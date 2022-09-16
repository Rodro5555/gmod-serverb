include("shared.lua")

function ENT:Initialize()
	zmlab2.Meth.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmlab2.Meth.Draw(self)
end
