--[[ MODEL INFO
Recommended FOV: 85

Hold type: pistol

--]]

if SERVER then
    AddCSLuaFile( "shared.lua" )
end

if CLIENT then
    SWEP.PrintName = CH_ATM.LangString( "Credit Card" )
    SWEP.Slot = 2
    SWEP.SlotPos = 4
    SWEP.DrawAmmo = false
end

SWEP.Author         = "Crap-Head"
SWEP.Instructions   = CH_ATM.LangString( "Left or right click while looking at a card scanner to pay the owner." )
SWEP.Category 		= "ATM by Crap-Head"

SWEP.ViewModelFOV   = 85
SWEP.ViewModelFlip  = false
SWEP.UseHands		= true
SWEP.AnimPrefix  	= "pistol"

SWEP.Spawnable      	= true
SWEP.AdminSpawnable     = true

SWEP.ViewModel = "models/craphead_scripts/ch_atm/c_suitcard.mdl"
SWEP.WorldModel = "models/craphead_scripts/ch_atm/w_suitcard.mdl"

SWEP.Primary.ClipSize     	= -1
SWEP.Primary.DefaultClip   	= 0
SWEP.Primary.Automatic    	= false
SWEP.Primary.Ammo 			= ""

SWEP.Secondary.ClipSize  	= -1
SWEP.Secondary.DefaultClip  = 0
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = ""

function SWEP:Initialize()
    self:SetHoldType( "pistol" )
end

function SWEP:Deploy()
    self:SetHoldType( "pistol" )
	self:SendWeaponAnim( ACT_VM_DRAW )
end

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()
	local trace = ply:GetEyeTrace()
	local ent = trace.Entity
	
    if CLIENT then return end
	
	-- Do delay
	self:SetNextPrimaryFire( CurTime() + CH_ATM.Config.UseCreditCardDelay )
	self:SetNextSecondaryFire( CurTime() + CH_ATM.Config.UseCreditCardDelay )
	
	-- Check if credit card activation is enabled and then check if target ent is ATM
	if CH_ATM.Config.ActivateWithCreditCard and ent:GetClass() == "ch_atm" then
		-- Check distance to ATM
		if ply:GetPos():DistToSqr( ent:GetPos() ) > CH_ATM.Config.DistanceToScreen3D2D then
			CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "Please move closer to the ATM." ) )
			return
		end
		
		-- Stop if it's in use (this is also checked in ActivateATM, but we don't want to run other code if IsInUse
		if ent.IsInUse then
			--return
		end
		
		if ent:GetIsBeingHacked() or ent:GetIsHackCooldown() then
			return
		end
		
		-- Run code to insert credit card into ATM visually
		CH_ATM.InsertCreditCardATM( ent )
		
		-- Strip credit card from player
		ply:StripWeapon( "weapon_ch_atm_card" )
		
		-- Activate ATM
		net.Start( "CH_ATM_Net_InsertCreditCard" )
			net.WriteEntity( ent )
		net.Send( ply )
		
		ent:ActivateATM( ply, true )
		
		return
	end
	
	-- Check that entity is card scanner or ATM
	if ent:GetClass() != "ch_atm_card_scanner" then
		return
	end
	
	-- Check if terminal is ready to scan
	if not ent:GetIsReadyToScan() then
		CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "The credit card scanner is not ready to take your card. Waiting for owner..." ) )
		return
	end
	
	-- Check distance to terminal
	if ply:GetPos():DistToSqr( ent:GetPos() ) > CH_ATM.Config.DistanceToTerminal then
		CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "Please move closer to the credit card scanner." ) )
		return
	end
	
	-- It's ready to scan. Let's pay the man!
	local terminal_owner = ent:CPPIGetOwner()
	local terminal_price = tonumber( ent:GetTerminalPrice() )
	
	-- Check that the terminal has an owner.
	if not IsValid( terminal_owner ) then
		CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "The card scanner terminal does not have a valid owner!" ) )
		return
	end
	
	-- Don't allow to pay via own terminal
	if terminal_owner == ply then
		CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "You cannot swipe your card on your own card scanner terminal!" ) )
		return
	end
	
	-- The price as an int is nil (it's 0)
	if not terminal_price then
		CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "The card scanner terminal price is 0 or below!" ) )
		return
	end
	
	-- ALL GOOD LETS GO
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK_1 )
	
	timer.Simple( 0.8, function()
		if not IsValid( self ) or not IsValid( ent ) then
			return
		end
		
		if CH_ATM.GetMoneyBankAccount( ply ) >= terminal_price then
			-- If transaction can pass
			
			-- Charge buyers bank account
			CH_ATM.TakeMoneyFromBankAccount( ply, terminal_price )
			
			-- bLogs support for buyer/ply and terminal_owner
			hook.Run( "CH_ATM_bLogs_TakeMoney", terminal_price, ply, "Paid via credit card." )
			hook.Run( "CH_ATM_bLogs_ReceiveMoney", terminal_price, terminal_owner, "Received from credit card terminal." )
			
			-- Notify player
			CH_ATM.NotifyPlayer( ply, CH_ATM.FormatMoney( terminal_price ) .." ".. CH_ATM.LangString( "has been charged from your bank account." ) )
			
			-- Notify terminal owner and give them money
			CH_ATM.AddMoneyToBankAccount( terminal_owner, terminal_price )
			
			CH_ATM.NotifyPlayer( terminal_owner, ply:Nick() .." ".. CH_ATM.LangString( "has swiped their credit card on your card terminal." ) )
			CH_ATM.NotifyPlayer( terminal_owner, CH_ATM.FormatMoney( terminal_price ) .." ".. CH_ATM.LangString( "has been added to your bank account." ) )
			
			-- Log transaction (only works with SQL enabled)
			CH_ATM.LogSQLTransaction( ply, "card", terminal_price )
			
			-- Change lights on machine to green
			ent:ChangeLights( true, true )
			
			-- Emit success sound
			ent:EmitSound( "npc/turret_floor/ping.wav", 100 )
			
			-- Reset scanner values
			ent:SetIsReadyToScan( false )
			ent:SetTerminalPrice( "" )
			
			-- Turn off lights again after 2 sec
			timer.Simple( 2, function()
				if IsValid( ent ) then
					ent:ChangeLights( false, false )
				end
			end )
		else
			-- Does not have enough money
			
			-- Notify player
			CH_ATM.NotifyPlayer( ply, CH_ATM.LangString( "You don't have this much money!" ) )
			
			-- Change lights on machine to red
			ent:ChangeLights( false, true )
			
			-- Emit failed sound
			ent:EmitSound( "common/warning.wav", 100 )
			
			-- Turn off lights again after 2 sec
			timer.Simple( 2, function()
				if IsValid( ent ) then
					ent:ChangeLights( false, false )
				end
			end )
		end
	end )
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end

-- Crosshair
function SWEP:DoDrawCrosshair( x, y )
	local size = 16
	
	surface.SetDrawColor( color_white )
	surface.SetMaterial( CH_ATM.Materials.Crosshair )
	surface.DrawTexturedRect( x - 6.5, y - 6.5, size, size )
	return true
end