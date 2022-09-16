include("shared.lua")
SWEP.PrintName = "Trash Collector" -- The name of your SWEP
SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true -- Do you want the SWEP to have a crosshair?

function SWEP:Initialize()
	ztm.TrashCollector.Initialize(self)
end

function SWEP:Think()
	ztm.TrashCollector.Think(self)
end

function SWEP:PrimaryAttack()
	ztm.TrashCollector.PrimaryAttack(self)
end

function SWEP:SecondaryAttack()
end

function SWEP:OnRemove()
	ztm.TrashCollector.OnRemove(self)
end

function SWEP:Holster(swep)
	ztm.TrashCollector.Holster(self)
end
