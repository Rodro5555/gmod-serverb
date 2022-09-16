include("shared.lua")

function ENT:Initialize()
	zmlab2.Ventilation.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmlab2.Ventilation.Draw(self)
end

function ENT:Think()
	zmlab2.Ventilation.OnThink(self)
end

function ENT:OnRemove()
	zmlab2.Ventilation.OnRemove(self)
end
