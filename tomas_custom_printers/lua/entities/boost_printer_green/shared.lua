ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Impresora Nivel 3"
ENT.Author = "Tomas"
ENT.Spawnable = true
ENT.AdminSpawnable = true


function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent")
end
