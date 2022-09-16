include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Initialize()
	zrush.DrillpipeHolder.Initialize(self)
end

function ENT:Think()
	zrush.DrillpipeHolder.Think(self)
end

function ENT:OnRemove()
	zrush.DrillpipeHolder.OnRemove(self)
end
