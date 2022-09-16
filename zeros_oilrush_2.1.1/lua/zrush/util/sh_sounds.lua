
sound.Add({
	name = "zrush_ui_click",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	pitch = {100, 100},
	sound = {"UI/buttonclick.wav"}
})

sound.Add({
	name = "zrush_sfx_error",
	channel = CHAN_STATIC,
	volume = 1,
	level = 65,
	pitch = {97, 100},
	sound = "zrush/zrush_error.wav"
})

sound.Add({
	name = "zrush_sfx_build",
	channel = CHAN_STATIC,
	volume = 1,
	level = 65,
	pitch = {97, 100},
	sound = "zrush/zrush_build01.wav",
	"zrush/zrush_build02.wav", "zrush/zrush_build03.wav"
})

sound.Add({
	name = "zrush_sfx_liquidfill",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 55,
	pitch = {97, 100},
	sound = "ambient/water/water_splash1.wav",
	"ambient/water/water_splash2.wav", "ambient/water/water_splash3.wav"
})

sound.Add({
	name = "zrush_sfx_barrel",
	channel = CHAN_STATIC,
	volume = 1,
	level = 65,
	pitch = {97, 100},
	sound = "physics/metal/metal_barrel_impact_soft1.wav",
	"physics/metal/metal_barrel_impact_soft2.wav", "physics/metal/metal_barrel_impact_soft3.wav", "physics/metal/metal_barrel_impact_soft4.wav"
})

sound.Add({
	name = "zrush_sfx_drill_pipedone",
	channel = CHAN_STATIC,
	volume = 1,
	level = 65,
	pitch = {97, 100},
	sound = "zrush/zrush_cooldown01.mp3",
	"zrush/zrush_cooldown02.mp3", "zrush/zrush_cooldown03.mp3", "zrush/zrush_cooldown04.mp3"
})

sound.Add({
	name = "zrush_sfx_drill_loadpipe",
	channel = CHAN_STATIC,
	volume = 1,
	level = 65,
	pitch = {60, 65},
	sound = "physics/metal/metal_grenade_impact_soft1.wav",
	"physics/metal/metal_grenade_impact_soft2.wav", "physics/metal/metal_grenade_impact_soft3.wav"
})

sound.Add({
	name = "zrush_sfx_cash01",
	channel = CHAN_STATIC,
	volume = 1,
	level = 65,
	pitch = {97, 100},
	sound = "zrush/zrush_cash01.wav"
})

sound.Add({
	name = "zrush_sfx_butangas",
	channel = CHAN_STATIC,
	volume = 1,
	level = 65,
	pitch = {97, 100},
	sound = "ambient/gas/steam_loop1.wav"
})

sound.Add({
	name = "zrush_sfx_oil",
	channel = CHAN_STATIC,
	volume = 1,
	level = 65,
	pitch = {97, 100},
	sound = "ambient/water/water_flow_loop1.wav"
})

sound.Add({
	name = "zrush_sfx_overheat",
	channel = CHAN_STATIC,
	volume = 1,
	level = 90,
	pitch = {80, 90},
	sound = "zrush/zrush_overheat01.wav",
	"zrush/zrush_overheat02.wav"
})

sound.Add({
	name = "zrush_sfx_overheat_loop",
	channel = CHAN_STATIC,
	volume = 1,
	level = 85,
	pitch = 90,
	sound = "zrush/zrush_fire.wav"
})

sound.Add({
	name = "zrush_sfx_cooldown",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 90,
	pitch = {80, 90},
	sound = "zrush/zrush_cooldown.wav"
})

-- Jam Event
sound.Add({
	name = "zrush_sfx_jammed",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 60,
	pitch = {80, 90},
	sound = "zrush/zrush_jammed.wav"
})

sound.Add({
	name = "zrush_sfx_unjam",
	channel = CHAN_STATIC,
	volume = 1,
	level = 70,
	pitch = {80, 90},
	sound = "zrush/zrush_unjam.wav"
})

sound.Add({
	name = "zrush_sfx_connect",
	channel = CHAN_STATIC,
	volume = 1,
	level = 65,
	pitch = {80, 90},
	sound = "zrush/zrush_connect.wav"
})

sound.Add({
	name = "zrush_sfx_deconnect",
	channel = CHAN_STATIC,
	volume = 1,
	level = 65,
	pitch = {80, 90},
	sound = "zrush/zrush_deconnect.wav"
})

sound.Add({
	name = "zrush_sfx_command",
	channel = CHAN_STATIC,
	volume = 1,
	level = 85,
	pitch = {80, 90},
	sound = "zrush/zrush_command.wav"
})

sound.Add({
	name = "zrush_sfx_drill",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 65,
	pitch = {80, 90},
	sound = "zrush/zrush_drill.wav"
})

sound.Add({
	name = "zrush_sfx_fire",
	channel = CHAN_STATIC,
	volume = 1,
	level = 85,
	pitch = {80, 90},
	sound = "zrush/zrush_fire.wav"
})

sound.Add({
	name = "zrush_sfx_pump",
	channel = CHAN_STATIC,
	volume = 1,
	level = 65,
	pitch = {80, 90},
	sound = "zrush/zrush_pumpjack_loop.wav"
})

sound.Add({
	name = "zrush_sfx_refine",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 65,
	pitch = {80, 90},
	sound = "zrush/zrush_refining.wav"
})

sound.Add({
	name = "zrush_sfx_connect_module",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 65,
	pitch = {80, 90},
	sound = "ambient/energy/spark1.wav",
	"ambient/energy/spark2.wav", "ambient/energy/spark3.wav", "ambient/energy/spark4.wav", "ambient/energy/spark5.wav", "ambient/energy/spark6.wav"
})

sound.Add({
	name = "zrush_sfx_deconnect_module",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 65,
	pitch = {80, 90},
	sound = "ambient/energy/zap1.wav",
	"ambient/energy/zap2.wav", "ambient/energy/zap3.wav", "ambient/energy/zap5.wav", "ambient/energy/zap6.wav", "ambient/energy/zap7.wav"
})
