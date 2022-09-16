include("shared.lua")

function ENT:Initialize()
	zgo2.Oven.Initialize(self)
end

function ENT:Draw()
	self:DrawModel()
	zgo2.Oven.Draw(self)
end

function ENT:Think()
	zgo2.Oven.Think(self)
	self:SetNextClientThink(CurTime())

	return true
end

function ENT:OnRemove()
	zgo2.Oven.OnRemove(self)
end
