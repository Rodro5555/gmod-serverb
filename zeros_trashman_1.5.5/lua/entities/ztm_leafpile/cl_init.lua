include("shared.lua")

function ENT:Initialize()
	zclib.EntityTracker.Add(self)
end

function ENT:Draw()
	self:DrawModel()
end
