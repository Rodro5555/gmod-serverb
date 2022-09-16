zgo2 = zgo2 or {}
zgo2.Packer = zgo2.Packer or {}
zgo2.Packer.List = zgo2.Packer.List or {}

/*

	Packers are used to clip dried weedbranches in to single flowers

*/

function zgo2.Packer.Initialize(Packer)

	timer.Simple(1, function()
		if IsValid(Packer) then
			Packer.m_Initialized = true
		end
	end)
end

function zgo2.Packer.OnRemove(Packer)
	Packer:StopSound("zgo2_grind_empty")

	if IsValid(Packer.ActiveWeedBranch) then
		Packer.ActiveWeedBranch:Remove()
	end
end

/*
	Draw ui stuff
*/
local vec,ang = Vector(17.2,0,24.8),Angle(0,90,90)
function zgo2.Packer.OnDraw(Packer)
	if not zclib.Convar.GetBool("zclib_cl_drawui") then return end
	if zclib.util.InDistance(Packer:GetPos(), LocalPlayer():GetPos(), zgo2.util.RenderDistance_UI) == false then return end

	if Packer:GetPoseParameter("p_fill") >= 0.8 then
		cam.Start3D2D(Packer:LocalToWorld(vec), Packer:LocalToWorldAngles(ang), 0.1)
			local PlantData = zgo2.Plant.GetData(Packer:GetWeedID())
			if PlantData then
				zgo2.util.DrawBar(300,30,zclib.Materials.Get("zgo2_icon_weed"), zgo2.colors[ "green01" ],0, -45, math.Clamp((1 / zgo2.config.Packer.Capacity) * Packer:GetWeedAmount(),0,1))
				draw.SimpleText(PlantData.name, zclib.GetFont("zclib_world_font_mediumsmall"), 0,  -31,  color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			if Packer:GetProgress() <= 0 then
				local hover = Packer:OnDrop(LocalPlayer()) and zclib.colors[ "orange01" ] or color_white
				draw.RoundedBox(0, -100, 10, 200, 60, zclib.colors[ "black_a200" ])
				zclib.util.DrawOutlinedBox(-100, 10, 200, 60, 4, hover)
				draw.SimpleText(zgo2.language[ "Drop" ], zclib.GetFont("zclib_world_font_medium"), 0, 40, hover, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		cam.End3D2D()
	end
end

/*
	Adds the Packer to the list
*/
function zgo2.Packer.OnThink(Packer)
	if zgo2.Packer.List[Packer] == nil then
		zgo2.Packer.List[Packer] = true
	end

	if zgo2.Plant.UpdateMaterials[ Packer ] == nil then
		zgo2.Plant.UpdateMaterials[ Packer ] = true
	end

	Packer.SmoothFill = Lerp(FrameTime() * 15,Packer.SmoothFill or 0,Packer:GetWeedAmount() > 0 and 1 or 0)
	Packer:SetPoseParameter("p_fill",Packer.SmoothFill)

	Packer.SmoothClose = Lerp(FrameTime() * 2,Packer.SmoothClose or 0,Packer:GetWeedAmount() >= zgo2.config.Packer.Capacity and 1 or 0)
	Packer:SetPoseParameter("p_close",math.Clamp(Packer.SmoothClose,0,1))

	local prog = (1 / 100) * Packer:GetProgress()
	Packer.SmoothProg = Lerp(FrameTime() * 2,Packer.SmoothProg or 0,prog)
	Packer:SetPoseParameter("p_press",math.Clamp(Packer.SmoothProg,0,1))

	local LastProg = Packer.LastProg or 0
	local DiffProg = math.abs(Packer.SmoothProg - LastProg)

	zclib.util.LoopedSound(Packer, "zgo2_press_weed", DiffProg > 0.0001 and Packer:GetWeedAmount() > 0)

	if not Packer.NextProgCheck or (Packer.NextProgCheck > CurTime()) then
		Packer.LastProg = Packer.SmoothProg
		Packer.NextProgCheck = CurTime() + 0.2
	end
end
