include("restoreboxconfig.lua")
AddCSLuaFile("restoreboxconfig.lua")

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Restore Box"
ENT.Author = "Owjo"
ENT.AdminSpawnable = true
ENT.Spawnable = true
ENT.Category = "Owjos Addons"

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "price")
	self:NetworkVar("Entity", 0, "owning_ent")
	self:NetworkVar("Int", 1, "Money")
end
