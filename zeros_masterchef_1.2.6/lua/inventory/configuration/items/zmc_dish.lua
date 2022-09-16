local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/props_junk/PopCan01a.mdl")

ITEM:AddAction("Use", 1, function(self, ply, ent, tbl)
    if CLIENT then return true end
    local data = tbl.data


    local DishData = zmc.Dish.GetData(data.DishID)
    if DishData == nil then return end
    if DishData.items == nil then return end
    local foodCount = table.Count(DishData.items)
    if foodCount == 0 then return end
    if data.EatProgress == -1 then data.EatProgress = foodCount end

    for k,v in pairs(DishData.items) do
        if v and v.uniqueid and tbl.data.EatProgress > 0 then
            zmc.Item.Eat(v.uniqueid, ply)
            tbl.data.EatProgress = tbl.data.EatProgress - 1
        end
    end
    zclib.NetEvent.Create("eat_effect", {ply,false})

end, function()
    return true
end)

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
    local data = tbl.data
    local DishID = data.DishID
    local EatProgress = data.EatProgress

    if DishID and zmc.Dish.GetData(DishID) then
        ent:SetDishID(DishID)
        ent:SetEatProgress(EatProgress)
        zclib.Player.SetOwner(ent, ply)

        local dishdata = zmc.Dish.GetData(tbl.data.DishID)
        ent:SetModel(dishdata.mdl)
    else
        SafeRemoveEntity(ent)
    end
end)

ITEM:SetDescription(function(self, tbl)
    local desc = {}
    desc[1] = zmc.language["price_title"] .. ": " .. zclib.Money.Display(zmc.Dish.GetPrice(tbl.data.DishID))

    return desc
end)

function ITEM:GetData(ent)
    return {
        DishID = ent:GetDishID(),
        EatProgress = ent:GetEatProgress()
    }
end

function ITEM:GetDisplayName(item)
    return self:GetName(item)
end

function ITEM:GetName(item)
    local name = "Unkown"
    local ent = isentity(item)
    local DishID

    if ent then
        DishID = item:GetDishID()
    else
        DishID = item.data.DishID
    end

    local data = zmc.Dish.GetData(DishID)

    if data and data.name then
        name = data.name
    end

    return name
end

function ITEM:GetCameraModifiers(tbl)
    return {
        FOV = 30,
        X = 0,
        Y = 0,
        Z = 50,
        Angles = Angle(0, 45, 0),
        Pos = Vector(0, 0, 0)
    }
end

function ITEM:GetClientsideModel(tbl, mdlPanel)

    local data = zmc.Dish.GetData(tbl.data.DishID)
    mdlPanel:SetModel(data.mdl)
    mdlPanel.PostDrawModel = function(s,ent)
        zmc.Dish.DrawFoodItems(mdlPanel.Entity,data,nil,function(food_id)
            return tbl.data.EatProgress ~= -1 and food_id > tbl.data.EatProgress
        end,false)
    end
end


ITEM:Register("zmc_dish")
