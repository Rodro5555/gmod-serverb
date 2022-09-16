include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Initialize()
	zrush.DrillHole.Initialize(self)
end

function ENT:Think()
	zrush.DrillHole.Think(self)
	self:SetNextClientThink(CurTime())

	return true
end

function ENT:OnRemove()
	zrush.DrillHole.OnRemove(self)
end
