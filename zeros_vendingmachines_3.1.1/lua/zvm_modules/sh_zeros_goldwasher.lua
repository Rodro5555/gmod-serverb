/////////////////////////
//Zeros Goldwasher
// https://www.gmodstore.com/market/view/7405

zvm.AllowedItems.Add("zgw_goldwasher")
zvm.AllowedItems.Add("zgw_bucket")
zvm.AllowedItems.Add("zgw_bucket_follow")
zvm.AllowedItems.Add("zgw_lantern")
zvm.AllowedItems.Add("zgw_jar")
zvm.AllowedItems.Add("zgw_mat")

zvm.AllowedItems.Add("zgw_shovel")
zvm.AllowedItems.Add("zgw_sieve")

zclib.RenderData.Add("zgw_shovel", {ang = Angle(90, 0, 0)})
zclib.RenderData.Add("zgw_sieve", {ang = Angle(0, 0, 0)})
zclib.RenderData.Add("zgw_goldwasher", {ang = Angle(0, 0, 0),FOV = 5,pos = Vector(-35,0,0)})

local zgw_entTable = {
    ["zgw_goldwasher"] = true,
    ["zgw_bucket"] = true,
    ["zgw_bucket_follow"] = true,
    ["zgw_lantern"] = true,
    ["zgw_jar"] = true,
    ["zgw_mat"] = true,
}
hook.Add("zvm_OnPackageItemSpawned", "zvm_OnPackageItemSpawned_GoldWasher", function(ply, ent, extradata)
    if zgw and zgw_entTable[ent:GetClass()] then
        zclib.Player.SetOwner(ent, ply)
    end
end)

hook.Add("zvm_BlockItemCheck", "zvm_BlockItemCheck_GoldWasher", function(ent)
    if zgw and ent:GetClass() == "zgw_jar" and ent:GetGold() <= 0 then return true end
end)

hook.Add("zvm_OnItemDataCatch", "zvm_OnItemDataCatch_GoldWasher", function(data, ent, itemclass)
    if zgw and itemclass == "zgw_jar" then
        data.gold = ent:GetGold()
    end
end)

hook.Add("zvm_OnItemDataApply", "zvm_OnItemDataApply_GoldWasher", function(itemclass, ent, extraData)
    if zgw and itemclass == "zgw_jar" then
        ent:SetGold(extraData.gold)
    end
end)

hook.Add("zvm_BlockItemCheck", "zvm_BlockItemCheck_GoldWasher", function(ent)
    if zgw then
        local itemclass = ent:GetClass()

        if itemclass == "zmlab_palette" and ent:GetCrateCount() > 0 then
            return true
        elseif itemclass == "zgw_bucket" and ent:GetDirt() > 0 then
            return true
        elseif itemclass == "zgw_bucket_follow" and ent:GetDirt() > 0 then
            return true
        elseif itemclass == "zgw_lantern" and ent.GotStarted then
            return true
        elseif itemclass == "zgw_mat" and ent:GetGold() > 0 then
            return true
        end
    end
end)

hook.Add("zvm_ItemExists", "zvm_ItemExists_GoldWasher", function(itemclass, compared_item, extraData)
    if zgw and itemclass == "zgw_jar" then return true, compared_item.extraData.gold == extraData.gold end
end)

hook.Add("zclib_GetImagePath", "zclib_GetImagePath_GoldWasher", function(ItemData)
    if zgw and string.sub(ItemData.class, 1, 4) == "zgw_" then return "zgw/" .. ItemData.class end
end)

hook.Add("zclib_RenderProductImage","zclib_RenderProductImage_GoldWasher",function(cEnt,ItemData)
    if zgw then
        if ItemData.class == "zgw_lantern" then
            ItemData.model_bg[0] = 0
        elseif ItemData.class == "zgw_bucket_follow" then
            ItemData.model_bg[1] = 1
        end
    end
end)

hook.Add("zvm_OnItemDataName", "zvm_OnItemDataName_GoldWasher", function(ent, extraData)
    if zgw and ent:GetClass() == "zgw_jar" then
        return ent.PrintName .. " " .. extraData.gold .. zgw.config.UoM
    end
end)
