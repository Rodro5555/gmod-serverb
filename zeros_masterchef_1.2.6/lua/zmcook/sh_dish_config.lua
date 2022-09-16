zmc = zmc or {}
zmc.config = zmc.config or {}


zmc.config.Dishs = {}
local function AddDish(data)
	return table.insert(zmc.config.Dishs, data)
end

AddDish({
    uniqueid = "cf1fb71e60",
    name = zmc.language[ "Hawai Pizza" ],
    mdl = "models/zerochain/props_kitchen/zmc_plate01.mdl",
    time = 600,
    items = {
       {uniqueid = "2aac6d3d04", lpos = Vector(0.5,0.5,0.08), lang = angle_zero,scale = 1},
    },
    price = 1000,
})

AddDish({
    uniqueid = "3fbe872079",
    name = zmc.language[ "Vegie Pizza" ],
    mdl = "models/zerochain/props_kitchen/zmc_plate01.mdl",
    time = 600,
    items = {
       {uniqueid = "840f02da26", lpos = Vector(0.5,0.5,0.07), lang = angle_zero,scale = 1},
    },
    price = 1000,
})

AddDish({
    uniqueid = "8cc55a7d78",
    name = zmc.language[ "Meat Pizza" ],
    mdl = "models/zerochain/props_kitchen/zmc_plate01.mdl",
    time = 600,
    items = {
       {uniqueid = "9da14724e3", lpos = Vector(0.5,0.5,0.08), lang = angle_zero,scale = 1},
    },
    price = 1000,
})



AddDish({
    uniqueid = "23ddb21443",
    name = zmc.language[ "Spagetti Meat" ],
    mdl = "models/zerochain/props_kitchen/zmc_plate03.mdl",
    time = 600,
    items = {
       {uniqueid = "eaf4422d32", lpos = Vector(0.5,0.5,0.1), lang = angle_zero,scale = 1},
    },
    price = 1000,
})

AddDish({
    uniqueid = "a365453d95",
    name = zmc.language[ "Spagetti Vegie" ],
    mdl = "models/zerochain/props_kitchen/zmc_plate03.mdl",
    time = 600,
    items = {
       {uniqueid = "41ea426784", lpos = Vector(0.5,0.5,0.11), lang = angle_zero,scale = 1},
    },
    price = 1000,
})


AddDish({
    uniqueid = "a8a16a49fe",
    name = zmc.language[ "Soup Generic" ],
    mdl = "models/zerochain/props_kitchen/zmc_plate05.mdl",
    time = 600,
    items = {
       {uniqueid = "a3cecf5f71", lpos = Vector(0.5,0.5,0.26), lang = angle_zero,scale = 0.73},
    },
    price = 1000,
})

AddDish({
    uniqueid = "ad52a96439",
    name = zmc.language[ "Soup Tomato" ],
    mdl = "models/zerochain/props_kitchen/zmc_plate05.mdl",
    time = 600,
    items = {
       {uniqueid = "6a5a74689c", lpos = Vector(0.5,0.5,0.28), lang = angle_zero,scale = 0.72},
    },
    price = 1000,
})

AddDish({
    uniqueid = "2eac964caa",
    name = zmc.language[ "Soup Goulash" ],
    mdl = "models/zerochain/props_kitchen/zmc_plate05.mdl",
    time = 600,
    items = {
       {uniqueid = "5417ddb5ba", lpos = Vector(0.5,0.5,0.28), lang = angle_zero,scale = 0.72},
    },
    price = 1000,
})



AddDish({
    uniqueid = "ea05fb4aa7",
    name = zmc.language[ "Maki - Fish" ],
    mdl = "models/zerochain/props_kitchen/zmc_plate04.mdl",
    time = 600,
    items = {
       {uniqueid = "9277032494", lpos = Vector(0.41,0.44,0.13), lang = Angle(90,0.5,0),scale = 1},
       {uniqueid = "9277032494", lpos = Vector(0.64,0.44,0.13), lang = Angle(90,57.6,0),scale = 1},
       {uniqueid = "9277032494", lpos = Vector(0.5,0.66,0.13), lang = Angle(90,57.6,0),scale = 1},
    },
    price = 1000,
})

AddDish({
    uniqueid = "6cb5ada18c",
    name = zmc.language[ "Maki - Mix" ],
    mdl = "models/zerochain/props_kitchen/zmc_plate04.mdl",
    time = 600,
    items = {
       {uniqueid = "9277032494", lpos = Vector(0.56,0.62,0.13), lang = Angle(90,57.6,0),scale = 1},
       {uniqueid = "7a872ba507", lpos = Vector(0.36,0.57,0.13), lang = Angle(90,0.5,0),scale = 1},
       {uniqueid = "4e37b88234", lpos = Vector(0.61,0.4,0.12), lang = Angle(90,0.46,0),scale = 1},
       {uniqueid = "86a893eaf8", lpos = Vector(0.38,0.37,0.12), lang = Angle(90,0.5,0),scale = 1},
    },
    price = 1000,
})



AddDish({
    uniqueid = "28a911f3f8",
    name = zmc.language[ "Steak" ],
    mdl = "models/zerochain/props_kitchen/zmc_plate03.mdl",
    time = 600,
    items = {
       {uniqueid = "04f7f02dc4", lpos = Vector(0.7,0.59,0.05), lang = Angle(0,223.2,0),scale = 1},
       {uniqueid = "3b44867a77", lpos = Vector(0.34,0.47,0.16), lang = Angle(18,133.2,0),scale = 1},
    },
    price = 1000,
})

AddDish({
    uniqueid = "59ff2efeb1",
    name = zmc.language[ "Pommes" ],
    mdl = "models/zerochain/props_kitchen/zmc_plate01.mdl",
    time = 600,
    items = {
       {uniqueid = "3b44867a77", lpos = Vector(0.63,0.55,0.13), lang = Angle(0,176.4,0),scale = 1},
       {uniqueid = "3b44867a77", lpos = Vector(0.35,0.56,0.13), lang = Angle(0,25.2,0),scale = 1},
    },
    price = 1000,
})

AddDish({
    uniqueid = "f6ff9a85c4",
    name = zmc.language[ "Burger" ],
    mdl = "models/zerochain/props_kitchen/zmc_plate01.mdl",
    time = 600,
    items = {
       {uniqueid = "d042cd82c9", lpos = Vector(0.5,0.5,0.06), lang = angle_zero,scale = 1},
       {uniqueid = "08f87f8949", lpos = Vector(0.5,0.5,0.17), lang = angle_zero,scale = 1},
       {uniqueid = "4e59caf7a3", lpos = Vector(0.5,0.5,0.12), lang = angle_zero,scale = 1},
       {uniqueid = "18c8ba9e90", lpos = Vector(0.74,0.5,0.17), lang = Angle(147.6,0.5,0),scale = 1},
       {uniqueid = "8398b7a744", lpos = Vector(0.28,0.54,0.17), lang = Angle(10.8,0.54,0),scale = 1},
       {uniqueid = "c46279e450", lpos = Vector(0.5,0.5,0.4), lang = angle_zero,scale = 1},
    },
    price = 1000,
})

AddDish({
    uniqueid = "1d7f6a1359",
    name = zmc.language[ "Baguette" ],
    mdl = "models/zerochain/props_kitchen/zmc_plate02.mdl",
    time = 600,
    items = {
       {uniqueid = "65c1cfef95", lpos = Vector(0.37,0.54,0.11), lang = Angle(0,100.8,0),scale = 1},
       {uniqueid = "65c1cfef95", lpos = Vector(0.59,0.48,0.11), lang = Angle(0,100.8,0),scale = 1},
       {uniqueid = "65c1cfef95", lpos = Vector(0.48,0.49,0.2), lang = Angle(0,122.4,0),scale = 1},
    },
    price = 1000,
})

AddDish({
    uniqueid = "128b12b01f",
    name = zmc.language[ "Stick Fish" ],
    mdl = "models/zerochain/props_kitchen/zmc_plate03.mdl",
    time = 600,
    items = {
       {uniqueid = "9d3460cb03", lpos = Vector(0.5,0.5,0.08), lang = Angle(0,0.5,0),scale = 1},
       {uniqueid = "9d3460cb03", lpos = Vector(0.32,0.5,0.08), lang = Angle(0,7.2,0),scale = 1},
       {uniqueid = "9d3460cb03", lpos = Vector(0.7,0.49,0.08), lang = Angle(0,3.6,0),scale = 1},
    },
    price = 1000,
})


AddDish({
    uniqueid = "c78e1fb08c",
    name = zmc.language[ "Holiday Cup" ],
    mdl = "models/zerochain/props_kitchen/zmc_plate05.mdl",
    time = 600,
    items = {
       {uniqueid = "9e4977a760", lpos = Vector(0.5,0.5,0.19), lang = angle_zero,scale = 0.83},
       {uniqueid = "ce07ee2d41", lpos = Vector(0.5,0.5,0.32), lang = angle_zero,scale = 0.62},
    },
    price = 1000,
})
