--[[ INFO
#Defibrilator
models/craphead_scripts/paramedic_essentials/weapons/c_defibrilator.mdl
models/craphead_scripts/paramedic_essentials/weapons/w_defibrilator.mdl
FOV: 65
Hold type: duel
Skins: 0/1/2/3/4
Sequences:
(sequence_name       activity)
idle 		ACT_IDLE
use 		ACT_VM_PRIMARYATTACK
charge 	 	ACT_VM_SECONDARYATTACK
draw 		ACT_VM_DRAW
--]]

if SERVER then
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= CH_AdvMedic.Config.Lang["Defibrillator"][CH_AdvMedic.Config.Language]
	SWEP.Author				= "Crap-Head"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 1
	SWEP.DrawAmmo			= false
	SWEP.DrawWeaponInfoBox	= false
	SWEP.BounceWeaponIcon   = false
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0
end

SWEP.Author				= "Crap-Head"
SWEP.Instructions 		= CH_AdvMedic.Config.Lang["Left Click: Use defib (charge required), Right Click: Charge defib"][CH_AdvMedic.Config.Language]
SWEP.Category 			= "Paramedic Essentials"

SWEP.UseHands			= true
SWEP.ViewModelFOV		= 65

SWEP.ViewModel 				= "models/craphead_scripts/paramedic_essentials/weapons/c_defibrilator.mdl"
SWEP.WorldModel				= "models/craphead_scripts/paramedic_essentials/weapons/w_defibrilator.mdl"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Range			= 120
SWEP.Primary.Recoil			= 4.6
SWEP.Primary.Damage			= 100
SWEP.Primary.Cone			= 0.005
SWEP.Primary.NumShots		= 1

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false	
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()
	self:SetWeaponHoldType( "duel" )
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self.Weapon:SetSkin( 1 )
	self.Weapon:SetNWInt( "DefibCharge", 0 )
	--[[
	timer.Simple( 0.25, function()
		if not IsValid( self.Owner ) then
			return
		end
		
		local vm = self.Owner:GetViewModel()
		vm:SetSubMaterial( 1, "models/craphead_scripts/paramedic_essentials/weapons/defib_scrn" )
	end )
	--]]
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	timer.Simple( 1.2, function()
		if IsValid( self.Weapon ) and IsValid( self.Owner ) then
			if self.Owner:GetActiveWeapon():GetClass() == "defibrillator_advanced" then
				self.Weapon:SendWeaponAnim( ACT_IDLE )
			end
		end
	end )
	
	local vm = self.Owner:GetViewModel()
	
	if self.Weapon:GetNWInt( "DefibCharge" ) == 25 then -- First level
		vm:SetSubMaterial( 1, "models/craphead_scripts/paramedic_essentials/weapons/defib_scrn2" )
	elseif self.Weapon:GetNWInt( "DefibCharge" ) == 50 then -- Second level
		vm:SetSubMaterial( 1, "models/craphead_scripts/paramedic_essentials/weapons/defib_scrn3" )
	elseif self.Weapon:GetNWInt( "DefibCharge" ) == 75 then -- Third level
		vm:SetSubMaterial( 1, "models/craphead_scripts/paramedic_essentials/weapons/defib_scrn4" )
	elseif self.Weapon:GetNWInt( "DefibCharge" ) == 100 then -- Fourth level
		vm:SetSubMaterial( 1, "models/craphead_scripts/paramedic_essentials/weapons/defib_scrn5" )
	end
	
	vm:SetPlaybackRate( 0.7 )
	
	return true
end

function SWEP:Holster( wep )
	if not IsFirstTimePredicted() then
		return
	end
	if not IsValid( self.Owner ) then
		return
	end
	
	local vm = self.Owner:GetViewModel()
	vm:SetSubMaterial( 1, nil )

	return true
end

function SWEP:OnRemove()
	if not IsValid( self.Owner ) then
		return
	end

	local vm = self.Owner:GetViewModel()
	if IsValid( vm ) then
		vm:SetSubMaterial( 1, nil )

		return true
	end
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + CH_AdvMedic.Config.DefibrillatorDelay )
	self.Weapon:SetNextSecondaryFire( CurTime() + CH_AdvMedic.Config.DefibrillatorDelay )
	
    if self.Weapon:GetNWInt( "DefibCharge" ) == 100 then
		local trace = util.GetPlayerTrace( self.Owner )
		local tr = util.TraceLine( trace )
		
		local ent = tr.Entity
	
		if not IsValid( ent ) then
			return
		end
		
		if ent:GetPos():DistToSqr( self.Owner:GetPos() ) > CH_AdvMedic.Config.ReviveDistanceToTarget then
			if SERVER then
				DarkRP.notify( self.Owner, 1, 5, CH_AdvMedic.Config.Lang["You need to move closer to the body."][CH_AdvMedic.Config.Language] )
			end
			return
		end
		
		if ent:GetNWBool( "RagdollIsCorpse" ) then
			self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			self.Weapon:UpdateDefibCharge( true )
			
			timer.Simple( 1.2, function()
				if IsValid( self.Weapon ) and IsValid( self.Owner ) then
					if self.Owner:GetActiveWeapon():GetClass() == "defibrillator_advanced" then
						self.Weapon:SendWeaponAnim( ACT_IDLE )
					end
				end
			end )
			
			if SERVER then
				local chance = math.random( 1, 100 )

				if chance <= CH_AdvMedic.Config.RevivalFailChance then
					DarkRP.notify( self.Owner, 1, 5, CH_AdvMedic.Config.Lang["Your attempt at reviving the player did not work. Recharge and try again!"][CH_AdvMedic.Config.Language] )
					return 
				end
				
				local victim = ent:GetOwner()
				victim.WasRevived = true
				
				victim:Spawn()
				
				if IsValid( victim.DeathRagdoll ) then
					victim:SetPos( victim.DeathRagdoll:GetPos() )
				end
				
				for k, v in pairs( victim.WeaponsOnKilled ) do
					victim:Give( v )
				end
				
				DarkRP.notify( victim, 1, 5, CH_AdvMedic.Config.Lang["A paramedic has saved you from dying!"][CH_AdvMedic.Config.Language] )
				DarkRP.notify( self.Owner, 1, 5, CH_AdvMedic.Config.Lang["You have rescued the dying person!"][CH_AdvMedic.Config.Language] )
				
				if victim.HasLifeAlert then
					DarkRP.notify( self.Owner, 1, 5, "+ ".. DarkRP.formatMoney( CH_AdvMedic.Config.LifeAlertRevivalReward ) .." ".. CH_AdvMedic.Config.Lang["for responding to a life alert!"][CH_AdvMedic.Config.Language] )
					self.Owner:addMoney( CH_AdvMedic.Config.LifeAlertRevivalReward )
				else
					DarkRP.notify( self.Owner, 1, 5, "+ ".. DarkRP.formatMoney( CH_AdvMedic.Config.RevivalReward ) .." ".. CH_AdvMedic.Config.Lang["for reviving a player!"][CH_AdvMedic.Config.Language] )
					self.Owner:addMoney( CH_AdvMedic.Config.RevivalReward )	
				end
				
				self.Owner:EmitSound( "ambient/energy/zap3.wav", 100, 100 )
				self.Owner:ViewPunch( Angle( math.Rand( -3, 3 ) * self.Primary.Recoil, math.Rand( -3, 3 ) * self.Primary.Recoil, 0) )
			end
		end
	else
		if SERVER then
			DarkRP.notify( self.Owner, 1, 5, CH_AdvMedic.Config.Lang["Your defibrillator is not fully charged!"][CH_AdvMedic.Config.Language] )
		end
	end
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + CH_AdvMedic.Config.DefibrillatorDelay )
	self.Weapon:SetNextSecondaryFire( CurTime() + CH_AdvMedic.Config.DefibrillatorDelay )
	
	if self.Weapon:GetNWInt( "DefibCharge" ) >= 100 then
		if SERVER then
			DarkRP.notify( self.Owner, 1, 5, CH_AdvMedic.Config.Lang["Your defibrillator is fully charged! It can be used to revive dead players now."][CH_AdvMedic.Config.Language] )
		end
		return
	end

	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self.Weapon:UpdateDefibCharge( false )
	
	timer.Simple( 1.2, function()
		if IsValid( self.Weapon ) and IsValid( self.Owner ) then
			if self.Owner:GetActiveWeapon():GetClass() == "defibrillator_advanced" then
				self.Weapon:SendWeaponAnim( ACT_IDLE )
			end
		end
	end )
end

function SWEP:UpdateDefibCharge( should_reset )
	if SERVER then
		if should_reset then
			self.Weapon:SetNWInt( "DefibCharge", 0 )
			self.Weapon:SetSkin( 0 )
			return
		end
		
		self.Weapon:SetNWInt( "DefibCharge", self.Weapon:GetNWInt( "DefibCharge" ) + 25 )
		
		if self.Weapon:GetNWInt( "DefibCharge" ) == 25 then -- First level
			self.Owner:EmitSound( "buttons/blip1.wav", 100, 100 )
			self.Weapon:SetSkin( 1 )
			--self.Owner:ChatPrint( "You've charged your defibrillators to level 1" )
		elseif self.Weapon:GetNWInt( "DefibCharge" ) == 50 then -- Second level
			self.Owner:EmitSound( "buttons/blip1.wav", 100, 100 )
			self.Weapon:SetSkin( 2 )
			--self.Owner:ChatPrint( "You've charged your defibrillators to level 2" )
		elseif self.Weapon:GetNWInt( "DefibCharge" ) == 75 then -- Third level
			self.Owner:EmitSound( "buttons/blip1.wav", 100, 100 )
			self.Weapon:SetSkin( 3 )
			--self.Owner:ChatPrint( "You've charged your defibrillators to level 3" )
		elseif self.Weapon:GetNWInt( "DefibCharge" ) == 100 then -- Fourth level
			self.Owner:EmitSound( "buttons/blip1.wav", 100, 100 )
			self.Weapon:SetSkin( 4 )
			--self.Owner:ChatPrint( "You've charged your defibrillators to level 4" )
		end
	end
	
	timer.Simple( 0.25, function()
		local vm = self.Owner:GetViewModel()
		
		if should_reset then
			vm:SetSubMaterial( 1, nil )
			return
		end
		
		if self.Weapon:GetNWInt( "DefibCharge" ) == 25 then -- First level
			vm:SetSubMaterial( 1, "models/craphead_scripts/paramedic_essentials/weapons/defib_scrn2" )
		elseif self.Weapon:GetNWInt( "DefibCharge" ) == 50 then -- Second level
			vm:SetSubMaterial( 1, "models/craphead_scripts/paramedic_essentials/weapons/defib_scrn3" )
		elseif self.Weapon:GetNWInt( "DefibCharge" ) == 75 then -- Third level
			vm:SetSubMaterial( 1, "models/craphead_scripts/paramedic_essentials/weapons/defib_scrn4" )
		elseif self.Weapon:GetNWInt( "DefibCharge" ) == 100 then -- Fourth level
			vm:SetSubMaterial( 1, "models/craphead_scripts/paramedic_essentials/weapons/defib_scrn5" )
		end
	end )
end

local mat_crosshair = Material( "craphead_scripts/medic_ui/close.png" )

function SWEP:DoDrawCrosshair( x, y )
	local size = 16

	surface.SetDrawColor( color_white )
	surface.SetMaterial( mat_crosshair )
	surface.DrawTexturedRect( x, y, size, size )
	return true
end