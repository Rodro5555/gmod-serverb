include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:Initialize()
	zcm.f.EntList_Add(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end
