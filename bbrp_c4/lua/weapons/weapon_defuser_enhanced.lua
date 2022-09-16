AddCSLuaFile()

SWEP.PrintName = "Defuser Kit"
SWEP.Author = "TankNut"
SWEP.Instructions = [[Left Click: Start defusing

Defusing will stop if you look away from the bomb.]]

SWEP.ViewModel = Model("models/weapons/w_defuser_single.mdl")
SWEP.WorldModel = Model("models/weapons/w_defuser_single.mdl")

SWEP.Spawnable = true

SWEP.Primary.Ammo = ""
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false

SWEP.Secondary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false

local duration = GetConVar("c4_enhanced_defusetimer")

function SWEP:SetupDataTables()
	self:NetworkVar("Entity", 0, "DefuseEntity")

	self:NetworkVar("Float", 0, "StartDefuseTime")
	self:NetworkVar("Float", 1, "DefuseDuration")
end

function SWEP:PrimaryAttack()
	if self:IsDefusing() then
		return
	end

	local ok, ent = self:CheckDefuseValidity()

	if ok then
		self:StartDefuse(ent)
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Deploy()
	self:StopDefuse()
end


function SWEP:Holster()
	self:StopDefuse()

	return true
end

function SWEP:IsDefusing()
	return IsValid(self:GetDefuseEntity())
end

local range = 82 * 82 -- Default +use range

function SWEP:CheckDefuseValidity(checkDefuse)
	if checkDefuse and not IsValid(self:GetDefuseEntity()) then
		return false
	end

	local ply = self:GetOwner()
	local ent = ply:GetEyeTraceNoCursor().Entity

	if not IsValid(ent) or ent:GetClass() != "ent_c4_enhanced" then
		return false
	end

	if ply:EyePos():DistToSqr(ent:WorldSpaceCenter()) > range then
		return false
	end

	if not ent:IsArmed() then
		return false
	end

	if checkDefuse and ent != self:GetDefuseEntity() then
		return false
	end

	return true, ent
end

function SWEP:Think()
	if self:IsDefusing() then
		if not self:CheckDefuseValidity(true) then
			self:StopDefuse()

			return
		end

		if CurTime() - self:GetStartDefuseTime() >= self:GetDefuseDuration() then
			self:FinishDefuse()
		end
	end
end

function SWEP:StartDefuse(ent)
	self:EmitSound("c4.disarmstart")

	self:SetDefuseEntity(ent)
	self:SetStartDefuseTime(CurTime())
	self:SetDefuseDuration(duration:GetFloat())
end

function SWEP:StopDefuse()
	self:SetDefuseEntity(NULL)
	self:SetStartDefuseTime(0)
	self:SetDefuseDuration(0)
end

function SWEP:FinishDefuse()
	self:EmitSound("c4.disarmfinish")

	if SERVER then
		self:GetDefuseEntity():StopTimer(self:GetOwner())
	end

	self:StopDefuse()
end

local holdtype = {
	[ACT_MP_STAND_IDLE]					= ACT_HL2MP_IDLE_SLAM,
	[ACT_MP_WALK]						= ACT_HL2MP_WALK_SLAM,
	[ACT_MP_RUN]						= ACT_HL2MP_RUN_SLAM,
	[ACT_MP_CROUCH_IDLE]				= ACT_HL2MP_IDLE_CROUCH_PISTOL,
	[ACT_MP_CROUCHWALK]					= ACT_HL2MP_WALK_CROUCH_PISTOL,
	[ACT_MP_ATTACK_STAND_PRIMARYFIRE]	= ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM,
	[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]	= ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM,
	[ACT_MP_JUMP]						= ACT_HL2MP_JUMP_SLAM,
	[ACT_RANGE_ATTACK1]					= ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM,
	[ACT_MP_SWIM]						= ACT_HL2MP_SWIM_SLAM
}

function SWEP:TranslateActivity(act)
	return holdtype[act] or -1
end

if CLIENT then
	function SWEP:DrawHUDBackground()
		if self:IsDefusing() then
			local x = ScrW() * 0.5
			local y = ScreenScale(225)
			local w = ScreenScale(225)
			local h = 10

			surface.SetDrawColor(255, 176, 0, 160)
			surface.DrawOutlinedRect(x - w * 0.5, y, w, h, 1)

			local fraction = (CurTime() - self:GetStartDefuseTime()) / self:GetDefuseDuration()

			surface.SetDrawColor(255, 176, 0, 240)
			surface.DrawRect(x - w * 0.5 + 2, y + 2, w * fraction - 4, h - 4)
		end
	end

	function SWEP:GetViewModelPosition(pos, ang)
		return LocalToWorld(Vector(15, -5, -7), Angle(35, -25, 0), pos, ang)
	end

	function SWEP:DrawWorldModel()
		local ply = self:GetOwner()

		if IsValid(ply) then
			self:SetRenderOrigin(vector_origin)

			local bone = ply:LookupBone("ValveBiped.Bip01_R_Hand")

			if not bone then
				return
			end

			local matrix = ply:GetBoneMatrix(bone)

			if not matrix then
				return
			end

			local pos, ang = LocalToWorld(Vector(4, -5, 0), Angle(-15, 30, 180), matrix:GetTranslation(), matrix:GetAngles())

			self:SetRenderOrigin(pos)
			self:SetRenderAngles(ang)

			self:DrawModel()
		else
			self:SetRenderOrigin(nil)
			self:SetRenderAngles(nil)

			self:DrawModel()
		end
	end
end
