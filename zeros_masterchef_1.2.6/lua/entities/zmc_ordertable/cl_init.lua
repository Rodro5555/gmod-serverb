include("shared.lua")

function ENT:Initialize()
	zmc.Ordertable.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmc.Ordertable.Draw(self)
end

function ENT:Think()
	zmc.Ordertable.Think(self)
end

function ENT:OnRemove()
	zmc.Ordertable.OnRemove(self)
end
