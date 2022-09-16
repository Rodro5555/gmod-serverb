ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Stove"
ENT.Author = "Mikael, Nvs2000 & Crap-Head"
ENT.Category = "The Cocaine Factory"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 1, "Plate1" )
	self:NetworkVar( "Bool", 2, "Plate2" )
	self:NetworkVar( "Bool", 3, "Plate3" )
	self:NetworkVar( "Bool", 4, "Plate4" )

	self:NetworkVar( "Int", 0, "Celious1" )
	self:NetworkVar( "Int", 1, "Celious2" )
	self:NetworkVar( "Int", 2, "Celious3" )
	self:NetworkVar( "Int", 3, "Celious4" )
	self:NetworkVar( "Int", 5, "GasAmount" )
	
	self:NetworkVar( "Int", 6, "HP" )
	
	self:NetworkVar( "Entity", 0, "owning_ent" ) -- darkrp owner support
end

TCF.Config.StovePos = {
	dpos1 = Vector(19.000000, -16.000000, 43.000000),
	dpos2 = Vector(22.000000, -11.000000, 33.000000),
	dpos3 = Vector(19.000000, -9.000000, 43.000000),
	dpos4 = Vector(22.000000, -4.000000, 33.000000), 
	dpos5 = Vector(19.000000, -3.000000, 43.000000),
	dpos6 = Vector(22.000000, 1.000000,33.000000), 
	dpos7 = Vector(19.000000, 2.000000, 43.000000),
	dpos8 = Vector(22.000000, 7.000000,33.000000)
}