/////////////////////////
//Zeros Crackermaker
//https://www.gmodstore.com/market/view/zero-s-crackermaker-firework-production

zvm.AllowedItems.Add("zcm_box")
zvm.AllowedItems.Add("zcm_blackpowder")
zvm.AllowedItems.Add("zcm_paperroll")
zvm.AllowedItems.Add("zcm_firecracker")
zvm.AllowedItems.Add("zcm_crackermachine")

local zcm_entTable = {
    ["zcm_box"] = true,
    ["zcm_blackpowder"] = true,
    ["zcm_paperroll"] = true,
    ["zcm_firecracker"] = true,
    ["zcm_crackermachine"] = true,
}
hook.Add("zvm_OnPackageItemSpawned", "zvm_OnPackageItemSpawned_ZerosCrackermaker", function(ply, ent, extradata)
    if zcm and zcm_entTable[class] then
        zcm.f.SetOwner(ent, ply)
    end
end)

hook.Add("zvm_BlockItemCheck", "zvm_BlockItemCheck_ZerosCrackermaker", function(ent)
    if zcm and ent:GetClass() == "zcm_box" and ent:GetFireworkCount() > 0 then
        return true
    end
end)

hook.Add("zclib_RenderProductImage", "zclib_RenderProductImage_ZerosCrackermaker", function(cEnt, ItemData)
    if zcm and ItemData.class == "zcm_crackermachine" then

        local function DrawPart(mdl)
            render.Model({
                model = mdl,
                pos = cEnt:GetPos(),
                angle = Angle(0, 0, 0)
            }, client_mdl)
        end

        DrawPart("models/zerochain/props_crackermaker/zcm_paperroller.mdl")
        DrawPart("models/zerochain/props_crackermaker/zcm_rollmover.mdl")
        DrawPart("models/zerochain/props_crackermaker/zcm_cutter.mdl")
        DrawPart("models/zerochain/props_crackermaker/zcm_cutrollrelease.mdl")
        DrawPart("models/zerochain/props_crackermaker/zcm_rollpacker.mdl")
        DrawPart("models/zerochain/props_crackermaker/zcm_rollbinder.mdl")
        DrawPart("models/zerochain/props_crackermaker/zcm_powderfiller.mdl")
    end
end)
