if SERVER then return end
zmc = zmc or {}
zmc.Worktable = zmc.Worktable or {}

net.Receive("zmc_Worktable_open", function(len)
    zclib.Debug_Net("zmc_Worktable_open", len)

    zmc.vgui.ActiveEntity = net.ReadEntity()

    zmc.Worktable.OpenInterface()
end)

function zmc.Worktable.OpenInterface()
    zmc.vgui.Page(zmc.language["Worktable"],function(main,top)

        //local CanProcess = false
        local CanCraft = false
        main.OnInventoryChanged = function()

            // Do we already have the inventory build?
            if not IsValid(main.Inventory) then return end


            // Update items
            main.Inventory:Update(zmc.Inventory.Get(zmc.vgui.ActiveEntity))

            if IsValid(zmc.vgui.ActiveEntity) and zmc.vgui.ActiveEntity.CraftItem then
                local itemData = zmc.Item.GetData(zmc.vgui.ActiveEntity.CraftItem)
                if itemData == nil then return end

                CanCraft = table.IsEmpty(zmc.Inventory.GetMissing(zmc.vgui.ActiveEntity,itemData.craft.items))
            end
        end

        local close_btn = zclib.vgui.ImageButton(940 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("close"),function()
            zmc_main_panel:Close()
        end,false)
        close_btn:Dock(RIGHT)
        close_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        close_btn.IconColor = zclib.colors["red01"]

        local workspace = vgui.Create("DPanel",main)
        workspace:SetSize(500 * zclib.wM, 200 * zclib.hM)
        workspace:Dock(TOP)
        workspace.Paint = function(s,w, h)
            draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
            draw.SimpleText(zmc.language["Craft:"], zclib.GetFont("zclib_font_medium"), 10 * zclib.wM,20 * zclib.hM,zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        workspace:DockMargin(50 * zclib.wM,5 * zclib.hM,50 * zclib.wM,10 * zclib.hM)
        workspace:InvalidateParent(true)

        if zmc.vgui.ActiveEntity.CraftItem == nil then
            local recipe_button = vgui.Create("DButton", workspace)
            recipe_button:SetSize(100 * zclib.wM, 100 * zclib.hM)
            recipe_button:SetText("")
            recipe_button.Paint = function(s, w, h)
                if s:IsHovered() then
                    zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2, zclib.colors["text01"])
                    surface.SetDrawColor(zclib.colors["green01"])
                    surface.SetMaterial(zclib.Materials.Get("plus"))
                    surface.DrawTexturedRect(0, 0,w, h)
                else
                    zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2, zclib.colors["ui02"])
                    surface.SetDrawColor(zclib.colors["ui02"])
                    surface.SetMaterial(zclib.Materials.Get("plus"))
                    surface.DrawTexturedRect(0, 0,w, h)
                end
            end
            recipe_button.DoClick = function(s)
                zclib.vgui.PlaySound("UI/buttonclick.wav")
                s:SetEnabled(false)
                timer.Simple(0.25, function() if IsValid(s) then s:SetEnabled(true) end end)

                zmc.vgui.ItemSelection(zmc.language["Select Recipe"],function(ItemID)
                    zmc.vgui.ActiveEntity.CraftItem = ItemID
                    zmc.Worktable.OpenInterface()
                end,function() return false end,function()
                    zmc.Worktable.OpenInterface()
                end,{},function(id,data)
                    if data.craft == nil then return true end
                end)
            end
            recipe_button:Center()
        else

            local cancel_btn = vgui.Create("DButton", workspace)
            cancel_btn:SetSize(100 * zclib.wM, 100 * zclib.hM)
            cancel_btn:SetText("")
            cancel_btn.Paint = function(s, w, h)
                if s:IsHovered() then
                    zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2, zclib.colors["text01"])
                    surface.SetDrawColor(zclib.colors["red01"])
                    surface.SetMaterial(zclib.Materials.Get("close"))
                    surface.DrawTexturedRect(0, 0, w, h)
                else
                    zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2, zclib.colors["ui02"])
                    surface.SetDrawColor(zclib.colors["ui02"])
                    surface.SetMaterial(zclib.Materials.Get("close"))
                    surface.DrawTexturedRect(0, 0, w, h)
                end
            end
            cancel_btn.DoClick = function(s)
                zclib.vgui.PlaySound("UI/buttonclick.wav")
                zmc.vgui.ActiveEntity.CraftItem = nil
                zmc.Worktable.OpenInterface()
            end
            cancel_btn:Center()


            local data = zmc.Item.GetData(zmc.vgui.ActiveEntity.CraftItem)

            CanCraft = table.IsEmpty(zmc.Inventory.GetMissing(zmc.vgui.ActiveEntity,data.craft.items))

            local list , scroll = zmc.vgui.List(workspace)
            scroll:DockMargin(10 * zclib.wM,10 * zclib.hM,120 * zclib.wM,10 * zclib.hM)
            list:DockMargin(0 * zclib.wM,5 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
            scroll:SetWide(170 * zclib.wM)
            scroll:Dock(RIGHT)
            scroll.Paint = function(s, w, h) end
            list.Paint = function(s, w, h) end

            for i = 1,4 do
                local dat = zmc.Item.GetData(data.craft.items[i])
                local item_pnl = zmc.vgui.Slot(dat,function()
                    return false
                end,function()
                    return false
                end,function()
                end)
                list:Add(item_pnl)
                item_pnl:SetSize(80 * zclib.wM, 80 * zclib.hM)
            end

            local itm_field = vgui.Create("DPanel",workspace)
            itm_field:SetWide(300)
            itm_field:Dock(LEFT)
            itm_field:DockMargin(10 * zclib.wM,10 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
            itm_field:InvalidateParent(true)
            itm_field.Paint = function(s,w, h) end

            local craft_font = zclib.util.FontSwitch(zmc.language["comp_title_craft"],120 * zclib.wM,zclib.GetFont("zclib_font_big"),zclib.GetFont("zclib_font_medium"))
            local item_pnl = zmc.vgui.Slot(data,function()
                return false
            end,function()
                return CanCraft
            end,function()
                if zmc.vgui.ActiveEntity.CraftItem == nil then return end
                // 512179242
                local listID = zmc.Item.GetListID(zmc.vgui.ActiveEntity.CraftItem)
                if listID == nil then return end

                net.Start("zmc_Worktable_craft")
                net.WriteEntity(zmc.vgui.ActiveEntity)
                net.WriteUInt(listID,16)
                net.SendToServer()
            end,nil,function(w,h,s,dat)
                if data.craft and data.craft.amount then
                    draw.SimpleText(data.craft.amount .. "x", zclib.GetFont("zclib_font_medium"), w - 5 * zclib.wM,0 * zclib.hM,zclib.colors["text01"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
                end

                if CanCraft == false then
                    draw.RoundedBox(4, 0, 0, w, h, zclib.colors["black_a200"])
                else
                    if s:IsHovered() then
                        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["green01"])
                        draw.RoundedBox(5, w * 0.02, h * 0.02, w * 0.96, h * 0.96, zclib.colors["ui01"])
                        draw.SimpleText(zmc.language["comp_title_craft"], craft_font, w / 2, h / 2, zclib.colors["green01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                        if dat and dat.name then
                            draw.RoundedBox(5, 0, h * 0.8, w, h * 0.2, zclib.colors["black_a100"])
                            local txtW = zclib.util.GetTextSize(dat.name, s.font_name)

                            if txtW > w * 0.9 then
                                if s.font_name == zclib.GetFont("zclib_font_mediumsmall") then
                                    s.font_name = zclib.GetFont("zclib_font_small")
                                elseif s.font_name == zclib.GetFont("zclib_font_small") then
                                    s.font_name = zclib.GetFont("zclib_font_tiny")
                                elseif s.font_name == zclib.GetFont("zclib_font_tiny") then
                                    s.font_name = zclib.GetFont("zclib_font_nano")
                                end
                            end

                            draw.SimpleText(dat.name, s.font_name, w / 2, h * 0.9, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        end
                    end
                end
            end)
            item_pnl:SetParent(itm_field)
            item_pnl:SetSize(150 * zclib.wM, 150 * zclib.hM)
            item_pnl:Center()
        end

        main.TaskButtons = {}
        local function AddTaskButton(txt,TaskID)

            if IsValid(main.TaskButtons[TaskID]) then main.TaskButtons[TaskID]:Remove() end

            local btn = zclib.vgui.TextButton(0,0,200,50,main.Inventory.top_pnl,{Text01 = txt},function()

                local slot_data = zmc.Inventory.GetSlotData(zmc.vgui.ActiveEntity,zmc.Inventory.SelectedItem)
                if slot_data == nil then return end
                local itmID = slot_data.itm
                if itmID == nil then return end

                net.Start("zmc_Worktable_start")
                net.WriteEntity(zmc.vgui.ActiveEntity)
                net.WriteUInt(zmc.Inventory.SelectedItem,16)
                net.WriteUInt(TaskID,2)
                net.SendToServer()
            end,function(s)
                return false
            end)
            btn:Dock(RIGHT)
            btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
            btn.txt_font = zclib.GetFont("zclib_font_medium")
            btn.color = zclib.colors["ui_highlight"]
            btn.txt_color = zclib.colors["text01"]
            main.TaskButtons[TaskID] = btn
        end

        // Build Inventory
        zmc.Inventory.VGUI(main,zmc.Inventory.Get(zmc.vgui.ActiveEntity),function(data)
            return true
        end,function(slot_id)

            if IsValid(main.TaskButtons[1]) then main.TaskButtons[1]:Remove() end
            if IsValid(main.TaskButtons[2]) then main.TaskButtons[2]:Remove() end

            local slot_data = zmc.Inventory.GetSlotData(zmc.vgui.ActiveEntity,zmc.Inventory.SelectedItem)
            if slot_data == nil then return end

            local itemdata = zmc.Item.GetData(slot_data.itm)
            if itemdata == nil then return end
            if itemdata.cut == nil and itemdata.knead == nil then return end

            if itemdata.cut then
                AddTaskButton(zmc.language["Cut"],1)
            end

            if itemdata.knead then
                AddTaskButton(zmc.language["Knead"],2)
            end
        end,function(w,h,s,ItemData)
            if ItemData.cut then
                surface.SetDrawColor(color_white)
                surface.SetMaterial(zmc.Item.Components.cut.icon)
                surface.DrawTexturedRect(5 * zclib.wM, 5 * zclib.hM, 40 * zclib.wM, 40 * zclib.hM)
            elseif ItemData.knead then
                surface.SetDrawColor(color_white)
                surface.SetMaterial(zmc.Item.Components.knead.icon)
                surface.DrawTexturedRect(5 * zclib.wM, 5 * zclib.hM, 40 * zclib.wM, 40 * zclib.hM)
            end
        end,nil,{SizeW = 117,SizeH = 90, ShowDropButton = true})
    end)
end
