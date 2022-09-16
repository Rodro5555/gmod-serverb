include("shared.lua")

function ENT:Initialize()
	zgo2.Packer.Initialize(self)
end

function ENT:Draw()
	self:DrawModel()
	zgo2.Packer.OnDraw(self)
end

function ENT:Think()
	zgo2.Packer.OnThink(self)
	self:SetNextClientThink(CurTime())
	return true
end

function ENT:OnRemove()
	zgo2.Packer.OnRemove(self)
end
