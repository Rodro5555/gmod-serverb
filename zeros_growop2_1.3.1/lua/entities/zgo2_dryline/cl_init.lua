include("shared.lua")

function ENT:Initialize()
	zgo2.Dryline.Initialize(self)
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:Think()
	zgo2.Dryline.OnThink(self)
end

function ENT:OnRemove()
	zgo2.Dryline.OnRemove(self)
end
