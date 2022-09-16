include("shared.lua")

function ENT:Initialize()
	ztm.Recycler.Initialize(self)
end

function ENT:Draw()
	self:DrawModel()
	ztm.Recycler.Draw(self)
end

function ENT:Think()
	ztm.Recycler.Think(self)
	self:SetNextClientThink(CurTime())

	return true
end

function ENT:UpdateVisuals()
	ztm.Recycler.UpdateVisuals(self)
end

function ENT:OnRemove()
	ztm.Recycler.OnRemove(self)
end
