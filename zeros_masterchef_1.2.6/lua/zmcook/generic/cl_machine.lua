if SERVER then return end

/*

    Creates a VGUI for machines which have identic UIs
    Provides a VGUI for machines which mix multiple Items together in order to create a new Item
    Used for Mixer, Wok, SoupPot

*/

zmc = zmc or {}
zmc.Machine = zmc.Machine or {}

local MachineTypeSelector = {
    ["zmc_mixer"] = "Mix",
    ["zmc_wok"] = "Mix",
    ["zmc_souppot"] = "Mix",

    ["zmc_oven"] = "Heat",
    ["zmc_grill"] = "Heat",
    ["zmc_boilpot"] = "Heat",
}

local SelectedItem
zmc.Machine.Mix = {

    Init = function()
        if zmc.vgui.ActiveEntity:GetItemID() > 0 then
            zmc.Machine.Mix.CookRecipe()
        else
            zmc.Machine.Mix.SelectRecipe()
        end
    end,

    SelectRecipe = function()

        zmc.vgui.Page(zmc.language[zmc.vgui.ActiveEntity.PrintName],function(main,top)

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

            local select_button_font = zclib.util.FontSwitch( zmc.language["Choose Recipe"],300 * zclib.wM,zclib.GetFont("zclib_font_big"),zclib.GetFont("zclib_font_medium"))
            local select_button = zclib.vgui.TextButton(0,0,300,50,top,{Text01 = zmc.language["Choose Recipe"],txt_font = select_button_font},function()

                if SelectedItem == nil then return end

                net.Start("zmc_machine_selectrecipe")
                net.WriteEntity(zmc.vgui.ActiveEntity)
                net.WriteUInt(SelectedItem,16)
                net.SendToServer()

                select_button:SetDisabled(true)
            end,function()
                return SelectedItem == nil
            end)

            select_button:Dock(RIGHT)
            select_button:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)


            local list,scroll = zmc.vgui.List(main)
            scroll:DockMargin(50 * zclib.wM,5 * zclib.hM,50 * zclib.wM,10 * zclib.hM)
            scroll.Paint = function(s, w, h) draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"]) end
            main.ItemList = scroll

            local itmW,itmH = main:GetWide() / 4,main:GetTall() / 3
            itmW = itmW + 3
            itmH = itmH - 20

            for id, data in pairs(zmc.config.Items) do

                if data[zmc.vgui.ActiveEntity.Component] == nil then continue end

                local item_pnl = zmc.vgui.Slot(data,function()

                    //IsSelected
                    return SelectedItem == id
                end,function()

                    // CanSelect
                    return true
                end,function()

                    // OnSelect
                    SelectedItem = id
                end,function()

                    // PreDraw
                end,function(w,h)

                    // PostDraw
                end)
                list:Add(item_pnl)
                item_pnl.font_name = zclib.GetFont("zclib_font_small")
            end
        end)
    end,

    CookRecipe = function()
        //[BUG] This can be nil if the client has not yet recieved the item id
        local ItemData = zmc.Item.GetData(zmc.vgui.ActiveEntity:GetItemID())

        zmc.vgui.Page(ItemData.name or zmc.language[zmc.vgui.ActiveEntity.PrintName],function(main,top)

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

            local cancel_button_font = zclib.util.FontSwitch(zmc.language["Cancel"],160 * zclib.wM,zclib.GetFont("zclib_font_big"),zclib.GetFont("zclib_font_medium"))
            local cancel_button = zclib.vgui.TextButton(0,0,160,50,top,{Text01 = zmc.language["Cancel"],txt_font = cancel_button_font},function()
                net.Start("zmc_machine_cancel")
                net.WriteEntity(zmc.vgui.ActiveEntity)
                net.SendToServer()
                cancel_button:SetDisabled(true)
            end,function()
                return false
            end)
            cancel_button:Dock(RIGHT)
            cancel_button:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)

            local start_button_font = zclib.util.FontSwitch(zmc.language["Start"],160 * zclib.wM,zclib.GetFont("zclib_font_big"),zclib.GetFont("zclib_font_medium"))
            local start_button = zclib.vgui.TextButton(0,0,160,50,top,{Text01 = zmc.language["Start"],txt_font = start_button_font},function()
                if ItemData == nil then return end
                local MissingIngredients = zmc.Inventory.GetMissing(zmc.vgui.ActiveEntity,ItemData[zmc.vgui.ActiveEntity.Component].items)
                if table.IsEmpty(MissingIngredients) then
                    net.Start("zmc_machine_start")
                    net.WriteEntity(zmc.vgui.ActiveEntity)
                    net.SendToServer()
                    start_button:SetDisabled(true)
                else
                    zclib.vgui.Notify(zmc.language["MissingIngredients"],NOTIFY_ERROR)
                end
            end,function()
                return false// zmc.Inventory.SelectedItem == nil
            end)
            start_button:Dock(RIGHT)
            start_button:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)


            local MissingIngredients = zmc.Inventory.GetMissing(zmc.vgui.ActiveEntity,ItemData[zmc.vgui.ActiveEntity.Component].items)
            local alist,ascroll = zmc.vgui.List(main)
            alist:DockMargin(10 * zclib.wM,45 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
            ascroll:SetTall(305 * zclib.hM)
            ascroll:DockMargin(50 * zclib.wM,5 * zclib.hM,50 * zclib.wM,10 * zclib.hM)
            ascroll:Dock(TOP)
            ascroll.IsReady = false
            ascroll.Paint = function(s, w, h)
                draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
                if s.IsReady then
                    draw.SimpleText(zmc.language["Ready"], zclib.GetFont("zclib_font_huge"), w / 2,h / 2,zclib.colors["green01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                else
                    draw.SimpleText(zmc.language["Missing Ingredients:"], zclib.GetFont("zclib_font_medium"), 10 * zclib.wM,20 * zclib.hM,zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end
            end
            main.MissingIngredientsList = ascroll

            main.MissingIngredientsList.UpdateItem = function(selfi,slot_id,slot_data)
                if slot_data == nil then return end

                local _ItemData = zmc.Item.GetData(slot_data.itm)

                if main.MissingIngredientsList.Items == nil then main.MissingIngredientsList.Items = {} end
                local item_pnl = main.MissingIngredientsList.Items[slot_id]

                if not IsValid(item_pnl) then
                    item_pnl = zmc.vgui.Slot(_ItemData,function()
                        //IsSelected
                        return false
                    end,function(itmDat)
                        // CanSelect
                        return false
                    end,function()
                        // OnSelect
                    end,function(w,h,s,itmDat)
                        // PreDraw
                    end,function(w,h)
                        // PostDraw
                    end)
                    item_pnl:SetSize(139 * zclib.wM, 120 * zclib.hM)
                    alist:Add(item_pnl)
                    main.MissingIngredientsList.Items[slot_id] = item_pnl
                else
                    item_pnl:UpdateModel(_ItemData)
                end
            end

            // Show which items we need
            main.OnInventoryChanged = function()
                MissingIngredients = zmc.Inventory.GetMissing(zmc.vgui.ActiveEntity,ItemData[zmc.vgui.ActiveEntity.Component].items)
                if table.IsEmpty(MissingIngredients) then
                    ascroll.IsReady = true
                else
                    ascroll.IsReady = false
                end
                for slot_id, slot_data in pairs(MissingIngredients) do main.MissingIngredientsList:UpdateItem(slot_id,slot_data) end

                // Do we already have the inventory build?
                if not IsValid(main.Inventory) then return end

                // Update items
                main.Inventory:Update(zmc.Inventory.Get(zmc.vgui.ActiveEntity))
            end

            // Update lists
            main:OnInventoryChanged()

            // Build Inventory
            zmc.Inventory.VGUI(main,zmc.Inventory.Get(zmc.vgui.ActiveEntity),function(data)
                return true
            end,function(slot_id)
            end,function(w,h,s,itmDat)
            end,nil,{SizeW = 138,SizeH = 136, ShowDropButton = true})
        end)
    end,
}

zmc.Machine.Heat = {
    Init = function()
        zmc.vgui.Page(zmc.language[zmc.vgui.ActiveEntity.PrintName],function(main,top)

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

            main.OnInventoryChanged = function()

                // Do we already have the inventory build?
                if not IsValid(main.Inventory) then return end


                // Update items
                main.Inventory:Update(zmc.Inventory.Get(zmc.vgui.ActiveEntity))
            end

            local temp = zmc.vgui.ActiveEntity:GetTemperatur()
            local temp_slider = zmc.vgui.TitledSlider(top,zmc.language["Temperature"],(1 / 100) * zmc.vgui.ActiveEntity:GetTemperatur(),function(val)
                temp = math.Round(100 * val)
            end,50,function(val)
                net.Start("zmc_machine_changetemperatur")
                net.WriteEntity(zmc.vgui.ActiveEntity)
                net.WriteUInt(math.Round(100 * val),16)
                net.SendToServer()
            end,0.40,0.40)
            temp_slider:SetWide(450 * zclib.wM)
            temp_slider:Dock(RIGHT)
            temp_slider:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
            temp_slider.displayValue = function(s) return math.Round(100 * s.slideValue) .. "°" end


            // Build Inventory
            local scroll = zmc.Inventory.VGUI(main,zmc.Inventory.Get(zmc.vgui.ActiveEntity),function(data)
                return true
            end,function(slot_id)
            end,function(w,h,s,ItemData)

                // Does the component has a temperatur subcomponent
                if ItemData[zmc.vgui.ActiveEntity.Component] and ItemData[zmc.vgui.ActiveEntity.Component].temp then
                    // Do we have the correct temperatur to cook the item?
                    if zmc.Machine.TemperaturCheck(ItemData[zmc.vgui.ActiveEntity.Component], temp) then
                        //draw.RoundedBox(5, 5 * zclib.wM,5 * zclib.hM,40 * zclib.wM,40 * zclib.hM, zclib.colors["green01"])
                        surface.SetDrawColor(zclib.colors["green01"])
                    else
                        //draw.RoundedBox(5, 5 * zclib.wM,5 * zclib.hM,40 * zclib.wM,40 * zclib.hM, zclib.colors["red01"])
                        surface.SetDrawColor(zclib.colors["red01"])
                    end
                    //surface.SetDrawColor(zclib.colors["black_a200"])
                    surface.SetMaterial(zclib.Materials.Get("icon_hot"))
                    surface.DrawTexturedRectRotated(30 * zclib.wM,30 * zclib.hM,60 * zclib.wM,60 * zclib.hM,0)
                end
            end,function(w,h,s,ItemData)

                if s.slot_data and s.slot_data[zmc.vgui.ActiveEntity.Component .. "_prog"] and ItemData[zmc.vgui.ActiveEntity.Component] and ItemData[zmc.vgui.ActiveEntity.Component].time then
                    local prog = s.slot_data[zmc.vgui.ActiveEntity.Component .. "_prog"]
                    draw.RoundedBox(2, 0 * zclib.wM, h - 5 * zclib.hM, (w / ItemData[zmc.vgui.ActiveEntity.Component].time) * prog, 5 * zclib.hM, zclib.colors["green01"])
                end
            end,{SizeW = 212,SizeH = 195, ShowDropButton = true})
            scroll:DockMargin(50 * zclib.wM,5 * zclib.hM,50 * zclib.wM,5 * zclib.hM)
        end)
    end,
}

net.Receive("zmc_machine_open", function(len)
    zclib.Debug_Net("zmc_machine_open", len)
    zmc.vgui.ActiveEntity = net.ReadEntity()
    zmc.Machine[MachineTypeSelector[zmc.vgui.ActiveEntity:GetClass()]].Init()
end)

net.Receive("zmc_machine_cancel", function(len)
    zclib.Debug_Net("zmc_machine_cancel", len)

    local machine = net.ReadEntity()

    // If any other player got the ui open then auto change to the cook menu
    if IsValid(machine) and IsValid(zmc.vgui.ActiveEntity) and machine == zmc.vgui.ActiveEntity then
        zmc.Machine[MachineTypeSelector[machine:GetClass()]].SelectRecipe()
    end
end)

net.Receive("zmc_machine_selectrecipe", function(len)
    zclib.Debug_Net("zmc_machine_selectrecipe", len)

    local machine = net.ReadEntity()

    // [BUG] This somehow causes a error?
    // NOTE I need to test if this problem only occurs if multiple players are using the same machine?
    // NOTE This should not really exist since we already delay the call of that net message on the server by timer.Simple(0.05
    // FIX I added zmc.config.NetDelay to let them increase the delay
    /*
         [zeros_masterchef_1.0.7] addons / zeros_masterchef_1.0.7 / lua / zmcook / generic / cl_machine.lua: 108: attempt to local index 'ItemData' (a nil value)
             1. CookRecipe - addons / zeros_masterchef_1.0.7 / lua / zmcook / generic / cl_machine.lua: 108
                 2.func - addons / zeros_masterchef_1.0.7 / lua / zmcook / generic / cl_machine.lua: 325
                    3.unknown - lua / includes / extensions / net.lua: 32 (x4)
    */

    // If any other player got the ui open then auto change to the cook menu
    if IsValid(machine) and IsValid(zmc.vgui.ActiveEntity) and machine == zmc.vgui.ActiveEntity then
        zmc.Machine[MachineTypeSelector[machine:GetClass()]].CookRecipe()
    end
end)


net.Receive("zmc_machine_start", function(len)
    zclib.Debug_Net("zmc_machine_start", len)

    local machine = net.ReadEntity()

    // If any other player got the ui open then auto change to the cook menu
    if IsValid(machine) and IsValid(zmc.vgui.ActiveEntity) and machine == zmc.vgui.ActiveEntity then
        zmc_main_panel:Close()
    end
end)

function zmc.Machine.GetNextIngredient(Machine)
    local ItemData = zmc.Item.GetData(Machine:GetItemID())
    if ItemData == nil then return end
    local missing = zmc.Inventory.GetMissing(Machine,ItemData[Machine.Component].items)
    if missing[1] == nil then
        Machine.NeedItem = false
        return
    end
    local item = missing[1].itm
    Machine.NeedItem = zmc.Item.GetName(item)
end

function zmc.Machine.DrawTextBox(txt,x,y,color)
    draw.RoundedBox(16, x-235, y-50, 470, 100, zclib.colors["ui01"])

    local font = zclib.GetFont("zclib_font_giant")
    if zclib.util.GetTextSize(txt,zclib.GetFont("zclib_font_giant")) < 470 then
        font = zclib.GetFont("zclib_font_giant")
    elseif zclib.util.GetTextSize(txt,zclib.GetFont("zclib_font_large")) < 470 then
        font = zclib.GetFont("zclib_font_large")
    elseif zclib.util.GetTextSize(txt,zclib.GetFont("zclib_font_big")) < 470 then
        font = zclib.GetFont("zclib_font_big")
    elseif zclib.util.GetTextSize(txt,zclib.GetFont("zclib_font_medium")) < 470 then
        font = zclib.GetFont("zclib_font_medium")
    end

    draw.SimpleText(txt, font, x, y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local ui_pos = Vector(-19.7,0, 35)
local ui_ang = Angle(0, -90, 90)
function zmc.Machine.DrawStatus(Machine,pos,ang)
    if zclib.Convar.Get("zclib_cl_drawui") ~= 1 then return end
    if Machine.InventoryChanged == true then
        Machine.InventoryChanged = nil
        zmc.Machine.GetNextIngredient(Machine)
    end

    local ItemData = zmc.Item.GetData(Machine:GetItemID())

    cam.Start3D2D(Machine:LocalToWorld(pos or ui_pos), Machine:LocalToWorldAngles(ang or ui_ang), 0.05)

        if ItemData and ItemData[Machine.Component] then

            if Machine.NeedItem == nil then
                zmc.Machine.GetNextIngredient(Machine)
            end

            if Machine.NeedItem == false then
                zmc.Machine.DrawTextBox(zmc.language["Ready"],0,0,zclib.colors["orange01"])
            else
                zmc.Machine.DrawTextBox(string.Replace(zmc.language["Need"],"$ItemName",Machine.NeedItem or "Ingredients"),0,0,zclib.colors["orange01"])
            end

        else
            zmc.Machine.DrawTextBox(zmc.language["Choose Recipe"],0,0,zclib.colors["text01"])
        end
    cam.End3D2D()
end

function zmc.Machine.DrawTemperatur(Machine)
    if zclib.Convar.Get("zclib_cl_drawui") ~= 1 then return end
    if zclib.util.InDistance(Machine:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_ui) == false then return end

    local temp = Machine:GetTemperatur()
    cam.Start3D2D(Machine:LocalToWorld(ui_pos), Machine:LocalToWorldAngles(ui_ang), 0.05)
        draw.RoundedBox(16, -375, -50,750, 100, zclib.colors["ui01"])
        draw.SimpleText(zmc.language["Temperature"] .. ": " .. temp .. "°", zclib.GetFont("zclib_world_font_giant"), 0, 0, zclib.colors["text01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end

local fuel_ui_pos = Vector(-12, 0, 6)
local fuel_ui_ang = Angle(0,-90,0)
function zmc.Machine.DrawFuel(Machine)
    if zclib.Convar.Get("zclib_cl_drawui") ~= 1 then return end
    if zclib.util.InDistance(Machine:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_ui) == false then return end

    if Machine.GetFuel and zmc.config.Gastank.enabled == true then
        cam.Start3D2D(Machine:LocalToWorld(fuel_ui_pos), Machine:LocalToWorldAngles(fuel_ui_ang), 0.05)
            draw.RoundedBox(16, -200, -50, 400, 100, zclib.colors["ui01"])

            local wbar = (400 / zmc.config.Gastank.fuel) * Machine:GetFuel()
            draw.RoundedBox(16, -200, -50, wbar, 100, zclib.colors["fuel"])
            //draw.SimpleText("Fuel", zclib.GetFont("zclib_font_huge"), -100, 0, zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            surface.SetDrawColor(zclib.colors["text01"])
            surface.SetMaterial(zclib.Materials.Get("icon_hot"))
            surface.DrawTexturedRectRotated(-150, 0, 100, 100, 0)
        cam.End3D2D()
    end
end

// Draws the processed items for grill and oven
function zmc.Machine.DrawHeatedItems(Machine,OnProcess,OnDraw)

    if zclib.util.InDistance(Machine:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_clientmodels) then
        if Machine.OnTableDummys == nil or Machine.InventoryChanged == true then
            if Machine.OnTableDummys == nil then
                Machine.OnTableDummys = {}
            end

            for slot_id, slot_data in pairs(zmc.Inventory.Get(Machine)) do
                if slot_data == nil then continue end
                local ItemData = zmc.Item.GetData(slot_data.itm)

                if ItemData == nil then
                    if IsValid(Machine.OnTableDummys[slot_id]) then
                        zclib.ClientModel.Remove(Machine.OnTableDummys[slot_id])
                    end

                    continue
                end

                local ent

                if IsValid(Machine.OnTableDummys[slot_id]) then
                    ent = Machine.OnTableDummys[slot_id]
                else
                    ent = zclib.ClientModel.AddProp()
                end

                if not IsValid(ent) then continue end

                zmc.Item.UpdateVisual(ent, ItemData, false)

                Machine.OnTableDummys[slot_id] = ent

                zclib.Entity.RelativeScale(ent,Machine,0.15)

                pcall(OnProcess,ent,ItemData,slot_data)
            end

            Machine.InventoryChanged = nil
        end

        if Machine.OnTableDummys then
            local x, y = 0, 0

            for k, v in pairs(Machine.OnTableDummys) do
                if IsValid(v) then
                    pcall(OnDraw,v,x,y)
                end

                local rad = 13
                x = rad * math.sin(k * 4)
                y = rad * math.cos(k * 4)
            end
        end
    else

        if Machine.OnTableDummys then
            for k, v in pairs(Machine.OnTableDummys) do
                if not IsValid(v) then continue end
                zclib.ClientModel.Remove(v)
            end
        end

        Machine.InventoryChanged = true
    end
end

//////////////////////////////////////////////////////
function zmc.Machine.HasEffect(Machine,effect)
    return Machine[effect] ~= nil
end

function zmc.Machine.KillEffect(Machine,effect,attach_ent)
    if zmc.Machine.HasEffect(Machine,effect) then
        if IsValid(attach_ent) then attach_ent:StopParticlesNamed(effect) end
        Machine[effect] = nil
    end
end

function zmc.Machine.CreateEffect(Machine,effect,amount,attach_ent,attach_id)
    if zclib.util.InDistance(Machine:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_effect) == false then return end

    if zmc.Machine.HasEffect(Machine,effect) == false and amount > 0 and IsValid(attach_ent) then
        for i = 1, amount do
            zclib.Effect.ParticleEffectAttach(effect, PATTACH_POINT_FOLLOW, attach_ent, attach_id)
        end

        Machine[effect] = true
    end
end

function zmc.Machine.DrawEffect(Machine,effect,amount,attach_ent,attach_id)
    if zclib.util.InDistance(Machine:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_effect) then
        zmc.Machine.CreateEffect(Machine,effect,amount,attach_ent,attach_id)
    else
        zmc.Machine.KillEffect(Machine,effect,attach_ent)
    end
end
//////////////////////////////////////////////////////

function zmc.Machine.OnRemove(Machine)
    zmc.Machine.KillEffect(Machine,"zmc_heat_flame_small",Machine)

    if Machine.OnTableDummys then
        for k, v in pairs(Machine.OnTableDummys) do
            if not IsValid(v) then continue end
            zclib.ClientModel.Remove(v)
        end
    end
end

function zmc.Machine.OnReDraw(Machine)

    zmc.Machine.KillEffect(Machine,"zmc_heat_flame_small",Machine)
    zmc.Machine.CreateEffect(Machine,"zmc_heat_flame_small",math.Clamp(math.Round((5 / 100) * Machine.LastTemperatur),Machine.LastTemperatur <= 0 and 0 or 1,5),Machine,1)

    if Machine.OnReDraw then
        Machine:OnReDraw()
    end
end

function zmc.Machine.DrawHeat(Machine,temp,matID,matPath,matIndex,lightpos)

    if Machine.LastTemperatur ~= temp then
        Machine.LastTemperatur = temp

        zmc.Machine.KillEffect(Machine,"zmc_heat_flame_small",Machine)
        zmc.Machine.CreateEffect(Machine,"zmc_heat_flame_small",math.Clamp(math.Round((5 / 100) * Machine.LastTemperatur),Machine.LastTemperatur <= 0 and 0 or 1,5),Machine,1)

        if Machine.OnTemperaturChange then
            Machine:OnTemperaturChange(temp)
        end
    end

    zmc.Machine.DrawEffect(Machine,"zmc_heat_flame_small",math.Clamp(math.Round((5 / 100) * Machine.LastTemperatur),Machine.LastTemperatur <= 0 and 0 or 1,5),Machine,1)

    zmc.Machine.DrawFuel(Machine)

    if zclib.util.InDistance(Machine:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_generic) then

        Machine.SmoothTemperatur = Lerp(1 * FrameTime(),Machine.SmoothTemperatur or 0,Machine.LastTemperatur)

        if math.abs(Machine.SmoothTemperatur - Machine.LastTemperatur) > 0.1 then
            zmc.Machine.UpdateHeatMaterial(Machine,matID,matPath,matIndex,Machine.SmoothTemperatur)
        end

        if Machine.LastDraw and CurTime() > (Machine.LastDraw + 0.1) then
            // Update the material once it gets drawn
            zmc.Machine.UpdateHeatMaterial(Machine,matID,matPath,matIndex,Machine.SmoothTemperatur)
            zmc.Machine.OnReDraw(Machine)
        end
        Machine.LastDraw = CurTime()
    else
        Machine.LastTemperatur = -1
    end

    zmc.Machine.DrawDynamicLight(Machine,lightpos,Machine.HeatColor or color_black)
end

function zmc.Machine.DrawDynamicLight(Machine,pos,col)
    if zclib.Convar.Get("zmc_vfx_dynamiclight") ~= 1 then return end

    if zclib.util.InDistance(Machine:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_dynamiclight) == false then return end

    if (Machine.SmoothTemperatur or 1) <= 0.1 then return end

    // Dont even create a DynamicLight if we have black as a color
    if (col.r + col.g + col.b) <= 0 then return end

    local dlight = DynamicLight(Machine:EntIndex())
    if (dlight) then
        dlight.pos = Machine:LocalToWorld( pos )
        dlight.r = col.r
        dlight.g = col.g
        dlight.b = col.b
        dlight.brightness = (2 / 100) * (Machine.SmoothTemperatur or 100)
        dlight.style = 0
        dlight.Decay = 1000
        dlight.Size = (128 / 100) * (Machine.SmoothTemperatur or 100)
        dlight.DieTime = CurTime() + 1
    end
end

local envmaptint = Vector(0.04, 0.04, 0.04)
local phongfresnelranges = Vector(1, 4, 6)
local phongtint = Vector(1, 1, 1)
local emissiveBlendScrollVector = Vector(0,0)
function zmc.Machine.UpdateHeatMaterial(Machine,matID,matPath,matIndex,temp)
    if zclib.util.InDistance(Machine:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_generic) == false then return end

    if Machine.HeatMaterial == nil then
        Machine.HeatMaterial = CreateMaterial(matID, "VertexLitGeneric", {

            ["$basetexture"] = matPath .. "_diff",
            ["$halflambert"] = 1,
            ["$model"] = 1,

            ["$bumpmap"] = matPath .. "_nrm",
            ["$normalmapalphaenvmapmask"] = 1,

            ["$envmap"] = "env_cubemap",
            ["$envmaptint"] = envmaptint,
            ["$envmapfresnel"] = 0.04,

            ["$phong"] = 1,
            ["$phongexponent"] = 5,
            ["$phongboost"] = 1,
            ["$phongfresnelranges"] = phongfresnelranges,
            ["$phongtint"] = phongtint,

            ["$rimlight"] = 1,
            ["$rimlightexponent"] = 25,
            ["$rimlightboost"] = 0.1,

            ["$emissiveBlendEnabled"] = 1,
            ["$emissiveBlendTexture"] = "zerochain/props_kitchen/null",
            ["$emissiveBlendBaseTexture"] = matPath .. "_em",
            ["$emissiveBlendFlowTexture"] = "zerochain/props_kitchen/null",
            ["$emissiveBlendTint"] = phongtint,
            ["$emissiveBlendStrength"] = 1,
            ["$emissiveBlendScrollVector"] = emissiveBlendScrollVector,
        })
    end
    local m_material = Machine.HeatMaterial

    m_material:SetInt("$halflambert", 1)
    m_material:SetInt("$model", 1)
    m_material:SetTexture("$bumpmap", matPath .. "_nrm")
    m_material:SetInt("$normalmapalphaenvmapmask", 1)

    m_material:SetVector("$envmaptint", envmaptint)
    m_material:SetFloat("$envmapfresnel", 0.04)

    m_material:SetInt("$phong", 1)
    m_material:SetFloat("$phongexponent", 5)
    m_material:SetFloat("$phongboost",1)
    m_material:SetVector("$phongfresnelranges", phongfresnelranges)
    m_material:SetVector("$phongtint", phongtint)

    m_material:SetInt("$rimlight", 1)
    m_material:SetFloat("$rimlightexponent", 25)
    m_material:SetFloat("$rimlightboost", 0.1)


    // $model + $envmapmode + $normalmapalphaenvmapmask + $opaquetexture + $softwareskin + $halflambert
    m_material:SetInt("$flags", 2048 + 33554432 + 4194304 + 16777216 + 8388608)

    local fract = (1 / 100) * temp
    Machine.HeatColor = zclib.util.LerpColor(fract, zclib.colors["heat01"], zclib.colors["heat02"])
    m_material:SetFloat("$emissiveBlendStrength", fract)
    m_material:SetVector("$emissiveBlendTint", zclib.util.ColorToVector(Machine.HeatColor))

    Machine:SetSubMaterial(matIndex, "!" .. matID)
end


function zmc.Machine.AnimateValue(Machine,delay,time,val01,val02,easeIn,easeOut)
    local f_fract = math.Clamp(CurTime() - (Machine.LastIneraction + delay),0,time)
    f_fract = math.EaseInOut( (1 / time) * f_fract,easeIn,easeOut )
    local final
    if f_fract > 0.5 then
        f_fract = (1 / 0.5) * (f_fract - 0.5)
        if isvector(val02) then
            final = LerpVector(f_fract,val02,val01)
        else
            final = LerpAngle(f_fract,val02,val01)
        end
    else
        f_fract = (1 / 0.5) * f_fract
        if isvector(val02) then
            final = LerpVector(f_fract,val01,val02)
        else
            final = LerpAngle(f_fract,val01,val02)
        end
    end
    return final
end
