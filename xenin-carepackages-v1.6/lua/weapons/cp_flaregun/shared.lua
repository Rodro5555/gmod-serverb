SWEP.Author = "sleeppyy"
SWEP.Contact = ""
SWEP.Purpose = "Shoot flares to call in care packages"
SWEP.Instructions = ""
SWEP.Base = "weapon_base"
SWEP.Gun = ("flaregun_hud")

SWEP.Weight			= 5
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false
SWEP.HoldType			= "pistol"
SWEP.Category 			= "Xenin"
SWEP.PrintName 			= "Flare gun"

SWEP.Secondary.IronFOV			= 60

SWEP.Slot = 1
SWEP.SlotPos = 3
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.BounceWeaponIcon   	= false

SWEP.ViewModel = "models/weapons/v_flaregun.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"

SWEP.Primary.Sound = Sound("weapons/flaregun/fire.wav")
SWEP.Primary.NumShots = 1
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 1
--SWEP.Primary.Ammo = "xd"


SWEP.SightsPos = Vector(-5.64, -6.535, 2.68)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector (2, -5, -5)
SWEP.RunSightsAng = Vector (15, 0, 0)

function SWEP:PrimaryAttack()
	if (self:Clip1() <= 0) then return end
	if (self:GetNextPrimaryFire() > CurTime()) then return end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:ShootFlare()
	self:EmitSound(self.Primary.Sound)
	self:SetClip1(self:Clip1() -1)
end

function SWEP:ShootFlare()
	if (CLIENT) then return end

	local flare = ents.Create("cp_flare")
	if (!IsValid(flare)) then return end
	flare:SetPos(self.Owner:GetShootPos())
	flare:SetAngles(self.Owner:GetAimVector():Angle())
	flare:SetKeyValue("scale", "4")
	--flare:EmitSound("Weapon_Flaregun.Burn")
	flare:Spawn()
	--SafeRemoveEntityDelayed(flare, 15)
	flare:Activate()
	flare:SetOwner(self.Owner)

	local phys = flare:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:ApplyForceCenter(self.Owner:GetAimVector() * 5000)
	end

	self.Owner:StripWeapon("cp_flaregun")
end

function SWEP:SecondaryAttack()
end

function SWEP:Initialize()
	if (CLIENT) then
		local oldpath = "vgui/hud/name"
		local newpath = string.gsub(oldpath, "name", self.Gun)
		self.WepSelectIcon = surface.GetTextureID(newpath)
	end
end

function SWEP:Reload() end