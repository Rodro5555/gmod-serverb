include("shared.lua")

function ENT:Initialize()
	zmlab2.Mixer.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmlab2.Mixer.Draw(self)
end

function ENT:Think()
	zmlab2.Mixer.Think(self)
end

function ENT:OnRemove()
	zmlab2.Mixer.OnRemove(self)
end
