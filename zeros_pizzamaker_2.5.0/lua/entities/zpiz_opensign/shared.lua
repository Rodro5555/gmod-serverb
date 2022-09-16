ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "OpenSign"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros PizzaMaker"
ENT.Model = "models/props_trainstation/TrackSign02.mdl"
ENT.DisableDuplicator = false

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "SignState")
	self:NetworkVar("Float", 0, "SessionEarnings")

	if (SERVER) then
		self:SetSignState(false)
		self:SetSessionEarnings(0)
	end
end
