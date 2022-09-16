zclib.NetEvent.AddDefinition("zrush_npc_anim", {
	[1] = {
		type = "entity"
	},
	[2] = {
		type = "string"
	},
	[3] = {
		type = "string"
	}
}, function(received)
	local ent = received[1]
	local anim01 = received[2]
	local anim02 = received[3]
	if not IsValid(ent) then return end
	if anim01 == nil then return end
	if anim02 == nil then return end
	zclib.Animation.PlayTransition(ent, anim01, 1, anim02, 1)
end)

zclib.NetEvent.AddDefinition("zrush_module_attached", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	zclib.Animation.Play(ent, "plugin", 1.3)

	timer.Simple(1, function()
		if IsValid(ent) then
			ent:EmitSound("zrush_sfx_connect_module")
		end
	end)
end)

zclib.NetEvent.AddDefinition("zrush_module_detached", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	ent:EmitSound("zrush_sfx_deconnect_module")
end)

zclib.NetEvent.AddDefinition("zrush_barrel_attached", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	zclib.Animation.Play(ent, "open", 1)
	ent:EmitSound("zrush_sfx_barrel")
end)

zclib.NetEvent.AddDefinition("zrush_barrel_detached", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	zclib.Animation.Play(ent, "close", 1)
	ent:EmitSound("zrush_sfx_barrel")
end)

zclib.NetEvent.AddDefinition("zrush_event_overheat", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	ent:EmitSound("zrush_sfx_overheat")
end)

zclib.NetEvent.AddDefinition("zrush_action_building", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	ent:EmitSound("zrush_sfx_build")
end)

zclib.NetEvent.AddDefinition("zrush_action_deconnect", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	ent:EmitSound("zrush_sfx_deconnect")
end)

zclib.NetEvent.AddDefinition("zrush_action_command", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	ent:EmitSound("zrush_sfx_command")
end)

zclib.NetEvent.AddDefinition("zrush_action_unjam", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	ent:EmitSound("zrush_sfx_unjam")
end)

zclib.NetEvent.AddDefinition("zrush_action_cooldown", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	ent:EmitSound("zrush_sfx_cooldown")
end)

zclib.NetEvent.AddDefinition("zrush_drill_cycle_complete", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	ent:EmitSound("zrush_sfx_drill_pipedone")
	zclib.Effect.ParticleEffectAttach("zrush_drillgas", PATTACH_POINT_FOLLOW, ent, 5)
	zclib.Effect.ParticleEffectAttach("zrush_drillgas", PATTACH_POINT_FOLLOW, ent, 6)
end)

zclib.NetEvent.AddDefinition("zrush_drill_anim_drilldown", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end

	local currentSpeed = ent:GetBoostValue("speed")
	local drillAnimSpeed = math.Clamp((1 / currentSpeed) * 2, 0, 5)
	zclib.Animation.Play(ent, "drilldown", drillAnimSpeed)
end)

zclib.NetEvent.AddDefinition("zrush_drill_anim_idle", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	zclib.Animation.Play(ent, "idle", 1)
end)

zclib.NetEvent.AddDefinition("zrush_drill_loadpipe", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	ent:EmitSound("zrush_sfx_drill_loadpipe")
end)

zclib.NetEvent.AddDefinition("zrush_drill_anim_jammed", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	zclib.Animation.Play(ent, "jammed", 3)
end)

zclib.NetEvent.AddDefinition("zrush_burner_anim_burn", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	zclib.Animation.Play(ent, "burn", 1)
end)

zclib.NetEvent.AddDefinition("zrush_burner_anim_idle", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	zclib.Animation.Play(ent, "idle", 1)
end)

zclib.NetEvent.AddDefinition("zrush_pump_anim_pumping", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	local pumpSpeed = ent:GetBoostValue("speed")
	local pumpAnimSpeed = math.Clamp(4 / pumpSpeed, 0, 10)
	zclib.Animation.Play(ent, "pump", pumpAnimSpeed)
end)

zclib.NetEvent.AddDefinition("zrush_pump_anim_idle", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	zclib.Animation.Play(ent, "idle", 1)
end)

zclib.NetEvent.AddDefinition("zrush_pump_anim_jammed", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	zclib.Animation.Play(ent, "jammed", 1.75)
end)

zclib.NetEvent.AddDefinition("zrush_pump_filloil", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	ent:EmitSound("zrush_sfx_liquidfill")
	zclib.Effect.ParticleEffectAttach("zrush_barrel_oil_fill", PATTACH_POINT_FOLLOW, ent, 5)
end)

zclib.NetEvent.AddDefinition("zrush_refinery_fillfuel", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	ent:EmitSound("zrush_sfx_liquidfill")
	zclib.Effect.ParticleEffectAttach("zrush_barrel_fuel_fill", PATTACH_POINT_FOLLOW, ent, 9)
end)

zclib.NetEvent.AddDefinition("zrush_npc_cash", {
	[1] = {
		type = "entity"
	}
}, function(received)
	local ent = received[1]
	if not IsValid(ent) then return end
	ent:EmitSound("zrush_sfx_cash01")
end)
