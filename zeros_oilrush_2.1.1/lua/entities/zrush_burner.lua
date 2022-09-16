AddCSLuaFile()
DEFINE_BASECLASS("zrush_machine_base")
ENT.Type = "anim"
ENT.Base = "zrush_machine_base"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "Burner"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros OilRush"
ENT.Model = "models/zerochain/props_oilrush/zor_drillburner.mdl"
ENT.AutomaticFrameAdvance = true

ENT.MachineID = "Burner"

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
	self:NetworkVar("Int", 0, "State")
	self:NetworkVar("Float", 1, "SpeedBoost")
	self:NetworkVar("Float", 2, "ProductionBoost")
	self:NetworkVar("Float", 3, "CoolingBoost")

	if (SERVER) then
		self:SetHole(NULL)
		self:SetState(-1)

		self:SetSpeedBoost(0)
		self:SetProductionBoost(0)
		self:SetCoolingBoost(0)
	end
end

function ENT:ReadyForEvent()
	if (self:IsRunning() and not self:IsOverHeating()) then
		return true
	else
		return false
	end
end

function ENT:IsRunning()
	return self:GetState() == ZRUSH_STATE_BURNINGGAS
end


if SERVER then

	function ENT:ModulesChanged()
		zrush.Burner.ModulesChanged(self)
	end

	function ENT:Initialize()
		zrush.Burner.Initialize(self)
	end

	function ENT:AcceptInput(key, ply)
		if ((self.lastUsed or CurTime()) <= CurTime()) and (key == "Use" and IsValid(ply) and ply:IsPlayer() and ply:Alive()) and zclib.util.InDistance(ply:GetPos(), self:GetPos(), 200) then
			self.lastUsed = CurTime() + 0.25
			zrush.Burner.OnUse(self, ply)
		end
	end

	function ENT:OnTakeDamage(dmg)
		zrush.Damage.Take(self,dmg)
	end

	function ENT:PostBuild(ply, BuildOnEntity)
		zrush.Burner.PostBuild(self, ply, BuildOnEntity)
	end


	function ENT:Deconstruct(ply)
		zrush.Burner.Deconstruct(self)
	end

	// Called to start a machine to overheat
	function ENT:OnHeatEvent()
		// NOT used
	end

	// Called after the machine got cooled
	function ENT:OnHeatFixed()
		zrush.Burner.OnHeatFixed(self)
	end

	// Called right before the machine explodes
	function ENT:OnHeatFailed()
		zrush.Burner.OnHeatFailed(self)
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
			ProductionBoost = " (+" .. math.Round(zrush.config.Machine[self.MachineID].Amount * ProductionBoost, 2) .. ")"
		else
			ProductionBoost = ""
		end

		local chaoeseventBoost = 0
		local ahole = self:GetHole()
		local gas = zrush.language["NA"]
		if IsValid(ahole) then
			chaoeseventBoost = ahole:GetChaosEventBoost()
			 gas = math.Clamp(math.Round(ahole:GetGas(), 2), 0, 9999999)
		end

		local CoolingBoost = self:GetCoolingBoost()
		if (CoolingBoost > 0) then
			CoolingBoost = " (-" .. math.Round((zrush.config.Machine[self.MachineID].OverHeat_Chance + chaoeseventBoost) * CoolingBoost, 2) .. "%)"
		else
			CoolingBoost = ""
		end


		local stats = {
			[1] = {
				name = zrush.language["Speed"],
				val = self:GetBoostValue("speed") .. "s" .. SpeedBoost
			},
			[2] = {
				name = zrush.language["BurnAmount"],
				val = self:GetBoostValue("production") .. ProductionBoost
			},
			[3] = {
				name = zrush.language["RemainingGas"],
				val = gas
			},
			[4] = {
				name = zrush.language["OverHeatChance"],
				val = self:GetBoostValue("cooling") .. "%" .. CoolingBoost
			}
		}

		return stats
	end

	function ENT:Initialize()
		zrush.Burner.Initialize(self)
	end

	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:Think()
		zrush.Burner.Think(self)
		self:SetNextClientThink(CurTime())

		return true
	end

	function ENT:OnRemove()
		zrush.Burner.OnRemove(self)
	end
end
