include("shared.lua")

function ENT:Initialize()
	zpiz.Plate.Initialize(self)
end

function ENT:Draw()
	self:DrawModel()
	zpiz.Plate.Draw(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end
