AddCSLuaFile()

SWEP.PrintName = AAS.SwepName
SWEP.Category = "Advanced Accessory System"
SWEP.Author = "Kobralost"
SWEP.Purpose = ""

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.HoldType = "pistol"
SWEP.WorldModel = ""

SWEP.AnimPrefix	 = "pistol"

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:PrimaryAttack()
	if CLIENT then
		if AAS.BuyItemWithSwep then
			AAS.ItemMenu()
		else
			AAS.InventoryMenu(true)
		end
	end
end

function SWEP:SecondaryAttack()
	if CLIENT then
		if AAS.BuyItemWithSwep then
			AAS.ItemMenu()
		else
			AAS.InventoryMenu(true)
		end
	end
end

function SWEP:CanPrimaryAttack() end
function SWEP:CanSecondaryAttack() end

function SWEP:Initialize() self:SetHoldType("pistol") end
function SWEP:DrawWorldModel() end
function SWEP:PreDrawViewModel() return true end