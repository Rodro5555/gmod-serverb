zgo2 = zgo2 or {}
zgo2.config = zgo2.config or {}
zgo2.config.Generators = {}
zgo2.config.Generators_ListID = zgo2.config.Generators_ListID or {}

local function AddGenerator(data)
	local PlantID = table.insert(zgo2.config.Generators,data)
	zgo2.config.Generators_ListID[data.uniqueid] = PlantID
	return PlantID
end

// Lets make a quick list of all the more advanced weed grower jobs
local NextLevelJobs = {}
table.Merge(NextLevelJobs,zgo2.config.Jobs.Pro)
table.Merge(NextLevelJobs,zgo2.config.Jobs.Basic)


AddGenerator({
	uniqueid = "4z24zhdafdasf",
	class = "zgo2_generator",
	name = zgo2.language[ "Generator - Small" ],
	mdl = "models/zerochain/props_growop2/zgo2_generator01.mdl",

	price = 2000,

	// How much fuel can it hold
	Capacity = 500,

	// How much energy does it produce per second
	PowerRate = 10,

	FuelConsumption = 1,

	UIPos = {
		vec = Vector(0, 16.1, 23.5),
		ang = Angle(0, 180, 90),
		scale = 0.05,
	},

	jobs = NextLevelJobs,
})

AddGenerator({
	uniqueid = "fkljfi4i4i33i",
	class = "zgo2_generator",
	name = zgo2.language[ "Generator - Large" ],
	mdl = "models/zerochain/props_growop2/zgo2_generator.mdl",

	price = 4000,

	Capacity = 1500,

	FuelConsumption = 2,

	PowerRate = 35,

	UIPos = {
		vec = Vector(0, 24.3, 33),
		ang = Angle(0, 180, 90),
		scale = 0.05,
	},

	jobs = zgo2.config.Jobs.Pro,
})
