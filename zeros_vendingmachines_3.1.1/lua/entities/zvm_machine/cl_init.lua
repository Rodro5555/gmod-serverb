include("shared.lua")

function ENT:Initialize()

	zvm.Machine.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
end

// Gets called once the player sees the entity again
function ENT:UpdateVisuals()
	zvm.Machine.UpdateVisuals(self)
end

function ENT:Think()
	zvm.Machine.Think(self)
	self:SetNextClientThink(CurTime())
	return true
end

function ENT:OnRemove()
	zvm.Machine.OnRemove(self)
end
