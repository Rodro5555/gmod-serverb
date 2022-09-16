/////////////////////////
// Zeros PumpkinNight
// https://www.gmodstore.com/market/view/6690

zvm.AllowedItems.Add("zpn_slapper_default")
zvm.AllowedItems.Add("zpn_slapper_candy")
zvm.AllowedItems.Add("zpn_slapper_fire")

local entTable = {
    ["zpn_slapper_default"] = true,
    ["zpn_slapper_candy"] = true,
    ["zpn_slapper_fire"] = true
}

hook.Add("zvm_OnPackageItemSpawned", "zvm_OnPackageItemSpawned_ZerosPumpkinNight", function(ply, ent, extradata)
    if zpn and entTable[ent:GetClass()] then
        zclib.Player.SetOwner(ent, ply)
    end
end)

hook.Add("zvm_BlockItemCheck", "zvm_BlockItemCheck_ZerosPumpkinNight", function(ent)
    if zpn and entTable[ent:GetClass()] and ent.GotPlaced then
        return true
    end
end)

hook.Add("zclib_GetImagePath", "zclib_GetImagePath_ZerosPumpkinNight", function(ItemData)
    if zpn and entTable[ItemData.class] then return "zpn/" .. ItemData.class end
end)
