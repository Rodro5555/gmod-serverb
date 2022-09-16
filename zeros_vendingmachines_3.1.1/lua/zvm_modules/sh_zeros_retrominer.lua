/////////////////////////
// Zero´s RetroMiner
// https://www.gmodstore.com/market/view/zero-s-retrominer-mining-script
zvm.AllowedItems.Add("zrms_basket")
zvm.AllowedItems.Add("zrms_gravelcrate")
zvm.AllowedItems.Add("zrms_storagecrate")

local zrmine_entTable = {
    ["zrms_basket"] = true,
    ["zrms_gravelcrate"] = true,
    ["zrms_storagecrate"] = true
}

hook.Add("zvm_OnPackageItemSpawned", "zvm_OnPackageItemSpawned_ZerosRetroMiner", function(ply, ent, extradata)
    if zrmine and zrmine_entTable[ent:GetClass()] then
        zrmine.f.SetOwner(ent, ply)
    end
end)

hook.Add("zvm_OnItemDataCatch", "zvm_OnItemDataCatch_ZerosRetroMiner", function(data, ent, itemclass)
    if zrmine then
        if itemclass == "zrms_basket" then
            data.ResourceAmount = ent:GetResourceAmount()
            data.ResourceType = ent:GetResourceType()
        elseif itemclass == "zrms_gravelcrate" then
            data.Iron = ent:GetIron()
            data.Bronze = ent:GetBronze()
            data.Silver = ent:GetSilver()
            data.Gold = ent:GetGold()
            data.Coal = ent:GetCoal()
        elseif itemclass == "zrms_storagecrate" then
            data.bIron = ent:GetbIron()
            data.bBronze = ent:GetbBronze()
            data.bSilver = ent:GetbSilver()
            data.bGold = ent:GetbGold()
        end
    end
end)

hook.Add("zvm_OnItemDataApply", "zvm_OnItemDataApply_ZerosRetroMiner", function(itemclass, ent, extraData)
    if zrmine then
        if itemclass == "zrms_basket" then
            ent:SetResourceAmount(extraData.ResourceAmount)
            ent:SetResourceType(extraData.ResourceType)
        elseif itemclass == "zrms_gravelcrate" then
            ent:SetIron(extraData.Iron)
            ent:SetBronze(extraData.Bronze)
            ent:SetSilver(extraData.Silver)
            ent:SetGold(extraData.Gold)
            ent:SetCoal(extraData.Coal)
        elseif itemclass == "zrms_storagecrate" then
            ent:SetbIron(extraData.bIron)
            ent:SetbBronze(extraData.bBronze)
            ent:SetbSilver(extraData.bSilver)
            ent:SetbGold(extraData.bGold)
        end
    end
end)
