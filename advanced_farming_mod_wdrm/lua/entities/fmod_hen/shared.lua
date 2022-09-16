ENT.Type = "nextbot"
ENT.Base = "base_nextbot"
ENT.PrintName = "Hen"
ENT.Category = "Farming Mod"
ENT.Author = "Venatuss"
ENT.Spawnable = true

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Hunger")
    self:NetworkVar("Int", 1, "Thirst")
    self:NetworkVar("Int", 2, "Age")
    self:NetworkVar("Int", 3, "Weight")
	self:NetworkVar("Entity", 0, "owning_ent")
end
