
-- Basic Settings
-- Should we limit the dumpster to certain jobs
bDumpsters.Config["dumpster_limit_jobs"] = true

-- Incase, which jobs should we allow to go through dumpsters. Use the jobs command.
bDumpsters.Config["dumpster_jobs"] = {
	["hobo"] = true, 
	["citizen"] = true 
}

-- Incorrect Job Message 
bDumpsters.Config["dumpster_incorrect_job"] = "You're too prestigious to be going around looking in bins."


-- Dumpster Cooldown
bDumpsters.Config["dumpster_cooldown"] = 75

-- Chances to get items per dumpster opened.
bDumpsters.Config["chances_per_dumpster"] = 2


-- Item Tier Chances
-- Chance to get each tier of item. 1-100. (Lower, the more rare.)
bDumpsters.Config["chance_to_get_bronze"] = 30

bDumpsters.Config["chance_to_get_silver"] = 15

bDumpsters.Config["chance_to_get_gold"] = 3

bDumpsters.Config["chance_to_get_platinum"] = 1


-- Item Tier Loot
-- Items given when bronze luck :((((
bDumpsters.Config["dumpster_luck_bronze"] = {
	["weapon_glock2"] = true, 
	["weapon_fiveseven2"] = true, 
	["weapon_bugbait"] = true,
	["item_ammo_pistol"] = true,
	["item_ammo_smg1"] = true
}

-- Items given when silver luck :(
bDumpsters.Config["dumpster_luck_silver"] = {
	["med_kit"] = true, 
	["weapon_deagle2"] = true
}

-- Items given when gold luck :)
bDumpsters.Config["dumpster_luck_gold"] = {
	["weapon_mac102"] = true, 
	["weapon_mp52"] = true, 
	["weapon_m42"] = true,
}

-- Items given when platinum luck :)))
bDumpsters.Config["dumpster_luck_platinum"] = {
	["ls_sniper"] = true,
	["weapon_ak472"] = true,
	["weapon_pumpshotgun2"] = true
}

-- Money From Dumpsters
-- Chance to get money 1-100
bDumpsters.Config["dumpster_money_chance"] = 20

-- Minimum amount of money possible
bDumpsters.Config["dumpster_minimum_money"] = 1000

-- Maximum amount of money possible
bDumpsters.Config["dumpster_maximum_money"] = 3500


-- Aethstetics
-- Which props should we spawn (temporarily) when a dumpster is opened?
bDumpsters.Config["dumpster_props"] = {
	["models/props_junk/garbage_milkcarton001a.mdl"] = true,
	["models/props_junk/garbage_bag001a.mdl"] = true,
	["models/props_junk/garbage_metalcan001a.mdl"] = true,
	["models/props_junk/Shoe001a.mdl"] = true,
	["models/props_junk/garbage_plasticbottle002a.mdl"] = true
}

-- How many props should we spawn on open?
bDumpsters.Config["dumpster_props_count"] = 5


-- Should we throw rubbish behind us whilst opening?
bDumpsters.Config["dumpster_props_throw"] = true 

-- How many tries should have to take before we open the dumpster?
bDumpsters.Config["dumpster_time_to_open"] = 12 
