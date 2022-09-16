ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Seed"
ENT.Author = "Mikael"
ENT.Category = "The Cocaine Factory (Unfinished)"
ENT.Spawnable = true
ENT.AdminSpawnable = false

function ENT:SetupDataTables()	
	self:NetworkVar( "Int", 0, "HP" )
end