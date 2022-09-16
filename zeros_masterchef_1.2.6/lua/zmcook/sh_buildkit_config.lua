zmc = zmc or {}
zmc.config = zmc.config or {}
zmc.config.Buildkit = zmc.config.Buildkit or {}
zmc.config.Buildkit.List = {}
local function AddItem(data) return table.insert(zmc.config.Buildkit.List,data) end



AddItem({
	name = zmc.language[ "Cookbook" ],
	class = "zmc_cookbook",
	mdl = "models/zerochain/props_kitchen/zmc_cookbook.mdl",
	price = 1000,
	limit = 4,
})
AddItem({
	name = zmc.language[ "Fridge" ],
	class = "zmc_fridge",
	mdl = "models/zerochain/props_kitchen/zmc_fridge.mdl",
	price = 1000,
	limit = 2,
})
AddItem({
	name = zmc.language[ "Garbagebin" ],
	class = "zmc_garbagepin",
	mdl = "models/zerochain/props_kitchen/zmc_garbagebin.mdl",
	price = 500,
	limit = 3,
})
AddItem({
	name = zmc.language[ "Mixer" ],
	class = "zmc_mixer",
	mdl = "models/zerochain/props_kitchen/zmc_mixer.mdl",
	price = 500,
	limit = 3,
})
AddItem({
	name = zmc.language[ "Worktable" ],
	class = "zmc_worktable",
	mdl = "models/zerochain/props_kitchen/zmc_worktable.mdl",
	price = 500,
	limit = 3,
})




AddItem({
	name = zmc.language[ "BoilPot" ],
	class = "zmc_boilpot",
	mdl = "models/zerochain/props_kitchen/zmc_heater.mdl",
	price = 500,
	limit = 3,
})
AddItem({
	name = zmc.language[ "Grill" ],
	class = "zmc_grill",
	mdl = "models/zerochain/props_kitchen/zmc_heater.mdl",
	bodygroup = {[1] = 1},
	price = 500,
	limit = 3,
})
AddItem({
	name = zmc.language[ "Oven" ],
	class = "zmc_oven",
	mdl = "models/zerochain/props_kitchen/zmc_heater.mdl",
	bodygroup = {[1] = 2},
	price = 500,
	limit = 3,
})
AddItem({
	name = zmc.language[ "SoupPot" ],
	class = "zmc_souppot",
	mdl = "models/zerochain/props_kitchen/zmc_heater.mdl",
	price = 500,
	limit = 3,
})
AddItem({
	name = zmc.language[ "Wok" ],
	class = "zmc_wok",
	mdl = "models/zerochain/props_kitchen/zmc_heater.mdl",
	price = 500,
	limit = 3,
})



AddItem({
	name = zmc.language[ "Dishtable" ],
	class = "zmc_dishtable",
	mdl = "models/zerochain/props_kitchen/zmc_dishtable.mdl",
	price = 500,
	limit = 2,
})
AddItem({
	name = zmc.language[ "Ordertable" ],
	class = "zmc_ordertable",
	mdl = "models/zerochain/props_kitchen/zmc_ordertable.mdl",
	price = 500,
	limit = 2,
})
AddItem({
	name = zmc.language[ "Customertable" ],
	class = "zmc_customertable",
	mdl = "models/zerochain/props_kitchen/zmc_table.mdl",
	price = 500,
	limit = 4,
})
AddItem({
	name = zmc.language[ "Washtable" ],
	class = "zmc_washtable",
	mdl = "models/zerochain/props_kitchen/zmc_washtable.mdl",
	price = 500,
	limit = 2,
})
