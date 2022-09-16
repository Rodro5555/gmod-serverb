sReward = sReward or {}
sReward.data = sReward.data or {}
sReward.data["referrals"] = sReward.data["referrals"] or {}
sReward.data["coupons"] = sReward.data["coupons"] or {}
sReward.data["rewards"] = sReward.data["rewards"] or {}
sReward.data["shop"] = sReward.data["shop"] or {}

sReward.couponNameToKey = sReward.couponNameToKey or {}

local sreward_menu

local white, textcolor, sidebarbttncolor, textcolor_min10, textcolor_min50, accentcolor, maincolor, maincolor_5, maincolor_7, maincolor_10, maincolor_12, maincolor_15, maincolor_90, successcolor, margin = Color(255,255,255), slib.getTheme("textcolor"), slib.getTheme("sidebarbttncolor"), slib.getTheme("textcolor", -10), slib.getTheme("textcolor", -50), slib.getTheme("accentcolor"), slib.getTheme("maincolor"), slib.getTheme("maincolor", 5), slib.getTheme("maincolor", 7), slib.getTheme("maincolor", 10), slib.getTheme("maincolor", 12), slib.getTheme("maincolor", 15), slib.getTheme("maincolor", 90), slib.getTheme("successcolor"), slib.getTheme("margin")
local failcolor = slib.getTheme("failcolor")

local maincolor_a100 = table.Copy(maincolor)
maincolor_a100.a = 100

local outline = Color(255,255,255,3)

local overlineFont = slib.createFont("Roboto", 13)

local hovercolor = slib.getTheme("hovercolor")
local reward_ico, task_ico, tokens_ico, referral_ico, copy_ico, coupon_ico, smiley_ico, buy_ico, admin_ico, return_ico = Material("sreward/giftbox.png", "smooth"), Material("sreward/checklist.png", "smooth"), Material("sreward/tokens.png", "smooth"), Material("sreward/referring.png", "smooth"), Material("sreward/copy.png", "smooth"), Material("sreward/coupon.png", "smooth"), Material("sreward/smiley.png", "smooth"), Material("sreward/buy.png", "smooth"), Material("sreward/admin.png", "smooth"), Material("sreward/back.png", "smooth")
local settings_ico, delete_ico = Material("sreward/gear.png", "smooth"), Material("sreward/delete.png", "smooth")
local accept_ico = Material("sreward/accept.png", "smooth")
local shadow_col = Color(0,0,0,100)

local friend_ico, foryou_ico = Material("sreward/friend.png", "smooth"), Material("sreward/for-you.png", "smooth")

sReward.GetTokens = function(ply)
    local sid = ply:SteamID()
    return sReward.data[sid] and sReward.data[sid].tokens or 0
end

local function addIconButton(selcol, icon, func, parent)
    local bttn = vgui.Create("SButton", parent)
    bttn:SetWide(bttn:GetTall())
    bttn.DoClick = function()
        func()
    end

    local hovcol = table.Copy(selcol or white)

    bttn.Paint = function(s,w,h)
        hovcol.a = bttn.hovopacity or hovercolor.a
        
        local icosize = h * .7
        local shadowsize = h * .71

        local wantedCol = s:IsHovered() and (selcol or white) or hovcol

        surface.SetDrawColor(slib.lerpColor(s, wantedCol))
        surface.SetMaterial(icon)
        surface.DrawTexturedRect(w * .5 - icosize * .5, h * .5 - icosize * .5, icosize, icosize)

        if s.shadow then
            surface.SetDrawColor(shadow_col)
            surface.SetMaterial(icon)
            surface.DrawTexturedRect(w * .5 - shadowsize * .5, h * .5 - shadowsize * .5, shadowsize, shadowsize)
        end
    end

    return bttn
end

local function checkRewards(data)
    if !data or table.IsEmpty(data.reward) then slib.notify(sReward.config["prefix"]..slib.getLang("sreward", sReward.config["language"], "no_rewards")) return end
    
    local close = vgui.Create("SButton")
    close:SetSize(ScrW(), ScrH())
    close:MakePopup()
    close.Paint = function(s,w,h) end

    close.DoClick = function()
        close:Remove()
    end

    local rewards = vgui.Create("SFrame", close)
    :SetSize(slib.getScaledSize(300, "x"),slib.getScaledSize(200, "y"))
    :setTitle(slib.getLang("sreward", sReward.config["language"], "rewards_title", data.name))
    :Center()
    :addCloseButton()
    :MakePopup()
    :setBlur(true)

    rewards.OnRemove = function()
        close:Remove()
    end

    local canvas = vgui.Create("SScrollPanel", rewards.frame)
    canvas:Dock(FILL)
    canvas:GetCanvas():DockPadding(margin,0,margin,margin)

    for k,v in pairs(data.reward) do
        local reward = vgui.Create("EditablePanel", canvas)
        reward:Dock(TOP)
        reward:DockMargin(0,margin,0,0)
        reward:SetTall(slib.getScaledSize(25, "y"))

        local icon = sReward.Rewards[k]

        reward.Paint = function(s,w,h)
            surface.SetDrawColor(maincolor_7)
            surface.DrawRect(0,0,w,h)

            local icosize, gap = h * .7, h * .15

            if icon then
                surface.SetDrawColor(white)
                surface.SetMaterial(icon)
                surface.DrawTexturedRect(gap, gap, icosize, icosize)
            end

            draw.SimpleText(slib.getLang("sreward", sReward.config["language"], k), slib.createFont("Roboto", 16), icon and (gap + gap + icosize + margin) or margin, h * .5, textcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(isnumber(v) and ("x"..string.Comma(v)) or v, slib.createFont("Roboto", 16), w - margin, h * .5, textcolor_min50, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end
    end
end

sReward.addStoreItem = function(canvas, data, row, column)
    local item = vgui.Create("EditablePanel", canvas)
    item.name = data.name
    item.data = data

    local showcase_size = 0

    item.InvalidateLayout = function()
        local addgap = math.floor(margin * 4 / 3)
        local shopitem_wide = math.ceil(((canvas:GetWide() - margin) / 3)) - addgap
        local shopitem_tall = shopitem_wide + slib.getScaledSize(31, "y")
        local fullwidth = shopitem_wide + margin
        showcase_size = shopitem_wide * .9

        item:SetSize(shopitem_wide, shopitem_tall)
        item:SetPos(margin + column * (shopitem_wide + addgap), margin + row * (shopitem_tall + margin))

        for k,v in ipairs(item:GetChildren()) do
            local showcase_size = item:GetWide()
            local gap = showcase_size * .05
            v:SetPos(v.right and (showcase_size - v:GetWide() - gap) or gap,gap)

            v.shadow = true
            v.hovopacity = 120
        end
    end

    item.InvalidateLayout()

    item.Paint = function(s,w,h)
        local gap = showcase_size * .05
        surface.SetDrawColor(maincolor_7)
        surface.DrawRect(0,0,w,h)

        surface.SetDrawColor(maincolor)
        surface.DrawRect(gap, h * .9, showcase_size, 1)
        
        local ico, loading = slib.ImgurGetMaterial(data.imgurid)
        
        if !loading then
            surface.SetDrawColor(white)
            surface.SetMaterial(ico)
            surface.DrawTexturedRect(gap, gap, showcase_size, showcase_size)
        else
            s.rotation = s.rotation or 0
            s.rotation = s.rotation + 1

            local icosize = showcase_size * .5

            surface.SetDrawColor(white)
            surface.SetMaterial(ico)
            surface.DrawTexturedRectRotated(w * .5, gap + showcase_size * .5, icosize, icosize, -s.rotation)
        end

        draw.SimpleText(data.name, slib.createFont("Roboto", 14), w * .5, gap + showcase_size + margin, textcolor_min10, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText(data.price.." TKN", slib.createFont("Roboto", 13), w * .5, h - margin, successcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    end

    local bttnsize = slib.getScaledSize(20, "y")
    item.addButton = function(selcol, icon, func, right)
        local showcase_size = item:GetWide()
        local gap = showcase_size * .05
        local bttn = addIconButton(selcol, icon, func, item)
        bttn:SetPos(right and (showcase_size - bttnsize - gap) or gap,gap)
        bttn:SetSize(bttnsize, bttnsize)
        bttn.right = right
    end

    return item
end

local topcolors = {
    [1] = Color(212, 175, 55),
    [2] = Color(211, 211, 211),
    [3] = Color(205, 127, 50)
}

sReward.addMultibox = function(parent, data)
    local panel = vgui.Create("EditablePanel", parent)
    panel:DockMargin(0,margin,0,0)
    panel:SetTall(slib.getScaledSize(33, "y"))
    panel:Dock(TOP)
    panel.name = data[1].val
    
    panel.Paint = function(s,w,h)
        local icosize = h * .6
        surface.SetDrawColor(maincolor_7)
        surface.DrawRect(0,0,w,h)

        local xoffset = s.avatar and h - 2 + margin or margin

        for k,v in ipairs(data) do
            panel.name = isfunction(v.val) and v.val() or v.val
            draw.SimpleText(v.title, overlineFont, xoffset + (w * v.offset), margin, textcolor_min50, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText(panel.name, slib.createFont("Roboto", 15), xoffset + (w * v.offset), h - margin, isFriend and successcolor or textcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        end
    end

    panel.addAvatar = function(ply)
        panel.avatar = vgui.Create( "AvatarImage", panel )
        panel.avatar:SetSize( panel:GetTall() - 4, panel:GetTall() - 4 )
        panel.avatar:SetPos( 2, 2 )
        panel.avatar:SetPlayer( ply, 64 )
    end

    panel.addButton = function(title, func)
        local bttn = vgui.Create("SButton", panel)
        bttn:Dock(RIGHT)
        bttn:DockMargin(0,margin + margin,margin,margin + margin)
        bttn:setTitle(title)
        bttn.DoClick = function()
            func(ply)
        end

        return bttn
    end

    return panel
end

local function createCouponBox(parent, title, code)
    local couponbox = vgui.Create("EditablePanel", parent)
    couponbox:Dock(TOP)
    couponbox:SetTall(slib.getScaledSize(50, "y"))
    couponbox.Paint = function(s,w,h)
        surface.SetDrawColor(maincolor_10)
        surface.DrawRect(0,0,w,h)

        draw.SimpleText(title, slib.createFont("Roboto", 16), margin, h * .25, topcolors[index] or textcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local codebox = vgui.Create("STextEntry", couponbox)
    codebox:AccentLineTop(true)
    codebox:SetValue(code)
    codebox:Dock(BOTTOM)
    codebox:SetDisabled(true)
    codebox.bg = maincolor_5

    local bttnsize = slib.getScaledSize(20, "y")
    local gap = slib.getScaledSize(2.5, "y")

    local copy = addIconButton(nil, copy_ico, function() SetClipboardText(code) end, couponbox)
    copy:Dock(RIGHT)
    copy:DockMargin(0, gap, gap, gap)
    copy:SetSize(bttnsize, bttnsize)

    local delete = addIconButton(failcolor, delete_ico, function()
        local popup = vgui.Create("SPopupBox")
        :setTitle(slib.getLang("sreward", sReward.config["language"], "are_you_sure"))
        :setBlur(true)
        :addChoise(slib.getLang("sreward", sReward.config["language"], "no"))
        :addChoise(slib.getLang("sreward", sReward.config["language"], "yes"), function()
            local data = file.Read("sreward/data/coupons.json", "DATA")
            if data then data = util.JSONToTable(data) else data = {} end
        
            data[code] = nil
        
            file.Write("sreward/data/coupons.json", util.TableToJSON(data))
    
            couponbox:Remove()
        end)
        :setText(slib.getLang("sreward", sReward.config["language"], "this_delete", title))
    end, couponbox)
    delete:Dock(RIGHT)
    delete:DockMargin(gap, gap, -gap, gap)
    delete:SetSize(bttnsize, bttnsize)

    return couponbox
end

local function receiveCoupon(title, code)
    local close = vgui.Create("SButton")
    close:SetSize(ScrW(), ScrH())
    close:MakePopup()
    close.Paint = function(s,w,h) end

    close.DoClick = function()
        close:Remove()
    end

    local coupon = vgui.Create("SFrame", close)
    :SetSize(slib.getScaledSize(260, "x"),slib.getScaledSize(150, "y"))
    :setTitle(slib.getLang("sreward", sReward.config["language"], "coupon_receive_title"))
    :Center()
    :addCloseButton()
    :MakePopup()
    :setBlur(true)

    local icosize = coupon.frame:GetTall() * .4
    local parse = markup.Parse("<colour="..textcolor_min10.r..","..textcolor_min10.g..","..textcolor_min10.b..","..textcolor_min10.a.."><font="..slib.createFont("Roboto", 16)..">"..slib.getLang("sreward", sReward.config["language"], "coupon_receive").."</font></colour>", coupon.frame:GetWide())
    coupon.frame.PaintOver = function(s,w,h)
        local x, y = w * .5 - icosize * .5, h * .3 - icosize * .5
        surface.SetDrawColor(successcolor)
        surface.SetMaterial(smiley_ico)
        surface.DrawTexturedRect(x, y, icosize, icosize)

        parse:Draw(w * .5, h * .75, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    coupon.OnRemove = function()
        close:Remove()
    end

    file.CreateDir("sreward/data")
    local data = file.Read("sreward/data/coupons.json", "DATA")
    if data then data = util.JSONToTable(data) else data = {} end

    data[code] = {title = title, index = table.Count(data)}

    file.Write("sreward/data/coupons.json", util.TableToJSON(data))

end

local function openCoupons()
    local data = file.Read("sreward/data/coupons.json", "DATA")
    if data then data = util.JSONToTable(data) else data = {} end

    if table.IsEmpty(data) then
        slib.notify(sReward.config["prefix"]..slib.getLang("sreward", sReward.config["language"], "no_coupons"))
    return end

    local close = vgui.Create("SButton")
    close:SetSize(ScrW(), ScrH())
    close:MakePopup()
    close.Paint = function(s,w,h) end

    close.DoClick = function()
        close:Remove()
    end

    local couponframe = vgui.Create("SFrame", close)
    :SetSize(slib.getScaledSize(300, "x"),slib.getScaledSize(285, "y"))
    :setTitle(slib.getLang("sreward", sReward.config["language"], "coupon_title"))
    :Center()
    :addCloseButton()
    :MakePopup()
    :setBlur(true)

    local scroller = vgui.Create("SScrollPanel", couponframe.frame)
    scroller:Dock(FILL)
    scroller:GetCanvas():DockPadding(margin,0,margin,margin)

    for code, v in pairs(data) do
        local couponbox = createCouponBox(scroller, v.title, code)
        couponbox:DockMargin(0,margin,0,0)
        couponbox:SetZPos(v.index)
    end

    couponframe.OnRemove = function()
        close:Remove()
    end
end

sReward.openRewards = function(x, y)
    net.Start("sR:NetworkingHandeler")
    net.WriteUInt(0,3)
    net.WriteBool(true)
    net.SendToServer()

    sreward_menu = vgui.Create("SFrame")
    :SetSize(slib.getScaledSize(670, "x"),slib.getScaledSize(520, "y"))
    :setTitle(slib.getLang("sreward", sReward.config["language"], "main_title"))
    :Center()
    :addCloseButton()
    :MakePopup()
    

    if sReward.config["enabled_tabs"]["tasks"] then
        sreward_menu:addTab(slib.getLang("sreward", sReward.config["language"], "tasks"), "sreward/tabs/tasks.png")
    end

    if sReward.config["enabled_tabs"]["referral"] then
        sreward_menu:addTab(slib.getLang("sreward", sReward.config["language"], "referral"), "sreward/tabs/referral.png")
    end

    if sReward.config["enabled_tabs"]["shop"] then
        sreward_menu:addTab(slib.getLang("sreward", sReward.config["language"], "shop"), "sreward/tabs/shop.png")
    end

    if sReward.config["enabled_tabs"]["leaderboard"] then
        sreward_menu:addTab(slib.getLang("sreward", sReward.config["language"], "leaderboard"), "sreward/tabs/leaderboard.png")
    end

    sreward_menu:setActiveTab()
    
    if isnumber(x) and isnumber(y) then
        sreward_menu:SetPos(x,y)
    end

    sreward_menu.OnRemove = function()
        if sreward_menu.changing then return end
        net.Start("sR:NetworkingHandeler")
        net.WriteUInt(0,3)
        net.WriteBool(false)
        net.SendToServer()
    end

    local topbttnsize = sreward_menu.close:GetTall()
    local bttngap = sreward_menu.topbar:GetTall() - topbttnsize

    sreward_menu.topbar:DockPadding(0,0,topbttnsize * .85,0)

    if sReward.config["permissions"][LocalPlayer():GetUserGroup()] then
        local admin = vgui.Create("SButton", sreward_menu.topbar)
        admin:Dock(RIGHT)
        admin:DockMargin(-3, bttngap / 2, margin / 2, bttngap / 2)
        admin:SetWide(topbttnsize)
        
        admin.DoClick = function()
            sreward_menu.changing = true
            sReward.openAdminmenu(sreward_menu)
        end
    
        admin.Paint = function(s,w,h)
            local icosize = h * .6
            local wantedCol = s:IsHovered() and white or hovercolor
    
            surface.SetDrawColor(slib.lerpColor(s, wantedCol))
            surface.SetMaterial(admin_ico)
            surface.DrawTexturedRect(w * .5 - icosize * .5, h * .5 - icosize * .5, icosize, icosize)
        end
    end

    local coupons = vgui.Create("SButton", sreward_menu.topbar)
    coupons:Dock(RIGHT)
    coupons:DockMargin(0, bttngap / 2, margin / 2, bttngap / 2)
    coupons:SetWide(topbttnsize)
    
    coupons.DoClick = function()
        openCoupons()
    end

    coupons.Paint = function(s,w,h)
        local icosize = h * .7
        local wantedCol = s:IsHovered() and white or hovercolor

        surface.SetDrawColor(slib.lerpColor(s, wantedCol))
        surface.SetMaterial(coupon_ico)
        surface.DrawTexturedRect(w * .5 - icosize * .5, h * .5 - icosize * .5, icosize, icosize)
    end

    -- Referral tab
    if IsValid(sreward_menu.tab[slib.getLang("sreward", sReward.config["language"], "referral")]) then
        local gradient_d = surface.GetTextureID("vgui/gradient_down")
        local podium = vgui.Create("EditablePanel", sreward_menu.tab[slib.getLang("sreward", sReward.config["language"], "referral")])
        podium:Dock(FILL)
        podium:DockMargin(margin, margin, margin, margin)
        podium:SetTall(sreward_menu.tab[slib.getLang("sreward", sReward.config["language"], "referral")]:GetTall() * .69)
        podium.Paint = function(s,w,h)
            local data = sReward.data["referral_top3"]

            local first, second, third = data and data[1] and data[1].amount or 0, data and data[2] and data[2].amount or 0, data and data[3] and data[3].amount or 0

            surface.SetDrawColor(maincolor_7)
            surface.DrawRect(0,0,w,h)

            draw.SimpleText(slib.getLang("sreward", sReward.config["language"], "top_3"), slib.createFont("Roboto", 24), w * .5, margin, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            
            if first <= 0 then
                draw.SimpleText(slib.getLang("sreward", sReward.config["language"], "no_data"), slib.createFont("Roboto", 18), w * .5, h * .5, textcolor_min50, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            return end

            local wide = w * .2
            local medal_size = wide * .3
            local max_h = h * .8
            local gap = w * .1
            local second_p, third_p = second / first, third / first

            surface.SetDrawColor(topcolors[2])
            surface.SetTexture(gradient_d)
            surface.DrawTexturedRect(w * .5 - wide * 1.5 - gap,h - max_h * second_p - 4,wide,max_h * second_p)
            surface.DrawOutlinedRect(w * .5 - wide * 1.5 - gap,h - max_h * second_p - 4,wide,max_h * second_p)

            surface.SetDrawColor(topcolors[1])
            surface.SetTexture(gradient_d)
            surface.DrawTexturedRect(w * .5 - wide * .5,h - max_h - 4,wide,max_h)
            surface.DrawOutlinedRect(w * .5 - wide * .5,h - max_h - 4,wide,max_h)

            surface.SetDrawColor(topcolors[3])
            surface.SetTexture(gradient_d)
            surface.DrawTexturedRect(w * .5 + wide * .5 + gap,h - max_h * third_p - 4,wide,max_h * third_p)
            surface.DrawOutlinedRect(w * .5 + wide * .5 + gap,h - max_h * third_p - 4,wide,max_h * third_p)

            local score_h = slib.getScaledSize(18, "y")

            draw.SimpleText(first, slib.createFont("Roboto", 19), w * .5, h - max_h - margin * 2, topcolors[1], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
            draw.SimpleText(second, slib.createFont("Roboto", 19), w * .5 - wide - gap, h - max_h * second_p - margin * 2, topcolors[2], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
            draw.SimpleText(third, slib.createFont("Roboto", 19), w * .5 + wide + gap, h - max_h * third_p - margin * 2, topcolors[3], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

            
            draw.SimpleText(slib.findName(data[1].sid64), slib.createFont("Roboto", 19), w * .5, h - max_h - margin * 2 - score_h, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
            draw.SimpleText(data[2] and slib.findName(data[2].sid64) or "N/A", slib.createFont("Roboto", 19), w * .5 - wide - gap, h - max_h * second_p - margin * 2 - score_h, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
            draw.SimpleText(data[3] and slib.findName(data[3].sid64) or "N/A", slib.createFont("Roboto", 19), w * .5 + wide + gap, h - max_h * third_p - margin * 2 - score_h, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        end

        local referral_info = vgui.Create("EditablePanel", sreward_menu.tab[slib.getLang("sreward", sReward.config["language"], "referral")])
        referral_info:SetTall(slib.getScaledSize(92, "y"))
        referral_info:Dock(BOTTOM)

        local rewardbttn_h = referral_info:GetTall() * .6

        local box_w = (sreward_menu.tab[slib.getLang("sreward", sReward.config["language"], "referral")]:GetWide() - margin * 2) * .5

        local referral_rewards = vgui.Create("EditablePanel", referral_info)
        referral_rewards:Dock(LEFT)
        referral_rewards:DockMargin(margin,0,margin * .5,margin)
        referral_rewards:DockPadding(0,slib.getScaledSize(10, "y"), 0,0)
        referral_rewards:SetWide(box_w)
        referral_rewards.Paint = function(s,w,h)
            surface.SetDrawColor(maincolor_7)
            surface.DrawRect(0,0,w,h)

            draw.SimpleText(slib.getLang("sreward", sReward.config["language"], "rewards"), slib.createFont("Roboto", 19), w * .5, margin, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        end

        local rewardBtn_size = box_w * .3
        local width_left = box_w - (rewardBtn_size * 2)

        local referrer_reward = vgui.Create("SButton", referral_rewards)
        referrer_reward:Dock(LEFT)
        referrer_reward:DockMargin(width_left * .33, 0, width_left * .33,0)
        referrer_reward:SetWide(rewardBtn_size)
        referrer_reward.col = table.Copy(color_white)
        referrer_reward.Paint = function(s,w,h)
            local ico_size = h * .45
            s.col.a = slib.lerpNum(s, s:IsHovered() and 30 or 255)
            surface.SetDrawColor(s.col)
            surface.SetMaterial(foryou_ico)
            surface.DrawTexturedRect(w * .5 - ico_size * .5,h * .5 - ico_size * .5,ico_size,ico_size)

            draw.SimpleText(slib.getLang("sreward", sReward.config["language"], "you"), slib.createFont("Roboto", 16), w * .5, h - margin, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        end

        referrer_reward.DoClick = function()
            checkRewards({name = slib.getLang("sreward", sReward.config["language"], "referral"),reward = sReward.config["give_referral_reward"]})
        end

        local referred_reward = vgui.Create("SButton", referral_rewards)
        referred_reward:Dock(LEFT)
        referred_reward:SetWide(rewardBtn_size)
        referred_reward.col = table.Copy(color_white)
        referred_reward.Paint = function(s,w,h)
            local ico_size = h * .45
            s.col.a = slib.lerpNum(s, s:IsHovered() and 30 or 255)
            surface.SetDrawColor(s.col)
            surface.SetMaterial(friend_ico)
            surface.DrawTexturedRect(w * .5 - ico_size * .5,h * .5 - ico_size * .5,ico_size,ico_size)

            draw.SimpleText(slib.getLang("sreward", sReward.config["language"], "friend"), slib.createFont("Roboto", 16), w * .5, h - margin, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        end

        referred_reward.DoClick = function()
            checkRewards({name = slib.getLang("sreward", sReward.config["language"], "referral"),reward = sReward.config["receive_referral_reward"]})
        end

        local box_size = referral_info:GetTall() * .28

        local referral_font = slib.createFont("Roboto", 17)

        local referral_setting = vgui.Create("EditablePanel", referral_info)
        referral_setting:Dock(LEFT)
        referral_setting:DockMargin(margin * .5,0,0,margin)
        referral_setting:SetWide(box_w)

        local sid = LocalPlayer():SteamID()

        referral_setting.Paint = function(s,w,h)
            local icosize, gap = h * .28

            surface.SetDrawColor(maincolor_7)
            surface.DrawRect(0,0,w,h)

            local txt = (sReward.data[sid] and sReward.data[sid]["total_referrals"] or 0).." "..slib.getLang("sreward", sReward.config["language"], "referrals")

            surface.SetFont(referral_font)
            local txt_w = surface.GetTextSize(txt)

            surface.SetDrawColor(white)
            surface.SetMaterial(referral_ico)
            surface.DrawTexturedRect(w * .5 - icosize * .5 - txt_w * .5 - (margin * .5), margin, icosize, icosize)
        
            draw.SimpleText(txt, referral_font, w * .5 + icosize * .5 + (margin * .5), icosize * .5 + margin, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        
            draw.SimpleText(slib.getLang("sreward", sReward.config["language"], "referr_with_code"), referral_font, w * .5, h - margin - box_size - margin, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        end

        local referral_id = vgui.Create("STextEntry", referral_setting)
        referral_id:Dock(BOTTOM)
        referral_id:DockMargin(margin,0, margin, margin)
        referral_id:SetTall(box_size)
        referral_id:SetPlaceholder("SteamID64")
        referral_id.bg = maincolor_15

        local referr_id = vgui.Create("SButton", referral_id)
        referr_id:Dock(RIGHT)
        referr_id:SetWide(box_size)
        referr_id.col = table.Copy(color_white)
        referr_id.Paint = function(s,w,h)
            local ico_size = h * .5
            s.col.a = slib.lerpNum(s, s:IsHovered() and 255 or 30)

            surface.SetDrawColor(s.col)
            surface.SetMaterial(accept_ico)
            surface.DrawTexturedRect(w * .5 - ico_size * .5,h * .5 - ico_size * .5,ico_size,ico_size)
        end

        referr_id.DoClick = function()
            local sid64 = referral_id:GetText()
            if !sid64 or #sid64 ~= 17 or !isnumber(tonumber(sid64)) then slib.notify(sReward.config["prefix"]..slib.getLang("sreward", sReward.config["language"], "invalid_sid64")) return end
            if sid64 == LocalPlayer():SteamID64() then slib.notify(sReward.config["prefix"]..slib.getLang("sreward", sReward.config["language"], "cannot_referr_yourself")) return end

            net.Start("sR:NetworkingHandeler")
            net.WriteUInt(2,3)
            net.WriteString(sid64)
            net.SendToServer()
        end
    end

    if IsValid(sreward_menu.tab[slib.getLang("sreward", sReward.config["language"], "shop")]) then
        local shop_stats = vgui.Create("EditablePanel", sreward_menu.tab[slib.getLang("sreward", sReward.config["language"], "shop")])
        shop_stats:Dock(TOP)
        shop_stats:SetTall(slib.getScaledSize(25, "y"))
        shop_stats:SetWide(sreward_menu.tab[slib.getLang("sreward", sReward.config["language"], "shop")]:GetWide())
        shop_stats.Paint = function(s,w,h)
            local icosize, gap = h * .7, h * .15

            surface.SetDrawColor(maincolor_10)
            surface.DrawRect(0,0,w,h)

            surface.SetDrawColor(white)
            surface.SetMaterial(tokens_ico)
            surface.DrawTexturedRect(gap, gap, icosize, icosize)

            draw.SimpleText(string.Comma(sReward.GetTokens(LocalPlayer())).." "..slib.getLang("sreward", sReward.config["language"], "tokens"), slib.createFont("Roboto", 16), gap + icosize + margin, h * .5, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        local shopcanvas = vgui.Create("SScrollPanel", sreward_menu.tab[slib.getLang("sreward", sReward.config["language"], "shop")])
        shopcanvas:Dock(FILL)
        local innercanvasshop = shopcanvas:GetCanvas()
        innercanvasshop:DockPadding(margin,0,margin,margin)

        local shop_search = vgui.Create("SSearchBar", shop_stats)
        shop_search:Dock(RIGHT)
        shop_search:SetWide(shop_stats:GetWide() * .5)
        shop_search:DockMargin(0,0,0,0)
        shop_search.bg = maincolor_15
        shop_search:addIcon()

        local store_canvas

        sreward_menu.rebuildStore = function(str)
            local addgap = margin * 1.33333333333
            local shopitem_wide = math.ceil((innercanvasshop:GetWide() / 3)) - addgap
            local shopitem_tall = shopitem_wide + slib.getScaledSize(31, "y")
            local fullwidth = shopitem_wide + margin

            store_canvas = innercanvasshop

            local iteration = 0
            local yiteration = 0
            for k,v in pairs(innercanvasshop:GetChildren()) do
                v:Remove()
            end

            local fulltbl = table.Copy(sReward.config["shop"])
            for k,v in SortedPairs(fulltbl) do fulltbl[k].id = k end
            for k,v in SortedPairs(sReward.data["shop"]) do if !istable(v) then continue end table.insert(fulltbl, v) end
            
            table.sort(fulltbl, function(a, b) return tonumber(a.price) > tonumber(b.price) end)

            for k,v in SortedPairs(fulltbl) do
                if str and !string.find(string.lower(v.name), string.lower(str)) or !v.enabled then continue end
                yiteration = iteration > 2 and yiteration + 1 or yiteration
                iteration = iteration > 2 and 0 or iteration

                local item = sReward.addStoreItem(innercanvasshop, v, yiteration, iteration)
                item.addButton(nil, reward_ico, function() checkRewards(item.data) end)
                item.addButton(nil, buy_ico, function()
                    local popup = vgui.Create("SPopupBox")
                    :setTitle(slib.getLang("sreward", sReward.config["language"], "are_you_sure"))
                    :setBlur(true)
                    :addChoise(slib.getLang("sreward", sReward.config["language"], "no"))
                    :addChoise(slib.getLang("sreward", sReward.config["language"], "yes"), function()
                        net.Start("sR:NetworkingHandeler")
                        net.WriteUInt(3,3)
                        net.WriteUInt(v.svid or v.id, 6)
                        net.WriteBool(tobool(v.svid))
                        net.SendToServer()
                    end)
                    :setText(slib.getLang("sreward", sReward.config["language"], "this_will_cost", item.data.name, item.data.price))
                end, true)

                item.InvalidateLayout()

                iteration = iteration + 1
            end
        end

        innercanvasshop.OnSizeChanged = function()
            local width = innercanvasshop:GetWide()
            if innercanvasshop.oldWide == width then return end
            innercanvasshop.oldWide = width

            if !IsValid(store_canvas) then return end
            for k,v in ipairs(store_canvas:GetChildren()) do
                v.InvalidateLayout()
            end  
        end

        sreward_menu.rebuildStore()

        shop_search.entry.onValueChange = function(newval)
            sreward_menu.rebuildStore(newval)
        end
    end

    if IsValid(sreward_menu.tab[slib.getLang("sreward", sReward.config["language"], "tasks")]) then
        local taskscanvas = vgui.Create("SScrollPanel", sreward_menu.tab[slib.getLang("sreward", sReward.config["language"], "tasks")])
        taskscanvas:Dock(FILL)
        taskscanvas:GetCanvas():DockPadding(margin,0,margin,margin)

        for k,v in ipairs(sReward.config["rewards"]) do
            local data = sReward.config["rewards"][k]
            
            local task = sReward.addMultibox(taskscanvas, {
                [1] = {
                    title = slib.getLang("sreward", sReward.config["language"], "name"),
                    val = data.name,
                    offset = 0
                },
                [2] = {
                    title = slib.getLang("sreward", sReward.config["language"], "uses"),
                    val = function() return (!data.maxuse or data.maxuse <= 0 and "∞") or (sReward.data["rewards"][k] and sReward.data["rewards"][k].used or 0).."/"..data.maxuse end,
                    offset = 0.3
                },
                [3] = {
                    title = slib.getLang("sreward", sReward.config["language"], "task"),
                    val = "",
                    offset = 0.6
                }
            })

            local verify = task.addButton(slib.getLang("sreward", sReward.config["language"], "verify"), function()
                if data.maxuse and data.maxuse > 0 and (sReward.data["rewards"][k] and sReward.data["rewards"][k].used or 0) >= data.maxuse then
                    slib.notify(sReward.config["prefix"]..slib.getLang("sreward", sReward.config["language"], "max_use_reached"))
                return end 
                
                if data.cooldown and data.cooldown > 0 and os.time() < ((sReward.data["rewards"][k] and sReward.data["rewards"][k].cd or -data.cooldown) + data.cooldown) then
                    slib.notify(sReward.config["prefix"]..slib.getLang("sreward", sReward.config["language"], "on_cooldown", math.Round((sReward.data["rewards"][k].cd + data.cooldown) - os.time(), 1)))
                return end 
        
                net.Start("sR:NetworkingHandeler")
                net.WriteUInt(1,3)
                net.WriteUInt(k, 4)
                net.SendToServer()
            end)

            local nextThink
            verify.Think = function()
                if nextThink and nextThink > CurTime() then return end
        
                local title
        
                if data.cooldown and data.cooldown > 0 and os.time() < ((sReward.data["rewards"][k] and sReward.data["rewards"][k].cd or -data.cooldown) + data.cooldown) then
                    local timeleft = math.Round((sReward.data["rewards"][k].cd + data.cooldown) - os.time(), 1)
                    local hours = math.floor( timeleft / 3600 )
                    local minutes = math.floor( ( timeleft / 60 ) % 60 )
                    local seconds = math.floor( timeleft % 60 )
        
                    title = string.format("%2i:%02i:%02i", hours, minutes, seconds)
                end
        
                if data.maxuse and data.maxuse > 0 and (sReward.data["rewards"][k] and sReward.data["rewards"][k].used or 0) >= data.maxuse then
                    title = slib.getLang("sreward", sReward.config["language"], "used")
                end
                
                if title then
                    verify:SetMouseInputEnabled(!title)
                    verify:setTitle(title)
                end
        
                nextThink = CurTime() + 1
            end

            local gap = margin * 2.3

            local rewards = addIconButton(nil, reward_ico, function() checkRewards(data) end, task)
            rewards:Dock(RIGHT)
            rewards:DockMargin(gap, gap, margin, gap)

            local tasks = addIconButton(nil, task_ico, function()
                if !data.instructionFunc then return end
                data.instructionFunc()
            end, task)
            tasks:Dock(LEFT)
            tasks:DockMargin(task:GetWide() * .6 + margin, gap * 2, margin, 0)
            
            tasks.PaintOver = function(s,w,h)    
                if s:IsHovered() and !IsValid(s.tooltip) then
                    s.tooltip = slib.drawTooltip(data.instruction, s, 1)
                end
            end

            task.OnSizeChanged = function()
                tasks:DockMargin(task:GetWide() * .6 + margin, gap * 2, margin, 0)
            end
        end
    end

    if IsValid(sreward_menu.tab[slib.getLang("sreward", sReward.config["language"], "leaderboard")]) then
        local leaderboardcanvas = vgui.Create("SScrollPanel", sreward_menu.tab[slib.getLang("sreward", sReward.config["language"], "leaderboard")])
        leaderboardcanvas:Dock(FILL)
        leaderboardcanvas:GetCanvas():DockPadding(margin,0,margin,margin)

        sreward_menu.RebuildLeaderboard = function()
            for k,v in pairs(leaderboardcanvas:GetCanvas():GetChildren()) do
                v:Remove()
            end

            if sReward.data["leaderboard"] then
                for k,v in ipairs(sReward.data["leaderboard"]) do
                    local ply = sReward.addMultibox(leaderboardcanvas, {
                        [1] = {
                            title = slib.getLang("sreward", sReward.config["language"], "name"),
                            val = function() return slib.findName(v.sid64) end,
                            offset = 0
                        },
                        [2] = {
                            title = slib.getLang("sreward", sReward.config["language"], "total_tokens"),
                            val = v.tokens,
                            offset = 0.4
                        }
                    })

                    ply.PaintOver = function(s,w,h)
                        draw.SimpleText("#"..k, slib.createFont("Roboto", 18), w - margin, h * .5, topcolors[k] or textcolor_min50, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                    end
                end
            end
        end

        sreward_menu.RebuildLeaderboard()
    end
end

concommand.Add("sreward_menu", sReward.openRewards)

local intToString = {
    [1] = {id = "rewards", instructions = {["jsontable"] = true}},
    [2] = {id = "total_referrals", instructions = {["player"] = true, ["int"] = true, ["plydata"] = true}},
    [3] = {id = "leaderboard", instructions = {["jsontable"] = true}, func = function()
        if IsValid(sreward_menu) and sreward_menu.RebuildLeaderboard then
            sreward_menu.RebuildLeaderboard()
        end
    end},
    [4] = {id = "tokens", instructions = {["player"] = true, ["int"] = true, ["plydata"] = true}},
    [5] = {id = "coupons", instructions = {["jsontable"] = true}, func = function(data)
        for k,v in pairs(sReward.data["coupons"]) do
            if !istable(v) then continue end
            sReward.couponNameToKey[v.name] = k
        end

        if IsValid(sreward_admin) and sreward_admin.RebuildCoupons then
            sreward_admin.RebuildCoupons()
        end
    end},
    [6] = {id = "shop", instructions = {["jsontable"] = true}, func = function()
        if IsValid(sreward_admin) and sreward_admin.rebuildStore then
            sreward_admin.rebuildStore()
        end

        if IsValid(sreward_menu) and sreward_menu.rebuildStore then
            sreward_menu.rebuildStore()
        end
    end},
    [7] = {id = "referral_top3", instructions = {["jsontable"] = true}}
}

net.Receive("sR:NetworkingHandeler", function()
    local action = net.ReadUInt(2)

    if action == 1 then
        local type = net.ReadUInt(4)
        local str = intToString[type]
        if !str or !str.id then return end

        local val
        local structure = {str.id}

        if str.instructions then
            if str.instructions["key"] then
                structure[2] = net.ReadUInt(4)
            end
    
            if str.instructions["player"] then
                local ply = net.ReadUInt(16)
                if !ply then return end
                ply = Entity(ply)
    
                local sid = IsValid(ply) and ply:SteamID()
    
                if !sid then return end

                if str.instructions["plydata"] then
                    structure[1] = sid
                    structure[2] = str.id
                end
            end
    
            if str.instructions["jsontable"] then
                val = util.JSONToTable(net.ReadString())
            end
    
            if str.instructions["int"] then
                val = net.ReadUInt(32)
            end
        end

        local lastStep = sReward.data
        
        local tblCount = #structure
        for i=1, tblCount do
            local key = structure[i]
            local isEnd = i >= tblCount
            lastStep[key] = isEnd and val or lastStep[key] or {}

            lastStep = !isEnd and lastStep[key]
        end
    
        if isfunction(str.func) then
            str.func(val)
        end
    elseif action == 2 then
        local data = net.ReadString()
        data = util.JSONToTable(data)

        receiveCoupon(data.title, data.code)
    end
end)