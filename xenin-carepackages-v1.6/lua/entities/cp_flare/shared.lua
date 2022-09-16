ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Flare"
ENT.Author = "sleeppyy"
ENT.Category = "Xenin"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:IsStill()
	local velocity = self:GetVelocity():Length()

	if (velocity <= 10) then
		self.HasBeenStill = true

		return true
	end
end