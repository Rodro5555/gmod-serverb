AddCSLuaFile()
DEFINE_BASECLASS("zrms_resource")
ENT.Type = "anim"
ENT.Base = "zrms_resource"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "Gravel - Iron"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros RetroMiningSystem"
ENT.Model = "models/Zerochain/props_mining/zrms_resource.mdl"
ENT.DisableDuplicator = false

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "ResourceAmount")
	self:NetworkVar("String", 0, "ResourceType")

	if (SERVER) then
		self:SetResourceType("Iron")
		self:SetResourceAmount(25)
	end
end
