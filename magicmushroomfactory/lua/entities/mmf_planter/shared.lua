ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Mushroom planter"
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Spawnable = true
ENT.Category = "Magic Mushrooms"
ENT.AutomaticFrameAdvance = true
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()
	self:NetworkVar( "Entity", 0, "owning_ent" )
end