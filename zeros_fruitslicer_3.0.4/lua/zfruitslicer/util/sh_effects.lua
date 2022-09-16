zclib.NetEvent.AddDefinition("zfs_shop_idle", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	zclib.Animation.Play(ent, "idle_turnedoff", 1)
end)

zclib.NetEvent.AddDefinition("zfs_mixer_close_to_idle", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	ent:EmitSound("zfs_sfx_ToogleMachine")
	zclib.Animation.PlayTransition(ent, "close", 1, "idle", 1)
end)

zclib.NetEvent.AddDefinition("zfs_mixer_open_to_idle", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	ent:EmitSound("zfs_sfx_ToogleMachine")
	zclib.Animation.PlayTransition(ent, "open", 1, "idle_open", 1)
end)

zclib.NetEvent.AddDefinition("zfs_shop_dessamble_to_idle", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	ent:EmitSound("zfs_sfx_item_select")
	zclib.Animation.PlayTransition(ent, "dessamble", 1, "idle_turnedoff", 1)
end, true)

zclib.NetEvent.AddDefinition("zfs_shop_assemble_to_idle", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	ent:EmitSound("zfs_sfx_item_select")
	zclib.Animation.PlayTransition(ent, "assemble", 1, "idle_turnedon", 1)
end, true)

zclib.NetEvent.AddDefinition("zfs_mixer_run", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	ent:EmitSound("zfs_sfx_startmixer")
	ent:EmitSound("zfs_sfx_mix")
	zclib.Animation.Play(ent, "mix", 2)
end)

zclib.NetEvent.AddDefinition("zfs_mixer_open", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	zclib.Animation.Play(ent, "open", 1)
end)

-- 248034310
zclib.NetEvent.AddDefinition("zfs_sweetner_fill", {
	[1] = {
		type = "entity"
	},
	[2] = {
		type = "string"
	}
}, function(received)
	local ent = received[1]
	local SweetType = received[2]
	if not IsValid(ent) then return end
	local effect

	if SweetType == "Coffe" then
		effect = "zfs_sweetener_coffee"
	elseif SweetType == "Milk" then
		effect = "zfs_sweetener_milk"
	elseif SweetType == "Chocolate" then
		effect = "zfs_sweetener_chocolate"
	end

	zclib.Effect.ParticleEffectAttach(effect, PATTACH_POINT_FOLLOW, ent, 1)
	zclib.Animation.PlayTransition(ent, "fill", 1, "idle", 1)
end)

zclib.NetEvent.AddDefinition("zfs_smoothie_sell", {
	[1] = {
		type = "vector"
	}
}, function(received)
	local pos = received[1]
	if pos == nil then return end
	zclib.Effect.ParticleEffect("zfs_sell_effect", pos, angle_zero, LocalPlayer())
	zclib.Sound.EmitFromPosition(pos, "cash")
end)

zclib.NetEvent.AddDefinition("zfs_fruit_prep", {
	[1] = {
		type = "entity"
	},
	[2] = {
		type = "uiint"
	}
}, function(received)
	local ent = received[1]
	local fruitID = received[2]
	if not IsValid(ent) then return end
	if fruitID == nil then return end
	local FruitData = zfs.Fruit.GetData(fruitID)

	if FruitData.CutEffect then
		zclib.Effect.ParticleEffect(FruitData.CutEffect, ent:GetPos(), angle_zero, ent)
	end

	if FruitData.CutSound then
		ent:EmitSound(FruitData.CutSound)
	end
end)

zclib.NetEvent.AddDefinition("zfs_fruit_finish", {
	[1] = {
		type = "entity"
	},
	[2] = {
		type = "uiint"
	}
}, function(received)
	local ent = received[1]
	local fruitID = received[2]
	if not IsValid(ent) then return end
	if fruitID == nil then return end
	local FruitData = zfs.Fruit.GetData(fruitID)

	if FruitData.CutFinishSound then
		ent:EmitSound(FruitData.CutFinishSound)
	end
end)

zclib.NetEvent.AddDefinition("zfs_slice_attack", {
	[1] = {
		type = "entity"
	},
	[2] = {
		type = "entity"
	},
	[3] = {
		type = "vector"
	}
}, function(received)
	local ent = received[1]
	local attacker = received[2]
	local pos = received[3]
	if not IsValid(ent) then return end
	if not IsValid(attacker) then return end
	if pos == nil then return end
	zclib.Sound.EmitFromEntity("throw", attacker)

	if ent:IsPlayer() or ent:IsNPC() then
		ent:EmitSound("zfs_sfx_melon")
		zclib.Effect.ParticleEffect("zfs_melon", pos, angle_zero, ent)
	else
		zclib.Effect.ParticleEffect("zmb_vgui_destroy", pos, angle_zero, ent)
	end
end)
