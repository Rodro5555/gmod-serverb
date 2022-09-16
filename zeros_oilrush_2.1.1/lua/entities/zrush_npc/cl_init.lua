include("shared.lua")

function ENT:Initialize()
	zrush.FuelBuyer.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zrush.FuelBuyer.Draw(self)
end
