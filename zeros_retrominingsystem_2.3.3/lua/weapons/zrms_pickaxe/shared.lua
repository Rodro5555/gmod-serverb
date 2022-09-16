include("zrmine_config.lua")
SWEP.PrintName = "Pickaxe" -- The name of your SWEP
SWEP.Author = "ZeroChain" -- Your name
SWEP.Instructions = "LMB - Harvest Ore | RMB - Fill Crusher/Crate" -- How do people use your SWEP?
SWEP.Contact = "https://www.gmodstore.com/users/ZeroChain" -- How people should contact you if they find bugs, errors, etc
SWEP.Purpose = "Used to mine Ore." -- What is the purpose of the SWEP?
SWEP.AdminSpawnable = false -- Is the SWEP spawnable for admins?
SWEP.Spawnable = true -- Can everybody spawn this SWEP? - If you want only admins to spawn it, keep this false and admin spawnable true.

SWEP.ViewModelFOV = 55 -- How much of the weapon do you see?
SWEP.ViewModel = "models/zerochain/props_mining/zrms_v_pickaxe.mdl"
SWEP.WorldModel = "models/zerochain/props_mining/zrms_w_pickaxe.mdl"
SWEP.UseHands = false

SWEP.AutoSwitchTo = false -- When someone picks up the SWEP, should it automatically change to your SWEP?
SWEP.AutoSwitchFrom = true -- Should the weapon change to the a different SWEP if another SWEP is picked up?
SWEP.Slot = 1 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6)
SWEP.SlotPos = 1 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.HoldType = "melee2" -- How is the SWEP held? (Pistol SMG Grenade Melee)
SWEP.FiresUnderwater = false -- Does your SWEP fire under water?
SWEP.Weight = 5 -- Set the weight of your SWEP.
SWEP.DrawCrosshair = true -- Do you want the SWEP to have a crosshair?
SWEP.Category = "Zeros RetroMiningSystem"
SWEP.DrawAmmo = false -- Does the ammo show up when you are using it? True / False
SWEP.base = "weapon_base" --What your weapon is based on.
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Recoil = 1
SWEP.Primary.Delay = 1
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Recoil = 1
SWEP.Secondary.Delay = 1

-- How much do we fill in the crusher per click
SWEP.FillAmount = 10

-- How much could we harvest with 1 hit at max
SWEP.MaxHarvestRate = 2

-- How much can we hold per resource
SWEP.HoldAmount = 25

-- Whats the time range between each hits
SWEP.MaxInterval = 0.7
SWEP.MinInterval = 0.5

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 3, "PlayerLVL")
	self:NetworkVar("Int", 0, "PlayerXP")
	self:NetworkVar("Int", 1, "NextXP")

	self:NetworkVar("Float", 7, "HarvestAmount")
	self:NetworkVar("Float", 8, "HarvestInterval")
	self:NetworkVar("Float", 9, "OreInv")
	self:NetworkVar("Float", 10, "FillCap")

	self:NetworkVar("Float", 0, "NextCoolDown")
	self:NetworkVar("Float", 1, "CoolDown")

	self:NetworkVar("Float", 2, "Iron")
	self:NetworkVar("Float", 3, "Bronze")
	self:NetworkVar("Float", 4, "Silver")
	self:NetworkVar("Float", 5, "Gold")
	self:NetworkVar("Float", 6, "Coal")

	if (SERVER) then
		self:SetPlayerLVL(0)
		self:SetPlayerXP(0)
		self:SetHarvestAmount(1)
		self:SetHarvestInterval(1)
		self:SetOreInv(1)
		self:SetFillCap(10)
		self:SetNextXP(999999)
		self:SetNextCoolDown(1)
		self:SetCoolDown(-1)
		self:SetIron(0)
		self:SetBronze(0)
		self:SetSilver(0)
		self:SetGold(0)
		self:SetCoal(0)
	end
end
