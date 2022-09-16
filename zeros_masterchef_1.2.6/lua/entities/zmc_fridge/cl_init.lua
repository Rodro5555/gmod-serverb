include("shared.lua")

function ENT:Initialize()
	zmc.Fridge.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmc.Fridge.Draw(self)
end

function ENT:Think()
	zmc.Fridge.Think(self)
end

function ENT:OnRemove()
	zmc.Fridge.OnRemove(self)
end
