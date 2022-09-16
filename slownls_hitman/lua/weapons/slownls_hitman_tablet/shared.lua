--[[  
    Addon: Hitman
    By: SlownLS
]]

AddCSLuaFile()

SWEP.PrintName = "Tablet"
SWEP.Author = "sterlingpierce & SlownLS"

SWEP.Category = "SlownLS | Hitman"

SWEP.DrawAmmo = false
SWEP.Base = "weapon_base"
SWEP.Spawnable = true

SWEP.ViewModel = Model("models/sterling/c_slown_mediapad.mdl")
SWEP.WorldModel = Model("models/sterling/w_slown_mediapad.mdl")
SWEP.ViewModelFOV = 85

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.strHoldType = "crossbow"
SWEP.boolFocus = false

-- SWEP.BobScale = 0
-- SWEP.SwayScale = 0

function SWEP:playAnimation(act)
	self.Weapon:SendWeaponAnim(act)
end

function SWEP:removeTimer()
	if( timer.Exists("SlownLS:Hitman:OpenTablet") ) then
		timer.Destroy("SlownLS:Hitman:OpenTablet")
	end
end

function SWEP:getAttach(vm, str)
	local intId = vm:LookupAttachment(str)
	local tbl = vm:GetAttachment(intId)

	return tbl
end

function SWEP:unfocus()
	self:removeTimer()

	if( self.boolFocus ) then
		self:playAnimation(ACT_VM_IDLE)
		self.boolFocus = false
	end
end

function SWEP:focus()
	if( not self.boolFocus ) then
		self:playAnimation(ACT_VM_PRIMARYATTACK_1)
		self.boolFocus = true

		local intSequence = 1
		local intTime = self:SequenceDuration(intSequence)

		if( CLIENT ) then
			if( timer.Exists("SlownLS:Hitman:OpenTablet") ) then
				timer.Destroy("SlownLS:Hitman:OpenTablet")
			end

			timer.Create("SlownLS:Hitman:OpenTablet", intTime, 1, function()
				SlownLS.Hitman:openTablet(self) 
			end)
		end
	end
end

function SWEP:PrimaryAttack()	
	self:SetNextPrimaryFire(CurTime() + 1)

	self:focus()
end 

function SWEP:SecondaryAttack()
	self:unfocus()
end

function SWEP:Reload()
	self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
end

function SWEP:Hostler()
	self:removeTimer()
	return true
end

function SWEP:Deploy()
	self:removeTimer()
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.strHoldType)
end

--[[ Networks ]]

SlownLS.Hitman:addEvent("close_tablet", function(_,pPlayer)
	if( CLIENT ) then
		pPlayer = LocalPlayer()

		if( SlownLS.Hitman.Tablet and IsValid(SlownLS.Hitman.Tablet) ) then
			SlownLS.Hitman.Tablet:Remove()
		end
	end

	local entWep = pPlayer:GetActiveWeapon()

	if( IsValid(entWep) && entWep:GetClass() == "slownls_hitman_tablet" ) then
		entWep:unfocus()
	end

	if SERVER then 
		SlownLS.Hitman:sendEvent("close_tablet", {}, pPlayer)
	end
end)