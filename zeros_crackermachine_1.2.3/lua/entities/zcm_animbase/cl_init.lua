include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Think()
	self:SetNextClientThink(CurTime())

	return true
end

function ENT:ClientAnim(anim, speed)
	local sequence = self:LookupSequence(anim)
	self:SetCycle(0)
	self:ResetSequence(sequence)
	self:SetPlaybackRate(speed)
	self:SetCycle(0)
end
