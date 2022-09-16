AddCSLuaFile()

local convarMin = GetConVar("c4_enhanced_mintimer")
local convarDamage = GetConVar("c4_enhanced_damage")

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.RenderGroup = RENDERGROUP_BOTH

ENT.PrintName = "C4"

ENT.Model = Model("models/weapons/w_c4_planted.mdl")

ENT.PhysgunDisabled = true

if CLIENT then
	include("cl_ui.lua")
else
	AddCSLuaFile("cl_ui.lua")

	include("sv_net.lua")
end

game.AddParticles("particles/gb5_high_explosive.pcf")
game.AddParticles("particles/gb5_high_explosive_2.pcf")

PrecacheParticleSystem("high_explosive_main")

function ENT:Initialize()
	self:SetModel(self.Model)

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)

		self:SetUseType(SIMPLE_USE)

		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	end

	self:SetTimer(convarMin:GetInt())
end

function ENT:SetupDataTables()
	self:NetworkVar("Float", 1, "Timer")
	self:NetworkVar("Float", 2, "LastBeep")
	self:NetworkVar("Float", 3, "ExplodeTimer")

	self:NetworkVar("Entity", 0, "Instigator")
end

function ENT:IsArmed()
	return self:GetExplodeTimer() > 0
end

if CLIENT then
	surface.CreateFont("C4.Enhanced.UIWorld", {
		font = "LCD AT&T Phone Time/Date", -- Christ
		size = 300,
		weight = 500
	})

	local sprite = Material("sprites/redglow1")

	function ENT:DrawTranslucent()
		if self:IsArmed() or CurTime() % 1 <= 0.5 then
			cam.Start3D2D(self:LocalToWorld(Vector(3.78, -1.8, 8.85)), self:LocalToWorldAngles(Angle(-180, 90, 180)), 0.0067)
				local time = self:IsArmed() and self:GetExplodeTimer() - CurTime() or self:GetTimer()
				local seconds, ms = math.modf(time)

				local str = string.format("%s:%02d", os.date("%M:%S", seconds), math.max(ms * 100, 0))

				draw.DrawText(str, "C4.Enhanced.UIWorld", 0, 0, Color(151, 12, 12))
			cam.End3D2D()
		end

		if self:IsArmed() then
			if not self.LastGlow then
				self.LastGlow = CurTime()
			end

			local nextGlow = math.Clamp(math.Remap(self:GetExplodeTimer() - CurTime(), 1, 5, 0.1, 1), 0.1, 1)

			if CurTime() - self.LastGlow >= nextGlow then
				self.LastGlow = self.LastGlow + nextGlow
			end

			local pos = self:LocalToWorld(Vector(1.2, -0.8, 9.5))
			local alpha = math.Clamp(math.Remap(CurTime() - self.LastGlow, 0, 0.15, 1, 0), 0, 1) * 255

			render.SetMaterial(sprite)
			render.DrawSprite(pos, 8, 8, ColorAlpha(color_white, alpha))
		end
	end
else
	local useTriggers = GetConVar("c4_enhanced_use_map_triggers")

	function ENT:TriggerBombTargets(key, ply)
		if not useTriggers:GetBool() then
			return
		end

		local pos = self:GetPos()

		for _, v in pairs(ents.FindByClass("func_bomb_target")) do
			if v:CheckBrush(pos) then
				v:Fire(key, "nil", 0, ply, self)
			end
		end
	end

	function ENT:Think()
		self:NextThink(CurTime())

		if not self:IsArmed() then
			return true
		end

		if self:GetExplodeTimer() <= CurTime() then
			local pos = self:WorldSpaceCenter()

			self:EmitSound("weapons/c4_enhanced/mine_explosion.mp3", 140)

			ParticleEffect("high_explosive_main", pos, angle_zero)

			local ply = self:GetInstigator()

			self:TriggerBombTargets("BombExplode", ply)

			local explo = ents.Create("env_explosion")

			explo:SetOwner(ply)
			explo:SetPos(pos)
			explo:SetKeyValue("iMagnitude", convarDamage:GetInt())
			explo:SetKeyValue("spawnflags", 608)
			explo:Spawn()
			explo:Activate()
			explo:Fire("Explode")

			util.ScreenShake(pos, 25, 15, 1, 3000)

			SafeRemoveEntity(self)

			return true
		end

		local nextBeep = math.Clamp(math.Remap(self:GetExplodeTimer() - CurTime(), 1, 5, 0.1, 1), 0.1, 1)

		if CurTime() - self:GetLastBeep() >= nextBeep then
			self:EmitSound("weapons/c4_enhanced/c4_click.wav", 80)

			self:SetLastBeep(self:GetLastBeep() + nextBeep)
		end
	end

	function ENT:Use(ply)
		if self:IsArmed() then
			return
		end

		net.Start("C4EnhancedOpenMenu")
			net.WriteEntity(self)
		net.Send(ply)
	end

	function ENT:StartTimer(ply)
		local time = CurTime()

		self:SetInstigator(ply)
		self:SetExplodeTimer(time + self:GetTimer())
		self:SetLastBeep(math.ceil(CurTime()) - 1)

		self:TriggerBombTargets("BombPlanted", ply)
	end

	function ENT:StopTimer(ply)
		self:SetTimer(self:GetExplodeTimer() - CurTime())

		self:SetInstigator(NULL)
		self:SetExplodeTimer(0)
		self:SetLastBeep(0)

		self:TriggerBombTargets("BombDefused", ply)
	end
end
