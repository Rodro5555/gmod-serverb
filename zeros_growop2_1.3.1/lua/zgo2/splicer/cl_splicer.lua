zgo2 = zgo2 or {}
zgo2.Splicer = zgo2.Splicer or {}
zgo2.Splicer.List = zgo2.Splicer.List or {}

/*

	Splicers are used to create new weedseeds from existing one

*/

function zgo2.Splicer.Initialize(Splicer)
	Splicer:DrawShadow(false)
	Splicer:DestroyShadow()

	timer.Simple(0.2, function()
		if IsValid(Splicer) then
			Splicer.m_Initialized = true
		end
	end)

	Splicer.DataSets = {}

	Splicer.ClientModels = {}
end

function zgo2.Splicer.OnRemove(Splicer)
	zgo2.Splicer.RemoveClientModels(Splicer)
	Splicer:StopSound("zgo2_Splicer_loop")
end

local vec01,ang01 = Vector(0,19.7,35.2),Angle(0,180,90)
function zgo2.Splicer.OnDraw(Splicer)
	if not zclib.Convar.GetBool("zclib_cl_drawui") then return end
	if zclib.util.InDistance(Splicer:GetPos(), LocalPlayer():GetPos(), zgo2.util.RenderDistance_UI) == false then return end
	if Splicer:GetSpliceStart() <= 0 then return end
	if Splicer.CapSmooth > -89 then return end
	cam.Start3D2D(Splicer:LocalToWorld(vec01), Splicer:LocalToWorldAngles(ang01), 0.05)
		zgo2.util.DrawBar(400,80,zclib.Materials.Get("zgo2_icon_splice"), zgo2.colors[ "violett01" ],0, -40, (1 / zgo2.config.Splicer.SpliceTime) * (CurTime() - Splicer:GetSpliceStart()))
		draw.SimpleText(zgo2.language["Splicing"] .. (Splicer.PointText or ""), zclib.GetFont("zclib_world_font_medium"), 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()

	if not Splicer.NextPointChange or CurTime() > Splicer.NextPointChange then
		Splicer.NextPointChange = CurTime() + 0.5

		Splicer.PointCount = (Splicer.PointCount or 0) + 1
		if Splicer.PointCount == 3 then
			Splicer.PointCount = 0
			Splicer.PointText = ""
		end

		zclib.Effect.ParticleEffect("zgo2_scan", Splicer:LocalToWorld(Vector(0, 1.8, 33.5)), Splicer:GetAngles(), Splicer)

		Splicer.PointText = (Splicer.PointText or "") .. "."
	end
end

local function AddWeedStick(PlantData)
	if not PlantData then return end
	local ent = ClientsideModel("models/zerochain/props_growop2/zgo2_weedstick.mdl")
	if not IsValid(ent) then return end
	ent:Spawn()

	// Disable normal leafs
	ent:SetBodygroup(4,1)

	// Enable shrunk leafs
	ent:SetBodygroup(6,1)
	ent:SetBodygroup(7,1)
	ent:SetBodygroup(8,1)

	// Creates / Updates the plants lua materials
	zgo2.Plant.UpdateMaterial(ent,PlantData,false,true)

	ent:SetModelScale(0.35)

	return ent
end

local function GetBonePos(ent, id)
	local pos, ang = ent:GetBonePosition(id)
	if pos == ent:GetPos() then
		local mat = ent:GetBoneMatrix(id)
		if mat then
			pos = mat:GetTranslation()
			ang = mat:GetAngles()
		end
	end

	pos = pos + ang:Up() * 2

	return pos, ang
end

function zgo2.Splicer.OnThink(Splicer)
	if not Splicer.m_Initialized then return end

	zgo2.Splicer.List[Splicer] = true

	local IsSplicing = Splicer:GetSpliceStart() > 0

	zclib.util.LoopedSound(Splicer, "zgo2_Splicer_loop", IsSplicing)

	if zclib.util.InDistance(Splicer:GetPos(), LocalPlayer():GetPos(), 300) then

		if IsSplicing then Splicer:ManipulateBoneAngles(Splicer:LookupBone("plate_jnt"),Angle(0,CurTime() * 5,0)) end

		Splicer.CapSmooth = Lerp(FrameTime() * 2,Splicer.CapSmooth or 0,IsSplicing and -90 or 0)
		Splicer:ManipulateBoneAngles(Splicer:LookupBone("door_jnt"),Angle(Splicer.CapSmooth,0,0))

		Splicer.ScannerSmooth = Lerp(FrameTime(),Splicer.ScannerSmooth or 0,IsSplicing and 0 or -19)
		Splicer:ManipulateBonePosition(Splicer:LookupBone("scanner_sticks_jnt"),Vector(0,0,Splicer.ScannerSmooth))

		// Close the chambers if we are splicing
		if not Splicer.ChamberSmoothPos then Splicer.ChamberSmoothPos = {} end
		for i = 1, 5 do

			if IsSplicing then
				Splicer.ChamberSmoothPos[i] =  Lerp(FrameTime(),Splicer.ChamberSmoothPos[i] or 0,8)
			else
				Splicer.ChamberSmoothPos[i] =  Lerp(FrameTime(),Splicer.ChamberSmoothPos[i] or 0,Splicer.DataSets[i] and 0 or 8)
			end
			Splicer:ManipulateBonePosition(Splicer:LookupBone("chamber0" .. i .. "_jnt"), Vector(Splicer.ChamberSmoothPos[i], 0, 0))
		end

		// Close the chambers doors if we got some weed dataq
		if not Splicer.ChamberSmoothAng then Splicer.ChamberSmoothAng = {} end
		for i = 1, 5 do
			if IsSplicing then
				Splicer.ChamberSmoothAng[i] =  Lerp(FrameTime(),Splicer.ChamberSmoothAng[i] or 0,0)
			else
				Splicer.ChamberSmoothAng[i] =  Lerp(FrameTime(),Splicer.ChamberSmoothAng[i] or 0,180)
			end
			Splicer:ManipulateBoneAngles(Splicer:LookupBone("chamber0" .. i .. "_door_rotate"), Angle(0, 0, Splicer.ChamberSmoothAng[ i ]))
		end

		if Splicer.ReceiveSplicerData then

			if not Splicer.ClientModels then Splicer.ClientModels = {} end

			for i = 1,zgo2.Splicer.ItemLimit do

				if Splicer.DataSets[i] then

					if not IsValid(Splicer.ClientModels[i]) then
						Splicer.ClientModels[i] = AddWeedStick(zgo2.Plant.GetData(Splicer.DataSets[i]))
					else
						local pos, ang = GetBonePos(Splicer, Splicer:LookupBone("chamber0" .. i .. "_jnt"))

						local ent = Splicer.ClientModels[i]
						ent:SetPos(pos)
						ent:SetAngles(ang)
					end
				else
					if IsValid(Splicer.ClientModels[i]) then
						Splicer.ClientModels[i]:Remove()
					end
				end
			end
		else

			// Ask the server about the current connected entities from this Splicer
			if (Splicer.NextDataRequest == nil or CurTime() > Splicer.NextDataRequest) then
				net.Start("zgo2.Splicer.Update")
				net.WriteEntity(Splicer)
				net.SendToServer()
				Splicer.NextDataRequest = CurTime() + 3
			end

			zgo2.Splicer.RemoveClientModels(Splicer)
		end

		Splicer:SetupBones()

		if Splicer:GetSpliceID() > 0 then
			local data = zgo2.Plant.GetData(Splicer:GetSpliceID())
			if data then
				if not Splicer.SplicedWeedStick then
					Splicer.SplicedWeedStick = ClientsideModel("models/zerochain/props_growop2/zgo2_weedseeds.mdl")
					Splicer.SplicedWeedStick:SetNoDraw(true)
					zgo2.Seed.UpdateMaterial(Splicer.SplicedWeedStick, data, false)
					zclib.Effect.ParticleEffect("zgo2_scan", Splicer:LocalToWorld(Vector(0, 1.8, 33.5)), Splicer:GetAngles(), Splicer)
				else
					local pos, ang = GetBonePos(Splicer, Splicer:LookupBone("plate_jnt"))
					if pos and ang then
						pos = pos + ang:Up() * 9
						Splicer.SplicedWeedStick:SetPos(pos)
					end
					if ang then
						ang:RotateAroundAxis(ang:Up(),-90)
						ang:RotateAroundAxis(ang:Forward(),-90)
						Splicer.SplicedWeedStick:SetAngles(ang)
					end
				end
			else
				if Splicer.SplicedWeedStick then
					Splicer.SplicedWeedStick:Remove()
					Splicer.SplicedWeedStick = nil
				end
			end
		else
			if Splicer.SplicedWeedStick then
				Splicer.SplicedWeedStick:Remove()
				Splicer.SplicedWeedStick = nil
			end
		end
	else
		Splicer.ReceiveSplicerData = nil
		zgo2.Splicer.RemoveClientModels(Splicer)

		if Splicer.SplicedWeedStick then
			Splicer.SplicedWeedStick:Remove()
			Splicer.SplicedWeedStick = nil
		end
	end
end

function zgo2.Splicer.RemoveClientModels(Splicer)
	if not Splicer.ClientModels then return end
	for i,v in pairs(Splicer.ClientModels) do
		if IsValid(v) then
			v:Remove()
		end
	end
	Splicer.ClientModels = nil
end

/*
	Gets called when the server sends the datasets to the player , either by itself or because of his request
*/
net.Receive("zgo2.Splicer.Update", function(len)
	zclib.Debug_Net("zgo2.Splicer.Update", len)

	local Splicer = net.ReadEntity()
	if not IsValid(Splicer) then return end
	if not Splicer:IsValid() then return end
	if Splicer:GetClass() ~= "zgo2_splicer" then return end

	Splicer.DataSets = {}
	local count = net.ReadUInt(8)
	for i = 1, count do Splicer.DataSets[ net.ReadUInt(8) ] = net.ReadString() end

	Splicer.ReceiveSplicerData = true

	zgo2.Splicer.RemoveClientModels(Splicer)
end)

function zgo2.Splicer.PostDraw()
	for Splicer,_ in pairs(zgo2.Splicer.List) do

        if not IsValid(Splicer) then
			continue
		end

		if not Splicer.m_Initialized then continue end

		if zclib.util.InDistance(Splicer:GetPos(), LocalPlayer():GetPos(), 300) == false then
			continue
		end

		if not Splicer.SplicedWeedStick then continue end

		//if Splicer.CapSmooth > -89 then continue end

		local progress = (1 / zgo2.config.Splicer.SpliceTime) * (CurTime() - Splicer:GetSpliceStart())

		// Everything "behind" this normal will be clipped
		local normal = Splicer:GetUp()
		local position = normal:Dot(Splicer:LocalToWorld(Vector(0, 0, Lerp(progress, 34, 48))))

		local oldEC = render.EnableClipping( true )
		render.PushCustomClipPlane( normal, position )

		local col = zgo2.colors[ "violett01" ]
		render.MaterialOverride(zclib.Materials.Get("highlight"))
		render.SetColorModulation(1 / 255 * col.r, 1 / 255 * col.g, 1 / 255 * col.b)
		Splicer.SplicedWeedStick:DrawModel()
		render.MaterialOverride()
		render.SetColorModulation(1, 1, 1)

		render.PopCustomClipPlane()
		render.EnableClipping( oldEC )
    end
end
zclib.Hook.Remove("PostDrawTranslucentRenderables", "zgo2_Splicer_postdraw")
zclib.Hook.Add("PostDrawTranslucentRenderables", "zgo2_Splicer_postdraw", function(bDrawingDepth, bDrawingSkybox, isDraw3DSkybox)
	if not isDraw3DSkybox then
		zgo2.Splicer.PostDraw()
	end
end)

function zgo2.Splicer.PreDraw()
	for Splicer,_ in pairs(zgo2.Splicer.List) do

        if not IsValid(Splicer) then
			continue
		end

		if not Splicer.m_Initialized then continue end

		if zclib.util.InDistance(Splicer:GetPos(), LocalPlayer():GetPos(), 300) == false then
			continue
		end

		if not Splicer.SplicedWeedStick then continue end

		//if Splicer.CapSmooth > -89 then continue end

		local progress = (1 / zgo2.config.Splicer.SpliceTime) * (CurTime() - Splicer:GetSpliceStart())

		local normal = -Splicer:GetUp()
		local position = normal:Dot(Splicer:LocalToWorld(Vector(0, 0, Lerp(progress, 34, 48))))
		local oldEC = render.EnableClipping( true )
		render.PushCustomClipPlane( normal, position )
		Splicer.SplicedWeedStick:DrawModel()
		render.PopCustomClipPlane()
		render.EnableClipping( oldEC )
    end
end
zclib.Hook.Remove("PreDrawTranslucentRenderables", "zgo2_Splicer_predraw")
zclib.Hook.Add("PreDrawTranslucentRenderables", "zgo2_Splicer_predraw", function(bDrawingDepth, bDrawingSkybox, isDraw3DSkybox)
	if not isDraw3DSkybox then
		zgo2.Splicer.PreDraw()
	end
end)
