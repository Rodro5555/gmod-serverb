include("shared.lua")

function ENT:Initialize()
	zgo2.Watertank.Initialize(self)
end

function ENT:Draw()
	self:DrawModel()
	zgo2.Watertank.OnDraw(self)
end

function ENT:Think()
	zgo2.Watertank.OnThink(self)
end
