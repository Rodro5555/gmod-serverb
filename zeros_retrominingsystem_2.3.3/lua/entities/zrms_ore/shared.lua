ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.PrintName = "Ore - Random"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros RetroMiningSystem"

ENT.Model = "models/zerochain/props_mining/zrms_resource_point.mdl"

ENT.DisableDuplicator = false

function ENT:SetupDataTables()
	self:NetworkVar("Float", 1, "Max_ResourceAmount")
	self:NetworkVar("Float", 0, "ResourceAmount")
	self:NetworkVar("String", 0, "ResourceType")

	if (SERVER) then
		self:SetResourceType("Random")
		self:SetResourceAmount(1000)
		self:SetMax_ResourceAmount(-1)
	end
end
