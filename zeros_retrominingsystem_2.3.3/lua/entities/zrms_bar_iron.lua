AddCSLuaFile()
DEFINE_BASECLASS("zrms_bar")
ENT.Type = "anim"
ENT.Base = "zrms_bar"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "Iron Bar"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros RetroMiningSystem"
ENT.Model = "models/Zerochain/props_mining/zrms_bar.mdl"
ENT.AutomaticFrameAdvance = true
ENT.DisableDuplicator = false

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "MetalType")

	if (SERVER) then
		self:SetMetalType("Iron")
	end
end
