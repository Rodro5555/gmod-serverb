zcm = zcm or {}
zcm.f = zcm.f or {}

zcm.Sounds = {
	["zcm_sell"] = Sound("zcm/zcm_cash01.wav"),
	["zcm_explode"] = {
		Sound("weapons/explode3.wav"),
		Sound("weapons/explode4.wav"),
		Sound("weapons/explode5.wav")
	},
	["zcm_explode01"] = {
		Sound("zcm/zcm_explode01.wav"),
		Sound("zcm/zcm_explode02.wav"),
	},
	["zcm_crackerexplode"] = {
		Sound("zcm/zcm_cracker01.wav"),
		Sound("zcm/zcm_cracker02.wav"),
		Sound("zcm/zcm_cracker03.wav"),
		Sound("zcm/zcm_cracker04.wav"),
		Sound("zcm/zcm_cracker05.wav"),
	},
}


// Generic
sound.Add({
	name = "zcm_ui_click",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	pitch = {100, 100},
	sound = {"UI/buttonclick.wav"}
})

sound.Add({
    name = "zcm_sell",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_75dB,
    pitch = {100, 100},
    sound = {"zcm/zcm_cash01.wav"}
})


sound.Add({
    name = "zcm_paperroller",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_75dB,
    pitch = {100, 100},
    sound = {"zcm/zcm_paperroller.wav"}
})

sound.Add({
    name = "zcm_box_close",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_75dB,
    pitch = {100, 100},
    sound = {"zcm/zcm_boxclose.wav"}
})

sound.Add({
    name = "zcm_rollmover",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_75dB,
    pitch = {100, 100},
    sound = {"zcm/zcm_rollmover.wav"}
})

sound.Add({
    name = "zcm_cutter",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_75dB,
    pitch = {100, 100},
    sound = {"zcm/zcm_cutter.wav"}
})

sound.Add({
    name = "zcm_rollrelease",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_75dB,
    pitch = {100, 100},
    sound = {"zcm/zcm_rollrelease.wav"}
})

sound.Add({
    name = "zcm_rollpacker",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_75dB,
    pitch = {100, 100},
    sound = {"zcm/zcm_rollpacker.wav"}
})

sound.Add({
    name = "zcm_binder",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_75dB,
    pitch = {100, 100},
    sound = {"zcm/zcm_binder.wav"}
})

sound.Add({
    name = "zcm_powderfiller",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_75dB,
    pitch = {100, 100},
    sound = {"zcm/zcm_powderfiller.wav"}
})

sound.Add({
    name = "zcm_fuse",
    channel = CHAN_STATIC,
    volume = 1,
    level = SNDLVL_75dB,
    pitch = {100, 100},
    sound = {"zcm/zcm_fuse.wav"}
})
