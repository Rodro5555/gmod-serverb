ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "Pizza Dough"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros PizzaMaker"
ENT.Model = "models/zerochain/props_pizza/zpizmak_pizzadough.mdl"
ENT.DisableDuplicator = false

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "PizzaState")
	self:NetworkVar("Int", 1, "PizzaID")
	self:NetworkVar("Float", 0, "BakeTime")

	if (SERVER) then
		self:SetBakeTime(0)
		self:SetPizzaState(0)
		self:SetPizzaID(-1)
	end
end
