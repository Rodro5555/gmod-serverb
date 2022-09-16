ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Generator"
ENT.Author = "Crap-Head"
ENT.Category = "Bitminers by Crap-Head"

ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()	
	self:NetworkVar( "Int", 0, "Fuel" )
	
	self:NetworkVar( "Bool", 0, "PowerOn" )
	
	self:NetworkVar( "Float", 0, "WattsGenerated" )
	
	self:NetworkVar( "Entity", 0, "owning_ent" ) -- darkrp owner support
end

CH_Bitminers.Config.GeneratorPositions = {
	power_on_one = Vector( 3.744550, 14.736773, 30.798128 ), 
	power_on_two = Vector( 0.682943, 18.729000, 28.514614 ),
	
	power_off_one = Vector( -0.578255, 14.751831, 30.789503 ),
	power_off_two = Vector( -3.672764, 18.798069, 28.475124 )
}