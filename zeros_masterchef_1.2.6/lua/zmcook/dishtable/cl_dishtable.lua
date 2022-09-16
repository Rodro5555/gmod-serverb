if SERVER then return end
zmc = zmc or {}
zmc.Dishtable = zmc.Dishtable or {}

function zmc.Dishtable.Initialize(Dishtable) end

function zmc.Dishtable.GetNextIngredient(Dishtable)
    local DishData = zmc.Dish.GetData(Dishtable:GetDishID())
    if DishData == nil then return end
    local temp = {}
    for k,v in pairs(DishData.items) do
        table.insert(temp,v.uniqueid)
    end
    local missing = zmc.Inventory.GetMissing(Dishtable, temp)

    if missing[1] == nil then
        Dishtable.NeedItem = false

        return
    end

    local item = missing[1].itm
    Dishtable.NeedItem = zmc.Item.GetName(item)
end

local ui_pos = Vector(-19.7, 0, 36)
local ui_ang = Angle(0, -90, 90)
function zmc.Dishtable.Draw(Dishtable)

    zmc.Dishtable.DrawFood(Dishtable)

    if zclib.Convar.Get("zclib_cl_drawui") ~= 1 then return end

    if zclib.util.InDistance(Dishtable:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_ui) then
        local DishData = zmc.Dish.GetData(Dishtable:GetDishID())
        cam.Start3D2D(Dishtable:LocalToWorld(ui_pos), Dishtable:LocalToWorldAngles(ui_ang), 0.05)

            if DishData and DishData.name then

                if Dishtable.NeedItem == nil then
                    zmc.Dishtable.GetNextIngredient(Dishtable)
                end

                if Dishtable.NeedItem == false then
                    zmc.Machine.DrawTextBox(zmc.language["Ready"],0,0,zclib.colors["orange01"])
                else
                    zmc.Machine.DrawTextBox(string.Replace(zmc.language["Need"],"$ItemName",Dishtable.NeedItem or "Ingredients"),0,0,zclib.colors["orange01"])
                end
            else
                 Dishtable.NeedItem = nil
                zmc.Machine.DrawTextBox(zmc.language["Select Dish"],0,0,zclib.colors["text01"])
            end
        cam.End3D2D()
    end
end

function zmc.Dishtable.Think(Dishtable) end

local plate_pos = Vector(-5,0,39.7)
function zmc.Dishtable.DrawFood(Dishtable)

    if Dishtable.InventoryChanged == true then
        Dishtable.InventoryChanged = nil
        zmc.Dishtable.GetNextIngredient(Dishtable)

        if IsValid(Dishtable.PlateModel) then
            SafeRemoveEntity(Dishtable.PlateModel)
            Dishtable.PlateModel = nil
        end
    end

    if zclib.util.InDistance(Dishtable:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_clientmodels) then

        local DishData = zmc.Dish.GetData(Dishtable:GetDishID())
        if DishData == nil then
            zmc.Dishtable.RemoveClientModels(Dishtable)
            return
        end

        if Dishtable.PlateModel == nil then
            Dishtable.PlateModel = zclib.ClientModel.Add(DishData.mdl or "models/zerochain/props_kitchen/zmc_plate01.mdl")
        end

        render.Model({
            model = DishData.mdl or "models/zerochain/props_kitchen/zmc_plate01.mdl",
            pos = Dishtable:LocalToWorld(plate_pos),
            angle = Dishtable:LocalToWorldAngles(angle_zero)
        }, Dishtable.PlateModel)

        if Dishtable.PlateModel then

            local InInv = table.Copy(zmc.Inventory.Get(Dishtable))
            zmc.Dish.DrawFoodItems(Dishtable.PlateModel,DishData,nil,function(food_id,food_val) end,function(food_id,food_val)

                local isghost = true
                for k,v in pairs(InInv) do
                    if v.itm == food_val then
                        InInv[k] = nil
                        isghost = false
                        break
                    end
                end
                return isghost
            end)
        end
    else
        zmc.Dishtable.RemoveClientModels(Dishtable)
    end
end

function zmc.Dishtable.RemoveClientModels(Dishtable)
    if Dishtable.ClientModels then
        for k,v in pairs(Dishtable.ClientModels) do
            zclib.ClientModel.Remove(v.ent)
        end
    end
    Dishtable.ClientModels = nil

    if Dishtable.PlateModel then
        zclib.ClientModel.Remove(Dishtable.PlateModel)
        Dishtable.PlateModel = nil
    end
end

function zmc.Dishtable.OnRemove(Dishtable)
    zmc.Dishtable.RemoveClientModels(Dishtable)
end
