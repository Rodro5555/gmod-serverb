zrush = zrush or {}
zrush.config = zrush.config or {}


// This disables the owner checks and allows every player do use each others entitys
zrush.config.EquipmentSharing = false

// Should the machines be all NoCollide with the players do make sure the players dont get stuck by mistake?
zrush.config.Machine_NoCollide = true


// Default Machine Settings
///////////////////////
zrush.config.Machine = zrush.config.Machine or {}

//MachineCrate
zrush.config.Machine["MachineCrate"] = {

	// Do we allow that other players can sell your machine if its in the crate? (Only works if zrush.config.EquipmentSharing = false)
	AllowSell = false
}

//DrillHole
zrush.config.Machine["DrillHole"] = {
	// Do we want that the drillhole spawns with a random color?
	RandomColor = true,

	// If the above is false then we spawn them with this color
	CustomColor = Color(200,45,45),

	// This is the time in seconds before it gets removed after its used(Only used in zrush.config.Drill_Mode = 0)
	PostCooldown = 60,

	// This makes sure unused drillholes get removed (Only used in zrush.config.Drill_Mode = 0) (Set to -1 to Disable it)
	Cooldown = 600,

	// Interval in seconds it takes do emit gas and inflict damage
	ButanGas_Speed = 1,

	// How much damage inflict the Butan Gas from the DrillHole on Players per Second
	ButanGas_Damage = 1,

	// The radius at which a players get damage from gas
	ButanGas_DamageRadius = 100,
}

//Drill
zrush.config.Machine["Drill"] = {

	//(seconds) How long does it take do drill one Pipe
	Speed = 25,

	// How many pipes can the machine hold by default
	MaxHoldPipes = 3,

	// % How High is the Chance that the Machine will Jam (There are extra % that get added later depending on the oilsource)
	JamChance = 60,

	// The radius at which the DrillTower searches for a free OilSpot
	SearchRadius = 250,

	// The Distance at which we allow a new drill hole do get created (This should be big enough do make sure the entitys dont glitch in one another)
	NewDrillRadius = 300,
}

//Burner
zrush.config.Machine["Burner"] = {

	// How long does one burn take in seconds
	Speed = 2,

	// How much gas get removed per Burn
	Amount = 2,

	// % How high is the chance for the machine do overheat? (There are extra % that get added later depending on the oilsource)
	OverHeat_Chance = 60,

	// (seconds) How long until it changes from OverHeating to exploding?
	OverHeat_Countown = 15,

	//The damage the explosion does do a player
	OverHeat_Radius = 200,

	//The damage the explosion does do a player
	OverHeat_Damage = 25,
}

//Pump
zrush.config.Machine["Pump"] = {

	// seconds  How long is one pump action
	Speed = 10,

	// units How much oil do we get per pump
	Amount = 3,

	// % How High is the Base Chance that the Machine will Jam (There are extra % that get added later depending on the oilsource)
	JamChance = 60,
}

//Refinery
zrush.config.Machine["Refinery"] = {

	// seconds
	Speed = 3,

	// How much Oil it takes in
	Amount = 1,

	// % How high is the base chance for the machine do overheat? (There are extra % that get added later depending on the oilsource)
	OverHeat_Chance = 60,

	// (seconds) How long until changes from OverHeating to exploding?
	OverHeat_Countown = 15,

	//The damage the explosion does do a player
	OverHeat_Radius = 200,

	//The damage the explosion does do a player
	OverHeat_Damage = 25,
}
///////////////////////



zrush.Machines = {}
local function AddMachine(data) return table.insert(zrush.Machines, data) end

// Machine Shop
///////////////////////

ZRUSH_DRILL = AddMachine({
	class = "zrush_drilltower",
	model = "models/zerochain/props_oilrush/zor_drilltower.mdl",
	limit = 2,
	price = 2500,
	machineID = "Drill",
	icon = Material("materials/zerochain/zrush/ui/zrush_machine_drilltower.png", "smooth"),
})

ZRUSH_BURNER = AddMachine({
	class = "zrush_burner",
	model = "models/zerochain/props_oilrush/zor_drillburner.mdl",
	limit = 2,
	price = 1000,
	machineID = "Burner",
	icon = Material("materials/zerochain/zrush/ui/zrush_machine_burner.png", "smooth"),
})

ZRUSH_PUMP = AddMachine({
	class = "zrush_pump",
	model = "models/zerochain/props_oilrush/zor_oilpump.mdl",
	limit = 3,
	price = 5000,
	machineID = "Pump",
	icon = Material("materials/zerochain/zrush/ui/zrush_machine_pump.png", "smooth"),
})

ZRUSH_REFINERY = AddMachine({
	class = "zrush_refinery",
	model = "models/zerochain/props_oilrush/zor_refinery.mdl",
	limit = 2,
	price = 10000,
	machineID = "Refinery",
	icon = Material("materials/zerochain/zrush/ui/zrush_machine_refinery.png", "smooth"),
})
///////////////////////
