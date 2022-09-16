include("shared.lua")
SWEP.PrintName = "Weed Sniffer" -- The name of your SWEP
SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true -- Do you want the SWEP to have a crosshair?

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + zgo2.config.Sniffer.interval)
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + zgo2.config.Sniffer.interval)
end
