zrush = zrush or {}
zrush.Machine = zrush.Machine or {}

function zrush.Machine.GetData(id)
	return zrush.Machines[id]
end

function zrush.Machine.GetIcon(id)
	local dat = zrush.Machine.GetData(id)
	return dat.icon
end

function zrush.Machine.GetIdentifier(id)
	local dat = zrush.Machine.GetData(id)
	if not dat then return 1 end
	return dat.machineID
end

function zrush.Machine.GetName(id)
	return zrush.language[zrush.Machine.GetIdentifier(id)]
end

function zrush.Machine.GetPrice(id)
	local dat = zrush.Machine.GetData(id)
	if not dat then return 1 end
	return dat.price
end

function zrush.Machine.GetModel(id)
	local dat = zrush.Machine.GetData(id)
	if not dat then return "" end
	return dat.model
end

function zrush.Machine.FindConfigByClass(class)
	local id
	for k,v in pairs(zrush.Machines) do
		if v.class == class then
			id = k
			break
		end
	end
	return id
end


zrush.MachineStates = {}
local function AddMachineState(name) return table.insert(zrush.MachineStates,name) end

ZRUSH_STATE_IDLE = AddMachineState("IDLE")
ZRUSH_STATE_ISDRILLING = AddMachineState("IS_DRILLING")
ZRUSH_STATE_READYFORWORK = AddMachineState("READY_FOR_WORK")
ZRUSH_STATE_BARRELFULL = AddMachineState("BARREL_FULL")

ZRUSH_STATE_NEEDPIPES = AddMachineState("NEED_PIPES")
ZRUSH_STATE_FINISHEDDRILLING = AddMachineState("FINISHED_DRILLING")


ZRUSH_STATE_PUMPREADY = AddMachineState("PUMP_READY")
ZRUSH_STATE_PUMPING = AddMachineState("PUMPING")
ZRUSH_STATE_NOOIL = AddMachineState("NO_OIL")

ZRUSH_STATE_NEEDBURNER = AddMachineState("NEED_BURNER")
ZRUSH_STATE_HASBURNER = AddMachineState("HAS_BURNER")
ZRUSH_STATE_BURNINGGAS = AddMachineState("BURNING_GAS")

ZRUSH_STATE_NOGASLEFT = AddMachineState("NO_GAS_LEFT")

ZRUSH_STATE_NEEDOILBARREL = AddMachineState("NEED_OIL_BARREL")
ZRUSH_STATE_NEEDEMPTYBARREL = AddMachineState("NEED_EMPTY_BARREL")
ZRUSH_STATE_REFINING = AddMachineState("IS_REFINING")
ZRUSH_STATE_FUELBARRELFULL = AddMachineState("FUELBARREL_FULL")

ZRUSH_STATE_OVERHEAT = AddMachineState("OVERHEAT")
ZRUSH_STATE_COOLED = AddMachineState("COOLED")

ZRUSH_STATE_JAMMED = AddMachineState("JAMMED")
ZRUSH_STATE_UNJAMMED = AddMachineState("UNJAMMED")


zrush.MachineState = zrush.MachineState or {}
function zrush.MachineState.GetName(id)
	return tostring(zrush.MachineStates[id])
end

function zrush.MachineState.GetTranslation(id)
	return zrush.language[zrush.MachineState.GetName(id)]
end
