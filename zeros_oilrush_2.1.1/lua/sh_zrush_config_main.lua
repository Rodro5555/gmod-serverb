zrush = zrush or {}
zrush.config = zrush.config or {}

///////////////////////////// Zeros OilRush //////////////////////////////////

// Developed by ZeroChain:
// http://steamcommunity.com/id/zerochain/
// https://www.gmodstore.com/users/view/76561198013322242
// https://www.artstation.com/zerochain

/////////////////////////////////////////////////////////////////////////////



///////////////////////// zclib Config //////////////////////////////////////
/*
	This config can be used to overwrite the main config of zeros libary
*/
//zclib.config.Debug = false

// The Currency
zclib.config.Currency = "$"

// Should the Currency symbol be in front or after the money value?
zclib.config.CurrencyInvert = true

// These Ranks are admins
// If xAdmin, sAdmin or SAM is installed then this table can be ignored
zclib.config.AdminRanks = {
	["superadmin"] = true
}

//zclib.config.CleanUp.SkipOnTeamChange[TEAM_STAFF] = true
/////////////////////////////////////////////////////////////////////////////


// This switches between fast download and workshop
zrush.config.FastDL = false

// What language do we want? en,de,hu,fr,es,pl,cn,ru,it,dk
zrush.config.selectedLanguage = "es"

// The Unit of Measurement
zrush.config.UoM = "L" // liter

// These Jobs are allowed to sell fuel, Leave empty to allow everyone to sell fuel
zrush.config.Jobs = {}
if TEAM_ZRUSH_FUELPRODUCER then zrush.config.Jobs[TEAM_ZRUSH_FUELPRODUCER] = true end

// How should the drilling work?
// 0 = The DrillTower dont needs a oilspots and can be placed everywhere
// 1 = The DrillTower can only be placed on OilSpots which get created at random by a OilSpot Zone. (OilSpot Zones need do be placed by an Admin using the oilspot zone toolgun)
zrush.config.Drill_Mode = 1

// This automaticly blacklists the entities from the pocket swep
if GM and GM.Config and GM.Config.PocketBlacklist then
	GM.Config.PocketBlacklist["zrush_barrel"] = true
	GM.Config.PocketBlacklist["zrush_drillhole"] = true
	GM.Config.PocketBlacklist["zrush_drillpipe_holder"] = true
	GM.Config.PocketBlacklist["zrush_machinecrate"] = true
	GM.Config.PocketBlacklist["zrush_module"] = true
	GM.Config.PocketBlacklist["zrush_npc"] = true
	GM.Config.PocketBlacklist["zrush_oilspot"] = true
	GM.Config.PocketBlacklist["zrush_palette"] = true
	GM.Config.PocketBlacklist["zrush_burner"] = true
	GM.Config.PocketBlacklist["zrush_drilltower"] = true
	GM.Config.PocketBlacklist["zrush_pump"] = true
	GM.Config.PocketBlacklist["zrush_refinery"] = true
end


// Defines how much damage is needed before the entity gets destroyed, set to -1 to disable this
zrush.config.Damageable = {
	["zrush_barrel"] = 50,
	["zrush_palette"] = 200,
	["zrush_drilltower"] = 200,
	["zrush_burner"] = 200,
	["zrush_pump"] = 200,
	["zrush_refinery"] = 200,
}

zrush.config.Barrel = {

	// How much liquid can a barrel store
	Storage = 160,

	// If enabled this checks if the player has the correct rank to pickup the FuelBarrel
	Rank_PickUpCheck = true,

	// If enabled this checks if the player is the owner of the FuelBarrel before picking it up
	Owner_PickUpCheck = false
}

// Player Config
zrush.config.Player = {
	// Should the player drop all of the Fuel Barrels he has in his Zrush inventory when he dies?
	DropFuelOnDeath = true,

	// How many acitve drillholes is the player allowed do have?
	MaxActiveDrillHoles = 3,

	// How many barrels can the player transport in his inventory?
	FuelInvSize = 10
}

// This jams or over heats the machines
// The chance of a machine getting hit by a chaos event can be reduced by the correct boost models
zrush.config.ChaosEvents = {
	// How often should we try to send chaos events to the machine
	Interval = 60,

	// How long till a machine can receive a chaos event again
	Cooldown = 300,
}

// The system which is used do place machines
zrush.config.MachineBuilder = {

	// The money you get when you sell your machines or modules again
	SellValue = 0.5, // You get 50% of the original price
}

// The Palette entity can be used if zrush.config.FuelBuyer.SellMode is set to 2
zrush.config.Palette = {
	// How many Barrels can fit on the palette?
	// If its higher then 8 then the barrels will be shrink down a bit to still fit on the palette
	Capacity = 18,
}

// The Fuel Buyer data
zrush.config.FuelBuyer = {

	// 1 = Barrels can be absorbed and sold by the NPC
	// 2 = Barrels need to be moved to the NPC and sold directly
	SellMode = 2,

	// The Model
	Model = "models/odessa.mdl",

	// The Dialogbox Image
	NotifyImage = "entities/npc_odessa.png",

	// How often should the fuel marked change in seconds
	RefreshRate = 300,

	//% The Max Sell Multiplicator you can get (100 is the Base Price, More means + Profit , Less means - Profit)
	MaxBuyRate = 150,

	//% The Min Sell Multiplicator you can get
	MinBuyRate = 75,

	// The idle animations of the npc
	anim_idle = {"idle_angry","idle_subtle"},

	// The sell animation of the npc
	anim_sell = {"takepackage","cheer1","cheer2"},

	// Just to give them a little Character :I
	names = {"Jeff","Martin","Alex","Henry","Thomas"},
}


// OilSpots
///////////////////////
zrush.config.OilSpot = {

	// This is the time in seconds a oilspot is gonna wait after it was closed before it can get drilled again or before it gets removed
	Cooldown = 60,
}

zrush.config.OilSpot_Zone = {
	// The rate in seconds the zone tries do spawn a new OilSpot if possible
	Rate = 3,

	// The Max count of valid oilspots a zone can have
	MaxOilSpots = 3,

	// This is the max time in seconds a oilspot is gonna wait before it gets removed again if its not used by a Player
	MaxLifeTime = 1000,
}
///////////////////////





// Only works if you have Vrondakis LevelSystem installed
zrush.config.Vrondakis = {}
zrush.config.Vrondakis.Enabled = false
zrush.config.Vrondakis["Selling"] = {XP = 25}		// XP per Sold Unit (5l/gal == 5XP)
zrush.config.Vrondakis["DrillingPipe"] = {XP = 100} // XP per drilled down Pipe
zrush.config.Vrondakis["BurningGas"] = {XP = 25}	// XP per burned gas unit
zrush.config.Vrondakis["ReachingOil"] = {XP = 200}  // XP when reaching Oil
zrush.config.Vrondakis["PumpingOil"] = {XP = 25}	// XP per pumped out Oil (5l/gal == 5XP)
zrush.config.Vrondakis["RefiningOil"] = {XP = 25}	// XP per refined unit of Oil (5l/gal == 5XP)
