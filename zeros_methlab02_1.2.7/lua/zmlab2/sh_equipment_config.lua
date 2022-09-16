zmlab2 = zmlab2 or {}
zmlab2.config = zmlab2.config or {}
zmlab2.config.Equipment = zmlab2.config.Equipment or {}

// Here are all the entities which can be bought / build
zmlab2.config.Equipment.List = {
	[1] = {
		name = zmlab2.language["ventilation_title"],
		desc = zmlab2.language["ventilation_desc"],
		class = "zmlab2_machine_ventilation",
		model = "models/zerochain/props_methlab/zmlab2_ventilation.mdl",
		price = 1000,
		limit = 4,
	},
	[2] = {
		name = zmlab2.language["storage_title"],
		desc = zmlab2.language["storage_desc"],
		class = "zmlab2_storage",
		model = "models/zerochain/props_methlab/zmlab2_storage.mdl",
		price = 1000,
		limit = 2,
	},
	[3] = {
		name = zmlab2.language["furnace_title"],
		desc = zmlab2.language["furnace_desc"],
		class = "zmlab2_machine_furnace",
		model = "models/zerochain/props_methlab/zmlab2_furnance.mdl",
		price = 1000,
		limit = 3,
	},
	[4] = {
		name = zmlab2.language["mixer_title"],
		desc = zmlab2.language["mixer_desc"],
		class = "zmlab2_machine_mixer",
		model = "models/zerochain/props_methlab/zmlab2_mixer.mdl",
		price = 1000,
		limit = 3,
	},
	[5] = {
		name = zmlab2.language["filter_title"],
		desc = zmlab2.language["filter_desc"],
		class = "zmlab2_machine_filter",
		model = "models/zerochain/props_methlab/zmlab2_filter.mdl",
		price = 1000,
		limit = 3,
	},
	[6] = {
		name = zmlab2.language["filler_title"],
		desc = zmlab2.language["filler_desc"],
		class = "zmlab2_machine_filler",
		model = "models/zerochain/props_methlab/zmlab2_filler.mdl",
		price = 1000,
		limit = 3,
	},
	[7] = {
		name = zmlab2.language["frezzer_title"],
		desc = zmlab2.language["frezzer_desc"],
		class = "zmlab2_machine_frezzer",
		model = "models/zerochain/props_methlab/zmlab2_frezzer.mdl",
		price = 1000,
		limit = 3,
	},
	[8] = {
		name = zmlab2.language["packingtable_title"],
		desc = zmlab2.language["packingtable_desc"],
		class = "zmlab2_table",
		model = "models/zerochain/props_methlab/zmlab2_table.mdl",
		price = 1000,
		limit = 2,
	}
}
