include("shared.lua")

function ENT:Initialize()
	zmlab2.NPC.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmlab2.NPC.Draw(self)
end
