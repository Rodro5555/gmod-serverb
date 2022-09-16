if not CLIENT then return end

// Effects
net.Receive("zfs_benefit_FX", function(len)

	local effect = net.ReadString()
	local ply = net.ReadEntity()
	local duration = net.ReadFloat()

	if effect and IsValid(ply) and duration then

		zclib.Effect.ParticleEffectAttach(effect, PATTACH_POINT_FOLLOW, ply, 0)

		timer.Simple(duration, function()
			if IsValid(ply) and effect and duration then
				ply:StopParticlesNamed(effect)
			end
		end)
	end
end)


// Screeneffects
local function StartScreenEffect(screeneffect,duration)

	local TimeLeft = duration

	local ply = LocalPlayer()

	zclib.Hook.Remove("RenderScreenspaceEffects","zfs_screeneffect")
	zclib.Hook.Add("RenderScreenspaceEffects", "zfs_screeneffect", function()

		if not IsValid(ply) or ply:Alive() == false then
			zclib.Hook.Remove("RenderScreenspaceEffects","zfs_screeneffect")
			return
		end

		TimeLeft = TimeLeft - (1 * FrameTime())
		if (TimeLeft or 0) > 0 then
			local alpha = math.Clamp((1 / 15) * TimeLeft,0,1)
			if (screeneffect == "MDMA") then
				DrawBloom(alpha * 0.3, alpha * 2, alpha * 8, alpha * 8, 15, 1, 1, 0.3, 0.7)
				DrawMotionBlur(0.1 * alpha, alpha, 0)
				DrawColorModify({
					["$pp_colour_colour"] = math.Clamp(1 * alpha, 1, 2),
					["$pp_colour_contrast"] = math.Clamp(1.2 * alpha, 1, 2),
					["$pp_colour_brightness"] = math.Clamp(-0.2 * alpha, 0, 1),
					["$pp_colour_addb"] = 0.3 * alpha,
					["$pp_colour_addr"] = 0.5 * alpha,
				})
			elseif (screeneffect == "CACTI") then
				DrawBloom(alpha * 0.3, alpha * 2, alpha * 8, alpha * 8, 15, 1, 1, 0, 0)
				DrawMotionBlur(0.2 * alpha, alpha * 2, 0)
				DrawSunbeams(25, 15, 15, 15, 15)
				DrawColorModify({
					["$pp_colour_colour"] = math.Clamp(1 * alpha, 1, 2),
					["$pp_colour_contrast"] = math.Clamp(1.3 * alpha, 1, 2),
					["$pp_colour_brightness"] = math.Clamp(-0.2 * alpha, 0, 1),
					["$pp_colour_addr"] = 0.4 * alpha,
					["$pp_colour_addg"] = 0.2 * alpha,
				})
			end
		else
			zclib.Hook.Remove("RenderScreenspaceEffects","zfs_screeneffect")
		end
	end)
end

net.Receive("zfs_benefit_screeneffect", function(len)

	local ScreenEffectName = net.ReadString()
	local duration = net.ReadFloat()

	if (duration and IsValid(LocalPlayer()) and ScreenEffectName) then
		StartScreenEffect(ScreenEffectName,duration)
	end
end)
