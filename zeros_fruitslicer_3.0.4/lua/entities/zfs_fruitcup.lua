AddCSLuaFile()
DEFINE_BASECLASS("zfs_anim")
ENT.Spawnable = false
ENT.Base = "zfs_anim"
ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.PrintName = "Fruitcup"
ENT.Category = "Zeros FruitSlicer"
ENT.Model = "models/zerochain/fruitslicerjob/fs_fruitcup.mdl"

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Price")
    self:NetworkVar("String", 0, "SmoothieCreator")
end

if CLIENT then return end

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    local phys = self:GetPhysicsObject()

    if IsValid(phys) then
        phys:Wake()
        phys:EnableMotion(false)
    end

    zfs.SellObject.Initialize(self)
end

function ENT:AcceptInput(input, activator, caller, data)
    if string.lower(input) == "use" and IsValid(activator) and activator:IsPlayer() and activator:Alive() then
        zfs.SellObject.Use(activator, self)
    end
end
