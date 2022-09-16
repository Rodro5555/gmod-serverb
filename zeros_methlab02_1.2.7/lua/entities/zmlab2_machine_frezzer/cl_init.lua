include("shared.lua")

function ENT:Initialize()
	zmlab2.Frezzer.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmlab2.Frezzer.Draw(self)
end

function ENT:Think()
    zmlab2.Frezzer.Think(self)
	self:SetNextClientThink(CurTime())
	return true
end

function ENT:OnRemove()
    zmlab2.Frezzer.OnRemove(self)
end
