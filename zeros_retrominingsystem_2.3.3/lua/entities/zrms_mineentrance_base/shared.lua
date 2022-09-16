ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Mining Entrance"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros RetroMiningSystem"
ENT.Model = "models/zerochain/props_mining/mining_entrance.mdl"
ENT.AutomaticFrameAdvance = true
ENT.DisableDuplicator = false

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 1, "HideCart")
	self:NetworkVar("Bool", 0, "IsClosed")

	self:NetworkVar("Int", 0, "CurrentState")

	self:NetworkVar("String", 1, "MineResourceType")
	self:NetworkVar("Entity", 0, "ConnectedOre")

	self:NetworkVar("Float", 0, "MinningTime")
	self:NetworkVar("Float", 1, "StartMinningTime")

	if (SERVER) then
		self:SetIsClosed(true)
		self:SetHideCart(true)
		self:SetCurrentState(0)
		self:SetMineResourceType("Nothing")
		self:SetConnectedOre(nil)
		self:SetMinningTime(-1)
		self:SetStartMinningTime(-1)
	end
end
