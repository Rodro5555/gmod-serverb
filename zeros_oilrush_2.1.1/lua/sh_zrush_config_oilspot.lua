zrush = zrush or {}
zrush.Holes = {}
local function AddOilSource(data) return table.insert(zrush.Holes, data) end

// Oil Hole Settings
///////////////////////
// OilSource Registration
/*
	Values for this are
	Chance (1-100)	     : The Chance of getting this Hole
	Depth			     : How many pipes it will need
	Burnchance (1-100)   : how high the chance is that it needs to be burned after hitting the oil
    oil_amount			 : how much oil is in the Hole
	gas_amount           : how much gas is in the Hole
	chaos_chance         : The Chance of the Machine do have a OverHeat/Jam -Event when working on this OilSource (This gets added do the Base OverHeat/Jam -Chance of the machine)
*/


AddOilSource({
    chance = 50,
    depth = 25,
    burnchance = 50,
    oil_amount = math.Round(math.random(300, 1000)),
    gas_amount = math.Round(math.random(100, 500)),
    chaos_chance = 5
})

AddOilSource({
    chance = 30,
    depth = 40,
    burnchance = 50,
    oil_amount = math.Round(math.random(600, 2000)),
    gas_amount = math.Round(math.random(500, 800)),
    chaos_chance = 10
})

AddOilSource({
    chance = 20,
    depth = 45,
    burnchance = 75,
    oil_amount = math.Round(math.random(1500, 4000)),
    gas_amount = math.Round(math.random(500, 1000)),
    chaos_chance = 20
})
///////////////////////
