zgo2 = zgo2 or {}
zgo2.Clipper = zgo2.Clipper or {}
zgo2.Clipper.List = zgo2.Clipper.List or {}

/*

	Clippers are used to clip dried weedbranches in to single flowers

*/

function zgo2.Clipper.Initialize(Clipper)

	timer.Simple(1, function()
		if IsValid(Clipper) then
			Clipper.m_Initialized = true
		end
	end)
end

function zgo2.Clipper.OnRemove(Clipper)
	Clipper:StopSound("zgo2_grind_empty")
	Clipper:StopSound("zgo2_grind_weed")

	if IsValid(Clipper.ActiveWeedBranch) then
		Clipper.ActiveWeedBranch:Remove()
	end

	if Clipper.LeafEmitter and Clipper.LeafEmitter:IsValid() then
		Clipper.LeafEmitter:Finish()
		Clipper.LeafEmitter = nil
	end
end

/*
	Draw ui stuff
*/
local vec,ang = Vector(-7.8,0,40.5),Angle(0,-90,90)
local vec01,ang01 = Vector(5.6,-28.2,6),Angle(0,0,90)
local vec02,ang02 = Vector(4.2,-15,31.7),Angle(0,0,90)
function zgo2.Clipper.OnDraw(Clipper)

	if zclib.Convar.GetBool("zclib_cl_drawui") then
		cam.Start3D2D(Clipper:LocalToWorld(vec), Clipper:LocalToWorldAngles(ang), 0.05)
			zgo2.util.DrawBar(370,25,zclib.Materials.Get("zgo2_icon_weed"), zclib.colors[ "orange01" ],0, 50, (1 / 100) * Clipper:GetProgress())
		cam.End3D2D()

		// Draw some power indicator
		if Clipper:GetPower() > 0 then
			cam.Start3D2D(Clipper:LocalToWorld(vec01), Clipper:LocalToWorldAngles(ang01), 0.05)
				zgo2.util.DrawBar(250,50,zclib.Materials.Get("zgo2_icon_power"), zclib.colors[ "orange01" ],0, 0, (1 / zgo2.config.Battery.Power) * Clipper:GetPower())
			cam.End3D2D()
		end

		// Draw some motor switch indicator
		if Clipper:GetHasMotor() then
			local w, h = 100, 100
			cam.Start3D2D(Clipper:LocalToWorld(vec02), Clipper:LocalToWorldAngles(ang02), 0.05)

				draw.RoundedBox(h/2, -w / 2, -h / 2, w, h, Clipper:GetMotorSwitch() and zclib.colors["orange01"] or zclib.colors["blue02"])
				surface.SetDrawColor(zclib.colors[ "white_a100" ])
				surface.SetMaterial(zclib.Materials.Get("switch"))
				surface.DrawTexturedRectRotated(0, 0, w, h, 0)

				if Clipper:OnMotorSwitch(LocalPlayer()) then
					draw.RoundedBox(h / 2, -w / 2, -h / 2, w, h, zclib.colors[ "white_a100" ])
				end
			cam.End3D2D()
		end
	end

	zclib.util.LoopedSound(Clipper, "zgo2_grind_empty", (Clipper.SpinSpeed or 0) > 0.02)
	zclib.util.LoopedSound(Clipper, "zgo2_grind_weed", (Clipper.SpinSpeed or 0) > 0.3 and Clipper:GetWeedID() > 0)

	if Clipper:GetSpin() then
		Clipper.SpinSpeed = math.Clamp(math.Round(Lerp(FrameTime() * 0.8, Clipper.SpinSpeed or 0, 1),5), 0, 1)

		if Clipper.FadeIn == nil then
			Clipper.FadeIn = true

			if Clipper.Sounds[ "zgo2_grind_empty" ] then
				Clipper.Sounds[ "zgo2_grind_empty" ]:ChangePitch(70, 0)
				Clipper.Sounds[ "zgo2_grind_empty" ]:ChangePitch(100, 1.5)
				Clipper.Sounds[ "zgo2_grind_empty" ]:ChangeVolume(0, 0)
				Clipper.Sounds[ "zgo2_grind_empty" ]:ChangeVolume(1, 0.5)
			end

			if Clipper.Sounds[ "zgo2_grind_weed" ] then
				Clipper.Sounds[ "zgo2_grind_weed" ]:ChangePitch(70, 0)
				Clipper.Sounds[ "zgo2_grind_weed" ]:ChangePitch(100, 1.5)
				Clipper.Sounds[ "zgo2_grind_weed" ]:ChangeVolume(0, 0)
				Clipper.Sounds[ "zgo2_grind_weed" ]:ChangeVolume(1, 0.5)
			end
		end
	else
		Clipper.SpinSpeed = math.Clamp(math.Round(Lerp(FrameTime() * 0.8, Clipper.SpinSpeed or 0, 0),5), 0, 1)

		if Clipper.FadeIn then
			Clipper.FadeIn = nil

			if Clipper.Sounds[ "zgo2_grind_empty" ] then
				Clipper.Sounds[ "zgo2_grind_empty" ]:ChangePitch(100, 0)
				Clipper.Sounds[ "zgo2_grind_empty" ]:ChangePitch(70, 1.5)
				Clipper.Sounds[ "zgo2_grind_empty" ]:ChangeVolume(1, 0)
				Clipper.Sounds[ "zgo2_grind_empty" ]:ChangeVolume(0, 1.5)
			end

			if Clipper.Sounds[ "zgo2_grind_weed" ] then
				Clipper.Sounds[ "zgo2_grind_weed" ]:ChangePitch(100, 0)
				Clipper.Sounds[ "zgo2_grind_weed" ]:ChangePitch(70, 1.5)
				Clipper.Sounds[ "zgo2_grind_weed" ]:ChangeVolume(1, 0)
				Clipper.Sounds[ "zgo2_grind_weed" ]:ChangeVolume(0, 1.5)
			end
		end
	end

	if Clipper.SpinSpeed > 0.01 then
		Clipper.SwenkRotation = (Clipper.SwenkRotation or 0) + (Clipper.SpinSpeed * 0.5)
		Clipper:ManipulateBoneAngles(Clipper:LookupBone("roll01_jnt"), Angle(0, 0, Clipper.SwenkRotation))
		Clipper:ManipulateBoneAngles(Clipper:LookupBone("roll02_jnt"), Angle(0, 0, Clipper.SwenkRotation))
		Clipper:ManipulateBoneAngles(Clipper:LookupBone("roll03_jnt"), Angle(0, 0, -Clipper.SwenkRotation))
		Clipper:ManipulateBoneAngles(Clipper:LookupBone("roll04_jnt"), Angle(0, 0, -Clipper.SwenkRotation))
	end


	if (Clipper.NextProgressCheck == nil or CurTime() > Clipper.NextProgressCheck) then
		Clipper.IsProgressing = (Clipper.LastProgress or 0) ~= Clipper:GetProgress()
		Clipper.LastProgress = Clipper:GetProgress()
		Clipper.NextProgressCheck = CurTime() + 1
	end

	// Emit weed leaf effect
	zgo2.Clipper.LeafEmitter(Clipper,Clipper.IsProgressing )
end

/*
	Adds the Clipper to the list
*/
function zgo2.Clipper.OnThink(Clipper)
	if zgo2.Clipper.List[Clipper] == nil then
		zgo2.Clipper.List[Clipper] = true
	end

	if zgo2.Plant.UpdateMaterials[ Clipper ] == nil then
		zgo2.Plant.UpdateMaterials[ Clipper ] = true
	end
end

function zgo2.Clipper.PreDraw()
	for Clipper,_ in pairs(zgo2.Clipper.List) do

        if not IsValid(Clipper) then
			continue
		end

		if not Clipper.m_Initialized then continue end

		if zclib.util.InDistance(Clipper:GetPos(), LocalPlayer():GetPos(), 300) == false then
			if IsValid(Clipper.ActiveWeedBranch) then
				Clipper.ActiveWeedBranch:Remove()
			end
			continue
		end

		zgo2.Clipper.Draw(Clipper)
    end
end
zclib.Hook.Remove("PreDrawOpaqueRenderables", "zgo2_Clipper_draw")
zclib.Hook.Add("PreDrawOpaqueRenderables", "zgo2_Clipper_draw", function(bDrawingDepth, bDrawingSkybox, isDraw3DSkybox)
	if not isDraw3DSkybox then
		zgo2.Clipper.PreDraw()
	end
end)

/*
	Draw the weedbranche
*/
local function AddWeedStick(PlantData)
	local ent = ClientsideModel("models/zerochain/props_growop2/zgo2_weedstick.mdl")
	if not IsValid(ent) then return end
	ent:Spawn()

	// Disable normal leafs
	ent:SetBodygroup(4,1)

	// Enable shrunk leafs
	ent:SetBodygroup(6,1)
	ent:SetBodygroup(7,1)
	ent:SetBodygroup(8,1)

	// Disable hair
	//ent:SetBodygroup(3,1)

	ent:SetNoDraw(true)

	// Creates / Updates the plants lua materials
	zgo2.Plant.UpdateMaterial(ent,PlantData,false,true)

	ent.RndRotation = math.random(8)
	ent.RndSpin = math.random(360)

	return ent
end

local offset = Vector(0,0,38)
function zgo2.Clipper.Draw(Clipper)

	local PlantData = zgo2.Plant.GetData(Clipper:GetWeedID())
	if not PlantData then

		if IsValid(Clipper.ActiveWeedBranch) then
			Clipper.ActiveWeedBranch:Remove()
		end

		if not Clipper.WeedBranches then return end
		for i,v in ipairs(Clipper.WeedBranches) do
			if IsValid(Clipper.WeedBranches[i]) then
				Clipper.WeedBranches[i]:Remove()
			end
		end
		Clipper.WeedBranches = nil
		return
	end

	if Clipper.WeedBranches == nil then Clipper.WeedBranches = {} end

	local count = Clipper:GetStickCount() - 1

	Clipper.SmoothProgress = Lerp(FrameTime() * 6,Clipper.SmoothProgress or 0,(1 / 100) * Clipper:GetProgress())

	if Clipper:GetProgress() == 0 and Clipper.SmoothProgress ~= 0 then
		Clipper.SmoothProgress = 0

		if IsValid(Clipper.ActiveWeedBranch) then zgo2.Plant.UpdateMaterial(Clipper.ActiveWeedBranch,PlantData,false,true) end
	end

	// Everything "behind" this normal will be clipped
	local normal = Clipper:GetUp()
	local position = normal:Dot( Clipper:LocalToWorld(offset) )

	local oldEC = render.EnableClipping( true )
	render.PushCustomClipPlane( normal, position )

	if not IsValid(Clipper.ActiveWeedBranch) then
		Clipper.ActiveWeedBranch = AddWeedStick(PlantData)
	else
		local ent = Clipper.ActiveWeedBranch
		local fract = 1 - Clipper.SmoothProgress
		ent:SetPos(Clipper:LocalToWorld(Vector(3, 0, 15 + 40 * fract)))

		if Clipper.SpinSpeed and ent.RndRotation then
			local wAng = Angle(0, (Clipper.SpinSpeed or 0) > 0.1 and (CurTime() * 90) or 0, 10 * math.sin((CurTime() + (ent.RndRotation or 0)) * ((Clipper.SpinSpeed or 0) > 0.1 and 6 or 0)))
			ent:SetAngles(Clipper:LocalToWorldAngles(wAng))
		end

		ent:DrawModel()
	end


	// Remove any weedsticks that are too much
	for i,v in ipairs(Clipper.WeedBranches) do
		if i > count and IsValid(Clipper.WeedBranches[i]) then
			Clipper.WeedBranches[i]:Remove()
		end
	end

	// Create / Update the weedsticks
	for i = 1,count do
		if not IsValid(Clipper.WeedBranches[i]) then
			Clipper.WeedBranches[i] = AddWeedStick(PlantData)
		else
			local ent = Clipper.WeedBranches[i]

			local spin = (Clipper.SpinSpeed or 0) > 0.1 and CurTime() * 0.25 or 0

			local x,y = math.sin(i + spin) * 3,math.cos(i + spin) * 3

			ent:SetPos(Clipper:LocalToWorld(Vector(3.4 + x, 0 + y, 55)))

			ent:SetAngles(Clipper:LocalToWorldAngles(Angle(x * 2,ent.RndSpin,-y * 3)))

			ent:DrawModel()
		end
	end

	render.PopCustomClipPlane()
	render.EnableClipping( oldEC )
end

local emitterOffset = Vector(10, 0, 25)
local particleGravity = Vector(0, 0, -300)
function zgo2.Clipper.LeafEmitter(Clipper,emit)
	local PlantData = zgo2.Plant.GetData(Clipper:GetWeedID())

	if not emit or not PlantData then
		if Clipper.LeafEmitter and Clipper.LeafEmitter:IsValid() then
			Clipper.LeafEmitter:Finish()
			Clipper.LeafEmitter = nil
		end
		return
	end

	if Clipper.NextLeafEmit and CurTime() < Clipper.NextLeafEmit then return end
	Clipper.NextLeafEmit = CurTime() + 0.05

	if not Clipper.LeafEmitter or not Clipper.LeafEmitter:IsValid() then Clipper.LeafEmitter = ParticleEmitter( Clipper:GetPos() , true ) end

	local particle = Clipper.LeafEmitter:Add("!zgo2_plant_leaf0" .. math.random(1, 2) .. "_dried_" .. PlantData.uniqueid, Clipper:LocalToWorld(emitterOffset))
	particle:SetVelocity(Clipper:GetRight() * math.Rand(-50,50) + Clipper:GetForward() * math.Rand(20,110))
	particle:SetVelocityScale( true )

	particle:SetAngles(Angle(-90,math.Rand(0, 360),0))
	particle:SetAngleVelocity(Angle(0,math.Rand(0, 360),0))

	particle:SetDieTime(math.Rand(2, 9))

	local size = math.Rand(5, 9)
	particle:SetStartSize(size)
	particle:SetEndSize(size)

	particle:SetCollide(true)
	particle:SetBounce(0.26)

	particle:SetGravity(particleGravity)
	particle:SetAirResistance(1)
end
