include("shared.lua")

function ENT:Initialize()
	zmlab2.Filler.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmlab2.Filler.Draw(self)
end

function ENT:Think()
    zmlab2.Filler.Think(self)
end

function ENT:OnRemove()
    zmlab2.Filler.OnRemove(self)
end
