/////////////////////////
//Zeros MasterCook
//https://www.gmodstore.com/market/view/zero-s-genlab-disease-script

zvm.AllowedItems.Add("zmc_item") // Has CustomData
zvm.AllowedItems.Add("zmc_dish") // Has CustomData
zvm.AllowedItems.Add("zmc_buildkit")
zvm.AllowedItems.Add("zmc_gastank")

local entTable = {
    ["zmc_buildkit"] = true,
    ["zmc_item"] = true,
    ["zmc_dish"] = true,
    ["zmc_gastank"] = true
}

zclib.RenderData.Add("zmc_buildkit", {ang = Angle(0, 270, 0)})
zclib.RenderData.Add("zmc_gastank", {ang = Angle(0, 270, 0)})


hook.Add("zvm_OnPackageItemSpawned", "zvm_OnPackageItemSpawned_ZerosMasterCook", function(ply, ent, extradata)
    if zmc and entTable[ent:GetClass()] then
        zclib.Player.SetOwner(ent, ply)
    end
end)

hook.Add("zvm_OnItemDataCatch", "zvm_OnItemDataCatch_ZerosMasterCook", function(data, ent, itemclass)
    if zmc then
        if itemclass == "zmc_item" then
            data.ItemID = ent:GetItemID()
            data.IsRotten = ent:GetIsRotten()
        elseif itemclass == "zmc_dish" then
            data.DishID = ent:GetDishID()
            data.EatProgress = ent.EatProgress
        end
    end
end)

hook.Add("zvm_OnItemDataApply", "zvm_OnItemDataApply_ZerosMasterCook", function(itemclass, ent, extraData)
    if zmc then
        if itemclass == "zmc_item" then
            ent:SetItemID(extraData.ItemID)
            ent:SetIsRotten(extraData.IsRotten)
            zmc.Item.UpdateVisual(ent,zmc.Item.GetData(extraData.ItemID),true)
        elseif itemclass == "zmc_dish" then

            local DishData = zmc.Dish.GetData(extraData.DishID)
            if DishData and DishData.mdl then
                ent:SetModel(DishData.mdl)
            end

            ent:SetDishID(extraData.DishID)
            ent.EatProgress = extraData.EatProgress
        end
    end
end)

hook.Add("zvm_OnItemDataName", "zvm_OnItemDataName_ZerosMasterCook", function(ent, extraData)

    if zmc then
        local itemclass = ent:GetClass()
        if itemclass == "zmc_item" then
            return zmc.Item.GetName(extraData.ItemID)
        elseif itemclass == "zmc_dish" then
            return zmc.Dish.GetName(extraData.DishID)
        end
    end
end)


hook.Add("zvm_BlockItemCheck", "zvm_BlockItemCheck_ZerosMasterCook", function(ent)
    if zmc then
        local itemclass = ent:GetClass()
        if itemclass == "zmc_item" then
            if ent:GetIsRotten() == true then return true end

            /*
            NOTE Not sure if we should block any item that causes damage on consumption
            local itemData = zmc.Item.GetData(ent:GetItemID())
            if itemData == nil then return true end
            if itemData.edible and itemData.edible.health and itemData.edible.health < 0 then return true end
            */
        elseif itemclass == "zmc_dish" then
            local DishData = zmc.Dish.GetData(ent:GetDishID())
            if DishData == nil then return true end
            if DishData.items == nil then return true end
            local foodCount = table.Count(DishData.items)
            if ent:GetEatProgress() ~= -1 and ent:GetEatProgress() ~= foodCount then return true end
        end
    end
end)


hook.Add("zvm_ItemExists", "zvm_ItemExists_ZerosMasterCook", function(itemclass, compared_item, extraData)
    if zmc then
        if itemclass == "zmc_item" then
            return true, compared_item.extraData.ItemID == extraData.ItemID
        elseif itemclass == "zmc_dish" then
            return true, compared_item.extraData.DishID == extraData.DishID
        end
    end
end)


zclib.Snapshoter.SetPath("zmc_item", function(ItemData) return "zmcook/items/" .. ItemData.extraData.ItemID end)
zclib.Snapshoter.SetPath("zmc_dish", function(ItemData) return "zmcook/dishs/" .. ItemData.extraData.DishID end)

hook.Add("zclib_RenderProductImage","zclib_RenderProductImage_ZerosMasterCook",function(cEnt,ItemData)
    // Lets add the food on the plates before rendering
    if zmc and ItemData.class == "zmc_dish" and ItemData.extraData and ItemData.extraData.DishID then
        local data = zmc.Dish.GetData(ItemData.extraData.DishID)
        if data then zmc.Dish.DrawFoodItems(cEnt,data,nil,nil,false,true) end
    end
end)
