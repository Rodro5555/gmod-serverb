zrush = zrush or {}
zrush.FuelTypes = {}
local function AddFuel(data) return table.insert(zrush.FuelTypes, data) end

// Fuel Settings
///////////////////////
// Fuel Registration
/*
	Values for this are
	Name			   : The Name of the Fuel
	FuelColor		   : The Color of the Fuel
	VCmodfuel (0||1)   : What VC Mod fuel is it (Petrol or Diesel) (Only usefull if you have VCMod installed!)
	RefineOutput	   : How much Fuel do we get from the refined Oil (0.5 = 50%)
	BasePrice		   : The Start Sell Price of the Fuel per Unit (Liter,etc..)
	Ranks			   : The Ranks which are allowed do refine this Fuel
	Jobs			   : The Jobs which are allowed to refine this Fuel
*/


local vip_ranks = {
	["vipinicial"] = true,
	["vipgiant"] = true,
	["viplegend"] = true,
	["vipblackblood"] = true,
	["superadmin"] = true
}

AddFuel({
	name = "Regular Petrol",
	color = Color(211,190,255),
	vcmodfuel = 0,
	refineoutput = 0.55,
	price = 180,
	ranks = {},
	/*
	jobs = {
		["Fuel Refiner"] = true,
		["Gangster"] = true,
	}
	*/
})

AddFuel({
	name = "Premium Petrol",
	color = Color(255,236,110),
	vcmodfuel = 0,
	refineoutput = 0.25,
	price = 200,
	ranks = vip_ranks,
	jobs = {}
})

AddFuel({
	name = "Premium Ultra Petrol",
	color = Color(211,255,149),
	vcmodfuel = 0,
	refineoutput = 0.1,
	price = 220,
	ranks = vip_ranks,
	jobs = {}
})



AddFuel({
	name = "Regular Diesel",
	color = Color(255,227,190),
	vcmodfuel = 1,
	refineoutput = 0.55,
	price = 180,
	ranks = {},
	jobs = {}
})

AddFuel({
	name = "Premium Diesel",
	color = Color(248,154,53),
	vcmodfuel = 1,
	refineoutput = 0.25,
	price = 220,
	ranks = vip_ranks,
	jobs = {}
})

AddFuel({
	name = "Premium Ultra Diesel",
	color = Color(255,68,31),
	vcmodfuel = 1,
	refineoutput = 0.1,
	price = 240,
	ranks = vip_ranks,
	jobs = {}
})
///////////////////////
