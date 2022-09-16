include("shared.lua")

function ENT:Initialize()
	zmlab2.Storage.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmlab2.Storage.DrawUI(self)
end

function ENT:OnRemove()
	zmlab2.Storage.OnRemove(self)
end
