include("shared.lua")

function ENT:Initialize()
	zmlab2.Furnace.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmlab2.Furnace.Draw(self)
end

function ENT:OnRemove()
	zmlab2.Furnace.OnRemove(self)
end
