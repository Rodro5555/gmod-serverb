include("shared.lua")

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zrush.Machinecrate.Draw(self)
end
