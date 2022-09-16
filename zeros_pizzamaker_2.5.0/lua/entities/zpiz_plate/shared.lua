ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "Plate"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros PizzaMaker"
ENT.Model = "models/maxofs2d/hover_plate.mdl"
ENT.DisableDuplicator = false

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "PizzaID")
	self:NetworkVar("Float", 0, "PizzaWaitTime")

	if (SERVER) then
		self:SetPizzaID(-1)
		self:SetPizzaWaitTime(-1)
	end
end
