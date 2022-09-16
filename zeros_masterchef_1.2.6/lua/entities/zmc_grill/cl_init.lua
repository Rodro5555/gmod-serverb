include("shared.lua")

function ENT:Initialize()
	zmc.Grill.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmc.Grill.Draw(self)
end

function ENT:Think()
	zmc.Grill.Think(self)
end

function ENT:OnRemove()
	zmc.Grill.OnRemove(self)
end
