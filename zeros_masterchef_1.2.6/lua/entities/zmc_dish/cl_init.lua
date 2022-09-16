include("shared.lua")

function ENT:Initialize()
	zmc.Dish.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmc.Dish.Draw(self)
end

function ENT:Think()
	zmc.Dish.Think(self)
end

function ENT:OnRemove()
	zmc.Dish.OnRemove(self)
end
