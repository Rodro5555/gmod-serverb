include("shared.lua")

function ENT:Initialize()
	zmc.Mixer.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmc.Mixer.Draw(self)
end

function ENT:Think()
	zmc.Mixer.Think(self)
end

function ENT:OnRemove()
	zmc.Mixer.OnRemove(self)
end
