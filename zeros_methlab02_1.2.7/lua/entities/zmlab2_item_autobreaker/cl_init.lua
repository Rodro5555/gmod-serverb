include("shared.lua")

function ENT:Initialize()

end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
end
