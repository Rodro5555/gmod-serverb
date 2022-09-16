AddCSLuaFile()
DEFINE_BASECLASS("zrms_basket")
ENT.Type = "anim"
ENT.Base = "zrms_basket"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Crate - Silver"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros RetroMiningSystem"
ENT.AutomaticFrameAdvance = true
ENT.DisableDuplicator = false

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "ResourceAmount")
	self:NetworkVar("String", 0, "ResourceType")

	if (SERVER) then
		self:SetResourceAmount(zrmine.config.ResourceCrates_Capacity)
		self:SetResourceType("Silver")
	end
end
