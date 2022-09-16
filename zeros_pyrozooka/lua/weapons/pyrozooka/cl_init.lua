include("shared.lua")
include("pyrozooka/sh/pyrozooka_config.lua")

net.Receive( "pyrozooka_shot_FX", function( len, ply )
	local effectInfo = net.ReadTable()
	if(effectInfo)then
		if(effectInfo.parent == nil)then return end
		if(IsValid(effectInfo.parent))then
			if(effectInfo.sound)then
				effectInfo.parent:EmitSound(effectInfo.sound)
			end
			if(effectInfo.effect)then
				ParticleEffect( effectInfo.effect, effectInfo.pos, effectInfo.ang, effectInfo.parent )
			end
		end
	end
end)

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
end

function SWEP:PrimaryAttack()
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) -- View model animation
	self.Owner:SetAnimation( ACT_VM_PRIMARYATTACK ) -- 3rd Person Animation
end

function SWEP:SecondaryAttack()
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) -- View model animation
	self.Owner:SetAnimation( ACT_VM_PRIMARYATTACK ) -- 3rd Person Animation
end

function SWEP:Equip() //Tells the script what to do when the player "Initializes" the SWEP.
	self:SendWeaponAnim( ACT_VM_DRAW ) -- View model animation
	self.Owner:SetAnimation( PLAYER_IDLE ) -- 3rd Person Animation
end
