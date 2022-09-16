include("shared.lua")

function ENT:Initialize()
	zpiz.Oven.Initialize(self)
end

function ENT:Draw()
	self:DrawModel()
	zpiz.Oven.Draw(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Think()
	zpiz.Oven.Think(self)
end

function ENT:OnRemove()
	zpiz.Oven.OnRemove(self)
end
