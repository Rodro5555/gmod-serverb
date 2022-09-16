include("shared.lua")

function ENT:Initialize()
	zmc.Dishtable.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmc.Dishtable.Draw(self)
end

function ENT:Think()
	zmc.Dishtable.Think(self)
end

function ENT:OnRemove()
	zmc.Dishtable.OnRemove(self)
end
