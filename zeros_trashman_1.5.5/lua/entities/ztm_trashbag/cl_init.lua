include("shared.lua")

function ENT:Initialize()
	ztm.Trashbag.Initialize(self)
end

function ENT:Draw()
	self:DrawModel()
	ztm.Trashbag.Draw(self)
end

function ENT:OnRemove()
	ztm.Trashbag.OnRemove(self)
end
