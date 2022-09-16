include("shared.lua")

function ENT:Initialize()
	ztm.Trash.Initialize(self)
end

function ENT:Draw()
	self:DrawModel()
	ztm.Trash.Draw(self)
end

function ENT:OnRemove()
	ztm.Trash.OnRemove(self)
end
