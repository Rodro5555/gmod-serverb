include("shared.lua")

function ENT:Initialize()
	zgo2.Lamp.Initialize(self)
end

function ENT:Draw()
	self:DrawModel()
	zgo2.Lamp.OnDraw(self)
end

function ENT:Think()
	zgo2.Lamp.OnThink(self)
end

function ENT:OnRemove()
	zgo2.Lamp.OnRemove(self)
end
