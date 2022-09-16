ENT.Base = "base_gmodentity" 
ENT.Type = "anim"
ENT.PrintName = "Showcase"
ENT.Category = "Realistic Car Dealer"
ENT.Author = "Kobralost"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent")
end