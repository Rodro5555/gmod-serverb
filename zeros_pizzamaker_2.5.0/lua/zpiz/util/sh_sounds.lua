sound.Add({
	name = "zpiz_sfx_ovenbake",
	channel = CHAN_STATIC,
	volume = 0.6,
	level = 65,
	pitch = {80, 90},
	sound = "zpizmak/oven_sfx.wav"
})

sound.Add({
	name = "zpiz_sfx_ovendone",
	channel = CHAN_STATIC,
	volume = 1,
	level = 80,
	pitch = {90, 90},
	sound = "zpizmak/kitchentimer_ding.wav"
})

sound.Add({
	name = "zpiz_eat",
	channel = CHAN_STATIC,
	volume = 1,
	level = 80,
	pitch = {90, 90},
	sound = {"zpizmak/eat02.wav", "zpizmak/eat02.wav", "zpizmak/eat03.wav"}
})
