include("shared.lua")

function ENT:Initialize()
	zgo2.Mixer.Initialize(self)
end

function ENT:Draw()
	self:DrawModel()
	zgo2.Mixer.Draw(self)
end

function ENT:Think()
	zgo2.Mixer.Think(self)
	self:SetNextClientThink(CurTime())
	return true
end

function ENT:OnRemove()
	zgo2.Mixer.OnRemove(self)
end
