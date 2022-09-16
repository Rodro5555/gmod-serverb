
AddCSLuaFile()

SWEP.PrintName = "RWC-Axe"
SWEP.Author = "Avatik & Jhon"
SWEP.Purpose = ""

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.Category = "Realistic-WoodCutter"

SWEP.ViewModel = Model("models/wasted/wasted_uniserv_axe_c.mdl")
SWEP.WorldModel = Model("models/wasted/wasted_uniserv_axe_w.mdl")
SWEP.ViewModelFOV = 48
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Delay = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false

SWEP.HitDistance = 200

function SWEP:Initialize() end

function SWEP:Deploy()
	self:SetHoldType("melee2")
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	return true
end

function SWEP:PrimaryAttack()
	if not IsValid(self.Owner) then return end
	
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)

	timer.Create("rwc_test", 0.8, 1, function()
		local ent = self:GetOwner():GetEyeTrace().Entity
		if ent:GetClass() == "realistic_woodcutter_maintree" then
			if ent:GetPos():Distance(self.Owner:GetPos()) < 150 then 
				self.Weapon:EmitSound("ambient/misc/shutter2.wav")

				if SERVER then
					ent:TakeDamage(15, self:GetOwner(), self)
				end
			end 
		end
	end)
end

if CLIENT then
	-- 349d068a3ca1ddf48cf2c06db96fbeee097e494b67f777a19e99cac1a1665904
	function SWEP:DrawWorldModel()
		local hand, offset, rotate 

		if not IsValid(self.Owner) then
			self:DrawModel()
			return
		end

		hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

		offset = hand.Ang:Right() * 0 + hand.Ang:Forward() * 0 + hand.Ang:Up() * -8

		hand.Ang:RotateAroundAxis(hand.Ang:Right(), 10)
		hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
		hand.Ang:RotateAroundAxis(hand.Ang:Up(), 0)

		self:SetRenderOrigin(hand.Pos + offset)
		self:SetRenderAngles(hand.Ang)

		self:DrawModel()

		if (CLIENT) then
			self:SetModelScale(1,1,1)
		end
	end
end
