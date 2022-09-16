--[[ INFO
#Medpack
models/craphead_scripts/paramedic_essentials/weapons/c_medpack.mdl
models/craphead_scripts/paramedic_essentials/weapons/w_medpack.mdl
FOV: 85
Hold type: slam
Bodygroups: 0/1
Events: On 'use' sequence, { event AE_NPC_MUZZLEFLASH 38 }  { event AE_MUZZLEFLASH 80 }
Sequences:
(sequence_name       activity)
idle 		ACT_IDLE
use 		ACT_VM_PRIMARYATTACK
draw 		ACT_VM_DRAW
--]]

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.ViewModelFOV		= 89
	SWEP.ViewModelFlip		= false
	SWEP.PrintName			= CH_AdvMedic.Config.Lang["Health Kit"][CH_AdvMedic.Config.Language]			
	SWEP.Author				= "Crap-Head"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
end

SWEP.Author					= "Crap-Head"
SWEP.Instructions 			= CH_AdvMedic.Config.Lang["Left Click: Heal target, Right Click: Heal yourself"][CH_AdvMedic.Config.Language]
SWEP.Category 				= "Paramedic Essentials"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.ViewModel 				= "models/craphead_scripts/paramedic_essentials/weapons/c_medpack.mdl"
SWEP.WorldModel				= "models/craphead_scripts/paramedic_essentials/weapons/w_medpack.mdl"
SWEP.UseHands				= true

SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= -1
SWEP.Primary.Cone			= 0.005
SWEP.Primary.Delay			= 1.0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0

SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

function SWEP:Initialize()
	self:SetWeaponHoldType( "slam" )
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self.Weapon:SetNWInt( "WeaponCharge", 100 )
end

function SWEP:PrimaryAttack()
	if self.Weapon:GetNWInt( "WeaponCharge") <= 0 then
		return
	end
	
    local tr = self.Owner:GetEyeTrace()
	local TargetHealth = tr.Entity:Health()
	
	local target = tr.Entity
	
	if not target or not target:IsPlayer() then 
		return 
	end
	
	if self.Owner:EyePos():DistToSqr( tr.HitPos ) > CH_AdvMedic.Config.HealDistanceToTarget then
		if SERVER then
			DarkRP.notify( self.Owner, 1, 7,  CH_AdvMedic.Config.Lang["You must move closer to the target to heal them."][CH_AdvMedic.Config.Language] )
		end
		return 
	end
	
	if TargetHealth >= target:GetMaxHealth() then 
		return 
	end
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	
    self:SetNextPrimaryFire( CurTime() + CH_AdvMedic.Config.MedkitHealDelay )
	self:SetNextSecondaryFire( CurTime() + CH_AdvMedic.Config.MedkitHealDelay )
	
	local target_new_health = math.Clamp( ( TargetHealth + math.random( CH_AdvMedic.Config.MinHealthToGive, CH_AdvMedic.Config.MaxHealthToGive ) ), 0, target:GetMaxHealth() )
	
    target:SetHealth( target_new_health )
	self.Weapon:SetNWInt( "WeaponCharge", self.Weapon:GetNWInt( "WeaponCharge") - math.random( 1, 3 ) )
    self:EmitSound( "hl1/fvox/boop.wav", 150, TargetHealth / target:GetMaxHealth() * 100, 1, CHAN_AUTO )
	
	if target_new_health >= CH_AdvMedic.Config.MinHealthFixInjury then
		if SERVER then
			if target:HasInjury() then
				ADV_MEDIC_DMG_FixInjuries( target, true )
			end
		end
	end
end

function SWEP:SecondaryAttack()
	if self.Weapon:GetNWInt( "WeaponCharge") <= 0 then
		return
	end
    
	self:SetNextPrimaryFire( CurTime() + CH_AdvMedic.Config.MedkitHealDelay )
	self:SetNextSecondaryFire( CurTime() + CH_AdvMedic.Config.MedkitHealDelay )

	local PlayerHealth = self.Owner:Health()
	
    if PlayerHealth < self.Owner:GetMaxHealth() then
		local target_new_health = math.Clamp( ( PlayerHealth + math.random( CH_AdvMedic.Config.MinHealthToGive, CH_AdvMedic.Config.MaxHealthToGive ) ), 0, self.Owner:GetMaxHealth() )
		
        self.Owner:SetHealth( target_new_health )
		self.Weapon:SetNWInt( "WeaponCharge", self.Weapon:GetNWInt( "WeaponCharge" ) - math.random( 1, 3 ) )
        self:EmitSound( "hl1/fvox/boop.wav", 150, PlayerHealth / self.Owner:GetMaxHealth() * 100, 1, CHAN_AUTO )
		
		if target_new_health >= CH_AdvMedic.Config.MinHealthFixInjury then
			if SERVER then
				if self.Owner:HasInjury() then
					ADV_MEDIC_DMG_FixInjuries( self.Owner, true )
				end
			end
		end
    end
end

local col_outline = Color( 20, 0, 0, 255 )

if CLIENT then
	function SWEP:PostDrawViewModel( vm, wep, ply )
		if ( IsValid( vm ) ) then

			local ComPos = vm:GetAttachment( 1 ).Pos
			local ComAng = vm:GetAttachment( 1 ).Ang
			
			ComAng:RotateAroundAxis( ComAng:Up(), -90 )
			
			cam.Start3D2D( ComPos, ComAng, 0.02 )
				draw.SimpleTextOutlined( CH_AdvMedic.Config.Lang["Charge:"][CH_AdvMedic.Config.Language] .." ".. math.Clamp( math.Round(self.Weapon:GetNWInt( "WeaponCharge" ), 1), 0, 100) .."%", "MEDIC_RechargeStationMedium", 90, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.2, col_outline )
			cam.End3D2D()
		end
	end
end

local mat_close_btn = Material( "craphead_scripts/medic_ui/close.png" )

function SWEP:DoDrawCrosshair( x, y )
	local size = 16

	surface.SetDrawColor( color_white )
	surface.SetMaterial( mat_close_btn )
	surface.DrawTexturedRect( x, y, size, size )
	return true
end