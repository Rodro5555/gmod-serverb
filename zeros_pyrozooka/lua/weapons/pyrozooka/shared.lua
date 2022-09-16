include("pyrozooka/sh/pyrozooka_config.lua")

if pyrozooka.config.RunOnTTT == true then
	SWEP.Base = "weapon_tttbase"
	SWEP.AmmoEnt = "item_ammo_smg1_ttt"
	SWEP.Icon = "vgui/entities/pyrozooka"
	SWEP.Kind = WEAPON_EQUIP1
	SWEP.CanBuy = { ROLE_TRAITOR }
	SWEP.LimitedStock = false
	SWEP.ViewModelFlip = false
	SWEP.NoSights = false
	SWEP.EquipMenuData = {
      type = "Weapon",
      desc = "Shoot your enemies with this sweet rocket launcher\n perfect for the New Years climate!"
    }
else
	SWEP.Base = "weapon_base"
	SWEP.ViewModelFlip = false
	SWEP.NoSights = false
end

SWEP.Spawnable			= true
SWEP.AdminOnly			= false
SWEP.UseHands			= false

SWEP.PrintName			= "Pyrozooka"
SWEP.Category 			= "Zeros Pyrozooka"
SWEP.Instructions		= "Left click - Shoot Effect | Right click - Shoot Cracker | Reload - Change Color"
SWEP.Purpose			= "Left click - Shoot Effect | Right click - Shoot Cracker | Reload - Change Color"

SWEP.ViewModel			= "models/zerochain/pyrozooka/v_pyrozooka.mdl"
SWEP.WorldModel			= "models/zerochain/pyrozooka/w_pyrozooka.mdl"
SWEP.HoldType 			= "rpg"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.TakeAmmo 		= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Spread 		= 0.1
SWEP.Primary.Recoil 		= 1 // How much recoil does the weapon have?
SWEP.Primary.Delay 			= 0.3 // How long must you wait before you can fire again?
SWEP.Primary.Force 			= 1000 // The force of the shot.
SWEP.Primary.Damage 		= 0
SWEP.Primary.Cone			= 255

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay 		= 0.5 // How long must you wait before you can fire again?

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= true
SWEP.AutoSwitchFrom			= false

SWEP.Slot					= 3
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= true
SWEP.DrawWeaponInfoBox 		= true
SWEP.ViewModelFOV			= 62
