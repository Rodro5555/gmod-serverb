if SERVER then return end
zmc = zmc or {}
zmc.Ordertable = zmc.Ordertable or {}

net.Receive("zmc_Ordertable_open", function(len)
    zclib.Debug_Net("zmc_Ordertable_open", len)

    zmc.vgui.ActiveEntity = net.ReadEntity()

    local dataLength = net.ReadUInt(16)
    local dataDecompressed = util.Decompress(net.ReadData(dataLength))
    local list = util.JSONToTable(dataDecompressed)

    zmc.vgui.ActiveEntity.DishWhitelist = {}
    for k,v in pairs(list) do zmc.vgui.ActiveEntity.DishWhitelist[tostring(k)] = true end

    if zmc.Player.IsCook(LocalPlayer()) then
        // This interface will only be visible for Cooks
        zmc.Ordertable.OpenControlls()
    else

        // This interface will only be visible for none Cooks (Normal players)
        zmc.Ordertable.OpenMenu()
    end
end)

local DishWhitelist = {}
function zmc.Ordertable.OpenControlls()
    zmc.vgui.Page(zmc.language["Ordered Dishes:"],function(main,top)

        top.Title_font = zclib.util.FontSwitch(zmc.language["Ordered Dishes:"],320 * zclib.wM,zclib.GetFont("zclib_font_big"),zclib.GetFont("zclib_font_medium"))

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


        // Whitelist
        if zmc.Ordertable.CanEditWhitelist(zmc.vgui.ActiveEntity,LocalPlayer()) then
            local whitelist_btn = zclib.vgui.ImageButton(480 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("whitelist"),function()
                DishWhitelist = zmc.vgui.ActiveEntity.DishWhitelist or {}
                zmc.Ordertable.EditWhitelist()
            end,function()
                return false
            end)
            whitelist_btn:Dock(RIGHT)
            whitelist_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
            whitelist_btn.IconColor = zclib.colors["orange01"]
            whitelist_btn:SetTooltip(zmc.language["Whitelist Editor"])
        end


        // Change icon to robot symbol
        local AllowNPC = zmc.vgui.ActiveEntity:GetNPCCustomer()
        local npc_text = AllowNPC and zmc.language["Ordertable_DenyNPC"] or zmc.language["Ordertable_AllowNPC"]
        local npc_color = AllowNPC and zclib.colors["red01"] or zclib.colors["green01"]
        local npc_btn = zclib.vgui.ImageButton(480 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("robot"),function(pnl)
            if not IsValid(zmc.vgui.ActiveEntity) then return end

            local newValue = not zmc.vgui.ActiveEntity:GetNPCCustomer()

            net.Start("zmc_Ordertable_NPCCustomer")
            net.WriteEntity(zmc.vgui.ActiveEntity)
            net.WriteBool(newValue)
            net.SendToServer()

            if newValue == false then
                pnl:SetTooltip(zmc.language["Ordertable_AllowNPC"])
                pnl.IconColor = zclib.colors["green01"]
                pnl.NoneHover_IconColor = zclib.colors["red01"]
            else
                pnl:SetTooltip(zmc.language["Ordertable_DenyNPC"])
                pnl.IconColor = zclib.colors["red01"]
                pnl.NoneHover_IconColor = zclib.colors["green01"]
            end
        end,function()
            return false
        end)
        npc_btn:Dock(RIGHT)
        npc_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        npc_btn.IconColor = npc_color
        npc_btn.NoneHover_IconColor = AllowNPC and zclib.colors["green01"] or zclib.colors["red01"]
        npc_btn:SetTooltip(npc_text)


        if zmc.config.Order.allow_customer_orders_adminonly == false or zclib.Player.IsAdmin(LocalPlayer()) then

            local CustomOrders = zmc.vgui.ActiveEntity:GetCustomOrders()
            local custm_color = CustomOrders and zclib.colors["red01"] or zclib.colors["green01"]
            local toggle_customorders = zclib.vgui.ImageButton(480 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("zmc_customorder"),function(pnl)
                if not IsValid(zmc.vgui.ActiveEntity) then return end
                local newValue = not zmc.vgui.ActiveEntity:GetCustomOrders()

                net.Start("zmc_Ordertable_CustomOrders")
                net.WriteEntity(zmc.vgui.ActiveEntity)
                net.WriteBool(newValue)
                net.SendToServer()

                if newValue == false then
                    pnl.IconColor = zclib.colors["green01"]
                    pnl.NoneHover_IconColor = zclib.colors["red01"]
                else
                    pnl.IconColor = zclib.colors["red01"]
                    pnl.NoneHover_IconColor = zclib.colors["green01"]
                end
            end,function()
                return false
            end)
            toggle_customorders:Dock(RIGHT)
            toggle_customorders:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
            toggle_customorders.IconColor = custm_color
            toggle_customorders.NoneHover_IconColor = CustomOrders and zclib.colors["green01"] or zclib.colors["red01"]
            toggle_customorders:SetTooltip(zmc.language["tooltip_CustomOrders"])
        end

        local AcceptOrders = zmc.vgui.ActiveEntity:GetAcceptOrders()
        local tgl_text = AcceptOrders and zmc.language["Stop"] or zmc.language["Start"]
        local tgl_color = AcceptOrders and zclib.colors["red01"] or zclib.colors["green01"]
        local toggle_button = zclib.vgui.ImageButton(480 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("money"),function(pnl)
            if not IsValid(zmc.vgui.ActiveEntity) then return end

            local newValue = not zmc.vgui.ActiveEntity:GetAcceptOrders()

            net.Start("zmc_Ordertable_toggle")
            net.WriteEntity(zmc.vgui.ActiveEntity)
            net.WriteBool(newValue)
            net.SendToServer()

            if newValue == false then
                pnl:SetTooltip(zmc.language["Start"])
                pnl.IconColor = zclib.colors["green01"]
                pnl.NoneHover_IconColor = zclib.colors["red01"]
            else
                pnl:SetTooltip(zmc.language["Stop"])
                pnl.IconColor = zclib.colors["red01"]
                pnl.NoneHover_IconColor = zclib.colors["green01"]
            end
        end,function()
            return false
        end)
        toggle_button:Dock(RIGHT)
        toggle_button:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        toggle_button.IconColor = tgl_color
        toggle_button.NoneHover_IconColor = AcceptOrders and zclib.colors["green01"] or zclib.colors["red01"]
        toggle_button:SetTooltip(tgl_text)


        // Show which dishes are ordered
        main.OnInventoryChanged = function()

            local OrderedDishes = zmc.Inventory.Get(zmc.vgui.ActiveEntity)

            // Build Inventory
            local scroll,list = zmc.Inventory.VGUI(main,OrderedDishes,function(data,slot_data)
                return slot_data.ReadyToGo ~= nil
            end,function(slot_id)
            end,function(w,h,s,ItemData)
            end,nil,{SizeW = 212,SizeH = 300, title = zmc.language["Orders:"]})
            scroll:DockMargin(50 * zclib.wM,5 * zclib.hM,50 * zclib.wM,0 * zclib.hM)
            list:DockMargin(10 * zclib.wM,2 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
            scroll.UpdateItem = function(selfi,slot_id,slot_data)
                if slot_data == nil then return end

                local DishData = zmc.Dish.GetData(slot_data.itm)
                if DishData == nil then return end

                local item_pnl = scroll.Items[slot_id]
                if IsValid(item_pnl) then item_pnl:Remove() end
                item_pnl = zmc.vgui.Dish(scroll,DishData)
                item_pnl:Dock(NODOCK)
                item_pnl:SetSize(212 * zclib.wM,  300 * zclib.hM)
                item_pnl.DoClick = function()
                    if slot_data.ReadyToGo then
                        // Call drop function
                        zmc.Inventory.Drop(zmc.vgui.ActiveEntity,slot_id)
                    end
                end

                local font = zclib.GetFont("zclib_font_medium")
                local txtW = zclib.util.GetTextSize(DishData.name,font)
                if txtW >= (200 * zclib.wM) then font = zclib.GetFont("zclib_font_mediumsmall") end

                local orderTime = zmc.Dish.GetOrderTime(slot_data.itm)
                local price = zmc.Dish.GetPrice(slot_data.itm)
                price = zclib.Money.Display(price)

                item_pnl.PreDrawModel = function(s,ent)
                    local w,h = s:GetWide(), s:GetTall()
                    cam.Start2D()
                        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui00"])

                        surface.SetDrawColor(zclib.colors["black_a200"])
                        surface.SetMaterial(zclib.Materials.Get("radial_shadow"))
                        surface.DrawTexturedRect(0, 0,w, h)

                        if slot_data.time then
                            draw.RoundedBox(5, 0, h - 20 * zclib.hM, w, 20 * zclib.hM, zclib.colors["ui02"])
                            local CountDown = math.Clamp(orderTime - (CurTime() - slot_data.time),0,orderTime)
                            local barW = (s:GetWide() / orderTime) * CountDown
                            draw.RoundedBox(5, 0, h - 20 * zclib.hM, math.Clamp(barW,0,w), 20 * zclib.hM, zclib.util.LerpColor((1 / orderTime) * CountDown, zclib.colors["red01"], zclib.colors["green01"]))

                            draw.SimpleText(string.FormattedTime(CountDown, "%02i:%02i"),zclib.GetFont("zclib_font_small"), w / 2, h - 10 * zclib.hM,color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        end

                        draw.SimpleText(price,zclib.GetFont("zclib_font_mediumsmall"), w / 2, h - 90 * zclib.hM,zclib.colors["green01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

                        draw.SimpleText(DishData.name,font,  10 * zclib.wM, 5 * zclib.hM,zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                        if slot_data.steamName then
                            draw.SimpleText("[" .. slot_data.steamName .. "]", zclib.GetFont("zclib_font_small"), 10 * zclib.wM, 35 * zclib.hM, zclib.colors["blue01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                        end
                    cam.End2D()
                end

                list:Add(item_pnl)
                scroll.Items[slot_id] = item_pnl
            end
            scroll:Update(OrderedDishes)
        end

        // Build Inventory
        main:OnInventoryChanged()
    end)
end

function zmc.Ordertable.EditWhitelist()
    zmc.vgui.WhitelistEditor(zmc.language["Restrict_Orders"],DishWhitelist,function()
        DishWhitelist = {}
        zmc.Ordertable.OpenControlls()
    end,function()

        local e_String = util.TableToJSON(DishWhitelist)
        local e_Compressed = util.Compress(e_String)
        net.Start("zmc_Ordertable_setwhitelist")
        net.WriteEntity(zmc.vgui.ActiveEntity)
        net.WriteUInt(#e_Compressed,16)
        net.WriteData(e_Compressed,#e_Compressed)
        net.SendToServer()

        DishWhitelist = nil

        zmc_main_panel:Close()
    end,function()

        local AddList = {}
        zmc.vgui.DishSelection(zmc.language["Whitelist_AddDish"],function(ItemID)

            if AddList[ItemID] then
                AddList[ItemID] = nil
            else
                AddList[ItemID] = true
            end
        end,function(_DishData)
            // Is this dish selected?
            return AddList[_DishData.uniqueid] ~= nil
        end,function()
            zmc.Ordertable.EditWhitelist()
        end,{},function(id,data)
            if DishWhitelist[tostring(data.uniqueid)] then return true end
        end,function()
            DishWhitelist = table.Merge( DishWhitelist, AddList )
            zmc.Ordertable.EditWhitelist()
        end)

    end,function()
        DishWhitelist = {}
        zmc.Ordertable.EditWhitelist()
    end,function(list)
        for uid, _ in pairs(DishWhitelist) do

            local data = zmc.Dish.GetData(uid)
            if data == nil then continue end

            local dish_pnl = zmc.vgui.Dish(list,data,function(s,ent,adata)
                local w,h = s:GetWide(), s:GetTall()
                cam.Start2D()
                    draw.RoundedBox(5, 0, h * 0.8, w, h * 0.2, zclib.colors["black_a100"])
                    draw.SimpleText(adata.name, zclib.GetFont("zclib_font_small"), w / 2,h * 0.9,zclib.colors["text01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                cam.End2D()
            end)
            dish_pnl:Dock(NODOCK)
            dish_pnl:SetSize(166 * zclib.wM, 166 * zclib.hM)
            dish_pnl.DoClick = function()
                zclib.vgui.PlaySound("UI/buttonclick.wav")
                // Remove this item from the list and rebuild
                DishWhitelist[tostring(data.uniqueid)] = nil
                zmc.Ordertable.EditWhitelist()
            end
            list:Add(dish_pnl)
        end
    end)
end

local SelectedDish
function zmc.Ordertable.OpenMenu()
    zmc.vgui.Page(zmc.language["OrderMenu"],function(main,top)

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

        local order_button_font = zclib.util.FontSwitch( zmc.language["Order Dish"],250 * zclib.wM,zclib.GetFont("zclib_font_big"),zclib.GetFont("zclib_font_medium"))
        local order_button = zclib.vgui.TextButton(0,0,250,50,top,{Text01 = zmc.language["Order Dish"],txt_font = order_button_font},function()
            if SelectedDish == nil then return end

            net.Start("zmc_OrderMenu_OrderDish")
            net.WriteEntity(zmc.vgui.ActiveEntity)
            net.WriteUInt(SelectedDish,32)
            net.SendToServer()

        end,function()
            return SelectedDish == nil
        end)
        order_button:Dock(RIGHT)
        order_button:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)


        local Dish_list = vgui.Create("DPanel", main)
        Dish_list:Dock(LEFT)
        Dish_list:SetSize(300 * zclib.wM, 230 * zclib.hM)
        Dish_list:DockPadding(0 * zclib.wM,30 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        Dish_list:DockMargin(50 * zclib.wM,5 * zclib.hM,0 * zclib.wM,10 * zclib.hM)
        Dish_list.Paint = function(s, w, h)
            draw.RoundedBox(5,0, 0, w, h, zclib.colors["ui01"])
            draw.RoundedBox(5, 10 * zclib.wM, 50 * zclib.hM, w - 20 * zclib.wM, h - 60 * zclib.hM, zclib.colors["ui02"])
            draw.SimpleText(zmc.language["Dishes"], zclib.GetFont("zclib_font_medium"), 10 * zclib.wM,20 * zclib.hM,zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        local list,scroll = zmc.vgui.List(Dish_list)
        list:DockMargin(10 * zclib.wM,10 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        scroll:DockMargin(10 * zclib.wM,21 * zclib.hM,10 * zclib.wM,10 * zclib.hM)

        local function RebuildDish(rData)
            // Rebuild the Dish panle
            if IsValid(main.DishPanel) then main.DishPanel:Remove() end

            timer.Simple(0.01,function()
                if IsValid(list) and SelectedDish then
                    local children = list:GetChildren()
                    if children and children[SelectedDish] then
                        scroll:JumpToChild( children[SelectedDish] )
                    end
                end
            end)

            local name = ""
            local price = ""
            if rData then
                if rData.name then
                    name = rData.name
                end

                if rData.uniqueid then
                    price = zclib.Money.Display(zmc.Dish.GetPrice(rData.uniqueid))
                end
            end

            local mdl_pnl = zmc.vgui.Dish(main,rData,function(s,ent)
                cam.Start2D()
                    draw.SimpleText(name, zclib.GetFont("zclib_font_big"), 10 * zclib.wM,0 * zclib.hM,zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText(price, zclib.GetFont("zclib_font_large"), s:GetWide() - 10 * zclib.wM,s:GetTall() + 5 * zclib.hM,zclib.colors["green01"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
                cam.End2D()
            end)
            mdl_pnl:DockMargin(10 * zclib.wM,5 * zclib.hM,50 * zclib.wM,10 * zclib.hM)
            main.DishPanel = mdl_pnl
        end

        // Display All the food items the player can order
        local wlist = zmc.vgui.ActiveEntity.DishWhitelist
        for id, data in pairs(zmc.config.Dishs) do

            // Only display whitelisted items
            if wlist and table.Count(wlist) > 0 and wlist[tostring(data.uniqueid)] == nil then continue end

            local CanCook = hook.Run("zmc_CanCookDish",LocalPlayer(),data.uniqueid)
            if CanCook ~= nil and CanCook == false then continue end


            local dish_pnl = zmc.vgui.Dish(main,data)
            dish_pnl:Dock(NODOCK)
            dish_pnl:SetSize(75 * zclib.wM, 75 * zclib.hM)
            dish_pnl.DoClick = function()
                zclib.vgui.PlaySound("UI/buttonclick.wav")
                SelectedDish = id

                local rData = zmc.Dish.GetData(SelectedDish)
                if rData then RebuildDish(rData) end
            end
            dish_pnl.PreDrawModel = function(s,ent)
                local w,h = s:GetWide(), s:GetTall()
                cam.Start2D()
                    draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a100"])

                    if SelectedDish == id then
                        draw.RoundedBox(5, 0, 0, 5 * zclib.wM, h, zclib.colors["green01"])
                    end

                    surface.SetDrawColor(zclib.colors["black_a200"])
                    surface.SetMaterial(zclib.Materials.Get("radial_shadow"))
                    surface.DrawTexturedRect(0, 0,w, h)
                cam.End2D()
            end

            // Forces the Food on the plate to no clip to improve performance since we dont are that close
            dish_pnl.Entity.NoFoodClipping = true

            list:Add(dish_pnl)
            if SelectedDish == nil then SelectedDish = id end
        end

        RebuildDish(zmc.Dish.GetData(SelectedDish))
    end)
end
