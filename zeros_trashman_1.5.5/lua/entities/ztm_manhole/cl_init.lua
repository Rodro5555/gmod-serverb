include("shared.lua")

function ENT:Initialize()
	ztm.Manhole.Initialize(self)
end

function ENT:Draw()
	self:DrawModel()
	ztm.Manhole.Draw(self)
end

function ENT:Think()
	ztm.Manhole.Think(self)
	self:SetNextClientThink(CurTime())

	return true
end

function ENT:OnRemove()
	ztm.Manhole.OnRemove(self)
end
