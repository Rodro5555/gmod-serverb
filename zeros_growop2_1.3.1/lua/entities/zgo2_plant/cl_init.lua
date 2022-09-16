include("shared.lua")

function ENT:Initialize()
	zgo2.Plant.Initialize(self)
end

function ENT:Draw()
	zgo2.Plant.OnDraw(self)
end

function ENT:Think()
	zgo2.Plant.OnThink(self)
	self:SetNextClientThink(CurTime() + 1)
    return true
end

function ENT:OnRemove()
	zgo2.Plant.OnRemove(self)
end
