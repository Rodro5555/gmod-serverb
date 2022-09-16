SWEP.ViewModelFlip 			= false
SWEP.Author					= "Venatuss"
SWEP.Instructions			= "Click to use"

SWEP.ViewModel				= Model( "models/sterling/ajr_phone_c.mdl" ) -- just change the model 
SWEP.WorldModel 			= Model( "models/sterling/ajr_phone_w.mdl" )

SWEP.UseHands				= true

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= false

SWEP.Primary.Damage         = 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay 			= 4

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Category 				= "Jewelry Robbery"
SWEP.PrintName				= "Telefono"
SWEP.Slot					= 1
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= true

function SWEP:SecondaryAttack()
end

function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:Reload()
end

local lang = Jewelry_Robbery.Config.Language
local sentences = Jewelry_Robbery.Config.Lang

function SWEP:CallResponse()
	if CLIENT then return end

	self:EmitSound( "buttons/blip1.wav" )

	Jewelry_Robbery.Config.SavedNPCPositions = Jewelry_Robbery.Config.SavedNPCPositions or {}

	if next(Jewelry_Robbery.Config.SavedNPCPositions) == nil then
		self.Owner:JEWNOTIF("No hay posiciones de NPC guardadas. Póngase en contacto con un administrador.")
		return
	end

	Jewelry_Robbery.NPCInfos = Jewelry_Robbery.NPCInfos or {
		free = true,
		pos = Vector(0,0,0),
		lastCall = -Jewelry_Robbery.Config.TimeBetween2CallNPC,
		caller = NULL,
	}
	
	if Jewelry_Robbery.NPCInfos.free and CurTime()-Jewelry_Robbery.NPCInfos.lastCall > Jewelry_Robbery.Config.TimeBetween2CallNPC then
		Jewelry_Robbery.CreateNPC( self.Owner )
		self.Owner:JEWNOTIF(sentences[23][lang])
	else
		remainingTime = math.floor( Jewelry_Robbery.Config.TimeBetween2CallNPC - (CurTime()-Jewelry_Robbery.NPCInfos.lastCall) )
		self.Owner:JEWNOTIF(sentences[24][lang].. " ( en ".. remainingTime .." s)")
	end
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	
	if CLIENT then return end
	
	self:SetCallTime(CurTime() + 2)
	
end

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "CallTime")
end

function SWEP:Think()
	if self:GetCallTime() > 0 and self:GetCallTime() < CurTime() then
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		if SERVER then
			self:SetCallTime(0)
			self:CallResponse()
		end
	end
end

function SWEP:Initialize()
	self:SetHoldType( "melee" )
	if SERVER then
		self:SetCallTime(0)
	end
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire(CurTime() + 1)
	if SERVER then
		self:SetCallTime(0)
	end
    return true
end

function SWEP:OnRemove()
end

function SWEP:Holster()
    return true
end