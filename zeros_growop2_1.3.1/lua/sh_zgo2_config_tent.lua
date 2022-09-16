zgo2 = zgo2 or {}
zgo2.config = zgo2.config or {}
zgo2.config.Tents = {}
zgo2.config.Tents_ListID = zgo2.config.Tents_ListID or {}

local function AddTent(data)
	local PlantID = table.insert(zgo2.config.Tents,data)
	zgo2.config.Tents_ListID[data.uniqueid] = PlantID
	return PlantID
end

AddTent({
	uniqueid = "4624vcsvfhfgv",
	class = "zgo2_tent",
	name = zgo2.language[ "Tent - Small" ],
	mdl = "models/zerochain/props_growop2/zgo2_tent01.mdl",
	price = 1000,
	lamps = {
		{Vector(0,0,69),Angle(0,0,0)}
	},

	pots = {
		{Vector(0,0,1),Angle(0,-90,0)}
	},

	battery_bg = {
		[1] = 0
	}
})

AddTent({
	uniqueid = "4621zhfhss",
	class = "zgo2_tent",
	name = zgo2.language[ "Tent - Big" ],
	mdl = "models/zerochain/props_growop2/zgo2_tent02.mdl",
	price = 2500,

	lamps = {
		{Vector(30,0,69),Angle(0,0,0)},
		{Vector(-29,0,69),Angle(0,0,0)},
	},

	pots = {
		{Vector(30,0,1),Angle(0,-90,0)},
		{Vector(-30,0,1),Angle(0,-90,0)},
	},

	battery_bg = {
		[1] = 1,
		[2] = 0,
	}
})
