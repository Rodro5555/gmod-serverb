ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Cooking Pan"
ENT.Author = "Crap-Head"
ENT.Category = "The Cocaine Factory"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "HP" )
	self:NetworkVar( "Bool", 0, "Cooking" )
	self:NetworkVar( "Bool", 1, "Cooked" )
	
	self:NetworkVar( "Entity", 0, "owning_ent" ) -- darkrp owner support
end

