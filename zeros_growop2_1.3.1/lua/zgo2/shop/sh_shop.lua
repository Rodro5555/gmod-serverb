zgo2 = zgo2 or {}
zgo2.Shop = zgo2.Shop or {}
zgo2.Shop.List = zgo2.Shop.List or {}
zgo2.Shop.IsItem = {}

/*
	Adds a new item to the Multitool Job
*/
local function AddItem(category,data)
	table.insert(zgo2.Shop.List[ category ].items,data)
	if data.class then
		zgo2.Shop.IsItem[data.class] = true
	else
		print()
		print("Added Shop Item has no class!")
		PrintTable(data)
		print()
	end
	zclib.CacheModel(data.mdl)
end

/*
	Returns how many entities of that class the player owns
*/
local function GetEntityCount(ply,class)
	local count = 0
	local entities = ents.FindByClass(class)
	for k,v in pairs(entities) do
		if IsValid(v) and zclib.Player.IsOwner(ply, v) then
			count = count + 1
		end
	end
	return count
end

/*
	Checks if the player reached the entity limit before buying another entity from the shop
*/
function zgo2.Shop.ReachedLimit(ply,category,itemid)
	if not zgo2.Shop.List[category] then return false end
	local data = zgo2.Shop.List[category].items[itemid]
	if not data then return false end

	local max = data.max or 1
	if data.class == "zgo2_pot" and zgo2.config.Pot.SpawnLimitOverwrite and zgo2.config.Pot.SpawnLimitOverwrite[zclib.Player.GetRank(ply)] then
		max = zgo2.config.Pot.SpawnLimitOverwrite[zclib.Player.GetRank(ply)]
	end

	return GetEntityCount(ply,data.class) >= max
end

/*
	Checks if the player is allowed to buy this item
*/
function zgo2.Shop.CanBuy(ply,category,itemid)
	if not zgo2.Shop.List[category] then return false end
	local data = zgo2.Shop.List[category].items[itemid]
	if not data then return false end

	return zgo2.Player.CanUse(ply,data)
end

/*
	Returns how much money the player would get as a refund when selling the equipment
*/
function zgo2.Shop.GetItemRefund(price)
	if not price then return end
	return (price / 100) * zgo2.config.Shop.Refund
end

function zgo2.Shop.Rebuild()

	zgo2.Shop.List = {
		["Water"] = {
			icon = "zgo2_icon_water",
			items = {}
		},
		["Pots"] = {
			icon = "zgo2_icon_pot",
			items = {}
		},
		["Lamps"] = {
			icon = "zgo2_icon_power",
			items = {}
		},
		["Tents"] = {
			icon = "zgo2_icon_tent",
			items = {}
		},
		["Seeds"] = {
			icon = "zgo2_icon_seed",
			items = {}
		},
		["Processing"] = {
			icon = "zgo2_icon_scissor",
			items = {}
		},
		["Production"] = {
			icon = "zgo2_icon_weed",
			items = {}
		}
	}

	// Can the player refund entities?
	if zgo2.config.Shop.Refund > 0 then
		zgo2.Shop.List["Sell"]  = {
			icon = "money",
			func = function()
				// Open PointerSystem for selling
				zgo2.Multitool.SellItem()
			end
		}
	end

	for k, v in pairs(zgo2.Plant.GetAll()) do

		// If the plant config is a spliced data one then ignore it
		if zgo2.Plant.IsSplice(k) then continue end

		AddItem("Seeds", {
			name = v.name .. " [" .. zgo2.language[ "Seeds" ] .. "]",
			class = "zgo2_seed",
			id = k,
			mdl = "models/zerochain/props_growop2/zgo2_weedseeds.mdl",
			price = zgo2.Plant.GetTotalMoney(k) * ((1 / 100) * zgo2.config.Seedbox.Cost),
			jobs = v.jobs,
			ranks = v.ranks,
			max = 5,
		})
	end

	for k, v in pairs(zgo2.config.Pots) do
		AddItem("Pots",{
			name = v.name,
			class = "zgo2_pot",
			mdl = zgo2.Pot.GetModel(k),
			id = k,
			price = v.price,
			jobs = v.jobs,
			ranks = v.ranks,
			max = 12,
		})
	end

	for k,v in pairs(zgo2.config.Racks) do
		AddItem("Pots",{
			name = v.name,
			class = v.class,
			mdl = v.mdl,
			id = k,
			price = v.price,
			jobs = v.jobs,
			ranks = v.ranks,
			max = 6,
		})
	end

	for k, v in pairs(zgo2.config.Watertanks) do
		AddItem("Water",{
			name = v.name,
			class = v.class,
			id = k,
			mdl = v.mdl,
			price = v.price,
			jobs = v.jobs,
			ranks = v.ranks,
			max = 6,
		})
	end

	for k, v in pairs(zgo2.config.Lamps) do

		if v.tent then
			AddItem("Tents",{
				name = v.name,
				class = v.class,
				id = k,
				mdl = v.mdl,
				price = v.price,
				jobs = v.jobs,
				ranks = v.ranks,
				max = 8,
			})
		else

			AddItem("Lamps",{
				name = v.name,
				class = v.class,
				id = k,
				mdl = v.mdl,
				price = v.price,
				jobs = v.jobs,
				ranks = v.ranks,
				max = 6,
			})
		end
	end

	for k, v in pairs(zgo2.config.Tents) do
		AddItem("Tents",{
			name = v.name,
			class = v.class,
			mdl = v.mdl,
			id = k,
			price = v.price,
			jobs = v.jobs,
			ranks = v.ranks,
			max = 4,
		})
	end

	for k, v in pairs(zgo2.config.Generators) do
		AddItem("Lamps",{
			name = v.name,
			class = v.class,
			id = k,
			mdl = v.mdl,
			price = v.price,
			jobs = v.jobs,
			ranks = v.ranks,
			max = 2,
		})
	end

	local NextLevelJobs = {}
	table.Merge(NextLevelJobs,zgo2.config.Jobs.Pro)
	table.Merge(NextLevelJobs,zgo2.config.Jobs.Basic)


	AddItem("Pots",{
		name = zgo2.language[ "Soil" ],
		class = "zgo2_soil",
		max = 3,
		mdl = "models/zerochain/props_growop2/zgo2_soil.mdl",
		price = 100,
	})

	AddItem("Processing",{
		name = zgo2.language[ "Jar Crate" ],
		class = "zgo2_jarcrate",
		max = 3,
		mdl = "models/zerochain/props_growop2/zgo2_jarcrate.mdl",
		price = 1000,
	})


	AddItem("Processing", {
		name = zgo2.language[ "Drying Line" ],
		class = "zgo2_dryline",
		max = 2,
		mdl = "models/zerochain/props_growop2/zgo2_dryline.mdl",
		price = 1000
	})

	AddItem("Processing", {
		name = zgo2.language[ "Weed Clipper" ],
		class = "zgo2_clipper",
		max = 2,
		mdl = "models/zerochain/props_growop2/zgo2_weedcruncher.mdl",
		price = 5000,
		jobs = NextLevelJobs,
	})

	AddItem("Processing", {
		name = zgo2.language[ "Weed Packer" ],
		class = "zgo2_packer",
		max = 2,
		mdl = "models/zerochain/props_growop2/zgo2_weedpacker.mdl",
		price = 5000,
		jobs = zgo2.config.Jobs.Pro,
	})

	AddItem("Processing", {
		name = zgo2.language[ "Palette" ],
		class = "zgo2_palette",
		max = 6,
		mdl = "models/zerochain/props_growop2/zgo2_palette.mdl",
		price = 100,
		jobs = zgo2.config.Jobs.Pro,
	})


	AddItem("Processing", {
		name = zgo2.language[ "Weed Clipper - Motor" ],
		class = "zgo2_motor",
		max = 2,
		mdl = "models/zerochain/props_growop2/zgo2_motor.mdl",
		price = 1000,
		jobs = zgo2.config.Jobs.Pro,
	})

	AddItem("Processing", {
		name = zgo2.language[ "Jar" ],
		class = "zgo2_jar",
		max = 12,
		mdl = "models/zerochain/props_growop2/zgo2_jar.mdl",
		price = 500,
		jobs = NextLevelJobs,
	})

	AddItem("Processing", {
		name = zgo2.language[ "Transport Crate" ],
		class = "zgo2_crate",
		max = 6,
		mdl = "models/zerochain/props_growop2/zgo2_crate.mdl",
		price = 1000,
	})

	AddItem("Processing", {
		name = zgo2.language[ "Log Book" ],
		class = "zgo2_logbook",
		max = 1,
		mdl = "models/props_lab/binderblue.mdl",
		price = 1000
	})

	AddItem("Water",{
		name = zgo2.language[ "Water Pump" ],
		class = "zgo2_pump",
		max = 2,
		mdl = "models/zerochain/props_growop2/zgo2_pump.mdl",
		price = 3000,
		jobs = zgo2.config.Jobs.Pro,
	})

	AddItem("Lamps",{
		name = zgo2.language[ "Battery" ],
		class = "zgo2_battery",
		max = 3,
		mdl = "models/zerochain/props_growop2/zgo2_battery.mdl",
		price = 500
	})

	AddItem("Lamps",{
		name = zgo2.language[ "Fuel" ],
		class = "zgo2_fuel",
		max = 3,
		mdl = "models/zerochain/props_growop2/zgo2_fuel.mdl",
		price = 500,
		jobs = NextLevelJobs,
	})

	AddItem("Lamps",{
		name = zgo2.language[ "Sodium Bulb" ],
		class = "zgo2_bulb",
		max = 3,
		mdl = "models/zerochain/props_growop2/zgo2_bulb.mdl",
		price = 500
	})

	AddItem("Processing", {
		name = zgo2.language["Splicer"],
		class = "zgo2_splicer",
		max = 1,
		mdl = "models/zerochain/props_growop2/zgo2_lab.mdl",
		price = 1000,
		jobs = zgo2.config.Jobs.Pro,
	})


	AddItem("Production", {
		name = zgo2.language[ "DoobyTable" ],
		class = "zgo2_doobytable",
		max = 1,
		mdl = "models/zerochain/props_growop2/zgo2_doobytable.mdl",
		price = 1000
	})

	AddItem("Production", {
		name = zgo2.language["Mixer"],
		class = "zgo2_mixer",
		max = 5,
		mdl = "models/zerochain/props_growop2/zgo2_mixer.mdl",
		price = 1000
	})

	AddItem("Production", {
		name = zgo2.language["Oven"],
		class = "zgo2_oven",
		max = 5,
		mdl = "models/zerochain/props_growop2/zgo2_oven.mdl",
		price = 1000
	})

	for k, v in pairs(zgo2.config.Edibles) do
		AddItem("Production",{
			name = v.name,
			class = "zgo2_backmix",
			id = k,
			mdl = v.backmix_model,
			price = v.backmix_price,
			jobs = v.jobs,
			ranks = v.ranks,
			max = 8,
		})
	end
end

/*
	Rebuild the shop list if the plant config got edited
*/
zclib.Hook.Add("zgo2_OnPlantConfigLoaded", "zgo2_OnPlantConfigLoaded_Shop", function()
	zgo2.Shop.Rebuild()
end)

zclib.Hook.Add("zgo2_OnPotConfigLoaded", "zgo2_OnPotConfigLoaded_Shop", function()
	zgo2.Shop.Rebuild()
end)

zgo2.Shop.Rebuild()
