include("shared.lua")

function ENT:Initialize()
	zgo2.Pump.Initialize(self)
end

function ENT:Draw()
	self:DrawModel()
	zgo2.Pump.OnDraw(self)
end

function ENT:Think()
	zgo2.Pump.OnThink(self)
end
