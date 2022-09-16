SWEP.PrintName = "Bong" // The name of your SWEP
SWEP.Author = "ZeroChain" // Your name
SWEP.Instructions = "Hold LMB: Smoke Weed | RMB: Add Weed | MMB: Drop / Share | Reload: Empty Bong" // How do people use your SWEP?
SWEP.Purpose = "Used to smoke weed." // What is the purpose of the SWEP?
SWEP.IconLetter	= "V"

SWEP.AutomaticFrameAdvance = true

SWEP.AdminSpawnable = false // Is the SWEP spawnable for admins?
SWEP.Spawnable = false // Can everybody spawn this SWEP? - If you want only admins to spawn it, keep this false and admin spawnable true.

SWEP.ViewModelFOV = 90 // How much of the weapon do you see?
SWEP.UseHands = true
SWEP.ViewModel = "models/zerochain/props_growop2/zgo2_bong02_vm.mdl"
SWEP.WorldModel = "models/zerochain/props_growop2/zgo2_bong02_wm.mdl"


SWEP.AutoSwitchTo = true // When someone picks up the SWEP, should it automatically change to your SWEP?
SWEP.AutoSwitchFrom = false // Should the weapon change to the a different SWEP if another SWEP is picked up?
SWEP.Slot = 3 // Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6)
SWEP.SlotPos = 1 // Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.HoldType = "slam" // How is the SWEP held? (Pistol SMG Grenade Melee)
SWEP.FiresUnderwater = false // Does your SWEP fire under water?
SWEP.Weight = 5 // Set the weight of your SWEP.
SWEP.DrawCrosshair = true // Do you want the SWEP to have a crosshair?
SWEP.Category = "Zeros GrowOP 2"
SWEP.DrawAmmo = false // Does the ammo show up when you are using it? True / False
SWEP.base = "weapon_base" //What your weapon is based on.

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Recoil = 1
SWEP.Primary.Delay = 1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Recoil = 1
SWEP.Secondary.Delay = 1



function SWEP:SetupDataTables()

	self:NetworkVar("Int", 3, "BongID")

    self:NetworkVar("Int", 1, "WeedID")
	self:NetworkVar("Int", 2, "WeedAmount")
	self:NetworkVar("Int", 4, "WeedTHC")

    self:NetworkVar("Bool", 0, "IsBusy")
    self:NetworkVar("Bool", 2, "IsBurning")
    self:NetworkVar("Bool", 3, "IsSmoking")

    if (SERVER) then
		self:SetBongID(1)
        self:SetWeedID(0)
		self:SetWeedAmount(0)
		self:SetWeedTHC(0)

        self:SetIsBusy(false)
        self:SetIsBurning(false)
        self:SetIsSmoking(false)
    end
end

/*
	If someone asks what the world model is
*/
function SWEP:GetWeaponWorldModel()
	local BongTypeData = zgo2.Bong.GetTypeData(Bong:GetBongID())
	return BongTypeData.wm
end

function SWEP:GetWeaponViewModel()
	local BongTypeData = zgo2.Bong.GetTypeData(Bong:GetBongID())
	return BongTypeData.vm
end
