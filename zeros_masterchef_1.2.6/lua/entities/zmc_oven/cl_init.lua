include("shared.lua")

function ENT:Initialize()
	zmc.Oven.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmc.Oven.Draw(self)
end

function ENT:Think()
	zmc.Oven.Think(self)
end

function ENT:OnRemove()
	zmc.Oven.OnRemove(self)
end
