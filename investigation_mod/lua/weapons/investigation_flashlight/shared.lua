SWEP.ViewModelFlip 			= false
SWEP.Author					= "Venatuss"
SWEP.Instructions			= "Click to use"

SWEP.ViewModel 				= "models/weapons/c_flashlight_zm.mdl"
SWEP.WorldModel 			= "models/weapons/w_flashlight_zm.mdl"

SWEP.UseHands				= true

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= false

SWEP.Primary.Damage         = 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay 			= 0.5

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Category 				= "Investigation Mod"
SWEP.PrintName				= "Linterna UV"
SWEP.Slot					= 1
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= true


function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
	if self.NextFire and self.NextFire > CurTime() then return end
	self.NextFire = CurTime() + self.Primary.Delay

	if CLIENT then
		self.Owner:IM_AskPrints()
	end
	self:CreateLight()
end

function SWEP:SecondaryAttack()
	if self.NextFire and self.NextFire > CurTime() then return end
	self.NextFire = CurTime() + self.Primary.Delay

	self:RemoveLight()
end

function SWEP:Holster()
	self:RemoveLight()
    return true
end

function SWEP:Initialize()
	self:SetHoldType( "slam" )
end

function SWEP:CreateLight()
	if not IsValid( self ) or not IsValid( self.Owner ) or not self.Owner:GetActiveWeapon() or self.Owner:GetActiveWeapon() ~= self  then return end
	if ( SERVER ) then
		if IsValid( self.flashlight ) then return end
		
		self.flashlight = ents.Create( "env_projectedtexture" )
		self.flashlight:SetParent( self.Owner:GetViewModel() )

		self.flashlight:SetPos( self.Owner:GetShootPos() )
		self.flashlight:SetAngles(  self.Owner:GetAngles() )

		self.flashlight:SetKeyValue( "enableshadows", 1 )
		self.flashlight:SetKeyValue( "nearz", 12 )
		self.flashlight:SetKeyValue( "lightfov", 100 ) 

		local dist = 400
		self.flashlight:SetKeyValue( "farz", dist )

		local c = Color( 38, 73, 255 )
		local b = 20

		self.flashlight:SetKeyValue( "lightcolor", Format( "%i %i %i 255", c.r * b, c.g * b, c.b * b ) )

		self.flashlight:Spawn()

		self.flashlight:Input( "SpotlightTexture", NULL, NULL, "effects/flashlight001" )
		self.flashlight:Fire( "setparentattachment", "light", 1 )
		self:DeleteOnRemove( self.flashlight )
	elseif ( CLIENT ) then
		self.Owner.UseInvestigationFlashlight = true
	end
end

function SWEP:RemoveLight()
	if IsValid( self.flashlight ) then
		SafeRemoveEntity ( self.flashlight )
	end

	if CLIENT then
		self.Owner.UseInvestigationFlashlight = false
	end 
end

