--[[ INFO
models/craphead_scripts/the_cocaine_factory/wrench/c_wrench.mdl
models/craphead_scripts/the_cocaine_factory/wrench/w_wrench.mdl
FOV: 65
Hold type: melee
Sequences:
(sequence_name       activity)
idle 		ACT_VM_IDLE
attack 		ACT_VM_PRIMARYATTACK
draw 		ACT_VM_DRAW
--]]

if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= TCF.Config.Lang["Repair Wrench (Cocaine Factory)"][TCF.Config.Language]
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
end

SWEP.Author = "Crap-Head"
SWEP.Instructions = TCF.Config.Lang["Left Click: Use repair wrench while aiming at a cocaine entity."][TCF.Config.Language]

SWEP.ViewModelFOV	= 65
SWEP.ViewModel		= "models/craphead_scripts/the_cocaine_factory/wrench/c_wrench.mdl"
SWEP.WorldModel		= "models/craphead_scripts/the_cocaine_factory/wrench/w_wrench.mdl" 

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "Crap-Head Scripts"

SWEP.UseHands 			= true
SWEP.ViewModelFlip      = false
SWEP.AnimPrefix  		= "stunstick"

SWEP.Primary.Range			= 90
SWEP.Primary.Recoil			= 4.6
SWEP.Primary.Damage			= 2
SWEP.Primary.Cone			= 0.02
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
	self:SetWeaponHoldType( "melee" )
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
end 

function SWEP:Deploy()
	return true
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + 1 )
	self.Weapon:SetNextSecondaryFire( CurTime() + 1 )
	
	local ply = self:GetOwner()
	
 	local trace = util.GetPlayerTrace( ply )
 	local tr = util.TraceLine( trace )
	local ent = tr.Entity
	
	self.Weapon:EmitSound( "weapons/stunstick/stunstick_swing1.wav", 100, math.random( 90, 120 ) )
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	ply:SetAnimation( PLAYER_ATTACK1 )

	if ( ply:GetPos() - tr.HitPos ):Length() < self.Primary.Range then
		ply:ViewPunch( Angle( math.random( -2, 2 ) * self.Primary.Recoil, math.random( -2, 2 ) * self.Primary.Recoil, 0 ) )
		
		if tr.HitNonWorld then
			if SERVER then
				if TCF.Config.HealableCocaineEntityList[ ent:GetClass() ] then
					if ent:GetClass() == "cocaine_stove" then -- stove entity clamp health
						if ent:GetHP() < TCF.Config.StoveHealth then
							ent:SetHP( math.Clamp( ent:GetHP() + math.random( 10, 20 ), 0, TCF.Config.StoveHealth )  )
						else
							DarkRP.notify( ply, 1, 5, TCF.Config.Lang["Your stove has reached its maximum health!"][TCF.Config.Language] )
							return
						end
					elseif ent:GetClass() == "cocaine_extractor" then -- extractor entity clamp health
						if ent:GetHP() < TCF.Config.ExtractorHealth then
							ent:SetHP( math.Clamp( ent:GetHP() + math.random( 10, 20 ), 0, TCF.Config.ExtractorHealth )  )
						else
							DarkRP.notify( ply, 1, 5, TCF.Config.Lang["Your cocaine extractor has reached its maximum health!"][TCF.Config.Language] )
							return
						end
					elseif ent:GetClass() == "cocaine_drying_rack" then -- drying rack entity clamp health
						if ent:GetHP() < TCF.Config.DryingRackHealth then
							ent:SetHP( math.Clamp( ent:GetHP() + math.random( 10, 20 ), 0, TCF.Config.DryingRackHealth )  )
						else
							DarkRP.notify( ply, 1, 5, TCF.Config.Lang["Your drying rack has reached its maximum health!"][TCF.Config.Language] )
							return
						end
					end
					
					DarkRP.notify( ply, 1, 5, TCF.Config.Lang["Entity has been healed."][TCF.Config.Language] )
				elseif ent:IsPlayer() then
					ent:TakeDamage( math.random( 12, 16 ), ply ) 
					ent:SetVelocity( ply:GetAngles():Forward() * 50 + ply:GetAngles():Up() * 10 )
				end
			end

			if TCF.Config.HealableCocaineEntityList[ ent:GetClass() ] then
				self.Weapon:EmitSound( "physics/metal/metal_canister_impact_hard".. math.random( 1, 3 ) ..".wav", 100, math.random( 95, 110 ) )
			elseif tr.Entity:IsPlayer() then
				self.Weapon:EmitSound( "physics/body/body_medium_impact_hard1.wav", 100, math.random( 95, 110 ) )
			end
		else
			self.Weapon:EmitSound( "physics/body/body_medium_impact_hard1.wav", 100, math.random(95,110) )
		end
	end
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + 1 )
	self.Weapon:SetNextSecondaryFire( CurTime() + 1 )
end