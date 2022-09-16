AddCSLuaFile()

SWEP.PrintName = "StunGun"
SWEP.Author = "Kobralost"
SWEP.Purpose = ""

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.Category = "Realistic Police"

SWEP.ViewModel = Model("models/realistic_police/taser/c_taser.mdl")
SWEP.WorldModel = Model("models/realistic_police/taser/w_taser.mdl")
SWEP.ViewModelFOV = 60
SWEP.UseHands = true

SWEP.Base = "weapon_base"

local ShootSound = Sound("Weapon_Pistol.Single")
SWEP.Primary.Damage = 1
SWEP.Primary.TakeAmmo = 1 
SWEP.Primary.ClipSize = 1 
SWEP.Primary.Ammo = "Pistol"

SWEP.Primary.DefaultClip = 1
SWEP.Primary.Spread = 0.1
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = .2
SWEP.Primary.Delay = 15.0
SWEP.Primary.Force = 100

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = true

SWEP.HitDistance = 125

function SWEP:Deploy()
	local Owner = self:GetOwner()
	self:SendWeaponAnim( ACT_VM_DRAW )
	-- Play the idle animation next the primary attack
	timer.Create("rpt_animation"..self:GetOwner():EntIndex(), self:SequenceDuration(), 1, function()	
		if IsValid(self) && IsValid(Owner) then 		
			if Owner:GetActiveWeapon() == self then
				self:SendWeaponAnim( ACT_VM_IDLE )
			end 
		end 
	end ) 
end 

function SWEP:Trace()
	local mins = Vector( -30, 0, 0 )
	local maxs = Vector( 30, 0, 0 )

	local startpos = self.Owner:GetPos() + self.Owner:GetForward() * 40 + self.Owner:GetUp() * 60
	local dir = self.Owner:GetAngles():Forward()
	local len = 500

	local tr = util.TraceHull( {
		start = startpos,
		endpos = startpos + dir * len,
		maxs = maxs,
		mins = mins,
		filter = self.Owner,
	})

	return tr
end

function SWEP:PrimaryAttack()
	local Owner = self:GetOwner()
	if ( !self:CanPrimaryAttack() ) then return end
	
	local bullet = {} 
	bullet.Num = self.Primary.NumberofShots 
	bullet.Src = self.Owner:GetShootPos() 
	bullet.Dir = self.Owner:GetAimVector() 
	bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
	bullet.Tracer = 1
	bullet.Force = self.Primary.Force 
	bullet.Damage = self.Primary.Damage 
	bullet.AmmoType = self.Primary.Ammo 
	
	local rnda = self.Primary.Recoil * -1 
	local rndb = self.Primary.Recoil * math.random(-1, 1) 
	
	self:ShootEffects()

	local tr = self:Trace()
	local ply = tr.Entity

	local tracepos = util.TraceLine(util.GetPlayerTrace( self.Owner ))
	local effect = EffectData()
	effect:SetOrigin( tracepos.HitPos )
	effect:SetStart( self.Owner:GetShootPos() )
	effect:SetAttachment( 1 )
	effect:SetEntity( self )
	util.Effect( "ToolTracer", effect )
	
	-- Take a bullet of primary ammo 
	self.Weapon:EmitSound("rptstungunshot2.mp3")

	if IsValid(ply) && ply:IsPlayer() then 
		-- Check if the player is near the player 
		if Owner:GetPos():DistToSqr(ply:GetPos()) < 180^2 then
			if SERVER then 
				if not ply:isCP() then
					ply:EmitSound( "ambient/voices/m_scream1.wav" )
					Realistic_Police.Tazz(ply)	
					Realistic_Police.ResetBonePosition(Realistic_Police.ManipulateBoneCuffed, ply)
					Realistic_Police.ResetBonePosition(Realistic_Police.ManipulateBoneSurrender, ply)	
					ply:EmitSound("rptstungunmain.mp3")
					
					hook.Run("RealisticPolice:Tazz", ply, self:GetOwner() )
				end 
			end
		end 
	end 
	self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay ) 
end 

function SWEP:Reload()
	if CurTime() < self:GetNextPrimaryFire() then
		-- emit sound to client
		if (self.lastReloadSound or 0) + 2 < CurTime() then
			self:EmitSound("weapons/pistol/pistol_empty.wav")
			self.lastReloadSound = CurTime()
		end
		return -1
	end
	local wep = self:GetOwner():GetActiveWeapon()
	if ( !IsValid( wep ) ) then return -1 end
	local ammo = self:GetOwner():GetAmmoCount( wep:GetPrimaryAmmoType() ) 

	if self:Clip1() == 0 && ammo != 0 then 
		self.Weapon:EmitSound("rptstungunreload.mp3")
		self.Weapon:DefaultReload( ACT_VM_RELOAD );
	end 
end

function SWEP:SecondaryAttack() end 
