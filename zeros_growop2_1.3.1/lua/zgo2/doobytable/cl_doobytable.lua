zgo2 = zgo2 or {}
zgo2.DoobyTable = zgo2.DoobyTable or {}

function zgo2.DoobyTable.Initialize(DoobyTable)
	zclib.EntityTracker.Add(DoobyTable)

	DoobyTable.DoobyProgress = false
	DoobyTable.LastWeedAmount = -1

	timer.Simple(0.5, function()
		if IsValid(DoobyTable) then
			DoobyTable.m_Initialized = true
		end
	end)
end

function zgo2.DoobyTable.Draw(DoobyTable)
	DoobyTable:DrawModel()

	if not LocalPlayer().zgo2_Initialized then return end
	if not zclib.Convar.GetBool("zclib_cl_drawui") then return end
	if zclib.util.InDistance(DoobyTable:GetPos(), LocalPlayer():GetPos(), zgo2.util.RenderDistance_UI) == false then return end

	zgo2.DoobyTable.DrawScreenUI(DoobyTable)
end

function zgo2.DoobyTable.Think(DoobyTable)

	if zgo2.Plant.UpdateMaterials[ DoobyTable ] == nil then
		zgo2.Plant.UpdateMaterials[ DoobyTable ] = true
	end

	if zclib.util.InDistance(DoobyTable:GetPos(), LocalPlayer():GetPos(), 1000) then

		// Update Weed Amount and Skin
		local _weedamount = DoobyTable:GetWeedAmount()
		if DoobyTable.LastWeedAmount ~= _weedamount then
			DoobyTable.LastWeedAmount = _weedamount

			local fraction = zgo2.config.DoobyTable.Capacity / 3
			if _weedamount <= 0 then

				// No Weed
				DoobyTable:SetBodygroup(5,0)
			elseif _weedamount < fraction then

				// Less Weed
				DoobyTable:SetBodygroup(5,1)
			elseif _weedamount < fraction * 2 then

				// Half Weed
				DoobyTable:SetBodygroup(5,2)
			elseif _weedamount > fraction * 2 then

				// Full Weed
				DoobyTable:SetBodygroup(5,3)
			end
		end

		local _progress = DoobyTable:GetDoobyProgress()
		if DoobyTable.DoobyProgress ~= _progress then
			DoobyTable.DoobyProgress = _progress



			if DoobyTable.DoobyProgress == 0 then

				// Disable Dooby
				DoobyTable:SetBodygroup(3,0)

				// Paper Close
				DoobyTable:SetBodygroup(2,0)
				zclib.Sound.EmitFromEntity("zgo2_paper_close", DoobyTable)

				// Grinder Close
				DoobyTable:SetBodygroup(1,0)
				zclib.Sound.EmitFromEntity("zgo2_grinder_close", DoobyTable)

			elseif DoobyTable.DoobyProgress == 1 then

				// Grinder Open
				DoobyTable:SetBodygroup(1,1)
				zclib.Sound.EmitFromEntity("zgo2_grinder_open", DoobyTable)

				// WeedJunk On
				DoobyTable:SetBodygroup(6,1)
				zclib.Sound.EmitFromEntity("zgo2_grab_weed", DoobyTable)

			elseif DoobyTable.DoobyProgress >= 1 and  DoobyTable.DoobyProgress < 5 then

				// Play Grind Animation
				zclib.Animation.Play(DoobyTable, "grind", 2)

				// Grinder Close
				if DoobyTable:GetBodygroup(1) == 1 then
					DoobyTable:SetBodygroup(1,0)
					zclib.Sound.EmitFromEntity("zgo2_grinder_close", DoobyTable)
				end

				// WeedJunk Off
				DoobyTable:SetBodygroup(6,0)
				zclib.Sound.EmitFromEntity("zgo2_grinder_grind", DoobyTable)

			elseif DoobyTable.DoobyProgress == 5 then

				// Grinded Weed On
				DoobyTable:SetBodygroup(6,2)

				// Grinder Open
				DoobyTable:SetBodygroup(1,1)
				zclib.Sound.EmitFromEntity("zgo2_grinder_open", DoobyTable)

			elseif DoobyTable.DoobyProgress == 6 then

				// Paper Open
				DoobyTable:SetBodygroup(2,1)
				zclib.Sound.EmitFromEntity("zgo2_paper_open", DoobyTable)

				// Paper Placed
				DoobyTable:SetBodygroup(0,1)
				zclib.Sound.EmitFromEntity("zgo2_grab_paper", DoobyTable)

			elseif DoobyTable.DoobyProgress == 7 then

				// Grinded Weed Off
				DoobyTable:SetBodygroup(6,0)

				// Added Weed On Paper
				DoobyTable:SetBodygroup(0,2)
				zclib.Sound.EmitFromEntity("zgo2_grab_weed", DoobyTable)

			elseif DoobyTable.DoobyProgress == 8 then

				// Roll Stage 01
				DoobyTable:SetBodygroup(0,3)
				zclib.Sound.EmitFromEntity("zgo2_joint_foldstage", DoobyTable)

			elseif DoobyTable.DoobyProgress == 9 then

				// Roll Stage 02
				DoobyTable:SetBodygroup(0,4)
				zclib.Sound.EmitFromEntity("zgo2_joint_foldstage", DoobyTable)

			elseif DoobyTable.DoobyProgress == 10 then

				// Roll Stage 03
				DoobyTable:SetBodygroup(0,5)
				zclib.Sound.EmitFromEntity("zgo2_joint_foldstage", DoobyTable)

			elseif DoobyTable.DoobyProgress == 11 then

				// Remove Roll Stage
				DoobyTable:SetBodygroup(0,0)

				// Enable Finished Dooby
				DoobyTable:SetBodygroup(3,1)

				// Play Grind Animation
				zclib.Animation.Play(DoobyTable, "roll", 2)
				zclib.Sound.EmitFromEntity("zgo2_joint_fold_finish", DoobyTable)
			end
		end
	else
		DoobyTable.DoobyProgress = -1
	end
end

local function DrawTextButton(txt,x,y,hover)
	draw.SimpleText(txt, zclib.GetFont("zclib_world_font_mediumsmall"), x, y, hover and zclib.colors[ "orange01" ] or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end

function zgo2.DoobyTable.DrawScreenUI(DoobyTable)

	if DoobyTable.LastWeedAmount > 0 then
		cam.Start3D2D(DoobyTable:LocalToWorld(Vector(2, 17, 17)), Angle(0, EyeAngles().y - 90, -EyeAngles().x + 90), 0.1)
			draw.SimpleText(zgo2.Plant.GetName(DoobyTable:GetWeedID()), zclib.GetFont("zclib_world_font_mediumsmall"), 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText(math.Round(DoobyTable.LastWeedAmount) .. zgo2.config.UoM, zclib.GetFont("zclib_world_font_small"), 0, 35, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		cam.End3D2D()
	end

	cam.Start3D2D(DoobyTable:LocalToWorld(Vector(0, 0, 5)), DoobyTable:LocalToWorldAngles(Angle(0, -90, 0)), 0.1)

		if DoobyTable.DoobyProgress == 0 and DoobyTable:GetWeedAmount() >= zgo2.config.DoobyTable.WeedPerJoint then

			DrawTextButton(zgo2.language[ "Start" ],-170, 55,DoobyTable:OnStartButton(LocalPlayer()))

			DrawTextButton(zgo2.language[ "Remove" ],-170, 25,DoobyTable:OnRemoveButton(LocalPlayer()))

		elseif DoobyTable.DoobyProgress >= 1 and DoobyTable.DoobyProgress < 5 then

			DrawTextButton("[E]", 170, 40, DoobyTable:OnGrinder(LocalPlayer()))

		elseif DoobyTable.DoobyProgress == 5 then

			DrawTextButton("[E]",0, -30,DoobyTable:OnPaper(LocalPlayer()))

		elseif DoobyTable.DoobyProgress == 6 then

			DrawTextButton("[E]", 170, 40, DoobyTable:OnGrinder(LocalPlayer()))
		end
	cam.End3D2D()

	if DoobyTable.DoobyProgress >= 7 and DoobyTable.DoobyProgress < 11 then

		local pos = DoobyTable:GetGamePos()
		cam.Start3D2D(DoobyTable:LocalToWorld(Vector(pos.x, pos.y, 6)), DoobyTable:LocalToWorldAngles(Angle(0, -90, 0)), 0.1)
			DrawTextButton("[E]",0, -10,DoobyTable:OnHitButton(LocalPlayer()))
		cam.End3D2D()
	end
end
