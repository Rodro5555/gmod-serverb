include("shared.lua")

function ENT:Draw()
	self:DrawModel()
	zpiz.Sign.Draw(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end
