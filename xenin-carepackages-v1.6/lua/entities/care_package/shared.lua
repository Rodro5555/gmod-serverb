ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Care Package"
ENT.Author = "sleeppyy"
ENT.Category = "Xenin"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "BeenUsed")
	self:NetworkVar("Float", 0, "Progress")
end