sReward = sReward or {}
sReward.data = sReward.data or {}
sReward.data["referral"] = sReward.data["referral"] or {}
sReward.data["coupons"] = sReward.data["coupons"] or {}
sReward.data["rewards"] = sReward.data["rewards"] or {}
sReward.data["shop"] = sReward.data["shop"] or {}

sReward.couponNameToKey = sReward.couponNameToKey or {}

local sreward_menu

local white, textcolor, sidebarbttncolor, textcolor_min10, textcolor_min50, accentcolor, maincolor, maincolor_5, maincolor_7, maincolor_10, maincolor_15, successcolor, margin = Color(255,255,255), slib.getTheme("textcolor"), slib.getTheme("sidebarbttncolor"), slib.getTheme("textcolor", -10), slib.getTheme("textcolor", -50), slib.getTheme("accentcolor"), slib.getTheme("maincolor"), slib.getTheme("maincolor", 5), slib.getTheme("maincolor", 7), slib.getTheme("maincolor", 10), slib.getTheme("maincolor", 15), slib.getTheme("successcolor"), slib.getTheme("margin")
local failcolor = slib.getTheme("failcolor")

local maincolor_a100 = table.Copy(maincolor)
maincolor_a100.a = 100

local outline = Color(255,255,255,3)

local overlineFont = slib.createFont("Roboto", 13)

local hovercolor = slib.getTheme("hovercolor")
local reward_ico, task_ico, tokens_ico, referral_ico, copy_ico, coupon_ico, smiley_ico, buy_ico, admin_ico, return_ico = Material("sreward/giftbox.png", "smooth"), Material("sreward/checklist.png", "smooth"), Material("sreward/tokens.png", "smooth"), Material("sreward/affiliate.png", "smooth"), Material("sreward/copy.png", "smooth"), Material("sreward/coupon.png", "smooth"), Material("sreward/smiley.png", "smooth"), Material("sreward/buy.png", "smooth"), Material("sreward/admin.png", "smooth"), Material("sreward/back.png", "smooth")
local settings_ico, delete_ico = Material("sreward/gear.png", "smooth"), Material("sreward/delete.png", "smooth")


local function addIconButton(selcol, icon, func, parent)
    local bttn = vgui.Create("SButton", parent)
    bttn.DoClick = function()
        func()
    end

    local hovcol = table.Copy(selcol or white)
    hovcol.a = hovercolor.a

    bttn.Paint = function(s,w,h)
        local icosize = h * .7
        local wantedCol = s:IsHovered() and (selcol or white) or hovcol

        surface.SetDrawColor(slib.lerpColor(s, wantedCol))
        surface.SetMaterial(icon)
        surface.DrawTexturedRect(w * .5 - icosize * .5, h * .5 - icosize * .5, icosize, icosize)
    end

    return bttn
end

local function adminAction(ply, title, placeholder, func)
    local close = vgui.Create("SButton")
    close:MakePopup()
    close:SetSize(ScrW(), ScrH())
    close.Paint = function() end
    close.DoClick = function()
        close:Remove()
    end

    local popup = vgui.Create("SFrame", close)
    :SetSize(slib.getScaledSize(250, "x"),slib.getScaledSize(30 + 20 + 20 , "y") + (margin * 3))
    :setTitle(title)
    :Center()
    :addCloseButton()
    :MakePopup()
    :setBlur(true)

    local wide = popup:GetWide()

    popup.OnRemove = function()
        close:Remove()
    end

    local inputTypes = {
        ["int"] = "STextEntry",
        ["dropdown"] = "SDropDown"
    }

    popup.addInput = function(type)
        local element = vgui.Create(inputTypes[type], popup.frame)
        element:Dock(TOP)
        element:DockMargin(margin, margin, margin, 0)
        element:SetTall(slib.getScaledSize(20, "y"))
        element.placeholder = placeholder
        element.bg = maincolor_10

        if type == "int" then
            element:SetNumeric(true)
            element:SetRefreshRate(0)
        end

        element:SetPlaceholder(placeholder)

        return element
    end


    local submit = vgui.Create("SButton", popup.frame)
    submit:setTitle("Submit")
    submit:SetTall(slib.getScaledSize(20, "y"))
    submit:Dock(BOTTOM)
    submit:DockMargin(margin, margin, margin, margin)
    submit.bg = maincolor_10

    local spaceleft = popup.frame:GetTall() - submit:GetTall() - margin

    submit.DoClick = function()
        func(popup.value)
        popup:Remove()
    end

    return popup
end

local function doAdminAction(target, type, val)
    if !val or val == "" then return end
    net.Start("sR:NetworkingHandeler")
    net.WriteUInt(4,3)
    net.WriteBit(1)
    net.WriteUInt(target:EntIndex(), 16)
    net.WriteUInt(type, 2)
    net.WriteUInt(math.abs(tonumber(val)), 20)
    net.SendToServer()
end

local function addBasicsPage(parent)
    local canvas = vgui.Create("SScrollPanel", parent)
    canvas:Dock(FILL)
    canvas:GetCanvas():DockPadding(margin,0,margin,margin)

    local search = vgui.Create("SSearchBar", parent)
    search:Dock(TOP)
    search:DockMargin(margin,margin,margin,0)
    search:addIcon()
    search.bg = maincolor_7
    search.entry.onValueChange = function(newval)
        for k,v in pairs(canvas:GetCanvas():GetChildren()) do
            if !v.name then continue end
            if !string.find(string.lower(v.name), string.lower(newval)) then
                v:SetVisible(false)
            else
                v:SetVisible(true)
            end

            canvas:GetCanvas():InvalidateLayout(true)
        end
    end

    return canvas, search
end

local intToStorage = {
    [1] = "coupons",
    [2] = "shop"
}

local function networkAdminData(type, key)
    local data = sReward.data[intToStorage[type]][key] and table.Copy(sReward.data[intToStorage[type]][key]) or {}

    net.Start("sR:NetworkingHandeler")
    net.WriteUInt(4, 3)
    net.WriteBit(0)
    net.WriteUInt(type, 2)
    net.WriteString(util.TableToJSON(data))
    net.SendToServer()
end

local function addCoupon(parent, val, new)
    if !val then return end
    local key = sReward.couponNameToKey[val]
    
    local couponData = {name = val, data = {}}
    
    if new then
        key = table.insert(sReward.data["coupons"], couponData)
        sReward.couponNameToKey[val] = key
    end

    if parent[val] and IsValid(parent[val]) then return end

    local coupon = sReward.addMultibox(parent, {
        [1] = {
            title = slib.getLang("sreward", sReward.config["language"], "name"), 
            val = val,
            offset = 0
        },
        [2] = {
            title = slib.getLang("sreward", sReward.config["language"], "coupons"), 
            val = function() return sReward.data["coupons"][key] and sReward.data["coupons"][key].data and table.Count(sReward.data["coupons"][key].data) or 0 end,
            offset = 0.45
        }
    })

    coupon.addButton(slib.getLang("sreward", sReward.config["language"], "delete"), function()
        local popup = vgui.Create("SPopupBox")
        :setTitle(slib.getLang("sreward", sReward.config["language"], "are_you_sure"))
        :setBlur(true)
        :addChoise(slib.getLang("sreward", sReward.config["language"], "no"))
        :addChoise(slib.getLang("sreward", sReward.config["language"], "yes"), function()
            coupon:Remove()
            sReward.data["coupons"][key] = sReward.data["coupons"][key] or {}
            sReward.data["coupons"][key].delete = "confirmed"

            networkAdminData(1, key)
        end)
        :setText(slib.getLang("sreward", sReward.config["language"], "coupon_delete_confirm", val))
    end)

    coupon.addButton(slib.getLang("sreward", sReward.config["language"], "manage"), function()
        local close = vgui.Create("SButton")
        close:MakePopup()
        close:SetSize(ScrW(), ScrH())
        close.Paint = function(s,w,h) end
        close.DoClick = function()
            close:Remove()
        end

        local table_viewer = vgui.Create("STableViewer", close)
        :setTable(sReward.data["coupons"][key].data)
        :addEntry()

        table_viewer:addSearch(table_viewer.viewbox, table_viewer.viewer)
        :MakePopup()

        table_viewer.OnRemove = function()
            if table_viewer.modified then
                sReward.data["coupons"][val] = table_viewer.viewer.tbl
                networkAdminData(1, key)
            end

            if !IsValid(close) then return end
            close:Remove()
        end
    end)

    parent[val] = coupon

    if new then
        networkAdminData(1, key)
    end

    return coupon
end

local function addLabel(parent, txt)
    local font = slib.createFont("Roboto", 14)
    
    surface.SetFont(font)
    local height = select(2, surface.GetTextSize(txt))
    
    local label = vgui.Create("EditablePanel", parent)
    label:Dock(TOP)
    label:DockMargin(0,0,0,margin)
    label:SetTall(height)

    label.Paint = function(s,w,h)
        draw.SimpleText(txt, font, 0, h, textcolor_min50, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    end

    return label
end

local function manageStoreItem(id)
    local key = id
    local data = {name = "", imgurid = "", price = 0, reward = {}, enabled = true}
    local new = true

    if id then
        data = table.Copy(sReward.data["shop"][id])
        data.oldname = data.name
        new = false
    end

    if new then
        key = table.insert(sReward.data["shop"], data)
        data = sReward.data["shop"][key]
    end

    local close = vgui.Create("SButton")
    close:MakePopup()
    close:SetSize(ScrW(), ScrH())
    close.Paint = function(s,w,h) end
    close.DoClick = function()
        close:Remove()
    end

    local store_management = vgui.Create("SFrame", close)
    :SetSize(slib.getScaledSize(230, "x"), 0)
    :setTitle(slib.getLang("sreward", sReward.config["language"], "manage_item"))
    :Center()
    :addCloseButton()
    :MakePopup()
    :setBlur(true)

    store_management.OnRemove = function()
        if !IsValid(close) then return end
        close:Remove()
    end

    store_management.frame:DockPadding(margin, margin, margin, margin)

    addLabel(store_management.frame, slib.getLang("sreward", sReward.config["language"], "name"))

    local name = vgui.Create("STextEntry", store_management.frame)
    :Dock(TOP)
    :DockMargin(0,0,0,margin * 2)

    name.bg = maincolor_7
    name:SetPlaceholder(slib.getLang("sreward", sReward.config["language"], "insert_name"))

    name.onValueChange = function(val)
        data.name = val
    end

    if data.name ~= "" then
        name:SetValue(data.name)
    end

    addLabel(store_management.frame, slib.getLang("sreward", sReward.config["language"], "price"))

    local price = vgui.Create("STextEntry", store_management.frame)
    :Dock(TOP)
    :DockMargin(0,0,0,margin * 2)

    price.bg = maincolor_7
    price:SetPlaceholder(slib.getLang("sreward", sReward.config["language"], "insert_price"))
    price:SetNumeric(true)

    price.onValueChange = function(val)
        data.price = val
    end

    if data.price ~= "" then
        price:SetValue(data.price)
    end

    addLabel(store_management.frame, slib.getLang("sreward", sReward.config["language"], "imgur_id"))

    local imgurid = vgui.Create("STextEntry", store_management.frame)
    :Dock(TOP)
    :DockMargin(0,0,0,margin)

    imgurid.bg = maincolor_7
    imgurid:SetPlaceholder(slib.getLang("sreward", sReward.config["language"], "insert_imgur_id"))

    local imgur_id = ""

    imgurid.onValueChange = function(val)
        imgur_id = val
        data.imgurid = val
    end

    if data.imgurid ~= "" then
        imgurid:SetValue(data.imgurid)
        imgur_id = data.imgurid
    end

    local imgur_prev = vgui.Create("EditablePanel", store_management.frame)
    imgur_prev:Dock(TOP)
    imgur_prev:SetTall(slib.getScaledSize(90, "y"))
    imgur_prev.Paint = function(s,w,h)
        surface.SetDrawColor(maincolor_7)
        surface.DrawRect(0,0,w,h)
        
        local ico, loading = slib.ImgurGetMaterial(imgur_id)
        
        if !loading then
            surface.SetDrawColor(white)
            surface.SetMaterial(ico)
            surface.DrawTexturedRect(margin, margin, h - margin - margin, h - margin - margin)
        else
            s.rotation = s.rotation or 0
            s.rotation = s.rotation + 1

            local icosize = h * .6

            surface.SetDrawColor(white)
            surface.SetMaterial(ico)
            surface.DrawTexturedRectRotated(h * .5, h * .5, icosize, icosize, -s.rotation)
        end
    end

    addLabel(store_management.frame, slib.getLang("sreward", sReward.config["language"], "rewards")):DockMargin(0,margin * 2,0,margin)

    local edit_rewards = vgui.Create("SButton", store_management.frame)
    :Dock(TOP)
    :setTitle(slib.getLang("sreward", sReward.config["language"], "edit_rewards"))

    edit_rewards:SetTall(slib.getScaledSize(20, "y"))
    edit_rewards.font = slib.createFont("Roboto", 14)
    edit_rewards.bg = maincolor_7

    local suggestions = {}

    for k,v in pairs(sReward.Rewards) do
        suggestions[k] = true
    end

    edit_rewards.DoClick = function()
        local close = vgui.Create("SButton")
        close:MakePopup()
        close:SetSize(ScrW(), ScrH())
        close.Paint = function(s,w,h) end
        close.DoClick = function()
            close:Remove()
        end

        local table_viewer = vgui.Create("STableViewer", close)
        :setTable(data.reward)
        :addSuggestions(suggestions)
        :setCustomValues(slib.getLang("sreward", sReward.config["language"], "submit"), "Input type/amount")


        table_viewer:addSearch(table_viewer.viewbox, table_viewer.viewer)
        :addSearch(table_viewer.suggestionbox, table_viewer.suggestions)
        :MakePopup()
        :sortValues(table_viewer.viewer)
		:sortValues(table_viewer.suggestions)

        table_viewer.OnRemove = function()
            if table_viewer.modified then
                data.reward = table_viewer.viewer.tbl
            end

            if !IsValid(close) then return end
            close:Remove()
        end
    end

    local save_item = vgui.Create("SButton", store_management.frame)
    :Dock(TOP)
    :DockMargin(0,margin,0,0)
    :setTitle(slib.getLang("sreward", sReward.config["language"], "save"))

    save_item.DoClick = function()
        sReward.data["shop"][key] = data
        networkAdminData(2, key)
        store_management:Remove()
    end

    save_item:SetTall(slib.getScaledSize(20, "y"))
    save_item.font = slib.createFont("Roboto", 14)
    save_item.bg = maincolor_7

    for k,v in pairs(store_management.frame:GetChildren()) do
        local h = v:GetTall()
        local l, t, r, b = v:GetDockMargin()

        h = h + b

        store_management.frame:SetTall(store_management.frame:GetTall() + h + t)
    end

    store_management.frame:SetTall(store_management.frame:GetTall() + (margin * 2))

    store_management:SetTall(store_management.frame:GetTall() + store_management.topbarheight)

    store_management:Center()
end

sReward.openAdminmenu = function(sreward_menu)
    local x, y
    if IsValid(sreward_menu) then
        x, y = sreward_menu:GetPos()
        sreward_menu:Remove()
    end
    
    sreward_admin = vgui.Create("SFrame")
    :SetSize(slib.getScaledSize(670, "x"),slib.getScaledSize(520, "y"))
    :setTitle(slib.getLang("sreward", sReward.config["language"], "title_admin"))
    :Center()
    :addCloseButton()
    :MakePopup()
    :addTab(slib.getLang("sreward", sReward.config["language"], "general"), "sreward/tabs/general.png")
    :addTab(slib.getLang("sreward", sReward.config["language"], "shop"), "sreward/tabs/product.png")
    :addTab(slib.getLang("sreward", sReward.config["language"], "coupons"), "sreward/tabs/coupon.png")
    :setActiveTab(slib.getLang("sreward", sReward.config["language"], "general"))
    :SetPos(x, y)

    sreward_admin.OnRemove = function()
        if sreward_admin.changing then return end
        net.Start("sR:NetworkingHandeler")
        net.WriteUInt(0,3)
        net.WriteBool(false)
        net.SendToServer()
    end

    local topbttnsize = sreward_admin.close:GetTall()
    local bttngap = sreward_admin.topbar:GetTall() - topbttnsize

    sreward_admin.topbar:DockPadding(0,0,topbttnsize * .85,0)

    local returnbttn = vgui.Create("SButton", sreward_admin.topbar)
    returnbttn:Dock(RIGHT)
    returnbttn:DockMargin(0, bttngap / 2, margin / 2, bttngap / 2)
    returnbttn:SetWide(topbttnsize)
    
    returnbttn.DoClick = function()
        sreward_admin.changing = true
        sReward.openRewards(sreward_admin:GetPos())
        sreward_admin:Remove()
    end

    returnbttn.Paint = function(s,w,h)
        local icosize = h * .5
        local wantedCol = s:IsHovered() and white or hovercolor

        surface.SetDrawColor(slib.lerpColor(s, wantedCol))
        surface.SetMaterial(return_ico)
        surface.DrawTexturedRect(w * .5 - icosize * .5, h * .5 - icosize * .5, icosize, icosize)
    end

    local generalcanvas = addBasicsPage(sreward_admin.tab[slib.getLang("sreward", sReward.config["language"], "general")])
    local shopcanvas, shops_search = addBasicsPage(sreward_admin.tab[slib.getLang("sreward", sReward.config["language"], "shop")])
    local couponscanvas, coupons_search = addBasicsPage(sreward_admin.tab[slib.getLang("sreward", sReward.config["language"], "coupons")])

    local rewardNameIndex = {}

    for k,v in pairs(sReward.config["rewards"]) do
        rewardNameIndex[v.name] = k
    end

    for k,v in ipairs(player.GetAll()) do
        local ply = sReward.addMultibox(generalcanvas, {
            [1] = {
                title = slib.getLang("sreward", sReward.config["language"], "name"), 
                val = v:Nick(),
                offset = 0
            }
        })
        ply.addAvatar(v)
        ply.addButton(slib.getLang("sreward", sReward.config["language"], "take_tokens"), function()
            local val
            local popup = adminAction(v, slib.getLang("sreward", sReward.config["language"], "take_tokens"), slib.getLang("sreward", sReward.config["language"], "number"), function()
                doAdminAction(v, 2, val)
            end)
            local textbox = popup.addInput("int")
            textbox.onValueChange = function(newval)
                val = newval
            end
        end)

        ply.addButton(slib.getLang("sreward", sReward.config["language"], "give_tokens"), function()
            local val
            local popup = adminAction(v, slib.getLang("sreward", sReward.config["language"], "give_tokens"), slib.getLang("sreward", sReward.config["language"], "number"), function()
                doAdminAction(v, 1, val)
            end)

            local textbox = popup.addInput("int")

            textbox.onValueChange = function(newval)
                val = newval
            end
        end)

        ply.addButton(slib.getLang("sreward", sReward.config["language"], "give_reward"), function()
            local val
            local dropdown
            local popup = adminAction(v, slib.getLang("sreward", sReward.config["language"], "give_reward"), slib.getLang("sreward", sReward.config["language"], "select_reward"), function()
                doAdminAction(v, 3, rewardNameIndex[dropdown.title])
            end)
            
            dropdown = popup.addInput("dropdown") 

            for k,v in pairs(sReward.config["rewards"]) do
                dropdown:addOption(v.name)
            end
        end)

        ply.PaintOver = function(s,w,h)
            draw.SimpleText(slib.getLang("sreward", sReward.config["language"], "tokens"), overlineFont, w * .45, margin, textcolor_min50, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText(string.Comma(sReward.GetTokens(v)), slib.createFont("Roboto", 15), w * .45, h - margin, isFriend and successcolor or textcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        end
    end

    sreward_admin.RebuildCoupons = function()
        for k,v in ipairs(couponscanvas:GetCanvas():GetChildren()) do
            v:Remove()
        end

        for k,v in SortedPairs(sReward.data["coupons"]) do
            if !istable(v) then continue end
            local coupon = addCoupon(couponscanvas, v.name)
        end
    end

    sreward_admin.RebuildCoupons()

    local store_canvas
    sreward_admin.rebuildStore = function(str)
        table.sort(sReward.data["shop"], function(a, b) return (istable(a) and istable(b)) and tonumber(a and a.price or 0) > tonumber(b and b.price or 0) end)

        local shopcanvas = shopcanvas:GetCanvas()
        store_canvas = shopcanvas

        local iteration = 0
        local yiteration = 0
        for k,v in ipairs(shopcanvas:GetChildren()) do
            v:Remove()
        end

        for k,v in SortedPairs(sReward.data["shop"]) do
            if !istable(v) then continue end
            if str and !string.find(string.lower(v.name), string.lower(str)) then continue end
            yiteration = iteration > 2 and yiteration + 1 or yiteration
            iteration = iteration > 2 and 0 or iteration

            local item = sReward.addStoreItem(shopcanvas, sReward.data["shop"][k], yiteration, iteration)
            item.addButton(failcolor, delete_ico, function()
                local popup = vgui.Create("SPopupBox")
                :setTitle(slib.getLang("sreward", sReward.config["language"], "are_you_sure"))
                :setBlur(true)
                :addChoise(slib.getLang("sreward", sReward.config["language"], "no"))
                :addChoise(slib.getLang("sreward", sReward.config["language"], "yes"), function()
                    sReward.data["shop"][k] = sReward.data["shop"][k] or {}
                    sReward.data["shop"][k].delete = "confirmed"
        
                    item:Remove()
                    networkAdminData(2, k)
                end)
                :setText(slib.getLang("sreward", sReward.config["language"], "this_delete", item.data.name))
            end)
            item.addButton(nil, settings_ico, function()
                manageStoreItem(k)
            end, true)

            iteration = iteration + 1
        end

        ignoreResize = false
    end

    sreward_admin.rebuildStore()

    shopcanvas:GetCanvas().OnSizeChanged = function()
        local width = store_canvas:GetWide()
        if store_canvas.oldWide == width then return end
        store_canvas.oldWide = width

        if !IsValid(store_canvas) then return end
        for k,v in ipairs(store_canvas:GetChildren()) do
            v.InvalidateLayout()
        end
    end

    shops_search.entry.onValueChange = function(newval)
        sreward_admin.rebuildStore(newval)
    end


    local add_shopitem = vgui.Create("SButton", shops_search)
    add_shopitem:Dock(RIGHT)
    add_shopitem:DockMargin(margin * 2,margin * 2,margin * 2,margin * 2)
    add_shopitem:SetWide(shops_search:GetTall() - (margin * 4))
    add_shopitem.Paint = function(s,w,h)
        local icosize, width = h * .7, 2
        local centerPos = h * .15
        local wantedCol = s:IsHovered() and white or hovercolor

        surface.SetDrawColor(slib.lerpColor(s, wantedCol))
        surface.DrawRect(w * .5 - width * .5, 0, width, h)
        surface.DrawRect(0, h * .5 - width * .5, w, width)
    end

    add_shopitem.DoClick = function()
        manageStoreItem(id)
    end

    local add_coupon = vgui.Create("SButton", coupons_search)
    add_coupon:Dock(RIGHT)
    add_coupon:DockMargin(margin * 2,margin * 2,margin * 2,margin * 2)
    add_coupon:SetWide(coupons_search:GetTall() - (margin * 4))
    add_coupon.Paint = function(s,w,h)
        local icosize, width = h * .7, 2
        local centerPos = h * .15
        local wantedCol = s:IsHovered() and white or hovercolor

        surface.SetDrawColor(slib.lerpColor(s, wantedCol))
        surface.DrawRect(w * .5 - width * .5, 0, width, h)
        surface.DrawRect(0, h * .5 - width * .5, w, width)
    end

    add_coupon.DoClick = function()
        local val
        local popup = adminAction(v, slib.getLang("sreward", sReward.config["language"], "create_coupon"), slib.getLang("sreward", sReward.config["language"], "coupon_name"), function()
            addCoupon(couponscanvas, val, true)
        end)
        local textbox = popup.addInput("int")
        textbox:SetNumeric(false)
        textbox.onValueChange = function(newval)
            val = newval
        end
    end
end