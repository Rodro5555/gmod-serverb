if SERVER then return end
zmc = zmc or {}
zmc.Cookbook = zmc.Cookbook or {}
zmc.Cookbook.Interface = zmc.Cookbook.Interface or {}

net.Receive("zmc_cookbook_open", function(len)
    zclib.Debug_Net("zmc_cookbook_open", len)
    zmc.Cookbook.Interface.Open()
end)

local function HasComponets(ItemData)
    local HasComp = false
    for k,v in pairs(ItemData) do
        if zmc.Item.Components[k] then
            HasComp = true
            break
        end
    end
    return HasComp
end

function zmc.Cookbook.Interface.Open()
    zmc.vgui.Page(zmc.language["Cookbook"],function(main,top)

        local close_btn = zclib.vgui.ImageButton(940 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("close"),function()
            zmc_main_panel:Close()
        end,false)
        close_btn:Dock(RIGHT)
        close_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        close_btn.IconColor = zclib.colors["red01"]

        local seperator = zmc.vgui.AddSeperator(top)
        seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
        seperator:Dock(RIGHT)
        seperator:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)

        local SelectedFilter = zmc.language["All"]
        local function RebuildList(search_input)
            if not IsValid(main) then return end
            if IsValid(main.CookbookList) then main.CookbookList:Remove() end

            local list,scroll = zmc.vgui.List(main)
            scroll:DockMargin(50 * zclib.wM,10 * zclib.hM,50 * zclib.wM,10 * zclib.hM)
            scroll.Paint = function(s, w, h) draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"]) end
            main.CookbookList = scroll

            for id, data in pairs(zmc.config.Items) do
                if data == nil or data.mdl == nil then continue end

                if HasComponets(data) == false then continue end

                if data.edible and data.edible.health <= 0 then continue end

                if search_input ~= nil and search_input ~= "" and search_input ~= " " then
                    if string.find( data.name:lower(), search_input ) == nil then continue end
                else
                    if zmc.Item.Components[SelectedFilter] and data[SelectedFilter] == nil then continue end
                end

                local Item_pnl = zmc.vgui.Slot(data,function()

                    //IsSelected
                    return false
                end,function()

                    // CanSelect
                    return true
                end,function()

                    // OnSelect
                    zmc.Cookbook.Interface.LookUpItem(id)
                end,function()

                    // PreDraw
                end,function(w,h)

                    // PostDraw
                end)
                list:Add(Item_pnl)
                Item_pnl:SetSize(99 * zclib.wM, 99 * zclib.hM)
            end

            timer.Simple(0.01,function()
                if IsValid(list) and SelectedCookbook then
                    local children = list:GetChildren()
                    if children and children[SelectedCookbook] then
                        scroll:JumpToChild( children[SelectedCookbook] )
                    end
                end
            end)
        end

        zmc.vgui.ComponentSelection(top,SelectedFilter,function(data_val)
            SelectedFilter = data_val
            RebuildList()
        end)

        seperator = zmc.vgui.AddSeperator(top)
        seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
        seperator:Dock(RIGHT)
        seperator:DockMargin(0 * zclib.wM,0 * zclib.hM,10 * zclib.wM,0 * zclib.hM)

        zmc.vgui.SearchBox(top,function(val)
            RebuildList(val)
        end)

        RebuildList()
    end)
end

function zmc.Cookbook.Interface.LookUpItem(id)
    local ItemData = zmc.Item.GetData(id)

    zmc.vgui.Page(ItemData.name,function(main,top)

        local close_btn = zclib.vgui.ImageButton(940 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("close"),function()
            zmc_main_panel:Close()
        end,false)
        close_btn:Dock(RIGHT)
        close_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        close_btn.IconColor = zclib.colors["red01"]

        local seperator = zmc.vgui.AddSeperator(top)
        seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
        seperator:Dock(RIGHT)
        seperator:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)

        local back_btn = zclib.vgui.ImageButton(540 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("back"),function()
            zmc.Cookbook.Interface.Open()
        end,false)
        back_btn:Dock(RIGHT)
        back_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        back_btn.IconColor = zclib.colors["red01"]

        local list,scroll = zmc.vgui.List(main)
        scroll:DockMargin(50 * zclib.wM,10 * zclib.hM,50 * zclib.wM,10 * zclib.hM)
        scroll.Paint = function(s, w, h)
            draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
        end
        main.CookbookList = scroll

        local function AddSeperator()
            local itm = vgui.Create("DPanel", list)
            itm:SetSize(880 * zclib.wM, 5 * zclib.hM)
            itm.Paint = function(s, w, h)
                draw.RoundedBox(5,0, 0, w, h, zclib.colors["black_a100"])
                //draw.RoundedBox(5, 0, h - (5 * zclib.hM), w, 5 * zclib.hM, zclib.colors["black_a100"])
            end
            list:Add(itm)
        end

        local function AddArrow(parent,dock)
            local itm = vgui.Create("DPanel", parent)
            itm:Dock(dock)
            itm.Paint = function(s, w, h)
                //draw.RoundedBox(5, 0, 0, w, h, zclib.colors["red01"])
                draw.SimpleText(">", zclib.GetFont("zclib_font_giant"), w / 2, h / 2, zclib.colors["green01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end

        local function AddSection(desc,content)
            local itm = vgui.Create("DPanel", list)
            itm:SetSize(880 * zclib.wM, 230 * zclib.hM)
            itm.Paint = function(s, w, h)
                draw.SimpleText(desc, zclib.GetFont("zclib_font_medium"), 10 * zclib.wM, 0 * zclib.hM, zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                //draw.RoundedBox(5,0, 0, w, h, zclib.colors["red01"])

                //draw.RoundedBox(5, 0, h - (5 * zclib.hM), w, 5 * zclib.hM, zclib.colors["black_a100"])
            end
            list:Add(itm)

            local cnt = vgui.Create("DPanel", itm)
            cnt:Dock(FILL)
            cnt:DockMargin(0 * zclib.wM, 30 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
            cnt.Paint = function(s, w, h)

            end



            pcall(content,cnt,itm)
        end

        local function AddModelPanel(parent,mdl,dock,ang,fov)
            local mdl_pnl = zclib.vgui.ModelPanel({model = mdl,render = {Angles = ang,FOV = fov}})
            mdl_pnl:SetParent(parent)
            mdl_pnl:SetSize(180 * zclib.wM, 180 * zclib.hM)
            mdl_pnl:Dock(dock)
            mdl_pnl:DockMargin(10 * zclib.wM, 10 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
            mdl_pnl.PreDrawModel = function(s,ent)
                local w,h = s:GetWide(), s:GetTall()
                cam.Start2D()
                    draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a100"])
                cam.End2D()
            end
            return mdl_pnl
        end

        local function AddSlot(parent,itemid,dock)
            local data = zmc.Item.GetData(itemid)
            if data == nil then return end
            local itm_pnl = zmc.vgui.Slot(data,function()
                //IsSelected
                return false
            end,function()
                // CanSelect
                return true
            end,function()
                // OnSelect
                zmc.Cookbook.Interface.LookUpItem(itemid)
            end,function()
                // PreDraw
            end,function(w,h)
                // PostDraw
            end)
            itm_pnl:SetParent(parent)
            itm_pnl:SetSize(180 * zclib.wM, 180 * zclib.hM)
            itm_pnl:Dock(dock)
            itm_pnl:DockMargin(10 * zclib.wM, 10 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
            return itm_pnl
        end

        local function AddItems(parent,dock,itms)
            local itm = vgui.Create("DPanel", parent)
            itm:SetSize(300 * zclib.wM, 200 * zclib.hM)
            itm:Dock(dock)
            itm:DockMargin(10 * zclib.wM, 10 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM)
            itm.Paint = function(s, w, h)
                draw.RoundedBox(5,0, 0, w, h, zclib.colors["black_a100"])
            end

            local alist,ascroll = zmc.vgui.List(itm)
            alist:SetSpaceY( 5 * zclib.hM )
            alist:SetSpaceX( 5 * zclib.wM )
            ascroll:Dock(FILL)
            ascroll:DockMargin(0 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
            ascroll.Paint = function(s, w, h) end
            for k,v in pairs(itms) do
                local slot = AddSlot(list,v,NODOCK)
                slot:SetSize(66 * zclib.wM, 66 * zclib.hM)
                alist:Add(slot)
            end
        end

        if ItemData.fridge then
            AddSection(zmc.Item.Components["fridge"].desc,function(itm)
                AddSlot(itm,id,LEFT)
                AddArrow(itm,FILL)
                AddModelPanel(itm,"models/zerochain/props_kitchen/zmc_fridge.mdl",RIGHT,Angle(0,210,0),45)
            end)
            AddSeperator()
        end

        if ItemData.craft then
            AddSection(zmc.Item.Components["craft"].desc,function(itm)
                AddItems(itm,LEFT,ItemData.craft.items)
                AddArrow(itm,LEFT)
                AddModelPanel(itm,"models/zerochain/props_kitchen/zmc_worktable.mdl",FILL,Angle(0,0,0),45)
                AddSlot(itm,id,RIGHT)
                AddArrow(itm,RIGHT)
            end)
            AddSeperator()
        end

        if ItemData.cut then
            AddSection(zmc.Item.Components["cut"].desc,function(itm)
                AddSlot(itm,id,LEFT)
                AddArrow(itm,LEFT)
                AddModelPanel(itm,"models/zerochain/props_kitchen/zmc_worktable.mdl",FILL,Angle(0,210,0),45)
                AddItems(itm,RIGHT,ItemData.cut.items)
                AddArrow(itm,RIGHT)
            end)
            AddSeperator()
        end

        if ItemData.knead then
            AddSection(zmc.Item.Components["knead"].desc,function(itm)
                AddSlot(itm,id,LEFT)
                AddArrow(itm,LEFT)
                AddModelPanel(itm,"models/zerochain/props_kitchen/zmc_worktable.mdl",FILL,Angle(0,210,0),45)
                AddSlot(itm,ItemData.knead.item,RIGHT)
                AddArrow(itm,RIGHT)
            end)
            AddSeperator()
        end

        if ItemData.bake then
            AddSection(zmc.Item.Components["bake"].desc,function(itm)
                AddSlot(itm,id,LEFT)
                AddArrow(itm,LEFT)
                local mdlpnl = AddModelPanel(itm,"models/zerochain/props_kitchen/zmc_heater.mdl",FILL,Angle(0,210,0),60)
                mdlpnl.Entity:SetBodygroup(1,2)
                /*
                mdlpnl.PostDrawModel = function(s,ent)
                    local w,h = s:GetWide(), s:GetTall()
                    cam.Start2D()
                        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a100"])
                    cam.End2D()
                end
                */
                AddSlot(itm,ItemData.bake.item,RIGHT)
                AddArrow(itm,RIGHT)
            end)
            AddSeperator()
        end

        if ItemData.mix then
            AddSection(zmc.Item.Components["mix"].desc,function(itm)
                AddItems(itm,LEFT,ItemData.mix.items)
                AddArrow(itm,LEFT)
                AddModelPanel(itm,"models/zerochain/props_kitchen/zmc_mixer.mdl",FILL,Angle(0,0,0),45)
                AddSlot(itm,id,RIGHT)
                AddArrow(itm,RIGHT)
            end)
            AddSeperator()
        end

        if ItemData.grill then
            AddSection(zmc.Item.Components["grill"].desc,function(itm)
                AddSlot(itm,id,LEFT)
                AddArrow(itm,LEFT)
                local mdlpnl = AddModelPanel(itm,"models/zerochain/props_kitchen/zmc_heater.mdl",FILL,Angle(0,210,0),60)
                mdlpnl.Entity:SetBodygroup(1,1)
                AddSlot(itm,ItemData.grill.item,RIGHT)
                AddArrow(itm,RIGHT)
            end)
            AddSeperator()
        end

        if ItemData.wok then
            AddSection(zmc.Item.Components["wok"].desc,function(itm)
                AddItems(itm,LEFT,ItemData.wok.items)
                AddArrow(itm,LEFT)
                AddModelPanel(itm,"models/zerochain/props_kitchen/zmc_wok.mdl",FILL,Angle(0,0,0),45)
                AddSlot(itm,id,RIGHT)
                AddArrow(itm,RIGHT)
            end)
            AddSeperator()
        end

        if ItemData.soup then
            AddSection(zmc.Item.Components["wok"].desc,function(itm)
                AddItems(itm,LEFT,ItemData.soup.items)
                AddArrow(itm,LEFT)
                AddModelPanel(itm,"models/zerochain/props_kitchen/zmc_souppot.mdl",FILL,Angle(0,0,0),45)
                AddSlot(itm,id,RIGHT)
                AddArrow(itm,RIGHT)
            end)
            AddSeperator()
        end

        if ItemData.boil then
            AddSection(zmc.Item.Components["boil"].desc,function(itm)
                AddSlot(itm,id,LEFT)
                AddArrow(itm,LEFT)
                local mdlpnl = AddModelPanel(itm,"models/zerochain/props_kitchen/zmc_boilpot.mdl",FILL,Angle(0,210,0),60)
                mdlpnl.Entity:SetBodygroup(1,2)
                AddSlot(itm,ItemData.boil.item,RIGHT)
                AddArrow(itm,RIGHT)
            end)
            AddSeperator()
        end

        if ItemData.sell then
            AddSection(zmc.Item.Components["sell"].desc,function(itm,amain)
                amain:SetTall(30 * zclib.hM)
                itm:DockMargin(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
            end)
            AddSeperator()
        end

        if ItemData.edible then
            AddSection(zmc.Item.Components["edible"].desc,function(itm,amain)
                amain:SetTall(30 * zclib.hM)
                itm:DockMargin(0 * zclib.wM, 0 * zclib.hM, 0 * zclib.wM, 0 * zclib.hM)
            end)
            AddSeperator()
        end
    end)
end
