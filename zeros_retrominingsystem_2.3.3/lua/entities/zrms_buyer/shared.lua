ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.PrintName = "Buyer NPC"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros RetroMiningSystem"
ENT.AutomaticFrameAdvance = true
ENT.DisableDuplicator = false

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "BuyRate")
	self:NetworkVar("Int", 1, "CurrentState")

	if (SERVER) then
		self:SetBuyRate(100)
		self:SetCurrentState(0)
	end
end
