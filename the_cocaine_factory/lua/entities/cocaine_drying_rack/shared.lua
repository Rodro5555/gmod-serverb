ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Drying Rack"
ENT.Author = "Crap-Head"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Category = "The Cocaine Factory"

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "HP" )	
	self:NetworkVar( "Int", 1, "BatteryCharge" )
	
	self:NetworkVar( "Entity", 0, "owning_ent" ) -- darkrp owner support
end

TCF.Config.DryingRackPos = {
	posone = Vector(24.263144, -29.354189, 38.837906), 
	postwo = Vector(28.107809, -26.434673, 36.438137)
}