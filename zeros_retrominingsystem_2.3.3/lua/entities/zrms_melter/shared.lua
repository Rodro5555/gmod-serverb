ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Melter"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros RetroMiningSystem"
ENT.Model = "models/zerochain/props_mining/zrms_melter.mdl"

ENT.AutomaticFrameAdvance = true
ENT.DisableDuplicator = false

function ENT:SetupDataTables()

	self:NetworkVar("Float", 1, "CoalAmount")

	self:NetworkVar("Int", 0, "CurrentState")
	self:NetworkVar("Bool", 0, "IsLowered")

	self:NetworkVar("Float", 0, "ResourceAmount")
	self:NetworkVar("String", 1, "ResourceType")


	if (SERVER) then
		self:SetResourceAmount(0)
		self:SetCoalAmount(0)
		self:SetCurrentState(0)
		self:SetResourceType("Empty")
		self:SetIsLowered(false)
	end
end
