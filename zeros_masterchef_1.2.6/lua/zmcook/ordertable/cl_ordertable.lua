if SERVER then return end
zmc = zmc or {}
zmc.Ordertable = zmc.Ordertable or {}

function zmc.Ordertable.Initialize(Ordertable) end

local RndRot = {}
for i = 1, 12 do RndRot[i] = Angle(0, math.random(0, 360), 0) end
local GridDistance = 18
local ItemScale = 0.5
local function DrawTextField(txt,color,x,y,bar,steamName)
    local txtW = zclib.util.GetTextSize(txt, zclib.GetFont("zclib_font_giant"))
    txtW = txtW + 50

    draw.RoundedBox(16,x -txtW / 2, -50 + y, txtW, 100, zclib.colors["ui01"])
    if bar then
        local abar = txtW * bar
        draw.RoundedBox(8,x -txtW / 2, 55 + y, txtW, 20, zclib.colors["ui01"])
        draw.RoundedBox(8,x -txtW / 2, 55 + y, abar, 20, zclib.util.LerpColor(bar, zclib.colors["red01"], zclib.colors["green01"]))
    end
    draw.SimpleText(txt, zclib.GetFont("zclib_font_giant"), x, y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    if steamName then
        draw.RoundedBox(16,x -txtW / 2, -50 + y + 140, txtW, 50, zclib.colors["ui01"])
        draw.SimpleText(steamName, zclib.GetFont("zclib_font_large"), x, y + 115, zclib.colors["blue01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

local light01_pos = Vector(0,22,64)
local light02_pos = Vector(0,-17,64)

local ui_pos = Vector(-19.7, 0, 35)
local ui_ang = Angle(0, -90, 90)

local ui02_pos = Vector(0, 0, 39.3)
local ui02_ang = Angle(0, -90, 0)

local ui03_pos = Vector(19.7, 0, 35)
local ui03_ang = Angle(0, 90, 90)
function zmc.Ordertable.Draw(Ordertable)

    if zclib.util.InDistance(Ordertable:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_clientmodels) then

        zmc.Ordertable.DrawLightVolume("light01",light01_pos,Ordertable)
        zmc.Ordertable.DrawLightVolume("light02",light02_pos,Ordertable)

        // Rebuild ClientModels
        if Ordertable.InventoryChanged == true then

            if Ordertable.OnTableDummys == nil then Ordertable.OnTableDummys = {} end

            for slot_id,slot_data in pairs(zmc.Inventory.Get(Ordertable)) do
                if slot_data == nil then continue end

                zmc.Ordertable.RemoveDish(Ordertable,slot_id)

                local DishData = zmc.Dish.GetData(slot_data.itm)
                if DishData == nil then
                    continue
                end

                zmc.Ordertable.BuildDish(Ordertable,slot_id,slot_data)
            end

            Ordertable.InventoryChanged = nil
        end

        // Draw ClientModels of Dishes
        if Ordertable.OnTableDummys then
            local x, y = 0, 0

            for k, v in pairs(Ordertable.OnTableDummys) do

                if v and IsValid(v.plate) then
                    zmc.Ordertable.DrawDish(Ordertable,v,x,y)
                end

                x = x + GridDistance
                if x > GridDistance then
                    x = 0
                    y = y + (GridDistance * 1)
                end
            end
        end
    else
        zmc.Ordertable.RemoveClientModels(Ordertable)

        Ordertable.InventoryChanged = true
    end

    if zclib.Convar.Get("zclib_cl_drawui") ~= 1 then return end
    if zclib.util.InDistance(Ordertable:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_ui) then

        cam.Start3D2D(Ordertable:LocalToWorld(ui_pos), Ordertable:LocalToWorldAngles(ui_ang), 0.05)
            //DrawTextField(zmc.language["Customer Happiness:"] .. " " .. Ordertable:GetCustomerRating() .. "%", zclib.colors["text01"], 0, 140)
            DrawTextField(zmc.language["Earnings:"] .. " " .. zclib.Money.Display(Ordertable:GetEarnings()), zclib.colors["text01"], 0, 0)
            //DrawTextField(zmc.language["Custom Orders:"] .. " " .. (Ordertable:GetCustomOrders() and zmc.language["ON"] or zmc.language["OFF"]), zclib.colors["text01"], 0, 360)
        cam.End3D2D()


        local status = Ordertable:GetAcceptOrders() and zmc.language["Open for Business"] or zmc.language["Closed"]
        local status_col = Ordertable:GetAcceptOrders() and zclib.colors["green01"] or zclib.colors["red01"]
        cam.Start3D2D(Ordertable:LocalToWorld(ui03_pos), Ordertable:LocalToWorldAngles(ui03_ang), 0.05)
            DrawTextField(status,status_col,0,0)
        cam.End3D2D()


        if Ordertable.OnTableDummys then
            cam.Start3D2D(Ordertable:LocalToWorld(ui02_pos), Ordertable:LocalToWorldAngles(ui02_ang), 0.025)
                for k, v in pairs(Ordertable.OnTableDummys) do
                    if v and IsValid(v.plate) and v.DishID then
                        local lpos = Ordertable:WorldToLocal(v.plate:GetPos()) / 0.025
                        local SlotData = zmc.Inventory.GetSlotData(Ordertable,k)
                        local DishData = zmc.Dish.GetData(v.DishID)
                        local orderTime = zmc.Dish.GetOrderTime(v.DishID)
                        if DishData then

                            local CountDown
                            if SlotData.time then
                                CountDown = (1 / orderTime) * math.Clamp(orderTime - (CurTime() - SlotData.time),0,orderTime)
                            end

                            local OrderTarget
                            if SlotData.ReadyToGo then
                                OrderTarget = zmc.language["Ready"]
                            else
                                OrderTarget = SlotData.steamName or zmc.language["NPC"]
                            end

                            DrawTextField(DishData.name,zclib.colors["text01"],-lpos.y,-lpos.x + 280,CountDown,OrderTarget)
                        end
                    end
                end
            cam.End3D2D()
        end
    end
end

function zmc.Ordertable.DrawLightVolume(id,pos,Ordertable)

    if Ordertable.LightVolumes == nil then Ordertable.LightVolumes = {} end

    if not IsValid(Ordertable.LightVolumes[id]) then
        local ent = ents.CreateClientProp()
    	if not IsValid(ent) then return end
    	ent:SetModel("models/zerochain/props_kitchen/zwf_light_volume.mdl")
    	ent:SetPos(Ordertable:GetPos())
    	ent:SetAngles(Ordertable:GetAngles())
    	ent:Spawn()
    	ent:Activate()
    	ent:SetParent(Ordertable)
    	ent:SetNoDraw(true)
    	ent:SetRenderMode(RENDERMODE_TRANSALPHA)
    	Ordertable.LightVolumes[id] = ent

        local scale = Vector(0.4,0.5,0.2)
        local mat = Matrix()
        mat:Scale(scale)
        ent:EnableMatrix("RenderMultiply", mat)
        ent:SetColor(zclib.colors["light_color"])
    else
        if Ordertable:GetAcceptOrders() then
            if zclib.Convar.Get("zmc_vfx_dynamiclight") == 1 then
                local dlight = DynamicLight(Ordertable:EntIndex() + pos:Length())
                if (dlight) then
                    dlight.pos = Ordertable:LocalToWorld( pos - Vector(0,0,5) )
                    dlight.r = zclib.colors["light_color"].r
                    dlight.g = zclib.colors["light_color"].g
                    dlight.b = zclib.colors["light_color"].b
                    dlight.brightness = 5
                    dlight.style = 0
                    dlight.Decay = 1000
                    dlight.Size = 128
                    dlight.DieTime = CurTime() + 1
                end
            end

            Ordertable.LightVolumes[id]:SetPos(Ordertable:LocalToWorld(pos))
            Ordertable.LightVolumes[id]:SetNoDraw(false)
        else
            if Ordertable.LightVolumes[id]:GetNoDraw() == false then
                Ordertable.LightVolumes[id]:SetNoDraw(true)
            end
        end
    end
end

local plate_ang = Angle(0, 90, 0)
function zmc.Ordertable.DrawDish(Ordertable,dish,x,y)
    dish.plate:SetPos(Ordertable:LocalToWorld(Vector(x - 6, y - 27.5, 39.2)))
    dish.plate:SetAngles(Ordertable:LocalToWorldAngles(plate_ang))

    zmc.Dish.DrawFoodItems(dish.plate,zmc.Dish.GetData(dish.dishid),nil,nil,function() return dish.ReadyToGo == nil end)
end

function zmc.Ordertable.BuildDish(Ordertable,slot_id,slot_data)
    local DishData = zmc.Dish.GetData(slot_data.itm)

    if Ordertable.OnTableDummys[slot_id] == nil then Ordertable.OnTableDummys[slot_id] = {} end

    Ordertable.OnTableDummys[slot_id].DishID = slot_data.itm
    Ordertable.OnTableDummys[slot_id].ReadyToGo = slot_data.ReadyToGo

    local plate = zclib.ClientModel.AddProp()
    if not IsValid(plate) then return end
    plate:SetModel(DishData.mdl or "models/zerochain/props_kitchen/zmc_plate01.mdl")
    plate:SetRenderMode(RENDERMODE_NORMAL)
    plate:SetModelScale(ItemScale)

    plate:CallOnRemove("zmc_remove_food_items",function(ent)
        zmc.Dish.RemoveClientModels(ent)
    end)

    if slot_data.ReadyToGo == nil then
        plate:SetColor(color_white)
        plate:SetMaterial("zerochain/zmc/shader/ghost_mat")
    end

    Ordertable.OnTableDummys[slot_id].plate = plate
    Ordertable.OnTableDummys[slot_id].dishid = slot_data.itm
end

function zmc.Ordertable.RemoveDish(Ordertable,slot)
    local dish = Ordertable.OnTableDummys[slot]
    if dish then
        zclib.ClientModel.Remove(dish.plate)
        Ordertable.OnTableDummys[slot] = nil
    end
end

function zmc.Ordertable.Think(Ordertable) end

function zmc.Ordertable.RemoveClientModels(Ordertable)
    if Ordertable.OnTableDummys then

        for slot_id,slot_data in pairs(zmc.Inventory.Get(Ordertable)) do
            if slot_data == nil then continue end

            zmc.Ordertable.RemoveDish(Ordertable,slot_id)
        end

        Ordertable.OnTableDummys = nil
    end

    if Ordertable.LightVolumes then
        for k,v in pairs(Ordertable.LightVolumes) do
            zclib.ClientModel.Remove(v)
        end
        Ordertable.LightVolumes = nil
    end
end

function zmc.Ordertable.OnRemove(Ordertable)
    zmc.Ordertable.RemoveClientModels(Ordertable)
end

// This hook gets called when the client receives a inventory update from one of the entities
zclib.Hook.Add("zmc_OnInventorySynch", "zmc_OnInventorySynch_Ordertable", function(ent)
    if IsValid(ent) and ent.zmc_inv then
        // NOTE This is special but if the inventory is actully from the ordertable and it has a player who ordered it then lets catch his name
        for k, v in pairs(ent.zmc_inv) do
            if v and v.ply and v.steamName == nil then
                steamworks.RequestPlayerInfo(v.ply, function(steamName)
                    v.steamName = steamName
                end)
            end
        end
    end
end)
