AddCSLuaFile()
DEFINE_BASECLASS("zrush_machine_base")
ENT.Type = "anim"
ENT.Base = "zrush_machine_base"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "Pump"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros OilRush"
ENT.Model = "models/zerochain/props_oilrush/zor_oilpump.mdl"
ENT.AutomaticFrameAdvance = true

ENT.MachineID = "Pump"
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
	self:NetworkVar("Entity", 0, "Hole")
	self:NetworkVar("Entity", 1, "Barrel")
	self:NetworkVar("Int", 0, "State")

	self:NetworkVar("Float", 1, "SpeedBoost")
	self:NetworkVar("Float", 2, "ProductionBoost")
	self:NetworkVar("Float", 3, "AntiJamBoost")

	if (SERVER) then
		self:SetHole(NULL)
		self:SetBarrel(NULL)

		self:SetState(-1)
		self:SetSpeedBoost(0)
		self:SetProductionBoost(0)
		self:SetAntiJamBoost(0)
	end
end

function ENT:ReadyForEvent()
	if self:IsRunning() and not self:IsJammed() then
		return true
	else
		return false
	end
end

function ENT:IsRunning()
	return self:GetState() == ZRUSH_STATE_PUMPING
end

if SERVER then

	function ENT:ModulesChanged()
		zrush.Pump.ModulesChanged(self)
	end

	function ENT:Initialize()
		zrush.Pump.Initialize(self)
	end

	function ENT:AcceptInput(key, ply)
		if ((self.lastUsed or CurTime()) <= CurTime()) and (key == "Use" and IsValid(ply) and ply:IsPlayer() and ply:Alive()) and zclib.util.InDistance(ply:GetPos(), self:GetPos(), 200) then
			self.lastUsed = CurTime() + 0.25
			zrush.Pump.OnUse(self, ply)
		end
	end

	function ENT:OnTakeDamage(dmg)
		zrush.Damage.Take(self,dmg)
	end

	function ENT:StartTouch(other)
	    zrush.Pump.OnTouch(self,other)
	end

	function ENT:PostBuild(ply, BuildOnEntity)
		zrush.Pump.PostBuild(self, ply, BuildOnEntity)
	end

	// Toggles the machine on or off
	function ENT:Toggle(ply)
		zrush.Pump.Toggle(self,ply)
	end

	// Called when the machine gets Deconstructed
	function ENT:Deconstruct(ply)
		zrush.Pump.Deconstruct(self)
	end

	function ENT:OnJamEvent()
		zrush.Pump.OnJamEvent(self)
	end

	function ENT:OnJamFixed()
		zrush.Pump.OnJamFixed(self)
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

		local ProductionBoost = self:GetProductionBoost()
		if (ProductionBoost > 0) then
			ProductionBoost = " (+" .. math.Round(zrush.config.Machine[self.MachineID].Amount * ProductionBoost, 2) .. zrush.config.UoM .. ")"
		else
			ProductionBoost = ""
		end

		local chaoeseventBoost = 0
		local aHole = self:GetHole()
		local remainOil = zrush.language["NA"]
		if IsValid(aHole) then
			chaoeseventBoost = aHole:GetChaosEventBoost()
			remainOil = math.Round(math.Clamp(aHole:GetOilAmount(), 0, 9999999), 2) .. zrush.config.UoM
		end

		local AntiJamBoost = self:GetAntiJamBoost()
		if (AntiJamBoost > 0) then
			AntiJamBoost = " (-" .. math.Round((zrush.config.Machine[self.MachineID].JamChance + chaoeseventBoost) * AntiJamBoost, 2) .. "%)"
		else
			AntiJamBoost = ""
		end

		local oilBarrel = self:GetBarrel()
		local oil = zrush.language["NA"]
		if (IsValid(oilBarrel)) then
			oil = math.Round(math.Clamp(oilBarrel:GetOil(), 0, 9999999), 2)
		end

		local stats = {
			[1] = {
				name = zrush.language["Speed"],
				val = self:GetBoostValue("speed") .. "s" .. SpeedBoost
			},
			[2] = {
				name = zrush.language["PumpAmount"],
				val = self:GetBoostValue("production") .. ProductionBoost
			},
			[3] = {
				name = zrush.language["BarrelOIL"],
				val = oil
			},
			[4] = {
				name = zrush.language["RemainingOil"],
				val = remainOil
			},
			[5] = {
				name = zrush.language["JamChance"],
				val = self:GetBoostValue("antijam") .. "%" .. AntiJamBoost
			}
		}

		return stats
	end

	function ENT:Initialize()
		zrush.Pump.Initialize(self)
	end

	function ENT:UpdatePitch()
		local basePitch = 100 / (zrush.config.Machine["Pump"].Speed / 4)
		self.SoundPitch = math.Clamp(basePitch + (140 * self:GetSpeedBoost()), 0, 140)
	end

	function ENT:Think()
		zrush.Pump.Think(self)
		self:SetNextClientThink(CurTime())

		return true
	end

	function ENT:OnRemove()
		zrush.Pump.OnRemove(self)
	end
end
