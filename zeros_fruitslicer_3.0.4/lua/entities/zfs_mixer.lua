AddCSLuaFile()
DEFINE_BASECLASS("zfs_anim")
ENT.Spawnable = false
ENT.Base = "zfs_anim"
ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.PrintName = "Mixer"
ENT.Category = "Zeros FruitSlicer"
ENT.Model = "models/zerochain/fruitslicerjob/fs_mixer.mdl"

if CLIENT then return end

function ENT:Use(activator, caller)
    local shop = self:GetParent()

    if not IsValid(shop) then return end

    if shop:GetClass() ~= "zfs_shop" then return end

    // If the shop is not a public entity and the player dont owns it then stop
    if shop:GetPublicEntity() == false and not zclib.Player.IsOwner(activator, shop) then
        zclib.Notify(ply, zfs.language.Shop.NotOwner, 1)
        return
    end

    if (shop:GetIsBusy()) then return end

    if (shop:GetCurrentState() == 11) then
        zfs.Shop.StartMixer(shop)
    end
end
