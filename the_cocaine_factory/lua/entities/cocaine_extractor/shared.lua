ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Cocaine Extractor"
ENT.Author = "Crap-Head"
ENT.Category = "The Cocaine Factory"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()	
	self:NetworkVar( "Int", 0, "HP" )
	self:NetworkVar( "Int", 1, "Leafs" )
	self:NetworkVar( "Int", 2, "BakingSoda" )
	
	self:NetworkVar( "Entity", 0, "owning_ent" ) -- darkrp owner support
end

TCF.Config.ExtractorPos = {
	posone = Vector(25.000000, -21.000000, 47.000000), 
	postwo = Vector(26.000000, -15.000000, 37.000000)
}