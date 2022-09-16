include("shared.lua")

function ENT:Initialize()
	zmlab2.Table.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmlab2.Table.Draw(self)
end

function ENT:Think()
	zmlab2.Table.Think(self)
	self:SetNextClientThink(CurTime())

	return true
end

function ENT:OnRemove()
	zmlab2.Table.OnRemove(self)
end
