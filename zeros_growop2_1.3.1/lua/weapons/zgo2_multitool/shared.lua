SWEP.PrintName = "Shop Tablet"
SWEP.Author = "ZeroChain"
SWEP.Instructions = ""
SWEP.Contact = ""
SWEP.Purpose = "Does a lot of things."
SWEP.AdminSpawnable = false
SWEP.Spawnable = true

SWEP.AutomaticFrameAdvance = true
SWEP.ViewModelFOV = 90
SWEP.ViewModel = "models/zerochain/props_growop2/zgo2_tablet_vm.mdl"
SWEP.WorldModel = "models/zerochain/props_growop2/zgo2_tablet.mdl"
SWEP.UseHands = true

//SWEP.AutoSwitchTo = false
//SWEP.AutoSwitchFrom = true
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.HoldType = "normal"
SWEP.FiresUnderwater = false
SWEP.Weight = 5
SWEP.DrawCrosshair = true
SWEP.Category = "Zeros GrowOP 2"
SWEP.DrawAmmo = false
SWEP.base = "weapon_base"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Recoil = 1
SWEP.Primary.Delay = 0.25

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Recoil = 1
SWEP.Secondary.Delay = 1

if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("zerochain/zgo2/vgui/zgo2_multitool")
end
