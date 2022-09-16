ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Gravel Crate"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros RetroMiningSystem"
ENT.Model = "models/Zerochain/props_mining/zrms_gravelcrate.mdl"
ENT.AutomaticFrameAdvance = true
ENT.DisableDuplicator = false

function ENT:SetupDataTables()
	self:NetworkVar("Float", 2, "Iron")
	self:NetworkVar("Float", 3, "Bronze")
	self:NetworkVar("Float", 4, "Silver")
	self:NetworkVar("Float", 5, "Gold")
	self:NetworkVar("Float", 6, "Coal")

	if (SERVER) then
		self:SetIron(0)
		self:SetBronze(0)
		self:SetSilver(0)
		self:SetGold(0)
		self:SetCoal(0)
	end
end
