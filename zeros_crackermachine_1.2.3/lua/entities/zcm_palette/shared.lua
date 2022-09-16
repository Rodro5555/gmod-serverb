ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Transport Pallet"
ENT.Category = "Zeros Crackermachine"
ENT.Model = "models/props_junk/wood_pallet001a.mdl"

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "FireworkCount")

	if (SERVER) then
		self:SetFireworkCount(0)
	end
end
