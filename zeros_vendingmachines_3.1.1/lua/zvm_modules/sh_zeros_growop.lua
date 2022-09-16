/////////////////////////
//Zeros GrowOP
//https://www.gmodstore.com/market/view/zero-s-grow-op-weed-script

zvm.AllowedItems.Add("zwf_generator")
zvm.AllowedItems.Add("zwf_fuel")
zvm.AllowedItems.Add("zwf_lamp") // Has CustomData
zvm.AllowedItems.Add("zwf_autopacker")
zvm.AllowedItems.Add("zwf_drystation")
zvm.AllowedItems.Add("zwf_pot")
zvm.AllowedItems.Add("zwf_pot_hydro")
zvm.AllowedItems.Add("zwf_packingstation")
zvm.AllowedItems.Add("zwf_seed_bank")
zvm.AllowedItems.Add("zwf_splice_lab")
zvm.AllowedItems.Add("zwf_soil")
zvm.AllowedItems.Add("zwf_ventilator")
zvm.AllowedItems.Add("zwf_watertank")
zvm.AllowedItems.Add("zwf_palette")
zvm.AllowedItems.Add("zwf_outlet")
zvm.AllowedItems.Add("zwf_seed") // Has CustomData
zvm.AllowedItems.Add("zwf_nutrition") // Has CustomData
zvm.AllowedItems.Add("zwf_bong01_ent")
zvm.AllowedItems.Add("zwf_bong02_ent")
zvm.AllowedItems.Add("zwf_bong03_ent")
zvm.AllowedItems.Add("zwf_doobytable")
zvm.AllowedItems.Add("zwf_mixer")
zvm.AllowedItems.Add("zwf_backmix")
zvm.AllowedItems.Add("zwf_oven")

zvm.AllowedItems.Add("zwf_jar") // Has CustomData
zvm.AllowedItems.Add("zwf_edibles") // Has CustomData
zvm.AllowedItems.Add("zwf_joint_ent") // Has CustomData
zvm.AllowedItems.Add("zwf_weedblock") // Has CustomData

zvm.AllowedItems.Add("zwf_shoptablet")
zvm.AllowedItems.Add("zwf_cable")
zvm.AllowedItems.Add("zwf_wateringcan")

zclib.RenderData.Add("zwf_seed_bank", {ang = Angle(0, 180, 0)})
zclib.RenderData.Add("zwf_seed", {ang = Angle(0, 0, -90)})
zclib.RenderData.Add("zwf_nutrition", {ang = Angle(0, 90, 0)})
zclib.RenderData.Add("zwf_jar", {pos = Vector(-35,-35,-15)})

local zwf_entTable = {
    ["zwf_autopacker"] = true,
    ["zwf_ventilator"] = true,
    ["zwf_outlet"] = true,
    ["zwf_pot"] = true,
    ["zwf_pot_hydro"] = true,
    ["zwf_soil"] = true,
    ["zwf_watertank"] = true,
    ["zwf_drystation"] = true,
    ["zwf_fuel"] = true,
    ["zwf_generator"] = true,
    ["zwf_lamp"] = true,
    ["zwf_packingstation"] = true,
    ["zwf_splice_lab"] = true,
    ["zwf_seed_bank"] = true,
    ["zwf_palette"] = true,
    ["zwf_doobytable"] = true,
    ["zwf_mixer"] = true,
    ["zwf_backmix"] = true,
    ["zwf_oven"] = true,
    ["zwf_edibles"] = true,
    ["zwf_jar"] = true,
    ["zwf_nutrition"] = true,
    ["zwf_joint_ent"] = true,
    ["zwf_weedblock"] = true,
}
hook.Add("zvm_OnPackageItemSpawned", "zvm_OnPackageItemSpawned_ZerosGrowOP", function(ply, ent,extradata)
    if zwf and zwf_entTable[ent:GetClass()] then
        zwf.f.SetOwner(ent, ply)
    end
end)

hook.Add("zvm_OnItemDataCatch", "zvm_OnItemDataCatch_ZerosGrowOP", function( data,ent,itemclass)

    if zwf then
        if itemclass == "zwf_lamp" then

            data.lampid = ent:GetLampID()
        elseif itemclass == "zwf_nutrition" then

            data.nutid = ent:GetNutritionID()
        elseif itemclass == "zwf_seed" then

            data.seedid = ent:GetSeedID()
            data.perf_time = ent:GetPerf_Time()
            data.perf_amount = ent:GetPerf_Amount()
            data.perf_thc = ent:GetPerf_THC()
            data.seedcount = ent:GetSeedCount()
            data.seedname = ent:GetSeedName()
        elseif itemclass == "zwf_jar" then

            data.weed_amount = ent:GetWeedAmount()
            data.weed_id = ent:GetPlantID()
            data.weed_thc = ent:GetTHC()

            data.weed_perftime = ent:GetPerf_Time()
            data.weed_perfamount = ent:GetPerf_Amount()
            data.weed_perfthc = ent:GetPerf_THC()

            data.weed_name = ent:GetWeedName()
        elseif itemclass == "zwf_edibles" then

            data.weed_id = ent.WeedID
            data.weed_amount = ent.WeedAmount
            data.weed_thc = ent.WeedTHC
            data.weed_name = ent.WeedName
            data.muffin_color = ent:GetColor()
            data.muffin_skin = ent:GetSkin()
            data.EdibleID = ent.EdibleID
        elseif itemclass == "zwf_joint_ent" then

            data.weed_amount = ent:GetWeed_Amount()
            data.weed_id = ent:GetWeedID()
            data.weed_thc = ent:GetWeed_THC()
            data.weed_name = ent:GetWeed_Name()
        elseif itemclass == "zwf_weedblock" then

            data.weed_amount = ent:GetWeedAmount()
            data.weed_id = ent:GetWeedID()
            data.weed_thc = ent:GetTHC()
            data.weed_name = ent:GetWeedName()
        end
    end
end)

hook.Add("zvm_OnItemDataApply", "zvm_OnItemDataApply_ZerosGrowOP", function( itemclass, ent, extraData)

    if zwf then
        if itemclass == "zwf_lamp" then

            ent:SetLampID(extraData.lampid)
            ent:SetModel(zwf.config.Lamps[extraData.lampid].model)
        elseif itemclass == "zwf_nutrition" then

            ent:SetNutritionID(extraData.nutid)
            ent:SetSkin(zwf.config.Nutrition[extraData.nutid].skin)
        elseif itemclass == "zwf_seed" then

            ent:SetSeedID(extraData.seedid)
            ent:SetPerf_Time(extraData.perf_time)
            ent:SetPerf_Amount(extraData.perf_amount)
            ent:SetPerf_THC(extraData.perf_thc)
            ent:SetSeedCount(extraData.seedcount)
            ent:SetSeedName(extraData.seedname)
            local plantData = zwf.config.Plants[extraData.seedid]

            if plantData then
                ent:SetSkin(plantData.skin)
            end
        elseif itemclass == "zwf_jar" then

            ent:SetWeedAmount(extraData.weed_amount)
            ent:SetPlantID(extraData.weed_id)
            ent:SetTHC(extraData.weed_thc)

            ent:SetPerf_Time(extraData.weed_perftime)
            ent:SetPerf_Amount(extraData.weed_perfamount)
            ent:SetPerf_THC(extraData.weed_perfthc)

            ent:SetWeedName(extraData.weed_name)
        elseif itemclass == "zwf_edibles" then
            ent.EdibleID = extraData.EdibleID
            ent.WeedID = extraData.weed_id
            ent.WeedAmount = extraData.weed_amount
            ent.WeedTHC = extraData.weed_thc
            ent.WeedName = extraData.weed_name
            ent:SetColor(extraData.muffin_color)
            ent:SetSkin(extraData.muffin_skin)

            if ent.EdibleID and zwf.config.Cooking.edibles[ent.EdibleID] and zwf.config.Cooking.edibles[ent.EdibleID].edible_model then
        		ent:SetModel(zwf.config.Cooking.edibles[ent.EdibleID].edible_model)
        	end
        elseif itemclass == "zwf_joint_ent" then
            ent:SetWeed_Amount(extraData.weed_amount)
            ent:SetWeedID(extraData.weed_id)
            ent:SetWeed_THC(extraData.weed_thc)
            ent:SetWeed_Name(extraData.weed_name)
        elseif itemclass == "zwf_weedblock" then
            ent:SetWeedAmount(extraData.weed_amount)
            ent:SetWeedID(extraData.weed_id)
            ent:SetTHC(extraData.weed_thc)
            ent:SetWeedName(extraData.weed_name)
        end
    end
end)

hook.Add("zvm_OnItemDataName", "zvm_OnItemDataName_ZerosGrowOP", function(ent,extraData)

    if zwf then
        local itemclass = ent:GetClass()
        if itemclass == "zwf_lamp" then

            return zwf.config.Lamps[extraData.lampid].name
        elseif itemclass == "zwf_nutrition" then

            return zwf.config.Nutrition[extraData.nutid].name
        elseif itemclass == "zwf_seed" then

            return ent:GetSeedName()
        elseif itemclass == "zwf_jar" then

            return ent:GetWeedName()
        elseif itemclass == "zwf_edibles" then

            if ent.WeedID ~= -1 then
                return ent.WeedName
            else
                return zwf.config.Cooking.edibles[ent.EdibleID].name
            end
        elseif itemclass == "zwf_joint_ent" then

            return ent:GetWeed_Name()
        end
    end
end)

hook.Add("zvm_BlockItemCheck", "zvm_BlockItemCheck_ZerosGrowOP", function(ent)

    if zwf then
        local itemclass = ent:GetClass()
        if itemclass == "zwf_joint_ent" and ent:GetIsBurning() == true then
            return true
        elseif itemclass == "zwf_jar" and ent:GetWeedAmount() <= 0 then
            return true
        end
    end
end)

hook.Add("zvm_ItemExists", "zvm_ItemExists_ZerosGrowOP", function(itemclass,compared_item,extraData)
    if zwf then
        if itemclass == "zwf_lamp" then
            return true, compared_item.extraData.lampid == extraData.lampid
        elseif itemclass == "zwf_nutrition" then
            return true, compared_item.extraData.nutid == extraData.nutid
        elseif itemclass == "zwf_seed" then
            return true, compared_item.extraData.seedid == extraData.seedid and compared_item.extraData.seedname == extraData.seedname and compared_item.extraData.seedcount == extraData.seedcount
        elseif itemclass == "zwf_jar" then
            return true, compared_item.extraData.weed_id == extraData.weed_id and compared_item.extraData.weed_name == extraData.weed_name and compared_item.extraData.weed_amount == extraData.weed_amount
        elseif itemclass == "zwf_edibles" then
            return true, compared_item.extraData.weed_id == extraData.weed_id and compared_item.extraData.weed_name == extraData.weed_name and compared_item.extraData.weed_amount == extraData.weed_amount
        elseif itemclass == "zwf_joint_ent" then
            return true, compared_item.extraData.weed_id == extraData.weed_id and compared_item.extraData.weed_name == extraData.weed_name and compared_item.extraData.weed_amount == extraData.weed_amount
        end
    end
end)

zclib.Snapshoter.SetPath("zwf_edibles", function(ItemData) return "zwf/edible_" .. ItemData.extraData.weed_id end)
zclib.Snapshoter.SetPath("zwf_nutrition", function(ItemData) return "zwf/nut_" .. ItemData.extraData.nutid end)
zclib.Snapshoter.SetPath("zwf_seed", function(ItemData) return "zwf/seed_" .. ItemData.extraData.seedid end)
zclib.Snapshoter.SetPath("zwf_weedblock", function(ItemData) return "zwf/weedblock_" .. ItemData.extraData.weed_id end)
zclib.Snapshoter.SetPath("zwf_jar", function(ItemData) return "zwf/jar_" .. ItemData.extraData.weed_id end)

hook.Add("zclib_RenderProductImage", "zclib_RenderProductImage_ZerosGrowOP", function(cEnt, ItemData)
    if zwf then
        if ItemData.class == "zwf_jar" and ItemData.extraData and ItemData.extraData.weed_id and ItemData.extraData.weed_amount then

            local weed_id = ItemData.extraData.weed_id
            local PlantData = zwf.config.Plants[weed_id]
            if PlantData then
                ItemData.model_skin = PlantData.skin
            end

            ItemData.model = "models/zerochain/props_weedfarm/zwf_weedstick.mdl"
            zclib.CacheModel("models/zerochain/props_weedfarm/zwf_weedstick.mdl")
            cEnt:SetModel("models/zerochain/props_weedfarm/zwf_weedstick.mdl")
        elseif ItemData.class == "zwf_weedblock" and ItemData.extraData and ItemData.extraData.weed_id and ItemData.extraData.weed_amount then
            local weed_id = ItemData.extraData.weed_id
            local PlantData = zwf.config.Plants[weed_id]
            if PlantData then
                ItemData.model_skin = PlantData.skin
            end
        end
    end
end)
