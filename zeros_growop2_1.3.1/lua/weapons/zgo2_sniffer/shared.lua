if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.PrintName = "Weed Sniffer" -- The name of your SWEP
SWEP.Author = "ZeroChain" -- Your name
SWEP.Instructions = "LMB - Sniff for weed." -- How do people use your SWEP?
SWEP.Contact = "https://www.gmodstore.com/users/ZeroChain" -- How people should contact you if they find bugs, errors, etc
SWEP.Purpose = "Detects illegal activity." -- What is the purpose of the SWEP?
SWEP.AdminSpawnable = true -- Is the SWEP spawnable for admins?
SWEP.Spawnable = true -- Can everybody spawn this SWEP? - If you want only admins to spawn it, keep this false and admin spawnable true.
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "rpg"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID("zerochain/zgo2/vgui/zgo2_sniffer")
end

SWEP.AutoSwitchTo = true -- When someone picks up the SWEP, should it automatically change to your SWEP?
SWEP.AutoSwitchFrom = false -- Should the weapon change to the a different SWEP if another SWEP is picked up?
SWEP.Slot = 3 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6)
SWEP.SlotPos = 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.FiresUnderwater = false -- Does your SWEP fire under water?
SWEP.Weight = 5 -- Set the weight of your SWEP.
SWEP.DrawCrosshair = true -- Do you want the SWEP to have a crosshair?
SWEP.Category = "Zeros GrowOP 2"
SWEP.DrawAmmo = false -- Does the ammo show up when you are using it? True / False
SWEP.base = "weapon_base" --What your weapon is based on.
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.UseHands = true

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
end

function SWEP:DrawWorldModel()
end

function SWEP:PreDrawViewModel(vm)
	return true
end

function SWEP:Holster()
	if not SERVER then return true end
	self:GetOwner():DrawViewModel(true)
	self:GetOwner():DrawWorldModel(true)

	return true
end
