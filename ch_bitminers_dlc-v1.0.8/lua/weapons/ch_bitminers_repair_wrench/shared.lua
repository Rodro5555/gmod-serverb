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
	SWEP.PrintName			= CH_Bitminers.LangString( "Repair Wrench (Bitminers)" )
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= true
end

SWEP.Author 				= "Crap-Head"
SWEP.Instructions 			= CH_Bitminers.LangString( "Left Click: Use repair wrench while aiming at a bitminer related entity." )

SWEP.ViewModelFOV			= 75
SWEP.ViewModel				= "models/craphead_scripts/the_cocaine_factory/wrench/c_wrench.mdl"
SWEP.WorldModel				= "models/craphead_scripts/the_cocaine_factory/wrench/w_wrench.mdl" 

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= true
SWEP.Category 				= "Bitminers by Crap-Head"

SWEP.UseHands 				= true
SWEP.ViewModelFlip      	= false
SWEP.AnimPrefix  			= "stunstick"

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
end 

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_DRAW )
	
	local ply = self:GetOwner()
	
	timer.Simple( 0.2, function()
		if IsValid( self ) and IsValid( ply ) then
			if ply:GetActiveWeapon():GetClass() == "ch_bitminers_repair_wrench" then
				self:SendWeaponAnim( ACT_VM_IDLE )
			end
		end
	end )
	return true
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + 1 )
	self:SetNextSecondaryFire( CurTime() + 1 )
	
	local ply = self:GetOwner()
 	local trace = util.GetPlayerTrace( ply )
 	local tr = util.TraceLine( trace )
	local ent = tr.Entity
	
	self:EmitSound( "weapons/stunstick/stunstick_swing1.wav", 100, math.random( 90, 120 ) )
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	ply:SetAnimation( PLAYER_ATTACK1 )
	
	-- Back to idle anim
	timer.Simple( 0.2, function()
		if IsValid( self ) and IsValid( ply ) then
			if ply:GetActiveWeapon():GetClass() == "ch_bitminers_repair_wrench" then
				self:SendWeaponAnim( ACT_VM_IDLE )
			end
		end
	end )
	
	if ( ply:GetPos() - tr.HitPos ):Length() < self.Primary.Range then
		ply:ViewPunch( Angle( math.random( -1, 1 ) * self.Primary.Recoil, math.random( -1, 1 ) * self.Primary.Recoil, 0 ) )
		
		if tr.HitNonWorld then
			if SERVER then
				if CH_Bitminers.ListOfEntities[ ent:GetClass() ] then
					local health_add = math.random( CH_Bitminers_DLC.Config.RepairMinHealth, CH_Bitminers_DLC.Config.RepairMaxHealth )
					
					if ent:Health() < ent:GetMaxHealth() then
						ent:SetHealth( math.Clamp( ent:Health() + health_add, 0, ent:GetMaxHealth() )  )
					else
						CH_Bitminers.NotifyPlayer( ply, CH_Bitminers.LangString( "This bitminer entity has reached it's maximum health!" ) )
						return
					end
					
					CH_Bitminers.NotifyPlayer( ply, CH_Bitminers.LangString( "Bitminer entity has been healed." ) )
				elseif ent:IsPlayer() then
					ent:TakeDamage( math.random( 12, 16 ), ply ) 
					ent:SetVelocity( ply:GetAngles():Forward() * 50 + ply:GetAngles():Up() * 10 )
				end
			end

			if CH_Bitminers.ListOfEntities[ ent:GetClass() ] then
				self:EmitSound( "physics/metal/metal_canister_impact_hard".. math.random( 1, 3 ) ..".wav", 100, math.random( 95, 110 ) )
			elseif tr.Entity:IsPlayer() then
				self:EmitSound( "physics/body/body_medium_impact_hard1.wav", 100, math.random( 95, 110 ) )
			end
		else
			self:EmitSound( "physics/body/body_medium_impact_hard1.wav", 100, math.random(95,110) )
		end
	end
end

function SWEP:SecondaryAttack()
	self:SetNextPrimaryFire( CurTime() + 1 )
	self:SetNextSecondaryFire( CurTime() + 1 )
	
	self:PrimaryAttack()
end

local col_green = Color( 0, 150, 0, 255 )
local prim_col

local entity_height_table = {
	["ch_bitminer_power_cable"] = 2,
	["ch_bitminer_power_cable_end"] = 2,
	["ch_bitminer_power_combiner"] = 10,
	["ch_bitminer_power_generator"] = 25,
	["ch_bitminer_power_generator_fuel"] = 20,
	["ch_bitminer_power_rtg"] = 35,
	["ch_bitminer_power_solar"] = 25,
	--["ch_bitminer_shelf"] = 70, -- it already says on the shelf screen how much health it has
	["ch_bitminer_upgrade_cooling1"] = 3,
	["ch_bitminer_upgrade_cooling2"] = 3,
	["ch_bitminer_upgrade_cooling3"] = 12,
	["ch_bitminer_upgrade_miner"] = 3,
	["ch_bitminer_upgrade_rgb"] = 7,
	["ch_bitminer_upgrade_ups"] = 3
}

function SWEP:DrawHUD()
	for k, ent in ipairs( ents.FindInSphere( LocalPlayer():GetPos(), CH_Bitminers_DLC.Config.ShowHealthDistance ) ) do
		local height = entity_height_table[ ent:GetClass() ]
	
		if not height then
			continue
		end

		local VPos = ent:GetPos() + Vector( 0, 0, height )
		local ScrPos = ( VPos + Vector( 0, 0, 10 )):ToScreen()

		local thetrace = {}
		thetrace.start = LocalPlayer():GetPos() + Vector( 0, 0, height )
		thetrace.endpos = VPos
		thetrace.filter = {LocalPlayer(), ent}
	
		local Trace = util.TraceLine( thetrace )
		
		if not Trace.Hit then
			if ent:Health() >= 75 then -- green
				prim_col = col_green
			elseif ent:Health() >= 50 then -- flash orange
				prim_col = Color( 240 * math.abs( math.sin( CurTime() * 1 ) ), 137 * math.abs( math.sin( CurTime() * 1 ) ), 19 * math.abs( math.sin( CurTime() * 1 ) ), 255 )
			else
				prim_col = Color( 190 * math.abs( math.sin( CurTime() * 1 ) ), 0, 0, 255 )
			end
				
			local outline_col = Color( 0, 0, 0, 255 )
				
			if ent:Health() > 0 then
				draw.SimpleTextOutlined( CH_Bitminers.LangString( "Health:" ) .." ".. ent:Health(), "BITMINER_DLC_TabletSmaller", ScrPos.x, ScrPos.y - 65, prim_col, 1, 1, 1, outline_col )
			end	
		end
	end
end

local mat_crosshair = Material( "craphead_scripts/bitminers/dlc/crosshair.png" )

function SWEP:DoDrawCrosshair( x, y )
	local size = 16

	surface.SetDrawColor( color_white )
	surface.SetMaterial( mat_crosshair )
	surface.DrawTexturedRect( x - 8, y - 8, size, size )
	return true
end