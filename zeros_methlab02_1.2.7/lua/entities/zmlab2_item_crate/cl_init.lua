include("shared.lua")

function ENT:Initialize()
	zmlab2.Crate.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmlab2.Crate.Draw(self)
end
