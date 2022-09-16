zfs = zfs or {}
zfs.config = zfs.config or {}

/////////////////////////// Zeros FruitSlicer /////////////////////////////

// Developed by ZeroChain:
// http://steamcommunity.com/id/zerochain/
// https://www.gmodstore.com/users/view/76561198013322242
// https://www.artstation.com/zerochain

/////////////////////////////////////////////////////////////////////////////


///////////////////////// zclib Config //////////////////////////////////////
/*
	This config can be used to overwrite the main config of zeros libary
*/
//zclib.config.Debug = true
/*
// The Currency
zclib.config.Currency = "$"

// Should the Currency symbol be in front or after the money value?
zclib.config.CurrencyInvert = true

// These Ranks are admins
// If xAdmin, sAdmin or SAM is installed then this table can be ignored
zclib.config.AdminRanks = {
	["superadmin"] = true
}
*/
//zclib.config.CleanUp.SkipOnTeamChange[TEAM_STAFF] = true
/////////////////////////////////////////////////////////////////////////////

// This enables FastDownload
zfs.config.FastDL = false

// What Language should we use
// Currently we support: en , de , fr , pl , pt , es , cn , ru
zfs.config.selectedLanguage = "es"

// These Jobs are allowed do interact with the fruitslicer, Leave empty to disable job check
zfs.config.Jobs = {
	["Rebanador de frutas"] = true,
}

// What should the SmoothieShop look like,  1 = California, 2 = India
zfs.config.Theme = 1

// Can the Creator of the fruitcup buy the fruitcup?
zfs.config.FruitcupCreatorBuy = true

// If set to true then finished smoothies are dropped to the floor instead of being placed on the shop for selling
zfs.config.DisableSell = false

// These are the fruits which get loaded in the entity on spawn
zfs.config.StartStorage = {}
zfs.config.StartStorage[ZFS_FRUIT_MELON] = 15
zfs.config.StartStorage[ZFS_FRUIT_BANANA] = 10
zfs.config.StartStorage[ZFS_FRUIT_STRAWBERRYS] = 15

zfs.config.Price = {
	// Do we allow the players do change the price of each Product
	// *Note* If set to false then there will be a Fruit Variation Charge on the Base Price
	// that uses the zfs.config.Price.FruitMultiplicator too incourage the Production of more complex Smoothies
	Custom = false,

	// This is the minimum Custom Price the players can set it to
	Minimum = 250,

	// This is the maximum Custom Price the players can set it to
	Maximum = 10000,

	// This is the percentage of what the Smoothie will cost more when using multiple fruit types
	// *Note Only works if zfs.config.Price.Custom is set to false
	FruitMultiplicator = 0.5 // 0.5 = +50% extra cost
}

zfs.config.Health = {
	// Do we want do cap the Health to MaxHealth if we get over it
	// *Examble* Player has 90 Health , MaxHealth = 100 , FruitCup gives Player 25 ExtraHealth , Players Health gets caped at 100
	HealthCap = true,

	// This is the Max Health the player can get from the Smoothies
	MaxHealthCap = 200,
}

zfs.config.Knife = {
	Damage = 3
}

zfs.config.FruitBox = {
	Amount = 10
}
