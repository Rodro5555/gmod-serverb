include("shared.lua")

function ENT:Initialize()
	zgo2.Tent.Initialize(self)
end

function ENT:Draw()
	self:DrawModel()
	zgo2.Tent.OnDraw(self)
end

function ENT:Think()
	zgo2.Tent.OnThink(self)
end
