include("shared.lua")

function ENT:Initialize()
	zmlab2.FrezzerTray.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmlab2.FrezzerTray.Draw(self)
end
