include("shared.lua")
function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	Diablos.RS.RadarAboveInfos(self)
end