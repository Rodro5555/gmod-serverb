ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Generator Fuel - Small"
ENT.Author = "Crap-Head"
ENT.Category = "Bitminers by Crap-Head"

ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()	
	self:NetworkVar( "Entity", 0, "owning_ent" ) -- darkrp owner support
end