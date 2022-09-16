zrmine = zrmine or {}
zrmine.f = zrmine.f or {}
zrmine.sounds = zrmine.sounds or {}

// This packs the requested sound Data
function zrmine.f.CatchSound(id)
	local soundData = {}
	local soundTable = zrmine.sounds[id]
	soundData.sound = soundTable.paths[math.random(#soundTable.paths)]
	soundData.lvl = soundTable.lvl
	soundData.pitch = math.Rand(soundTable.pitchMin, soundTable.pitchMax)
	local vol = 1

	if CLIENT then
		vol = GetConVar("zrms_cl_audiovolume"):GetFloat()
	end

	soundData.volume = vol * soundTable.pref_volume

	return soundData
end

function zrmine.f.EmitSoundENT(id, ent)
	if SERVER then
		// If this function got called on server then we make it be executed on client instead
		zrmine.f.CreateSoundEffect(id, ent)
	else
		local soundData = zrmine.f.CatchSound(id)

		EmitSound(soundData.sound, ent:GetPos(), ent:EntIndex(), CHAN_STATIC, soundData.volume, soundData.lvl, 0, soundData.pitch)
	end
end

function zrmine.f.EmitSoundPos(id, pos)
	zrmine.f.Debug("zrmine.f.EmitSoundPos: " .. id)

	local soundData = zrmine.f.CatchSound(id)
	if SERVER then
		sound.Play(soundData.sound, pos,  soundData.lvl, soundData.pitch, soundData.volume)
	else
		sound.Play(soundData.sound, pos,  soundData.lvl, soundData.pitch, soundData.volume)
	end
end

zrmine.sounds["zrmine_npc_wrongjob"] = {
	paths = {"vo/npc/male01/pardonme01.wav", "vo/npc/male01/pardonme02.wav"},
	lvl = SNDLVL_45dB,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}

zrmine.sounds["zrmine_npc_sell"] = {
	paths = {"vo/npc/male01/question02.wav", "vo/npc/male01/question03.wav", "vo/npc/male01/question04.wav", "vo/npc/male01/question05.wav", "vo/npc/male01/question06.wav", "vo/npc/male01/question09.wav", "vo/npc/male01/question10.wav", "vo/npc/male01/question13.wav", "vo/npc/male01/question16.wav", "vo/npc/male01/question17.wav", "vo/npc/male01/question18.wav", "vo/npc/male01/question19.wav", "vo/npc/male01/question23.wav", "vo/npc/male01/question25.wav", "vo/npc/male01/question27.wav", "vo/npc/male01/question28.wav", "vo/npc/male01/question29.wav", "vo/npc/male01/question30.wav"},
	lvl = SNDLVL_45dB,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}

zrmine.sounds["zrmine_pickaxeHit"] = {
	paths = {"physics/concrete/concrete_impact_hard1.wav", "physics/concrete/concrete_impact_hard2.wav", "physics/concrete/concrete_impact_hard3.wav", "physics/concrete/concrete_impact_soft1.wav", "physics/concrete/concrete_impact_soft2.wav", "physics/concrete/concrete_impact_soft3.wav"},
	lvl = SNDLVL_65dB,
	pitchMin = 80,
	pitchMax = 90,
	pref_volume = 1
}

zrmine.sounds["zrmine_addgravel"] = {
	paths = {"physics/concrete/concrete_impact_hard1.wav", "physics/concrete/concrete_impact_hard2.wav", "physics/concrete/concrete_impact_hard3.wav", "physics/concrete/concrete_impact_soft1.wav", "physics/concrete/concrete_impact_soft2.wav", "physics/concrete/concrete_impact_soft3.wav"},
	lvl = SNDLVL_65dB,
	pitchMin = 85,
	pitchMax = 90,
	pref_volume = 0.4
}

zrmine.sounds["zrmine_spawnresource"] = {
	paths = {"ambient/levels/streetwar/building_rubble1.wav", "ambient/levels/streetwar/building_rubble2.wav", "ambient/levels/streetwar/building_rubble3.wav", "ambient/levels/streetwar/building_rubble4.wav", "ambient/levels/streetwar/building_rubble5.wav"},
	lvl = SNDLVL_75dB,
	pitchMin = 85,
	pitchMax = 90,
	pref_volume = 1
}

sound.Add({
	name = "zrmine_minecratemove",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 75,
	pitch = {50, 60},
	sound = "ambient/machines/train_wheels_loop1.wav"
})

zrmine.sounds["zrmine_melter_move"] = {
	paths = {"doors/heavy_metal_move1.wav"},
	lvl = SNDLVL_60dB,
	pitchMin = 85,
	pitchMax = 90,
	pref_volume = 1
}

zrmine.sounds["zrmine_mine_door_move"] = {
	paths = {"doors/wood_move1.wav"},
	lvl = SNDLVL_75dB,
	pitchMin = 90,
	pitchMax = 100,
	pref_volume = 1
}

zrmine.sounds["zrmine_mine_door_stop"] = {
	paths = {"doors/wood_stop1.wav"},
	lvl = SNDLVL_75dB,
	pitchMin = 90,
	pitchMax = 100,
	pref_volume = 1
}

zrmine.sounds["zrmine_mine_cartup"] = {
	paths = {"plats/elevator_stop.wav"},
	lvl = SNDLVL_75dB,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}

sound.Add({
	name = "zrmine_sfx_conveyorbelt_move",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	pitch = {60, 75},
	sound = "zrms/belt_loop.wav"
})

sound.Add({
	name = "zrmine_sfx_melter_loop",
	channel = CHAN_STATIC,
	volume = 0.6,
	level = 65,
	pitch = {85, 90},
	sound = "zrms/melter_loop.wav"
})

sound.Add({
	name = "zrmine_sfx_meltercool_loop",
	channel = CHAN_STATIC,
	volume = 0.6,
	level = 65,
	pitch = {85, 90},
	sound = "zrms/molten_metal.wav"
})

// Generic
sound.Add({
	name = "zrmine_ui_click",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	pitch = {100, 100},
	sound = {"UI/buttonclick.wav"}
})

zrmine.sounds["zrmine_cash"] = {
	paths = {"zrms/zrms_cash01.wav"},
	lvl = SNDLVL_75dB,
	pitchMin = 100,
	pitchMax = 100,
	pref_volume = 1
}

zrmine.sounds["zrmine_connect_belt"] = {
	paths = {"zrms/connect_belt.wav"},
	lvl = SNDLVL_75dB,
	pitchMin = 65,
	pitchMax = 65,
	pref_volume = 1
}

zrmine.sounds["zrmine_connect_refinery"] = {
	paths = {"zrms/connect_refinery.wav"},
	lvl = SNDLVL_75dB,
	pitchMin = 65,
	pitchMax = 75,
	pref_volume = 1
}

sound.Add({
	name = "zrmine_sfx_refinery_loop",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	pitch = {60, 75},
	sound = "zrms/refinery_loop.wav"
})

zrmine.sounds["zrmine_addbar"] = {
	paths = {"physics/metal/metal_solid_impact_hard1.wav", "physics/metal/metal_solid_impact_hard4.wav", "physics/metal/metal_solid_impact_hard5.wav", "physics/metal/metal_solid_impact_soft1.wav", "physics/metal/metal_solid_impact_soft2.wav", "physics/metal/metal_solid_impact_soft3.wav"},
	lvl = SNDLVL_60dB,
	pitchMin = 85,
	pitchMax = 90,
	pref_volume = 1
}

zrmine.sounds["zrmine_placecrate"] = {
	paths = {"physics/plastic/plastic_box_impact_soft1.wav", "physics/plastic/plastic_box_impact_soft2.wav", "physics/plastic/plastic_box_impact_soft3.wav", "physics/plastic/plastic_box_impact_soft4.wav"},
	lvl = SNDLVL_60dB,
	pitchMin = 85,
	pitchMax = 90,
	pref_volume = 1
}

zrmine.sounds["zrmine_crate_break"] = {
	paths = {"physics/wood/wood_box_break1.wav", "physics/wood/wood_box_break2.wav"},
	lvl = SNDLVL_75dB,
	pitchMin = 85,
	pitchMax = 90,
	pref_volume = 1
}

zrmine.sounds["zrmine_crush_expo"] = {
	paths = {"physics/concrete/boulder_impact_hard1.wav", "physics/concrete/boulder_impact_hard2.wav", "physics/concrete/boulder_impact_hard3.wav", "physics/concrete/boulder_impact_hard4.wav"},
	lvl = SNDLVL_60dB,
	pitchMin = 85,
	pitchMax = 90,
	pref_volume = 1
}

zrmine.sounds["zrmine_crush"] = {
	paths = {"zrms/machine_crush.wav"},
	lvl = SNDLVL_60dB,
	pitchMin = 85,
	pitchMax = 90,
	pref_volume = 1
}

zrmine.sounds["zrmine_refinerdirt"] = {
	paths = {"ambient/machines/thumper_dust.wav"},
	lvl = SNDLVL_60dB,
	pitchMin = 95,
	pitchMax = 100,
	pref_volume = 1
}

zrmine.sounds["zrmine_resourcedespawn"] = {
	paths = {"physics/concrete/concrete_break2.wav", "physics/concrete/concrete_break3.wav"},
	lvl = SNDLVL_60dB,
	pitchMin = 95,
	pitchMax = 100,
	pref_volume = 1
}
