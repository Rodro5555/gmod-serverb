include("shared.lua")

function ENT:Initialize()
	zmlab2.Dropoff.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	zmlab2.Dropoff.Draw(self)
end

function ENT:OnRemove()
	zmlab2.Dropoff.OnRemove(self)
end

function ENT:Think()
	zmlab2.Dropoff.Think(self)
	self:SetNextClientThink(CurTime())
	return true
end
