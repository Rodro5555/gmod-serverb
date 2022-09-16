ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Radioisotope Thermoelectric Generator"
ENT.Author = "Crap-Head"
ENT.Category = "Bitminers by Crap-Head"

ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "PowerOn" )
	
	self:NetworkVar( "Float", 0, "WattsGenerated" )
	
	self:NetworkVar( "Entity", 0, "owning_ent" ) -- darkrp owner support
end