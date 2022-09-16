include("shared.lua")

function ENT:Initialize()
	zmc.Customertable.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmc.Customertable.Draw(self)
end

function ENT:Think()
	zmc.Customertable.Think(self)
end

function ENT:OnRemove()
	zmc.Customertable.OnRemove(self)
end
