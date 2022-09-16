ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Pot"
ENT.Author = "Mikael"
ENT.Category = "The Cocaine Factory (Unfinished)"
ENT.Spawnable = true
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "dist_harvest")
	self:NetworkVar("Int", 0, "dist_crop")
end
