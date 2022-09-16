include("shared.lua")

function ENT:Initialize()
	zgo2.Generator.Initialize(self)
end

function ENT:Draw()
	self:DrawModel()
	zgo2.Generator.OnDraw(self)
end

function ENT:Think()
	zgo2.Generator.OnThink(self)
end

function ENT:OnRemove()
	zgo2.Generator.OnRemove(self)
end
