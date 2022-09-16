zgo2 = zgo2 or {}
zgo2.config = zgo2.config or {}
zgo2.config.Lamps = {}
zgo2.config.Lamps_ListID = zgo2.config.Lamps_ListID or {}

local function AddLamp(data)
	local PlantID = table.insert(zgo2.config.Lamps,data)
	zgo2.config.Lamps_ListID[data.uniqueid] = PlantID
	return PlantID
end

local NextLevelJobs = {}
table.Merge(NextLevelJobs,zgo2.config.Jobs.Pro)
table.Merge(NextLevelJobs,zgo2.config.Jobs.Basic)

AddLamp({
	uniqueid = "56dg54jhfgsf",
	class = "zgo2_lamp",
	name = zgo2.language[ "Sodium - Small" ],
	mdl = "models/zerochain/props_growop2/zgo2_sodium_lamp01.mdl",

	price = 1000,

	jobs = NextLevelJobs,

	// Defines where the ui are located
	/*
	NOTE Can be used to overwrite the uis position
	ui = {
		// Where is the on switch
		switch_vec = Vector(5, 0, 45),
		switch_ang = Angle(0, 90, 90),

		// Where is the color change button
		color_vec = Vector(5, 0, 36),
		color_ang = Angle(0, 90, 90),

		// Where should the power be displayed
		power_vec = Vector(18.5, 0, 7),
		power_ang = Angle(0, 90, 90),
	},
	*/

	// If this is specified then lamps will requiere pulps in order to work
	// NOTE The efficiency of the lamp will only be at 100% if it has all its bulbs
	// NOTE This also means that the lamp will loose it bulbs over time since they can burst
	bulbs = {
		//[key] = bodygroup
		[1] = 1,
	},

	// Does this lamp produce heat?
	heat = true,

	// How much power is needed per second
	power = 2,

	cable_bg = 0,
	battery_bg = 2,

	color = {
		// The default color of the lamp
		default = Color(255,220,150),

		// Allows the player to change the color of the lamp
		change = false,
	},

	// Creates the visuals for the light sprites and beams
	visuals = {
		{ lpos = Vector(-3,0,68), lang = Angle(0,90,90), sprite = {w = 128, h = 200}, cone = { w = 2, h = 2, d = 1 }, light = {size = 256} },
	}
})

AddLamp({
	uniqueid = "14351dfgad",
	class = "zgo2_lamp",
	name = zgo2.language[ "Sodium - Medium" ],
	mdl = "models/zerochain/props_growop2/zgo2_sodium_lamp02.mdl",

	price = 2000,

	jobs = NextLevelJobs,

	power = 2,

	bulbs = {
		[1] = 1,
		[2] = 2,
	},

	heat = true,

	cable_bg = 0,
	battery_bg = 3,
	visuals = {
		{ lpos = Vector(-3,11,70), lang = Angle(0,75,90), sprite = {w = 128, h = 200}, cone = { w = 2, h = 2, d = 1 }, light = {size = 256,offset = 50}   },
		{ lpos = Vector(-3,-11,70), lang = Angle(0,105,90), sprite = {w = 128, h = 200}, cone = { w = 2, h = 2, d = 1 }, light = {size = 256,offset = 50}   },
	},

	color = { default = Color(255,220,150)},
})

AddLamp({
	uniqueid = "4zwhsfh4sf",
	class = "zgo2_lamp",
	name = zgo2.language[ "Sodium - Big" ],
	mdl = "models/zerochain/props_growop2/zgo2_sodium_lamp03.mdl",

	jobs = NextLevelJobs,

	price = 4000,

	power = 4,

	bulbs = {
		[1] = 7,
		[2] = 6,
		[3] = 5,
		[4] = 4,
		[5] = 3,
	},

	heat = true,

	cable_bg = 0,
	battery_bg = 1,
	visuals = {
		{ lpos = Vector(0,13,70), lang = Angle(0,0,90), sprite = {w = 128, h = 200}, cone = { w = 2, h = 2, d = 1 }, light = {size = 256}   },
		{ lpos = Vector(13,3,70), lang = Angle(0,-72,90), sprite = {w = 128, h = 200}, cone = { w = 2, h = 2, d = 1 }, light = {size = 256}   },
		{ lpos = Vector(8,-10,70), lang = Angle(0,-144,90), sprite = {w = 128, h = 200}, cone = { w = 2, h = 2, d = 1 }, light = {size = 256}   },
		{ lpos = Vector(-7,-10,70), lang = Angle(0,-216,90), sprite = {w = 128, h = 200}, cone = { w = 2, h = 2, d = 1 }, light = {size = 256}   },
		{ lpos = Vector(-12,4,70), lang = Angle(0,-288,90), sprite = {w = 128, h = 200}, cone = { w = 2, h = 2, d = 1 }, light = {size = 256}  },
	},

	color = { default = Color(255,220,150)},
})



AddLamp({
	uniqueid = "fkf9848fhfg84",
	class = "zgo2_lamp",
	name = zgo2.language[ "LED - Small" ],
	mdl = "models/zerochain/props_growop2/zgo2_led_lamp01.mdl",

	price = 2000,

	power = 1,

	jobs = zgo2.config.Jobs.Pro,

	cable_bg = 0,
	battery_bg = 1,

	visuals = {
		{ lpos = Vector(-6,0,72.4), lang = Angle(0,90,90), sprite = {w = 35, h = 35, count = 8, z_dist = 5.1}, cone = { w = 2, h = 2, d = 1 }, light = {size = 1024, lpos = Vector(-40,0,72.4)}   },
	},

	color = {
		default = Color(255,100,160),
		change = true,
	},
})

AddLamp({
	uniqueid = "fdbfskj459f",
	class = "zgo2_lamp",
	name = zgo2.language[ "LED - Medium" ],
	mdl = "models/zerochain/props_growop2/zgo2_led_lamp02.mdl",

	price = 4000,

	power = 2,

	jobs = zgo2.config.Jobs.Pro,

	cable_bg = 0,
	battery_bg = 1,

	visuals = {
		{ lpos = Vector(-5,12,74), lang = Angle(0,75,90), sprite = {w = 35, h = 35, count = 8, z_dist = 5.1}, cone = { w = 2, h = 2, d = 1 }},//, light = {size = 512,offset = 100}   },
		{ lpos = Vector(-5,0,74), lang = Angle(0,90,90), sprite = {w = 35, h = 35, count = 8, z_dist = 5.1}, cone = { w = 2, h = 2, d = 1 }, light = {size = 1024,offset = 50}   },
		{ lpos = Vector(-5,-12,74), lang = Angle(0,105,90), sprite = {w = 35, h = 35, count = 8, z_dist = 5.1}, cone = { w = 2, h = 2, d = 1 }},//, light = {size = 512,offset = 100}   },
	},

	color = {
		default = Color(255,100,160),
		change = true,
	},
})

AddLamp({
	uniqueid = "dkfk48548dhfd",
	class = "zgo2_lamp",
	name = zgo2.language[ "LED - Big" ],
	mdl = "models/zerochain/props_growop2/zgo2_led_lamp03.mdl",

	price = 6000,

	power = 2,

	jobs = zgo2.config.Jobs.Pro,

	cable_bg = 0,
	battery_bg = 1,

	visuals = {
		{ lpos = Vector(0,16,74), lang = Angle(0,0,90), sprite = {w = 35, h = 35, count = 8, z_dist = 5.1}, cone = { w = 2, h = 2, d = 1 }, light = {size = 512}   },
		{ lpos = Vector(16,5,74), lang = Angle(0,-72,90), sprite = {w = 35, h = 35, count = 8, z_dist = 5.1}, cone = { w = 2, h = 2, d = 1 }, light = {size = 512}   },
		{ lpos = Vector(10,-13,74), lang = Angle(0,-144,90), sprite = {w = 35, h = 35, count = 8, z_dist = 5.1}, cone = { w = 2, h = 2, d = 1 }, light = {size = 512}   },
		{ lpos = Vector(-9,-13,74), lang = Angle(0,-216,90), sprite = {w = 35, h = 35, count = 8, z_dist = 5.1}, cone = { w = 2, h = 2, d = 1 }, light = {size = 512}   },
		{ lpos = Vector(-16,5,74), lang = Angle(0,-288,90), sprite = {w = 35, h = 35, count = 8, z_dist = 5.1}, cone = { w = 2, h = 2, d = 1 }, light = {size = 512}   },
	},

	color = {
		default = Color(255,100,160),
		change = true,
	},
})




/*
	Those lamps can only be added to grow tents
*/
AddLamp({
	uniqueid = "dfjfruir98498",
	class = "zgo2_lamp",
	name = zgo2.language[ "Tent - Sodium" ],
	mdl = "models/zerochain/props_growop2/zgo2_tent_sodium_lamp.mdl",

	price = 1000,

	power = 1,

	// If set then this lamp can only be added to a tent
	tent = true,

	ui = {
		switch_vec = Vector(-8, 10, 0),
		switch_ang = Angle(0, 180, 90),
		color_vec = Vector(-5, 2.7, 3),
		color_ang = Angle(0, 180, 90),
		power_vec = Vector(-14.9,18.5,-61),
		power_ang = Angle(0, 90, 90),
	},

	bulbs = {[1] = 1,},
	heat = true,
	cable_bg = 0,
	battery_bg = 0,
	color = {default = Color(255,220,150)},
	visuals = {
		{ lpos = Vector(0,0,-2), lang = Angle(0,90,0), sprite = {w = 100, h = 100}, cone = { w = 0.25, h = 0.7, d = 1 }, light = {size = 360}  },
	}
})

AddLamp({
	uniqueid = "498gj48fhs23",
	class = "zgo2_lamp",
	name = zgo2.language[ "Tent - LED" ],
	mdl = "models/zerochain/props_growop2/zgo2_tent_led_lamp.mdl",

	price = 2000,

	power = 1,

	// If set then this lamp can only be added to a tent
	tent = true,

	ui = {
		switch_vec = Vector(3, 2.7, 3),
		switch_ang = Angle(0, 180, 90),
		color_vec = Vector(-5, 2.7, 3),
		color_ang = Angle(0, 180, 90),
		power_vec = Vector(-14.9,18.5,-61),
		power_ang = Angle(0, 90, 90),
	},

	cable_bg = 0,
	battery_bg = 0,
	color = {default = Color(255,100,160),change = true,},
	visuals = {
		{ lpos = Vector(2,0,-1), lang = Angle(0,90,0), sprite = {w = 25, h = 25, count = 8, z_dist = 5.1}, cone = {  w = 0.2, h = 0.7, d = 1 }, light = {size = 360} },
	}
})
