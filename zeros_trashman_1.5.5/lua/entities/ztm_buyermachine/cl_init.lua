include("shared.lua")

function ENT:Initialize()
	ztm.Buyermachine.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	ztm.Buyermachine.Draw(self)
end

function ENT:Think()
	ztm.Buyermachine.Think(self)
	self:SetNextClientThink(CurTime())

	return true
end

function ENT:OnRemove()
	ztm.Buyermachine.OnRemove(self)
end
