AddCSLuaFile()
DEFINE_BASECLASS("zrush_machine_base")
ENT.Type = "anim"
ENT.Base = "zrush_machine_base"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "DrillTower"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros OilRush"
ENT.Model = "models/zerochain/props_oilrush/zor_drilltower.mdl"
ENT.AutomaticFrameAdvance = true

ENT.MachineID = "Drill"

function ENT:CanProperty(ply)
    return ply:IsSuperAdmin()
end

function ENT:CanTool(ply, tab, str)
    return ply:IsSuperAdmin()
end

function ENT:CanDrive(ply)
    return false
end


function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Pipes")
	self:NetworkVar("Entity", 0, "Hole")
	self:NetworkVar("Int", 1, "State")

	self:NetworkVar("Float", 1, "SpeedBoost")
	self:NetworkVar("Float", 2, "ProductionBoost")
	self:NetworkVar("Float", 3, "AntiJamBoost")
	self:NetworkVar("Float", 4, "ExtraPipes")

	if (SERVER) then
		self:SetPipes(0)

		self:SetSpeedBoost(0)
		self:SetProductionBoost(0)
		self:SetAntiJamBoost(0)
		self:SetExtraPipes(0)

		self:SetState(-1)
	end
end

function ENT:ReadyForEvent()
	if (self:IsRunning() and not self:IsJammed() and self:GetPipes() > math.Round(zrush.config.Machine["Drill"].MaxHoldPipes * 0.3)) then
		return true
	else
		return false
	end
end

function ENT:IsRunning()
	return self:GetState() == ZRUSH_STATE_ISDRILLING
end

if SERVER then

	function ENT:ModulesChanged()
		zrush.DrillTower.ModulesChanged(self)
	end

	function ENT:Initialize()
		zrush.DrillTower.Initialize(self)
	end

	function ENT:AcceptInput(key, ply)
		if ((self.lastUsed or CurTime()) <= CurTime()) and (key == "Use" and IsValid(ply) and ply:IsPlayer() and ply:Alive()) and zclib.util.InDistance(ply:GetPos(), self:GetPos(), 200) then
			self.lastUsed = CurTime() + 1
			zrush.DrillTower.OnUse(self, ply)
		end
	end

	function ENT:OnTakeDamage(dmg)
		zrush.Damage.Take(self,dmg)
	end

	function ENT:PostBuild(ply, BuildOnEntity)
		zrush.DrillTower.PostBuild(self, ply, BuildOnEntity)
	end

	function ENT:StartTouch(other)
		zrush.DrillTower.OnTouch(self, other)
	end

	function ENT:OnJamEvent()
		zrush.DrillTower.OnJamEvent(self)
	end

	function ENT:OnJamFixed()
		zrush.DrillTower.OnJamFixed(self)
	end

	function ENT:Toggle(ply)
		zrush.DrillTower.Toggle(self,ply)
	end

	function ENT:Deconstruct(ply)
		zrush.DrillTower.Deconstruct(self,ply)
	end
else

	// Creats a table with all the machines current statistics
	function ENT:GetStats()

		local SpeedBoost = self:GetSpeedBoost()
		if (SpeedBoost > 0) then
			SpeedBoost = " (-" .. math.Round(zrush.config.Machine[self.MachineID].Speed * SpeedBoost, 2) .. "s)"
		else
			SpeedBoost = ""
		end


		local ExtraPipes = self:GetExtraPipes()
		if (ExtraPipes > 0) then
			ExtraPipes = " (+" .. ExtraPipes .. ")"
		else
			ExtraPipes = ""
		end

		local chaoeseventBoost = 0
		local aHole = self:GetHole()
		local pipes_val = zrush.language["NA"]
		if IsValid(aHole) then
			chaoeseventBoost = self:GetHole():GetChaosEventBoost()
			pipes_val = "(" .. (aHole:GetNeededPipes() - aHole:GetPipes()) .. ")"
		end

		local AntiJamBoost = self:GetAntiJamBoost()
		if (AntiJamBoost > 0) then
			AntiJamBoost = " (-" .. math.Round((zrush.config.Machine[self.MachineID].JamChance + chaoeseventBoost) * AntiJamBoost, 2) .. "%)"
		else
			AntiJamBoost = ""
		end

		local stats = {
			[1] = {
				name = zrush.language["TimeprePipe"],
				val = self:GetBoostValue("speed") .. "s" .. SpeedBoost
			},
			[2] = {
				name = zrush.language["PipesinQueue"],
				val = "(" .. self:GetPipes() .. "/" .. self:GetBoostValue("pipes") .. ")" .. ExtraPipes
			},
			[3] = {
				name = zrush.language["NeededPipes"],
				val = pipes_val
			},
			[4] = {
				name = zrush.language["JamChance"],
				val = self:GetBoostValue("antijam") .. "%" .. AntiJamBoost
			}
		}
		return stats
	end


	function ENT:Initialize()
		zrush.DrillTower.Initialize(self)
	end

	function ENT:Think()
		zrush.DrillTower.Think(self)
		self:SetNextClientThink(CurTime())

		return true
	end

	function ENT:OnRemove()
		zrush.DrillTower.OnRemove(self)
	end
end
