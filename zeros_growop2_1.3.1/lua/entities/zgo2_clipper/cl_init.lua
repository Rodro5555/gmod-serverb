include("shared.lua")

function ENT:Initialize()
	zgo2.Clipper.Initialize(self)
end

function ENT:Draw()
	self:DrawModel()
	zgo2.Clipper.OnDraw(self)
end

function ENT:Think()
	zgo2.Clipper.OnThink(self)
	self:SetNextClientThink(CurTime())
	return true
end

function ENT:OnRemove()
	zgo2.Clipper.OnRemove(self)
end
