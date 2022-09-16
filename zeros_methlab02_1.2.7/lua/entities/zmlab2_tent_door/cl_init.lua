include("shared.lua")

function ENT:Initialize()
	zmlab2.TentDoor.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmlab2.TentDoor.Draw(self)
end

function ENT:Think()
	self:SetNextClientThink(CurTime())
	zmlab2.TentDoor.Think(self)

	return true
end
