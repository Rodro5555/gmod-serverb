include("shared.lua")

function ENT:Initialize()
	zgo2.MixerBowl.Initialize(self)
end

function ENT:Draw()
	self:DrawModel()
	zgo2.MixerBowl.Draw(self)
end

function ENT:Think()
	zgo2.MixerBowl.Think(self)
end
