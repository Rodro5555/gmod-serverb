include("shared.lua")

function ENT:Initialize()
	zgo2.Splicer.Initialize(self)
end

function ENT:Draw()
	self:DrawModel()
	zgo2.Splicer.OnDraw(self)
end

function ENT:Think()
	zgo2.Splicer.OnThink(self)
end

function ENT:OnRemove()
	zgo2.Splicer.OnRemove(self)
end
