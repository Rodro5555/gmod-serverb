include("shared.lua")

function ENT:Initialize()
	zmlab2.Palette.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmlab2.Palette.Draw(self)
end

function ENT:OnRemove()
	zmlab2.Palette.OnRemove(self)
end

function ENT:Think()
	zmlab2.Palette.Think(self)
end
