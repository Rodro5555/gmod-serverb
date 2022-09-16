AddCSLuaFile()
DEFINE_BASECLASS("zrush_machine_base")
ENT.Type = "anim"
ENT.Base = "zrush_machine_base"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "Refinery"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros OilRush"
ENT.Model = "models/zerochain/props_oilrush/zor_refinery.mdl"
ENT.AutomaticFrameAdvance = true

ENT.MachineID = "Refinery"
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
	self:NetworkVar("Entity", 0, "InputBarrel")
	self:NetworkVar("Entity", 1, "OutputBarrel")
	self:NetworkVar("Int", 1, "State")
	self:NetworkVar("Float", 0, "SpeedBoost")
	self:NetworkVar("Float", 1, "ProductionBoost")
	self:NetworkVar("Float", 3, "CoolingBoost")
	self:NetworkVar("Float", 4, "RefineBoost")
	self:NetworkVar("Int", 0, "FuelTypeID")

	if (SERVER) then
		self:SetState(-1)
		self:SetInputBarrel(NULL)
		self:SetOutputBarrel(NULL)

		self:SetSpeedBoost(0)
		self:SetProductionBoost(0)
		self:SetCoolingBoost(0)
		self:SetRefineBoost(0)

		self:SetFuelTypeID(1)
	end
end

function ENT:ReadyForEvent()
	if (self:IsRunning() and not self:IsOverHeating() and IsValid(self:GetInputBarrel()) and IsValid(self:GetOutputBarrel())) then
		return true
	else
		return false
	end
end

function ENT:IsRunning()
	return self:GetState() == ZRUSH_STATE_REFINING
end

if SERVER then

	function ENT:ModulesChanged()
		zrush.Refinery.ModulesChanged(self)
	end

	function ENT:Initialize()
		zrush.Refinery.Initialize(self)
	end

	function ENT:AcceptInput(key, ply)
		if ((self.lastUsed or CurTime()) <= CurTime()) and (key == "Use" and IsValid(ply) and ply:IsPlayer() and ply:Alive()) and zclib.util.InDistance(ply:GetPos(), self:GetPos(), 200) then
			self.lastUsed = CurTime() + 0.25
			zrush.Refinery.OnUse(self, ply)
		end
	end

	function ENT:OnTakeDamage(dmg)
		zrush.Damage.Take(self,dmg)
	end

	function ENT:StartTouch(other)
	    zrush.Refinery.OnTouch(self,other)
	end

	function ENT:PostBuild(ply, BuildOnEntity)
		zrush.Refinery.PostBuild(self, ply, BuildOnEntity)
	end

	// Toggles the machine on or off
	function ENT:Toggle(ply)
		zrush.Refinery.Toggle(self,ply)
	end

	function ENT:Deconstruct(ply)
		zrush.Refinery.Deconstruct(self,ply)
	end

	// Called to start a machine to overheat
	function ENT:OnHeatEvent()
		zrush.Refinery.OnHeatEvent(self)
	end

	// Called after the machine got cooled
	function ENT:OnHeatFixed()
		zrush.Refinery.OnHeatFixed(self)
	end

	// Called right before the machine explodes
	function ENT:OnHeatFailed()
		zrush.Refinery.OnHeatFailed(self)
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

		local RefineBoost = self:GetRefineBoost()
		if (RefineBoost > 0) then
			RefineBoost = " (+" .. math.Round((self:GetBoostValue("production") * RefineBoost) / 10, 2) .. zrush.config.UoM .. ")"
		else
			RefineBoost = ""
		end

		local CoolingBoost = self:GetCoolingBoost()
		if (CoolingBoost > 0) then
			CoolingBoost = " (-" .. math.Round(zrush.config.Machine[self.MachineID].OverHeat_Chance * CoolingBoost, 2) .. "%)"
		else
			CoolingBoost = ""
		end

		local oilBarrel = self:GetInputBarrel()
		local oil = zrush.language["NA"]

		local fuelBarrel = self:GetOutputBarrel()
		local fuel = zrush.language["NA"]

		if (IsValid(oilBarrel)) then
			oil = math.Round(math.Clamp(oilBarrel:GetOil(), 0, 9999999), 1) .. zrush.config.UoM
		end

		if (IsValid(fuelBarrel)) then
			fuel = math.Round(math.Clamp(fuelBarrel:GetFuel(), 0, 9999999), 1) .. zrush.config.UoM
		end

		local stats = {
			[1] = {
				name = zrush.language["Fuel"],
				val = zrush.FuelTypes[self:GetFuelTypeID()].name
			},
			[2] = {
				name = zrush.language["Speed"],
				val = self:GetBoostValue("speed") .. "s" .. SpeedBoost
			},
			[3] = {
				name = zrush.language["RefineAmount"],
				val = self:GetBoostValue("production") .. zrush.config.UoM .. ProductionBoost
			},
			[4] = {
				name = zrush.language["RefineOutput"],
				val = self:GetBoostValue("production") * self:GetBoostValue("refining") .. zrush.config.UoM .. RefineBoost
			},
			[5] = {
				name = zrush.language["OverHeatChance"],
				val = self:GetBoostValue("cooling") .. "%" .. CoolingBoost
			},
			[6] = {
				name = zrush.language["BarrelOIL"],
				val = oil
			},
			[7] = {
				name = zrush.language["BarrelFuel"],
				val = fuel
			}
		}

		return stats
	end

	function ENT:Initialize()
		zrush.Refinery.Initialize(self)
	end

	function ENT:Draw()
		self:DrawModel()
		zrush.Refinery.Draw(self)
	end

	function ENT:Think()
		zrush.Refinery.Think(self)
		self:SetNextClientThink(CurTime())

		return true
	end

	function ENT:OnRemove()
		zrush.Refinery.OnRemove(self)
	end
end
