include("shared.lua")

function ENT:Initialize()
	zpiz.Pizza.Initialize(self)
end

function ENT:Draw()
	self:DrawModel()
	zpiz.Pizza.Draw(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end
