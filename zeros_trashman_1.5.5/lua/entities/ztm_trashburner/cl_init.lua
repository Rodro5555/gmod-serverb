include("shared.lua")

function ENT:Initialize()
	ztm.Trashburner.Initialize(self)
end

function ENT:Draw()
	self:DrawModel()
	ztm.Trashburner.Draw(self)
end

function ENT:Think()
	ztm.Trashburner.Think(self)
	self:SetNextClientThink(CurTime())

	return true
end

function ENT:UpdateVisuals()
	ztm.Trashburner.UpdateVisuals(self)
end

function ENT:Remove()
	ztm.Trashburner.Remove(self)
end
