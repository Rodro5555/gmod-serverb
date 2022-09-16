/////////////////////////
//Zeros Oilrush
//https://www.gmodstore.com/market/view/5387

zvm.AllowedItems.Add("zrush_barrel") // Has CustomData
zvm.AllowedItems.Add("zrush_machinecrate")
zvm.AllowedItems.Add("zrush_palette")
zvm.AllowedItems.Add("zrush_drillpipe_holder")

zclib.RenderData.Add("zrush_barrel", {pos = Vector(0,0,3)})

local zrush_entTable = {
    ["zrush_barrel"] = true,
    ["zrush_machinecrate"] = true,
    ["zrush_palette"] = true,
    ["zrush_drillpipe_holder"] = true,
}
hook.Add("zvm_OnPackageItemSpawned", "zvm_OnPackageItemSpawned_ZerosOilRush", function(ply, ent,extradata)
    if zrush and zrush_entTable[ent:GetClass()] then
        zclib.Player.SetOwner(ent, ply)
    end
end)

hook.Add("zvm_OnItemDataCatch", "zvm_OnItemDataCatch_ZerosOilRush", function( data,ent,itemclass)

    if zrush and itemclass == "zrush_barrel" then
        local oil = ent:GetOil()
        local fuel = ent:GetFuel()
        local FuelTypeID = ent:GetFuelTypeID()

        if oil > 0 then
            data.oil = oil
        elseif fuel > 0 then
            data.fuel = fuel
            data.FuelTypeID = FuelTypeID
        end
    end
end)

hook.Add("zvm_OnItemDataApply", "zvm_OnItemDataApply_ZerosOilRush", function( itemclass, ent, extraData)

    if zrush and itemclass == "zrush_barrel" then
        if extraData.oil then
            ent:SetOil(extraData.oil)
        elseif extraData.fuel then
            ent:SetFuel(extraData.fuel)
            ent:SetFuelTypeID(extraData.FuelTypeID)
        end

        zrush.Barrel.UpdateVisual(ent)
    end
end)

hook.Add("zvm_OnItemDataName", "zvm_OnItemDataName_ZerosOilRush", function(ent,extraData)
    if zrush and ent:GetClass() == "zrush_barrel" then

        if extraData.oil then
            return "Oil Barrel"
        elseif extraData.fuel and extraData.FuelTypeID then
            local fuelname = zrush.Fuel.GetName(extraData.FuelTypeID) or "Unkown"
            return fuelname .. " Barrel"
        else
            return "Empty Barrel"
        end
    end
end)

hook.Add("zvm_BlockItemCheck", "zvm_BlockItemCheck_ZerosOilRush", function(ent)
    if zrush then
        local itemclass = ent:GetClass()
        if itemclass == "zrush_palette" and ent.BarrelCount > 0 then
            return true
        elseif itemclass == "zrush_drillpipe_holder" and ent:GetPipeCount() < 10 then
            return true
        end
    end
end)

hook.Add("zvm_ItemExists", "zvm_ItemExists_ZerosOilRush", function(itemclass,compared_item,extraData)
    if zrush then
        if itemclass == "zrush_barrel" and extraData.oil then
            return true, compared_item.extraData.oil == extraData.oil
        elseif itemclass == "zrush_barrel" and extraData.fuel then
            return true, compared_item.extraData.fuel == extraData.fuel and compared_item.extraData.FuelTypeID == extraData.FuelTypeID
        elseif itemclass == "zrush_barrel" then
            return true, true
        end
    end
end)

zclib.Snapshoter.SetPath("zrush_barrel", function(ItemData)
    if ItemData.extraData then
        if ItemData.extraData.oil and ItemData.extraData.oil > 0 then
            return "zrush/barrel_oil"
        elseif ItemData.extraData.FuelTypeID and ItemData.extraData.fuel and ItemData.extraData.fuel > 0 then
            return "zrush/barrel_fuel_" .. ItemData.extraData.FuelTypeID
        end
    else
        return "zrush/barrel_empty"
    end
end)

hook.Add("zclib_RenderProductImage", "zclib_RenderProductImage_ZerosOilRush", function(cEnt, ItemData)

    if zrush and ItemData.class == "zrush_barrel" then
        if ItemData.extraData then
            if ItemData.extraData.oil then
                cEnt:SetColor(zrush.default_colors["grey02"])
            elseif ItemData.extraData.fuel and ItemData.extraData.FuelTypeID then
                cEnt:SetColor(zrush.FuelTypes[ItemData.extraData.FuelTypeID].color)
            else
                cEnt:SetColor(color_white)
            end
        end

        ItemData.model = "models/zerochain/props_oilrush/zor_barrel.mdl"
        zclib.CacheModel("models/zerochain/props_oilrush/zor_barrel.mdl")
        cEnt:SetModel("models/zerochain/props_oilrush/zor_barrel.mdl")
    end
end)
