include("shared.lua")

function ENT:Initialize()
	zmc.BoilPot.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmc.BoilPot.Draw(self)
end

function ENT:Think()
	zmc.BoilPot.Think(self)
end

function ENT:OnRemove()
	zmc.BoilPot.OnRemove(self)
end

function ENT:OnTemperaturChange(newTemp)
	zmc.BoilPot.OnTemperaturChange(self, newTemp)
end

function ENT:OnReDraw()
	zmc.BoilPot.OnReDraw(self)
end
