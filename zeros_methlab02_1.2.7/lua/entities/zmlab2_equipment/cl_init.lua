include("shared.lua")

function ENT:Initialize()
	zmlab2.Equipment.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmlab2.Equipment.DrawUI(self)
end

function ENT:OnRemove()
	zmlab2.Equipment.OnRemove(self)
end
