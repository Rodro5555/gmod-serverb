include("shared.lua")

function ENT:Initialize()
	zmc.Washtable.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmc.Washtable.Draw(self)
end

function ENT:Think()
	zmc.Washtable.Think(self)
end

function ENT:OnRemove()
	zmc.Washtable.OnRemove(self)
end
