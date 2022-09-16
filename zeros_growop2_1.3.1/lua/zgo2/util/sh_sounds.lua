
// DoobyTable
zclib.Sound.List["zgo2_grab_weed"] = {
	paths = {"zgo2/doobytable/grab_weed.wav"},
	lvl = 60,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}

zclib.Sound.List["zgo2_grab_paper"] = {
	paths = {"zgo2/doobytable/grab_paper.wav"},
	lvl = 60,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}
zclib.Sound.List["zgo2_paper_close"] = {
	paths = {"zgo2/doobytable/paper_close.wav"},
	lvl = 60,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}
zclib.Sound.List["zgo2_paper_open"] = {
	paths = {"zgo2/doobytable/paper_open.wav"},
	lvl = 60,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}

zclib.Sound.List["zgo2_grinder_open"] = {
	paths = {"zgo2/doobytable/grinder_open.wav"},
	lvl = 60,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}
zclib.Sound.List["zgo2_grinder_close"] = {
	paths = {"zgo2/doobytable/grinder_close.wav"},
	lvl = 60,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}
zclib.Sound.List["zgo2_grinder_grind"] = {
	paths = {"zgo2/doobytable/grinder_grind.wav"},
	lvl = 60,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}

zclib.Sound.List["zgo2_joint_foldstage"] = {
	paths = {"zgo2/doobytable/joint_fold01.wav","zgo2/doobytable/joint_fold02.wav","zgo2/doobytable/joint_fold03.wav"},
	lvl = 60,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}
zclib.Sound.List["zgo2_joint_fold_finish"] = {
	paths = {"zgo2/doobytable/joint_fold_finish.wav"},
	lvl = 60,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}




// Joint
sound.Add({
	name = "zgo2_joint_loop",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 60,
	pitch = {100, 100},
	sound = {"zgo2/joint/joint_loop.wav"}
})
zclib.Sound.List["zgo2_joint_start"] = {
	paths = {"zgo2/joint/joint_start.wav"},
	lvl = 60,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}
zclib.Sound.List["zgo2_joint_stop"] = {
	paths = {"zgo2/joint/joint_stop.wav"},
	lvl = 60,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}



// Sniff Swep
zclib.Sound.List["zgo2_sniff"] = {
	paths = {"zgo2/sniff01.wav","zgo2/sniff02.wav"},
	lvl = 60,
	pitchMin = 95,
	pitchMax = 105,
	pref_volume = 1
}

// Clipper
sound.Add({
    name = "zgo2_grind_empty",
    channel = CHAN_STATIC,
    volume = 1,
    level = 55,
    pitch = {100, 100},
    sound = {"zgo2/grind_loop03.wav"}
})

sound.Add({
	name = "zgo2_grind_weed",
	channel = CHAN_STATIC,
	volume = 1,
	level = 55,
	pitch = { 100, 100 },
	sound = { "zgo2/grind_weed_loop.wav"}
})

// Packer
sound.Add({
	name = "zgo2_press_weed",
	channel = CHAN_STATIC,
	volume = 1,
	level = 50,
	pitch = { 100, 100 },
	sound = { "plats/elevator_move_loop2.wav"}
})

// Generator
sound.Add({
	name = "zgo2_generator_refill",
	channel = CHAN_STATIC,
	volume = 1,
	level = 50,
	pitch = { 100, 100 },
	sound = { "zgo2/generator_refill.wav"}
})

// Crate
sound.Add({
	name = "zgo2_crate_addweed",
	channel = CHAN_STATIC,
	volume = 1,
	level = 55,
	pitch = { 100, 100 },
	sound = { "player/footsteps/grass1.wav", "player/footsteps/grass2.wav", "player/footsteps/grass3.wav", "player/footsteps/grass4.wav" }
})


zclib.Sound.List["zgo2_dirt"] = {
	paths = {
		"player/footsteps/gravel1.wav",
		"player/footsteps/gravel2.wav",
		"player/footsteps/gravel3.wav",
		"player/footsteps/gravel4.wav",
	},
	lvl = 45,
	pitchMin = 100,
	pitchMax = 100
}

zclib.Sound.List["zgo2_water"] = {
	paths = {
		"ambient/water/water_splash1.wav",
		"ambient/water/water_splash2.wav",
		"ambient/water/water_splash3.wav"
	},
	lvl = 45,
	pitchMin = 100,
	pitchMax = 100
}


sound.Add({
	name = "zgo2_bulb_burnout",
	channel = CHAN_STATIC,
	volume = 1,
	level = 65,
	pitch = { 100, 100 },
	sound = { "weapons/physcannon/superphys_small_zap1.wav", "weapons/physcannon/superphys_small_zap2.wav", "weapons/physcannon/superphys_small_zap3.wav", "weapons/physcannon/superphys_small_zap4.wav", }
})



sound.Add({
	name = "zgo2_generator_loop",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 55,
	pitch = { 100, 100 },
	sound = { "zgo2/generator_running.wav"}
})
sound.Add({
	name = "zgo2_generator_stop",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 55,
	pitch = { 100, 100 },
	sound = { "zgo2/generator_stop.wav"}
})
sound.Add({
	name = "zgo2_generator_start_sucess",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 55,
	pitch = { 100, 100 },
	sound = { "zgo2/generator_start_sucess.wav"}
})
sound.Add({
	name = "zgo2_generator_start_fail",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 55,
	pitch = { 100, 100 },
	sound = { "zgo2/generator_start_fail.wav"}
})


sound.Add({
	name = "zgo2_jar_place",
	channel = CHAN_STATIC,
	volume = 1,
	level = 65,
	pitch = { 100, 100 },
	sound = {
		"physics/glass/glass_sheet_impact_soft1.wav",
		"physics/glass/glass_sheet_impact_soft2.wav",
		"physics/glass/glass_sheet_impact_soft3.wav",
	}
})

sound.Add({
	name = "zgo2_map_background_ambient",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 65,
	pitch = { 100, 100 },
	sound = { "zgo2/map_background_ambient.wav"}
})

sound.Add({
	name = "zgo2_map_marketplace_ambient",
	channel = CHAN_STATIC,
	volume = 0.1,
	level = 65,
	pitch = { 100, 100 },
	sound = { "zgo2/map_marketplace_ambient.wav"}
})

zclib.Sound.List["zgo2_plug"] = {
	paths = {
		"zgo2/plug/plug01.wav",
		"zgo2/plug/plug03.wav",
		"zgo2/plug/plug07.wav",
		"zgo2/plug/plug08.wav",
		"zgo2/plug/plug11.wav",
		"zgo2/plug/plug13.wav",
		"zgo2/plug/plug15.wav",
	},
	lvl = 65,
	pitchMin = 100,
	pitchMax = 100
}

zclib.Sound.List["zgo2_install"] = {
	paths = { "ambient/energy/spark1.wav", "ambient/energy/spark2.wav", "ambient/energy/spark3.wav", },
	lvl = 65,
	pitchMin = 100,
	pitchMax = 100
}

zclib.Sound.List["zgo2_bulb"] = {
	paths = {
		"zgo2/bulb/bulb01.wav",
		"zgo2/bulb/bulb02.wav",
		"zgo2/bulb/bulb03.wav",
		"zgo2/bulb/bulb04.wav",
		"zgo2/bulb/bulb05.wav",
	},
	lvl = 55,
	pitchMin = 100,
	pitchMax = 100
}

zclib.Sound.List["zgo2_plant_cut"] = {
	paths = {
		"zgo2/plant_cut01.wav",
		"zgo2/plant_cut02.wav",
		"zgo2/plant_cut03.wav",
		"zgo2/plant_cut04.wav",
	},
	lvl = 55,
	pitchMin = 100,
	pitchMax = 100
}

zclib.Sound.List["zgo2_leaf_rustling"] = {
	paths = {
		//"zgo2/leaf/leaf01.wav",
		"zgo2/leaf/leaf02.wav",
		"zgo2/leaf/leaf03.wav",
		"zgo2/leaf/leaf04.wav",
		"zgo2/leaf/leaf05.wav",
		"zgo2/leaf/leaf06.wav",
	},
	lvl = 65,
	pitchMin = 100,
	pitchMax = 100
}

zclib.Sound.List["zgo2_plant_hang"] = {
	paths = {
		"zgo2/plant_hang.wav",
	},
	lvl = 65,
	pitchMin = 100,
	pitchMax = 100
}

// Generic
sound.Add({
	name = "zgo2_cough",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 60,
	pitch = {90, 110},
	sound = {"zgo2/bong/cough.wav"}
})

// Bong
sound.Add({
	name = "zgo2_igniter_lit",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 60,
	pitch = {100, 100},
	sound = {"zgo2/bong/igniter_lit.wav"}
})
sound.Add({
	name = "zgo2_bong_end",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 60,
	pitch = {100, 100},
	sound = {"zgo2/bong/bong_end.wav"}
})
sound.Add({
	name = "zgo2_bong_loop",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 60,
	pitch = {100, 100},
	sound = {"zgo2/bong/bong_loop.wav"}
})
zclib.Sound.List["zgo2_bong_exhale_short"] = {
	paths = {"zgo2/bong/bong_exhale_short.wav"},
	lvl = 60,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}
zclib.Sound.List["zgo2_bong_exhale_mid"] = {
	paths = {"zgo2/bong/bong_exhale_mid.wav"},
	lvl = 60,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}
zclib.Sound.List["zgo2_bong_exhale_long"] = {
	paths = {"zgo2/bong/bong_exhale_long.wav"},
	lvl = 60,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}



sound.Add({
	name = "zgo2_lamp_sodium_loop",
	channel = CHAN_STATIC,
	volume = 1,
	level = 45,
	pitch = { 100, 100 },
	sound = { "zgo2/lamp_sodium_loop.wav"}
})

sound.Add({
	name = "zgo2_lamp_led_loop",
	channel = CHAN_STATIC,
	volume = 1,
	level = 50,
	pitch = { 100, 100 },
	sound = { "zgo2/lamp_led_loop.wav"}
})

sound.Add({
	name = "zgo2_pump_loop",
	channel = CHAN_STATIC,
	volume = 1,
	level = 50,
	pitch = { 100, 100 },
	sound = { "zgo2/pump_loop.wav"}
})

sound.Add({
	name = "zgo2_clipper_weed_output",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	pitch = { 100, 100 },
	sound = { "zgo2/clipper_weed_output.wav"}
})


sound.Add({
	name = "zgo2_Splicer_loop",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 50,
	pitch = {100, 100},
	sound = {"npc/scanner/combat_scan_loop6.wav"}
})


// Muffin
zclib.Sound.List["zgo2_muffin_eat"] = {
	paths = {"zgo2/muffin_eat.wav"},
	lvl = 60,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}



// Cooking
zclib.Sound.List["zgo2_cooking_dough"] = {
	paths = {"zgo2/cooking/cooking_dough.wav"},
	lvl = 60,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}
zclib.Sound.List["zgo2_cooking_flour"] = {
	paths = {"zgo2/cooking/cooking_flour.wav"},
	lvl = 60,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}
zclib.Sound.List["zgo2_mixer_close"] = {
	paths = {"zgo2/cooking/mixer_close.wav"},
	lvl = 60,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}
sound.Add({
	name = "zgo2_mixer_loop",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 60,
	pitch = {100, 100},
	sound = {"zgo2/cooking/mixer_loop.wav"}
})
zclib.Sound.List["zgo2_mixer_open"] = {
	paths = {"zgo2/cooking/mixer_open.wav"},
	lvl = 60,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}
zclib.Sound.List["zgo2_mixerbowl_add"] = {
	paths = {"zgo2/cooking/mixerbowl_add.wav"},
	lvl = 60,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}
zclib.Sound.List["zgo2_mixerbowl_remove"] = {
	paths = {"zgo2/cooking/mixerbowl_remove.wav"},
	lvl = 60,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}
zclib.Sound.List["zgo2_oven_close"] = {
	paths = {"zgo2/cooking/oven_close.wav"},
	lvl = 60,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}
zclib.Sound.List["zgo2_oven_open"] = {
	paths = {"zgo2/cooking/oven_open.wav"},
	lvl = 60,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}
sound.Add({
	name = "zgo2_oven_loop",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 60,
	pitch = {100, 100},
	sound = {"zgo2/cooking/oven_loop.wav"}
})
