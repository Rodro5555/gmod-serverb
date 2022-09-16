include("shared.lua")

function ENT:Draw()
	self:DrawModel()
	zrush.Modules.Draw(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Think()
	self:SetNextClientThink(CurTime())

	return true
end
