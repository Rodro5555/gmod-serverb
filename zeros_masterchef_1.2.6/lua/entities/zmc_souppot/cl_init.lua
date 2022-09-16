include("shared.lua")

function ENT:Initialize()
	zmc.SoupPot.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmc.SoupPot.Draw(self)
end

function ENT:Think()
	zmc.SoupPot.Think(self)
end

function ENT:OnRemove()
	zmc.SoupPot.OnRemove(self)
end

function ENT:OnReDraw()
	zmc.SoupPot.OnReDraw(self)
end
