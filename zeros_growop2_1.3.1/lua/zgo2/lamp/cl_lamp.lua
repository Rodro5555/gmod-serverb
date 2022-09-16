zgo2 = zgo2 or {}
zgo2.Lamp = zgo2.Lamp or {}
zgo2.Lamp.List = zgo2.Lamp.List or {}

/*

	Lamps are used to provide the plants with light, depending on the lamp it can have diffrent colors, muliply bulbs and a wider light cone

*/
function zgo2.Lamp.Initialize(Lamp)
	Lamp:DrawShadow(false)
	Lamp:DestroyShadow()

	Lamp.PixVis =  {}

	Lamp.LightColor = Lamp.LightColor or Color(255,220,150)

	timer.Simple(0.2, function()
		if IsValid(Lamp) then
			Lamp.m_Initialized = true
		end
	end)
end

function zgo2.Lamp.OnRemove(Lamp)
	zgo2.Lamp.RemoveCones(Lamp)
	Lamp:StopSound(zgo2.Lamp.CausesHeat(Lamp) and "zgo2_lamp_sodium_loop" or "zgo2_lamp_led_loop")
end

/*
	Draw ui and light stuff
*/
function zgo2.Lamp.OnDraw(Lamp)

	// Draw the light sprites
	if zgo2.Lamp.EmittingLight(Lamp) then
		zgo2.Lamp.PixVisLight(Lamp)
	end

	if not zclib.Convar.GetBool("zclib_cl_drawui") then return end
	if zclib.util.InDistance(Lamp:GetPos(), LocalPlayer():GetPos(), zgo2.util.RenderDistance_UI) == false then return end

	local switch_vec , switch_ang = zgo2.Lamp.GetUI_Switch(Lamp)

	// Draw some light switch indicator
	local w, h = 100, 100
	cam.Start3D2D(Lamp:LocalToWorld(switch_vec), Lamp:LocalToWorldAngles(switch_ang), 0.05)

		draw.RoundedBox(h/2, -w / 2, -h / 2, w, h, Lamp:GetLightSwitch() and zclib.colors["orange01"] or zclib.colors["blue02"])
		surface.SetDrawColor(zclib.colors[ "white_a100" ])
		surface.SetMaterial(zclib.Materials.Get("switch"))
		surface.DrawTexturedRectRotated(0, 0, w, h, 0)

		if Lamp:OnLightSwitch(LocalPlayer()) then
			draw.RoundedBox(h / 2, -w / 2, -h / 2, w, h, zclib.colors[ "white_a100" ])
		end
	cam.End3D2D()

	// If the lamp support multi colors then add a color change button
	if zgo2.Lamp.CanChangeColor(Lamp) then

		local color_vec , color_ang = zgo2.Lamp.GetUI_Color(Lamp)

		cam.Start3D2D(Lamp:LocalToWorld(color_vec), Lamp:LocalToWorldAngles(color_ang), 0.05)

			draw.RoundedBox(h/2, -w / 2, -h / 2, w, h, Lamp.LightColor or zclib.colors["blue02"])

			surface.SetDrawColor(zclib.colors[ "white_a100" ])
			surface.SetMaterial(zclib.Materials.Get("appearance"))
			surface.DrawTexturedRectRotated(0, 0, w, h, 0)

			if Lamp:OnColorChange(LocalPlayer()) then
				draw.RoundedBox(h / 2, -w / 2, -h / 2, w, h, zclib.colors[ "white_a100" ])
			end
		cam.End3D2D()
	end

	// Draw some power indicator
	if Lamp:GetPower() > 0 then

		local power_vec , power_ang = zgo2.Lamp.GetUI_Power(Lamp)

		cam.Start3D2D(Lamp:LocalToWorld(power_vec), Lamp:LocalToWorldAngles(power_ang), 0.05)
			zgo2.util.DrawBar(250,50,zclib.Materials.Get("zgo2_icon_power"), zclib.colors[ "orange01" ],0, 0, (1 / zgo2.config.Battery.Power) * Lamp:GetPower())
		cam.End3D2D()
	end
end

/*
	Render the visible Light sprite
*/
function zgo2.Lamp.PixVisLight(Lamp)
	if not zclib.Convar.GetBool("zgo2_cl_lightsprite") then return end
	if zclib.util.InDistance(Lamp:GetPos(), LocalPlayer():GetPos(), 600) == false then return end

	local dat = zgo2.Lamp.GetData(Lamp:GetLampID())
	if not dat then return end
	if not dat.visuals then return end

	for k,v in pairs(dat.visuals) do
		if not v.sprite then continue end

		if not zgo2.Lamp.HasBulb(Lamp,k) then
			continue
		end

		local w,h = v.sprite.w , v.sprite.h

		local LightPos = Lamp:LocalToWorld(v.lpos)

		render.SetMaterial(zclib.Materials.Get("light_sprite"))

		local ViewNormal = LightPos - EyePos()
		ViewNormal:Normalize()

		//debugoverlay.BoxAngles( LightPos, Vector(-2,-20,-10), Vector(2,20,2), Lamp:LocalToWorldAngles(v.lang), 0.01,Color( 0, 255, 0 ,10) )

		// Create the handler if it doesent exist
		if Lamp.PixVis[k] == nil then Lamp.PixVis[k] = util.GetPixelVisibleHandle() end

		local Visibile = util.PixelVisible(LightPos, 1, Lamp.PixVis[k])
		if (not Visibile or Visibile < 0.1) then continue end

		if v.sprite.count then
			local ang = Lamp:LocalToWorldAngles(v.lang)
			for i = 1, v.sprite.count do
				render.DrawSprite(Lamp:LocalToWorld(v.lpos) + (-ang:Right() * (v.sprite.z_dist * i)) + (ang:Right() * (v.sprite.z_dist * (v.sprite.count / 1.8))), w, h, Lamp.LightColor)
			end
		else
			render.DrawSprite(LightPos, w, h, Lamp.LightColor)
		end
	end
end

/*
	Render dynamic light
*/
function zgo2.Lamp.DynamicLight(Lamp)
	if not zclib.Convar.GetBool("zgo2_cl_dynlight") then return end

	/*
	local dat = zgo2.Lamp.GetData(Lamp:GetLampID())
	if not dat then return end
	if not dat.visuals then return end
	local v = dat.visuals[1]
	local pos = Lamp:LocalToWorld(v.light.lpos or v.lpos) + (Lamp:LocalToWorldAngles(v.light.lang or v.lang):Up() * -5)

	local dlight01 = DynamicLight(Lamp:EntIndex())
	if dlight01 then
		dlight01.pos = pos
		dlight01.r = Lamp.LightColor.r
		dlight01.g = Lamp.LightColor.g
		dlight01.b = Lamp.LightColor.b
		dlight01.brightness = 1
		dlight01.Decay = 1000
		dlight01.Size = v.light.size * 2
		dlight01.DieTime = CurTime() + 1
	end
	*/

	local dat = zgo2.Lamp.GetData(Lamp:GetLampID())
	if not dat then return end
	if not dat.visuals then return end

	for k, v in pairs(dat.visuals) do

		if not zgo2.Lamp.HasBulb(Lamp,k) then
			continue
		end

		if not v.light then continue end

		local pos = Lamp:LocalToWorld(v.light.lpos or v.lpos) + (Lamp:LocalToWorldAngles(v.light.lang or v.lang):Up() * -1)
		pos = pos + (Lamp:LocalToWorldAngles(v.light.lang or v.lang):Up() * -(v.light.offset or 1))

		local dlight01 = DynamicLight(Lamp:EntIndex() + pos.x + pos.y + pos.z)
		if dlight01 then

			//debugoverlay.Sphere(pos,1,0.1,Color( 255, 0, 0 ),false)

			dlight01.pos = pos
			dlight01.r = Lamp.LightColor.r
			dlight01.g = Lamp.LightColor.g
			dlight01.b = Lamp.LightColor.b
			dlight01.brightness = 1
			dlight01.Decay = 1000
			dlight01.Size = v.light.size
			dlight01.DieTime = CurTime() + 1
		end
	end
end

/*
	Adds the lamp to the list
*/
function zgo2.Lamp.OnThink(Lamp)
	if zgo2.Lamp.List[Lamp] == nil then
		zgo2.Lamp.List[Lamp] = true
	end

	zclib.util.LoopedSound(Lamp, zgo2.Lamp.CausesHeat(Lamp) and "zgo2_lamp_sodium_loop" or "zgo2_lamp_led_loop", zgo2.Lamp.IsEmittingLight(Lamp))
end

/*
	Handles the client light ray model being created / Updated
*/
function zgo2.Lamp.Logic()
    for ent,_ in pairs(zgo2.Lamp.List) do
        if not IsValid(ent) then
			continue
		end

		if not ent.m_Initialized then continue end

		if zclib.util.InDistance(ent:GetPos(), LocalPlayer():GetPos(), 1000) == false then
			ent.ReceiveBulbData = nil
			continue
		end

		// Ask the server about the current bulbs info if the lamp has some
		if zgo2.Lamp.UsesBulbs(ent) and (ent.NextBulbRequest == nil or CurTime() > ent.NextBulbRequest) and not ent.ReceiveBulbData then
			net.Start("zgo2.Lamp.UpdateBulbs")
			net.WriteEntity(ent)
			net.SendToServer()
			ent.NextBulbRequest = CurTime() + 3
		end

        // If we cant see the lamp then skip
        if zclib.util.IsInsideViewCone(ent:GetPos(),EyePos(),EyeAngles(),1000,2000) == false then
			ent.UpdatedLight_model = nil
            continue
        end

		// Remove the light ray if we are not emitting light
		if not zgo2.Lamp.EmittingLight(ent) then
			zgo2.Lamp.RemoveCones(ent)
			ent.UpdatedLight_model = nil
			continue
		end

		if ent.UpdatedLight_model == nil then

			// Create  / update the light models for this lamp
			zgo2.Lamp.UpdateLight(ent)

			ent.UpdatedLight_model = true
		end

		zgo2.Lamp.UpdateLightBeam(ent)
    end
end
zclib.Timer.Remove("zgo2_lamp_logic")
zclib.Timer.Create("zgo2_lamp_logic", 1, 0, function() zgo2.Lamp.Logic() end)

function zgo2.Lamp.PreDraw()
	if not LocalPlayer().zgo2_Initialized then return end
	for ent,_ in pairs(zgo2.Lamp.List) do
        if not IsValid(ent) then
			continue
		end

		if not ent.m_Initialized then continue end

		if zclib.util.InDistance(ent:GetPos(), LocalPlayer():GetPos(), 600) == false then continue end

		// Remove the light ray if we are not emitting light
		if not zgo2.Lamp.EmittingLight(ent) then
			continue
		end

		// Draw the realtime dynamic light
		zgo2.Lamp.DynamicLight(ent)
    end
end
zclib.Hook.Remove("PreDrawHUD", "zgo2_lamp_draw")
zclib.Hook.Add("PreDrawHUD", "zgo2_lamp_draw", function() zgo2.Lamp.PreDraw() end)

/*
	Creates a clientmodel
*/
local function AddCSEnt(Lamp,mdl)

	local ent = ClientsideModel( mdl )
	if not IsValid(ent) then return end
	table.insert(zgo2.ClientModels,ent)
	ent:SetModel(mdl)
	ent:Spawn()

	local width,height = 1,2.5
	local scale = Vector(width,width,height)
	local vmat = Matrix()
	vmat:Scale(scale)
	ent:EnableMatrix( "RenderMultiply", vmat )

	ent:SetParent(Lamp)
	ent.Lamp = Lamp
	return ent
end

/*
	Creates / Updates the LightRays
*/
function zgo2.Lamp.UpdateLight(Lamp)

	if not zclib.Convar.GetBool("zgo2_cl_lightbeam") then
		zgo2.Lamp.RemoveCones(Lamp)
		return
	end

	local dat = zgo2.Lamp.GetData(Lamp:GetLampID())
	if not dat then return end
	if not dat.visuals then return end

	if Lamp.LightCones == nil then Lamp.LightCones = {} end

	if not zgo2.Lamp.EmittingLight(Lamp) then return end

	for k,v in pairs(dat.visuals) do
		if not v.cone then continue end

		if not zgo2.Lamp.HasBulb(Lamp,k) then
			if IsValid(Lamp.LightCones[k]) then
				Lamp.LightCones[k]:Remove()
			end
			continue
		end

		if not IsValid(Lamp.LightCones[k]) then
			Lamp.LightCones[k] = AddCSEnt(Lamp,"models/zerochain/props_growop2/zgo2_lightray01.mdl")
			Lamp.LightCones[k]:SetRenderMode(RENDERMODE_TRANSCOLOR)
			zgo2.Lamp.UpdateBeamColor(Lamp,Lamp.LightCones[k])
		end
		Lamp.LightCones[k]:SetParent(nil)
		Lamp.LightCones[k]:SetPos(Lamp:LocalToWorld(v.lpos))
		Lamp.LightCones[k]:SetAngles(Lamp:LocalToWorldAngles(v.lang))
		Lamp.LightCones[k]:SetParent(Lamp)
	end
end

/*
	Removes all the light cones from the lamp
*/
function zgo2.Lamp.RemoveCones(Lamp)
	if Lamp.LightCones then
		for k,v in pairs(Lamp.LightCones) do
			if v and IsValid(v) then v:Remove() end
		end
	end
end

/*
	Gets called when the light color changes
*/
function zgo2.Lamp.OnColorChange(Lamp)
	if IsValid(Lamp) and Lamp.LightCones then
		for k, v in pairs(Lamp.LightCones) do
			if v and IsValid(v) then
				zgo2.Lamp.UpdateBeamColor(Lamp,v)
			end
		end
	end
end

function zgo2.Lamp.UpdateBeamColor(Lamp,Beam)
	Beam:SetColor(Color(Lamp.LightColor.r * 0.4,Lamp.LightColor.g * 0.4,Lamp.LightColor.b * 0.4,255))
end

/*
	Updates the light beam scale according to where the lamp light is hitting the wall
*/
function zgo2.Lamp.UpdateLightBeam(Lamp)

	if not zclib.Convar.GetBool("zgo2_cl_lightbeam") then
		zgo2.Lamp.RemoveCones(Lamp)
		return
	end

	local dat = zgo2.Lamp.GetData(Lamp:GetLampID())

	for id,data in pairs(dat.visuals) do

		if not Lamp.LightCones then continue end

		local ent = Lamp.LightCones[id]

		if not zgo2.Lamp.HasBulb(Lamp,id) then
			if IsValid(ent) then
				ent:Remove()
			end
			continue
		end

		if not IsValid(ent) then continue end

		ent:SetParent(nil)

		local pos,ang = Lamp:LocalToWorld(data.lpos) , Lamp:LocalToWorldAngles(data.lang)

		ent:SetPos(pos)
		ent:SetAngles(ang)

		local dist = 300

		ang:RotateAroundAxis(ang:Right(),-90)

		local tr = util.TraceLine( {
			start = pos,
			endpos = pos + ang:Forward() * dist,
			mask = MASK_PLAYERSOLID_BRUSHONLY,
		} )

		local len = 1
		if tr and tr.Fraction then len = tr.Fraction end

		// debugoverlay.Line(pos,pos + ang:Forward() * dist,1,Color( 0, 255, 0 ),true)
		// debugoverlay.Text( pos, id, 1, true )

		local scale = Vector(data.cone.w ,data.cone.h,data.cone.d * len)
		local vmat = Matrix()
		vmat:Scale(scale)
		ent:EnableMatrix( "RenderMultiply", vmat )

		ent:SetParent(Lamp)
	end
end

/*
	Update which slots has which bulb
*/
net.Receive("zgo2.Lamp.UpdateBulbs", function(len,ply)
    zclib.Debug_Net("zgo2.Lamp.UpdateBulbs", len)

    local Lamp = net.ReadEntity()
	if not IsValid(Lamp) then return end
	if not Lamp:IsValid() then return end
	if Lamp:GetClass() ~= "zgo2_lamp" then return end

	local count = net.ReadUInt(4)

	Lamp.Bulbs = {}
	for i=1,count do Lamp.Bulbs[net.ReadUInt(4)] = net.ReadBool() end

	zgo2.Lamp.UpdateLight(Lamp)

	Lamp.ReceiveBulbData = true
end)

/*
	Returns true if all bulbs are added
*/
function zgo2.Lamp.HasBulb(Lamp,id)
	if not zgo2.Lamp.UsesBulbs(Lamp) then return true end
	if not Lamp.Bulbs then return false end

	return Lamp.Bulbs[id] == true
end
