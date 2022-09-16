zgo2 = zgo2 or {}
zgo2.Mixer = zgo2.Mixer or {}

/*

	Bakes the dough

*/

function zgo2.Mixer.Initialize(Mixer)

	Mixer:DestroyShadow()

	timer.Simple(0.5, function()
		if IsValid(Mixer) then
			Mixer.m_Initialized = true
		end
	end)

	Mixer.LastWorkState = -1

	zclib.EntityTracker.Add(Mixer)
end

function zgo2.Mixer.Draw(Mixer)
	if not LocalPlayer().zgo2_Initialized then return end
	if not zclib.Convar.GetBool("zclib_cl_drawui") then return end
	if zclib.util.InDistance(Mixer:GetPos(), LocalPlayer():GetPos(), zgo2.util.RenderDistance_UI) == false then return end

	zgo2.Mixer.DrawScreenUI(Mixer)
end

function zgo2.Mixer.DrawScreenUI(Mixer)
	if Mixer:GetHasBowl() then

		if Mixer:GetHasDough() and Mixer.MixStart then

			local mix_duration = zgo2.Edible.GetMixDuration(Mixer:GetEdibleID())

			cam.Start3D2D(Mixer:LocalToWorld(Vector(-11, 11, 16)), Mixer:LocalToWorldAngles(Angle(0, 180, 90)), 0.08)
				zgo2.util.DrawBar(180, 20, zclib.Materials.Get("time"), zclib.colors[ "blue02" ], -90, -10, (1 / mix_duration) * (CurTime() - Mixer.MixStart))
			cam.End3D2D()
		end

		if Mixer:GetHasDough() == false then
			cam.Start3D2D(Mixer:LocalToWorld(Vector(-5, 12, 25)), Mixer:LocalToWorldAngles(Angle(0, 180, 90)), 0.1)
			draw.SimpleText(zgo2.language[ "Remove" ], zclib.GetFont("zclib_world_font_mediumsmall"), -10, 75, Mixer:OnRemoveButton(LocalPlayer()) and zgo2.colors[ "orange02" ] or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			cam.End3D2D()
		end
	end
end


function zgo2.Mixer.Think(Mixer)
	zclib.util.LoopedSound(Mixer, "zgo2_mixer_loop", Mixer.LastWorkState == 3)


	if not zclib.util.InDistance(LocalPlayer():GetPos(), Mixer:GetPos(), 500) then return end

	local _workstate = Mixer:GetWorkState()
	local _weedid = Mixer:GetWeedID()

	if zgo2.Plant.UpdateMaterials[ Mixer ] == nil then
		zgo2.Plant.UpdateMaterials[ Mixer ] = true
	end

	Mixer.OpenSmooth = Lerp(FrameTime() * 2, Mixer.OpenSmooth or 0, Mixer:GetHasBowl() and 0 or -30)
	Mixer:ManipulateBoneAngles(Mixer:LookupBone("head_jnt"), Angle(0, 0, Mixer.OpenSmooth))

	if _workstate == 3 then

		Mixer:ManipulateBoneAngles(Mixer:LookupBone("arm_jnt"), Angle(CurTime() * 180, 0, 0))
		Mixer:ManipulateBoneAngles(Mixer:LookupBone("hand_jnt"), Angle(CurTime() * -360, 0, 0))
		Mixer:ManipulateBoneAngles(Mixer:LookupBone("dough_rot_jnt"), Angle(CurTime() * -180, 0, 0))
		Mixer:ManipulateBonePosition(Mixer:LookupBone("dough_jnt"), Vector(0, 2 + (3 * math.sin(CurTime())), 0))

		if not Mixer.MixStart then
			Mixer.MixStart = CurTime()
		end

		local mixtime = CurTime() - Mixer.MixStart

		local scale = 1
		if _weedid ~= -1 then
			local mix_duration = zgo2.Edible.GetMixDuration(Mixer:GetEdibleID())
			local prog = (1 / mix_duration) * mixtime
			Mixer:SetColor(zclib.util.LerpColor(prog, color_white, zgo2.Plant.GetColor(_weedid)))

			scale = Lerp(prog, 1, 0)
			Mixer:ManipulateBoneScale(Mixer:LookupBone("weed_pos01_jnt"), Vector(scale, scale, scale))
			Mixer:ManipulateBoneScale(Mixer:LookupBone("weed_pos02_jnt"), Vector(scale, scale, scale))
		end

		Mixer:ManipulateBonePosition(Mixer:LookupBone("weed_pos01_jnt"), Vector(0, math.sin(CurTime()) * scale, 0))
		Mixer:ManipulateBonePosition(Mixer:LookupBone("weed_pos02_jnt"), Vector(0, -math.sin(CurTime()) * scale, 0))
	else
		Mixer.MixStart = nil
		Mixer:SetColor(color_white)
	end

	Mixer.LeverSmooth = Lerp(FrameTime(), Mixer.LeverSmooth or 0, _workstate == 3 and 6 or 0)
	Mixer:ManipulateBonePosition(Mixer:LookupBone("lever_jnt"), Vector(0, 0, Mixer.LeverSmooth))

	if Mixer.LastWorkState ~= _workstate then
		Mixer.LastWorkState = _workstate

		if _workstate == 1 then
			zclib.Sound.EmitFromEntity("zgo2_mixer_open", Mixer)
		elseif _workstate == 2 then
			zclib.Sound.EmitFromEntity("zgo2_mixer_close", Mixer)
		end
	end
end

function zgo2.Mixer.OnRemove(Mixer)
	Mixer:StopSound("zgo2_mixer_loop")
end
