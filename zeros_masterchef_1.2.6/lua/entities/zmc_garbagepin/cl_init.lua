include("shared.lua")

function ENT:Initialize()
	zmc.Garbagebin.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmc.Garbagebin.Draw(self)
end
