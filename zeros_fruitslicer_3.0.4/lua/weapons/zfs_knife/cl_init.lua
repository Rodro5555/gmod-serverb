include("shared.lua")
SWEP.PrintName = "Knife" -- The name of your SWEP
SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true -- Do you want the SWEP to have a crosshair?

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	self.Owner:DoAttackEvent()
	self:SendWeaponAnim(ACT_VM_MISSCENTER)

	local ply = self:GetOwner()
	if not IsValid(ply) then return end
	local tr = ply:GetEyeTrace()

	zclib.Sound.EmitFromEntity("throw", ply)

	if tr and IsValid(tr.Entity) and string.sub(tr.Entity:GetClass(),1,4) == "zfs_" then return end

	if tr and zclib.util.InDistance(ply:GetPos(), tr.HitPos, 100) then
		local bullet = {}
		bullet.Num = 1
		bullet.Src = ply:GetShootPos()
		bullet.Dir = ply:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force = 25
		bullet.Damage = zfs.config.Knife.Damage
		ply:FireBullets(bullet)
	end
end

function SWEP:SecondaryAttack()
	self.Owner:DoAttackEvent()
	self:SendWeaponAnim(ACT_VM_MISSCENTER)
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:Equip()
end
