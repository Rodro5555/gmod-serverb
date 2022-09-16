if CLIENT then	

	CreateClientConVar( "simple_thirdperson_enabled", "0", true, false )

	local SThirdPerson = {}

	SThirdPerson.DelayPos = nil
	SThirdPerson.ViewPos = nil
	
	SThirdPerson.EnableToggle = GetConVar( "simple_thirdperson_enabled" ):GetBool() or false
	
	list.Set(
		"DesktopWindows", 
		"ThirdPerson",
		{
			title = "Modo Tercera Persona",
			icon = "icon32/zoom_extend.png",
			init = function(icn, pnl)
				SThirdPerson.EnableToggle = !SThirdPerson.EnableToggle
				RunConsoleCommand("simple_thirdperson_enabled",BoolToInt(SThirdPerson.EnableToggle))
			end
		}
	)
	
	function ServerBool(cmd_server,cmd_client)
		
		local srv_shoulder = GetConVar(cmd_server):GetInt()
		
		if srv_shoulder == 0 then
			return IntToBool(GetConVar( cmd_client ):GetInt())
		elseif srv_shoulder == 1 then
			return true
		elseif srv_shoulder == 2 then
			return false
		end
	end
	
	function ServerNumber(cmd_server_max,cmd_server_min,cmd_client,default)
	
		local value = default
		
		local SrvMax = GetConVar( cmd_server_max ):GetFloat() or 0
		local SrvMin = GetConVar( cmd_server_min ):GetFloat() or 0
		
		local ClnVal = GetConVar( cmd_client ):GetFloat() or default
		
		if SrvMax != 0 and SrvMin != 0 then
			if SrvMin > SrvMax then return ClnVal end
			
			if ClnVal <= SrvMax and ClnVal >= SrvMin then
				value = ClnVal
			else
				value = SrvMax
			end
		else
			value = ClnVal
		end
		
		return value
	end
	
	function IntToBool(it)
		if it == 1 then
			return true
		else
			return false
		end
	end
	
	function BoolToInt(bol)
		if bol then
			return 1
		else
			return 0
		end
	end
	
	concommand.Add( "simple_thirdperson_enable_toggle", function()
		SThirdPerson.EnableToggle = !SThirdPerson.EnableToggle
		RunConsoleCommand("simple_thirdperson_enabled",BoolToInt(SThirdPerson.EnableToggle))
	end)
	
	concommand.Add( "stp", function()
		SThirdPerson.EnableToggle = !SThirdPerson.EnableToggle
		RunConsoleCommand("simple_thirdperson_enabled",BoolToInt(SThirdPerson.EnableToggle))
	end)
	
	hook.Add("ShouldDrawLocalPlayer", "SimpleTP.ShouldDraw", function(ply)
		if GetConVar( "simple_thirdperson_enabled" ):GetBool() then
			return true
		end
	end)

	hook.Add("HUDShouldDraw", "SimpleTP.HUDShouldDraw", function(name)
		if name == "CHudCrosshair" then
			return false //not GetConVar( "simple_thirdperson_enabled" ):GetBool()
		end
	end)
	
	hook.Add("HUDPaint", "SimpleTP.HUDPaint", function()
	
		local ply = LocalPlayer()
		
		local t = {}
		t.start = ply:GetShootPos()
		t.endpos = t.start + ply:GetAimVector() * 9000
		t.filter = ply
		
		local tr = util.TraceLine(t)
		local pos = tr.HitPos:ToScreen()
		
		-- local dist = (tr.HitPos - t.start):Length()

		-- if dist < 3500 then
			
			surface.SetDrawColor(0, 255, 0, 255)
			
			surface.DrawLine(pos.x - 5, pos.y, pos.x - 8, pos.y)
			surface.DrawLine(pos.x + 5, pos.y, pos.x + 8, pos.y)
	
			surface.DrawLine(pos.x, pos.y - 5, pos.x, pos.y - 8)
			surface.DrawLine(pos.x, pos.y + 5, pos.x, pos.y + 8)
			
		-- end
		
	end)
	
	hook.Add("CalcView","SimpleTP.Camera.View",function(ply, pos, angles, fov)
		local isEnabled = GetConVar( "simple_thirdperson_enabled" ):GetBool() or false
		
		if isEnabled and IsValid(ply) then
		
			if SThirdPerson.DelayPos == nil then
				SThirdPerson.DelayPos = ply:EyePos()
			end
			
			if SThirdPerson.ViewPos == nil then
				SThirdPerson.ViewPos = ply:EyePos()
			end
			

			SThirdPerson.DelayFov = fov
			
			local view = {}
			
			angles.p = angles.p + 0
			angles.y = angles.y + 0
			
			SThirdPerson.DelayPos = SThirdPerson.DelayPos + (ply:GetVelocity() * (FrameTime() / 10.0))
			SThirdPerson.DelayPos.x = math.Approach(SThirdPerson.DelayPos.x, pos.x, math.abs(SThirdPerson.DelayPos.x - pos.x) * 0.3)
			SThirdPerson.DelayPos.y = math.Approach(SThirdPerson.DelayPos.y, pos.y, math.abs(SThirdPerson.DelayPos.y - pos.y) * 0.3)
			SThirdPerson.DelayPos.z = math.Approach(SThirdPerson.DelayPos.z, pos.z, math.abs(SThirdPerson.DelayPos.z - pos.z) * 0.3)

			SThirdPerson.DelayFov = SThirdPerson.DelayFov + 20
			fov = math.Approach(fov, SThirdPerson.DelayFov, math.abs(SThirdPerson.DelayFov - fov) * 0.3)
			
			local traceData = {}
			traceData.start = SThirdPerson.DelayPos
			traceData.endpos = traceData.start + angles:Forward() * -100
			traceData.endpos = traceData.endpos + angles:Right() * 0
			traceData.endpos = traceData.endpos + angles:Up() * 0
			traceData.filter = ply
			
			local trace = util.TraceLine(traceData)
			
			pos = trace.HitPos
			
			if trace.Fraction < 1.0 then
				pos = pos + trace.HitNormal * 5
			end
			
			view.origin = pos

			view.angles = angles
			view.fov = fov
		 
			return view
		end
	end)
	
	print("[SimpleThirdPerson] Addon Loaded")
end