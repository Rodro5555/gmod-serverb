SWEP.ViewModelFlip 			= false
SWEP.Author					= "Venatuss"
SWEP.Instructions			= "Click to use"

SWEP.ViewModel				= Model( "models/sterling/ajr_hammer_c.mdl" ) -- just change the model 
SWEP.WorldModel				= Model( "models/sterling/ajr_hammer_w.mdl" )

SWEP.UseHands				= false

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= false

SWEP.Primary.Damage         = 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay 			= 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Category 				= "Jewelry Robbery"
SWEP.PrintName				= "Martillo"
SWEP.UseHands				=true
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

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 100 )
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	-- if ( trace.Hit ) and IsValid(trace.Entity) and trace.Entity:GetClass() == "jewelryrobbery_glass" then
		
	
	
	bullet = {}
	bullet.Num    = 1
	bullet.Src    = self.Owner:GetShootPos()
	bullet.Dir    = self.Owner:GetAimVector()
	bullet.Spread = Vector(0, 0, 0)
	bullet.Tracer = 0
	bullet.Force  = 1	
	self.Owner:ViewPunch(Angle(5, 5, 0))
	
	if ( trace.Hit ) and IsValid(trace.Entity) and trace.Entity.Base and trace.Entity.Base == "jewelryrobbery_glass_base" then
		if trace.MatType == MAT_GLASS then
			bullet.Damage = 10
			self.Owner:FireBullets(bullet)
			trace.Entity:RemoveAllDecals()
		else
			bullet.Damage = 0
			self.Owner:FireBullets(bullet)
			trace.Entity:RemoveAllDecals()
		end
	end
end

function SWEP:Initialize()
	
	self:SetHoldType( "melee" )
	
	
end

function SWEP:Deploy()
    return true
end

function SWEP:OnRemove()
end

function SWEP:Holster()
    return true
end

-- function SWEP:PreDrawViewModel()
    -- return true
-- end