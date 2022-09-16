if SERVER then return end

zmc = zmc or {}
zmc.Dishtable = zmc.Dishtable or {}
zmc.Dishtable.Interface = zmc.Dishtable.Interface or {}

local SelectedDish
local DishData = {}
local DishWhitelist = {}

net.Receive("zmc_Dishtable_open", function(len)
    zclib.Debug_Net("zmc_config_open", len)

    zmc.vgui.ActiveEntity = net.ReadEntity()
    if not IsValid(zmc.vgui.ActiveEntity) then return end

    local dataLength = net.ReadUInt(16)
    local dataDecompressed = util.Decompress(net.ReadData(dataLength))
    local list = util.JSONToTable(dataDecompressed)
    zmc.vgui.ActiveEntity.DishWhitelist = {}
    for k,v in pairs(list) do zmc.vgui.ActiveEntity.DishWhitelist[tostring(k)] = true end

    if zmc.vgui.ActiveEntity:GetDishID() > 0 then
        zmc.Dishtable.CookMenu()
    else
        SelectedDish = nil
        zmc.Dishtable.MainMenu()
    end
end)

net.Receive("zmc_Dishtable_selectdish", function(len)
    zclib.Debug_Net("zmc_Dishtable_selectdish", len)

    local Dishtable = net.ReadEntity()

    // If any other player got the ui open then auto change to the cook menu
    if IsValid(Dishtable) and IsValid(zmc.vgui.ActiveEntity) and Dishtable == zmc.vgui.ActiveEntity then
        zmc.Dishtable.CookMenu()
    end
end)

net.Receive("zmc_Dishtable_canceldish", function(len)
    zclib.Debug_Net("zmc_Dishtable_canceldish", len)

    local Dishtable = net.ReadEntity()

    // If any other player got the ui open then auto change to the cook menu
    if IsValid(Dishtable) and IsValid(zmc.vgui.ActiveEntity) and Dishtable == zmc.vgui.ActiveEntity then
        zmc.Dishtable.MainMenu()
    end
end)

function zmc.Dishtable.CookMenu()
    zmc.vgui.Page(zmc.language["Cook Menu"],function(main,top)

        local close_btn = zclib.vgui.ImageButton(940 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("close"),function()
            zmc_main_panel:Close()
        end,false)
        close_btn:Dock(RIGHT)
        close_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        close_btn.IconColor = zclib.colors["red01"]

        local cancel_button = zclib.vgui.TextButton(0,0,240,50,top,{Text01 = zmc.language["Cancel"]},function()
            net.Start("zmc_Dishtable_canceldish")
            net.WriteEntity(zmc.vgui.ActiveEntity)
            net.SendToServer()
        end,function()
            return false
        end)
        cancel_button:Dock(RIGHT)
        cancel_button:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)


        // Show which items we need
        main.OnInventoryChanged = function()

            local MissingIngredients = zmc.Dishtable.GetMissingIngredients(zmc.vgui.ActiveEntity)

            // Build Inventory
            local scroll = zmc.Inventory.VGUI(main,MissingIngredients,function(data)
                return false
            end,function(slot_id)
            end,function(w,h,s,ItemData)
            end,nil,{SizeW = 168,SizeH = 168,title = zmc.language["Missing Ingredients:"]})
            scroll:DockMargin(50 * zclib.wM,5 * zclib.hM,50 * zclib.wM,10 * zclib.hM)
        end

        // Build Inventory
        main:OnInventoryChanged()
    end)
end

function zmc.Dishtable.MainMenu()
    zmc.vgui.Page(zmc.language["Dishtable"],function(main,top)

        top.Title_font = zclib.util.FontSwitch(zmc.language["Dishtable"],210 * zclib.wM,zclib.GetFont("zclib_font_big"),zclib.GetFont("zclib_font_medium"))

        local close_btn = zclib.vgui.ImageButton(940 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("close"),function()
            zmc_main_panel:Close()
        end,false)
        close_btn:Dock(RIGHT)
        close_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        close_btn.IconColor = zclib.colors["red01"]

        if zclib.Player.IsAdmin(LocalPlayer()) then
            local seperator = zmc.vgui.AddSeperator(top)
            seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
            seperator:Dock(RIGHT)
            seperator:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)

            // Whitelist
            local whitelist_btn = zclib.vgui.ImageButton(480 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("whitelist"),function()
                DishWhitelist = zmc.vgui.ActiveEntity.DishWhitelist or {}
                zmc.Dishtable.EditWhitelist()
            end,function()
                return false
            end)
            whitelist_btn:Dock(RIGHT)
            whitelist_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
            whitelist_btn.IconColor = zclib.colors["orange01"]
            whitelist_btn:SetTooltip(zmc.language["Whitelist Editor"])

            local seperator = zmc.vgui.AddSeperator(top)
            seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
            seperator:Dock(RIGHT)
            seperator:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)

            // Clipboard
            local clip_btn = zclib.vgui.ImageButton(480 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("clipboard"),function()
                if zmc.Dish.GetData(SelectedDish) == nil then return end
                zmc.Dishtable.Copytoclipboard(SelectedDish)
            end,function()
                return zmc.Dish.GetData(SelectedDish) == nil
            end)
            clip_btn:Dock(RIGHT)
            clip_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
            clip_btn.IconColor = zclib.colors["green01"]
            clip_btn:SetTooltip(zmc.language["tooltip_clipboard"])

            // Edit
            local edit_btn = zclib.vgui.ImageButton(480 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("edit"),function()
                if zmc.Dish.GetData(SelectedDish) == nil then return end
                DishData = nil
                zmc.Dishtable.DishEditor()
            end,function()
                return zmc.Dish.GetData(SelectedDish) == nil
            end)
            edit_btn:Dock(RIGHT)
            edit_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
            edit_btn.IconColor = zclib.colors["orange01"]

            // Remove
            local remove_btn = zclib.vgui.ImageButton(420 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("delete"),function()
                if zmc.Dish.GetData(SelectedDish) == nil then return end
                zmc.Dishtable.RemoveDish(SelectedDish)
            end,function()
                return zmc.Dish.GetData(SelectedDish) == nil
            end)
            remove_btn:Dock(RIGHT)
            remove_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
            remove_btn.IconColor = zclib.colors["red01"]

            // Add
            local add_btn = zclib.vgui.ImageButton(300 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("plus"),function()
                SelectedDish = -1
                DishData = nil
                zmc.Dishtable.DishEditor()
            end,false)
            add_btn:Dock(RIGHT)
            add_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
            add_btn.IconColor = zclib.colors["green01"]

            // Duplicate
            local dup_btn = zclib.vgui.ImageButton(200 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("duplicate"),function()
                if zmc.Dish.GetData(SelectedDish) == nil then return end
                DishData = nil

                local data = table.Copy(zmc.Dish.GetData(SelectedDish))
                data.uniqueid = zclib.util.GenerateUniqueID("xxxxxxxxxx")
                data.name = data.name .. " " .. zmc.language["Copy"]
                SelectedDish = table.insert(zmc.config.Dishs,data)


                zmc.Dishtable.DishEditor()
            end,false)
            dup_btn:Dock(RIGHT)
            dup_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
            dup_btn.IconColor = zclib.colors["blue01"]
        end

        local seperator = zmc.vgui.AddSeperator(top)
        seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
        seperator:Dock(RIGHT)
        seperator:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)

        local cook_button_font = zclib.util.FontSwitch( zmc.language["Select Dish"],250 * zclib.wM,zclib.GetFont("zclib_font_big"),zclib.GetFont("zclib_font_medium"))
        local cook_button = zclib.vgui.TextButton(0,0,250,50,top,{Text01 = zmc.language["Select Dish"],txt_font = cook_button_font},function()
            if SelectedDish == nil then return end
            net.Start("zmc_Dishtable_selectdish")
            net.WriteEntity(zmc.vgui.ActiveEntity)
            net.WriteUInt(SelectedDish,16)
            net.SendToServer()
            //zmc.Dishtable.CookMenu()
        end,function()
            return SelectedDish == nil
        end)
        cook_button:Dock(RIGHT)
        cook_button:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)


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
                    draw.SimpleText(name, zclib.GetFont("zclib_font_big"), 10 * zclib.wM,25 * zclib.hM,zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    draw.SimpleText(price, zclib.GetFont("zclib_font_big"), s:GetWide() - 10 * zclib.wM,s:GetTall() - 25 * zclib.hM,zclib.colors["green01"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                cam.End2D()
            end)
            mdl_pnl:DockMargin(10 * zclib.wM,5 * zclib.hM,50 * zclib.wM,10 * zclib.hM)
            main.DishPanel = mdl_pnl

            // Rebuild the ingredient list
            if IsValid(main.IngList) then main.IngList:Remove() end
            if rData then

                local alist,ascroll = zmc.vgui.List(main.Dish_info)
                alist:DockMargin(10 * zclib.wM,50 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
                alist:SetSpaceY( 9 )
                alist:SetSpaceX( 9 )
                main.IngList = ascroll
                for k,v in pairs(rData.items) do
                    local data = zmc.Item.GetData(v.uniqueid)
                    if data == nil then continue end

                    local itm_pnl = zmc.vgui.Slot(data,function()

                        //IsSelected
                        return false
                    end,function()

                        // CanSelect
                        return false
                    end,function()

                        // OnSelect
                    end,function()

                        // PreDraw
                    end,function(w,h)

                        // PostDraw
                    end)

                    alist:Add(itm_pnl)

                    itm_pnl:SetSize(70 * zclib.wM, 70 * zclib.hM)
                end
            end
        end

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

        local Dish_info = vgui.Create("DPanel", main)
        Dish_info:Dock(BOTTOM)
        Dish_info:SetSize(300 * zclib.wM, 230 * zclib.hM)
        Dish_info:DockMargin(10 * zclib.wM,0 * zclib.hM,50 * zclib.wM,10 * zclib.hM)
        Dish_info.Paint = function(s, w, h)
            draw.RoundedBox(5,0, 0, w, h, zclib.colors["ui01"])
            draw.RoundedBox(5, 10 * zclib.wM, 50 * zclib.hM, w - 20 * zclib.wM, h - 60 * zclib.hM, zclib.colors["ui02"])
            draw.SimpleText(zmc.language["Ingredients"], zclib.GetFont("zclib_font_medium"), 10 * zclib.wM,20 * zclib.hM,zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        main.Dish_info = Dish_info

        RebuildDish(zmc.Dish.GetData(SelectedDish))
    end)
end

local SelectedFood

local SpinVal_X = 0
local LerpedZoom = 0.5
local Zoom = 0.5

function zmc.Dishtable.DishEditor()
    if DishData == nil then
        if zmc.Dish.GetData(SelectedDish) then
            DishData = table.Copy(zmc.Dish.GetData(SelectedDish))
        else
            DishData = {
                name = "Dish Name",
                time = 10,
                mdl = "models/zerochain/props_kitchen/zmc_plate01.mdl",
                items = {}
            }
        end
    end

    zmc.vgui.Page(zmc.language["Dish Editor"],function(main,top)

        local close_btn = zclib.vgui.ImageButton(540 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("back"),function()
            zmc.Dishtable.MainMenu()
        end,false)
        close_btn:Dock(RIGHT)
        close_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        close_btn.IconColor = zclib.colors["red01"]

        // Save Button
        local save_btn = zclib.vgui.ImageButton(480 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("save"),function()
            if SelectedDish == -1 then
                zmc.Dishtable.CreateDish()
            else
                zmc.Dishtable.UpdateDish(SelectedDish)
            end
        end,false)
        save_btn:Dock(RIGHT)
        save_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        save_btn.IconColor = zclib.colors["green01"]


        local left_pnl = vgui.Create("DPanel", main)
        left_pnl:Dock(LEFT)
        left_pnl:SetSize(300 * zclib.wM, 230 * zclib.hM)
        left_pnl:DockMargin(50 * zclib.wM,10 * zclib.hM,0 * zclib.wM,10 * zclib.hM)
        left_pnl.Paint = function(s, w, h)
            //draw.RoundedBox(5,0, 0, w, h, zclib.colors["red01"])
        end

        local plate_names = {}
        for k, v in pairs(zmc.config.Plates) do
            plate_names[v] = "Plate0" .. k
        end

        local plate_combo = vgui.Create( "DComboBox", left_pnl )
        plate_combo:SetSize(300 * zclib.wM, 40 * zclib.hM)
        plate_combo:Dock(TOP)
        plate_combo:DockMargin(0 * zclib.wM,0 * zclib.hM,0 * zclib.wM,10 * zclib.hM)
        plate_combo:SetValue(plate_names[DishData.mdl])
        plate_combo:SetColor(zclib.colors["text01"] )
        plate_combo.Paint = function(s, w, h) draw.RoundedBox(4, 0, 0, w, h, zclib.colors["ui01"]) end
        plate_combo.OnSelect = function( s, index, value ,data_val)
            main.DishPanel:SetModel(data_val)
            DishData.mdl = data_val
        end
        for k, v in pairs(zmc.config.Plates) do
            plate_combo:AddChoice("Plate0" .. k, v)
        end


        local cooktime_pnl_font = zclib.util.FontSwitch(zmc.language["Order Time"],100 * zclib.wM,zclib.GetFont("zclib_font_medium"),zclib.GetFont("zclib_font_small"))
        local cooktime_pnl = zmc.vgui.TitledTextEntry(left_pnl,45,cooktime_pnl_font,zmc.language["Order Time"],DishData.time or 10 , 10,false,function(val)
            DishData.time = math.Clamp(val,10,600)
        end)
        cooktime_pnl:SetSize(300 * zclib.wM, 40 * zclib.hM)
        cooktime_pnl:Dock(TOP)
        cooktime_pnl:DockMargin(0 * zclib.wM,0 * zclib.hM,0 * zclib.wM,10 * zclib.hM)
        cooktime_pnl.textentry:DockMargin(150 * zclib.wM,0 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
        cooktime_pnl.textentry.font = zclib.GetFont("zclib_font_medium")
        cooktime_pnl.textentry:SetTooltip(zmc.language["tooltip_OrderTime"])


        local customprice_pnl_font = zclib.util.FontSwitch(zmc.language["Custom Price"],100 * zclib.wM,zclib.GetFont("zclib_font_medium"),zclib.GetFont("zclib_font_small"))
        local customprice_pnl = zmc.vgui.TitledTextEntry(left_pnl,45,customprice_pnl_font,zmc.language["Custom Price"],DishData.price or 0 , 0,false,function(val)
            DishData.price = math.Clamp(val,0,10000000)
        end)
        customprice_pnl:SetSize(300 * zclib.wM, 40 * zclib.hM)
        customprice_pnl:Dock(TOP)
        customprice_pnl:DockMargin(0 * zclib.wM,0 * zclib.hM,0 * zclib.wM,10 * zclib.hM)
        customprice_pnl.textentry:DockMargin(150 * zclib.wM,0 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
        customprice_pnl.textentry.font = zclib.GetFont("zclib_font_medium")
        customprice_pnl.textentry:SetTooltip(zmc.language["tooltip_CustomPrice"])



        local food_list = vgui.Create("DPanel", left_pnl)
        food_list:Dock(FILL)
        food_list:DockPadding(0 * zclib.wM,50 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        food_list.Paint = function(s, w, h)
            draw.RoundedBox(5,0, 0, w, h, zclib.colors["ui01"])
            draw.RoundedBox(5, 10 * zclib.wM, 50 * zclib.hM, w - 20 * zclib.wM, h - 60 * zclib.hM, zclib.colors["ui02"])
            draw.SimpleText(zmc.language["Ingredients"], zclib.GetFont("zclib_font_medium"), 10 * zclib.wM,20 * zclib.hM,zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        local list = zmc.vgui.List(food_list)
        list:SetSpaceY( 10 * zclib.hM )
        list:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)

        local function SelectFoodItem(id)
            SelectedFood = id
            local itmData = DishData.items[SelectedFood]
            if itmData == nil then return end
            // Here we tell the system which client food model should be highlighted
            main.DishPanel.HighlightID = SelectedFood

            if main.slider_pitch then
                main.slider_pitch.slideValue = (1 / 360 ) * itmData.lang.p
            end

            if main.slider_yaw then
                main.slider_yaw.slideValue = (1 / 360 ) * itmData.lang.y
            end

            if main.slider_roll then
                main.slider_roll.slideValue = (1 / 360 ) * itmData.lang.r
            end

            if main.slider_height then
                main.slider_height.slideValue = itmData.lpos.z
            end

            if main.slider_scale then
                main.slider_scale.slideValue = (itmData.scale or 1)
            end
        end

        for k,v in pairs(DishData.items) do
            if v.uniqueid == nil then continue end
            local itemData = zmc.Item.GetData(v.uniqueid)
            if itemData == nil then continue end

            local food_button = zclib.vgui.TextButton(0,0,260,40,top,{Text01 = itemData.name,txt_font = zclib.GetFont("zclib_font_mediumsmall")},function()
                zclib.vgui.PlaySound("UI/buttonclick.wav")
                SelectFoodItem(k)
            end,function()
                return false
            end,function()
                return SelectedFood == k
            end)
            list:Add(food_button)

            if SelectedFood == nil or DishData.items[SelectedFood] == nil then
                SelectedFood = k
            end
        end

        // Remove
        local remove_btn  = zmc.vgui.SimpleButton(180 * zclib.wM,10 * zclib.hM,30 * zclib.wM, 30 * zclib.hM,food_list,zclib.Materials.Get("delete"),function()
            if SelectedFood == nil or DishData.items[SelectedFood] == nil then return end
            table.remove(DishData.items,SelectedFood)
            SelectedFood = nil
            zmc.Dishtable.DishEditor()
        end,function()
            return SelectedFood == nil or DishData.items[SelectedFood] == nil
        end)
        remove_btn.IconColor = zclib.colors["red01"]

        // Add
        local add_btn = zmc.vgui.SimpleButton(260 * zclib.wM,10 * zclib.hM,30 * zclib.wM, 30 * zclib.hM,food_list,zclib.Materials.Get("plus"),function()
            if table.Count(DishData.items) >= 10 then
                zclib.vgui.Notify(zmc.language["ingredient_count_warning"],NOTIFY_ERROR)
                return
            end

            zmc.vgui.ItemSelection(zmc.language["Add Food"],function(ItemID)
                zclib.vgui.PlaySound("UI/buttonclick.wav")
                SelectedFood = table.insert(DishData.items, {
                    uniqueid = ItemID,
                    lpos = Vector(0.5, 0.5, 0.5),
                    lang = angle_zero,
                    scale = 1,
                })
                zmc.Dishtable.DishEditor()
            end,function() return false end,function()
                zmc.Dishtable.DishEditor()
            end,{},function(id,data)
                if data.sell == nil then return true end
            end)
        end,false)
        add_btn.IconColor = zclib.colors["green01"]

        // Duplicate
        local dup_btn = zmc.vgui.SimpleButton(220 * zclib.wM,10 * zclib.hM,30 * zclib.wM, 30 * zclib.hM,food_list,zclib.Materials.Get("duplicate"),function()
            if SelectedFood == nil or DishData.items[SelectedFood] == nil then return end

            if table.Count(DishData.items) >= 10 then
                zclib.vgui.Notify(zmc.language["ingredient_count_warning"],NOTIFY_ERROR)
                return
            end

            SelectedFood = table.insert(DishData.items, table.Copy(DishData.items[SelectedFood]))
            zmc.Dishtable.DishEditor()
        end,false)
        dup_btn.IconColor = zclib.colors["blue01"]


        local info_pnl = vgui.Create("DPanel", main)
        info_pnl:Dock(BOTTOM)
        info_pnl:SetSize(300 * zclib.wM, 230 * zclib.hM)
        info_pnl:DockMargin(10 * zclib.wM,0 * zclib.hM,50 * zclib.wM,10 * zclib.hM)
        info_pnl.Paint = function(s, w, h) end

        local pox_pnl = zmc.vgui.PositionSelection(info_pnl)
        pox_pnl.GetPosition = function(s)
            if SelectedFood and DishData.items[SelectedFood] and DishData.items[SelectedFood].lpos then
                return DishData.items[SelectedFood].lpos
            else
                return Vector(0.5,0.5,0)
            end
        end
        pox_pnl.OnChanged = function(s,newpos)
            if SelectedFood and DishData.items[SelectedFood] then
                DishData.items[SelectedFood].lpos = newpos
            end
        end
        pox_pnl.PreDraw = function(s,w,h)
            for k,v in pairs(DishData.items) do
                if v and v.lpos then
                    local vec = Vector(v.lpos.x, v.lpos.y, 0)

                    /*
                    if IsValid(main.DishPanel) then
                        local angle = main.DishPanel.SpinVal_X
                        local x,y = vec.x,vec.y
                        local cx,cy = w / 2, h / 2
                        local x_rotated = ((x - cx) * math.cos(angle)) - ((cy - y) * math.sin(angle)) + cx
                        local y_rotated = cy - ((cy - y) * math.cos(angle)) + ((x - cx) * math.sin(angle))

                        //print("x = " .. x, "y = " .. y, "x_rot = " .. x_rotated, "y_rot = " .. y_rotated)

                        //vec:Rotate(Angle(0, main.DishPanel.SpinVal_X, 0))
                        vec = Vector(x_rotated, y_rotated, 0)
                    end
                    */

                    draw.RoundedBox(5, (w * vec.x) - 4 * zclib.wM, (h * vec.y) - 4 * zclib.hM, 8 * zclib.wM, 8 * zclib.hM, zclib.colors["orange01"])

                    //draw.RoundedBox(5, math.Clamp(-w * vec.x, 0, w - 4 * zclib.wM), math.Clamp(h * vec.y, 0, h - 4 * zclib.hM), 8 * zclib.wM, 8 * zclib.hM, zclib.colors["orange01"])
                    //draw.RoundedBox(5, math.Clamp(-w * v.lpos.x, 0, w - 4 * zclib.wM), math.Clamp(h * v.lpos.y, 0, h - 4 * zclib.hM), 8 * zclib.wM, 8 * zclib.hM, zclib.colors["orange01"])
                end
            end

            /*
            if IsValid(main.DishPanel) then
                draw.SimpleText(math.Round(main.DishPanel.SpinVal_X), zclib.GetFont("zclib_font_small"),w / 2, h / 2, zclib.colors["text01"], 0, 1)
            end
            */
        end

        local function AddSlider(name,type,fill)

            local default = 0

            if SelectedFood and DishData.items[SelectedFood] then
                local itmDat = DishData.items[SelectedFood]

                if type == "pitch" then
                    default = (1 / 360 ) * itmDat.lang.p
                elseif type == "yaw" then
                    default = (1 / 360 ) * itmDat.lang.y
                elseif type == "roll" then
                    default = (1 / 360 ) * itmDat.lang.r
                elseif type == "height" then
                    default = itmDat.lpos.z
                elseif type == "scale" then
                    default = (itmDat.scale or 1)
                end
            end

            local slider = zmc.vgui.TitledSlider(info_pnl, name, default, function(val,pnl)

                if SelectedFood and DishData.items[SelectedFood] then

                    local curPos = DishData.items[SelectedFood].lpos
                    local curAng = DishData.items[SelectedFood].lang

                    if type == "pitch" then
                        DishData.items[SelectedFood].lang = Angle(360 * val, curPos.y, curAng.r)
                    elseif type == "yaw" then
                        DishData.items[SelectedFood].lang = Angle(curAng.p, 360 * val, curAng.r)
                    elseif type == "roll" then
                        DishData.items[SelectedFood].lang = Angle(curAng.p, curPos.y, 360 * val)
                    elseif type == "height" then
                        DishData.items[SelectedFood].lpos = Vector(curPos.x, curPos.y, val)
                    elseif type == "scale" then
                        DishData.items[SelectedFood].scale = val
                    end
                end
            end, 40, function(val) end)
            slider:SetWide(300 * zclib.wM)
            slider:DockMargin(0 * zclib.wM,(type == "pitch" and 10 or 5) * zclib.hM,10 * zclib.wM,0 * zclib.hM)
            slider.displayValue = function(s)
                if type == "pitch" or type == "yaw" or type == "roll" then
                    return math.Round(s.slideValue * 360)
                else
                    return math.Round(s.slideValue, 2)
                end
            end
            slider.font = zclib.GetFont("zclib_font_mediumsmall")
            if fill then slider:Dock(FILL) end
            return slider
        end

        main.slider_pitch = AddSlider(zmc.language["Pitch"],"pitch")
        main.slider_yaw = AddSlider(zmc.language["Yaw"],"yaw")
        main.slider_roll = AddSlider(zmc.language["Roll"],"roll")
        main.slider_height = AddSlider(zmc.language["Height"],"height")
        main.slider_scale = AddSlider(zmc.language["Scale"],"scale",true)


        local mdl_pnl = zmc.vgui.Dish(main,DishData,function(s,ent)
            local w,h = s:GetWide(), s:GetTall()
            cam.Start2D()
                // Draw food price
                if DishData.price and DishData.price > 0 then
                    draw.SimpleText(zclib.Money.Display(DishData.price), zclib.GetFont("zclib_font_big"), w - 10 * zclib.wM, h - 5 * zclib.hM, zclib.colors["green01"],TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
                else
                    draw.SimpleText(zclib.Money.Display(zmc.Dish.GetPrice(SelectedDish)), zclib.GetFont("zclib_font_big"), w - 10 * zclib.wM, h - 5 * zclib.hM, zclib.colors["green01"],TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
                end
            cam.End2D()
        end)
        mdl_pnl.LayoutEntity = function(s,ent)
            s:RunAnimation()

            if s:IsDown() then
                if input.IsMouseDown( MOUSE_MIDDLE ) == true then
                    SpinVal_X = 0
                else
                    if s.LastPos_X == nil or s.LastPos_Y == nil then
                        local curX, curY = s:CursorPos()
                        s.LastPos_X = curX
                        s.LastPos_Y = curY
                    end

                    local curPosX,curPosY = s:CursorPos()
                    local diff_x = s.LastPos_X - curPosX
                    local diff_y = s.LastPos_Y - curPosY

                    SpinVal_X = SpinVal_X + diff_x
                    if SpinVal_X < 0 then
                        SpinVal_X = 360
                    elseif SpinVal_X > 360 then
                        SpinVal_X = 0
                    end

                    if diff_y ~= 0 then
                        local newFov = (Zoom or 0.5)
                        if diff_y > 0 then
                            newFov = newFov - 0.005
                        else
                            newFov = newFov + 0.005
                        end
                        newFov = math.Clamp(newFov,0,1)
                        Zoom = newFov
                    end

                    s.LastPos_X = curPosX
                    s.LastPos_Y = curPosY
                end
            else
                s.LastPos_X = nil
                s.LastPos_Y = nil
            end

            local radius = mdl_pnl.DistPos or 350
            local a = math.rad( (SpinVal_X / 360)  * -360 )
            local x = math.sin(a) * radius
            local y = math.cos(a) * radius
            s:SetCamPos(Vector(x,y,mdl_pnl.HeightPos or 15))
            s:SetLookAt(vector_origin)
        end
        mdl_pnl.OnZoomChange = function(s,val)
            s.val = val

            local ypos = Lerp(s.val,15,100)
            mdl_pnl.HeightPos = ypos

            local cpos = Lerp(s.val,30,50)
            mdl_pnl.DistPos = cpos
        end
        mdl_pnl:OnZoomChange(Zoom)
        mdl_pnl.OnMouseWheeled = function(s, scrollDelta )
            local newFov = (Zoom or 0.5) - (0.05 * scrollDelta)
            newFov = math.Clamp(newFov,0,1)
            Zoom = newFov
        end
        mdl_pnl.Think = function(s)
            if LerpedZoom ~= Zoom then
                LerpedZoom = Lerp(5 * FrameTime(),LerpedZoom,Zoom or 0.5)
                mdl_pnl:OnZoomChange(LerpedZoom)
            end
        end


        // Here we tell the system which client food model should be highlighted
        mdl_pnl.HighlightID = SelectedFood
        main.DishPanel = mdl_pnl

        // Select the first food we found
        timer.Simple(0,function()
            if SelectedFood then SelectFoodItem(SelectedFood) end
        end)

        local name_pnl = vgui.Create("DTextEntry", mdl_pnl)
        name_pnl:SetSize(200 * zclib.wM,50 * zclib.hM )
        name_pnl:DockMargin(8 * zclib.wM,2 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
        name_pnl:Dock(TOP)
        name_pnl:SetPaintBackground(false)
        name_pnl:SetAutoDelete(true)
        name_pnl:SetUpdateOnType(true)
        name_pnl.Paint = function(s, w, h)
            //draw.RoundedBox(4, 0, 0, w, h, zclib.colors["ui01"])

            if s:GetText() == "" and not s:IsEditing() then
                draw.SimpleText(zmc.language["Dish Name"], zclib.GetFont("zclib_font_small"), 5 * zclib.wM, h / 2, zclib.colors["white_a15"], 0, 1)
            end

            s:DrawTextEntryText(zclib.colors["orange01"], zclib.colors["textentry"], color_white)
        end
        name_pnl:SetDrawLanguageID(false)
        name_pnl.OnValueChange = function(s,val) DishData.name = val end
        name_pnl:SetTextColor(zclib.colors["orange01"])
        name_pnl:SetValue(DishData.name)
        name_pnl:SetFont(zclib.GetFont("zclib_font_big"))
    end)
end

function zmc.Dishtable.RemoveDish(id)
    if zmc.Dish.GetData(id) == nil then return end
    zmc.vgui.ConfirmationWindow(zmc_main_panel,zmc.language["Delete this Dish?"],function()
        table.remove(zmc.config.Dishs,id)
        zmc.Dishtable.UpdateServer()
        SelectedDish = nil
        zmc.Dishtable.MainMenu()
    end,function()
        // DO nuthin
    end)
end

function zmc.Dishtable.UpdateDish(id)
    zmc.config.Dishs[id] = table.Copy(DishData)
    zmc.Dishtable.UpdateServer()
    zmc.Dishtable.MainMenu()
end

function zmc.Dishtable.CreateDish()
    DishData.uniqueid = zclib.util.GenerateUniqueID("xxxxxxxxxx")
    table.insert(zmc.config.Dishs,DishData)
    zmc.Dishtable.UpdateServer()
    zmc.Dishtable.MainMenu()
end

function zmc.Dishtable.UpdateServer()
    // Send net msg to server
    zclib.Data.UpdateConfig("zmc_dish_config")
    DishData = nil
end

local function BuildClipboard(id)
    local dat = zmc.Dish.GetData(id)
    if dat == nil then return end

    local text = [[zmc.Dish.LoadModule({
    uniqueid = "]] .. dat.uniqueid .. [[",
    name = "]] .. dat.name .. [[",
    mdl = "]] .. dat.mdl .. [[",
    time = ]] .. dat.time .. [[,
    price = ]] .. (dat.price or 0) .. [[,
    items = {
]]
    for k, v in pairs(dat.items) do
        text = text .. [[       {uniqueid = "]] .. v.uniqueid .. [[", lpos = Vector(]] .. math.Round(v.lpos.x,2) .. [[,]] .. math.Round(v.lpos.y,2) .. [[,]] .. math.Round(v.lpos.z,2) .. [[), lang = Angle(]] .. math.Round(v.lang.p,2) .. [[,]] .. math.Round(v.lang.y,2) .. [[,]] .. math.Round(v.lang.r,2) .. [[),scale = ]] .. (v.scale or 1) .. [[},
]]
    end
    text = text .. [[
    }
]]
text = text .. [[
})]]
text = string.Replace(text,[[\]],[[/]])
return text
end

function zmc.Dishtable.Copytoclipboard(id)
    local dat = zmc.Dish.GetData(id)
    if dat == nil then return end

    SetClipboardText( BuildClipboard(id) )

    zclib.vgui.Notify(zmc.language["Config code copied to clipboard!"],NOTIFY_GENERIC)
end

concommand.Add("zmc_GetDishConfig", function(ply, cmd, args)
    if zclib.Player.IsAdmin(ply) then
        local text = ""
        for k,v in pairs(zmc.config.Dishs) do
            text = text .. BuildClipboard(k)

            text = text .. [[


]]
        end
        SetClipboardText( text )
        zclib.vgui.Notify(zmc.language["Config code copied to clipboard!"],NOTIFY_GENERIC)
    end
end)



function zmc.Dishtable.EditWhitelist()
    zmc.vgui.WhitelistEditor(zmc.language["Restrict_Dishes"],DishWhitelist,function()
        DishWhitelist = {}
        zmc.Dishtable.MainMenu()
    end,function()

        local e_String = util.TableToJSON(DishWhitelist)
        local e_Compressed = util.Compress(e_String)
        net.Start("zmc_Dishtable_setwhitelist")
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
            zmc.Dishtable.EditWhitelist()
        end,{},function(id,data)
            if DishWhitelist[tostring(data.uniqueid)] then return true end
        end,function()
            DishWhitelist = table.Merge( DishWhitelist, AddList )
            zmc.Dishtable.EditWhitelist()
        end)

    end,function()
        DishWhitelist = {}
        zmc.Dishtable.EditWhitelist()
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
                zmc.Dishtable.EditWhitelist()
            end
            list:Add(dish_pnl)
        end
    end)
end
