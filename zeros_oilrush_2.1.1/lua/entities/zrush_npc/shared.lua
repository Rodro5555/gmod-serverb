ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Fuel Buyer"
ENT.Category = "Zeros OilRush"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "Price_Mul")
	self:NetworkVar("String", 0, "NPCName")

	if (SERVER) then
		self:SetPrice_Mul(1)
		self:SetNPCName(zrush.config.FuelBuyer.names[math.random(#zrush.config.FuelBuyer.names)])
	end
end
