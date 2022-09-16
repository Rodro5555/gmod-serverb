include("shared.lua")

function ENT:Initialize()
	zmlab2.Tent.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmlab2.Tent.Draw(self)
end

function ENT:Think()
	self:SetNextClientThink(CurTime())
	zmlab2.Tent.OnThink(self)

	return true
end

function ENT:OnRemove()
	zmlab2.Tent.OnRemove(self)
end
