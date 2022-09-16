zgo2 = zgo2 or {}
zgo2.config = zgo2.config or {}
zgo2.config.Watertanks = {}
zgo2.config.Watertanks_ListID = zgo2.config.Watertanks_ListID or {}

local function AddWatertank(data)
	local PlantID = table.insert(zgo2.config.Watertanks,data)
	zgo2.config.Watertanks_ListID[data.uniqueid] = PlantID
	return PlantID
end

AddWatertank({
	uniqueid = "4z24zhdafdasf",
	class = "zgo2_watertank",
	name = zgo2.language[ "Watertank - Small" ],
	mdl = "models/zerochain/props_growop2/zgo2_watertank_small.mdl",

	price = 1000,

	// How much water can it hold
	Capacity = 2000,

	// How fast does it refill
	RefillRate = 25,

	UIPos = {
		vec = Vector(0, 17, 34),
		ang = Angle(0, 180, 90),
		scale = 0.02,
	}
})

AddWatertank({
	uniqueid = "fkljfi4i4i33i",
	class = "zgo2_watertank",
	name = zgo2.language[ "Watertank - Big" ],
	mdl = "models/zerochain/props_growop2/zgo2_watertank.mdl",
	price = 2000,
	Capacity = 10000,
	RefillRate = 50,
	jobs = zgo2.config.Jobs.Pro,
	UIPos = {
		vec = Vector(0, 54, 50),
		ang = Angle(0, 180, 90),
		scale = 0.05,
	}
})
