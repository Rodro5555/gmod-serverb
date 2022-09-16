include("shared.lua")

function ENT:Initialize()
	zmc.Worktable.Initialize(self)
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
	self:DrawModel()
	zmc.Worktable.Draw(self)
end

function ENT:Think()
	zmc.Worktable.Think(self)
end

function ENT:OnRemove()
	zmc.Worktable.OnRemove(self)
end
