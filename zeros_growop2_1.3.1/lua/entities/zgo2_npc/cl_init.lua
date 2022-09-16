include("shared.lua")

function ENT:Initialize()
	zgo2.NPC.Initialize(self)
end

function ENT:Draw()
	self:DrawModel()
	zgo2.NPC.Draw(self)
end
