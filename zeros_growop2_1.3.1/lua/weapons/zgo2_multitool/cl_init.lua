include("shared.lua")
SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()

end

function SWEP:SecondaryAttack()
	zgo2.Multitool.SecondaryAttack(self)
end

function SWEP:Holster(swep)
	zgo2.Multitool.Holster(self)
end
