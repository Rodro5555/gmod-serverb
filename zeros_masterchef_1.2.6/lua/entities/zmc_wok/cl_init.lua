include("shared.lua")

function ENT:Initialize()
	zmc.Wok.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmc.Wok.Draw(self)
end

function ENT:Think()
	zmc.Wok.Think(self)
end

function ENT:OnRemove()
	zmc.Wok.OnRemove(self)
end
