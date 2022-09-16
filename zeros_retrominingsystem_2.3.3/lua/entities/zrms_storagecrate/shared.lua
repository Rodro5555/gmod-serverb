ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Storage Crate"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros RetroMiningSystem"
ENT.Model = "models/Zerochain/props_mining/zrms_storagecrate.mdl"
ENT.AutomaticFrameAdvance = true
ENT.DisableDuplicator = false

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "bIron")
	self:NetworkVar("Float", 1, "bBronze")
	self:NetworkVar("Float", 2, "bSilver")
	self:NetworkVar("Float", 3, "bGold")

	self:NetworkVar("Bool", 0, "IsClosed")

	if (SERVER) then
		self:SetbIron(0)
		self:SetbBronze(0)
		self:SetbSilver(0)
		self:SetbGold(0)

		self:SetIsClosed(false)
	end
end

function ENT:GetBarCount()
	return self:GetbIron() + self:GetbBronze() + self:GetbSilver() + self:GetbGold()
end
