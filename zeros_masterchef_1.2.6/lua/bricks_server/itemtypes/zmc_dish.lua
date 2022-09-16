local ITEM = BRICKS_SERVER.Func.CreateItemType("zmc_dish")

ITEM.GetItemData = function(ent)
    if (not IsValid(ent)) then return end
    local itemData = {"zmc_dish", "models/zerochain/props_kitchen/zmc_plate01.mdl", ent:GetDishID(), ent:GetEatProgress()}

    return itemData, 1
end

ITEM.OnSpawn = function(ply, pos, itemData, itemAmount)
    local DishID = itemData[3]
    local EatProgress = itemData[4]

    if DishID and EatProgress and zmc.Dish.GetData(DishID) then
        local ent = zmc.Dish.Spawn(pos,DishID)
        if not IsValid(ent) then return end
        ent:SetEatProgress(EatProgress)
        zclib.Player.SetOwner(ent, ply)
    end
end

ITEM.CanUse = function(ply, itemData) return true end

ITEM.OnUse = function(ply, itemData)
    local DishID = itemData[3]

    if SERVER and zmc.Item.Eat(DishID, ply) then
        zclib.NetEvent.Create("eat_effect", {ply,false})

        return true
    else
        return false
    end
end

ITEM.GetInfo = function(itemData)
    local ItemID = itemData[3]
    local ItemData = zmc.Dish.GetData(ItemID)
    local itemDescription = ""
    local itemtitle = ""

    if ItemData then
        itemtitle = ItemData.name
        itemDescription = zmc.language["price_title"] .. ": " .. zclib.Money.Display(zmc.Dish.GetPrice(ItemID))
    end

    return {itemtitle, itemDescription, ""}
end

ITEM.ModelDisplay = function(Panel, itemtable)
    if (not Panel.Entity or not IsValid(Panel.Entity)) then return end
    local mn, mx = Panel.Entity:GetRenderBounds()
    local size = 0
    size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
    size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
    size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
    Panel:SetFOV(15)
    Panel:SetCamPos(Vector(size, size * 3, size * 2))
    Panel:SetLookAt((mn + mx) * 0.5)
    Panel.Entity:SetAngles(Angle(0, 45, 0))
    local data = zmc.Dish.GetData(itemtable[3])
    local EatProgress = itemtable[4]

    if data then
        Panel:SetModel(data.mdl)

        Panel.PostDrawModel = function(s, ent)
            zmc.Dish.DrawFoodItems(Panel.Entity, data, nil, function(food_id) return EatProgress ~= -1 and food_id > EatProgress end, false)
        end
    end
end

ITEM.CanCombine = function(itemData1, itemData2) return false end
ITEM:Register()

if BRICKS_SERVER and BRICKS_SERVER.CONFIG and BRICKS_SERVER.CONFIG.INVENTORY and BRICKS_SERVER.CONFIG.INVENTORY.Whitelist then
    BRICKS_SERVER.CONFIG.INVENTORY.Whitelist["zmc_dish"] = {false, true}
end
