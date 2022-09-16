include("shared.lua")

function ENT:Initialize()
	zgo2.DoobyTable.Initialize(self)
end

function ENT:Draw()
	zgo2.DoobyTable.Draw(self)
end

function ENT:Think()
	zgo2.DoobyTable.Think(self)
	self:SetNextClientThink(CurTime())

	return true
end
