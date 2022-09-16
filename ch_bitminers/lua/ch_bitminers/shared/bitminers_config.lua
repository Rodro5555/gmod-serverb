CH_Bitminers = CH_Bitminers or {}
CH_Bitminers.Config = CH_Bitminers.Config or {}
CH_Bitminers.Design = CH_Bitminers.Design or {}
CH_Bitminers.Config.MineMoneyInterval = CH_Bitminers.Config.MineMoneyInterval or {}

-- SET LANGUAGE
-- Available languages: English: en - Danish: da - German: de - Polish: pl - Russian: ru - Spanish: es - French: fr - Portuguese: pt - Chinese: cn - Turkish: tr
CH_Bitminers.Config.Language = "es" -- Set the language of the script.

-- General
CH_Bitminers.Config.NotificationTime = 6 -- How long should a notification appear for?

-- Bitminer Values
CH_Bitminers.Config.BitcoinRate = 6808 -- 1 bitcoin equals how much cash? (1 bitcoin = 6808)
CH_Bitminers.Config.RateRandomizeInterval = 300 -- seconds between bitcoin rate is changed.
CH_Bitminers.Config.RateUpdateInterval = 20 -- Default 20. So it will randomize the change between -20 to +20. So it can either go down or up, but maximum 20 either way.
CH_Bitminers.Config.MinBitcoinRate = 4000 -- The lowest the bitcoin rate can hit.
CH_Bitminers.Config.MaxBitcoinRate = 20000 -- The maximum the bitcoin rate can go to.

CH_Bitminers.Config.NotifyPlayersChatRateUpdate = true -- Should all players be notified in chat when the bitcoin rate updates?

-- CH_Bitminers.Config.MineMoneyInterval[[AMOUNT OF MINERS] = INTERVAL BETWEEN MINING MONEY
-- Here it illustrates that having 1 miner will take 15 seconds before it mines bitcoins. The more miners, the less interval.
-- YOU DON'T NECESSARILY NEED TO MODIFY THIS
CH_Bitminers.Config.MineMoneyInterval[1] = 15
CH_Bitminers.Config.MineMoneyInterval[2] = 14
CH_Bitminers.Config.MineMoneyInterval[3] = 13
CH_Bitminers.Config.MineMoneyInterval[4] = 12
CH_Bitminers.Config.MineMoneyInterval[5] = 11
CH_Bitminers.Config.MineMoneyInterval[6] = 10
CH_Bitminers.Config.MineMoneyInterval[7] = 10
CH_Bitminers.Config.MineMoneyInterval[8] = 10
CH_Bitminers.Config.MineMoneyInterval[9] = 10
CH_Bitminers.Config.MineMoneyInterval[10] = 10
CH_Bitminers.Config.MineMoneyInterval[11] = 10
CH_Bitminers.Config.MineMoneyInterval[12] = 9
CH_Bitminers.Config.MineMoneyInterval[13] = 8
CH_Bitminers.Config.MineMoneyInterval[14] = 7
CH_Bitminers.Config.MineMoneyInterval[15] = 6
CH_Bitminers.Config.MineMoneyInterval[16] = 5

-- Removing Entities
CH_Bitminers.Config.RemoveEntsOnDC = true -- Should bitminer entities be removed once a player disconnects?
CH_Bitminers.Config.RemoveEntsOnTeamChange = true -- Should bitminer entities be removed when a player changes his job?

-- Bitminer Shelf
CH_Bitminers.Config.DefaultBitcoinsMinedPer = 0.015 -- Amount of bitcoins mined on each interval by default (any rank that is not in the table below will fallback to this.

CH_Bitminers.Config.BitcoinsMinedPer = { -- How many bitcoins are mined on each interval based on their usergroup.
	{ Usergroup = "vipinicial", Bitcoins = 0.02 },
	{ Usergroup = "vipgiant", Bitcoins = 0.025 },
	{ Usergroup = "viplegend", Bitcoins = 0.03 },
	{ Usergroup = "vipblackblood", Bitcoins = 0.035 },
}

CH_Bitminers.Config.MaxBitcoinsMined = 500 -- How many bitcoins can a bitminer maximum contain
CH_Bitminers.Config.WattsRequiredPerMiner = 1225 -- Amount of watts required per miner in order to properly mine bitcoins most optimal

CH_Bitminers.Config.ShelfHealth = 150 -- Amount of health before it destroys.
CH_Bitminers.Config.ShelfStartTemperature = 0 -- Temperature the shelf spawns with.

CH_Bitminers.Config.ShelfExplosion = true -- Should the shelf cause an explosion if it takes too much damage or overheats?
CH_Bitminers.Config.NotifyOwnerOverheating = true -- Should the owner of the shelf be notified when the mining shelf overheats?

CH_Bitminers.Config.ShowScreenDistance = 50000 -- Distance between player and shelf for showing screen

CH_Bitminers.Config.ShelfMiningSoundLevel = 50 -- Sound level of the shelf mining sound. (0 = muted)

CH_Bitminers.Config.EnableEjectingBitminers = true -- Should ejecting bitminers be enabled or disabled?

-- Fuel Canisters
CH_Bitminers.Config.FuelCanSmallAmount = 50 -- Amount of fuel the small canister contains (max is 100)
CH_Bitminers.Config.FuelCanMediumAmount = 75 -- Amount of fuel the medium canister contains (max is 100)
CH_Bitminers.Config.FuelCanLargeAmount = 100 -- Amount of fuel the large canister contains (max is 100)

-- Fuel Generator
CH_Bitminers.Config.GeneratorWattsInterval = 3 -- Interval for the fuel generator to generate watts in seconds.
CH_Bitminers.Config.FuelGeneratorHealth = 150 -- Amount of health before it destroys.
CH_Bitminers.Config.FuelGeneratorExplosion = true -- Should the fuel generator cause an explosion if it takes too much damage?

CH_Bitminers.Config.FuelConsumptionRate = 7 -- Every x second the generator will consume a random amount of fuel
CH_Bitminers.Config.FuelConsumptionMin = 2 -- Every FuelConsumptionRate it will consume this minimum amount of fuel (it's randomized)
CH_Bitminers.Config.FuelConsumptionMax = 4 -- Every FuelConsumptionRate it will consume this maximum amount of fuel (it's randomized)

CH_Bitminers.Config.GeneratorSmokeEffect = true -- Display smoke effect coming out of generator when turned on.
CH_Bitminers.Config.FuelGeneratorSoundLevel = 75 -- Sound level of the fuel generator when powered on. (0 = muted)

CH_Bitminers.Config.GeneratorWattsMin = 50 -- Minimum amounts of watts generated per interval
CH_Bitminers.Config.GeneratorWattsMax = 90 -- Maximum amounts of watts generated per interval (IT'S RANDOMIZED)

-- Solar Panel
CH_Bitminers.Config.SolarPanelWattsInterval = 4 -- Interval for the solar panel to generate watts in seconds.
CH_Bitminers.Config.SolarPanelHealth = 100 -- Amount of health before it destroys.
CH_Bitminers.Config.SolarPanelExplosion = true -- Should the solar panel cause an explosion if it takes too much damage?

CH_Bitminers.Config.SolarPanelWattsMin = 80 -- Minimum amounts of watts generated per interval
CH_Bitminers.Config.SolarPanelWattsMax = 120 -- Maximum amounts of watts generated per interval (IT'S RANDOMIZED)

CH_Bitminers.Config.CollectDirtInterval = 30 -- Amount of seconds between collecting more dirt on the solar panel.
CH_Bitminers.Config.CollectDirtMin = 1 -- Minimum amount of dirt collected per interval.
CH_Bitminers.Config.CollectDirtMax = 3 -- Maximum amount of dirt collected per interval.
CH_Bitminers.Config.ShowDirt3D2D = 25000 -- -- Distance between player and solar panel for showing dirt 3d2d.

-- RTG Generator
CH_Bitminers.Config.RTGWattsInterval = 5 -- Interval for the RTG to generate watts in seconds.
CH_Bitminers.Config.RTGGeneratorHealth = 300 -- Amount of health before it destroys.
CH_Bitminers.Config.RTGGeneratorExplosion = true -- Should the RTG cause an explosion if it takes too much damage? (NOTE: large explosion)

CH_Bitminers.Config.RTGRadiationEnabled = true -- Enable/disable the damage dealt by radiation.
CH_Bitminers.Config.RTGRadiationDamageOwnerOnly = false -- If enabled, should the radiation only damage the owner of the RTG? false = damage everyone, true = owner only

CH_Bitminers.Config.RTGRadiationInterval = 5 -- Amount of seconds between giving damage to players nearby.
CH_Bitminers.Config.RTGRadiationDistance = 50000 -- Distance from players to RGT before doing damage.

CH_Bitminers.Config.RTGWattsMin = 100 -- Minimum amounts of watts generated per interval
CH_Bitminers.Config.RTGWattsMax = 150 -- Maximum amounts of watts generated per interval (IT'S RANDOMIZED)

CH_Bitminers.Config.EmitRadiationSound = true -- Should the random radiation sounds be emitted from the RTG?

-- Watts Decrease System
CH_Bitminers.Config.WattsDecreaseInterval = 5 -- Every 5th second it will decrease the watts if not powered/plugged in with a cable.
CH_Bitminers.Config.DecreaseAmountMin = 20 -- Minimum amount decreased every 5th second.
CH_Bitminers.Config.DecreaseAmountMax = 40 -- Minimum amount decreased every 5th second.

-- Power Cable
CH_Bitminers.Config.CableRopeLenght = 100 -- Lenght of the rope between the two ends of the power cable.
CH_Bitminers.Config.CableRopeColor = Color( 255, 255, 255, 255 ) -- Sets the color of the rope. Default is just white (no color)

-- Cooling System & Upgrades
CH_Bitminers.Config.TemperatureInterval = 2 -- Interval between updating temperature on miners in seconds
CH_Bitminers.Config.TempToAddPerMiner = 0.11 -- Temperature added per miner on the shelf.

CH_Bitminers.Config.TempToTakePerCooling = 0.21 -- Temperature removed from shelf per cooling upgrade installed.
CH_Bitminers.Config.TempToTakeWhenOff = 0.5 -- Temperature to remove every interval if the shelf is turned off.

-- Donator Features
CH_Bitminers.Config.MaxBitminersInstalled = {
	{ UserGroup = "user", MaxBitminers = 16 },
	{ UserGroup = "vipinicial", MaxBitminers = 20 },
	{ UserGroup = "vipgiant", MaxBitminers = 22 },
	{ UserGroup = "viplegend", MaxBitminers = 24 },
	{ UserGroup = "vipblackblood", MaxBitminers = 28 },
}

-- Health Options (Additional)
CH_Bitminers.Config.PowerCombinerHealth = 75
CH_Bitminers.Config.PowerCableHealth  = 50
CH_Bitminers.Config.FuelCanisterHealth = 75
CH_Bitminers.Config.CoolingUpgradesHealth = 100
CH_Bitminers.Config.SingleMinerHealth = 100
CH_Bitminers.Config.RGBUpgradeHealth = 75
CH_Bitminers.Config.UPSUpgradeHealth = 75
CH_Bitminers.Config.DirtCleaning = 50

-- 3RD PARTY SUPPORT
CH_Bitminers.Config.CreateFireOnExplode = false -- ONLY WORKS WITH MY FIRE SYSTEM https://www.gmodstore.com/market/view/302

CH_Bitminers.Config.DarkRPLevelSystemEnabled = true -- DARKRP LEVEL SYSTEM BY vrondakis https://github.com/uen/Leveling-System
CH_Bitminers.Config.SublimeLevelSystemEnabled = false -- Sublime Levels by HIGH ELO CODERS https://www.gmodstore.com/market/view/6431
CH_Bitminers.Config.EXP2SystemEnabled = false -- Elite XP System (EXP2) by Axspeo https://www.gmodstore.com/market/view/4316
CH_Bitminers.Config.EssentialsXPSystemEnabled = false -- Brick's Essentials and/or DarkRP Essentials by Brickwall https://www.gmodstore.com/market/view/5352 & https://www.gmodstore.com/market/view/7244
CH_Bitminers.Config.GlorifiedLevelingXPSystem = false -- GlorifiedLeveling by GlorifiedPig https://www.gmodstore.com/market/view/7254

CH_Bitminers.Config.WithdrawXPAmount = 400 -- Amount of XP to receive when exchanging bitcoins.
CH_Bitminers.Config.InstallRGBXPAmount = 200 -- Amount of XP to receive when installing RGB upgrade on bitminer shelf.

-- Bitminer Entities (NOT NECESSARY TO EDIT THIS)
CH_Bitminers.ListOfEntities = {
	["ch_bitminer_power_cable"] = true,
	["ch_bitminer_power_cable_end"] = true,
	["ch_bitminer_power_combiner"] = true,
	["ch_bitminer_power_generator"] = true,
	["ch_bitminer_power_generator_fuel_small"] = true,
	["ch_bitminer_power_generator_fuel_medium"] = true,
	["ch_bitminer_power_generator_fuel_large"] = true,
	["ch_bitminer_power_rtg"] = true,
	["ch_bitminer_power_solar"] = true,
	["ch_bitminer_shelf"] = true,
	["ch_bitminer_upgrade_clean_dirt"] = true,
	["ch_bitminer_upgrade_cooling1"] = true,
	["ch_bitminer_upgrade_cooling2"] = true,
	["ch_bitminer_upgrade_cooling3"] = true,
	["ch_bitminer_upgrade_miner"] = true,
	["ch_bitminer_upgrade_rgb"] = true,
	["ch_bitminer_upgrade_ups"] = true,
	["ch_bitminer_antivirus_usb"] = true, -- from dlc
	["ch_bitminer_hacking_usb"] = true, -- from dlc
}