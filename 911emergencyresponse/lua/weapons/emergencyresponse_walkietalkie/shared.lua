SWEP.ViewModelFlip 			= false
SWEP.UseHands				= true
SWEP.ViewModel 				= "models/noahkrueger/c_motorola.mdl"
SWEP.WorldModel 			= "models/noahkrueger/c_motorola.mdl"
SWEP.Author					= "Fléodon"
SWEP.Instructions			= "[Mouse1] : Open the Radio Menu.\n[Mouse2] - Scroll the Radio Menu. \n [E] - Select the button."

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Damage         = 2
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay 			= 2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay 			= 2

SWEP.Category 				= "911EmergencyResponse"
SWEP.PrintName				= "Emergency Radio"
SWEP.Slot					= 1
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

function SWEP:Initialize()
	self:SetHoldType( "pistol" )
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
	if not IsValid( self.Owner ) then return end
	if not self.Owner:IsPlayer() then return end
	if not self.Owner:Alive() then return end
	if not self.Owner:isCP() then return end
	if self.Weapon:GetNextPrimaryFire() > CurTime() then return end

	if SERVER then
		net.Start( "EmergencyDispatch:DispatchRadio:TraficPolicerMenu" )
			net.WriteBool( true )
			net.WriteBool( false )
		net.Send( self.Owner )

		self.Owner:EmitSound( EmergencyDispatch.RadioButtonScroll )
	end

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
end

function SWEP:SecondaryAttack()
	if not IsValid( self.Owner ) then return end
	if not self.Owner:IsPlayer() then return end
	if not self.Owner:Alive() then return end
	if not self.Owner:isCP() then return end
	if self.Weapon:GetNextSecondaryFire() > CurTime() then return end

	if SERVER then
		net.Start( "EmergencyDispatch:DispatchRadio:TraficPolicerMenu" )
			net.WriteBool( true )
			net.WriteBool( true )
		net.Send( self.Owner )
	end

	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.05 )
end

function SWEP:Deploy()
	return true
end

function SWEP:Holster()
	return true
end