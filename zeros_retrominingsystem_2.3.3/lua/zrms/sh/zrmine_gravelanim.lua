zrmine = zrmine or {}
zrmine.f = zrmine.f or {}


function zrmine.f.Gravel_SetupDataTables(ent)
	ent:NetworkVar("Int", 9, "GravelAnim_Type")

	if (SERVER) then
		ent:SetGravelAnim_Type(-1)
	end
end

if CLIENT then

	// A table with diffrent local position for the gravel animation, depending on entity class
	local zrms_GravelPosOffset = {
		["zrms_crusher"] = Vector(-55,0,-1),
		["zrms_conveyorbelt_n"] = Vector(0,0,-1),
		["zrms_conveyorbelt_s"] = Vector(0,0,-1),
		["zrms_conveyorbelt_c_left"] = Vector(0,0,0),
		["zrms_conveyorbelt_c_right"] = Vector(0,0,0),
		["zrms_inserter"] = Vector(0,0,-1),

		["zrms_refiner_coal"] = Vector(-40,0,-1),
		["zrms_refiner_iron"] = Vector(0,0,-1),
		["zrms_refiner_bronze"] = Vector(0,0,-1),
		["zrms_refiner_silver"] = Vector(0,0,-1),
		["zrms_refiner_gold"] = Vector(0,0,-1),
	}

	function zrmine.f.Gravel_Initialize(ent)
		ent.a_cycle = 0
	end


	function zrmine.f.ClientGravelAnim(ent)
		if ent.ClientProps == nil then
			ent.ClientProps = {}
		end

		if zrmine.f.InDistance(LocalPlayer():GetPos(), ent:GetPos(), 1000) then

			if IsValid(ent.ClientProps["Gravel"]) then

				// The requested animation type aka skin
				local r_type = ent:GetGravelAnim_Type()

				if r_type == -1 then
					ent.ClientProps["Gravel"]:SetNoDraw(true)
					ent.a_cycle = 0
				else


					local speed = 2

					if ent:GetClass() == "zrms_crusher" then

						speed = zrmine.config.Crusher_Time / 2
					elseif string.sub(ent:GetClass(), 1, 12) == "zrms_refiner" then

						speed = 1.9
					else

						speed = ent.GravelAnimTime / ent.TransportSpeed
					end

					ent.a_cycle = math.Clamp(ent.a_cycle + (1 / speed) * FrameTime(), 0, 1)

					if ent.a_cycle >= 1 then

						ent.ClientProps["Gravel"]:SetNoDraw(true)
					else
						ent.ClientProps["Gravel"]:SetPos(ent:LocalToWorld(zrms_GravelPosOffset[ent:GetClass()]))
						ent.ClientProps["Gravel"]:SetSkin(r_type)
						ent.ClientProps["Gravel"]:SetNoDraw(false)

						local sequence = ent.ClientProps["Gravel"]:LookupSequence("output")
						ent.ClientProps["Gravel"]:SetSequence(sequence)
						ent.ClientProps["Gravel"]:SetPlaybackRate(1)
						ent.ClientProps["Gravel"]:SetCycle(ent.a_cycle)
					end
				end
			else
				zrmine.f.CreateClientGravel(ent)
			end
		else

			if IsValid(ent.ClientProps["Gravel"]) then
				ent.ClientProps["Gravel"]:Remove()
			end

			ent.a_cycle = 0
		end
	end

	function zrmine.f.CreateClientGravel(ent)
		local gravel = ents.CreateClientProp()

		gravel:SetPos(ent:LocalToWorld(zrms_GravelPosOffset[ent:GetClass()]))
		gravel:SetModel(ent.GravelModel)
		gravel:SetAngles(ent:GetAngles())

		gravel:Spawn()
		gravel:Activate()

		gravel:SetRenderMode(RENDERMODE_NORMAL)
		gravel:SetParent(ent)
		gravel:SetNoDraw(true)

		ent.ClientProps["Gravel"] = gravel
	end

	function zrmine.f.RemoveClientGravel(ent)
		if (ent.ClientProps and table.Count(ent.ClientProps) > 0) then
			for k, v in pairs(ent.ClientProps) do
				if IsValid(v) then
					v:Remove()
				end
			end
		end
	end
end
