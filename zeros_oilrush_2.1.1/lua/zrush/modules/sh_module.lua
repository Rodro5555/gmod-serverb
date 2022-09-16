zrush = zrush or {}
zrush.Modules = zrush.Modules or {}

// These are the attachment points IDs the machine have
zrush.ModuleSockets = zrush.ModuleSockets or {}
zrush.ModuleSockets["Drill"] = {1, 2, 3}
zrush.ModuleSockets["Burner"] = {1, 2, 3}
zrush.ModuleSockets["Pump"] = {1, 2, 3}
zrush.ModuleSockets["Refinery"] = {1, 2, 3, 4}

local Cached = {
	["speed"] = {
		["Drill"] = true,
		["Burner"] = true,
		["Pump"] = true,
		["Refinery"] = true
	},
	["production"] = {
		["Burner"] = true,
		["Pump"] = true,
		["Refinery"] = true
	},
	["antijam"] = {
		["Drill"] = true,
		["Pump"] = true
	},
	["cooling"] = {
		["Burner"] = true,
		["Refinery"] = true
	},
	["refining"] = {
		["Refinery"] = true
	},
	["pipes"] = {
		["Drill"] = true
	}
}

function zrush.Modules.CatchMachinesByType(m_type)
	return Cached[m_type]
end

zrush.ModuleDefinitions = {
	["speed"] = {
		icon = zrush.default_materials["module_speed"],
		getvalue = function(ent)
			if zclib.util.FunctionValidater(ent.GetSpeedBoost) then
				return math.Clamp(zrush.config.Machine[ent.MachineID].Speed * (1 - ent:GetSpeedBoost()), 0.1, 99)
			else
				return 0
			end
		end,
		setvalue = function(ent,amount) ent:SetSpeedBoost(amount) end
	},
	["production"] = {
		icon = zrush.default_materials["module_production"],
		getvalue = function(ent)
			if zclib.util.FunctionValidater(ent.GetProductionBoost) then
				return zrush.config.Machine[ent.MachineID].Amount * (1 + ent:GetProductionBoost())
			else
				return 0
			end
		end,
		setvalue = function(ent,amount) ent:SetProductionBoost(amount) end
	},
	["antijam"] = {
		icon = zrush.default_materials["module_antijam"],
		getvalue = function(ent)
			local boostValue = 0
			if zclib.util.FunctionValidater(ent.GetAntiJamBoost) then
				local hole = ent:GetHole()
				if IsValid(hole) and zclib.util.FunctionValidater(hole.GetChaosEventBoost) then
					boostValue = math.Clamp((zrush.config.Machine[ent.MachineID].JamChance + hole:GetChaosEventBoost()) * (1 - ent:GetAntiJamBoost()), 0, 99999)
				end
			end
			return boostValue
		end,
		setvalue = function(ent,amount) ent:SetAntiJamBoost(amount) end
	},
	["cooling"] = {
		icon = zrush.default_materials["module_cooling"],
		getvalue = function(ent)
			if zclib.util.FunctionValidater(ent.GetCoolingBoost) then
				return math.Clamp(zrush.config.Machine[ent.MachineID].OverHeat_Chance * (1 - ent:GetCoolingBoost()), 0, 99999)
			else
				return 0
			end
		end,
		setvalue = function(ent,amount) ent:SetCoolingBoost(amount) end
	},
	["pipes"] = {
		icon = zrush.default_materials["module_morepipes"],
		getvalue = function(ent)
			if zclib.util.FunctionValidater(ent.GetExtraPipes) then
				return zrush.config.Machine[ent.MachineID].MaxHoldPipes + ent:GetExtraPipes()
			else
				return 0
			end
		end,
		setvalue = function(ent,amount) ent:SetExtraPipes(amount) end
	},
	["refining"] = {
		icon = zrush.default_materials["module_refining"],
		getvalue = function(ent)
			if zclib.util.FunctionValidater(ent.GetRefineBoost) and zclib.util.FunctionValidater(ent.GetFuelTypeID) then
				return math.Clamp(zrush.FuelTypes[ent:GetFuelTypeID()].refineoutput * (1 + ent:GetRefineBoost()), 0.01, 1)
			else
				return 0
			end
		end,
		setvalue = function(ent,amount) ent:SetRefineBoost(amount) end
	},
}

function zrush.Modules.GetIcon(m_type)
	return zrush.ModuleDefinitions[m_type].icon
end

function zrush.Modules.GetData(m_id)
	return zrush.AbilityModules[m_id]
end
