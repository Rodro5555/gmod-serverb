zgo2 = zgo2 or {}
zgo2.Dryline = zgo2.Dryline or {}
zgo2.Dryline.List = zgo2.Dryline.List or {}

/*

	Drylines are used to dry weed, they are 2 anker points connected by a rope / line

*/

function zgo2.Dryline.Initialize(Dryline)
	Dryline:DrawShadow(false)
	Dryline:DestroyShadow()
	timer.Simple(1, function()
		if IsValid(Dryline) then
			Dryline.m_Initialized = true
		end
	end)
end

function zgo2.Dryline.OnRemove(Dryline)
	zgo2.Dryline.RemoveBranchModels(Dryline)

	if IsValid(Dryline.EndPointModel) then
		Dryline.EndPointModel:Remove()
	end
end

/*
	Adds the Dryline to the list
*/
function zgo2.Dryline.OnThink(Dryline)
	if zgo2.Dryline.List[Dryline] == nil then
		zgo2.Dryline.List[Dryline] = true
	end
end

net.Receive("zgo2.Dryline.StartPointer", function(len)
	zclib.Debug_Net("zgo2.Dryline.StartPointer", len)
	local Dryline = net.ReadEntity()
	local IsStartPoint = net.ReadBool()
	if not IsValid(Dryline) then return end

	zgo2.Dryline.StartPointer(Dryline,IsStartPoint)
end)

function zgo2.Dryline.StartPointer(Dryline,IsStartPoint)
	zclib.Debug("zgo2.Dryline.StartPointer")

	zclib.PointerSystem.Stop()

	zclib.PointerSystem.Data.Ignore = Dryline

	local title = IsStartPoint and zgo2.language["StartPoint"] or zgo2.language["EndPoint"]

	local function HitCheck()
		if not zclib.PointerSystem.Data.Pos then return end
		if zgo2.config.Dryline.WorldOnly and (zclib.PointerSystem.Data.HitEntity and not zclib.PointerSystem.Data.HitEntity:IsWorld()) then return end
		if not zclib.util.InDistance(IsStartPoint and Dryline:GetEndPoint() or Dryline:GetPos(), zclib.PointerSystem.Data.Pos, zgo2.config.Dryline.Distance) then return end
		return true
	end

	zclib.PointerSystem.Start(IsStartPoint and Dryline:GetEndPoint() or Dryline, function()
		-- OnInit
		zclib.PointerSystem.Data.MainColor = zclib.colors[ "green01" ]
		zclib.PointerSystem.Data.ActionName = title
		zclib.PointerSystem.Data.CancelName = zgo2.language["Cancel"]
	end, function()

		if not HitCheck() then
			zclib.vgui.PlaySound("common/warning.wav")
			return
		end

		-- OnLeftClick
		net.Start("zgo2.Dryline.SetPoint")
		net.WriteEntity(Dryline)
		net.WriteBool(IsStartPoint)
		net.SendToServer()
		zclib.PointerSystem.Stop()

	end, function()

		if HitCheck() then
			zclib.PointerSystem.Data.MainColor = zclib.colors[ "green01" ]
			zclib.PointerSystem.Data.ActionName = title .. "[ ".. zclib.Money.Display(zgo2.Dryline.GetCost(IsStartPoint and Dryline:GetEndPoint() or Dryline:GetPos(),zclib.PointerSystem.Data.Pos)) .." ]"
		else
			zclib.PointerSystem.Data.MainColor = zclib.colors[ "red01" ]
		end

		if IsValid(zclib.PointerSystem.Data.PreviewModel) then
			local ang = zclib.PointerSystem.Data.Ang
			//ang:RotateAroundAxis(ang:Right(),90)
			zclib.PointerSystem.Data.PreviewModel:SetAngles(ang)
			zclib.PointerSystem.Data.PreviewModel:SetColor(zclib.PointerSystem.Data.MainColor)
			zclib.PointerSystem.Data.PreviewModel:SetPos(zclib.PointerSystem.Data.Pos)
			zclib.PointerSystem.Data.PreviewModel:SetNoDraw(false)
			zclib.PointerSystem.Data.PreviewModel:SetModel("models/zerochain/props_growop2/zgo2_dryline.mdl")
		end
	end, nil, function()

	end)
end

/*
	Draw the rope
*/
local gravity = Vector(0, 0, -0.05)
local damping = 0.9
function zgo2.Dryline.PreDraw()
	for Dryline,_ in pairs(zgo2.Dryline.List) do

        if not IsValid(Dryline) then
			continue
		end

		if not Dryline.m_Initialized then continue end

		if zclib.util.InDistance(Dryline:GetPos(), LocalPlayer():GetPos(), zgo2.config.Dryline.Distance * 2) == false then
			zgo2.Dryline.RemoveBranchModels(Dryline)

			if IsValid(Dryline.EndPointModel) then
				Dryline.EndPointModel:Remove()
			end
			continue
		end

		zgo2.Dryline.Draw(Dryline)
    end
end
zclib.Hook.Remove("PostDrawOpaqueRenderables", "zgo2_Dryline_draw")
zclib.Hook.Add("PostDrawOpaqueRenderables", "zgo2_Dryline_draw", function() zgo2.Dryline.PreDraw() end)

function zgo2.Dryline.RemoveBranchModels(Dryline)
	if Dryline.WeedBranches then
		for k,v in pairs(Dryline.WeedBranches) do
			if v and v.ent then
				v.ent:Remove()
			end
		end
	end
end

local function GetBonePos(ent, boneid)
	local pos = ent:GetBonePosition(boneid)

	if pos == ent:GetPos() then
		local mat = ent:GetBoneMatrix(boneid)

		if mat then
			pos = mat:GetTranslation()
		end
	end

	return pos
end

/*
	Draw the cable and the weedbranches
*/
local rope_beam = Material("cable/new_cable_lit")
local rope_color = Color(135,105,83)
function zgo2.Dryline.Draw(Dryline)

	/*
	local min, max = Dryline:GetCollisionBounds()
	render.SetColorMaterial()
	render.DrawBox(Dryline:GetPos(), Dryline:GetWallAngle(), min, max, zclib.colors[ "zone_green01" ])
	*/

	if not IsValid(Dryline) then
		Dryline.LinePoints = nil
		return
	end

	local rope_boneid = Dryline:LookupBone("rope_point")
	local hook_boneid = Dryline:LookupBone("hook")

	local from = GetBonePos(Dryline, rope_boneid)
	local to = Dryline:GetEndPoint()
	if not to then
		Dryline.LinePoints = nil
		return
	end

	// If we have the clientmodel of the hook endpoint then use its rope_point instead
	if IsValid(Dryline.EndPointModel) then to = GetBonePos(Dryline.EndPointModel, rope_boneid) end

	if not to then return end

	// Be aligned with the wall
	Dryline:SetRenderAngles(Dryline:GetWallAngle())

	// Let the hook look at the end point on the Roll angle
	local LookAt = (from - to):Angle()
	Dryline:ManipulateBoneAngles(hook_boneid,Angle(0,0,-LookAt.p))

	// If the start or end point changed then we need to rebuild the linepoints
	if Dryline.LastEndPoint ~= Dryline:GetEndPoint() or Dryline.LastPos ~= Dryline:GetPos() then
		Dryline.LastEndPoint = Dryline:GetEndPoint()
		Dryline.LastPos = Dryline:GetPos()

		Dryline.BranchLimit = nil
		Dryline.LinePoints = nil
		zgo2.Dryline.RemoveBranchModels(Dryline)
	end

	local Length = zgo2.Dryline.GetBranchLimit(Dryline)

	// Create rope points
	if Dryline.LinePoints == nil then Dryline.LinePoints = zclib.Rope.Setup(Length, from) end

	local grav_redcuion = (1 / zgo2.config.Dryline.Distance) * math.Clamp(zgo2.config.Dryline.Distance - from:Distance(to),0,zgo2.config.Dryline.Distance)
	gravity = Vector(0, 0, -0.3 * grav_redcuion)

	// Updates the Rope points to move physicly
	if Dryline.LinePoints and table.Count(Dryline.LinePoints) > 0 then zclib.Rope.Update(Dryline.LinePoints, from, to, Length, gravity, damping) end

	// Draw the rope
	zclib.Rope.Draw(Dryline.LinePoints, from, to, Length, rope_beam, nil, rope_color,2)

	// Create EntPoint Hook model
	if not IsValid(Dryline.EndPointModel) then
		local ent = ClientsideModel("models/zerochain/props_growop2/zgo2_dryline.mdl")

		if IsValid(ent) then
			ent:Spawn()
			Dryline.EndPointModel = ent
		end
	else
		Dryline.EndPointModel:SetPos(Dryline:GetEndPoint())
		Dryline.EndPointModel:SetAngles(Dryline:GetWallEndAngle())

		if from.z < to.z then
			local LookAt = (to - from):Angle()
			Dryline.EndPointModel:ManipulateBoneAngles(hook_boneid,Angle(0,0,-LookAt.p))
		else
			Dryline.EndPointModel:ManipulateBoneAngles(hook_boneid,angle_zero)
		end
	end

	// Debug points
	//for k,v in pairs(Dryline.LinePoints) do debugoverlay.Sphere(v.position,1,0.01,Color( 0,255, 0 ),true) end

	// Position the weedbranches on the rope
	if not Dryline.WeedBranches then return end

	local index = 1
	for spot, data in pairs(Dryline.WeedBranches) do
		if not IsValid(data.ent) then
			local ent = ClientsideModel("models/zerochain/props_growop2/zgo2_weedstick.mdl")
			if not IsValid(ent) then continue end
			ent:Spawn()

			data.ent = ent

			// Creates / Updates the plants lua materials
			zgo2.Plant.UpdateMaterial(ent,zgo2.Plant.GetData(data.id),nil,data.ent.Dried)
		else
			if data.ent.RndRotation == nil then data.ent.RndRotation = math.random(360) end

			local wAng = Angle(math.sin(CurTime() + data.ent.RndRotation) * 2,data.ent.RndRotation + CurTime(),180 + (2 * math.sin(CurTime() + data.ent.RndRotation)))

			local pos = Dryline:GetPos()
			if Dryline.LinePoints[ spot ] and Dryline.LinePoints[ spot ].position then
				if spot == 1 then
					pos = Lerp(0.3,Dryline.LinePoints[ spot ].position,Dryline.LinePoints[ spot + 1 ].position) + wAng:Up() * 18
				elseif spot == Length then
					pos = Lerp(0.3,Dryline.LinePoints[ spot ].position,Dryline.LinePoints[ spot - 1 ].position) + wAng:Up() * 18
				else
					pos = Dryline.LinePoints[ spot ].position + wAng:Up() * 18
				end
			end
			data.ent:SetPos(pos)

			data.ent:SetAngles(wAng)

			if zgo2.Dryline.IsDried(Dryline,spot) and not data.ent.Dried then

				// Disable normal leafs
				data.ent:SetBodygroup(4,1)

				// Enable shrunk leafs
				data.ent:SetBodygroup(6,1)
				data.ent:SetBodygroup(7,1)
				data.ent:SetBodygroup(8,1)

				// Disable hair
				data.ent:SetBodygroup(3,1)

				zclib.Sound.EmitFromPosition(data.ent:GetPos(),"zgo2_plant_hang")

				data.ent.Dried = true

				zgo2.Plant.UpdateMaterial(ent,zgo2.Plant.GetData(data.id),nil,data.ent.Dried)
			end

			index = index + 1
		end
	end
end

/*
	Called from server to inform the client that the weedbranch count changed
*/
net.Receive("zgo2.Dryline.Update", function(len)
	zclib.Debug_Net("zgo2.Dryline.Update", len)
	local Dryline = net.ReadEntity()
	if not IsValid(Dryline) then return end

	zgo2.Dryline.RemoveBranchModels(Dryline)

	Dryline.WeedBranches = {}
	for i = 1, net.ReadUInt(20) do
		Dryline.WeedBranches[ net.ReadUInt(20) ] = {
			id = net.ReadUInt(20),
			amount = net.ReadUInt(20),
			time = net.ReadUInt(32)
		}
	end
end)

/*
	Draw the progress bar
*/
local offset = Vector(0,0,24)
zclib.Hook.Remove("HUDPaint", "zgo2_Dryline_draw")
zclib.Hook.Add("HUDPaint", "zgo2_Dryline_draw", function()
	for Dryline,_ in pairs(zgo2.Dryline.List) do

		if not Dryline.WeedBranches then continue end
		if not zclib.Convar.GetBool("zclib_cl_drawui") then continue end

		for spot, data in pairs(Dryline.WeedBranches) do
			if not IsValid(data.ent) then continue end
			local pos = data.ent:GetPos() + offset

			if zclib.util.InDistance(pos, LocalPlayer():GetPos(), 200) then

				local data2D = pos:ToScreen()
				local dur = zgo2.Dryline.GetTime(Dryline, spot)
				local prog = math.Clamp((1 / dur) * (CurTime() - data.time),0,1)

				if prog < 1 then
					cam.Start2D()
						zgo2.util.DrawBar(100 * zclib.wM, 20 * zclib.hM, zclib.Materials.Get("time"), zclib.colors[ "green01" ], data2D.x, data2D.y, prog)
					cam.End2D()
				end
			end
		end
	end
end)
