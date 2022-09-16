include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Initialize()
	zrush.Palette.Initialize(self)
end

function ENT:Think()
	zrush.Palette.Think(self)
end

function ENT:OnRemove()
	zrush.Palette.OnRemove(self)
end
