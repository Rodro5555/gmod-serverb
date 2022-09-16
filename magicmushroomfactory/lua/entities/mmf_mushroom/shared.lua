ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Mushroom"
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Spawnable = true
ENT.Category = "Magic Mushrooms"
ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "Mushroom")
end