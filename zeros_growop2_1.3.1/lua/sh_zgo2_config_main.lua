zgo2 = zgo2 or {}
zgo2.config = zgo2.config or {}

///////////////////////// Zero´s GrowOP 2 ////////////////////////////////////

// Developed by ZeroChain:
// http://steamcommunity.com/id/zerochain/
// https://www.gmodstore.com/users/view/76561198013322242
// https://www.artstation.com/zerochain

/////////////////////////////////////////////////////////////////////////////


///////////////////////// zclib Config //////////////////////////////////////
/*
	This config can be used to overwrite the main config of zeros libary
*/
// The Currency
zclib.config.Currency = "$"

// Should the Currency symbol be in front or after the money value?
zclib.config.CurrencyInvert = true

// These Ranks are admins
// If xAdmin, sAdmin or SAM is installed then this table can be ignored
zclib.config.AdminRanks = {
	[ "superadmin" ] = true
}

//zclib.config.CleanUp.SkipOnTeamChange[TEAM_STAFF] = true
/////////////////////////////////////////////////////////////////////////////

// This tells the script who is a amateur and professional weed grower
// NOTE Mainly used to restrict who can interact with which entity, Pros can use better Equipment
zgo2.config.Jobs = {}

zgo2.config.Jobs.Amateur = {}
if TEAM_ZGO2_AMATEUR then zgo2.config.Jobs.Amateur[TEAM_ZGO2_AMATEUR] = true end

zgo2.config.Jobs.Basic = {}
if TEAM_ZGO2_BASIC then zgo2.config.Jobs.Basic[TEAM_ZGO2_BASIC] = true end

zgo2.config.Jobs.Pro = {}
if TEAM_ZGO2_PRO then zgo2.config.Jobs.Pro[TEAM_ZGO2_PRO] = true end

/*
	How much damage it takes to destroy the object, -1 disables it
*/
zgo2.config.Damageable = {
	["zgo2_plant"] = 15,
	["zgo2_weedbranch"] = 5,
	["zgo2_weedblock"] = 10,
	["zgo2_jar"] = 10,
	["zgo2_pot"] = 15,

	["zgo2_crate"] = 25,
	["zgo2_soil"] = 15,
	["zgo2_motor"] = 15,
	["zgo2_logbook"] = 25,
	["zgo2_jarcrate"] = 25,
	["zgo2_fuel"] = 15,
	["zgo2_bulb"] = 15,
	["zgo2_battery"] = 15,
	["zgo2_seed"] = 15,
	["zgo2_palette"] = 50,
	["zgo2_clipper"] = 100,
	["zgo2_dryline"] = 50,
	["zgo2_generator"] = 100,
	["zgo2_tent"] = 100,
	["zgo2_rack"] = 50,
	["zgo2_pump"] = 50,
	["zgo2_watertank"] = 50,
	["zgo2_packer"] = 100,
	["zgo2_bong"] = 15,
	["zgo2_lamp"] = 35,
	["zgo2_doobytable"] = 35,
	["zgo2_splicer"] = 100,
	["zgo2_baggy"] = 6,
	["zgo2_joint_ent"] = 3,

	["zgo2_backmix"] = 3,
	["zgo2_edible"] = 3,
	["zgo2_mixer"] = 25,
	["zgo2_mixerbowl"] = 25,
	["zgo2_oven"] = 25,
}

/*
	What weight measurement should we use
*/
zgo2.config.UoM = "g"

/*
	What language should we display en, fr, de, es, ru , ptbr , tr , pl , cn
*/
zgo2.config.SelectedLanguage = "es"

/*
	This automaticly blacklists the entities from the pocket swep
*/
if GM and GM.Config and GM.Config.PocketBlacklist then
	GM.Config.PocketBlacklist[ "zgo2_npc" ] = true
	GM.Config.PocketBlacklist[ "zgo2_npc_export" ] = true
	GM.Config.PocketBlacklist[ "zgo2_plant" ] = true
	for k, v in pairs(zgo2.util.ClassList) do
		GM.Config.PocketBlacklist[ k ] = true
	end
end

/*
	The size of the generated lua materials
*/
zgo2.config.RenderTargetSize = 512

/*
	Can be used to modify the weed price per gram globaly
	1 = 1$ per gram
	0.5 = 0.5$ per gram
	0.1 = 0.1$ per gram
*/
zgo2.config.WeedPriceMultiplicator = 0.25

/*
	The player can access the shop using the multitool
*/
zgo2.config.Shop = {
	// How much money does the player get back when selling his Equipment again using the multitool
	// NOTE Set it to 0 to disable this function
	// Default: 50%
	Refund = 50
}

/*
	The weed plant
*/
zgo2.config.Plant = {

	// Checks if the plant has enough space to grow (Not to close to other plants)
	proximity_check = true,

	// If the plant is closer then this distance to a none LED lamp then its considered overheating
	overheat_dist = 80,

	// How long does a plant need to be really close to a none LED lamp before it starts burning?
	overheat_time = 5,

	// When a plant grows inside a tent then it will be smaller
	// This value defines how much less weed it will produce
	tent_weed_penalty = 0.5, // -50%

	// When a plant gets its light from a sodium lamp which produces heat then it will need more water
	// This value defines how much more water the plant will need
	heat_water_penalty = 1.5, // +50%

	// Defines how long a plant needs to grow (Editor Limit)
	grow_time = {min = 30 , max = 1200},

	// Defines how much water a plant will need (Editor Limit)
	water_need = {min = 1000 , max = 5000},

	// Defines how much weed a plant can have (Editor Limit)
	weed_amount = {min = 100 , max = 5000},


	// How long does the plant need to stay in harvest ready state in order to get the full THC Bonus Boost (thc_bonus_boost)
	thc_bonus_time = 300,

	// How much will the THC value of the plant increase if keept in the harvest ready state for some time (thc_bonus_time)
	thc_bonus_boost = 10,


	// How many weedbranches is the player allowed to spawn
	spawnlimit_weedbranch = 12,

	// How many jars is the player allowed to spawn
	spawnlimit_jar = 10,

	// How many weedblocks is the player allowed to spawn
	spawnlimit_weedblock = 10,

	// How many baggies is the player allowed to spawn
	spawnlimit_baggy = 5,
}

/*
	Pots are used to grow plants in them
*/
zgo2.config.Pot = {
	// Does the pot need to be placed on a rack or in a tent in order to work
	RequiereRack = false,

	// If the pot is tilted too far then it will auto reset / spill out all the dirt
	TiltCheck = true,

	// Can be used to overwrite the spawn limit according to rank
	SpawnLimitOverwrite = {
		["superadmin"] = 50,
	}
}

/*
	Batterys can be put in to lamps to power them
*/
zgo2.config.Battery = {
	// How much power will a battery provide
	Power = 300,
}

/*
	Bulbs are used in sodium lamps, they can burn out
*/
zgo2.config.Bulb = {
	// How many seconds of use can a bulb survive
	Lifetime = {min = 1000,max = 1200},
}

/*
	Watertanks provide water and refill over time
*/
zgo2.config.Watertank = {
	// How much water can be used at once when watering manually
	UseAmount = 200,
}

/*
	Cables tranfser power / water between entities
*/
zgo2.config.Cable = {
	// How far away till the connection breaks
	Distance = 700,

	// Should cables and hoses be drawn constantly?
	AlwaysRender = false,
}

/*
	Pumps move water from tanks to pots
*/
zgo2.config.Pump = {

	// How many pots can be connected per pump
	PotLimit = 12,

	// How much water will be send per connected pot
	TransferRate = 25,

	// How much power is needed
	PowerUsage = 1,
}

/*
	Generators produce power
*/
zgo2.config.Generator = {

	// How much fuel does a fuecan provide?
	FuelPerCan = 500,

	// How much power can be send per connected entity
	TransferRate = 25,
}

/*
	Used to try weed
*/
zgo2.config.Dryline = {

	// How many weed branches can fit on the rope at max
	BranchLimit = 50,

	// How long can the dryline be
	Distance = 1000,

	// How much does one unit of rope cost?
	CostPerUnit = 25,

	// How long does it take for weed to dry?
	DryTime = 60,

	// Where can the players attach the dryinghook
	WorldOnly = false,
}

/*
	Jars hold weed
*/
zgo2.config.Jar = {

	// How much weed can jars hold?
	Capacity = 1000, // g
}

/*
	The WeedClipper can clip large amount of weed
*/
zgo2.config.Clipper = {

	// How many weedbranches can the machine hold?
	Limit = 25,

	// If a motor is installed this will be the amount of power thats needed per second
	PowerUsage = 1,
}

/*
	The WeedPacker compresses weed jars in to weedpacks
*/
zgo2.config.Packer = {

	// How much weed is requiered for one weedblock
	Capacity = 5000,
}

/*
	The Palette is used to transport weedblocks
*/
zgo2.config.Palette = {

	// How much weedblocks can fit on the Palette
	Limit = 24,
}

/*
	Seedbox hold weed seeds
*/
zgo2.config.Seedbox = {
	// How many seeds are inside one box
	Count = 10,

	// The seed cost is calculated by getting a fraction of the total money value of the final plant
	// Examble: The total weed value of a harvested plants is 1000$ then one seedbox is gonna cost 100$
	Cost = 10, // %
}

/*
	Bongs are used to smoke da weed
*/
zgo2.config.Bong = {
	// How much weed will be used per hit
	Use = 5,
}

/*
	Bongs are used to smoke da weed
*/
zgo2.config.HighEffect = {

	// How long will the high effect last per bong / joint hit?
	Duration = 10,

	// How long can the high effect last
	// Default: 60 Seconds
	MaxDuration = 60,

	// Reverses the players sentences when chating
	Babble = true,
}

/*
	Players can buy bongs , sell small amounts of weed and request weed transfer positions for large amounts of weed (So that it be send to the global Marketplace)
*/
zgo2.config.NPC = {

	// Allows the player to sell small amounts of weed directly to the weed dealer
	QuickSell = {
		// Players can sell small amounts of weed directly to the NPC
		// This value defines for how much the NPC will buy the weed in %
		// Default: 50% (Half of its normal price)
		Rate = 75,

		// How much weed will the NPC buy at once
		// Default: 50000g
		Amount = 50000,

		// This value defines how long the NPC will wait before he will buy more weed from the players
		// NOTE This cooldown applies for all players who wanna use the same NPC
		Cooldown = 600,
	},

	// Allows the player to export cargo from the map
	Export = {
		// The default location for weed transfered from the NPC to the Marketplace
		// NOTE Setting this to -1 will choose a random marketplace
		Location = -1,

		// How much time does the player have to deliver the weed to the dropzone
		Time = 120,

		// If set to true then only entities owned by the player who requested the pickup can be exported
		OwnerCheck = true,

		// Should we adjust the dropoff time once the player arrives at the dropzone
		ReduceTimeOnArrival = true
	},

	// Who is allowed to sell weed
	// NOTE Everyone is allowed to buy bongs
	jobs = {}
}
table.Merge(zgo2.config.NPC.jobs,zgo2.config.Jobs.Amateur)
table.Merge(zgo2.config.NPC.jobs,zgo2.config.Jobs.Basic)
table.Merge(zgo2.config.NPC.jobs,zgo2.config.Jobs.Pro)


/*
	Players can ship their weed to diffrent Marketplaces on the world map and sell their weed there
*/
zgo2.config.Marketplace = {

	// If set to true then the player wont need mules to move the weed between marketplaces
	DisableMules = false,

	// Allows the players to sell his cargo at marketplaces
	Sell = {
		// If set to false then the player cant sell his cargo directly at the marketplaces
		Enabled = true,

		// How often does the Marketplaces update their buy %
		// Default: 600 seconds
		Interval = 600,

		// The buy value of each Marketplace change over time
		// Those values define how much the buy value can change in %
		// NOTE The money value for each weed is defined in the plant config
		Min = 70,
		Max = 130,
	},

	// How many transfers can the player make simultaneously
	TransferLimit = {
		["Default"] = 3,
		["superadmin"] = 6,
	},

	// Multiplies the travel duration
	TravelDuration = 0.75,

	Save = {

		// Should we save the players cargo in the marketplace?
		Enabled = true,

		// Any savefile which has not been modified for 1 month will be removed
		LifeTime = 2678400,
	},

	// Contracts will pay more money if the specified cargo is delivered in time
	Contracts = {

		// Should this feature be enabled?
		Enabled = true,

		// How many active contracts can be available at once
		Limit = 3,

		// In order to accept a contract the player needs to pay a small fee which is a percentage of the final earnings
		// Default: 10%
		SigningFee = 10,

		// How often should we add another contract if the limit is not reached yet
		Interval = 300,

		// How long does the player have time until the contract is over
		// NOTE In this time the player needs to move the requested cargo to the requested marketplace
		Time = {min = 300, max = 600},

		// How much profit can the player make if selling his cargo via contract?
		// Default: +20%	+50%
		Profit = {min = 50,max = 80}
	}
}

/*
	The DoobyTable is used to make joints
*/
zgo2.config.DoobyTable = {
    // How much weed can be stored on the table
    Capacity = 100,

    // How much weed gets used per joint
    WeedPerJoint = 50,

	// Should we change the color of the joint according to the weed color to make it easier to identify?
	ColoredJoints = true
}

/*
	Splicers are used to create new weedseeds from existing ones
*/
zgo2.config.Splicer = {
    // The cost of splicing per plant in %
	// Default: 10%
	/*
		Examble:
			Plants total money value 1000$ (sell value * harvest amount)
			SplicingCost: 800$ (80%)
	*/
    SplicingCostPerPlant = 80,

	// How long does it take to splice
	// Default: 60 seconds
	SpliceTime = 60,

	// How long till the player can use the splicer again
	// Default: 30 minutes
	Cooldown = 1800,

	// How long does a spliced plant config needs to be inactive before it gets deleted permanently. (Inactive means not used / grown / smoked by players)
	// NOTE Its important to clean out inactive spliced plant configs to make sure the total plant config send to the clients does not get bloated
	// The LifeTime depends on the plants creators rank, better rank means the plant config is allowed to be longer inactive before it gets deleted for good.
	LifeTime = {
		["default"] = 86400, // 1 Day
		["vipinicial"] = 259200, // 3 Days
		["vipgiant"] = 259200, // 3 Days
		["viplegend"] = 259200, // 3 Days
		["vipblackblood"] = 259200, // 3 Days
		["superadmin"] = 604800, // 1 Week
	}
}

/*
	The sniffer swep is used by police to detect weed plants
*/
zgo2.config.Sniffer = {
    // Shows every harvest ready weed plant in this distance
    distance = 1000,

    // The duration of the sniff action in seconds per sniff
    duration = 3,

    // How often can the player sniff for illegal items in seconds
    interval = 1,
}

/*
	Baggies can hold small amounts of weed
*/
zgo2.config.Baggy = {
	// How much weed can the baggy hold
	Capacity = 300
}

/*
	The backpack swep can be used to transport weed
*/
zgo2.config.Backpack = {
	// Should the backpack model be visible on players which have the backpack swep?
	DrawModel = true
}
