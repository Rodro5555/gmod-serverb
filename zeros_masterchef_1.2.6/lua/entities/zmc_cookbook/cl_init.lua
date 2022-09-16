include("shared.lua")

function ENT:Initialize()
	zmc.Cookbook.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmc.Cookbook.Draw(self)
end
