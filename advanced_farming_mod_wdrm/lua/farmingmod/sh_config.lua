FarmingMod.Config.Prices = {
	["1 kg of hen"] = 10,
	["1 kg of cow"] = 50,
	["1 kg of pig"] = 50,
	["1 kg of goat"] = 50,
	["1 L of milk"] = 400,
	["1 egg"] = 200,
}

-- the NPC model to use
FarmingMod.Config.NPCModel = "models/humans/group01/male_07.mdl"

-- the NPC should drop the money to the ground or directly pay the player?
FarmingMod.Config.ShouldDropMoney = false

-- Sometimes, collisions are really bad. I advise you to let this enabled.
FarmingMod.Config.CollisionsDisabled = true

FarmingMod.Config.AnimalsConfig = {
	["Hen"] = {
		TimePerCycle = 10, -- Def : 10 - A cycle will pass in 10 seconds.
		CyclesPerYear = 30, -- Def : 30 - 30 cycles will correspond to a year for this animal,
		HungerPerCycle = 4, -- Def : 4 - Means that 5% of hunger will be removed each cycle,
		ThirstPerCycle = 6, -- Def : 6 - Means that 8% of thirst will be removed each cycle,
	},
	["Cow"] = {
		TimePerCycle = 10,
		CyclesPerYear = 30,
		HungerPerCycle = 5,
		ThirstPerCycle = 6,
	},
	["Pig"] = {
		TimePerCycle = 10,
		CyclesPerYear = 30,
		HungerPerCycle = 12,
		ThirstPerCycle = 6,
	},
	["Sheep"] = {
		TimePerCycle = 10,
		CyclesPerYear = 30,
		HungerPerCycle = 4,
		ThirstPerCycle = 6,
	}

}

FarmingMod.Config.Vehicles = {
	["models/tdmcars/trucks/gmc_c5500.mdl"] = {
		infospos = Vector(0,-205,120),
		infosang = Angle(0,0,90)
	}
}
