include("shared.lua")

function ENT:Initialize()
	zmlab2.Filter.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmlab2.Filter.Draw(self)
end

function ENT:OnRemove()
    zmlab2.Filter.OnRemove(self)
end
