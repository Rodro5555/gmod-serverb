include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Initialize()
	zfs.Shop.Initialize(self)
end

function ENT:Think()
	zfs.Shop.Think(self)
	self:SetNextClientThink(CurTime())

	return true
end

function ENT:OnRemove()
	zfs.Shop.OnRemove(self)
end
