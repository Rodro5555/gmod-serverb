include("shared.lua")

surface.CreateFont("DiablosRSClientHUDBigFont1", { font = "Digital-7", size = 37, weight = 2500 })
surface.CreateFont("DiablosRSClientHUDBiggerFont1", { font = "Digital-7", size = 80, weight = 4000 })
surface.CreateFont("DiablosRSClientHUDLittleFont1", { font = "Digital-7", size = 17, weight = 500 })
surface.CreateFont("DiablosRSClientHUDBigFont2", { font = "Digital-7", size = 28, weight = 2500 })
surface.CreateFont("DiablosRSClientHUDBiggerFont2", { font = "Digital-7", size = 70, weight = 4000 })
surface.CreateFont("DiablosRSClientHUDLittleFont2", { font = "Digital-7", size = 12, weight = 500 })
surface.CreateFont("DiablosRSCopsDigiFont", { font = "Digital-7", size = 22, weight = 500 })
surface.CreateFont("DiablosRSSpeedometerFont", { font = "Digital-7", size = 30, weight = 800 })
surface.CreateFont("DiablosRSAboveRadarFont", { font = "Calibri", size = 130, weight = 700 })
surface.CreateFont("DiablosRSToolgunFont1", { font = "Calibri", size = 34, weight = 700 })
surface.CreateFont("DiablosRSToolgunFont2", { font = "Calibri", size = 25, weight = 600 })
surface.CreateFont("DiablosRSMainFont", { font = "Calibri", size = 18, weight = 400 })
surface.CreateFont("DiablosRSMainFontI", { font = "Calibri", size = 18, weight = 400, italic = true })
surface.CreateFont("DiablosRSCopsFont", { font = "Calibri", size = 30, weight = 700 })
surface.CreateFont("DiablosRSCopsFont2", { font = "Calibri", size = 25, weight = 700 })

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	Diablos.RS.RadarAboveInfos(self)
end

local DrawRadarInfos = {
	["english_speed_camera"] = {h = 190, r = -20},
	["french_speed_camera"] = {h = 60, r = 0},
	["discriminating_camera"] = {h = 150, r = 0},
	["educational_camera"] = {h = 100, r = 0},
	["average_camera_begin"] = {h = 100, r = 0},
	["average_camera_end"] = {h = 50, r = 0},
	["stop_camera"] = {h = 120, r = 0},
	["pedestrian_camera"] = {h = 120, r = 0},
}

local RenderRadarInfos = {
	["english_speed_camera"] = {f = 160, u = 170, r = 90},
	["french_speed_camera"] = {f = 160, u = 60, r = 120},
	["discriminating_camera"] = {f = 140, u = 130, r = 100},
	["educational_camera"] = {f = 140, u = 80, r = 100},
	["average_camera_begin"] = {f = 120, u = 70, r = 100},
	["average_camera_end"] = {f = 120, u = 50, r = 100},
	["stop_camera"] = {f = 120, u = 50, r = 100},
	["pedestrian_camera"] = {f = 120, u = 50, r = 100},
}

function Diablos.RS.RadarAboveInfos(ent)
	if not IsValid(ent) then return end
	local ply = LocalPlayer()
	if ply.DrawVisible == nil then ply.DrawVisible = true end
	if ply.DrawVisible then
		local class = ent:GetClass()
		local infos = DrawRadarInfos[class]
		local educ = class == "educational_camera"
		local discri = class == "discriminating_camera"
		local avgend = class == "average_camera_end"

		local speed
		if not avgend and not discri then
			speed = ent:GetSpeedLimit()
		elseif avgend then
			if IsValid(ent:GetAverageBegin()) then
				speed = ent:GetAverageBegin():GetSpeedLimit()
			end
		end
		if not speed then speed = 0 end

		local fineprice
		if not avgend and not educ then
			fineprice = ent:GetFinePrice()
		elseif avgend then
			if IsValid(ent:GetAverageBegin()) then
				fineprice = ent:GetAverageBegin():GetFinePrice()
			end
		end

		local speedatzero = (not discri and speed == 0) or (discri and ent:GetSpeedLimitVeh() == 0 and ent:GetSpeedLimitTruck() == 0)

		local angadd, newangadd = 90, 0
		if not educ and ent:GetRoadRadar() then angadd, newangadd = 0, 180 end

		cam.Start3D2D(ent:GetPos() + ent:GetUp() * infos.h + ent:GetRight() * infos.r, Angle(0, ent:GetAngles().y + angadd, 90), .1)
			surface.SetFont("DiablosRSAboveRadarFont")
			if Diablos.RS.ShowSpeedAboveRadar then
				if not speedatzero then
					if not discri then
						surface.SetFont("DiablosRSAboveRadarFont")
						local sizex, sizey = surface.GetTextSize(speed .. " " .. Diablos.RS.MPHKMHText)
						draw.RoundedBox(8, - sizex / 2 - 25, -10, sizex + 50, sizey + 20, Diablos.RS.Colors.AboveRadarBorder)
						draw.RoundedBox(8, - sizex / 2 - 5, 0, sizex + 10, sizey, Diablos.RS.Colors.AboveRadarBorder)
						draw.SimpleText(speed .. " " .. Diablos.RS.MPHKMHText, "DiablosRSAboveRadarFont", 0, 0, Diablos.RS.Colors.AboveRadarText, TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)
					elseif discri then
						surface.SetFont("DiablosRSAboveRadarFont")
						local sizexveh, sizeyveh = surface.GetTextSize(Diablos.RS.Strings.vehtxt .. ": " .. ent:GetSpeedLimitVeh() .. " " .. Diablos.RS.MPHKMHText)
						local sizextruck, sizeytruck = surface.GetTextSize(Diablos.RS.Strings.trucktxt .. ": " .. ent:GetSpeedLimitTruck() .. " " .. Diablos.RS.MPHKMHText)

						draw.RoundedBox(8, - sizexveh / 2 - 25, - 25, sizexveh + 50, 140 + sizeyveh / 2 + sizeytruck / 2 + 50, Diablos.RS.Colors.AboveRadarBorder)
						draw.RoundedBox(8, - sizexveh / 2 - 15,  -15, sizexveh + 30, 140 + sizeyveh / 2 + sizeytruck / 2 + 30, Diablos.RS.Colors.AboveRadarBorder)

						draw.SimpleText(Diablos.RS.Strings.vehtxt .. ": " .. ent:GetSpeedLimitVeh() .. " " .. Diablos.RS.MPHKMHText, "DiablosRSAboveRadarFont", 0, 0, Diablos.RS.Colors.AboveRadarText, TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)
						draw.SimpleText(Diablos.RS.Strings.trucktxt .. ": " .. ent:GetSpeedLimitTruck() .. " " .. Diablos.RS.MPHKMHText, "DiablosRSAboveRadarFont", 0, 140, Diablos.RS.Colors.AboveRadarText, TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)
					end
				end
			end

			local nick = Diablos.RS.Strings.server
			if IsValid(ent:Getowning_ent()) then nick = ent:Getowning_ent():Nick() end
			if IsValid(ply:GetActiveWeapon()) then
				local wepclass = ply:GetActiveWeapon():GetClass()
				if (wepclass == "gmod_tool" and istable(ply:GetTool()) and ply:GetTool().Mode == "radar") or wepclass == "radar_infos" then
					local sizex1, sizey1 = surface.GetTextSize(Diablos.RS.Strings.owner .. ": " .. nick)

					local sizex2, sizey2 = 0, 0
					if class != "educational_camera" then
						sizex2, sizey2 = surface.GetTextSize(Diablos.RS.Strings.fineprice .. ": " .. GAMEMODE.Config.currency ..  fineprice)
					end

					local biggestsizex = sizex1
					if sizex2 > sizex1 then biggestsizex = sizex2 end

					draw.RoundedBox(8, - biggestsizex / 2 - 25, -270 - sizey1 / 2 - 25, biggestsizex + 50, 140 + sizey1 / 2 + sizey2 / 2 + 50, Diablos.RS.Colors.AboveRadarBorder)
					draw.RoundedBox(8, - biggestsizex / 2 - 15, -270 - sizey1 / 2 - 15, biggestsizex + 30, 140 + sizey1 / 2 + sizey2 / 2 + 30, Diablos.RS.Colors.AboveRadarBorder)

					draw.SimpleText(Diablos.RS.Strings.owner .. ": " .. nick, "DiablosRSAboveRadarFont", 0, -270, Diablos.RS.Colors.AboveRadarText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					if sizex2 != 0 then
						draw.SimpleText(Diablos.RS.Strings.fineprice .. ": " .. GAMEMODE.Config.currency ..  fineprice, "DiablosRSAboveRadarFont", 0, -140, Diablos.RS.Colors.AboveRadarText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
				end
			end
		cam.End3D2D()

		cam.Start3D2D(ent:GetPos() + ent:GetUp() * infos.h + ent:GetRight() * infos.r, Angle(0, ent:GetAngles().y - angadd - newangadd, 90), .1)
			if Diablos.RS.ShowSpeedAboveRadar then
				if not speedatzero then
					if not discri then
						draw.SimpleText(speed .. " " .. Diablos.RS.MPHKMHText, "DiablosRSAboveRadarFont", 0, 0, Diablos.RS.Colors.AboveRadarText, TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)
					elseif discri then
						draw.SimpleText(Diablos.RS.Strings.vehtxt .. ": " .. ent:GetSpeedLimitVeh() .. " " .. Diablos.RS.MPHKMHText, "DiablosRSAboveRadarFont", 0, 0, Diablos.RS.Colors.AboveRadarText, TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)
						draw.SimpleText(Diablos.RS.Strings.trucktxt .. ": " .. ent:GetSpeedLimitTruck() .. " " .. Diablos.RS.MPHKMHText, "DiablosRSAboveRadarFont", 0, 140, Diablos.RS.Colors.AboveRadarText, TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)
					end
				end
			end

			local nick = Diablos.RS.Strings.server
			if IsValid(ent:Getowning_ent()) then nick = ent:Getowning_ent():Nick() end
			if IsValid(ply:GetActiveWeapon()) then
				local wepclass = ply:GetActiveWeapon():GetClass()
				if (wepclass == "gmod_tool" and istable(ply:GetTool()) and ply:GetTool().Mode == "radar") or wepclass == "radar_infos" then
					draw.SimpleText(Diablos.RS.Strings.owner .. ": " .. nick, "DiablosRSAboveRadarFont", 0, -270, Diablos.RS.Colors.AboveRadarText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					
					if class != "educational_camera" then
						draw.SimpleText(Diablos.RS.Strings.fineprice .. ": " .. GAMEMODE.Config.currency ..  fineprice, "DiablosRSAboveRadarFont", 0, -140, Diablos.RS.Colors.AboveRadarText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
				end
			end
		cam.End3D2D()
	end
end

local function DiablosRSPaintButtons(panel)
	if panel.Hovered then
		if panel:IsDown() then
			panel:SetTextColor(Diablos.RS.Colors.LabelDown)
		else
			panel:SetTextColor(Diablos.RS.Colors.LabelHovered)
		end
	else
		panel:SetTextColor(Diablos.RS.Colors.Label)
	end
end

function Diablos.RS.Frame.Classic(ent, english)
	local valident = IsValid(ent)

	local currentval = 1

	local frame = vgui.Create("DFrame")
	frame:SetSize(300, 340)
	frame:Center()
	frame:SetTitle("")
	frame:ShowCloseButton(false)
	frame.Paint = function(s, w, h)
		if Diablos.RS.Colors.Blurs then Derma_DrawBackgroundBlur(s, 1) end
		surface.SetDrawColor(Diablos.RS.FrameBasicColors.basicframe) surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(Diablos.RS.FrameBasicColors.basicheader) surface.DrawRect(0, 0, w, 30)
		if english then
			draw.SimpleText("RADAR CREATION (ENGLISH CLASSICAL)", "DiablosRSMainFont", 7, 7, Diablos.RS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		else
			draw.SimpleText("RADAR CREATION (FRENCH CLASSICAL)", "DiablosRSMainFont", 7, 7, Diablos.RS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		end

		draw.SimpleText("SPEED LIMIT", "DiablosRSMainFont", 15, 65, Diablos.RS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("FINE PRICE", "DiablosRSMainFont", 15, 125, Diablos.RS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		draw.SimpleText("RADAR IN FRONT OF ROAD", "DiablosRSMainFont", 15, 185, Diablos.RS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("LENGTH", "DiablosRSMainFont", 15, 245, Diablos.RS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	frame:MakePopup()

	local cancel = vgui.Create("DButton", frame)
	cancel:SetPos(280, 5)
	cancel:SetSize(20, 20)
	cancel:SetText("X")
	cancel:SetFont("DiablosRSMainFont")
	cancel.DoClick = function()
		frame:Close()
	end
	cancel.Paint = function(s, w, h)
		DiablosRSPaintButtons(s)
	end

	local speedlimit = vgui.Create("DNumberWang", frame)
	speedlimit:SetPos(125, 50)
	speedlimit:SetSize(160, 30)
	speedlimit:SetMinMax(1, 255)
	speedlimit:SetFont("DiablosRSMainFont")
	speedlimit.Paint = function(s, w, h)
		surface.SetDrawColor(Diablos.RS.FrameBasicColors.rndbox) surface.DrawRect(0, 0, w, h)
		s:DrawTextEntryText(Diablos.RS.Colors.Label, Diablos.RS.Colors.LabelHovered, Diablos.RS.Colors.LabelDown)
	end

	local fineprice = vgui.Create("DNumberWang", frame)
	fineprice:SetPos(125, 110)
	fineprice:SetSize(160, 30)
	fineprice:SetMinMax(1, 65535)
	fineprice:SetFont("DiablosRSMainFont")
	fineprice.Paint = function(s, w, h)
		surface.SetDrawColor(Diablos.RS.FrameBasicColors.rndbox) surface.DrawRect(0, 0, w, h)
		s:DrawTextEntryText(Diablos.RS.Colors.Label, Diablos.RS.Colors.LabelHovered, Diablos.RS.Colors.LabelDown)
	end

	local roadvalue = 1
	local roadradar = vgui.Create("DButton", frame)
	roadradar:SetPos(205, 170)
	roadradar:SetSize(80, 30)
	roadradar:SetText("")
	roadradar:SetFont("DiablosRSMainFont")
	roadradar.Paint = function(s, w, h)
		surface.SetDrawColor(Diablos.RS.FrameBasicColors.rndbox) surface.DrawRect(0, 0, w, h)
		if roadvalue == 1 then
			surface.SetDrawColor(Diablos.RS.FrameBasicColors.g) surface.DrawRect(0, 0, w, h)
			draw.SimpleText("true", "DiablosRSMainFont", 40, 15, Diablos.RS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			surface.SetDrawColor(Diablos.RS.FrameBasicColors.r) surface.DrawRect(0, 0, w, h)
			draw.SimpleText("false", "DiablosRSMainFont", 40, 15, Diablos.RS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
	roadradar.DoClick = function(s)
		if roadvalue == 1 then
			roadvalue = 0
		else
			roadvalue = 1
		end
	end

	local lengthradar = vgui.Create("DNumberWang", frame)
	lengthradar:SetPos(125, 230)
	lengthradar:SetSize(160, 30)
	lengthradar:SetMinMax(1, 8)
	lengthradar:SetFont("DiablosRSMainFont")
	lengthradar.Paint = function(s, w, h)
		surface.SetDrawColor(Diablos.RS.FrameBasicColors.rndbox) surface.DrawRect(0, 0, w, h)
		s:DrawTextEntryText(Diablos.RS.Colors.Label, Diablos.RS.Colors.LabelHovered, Diablos.RS.Colors.LabelDown)
	end

	local btext = "SAVE"
	if not valident then 
		speedlimit:SetValue(Diablos.RS.SpeedLimit)
		fineprice:SetValue(Diablos.RS.FinePrice)
		lengthradar:SetValue(1)
	else 
		speedlimit:SetValue(ent:GetSpeedLimit())
		fineprice:SetValue(ent:GetFinePrice())
		if ent:GetRoadRadar() then roadvalue = 1 else roadvalue = 0 end
		lengthradar:SetValue(ent:GetLengthRadar())

		btext = "EDIT"
	end

	local posx = 100
	if valident then
		posx = 25
		local delete = vgui.Create("DButton", frame)
		delete:SetPos(175, 290)
		delete:SetSize(100, 30)
		delete:SetText("DELETE")
		delete:SetFont("DiablosRSMainFont")
		delete.DoClick = function()
			net.Start("TPRSA:SaveRadar:Classical")
				net.WriteEntity(ent)
			net.SendToServer()
			frame:Close()
		end
		delete.Paint = function(s, w, h)
			surface.SetDrawColor(Diablos.RS.FrameBasicColors.basicheader) surface.DrawRect(0, 0, w, h)
			DiablosRSPaintButtons(s)
		end
	end

	local save = vgui.Create("DButton", frame)
	save:SetPos(posx, 290)
	save:SetSize(100, 30)
	save:SetText(btext)
	save:SetFont("DiablosRSMainFont")
	save.DoClick = function()
		if speedlimit:GetValue() != 0 then
			net.Start("TPRSA:SaveRadar:Classical")
				net.WriteEntity(ent)
				net.WriteUInt(speedlimit:GetValue(), 8)
				net.WriteUInt(fineprice:GetValue(), 16)
				net.WriteBit(roadvalue)
				net.WriteUInt(lengthradar:GetValue(), 4)
				net.WriteBool(english)
			net.SendToServer()
			frame:Close()
		else
			chat.AddText(col.pre1, Diablos.RS.Strings.radarsystem .. " ", col.pre2, ": " .. Diablos.RS.Strings.speedzero)
		end
	end
	save.Paint = function(s, w, h)
		surface.SetDrawColor(Diablos.RS.FrameBasicColors.basicheader) surface.DrawRect(0, 0, w, h)
		DiablosRSPaintButtons(s)
	end
end

local function TPRSARecordsFrame(ent, tableofrecords)
	table.SortByMember(tableofrecords, "speed")

	local norecords = true

	local frame = vgui.Create("DFrame")
	frame:SetSize(1100, 700)
	frame:Center()
	frame:SetTitle("")
	frame:SetDraggable(false)
	frame:ShowCloseButton(false)
	frame.Paint = function(s, w, h)
		if Diablos.RS.Colors.Blurs then Derma_DrawBackgroundBlur(s, 1) end
		surface.SetDrawColor(Diablos.RS.Colors.Frame) surface.DrawRect(0, 0, w, h)
		draw.SimpleText(Diablos.RS.Strings.speedrecord .. " (TOP " .. Diablos.RS.BestRecordsTop .. ")", "DiablosRSCopsFont", w / 2, 20, Diablos.RS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		if norecords then
			draw.SimpleText(Diablos.RS.Strings.norecords, "DiablosRSCopsFont", w / 2, h / 2, Diablos.RS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		/*surface.SetDrawColor(Diablos.RS.FrameBasicColors.basicframe) surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(Diablos.RS.FrameBasicColors.basicheader) surface.DrawRect(0, 0, w, 30)
		draw.SimpleText(Diablos.RS.Strings.speedrecord .. " (TOP " .. Diablos.RS.BestRecordsTop .. ")", "DiablosRSMainFont", 7, 7, Diablos.RS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		if norecords then
			draw.SimpleText(Diablos.RS.Strings.norecords, "DiablosRSMainFont", 325, 225, Diablos.RS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)
		else
			draw.SimpleText(Diablos.RS.Strings.speedtxt, "DiablosRSMainFont", 70, 45, Diablos.RS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)
			draw.SimpleText(Diablos.RS.Strings.vehtxt, "DiablosRSMainFont", 200, 45, Diablos.RS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)
			draw.SimpleText(Diablos.RS.Strings.playertxt, "DiablosRSMainFont", 350, 45, Diablos.RS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)
			draw.SimpleText(Diablos.RS.Strings.datetxt, "DiablosRSMainFont", 510, 45, Diablos.RS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)
		end*/
	end

	frame:MakePopup()

	local close = vgui.Create("DImageButton", frame)
	close:SetPos(1050, 10)
	close:SetSize(40, 40)
	close:SetImage("materials/tprsa/close.png")
	close.DoClick = function(s)
		frame:Close()
	end

	local scrollframe = vgui.Create("DScrollPanel", frame)
	scrollframe:SetPos(15, 80)
	scrollframe:SetSize(1070, 600)

	local anim = Derma_Anim("DiablosAnim", scrollframe, function(pnl, anim, delta, data)
		--pnl:SetPos(650 - 640 * delta, 80)
	end)
	anim:Start(1)
	scrollframe.Think = function()
		if anim:Active() then
			anim:Run()
		end
	end

	local scrollframevbar = scrollframe:GetVBar()

	scrollframevbar.Paint = function(s, w, h)
		draw.RoundedBox(4, 5, 0, 10, h, Diablos.RS.Colors.VBarBG)
	end
	
	scrollframevbar.btnGrip.Paint = function(s, w, h)
		draw.RoundedBox(8, 5, 0, 10, h, Diablos.RS.Colors.VBarGrip)
	end
	
	scrollframevbar.btnUp.Paint = function(s, w, h) end
	scrollframevbar.btnDown.Paint = function(s, w, h) end

	local num = 0
	for _, tab in pairs(tableofrecords) do
		if IsValid(tab.ent) and tab.ent == ent and num <= Diablos.RS.BestRecordsTop then
			norecords = false
			local vehname = list.Get("Vehicles")[tab.veh].Name
			local vehmodel = list.Get("Vehicles")[tab.veh].Model

			local class = ent:GetClass()

			local panel = vgui.Create("DPanel", scrollframe)
			panel:SetPos(0, 130 * (num - 1))
			panel:SetSize(1055, 120)
			panel.Paint = function(s, w, h)
				surface.SetDrawColor(Diablos.RS.Colors.FrameLeft) surface.DrawRect(0, 0, w, h)
				draw.SimpleText(tab.speed .. " " .. Diablos.RS.MPHKMHText, "DiablosRSCopsFont", 800, h / 2, Diablos.RS.FrameBasicColors.gl, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				if IsValid(tab.caughtply) then
					draw.SimpleText(tab.caughtply:Nick(), "DiablosRSCopsFont", 10, h / 2, Diablos.RS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
				draw.SimpleText(vehname, "DiablosRSCopsFont", 500, 5, Diablos.RS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				
				draw.SimpleText(tab.date, "DiablosRSCopsFont2", w - 5, h - 5, Diablos.RS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
			end

			local vehicon = vgui.Create("DModelPanel", panel)
			vehicon:SetPos(400, 10)
			vehicon:SetSize(200, 100)
			vehicon:SetModel(vehmodel)
			vehicon:SetFOV(100)
			num = num + 1
		end
	end
end

local AllButtons = {
	{icon = "home", anim_col = Color(180, 180, 180)},
	{icon = "speed_cameras", anim_col = Color(230, 100, 60)},
	{icon = "records", anim_col = Color(60, 200, 80)},
	{icon = "governement", anim_col = Color(60, 160, 220)},
	{icon = "close", anim_col = Color(250, 0, 0)},
}

local function TPRSACopsFrame(speedcameras, records, logs, aimedent)
	local ply = LocalPlayer()
	logs = table.Reverse(logs)

	local EnglishTab, FrenchTab, DiscrTab, EduTab, AvgBTab, AvgETab, StopTab, PedTab, UndefinedTab = {}, {}, {}, {}, {}, {}, {}, {}, {}
	for k,v in pairs(speedcameras) do
		if IsValid(v) then
			local class = v:GetClass()
			if class == "english_speed_camera" then
				table.insert(EnglishTab, v)
			elseif class == "french_speed_camera" then
				table.insert(FrenchTab, v)
			elseif class == "discriminating_camera" then
				table.insert(DiscrTab, v)
			elseif class == "educational_camera" then
				table.insert(EduTab, v)
			elseif class == "average_camera_begin" then
				table.insert(AvgBTab, v)
			elseif class == "average_camera_end" then
				table.insert(AvgETab, v)
			elseif class == "pedestrian_camera" then
				table.insert(PedTab, v)
			elseif class == "stop_camera" then
				table.insert(StopTab, v)
			end
		else
			table.insert(UndefinedTab, v) // Due to clientside non-valid entities
		end
	end

	local idopen = 0

	local randomtab = {}
	for i = 1, 8 do
		randomtab[i] = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255))
	end

	local totalfine, finepaid, bestspeedgap, amountpeople, peopleverif = 0, 0, 0, 0, {}
	for k,v in pairs(records) do
		totalfine = totalfine + v.finetopay
		finepaid = finepaid + v.finepaid
		if v.speed - v.speedlim > bestspeedgap then bestspeedgap = v.speed - v.speedlim end
		if not peopleverif[v.caughtply] then peopleverif[v.caughtply] = true amountpeople = amountpeople + 1 end
	end

	local money_icon, counter_icon = Material("tprsa/money.png"), Material("tprsa/counter.png")
	local white = Color(255, 255, 255)

	local frame = vgui.Create("DFrame")
	frame:SetSize(1200, 700)
	frame:Center()
	frame:SetTitle("")
	frame:SetDraggable(false)
	frame:ShowCloseButton(false)
	frame.Paint = function(s, w, h)
		if Diablos.RS.Colors.Blurs then Derma_DrawBackgroundBlur(s, 1) end
		surface.SetDrawColor(Diablos.RS.Colors.Frame) surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(Diablos.RS.Colors.FrameLeft) surface.DrawRect(0, 0, 110, 700)
		if idopen == 1 then
			surface.SetDrawColor(Diablos.RS.Colors.FrameLeft) surface.DrawRect(120, 20, 1070, 40)
			draw.SimpleText(Diablos.RS.Strings.home, "DiablosRSCopsFont", 655, 40, Diablos.RS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			surface.SetDrawColor(Diablos.RS.Colors.FrameLeft) surface.DrawRect(120, 80, 530, 40)
			draw.SimpleText(Diablos.RS.Strings.camerarepart, "DiablosRSCopsFont", 385, 100, Diablos.RS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			surface.SetDrawColor(Diablos.RS.Colors.FrameLeft) surface.DrawRect(660, 80, 530, 40)
			draw.SimpleText(Diablos.RS.Strings.statistics, "DiablosRSCopsFont", 915, 100, Diablos.RS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			local val_arc = #EnglishTab / #speedcameras * 360
			DiablosDraw.Arc(350, 300, 150, 150, 0, val_arc, 0, randomtab[1])

			DiablosDraw.Arc(350, 300, 150, 150, val_arc, val_arc + #FrenchTab / #speedcameras * 360, 0, randomtab[2])

			val_arc = val_arc + #FrenchTab / #speedcameras * 360
			DiablosDraw.Arc(350, 300, 150, 150, val_arc, val_arc + #DiscrTab / #speedcameras * 360, 0, randomtab[3])
			val_arc = val_arc + #DiscrTab / #speedcameras * 360
			DiablosDraw.Arc(350, 300, 150, 150, val_arc, val_arc + #EduTab / #speedcameras * 360, 0, randomtab[4])
			val_arc = val_arc + #EduTab / #speedcameras * 360
			DiablosDraw.Arc(350, 300, 150, 150, val_arc, val_arc + #AvgBTab / #speedcameras * 360 + #AvgETab / #speedcameras * 360, 0, randomtab[5])
			val_arc = val_arc + #AvgBTab / #speedcameras * 360 + #AvgETab / #speedcameras * 360
			DiablosDraw.Arc(350, 300, 150, 150, val_arc, val_arc + #StopTab / #speedcameras * 360, 0, randomtab[6])
			val_arc = val_arc + #StopTab / #speedcameras * 360
			DiablosDraw.Arc(350, 300, 150, 150, val_arc, val_arc + #PedTab / #speedcameras * 360, 0, randomtab[7])
			val_arc = val_arc + #PedTab / #speedcameras * 360
			DiablosDraw.Arc(350, 300, 150, 150, val_arc, val_arc + #UndefinedTab / #speedcameras * 360, 0, randomtab[8])
			val_arc = val_arc + #UndefinedTab / #speedcameras * 360

			surface.SetDrawColor(white)
			surface.SetMaterial(counter_icon)
			surface.DrawTexturedRect(680, 160, 60, 60)

			draw.SimpleText(Diablos.RS.Strings.thereare .. " " .. #records .. " " .. Diablos.RS.Strings.governementflashes .. "!", "DiablosRSCopsFont", 750, 225, Diablos.RS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(Diablos.RS.Strings.including .. " " .. amountpeople .. " " .. Diablos.RS.Strings.differentpeople .. "!", "DiablosRSCopsFont", 750, 275, Diablos.RS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(bestspeedgap .. " " .. Diablos.RS.MPHKMHText .. " " .. Diablos.RS.Strings.bestgap .. "!", "DiablosRSCopsFont", 750, 325, Diablos.RS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			surface.SetDrawColor(white)
			surface.SetMaterial(money_icon)
			surface.DrawTexturedRect(680, 360, 60, 60)
			draw.SimpleText(GAMEMODE.Config.currency .. finepaid .. " " .. Diablos.RS.Strings.madesincebegin .. "!", "DiablosRSCopsFont", 750, 425, Diablos.RS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(GAMEMODE.Config.currency .. totalfine .. " " .. Diablos.RS.Strings.finetotal .. "!", "DiablosRSCopsFont", 750, 475, Diablos.RS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			local amount = 0
			local xval = 130
			local function AddCaption(text, color, num)
				if num > 0 then
					if amount == 4 then amount = 0 xval = xval + 250 end
					local yval = 480 + (amount * 60)
					surface.SetDrawColor(color)
					surface.DrawRect(xval, yval, 50, 10)
					draw.SimpleText(text, "DiablosRSCopsFont2", xval + 55, yval + 5, Diablos.RS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					amount = amount + 1
				end
			end
			AddCaption(Diablos.RS.Strings.english, randomtab[1], #EnglishTab)
			AddCaption(Diablos.RS.Strings.french, randomtab[2], #FrenchTab)
			AddCaption(Diablos.RS.Strings.discr, randomtab[3], #DiscrTab)
			AddCaption(Diablos.RS.Strings.edu, randomtab[4], #EduTab)
			AddCaption(Diablos.RS.Strings.avg, randomtab[5], #AvgBTab + #AvgETab)
			AddCaption(Diablos.RS.Strings.stop, randomtab[6], #StopTab)
			AddCaption(Diablos.RS.Strings.ped, randomtab[7], #PedTab)
			AddCaption(Diablos.RS.Strings.undefined, randomtab[8], #UndefinedTab)
		elseif idopen == 2 then
			surface.SetDrawColor(Diablos.RS.Colors.FrameLeft) surface.DrawRect(120, 20, 1070, 40)
			draw.SimpleText(Diablos.RS.Strings.speedcameras, "DiablosRSCopsFont", 655, 40, Diablos.RS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			if #speedcameras == 0 then
				draw.SimpleText(Diablos.RS.Strings.nocameras, "DiablosRSCopsFont", 655, 350, Diablos.RS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		elseif idopen == 3 then
			surface.SetDrawColor(Diablos.RS.Colors.FrameLeft) surface.DrawRect(120, 20, 1070, 40)
			draw.SimpleText(Diablos.RS.Strings.globalrecords, "DiablosRSCopsFont", 655, 40, Diablos.RS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(Diablos.RS.Strings.showonly .. ":", "DiablosRSCopsFont", 120, 90, Diablos.RS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			if #records == 0 then
				draw.SimpleText(Diablos.RS.Strings.norecords, "DiablosRSCopsFont", 655, 350, Diablos.RS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		elseif idopen == 4 then
			surface.SetDrawColor(Diablos.RS.Colors.FrameLeft) surface.DrawRect(120, 20, 1070, 40)
			draw.SimpleText(Diablos.RS.Strings.governementlogs, "DiablosRSCopsFont", 655, 40, Diablos.RS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			if #logs == 0 then
				draw.SimpleText(Diablos.RS.Strings.nologs, "DiablosRSCopsFont", 655, 350, Diablos.RS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end

	frame:MakePopup()

	local anim = Derma_Anim("DiablosAnim", frame, function(pnl, anim, delta, data)
		pnl:SetPos(ScrW() / 2 - pnl:GetWide() / 2, ScrH() / 2 - pnl:GetTall() / 2 - 100 + 100 * delta)
	end)
	anim:Start(1)
	frame.Think = function()
		if anim:Active() then
			anim:Run()
		end
	end

	local scrollframe = vgui.Create("DScrollPanel", frame)
	scrollframe:SetPos(0, 10)
	scrollframe:SetSize(110, 690)

	local scrollframevbar = scrollframe:GetVBar()

	scrollframevbar.Paint = function(s, w, h)
		draw.RoundedBox(4, 5, 0, 10, h, Diablos.RS.Colors.VBarBG)
	end
	
	scrollframevbar.btnGrip.Paint = function(s, w, h)
		draw.RoundedBox(8, 5, 0, 10, h, Diablos.RS.Colors.VBarGrip)
	end
	
	scrollframevbar.btnUp.Paint = function(s, w, h) end
	scrollframevbar.btnDown.Paint = function(s, w, h) end

	local function RenderSpeedCamera(ent)
		local class = ent:GetClass()
		local infos = RenderRadarInfos[class]
		local discri = class == "discriminating_camera"
		local edu = class == "educational_camera"
		local stop_ped = class == "stop_camera" or class == "pedestrian_camera"
		local classic = class == "english_speed_camera" or class == "french_speed_camera"
		local avgb = class == "average_camera_begin"
		local avge = class == "average_camera_end"

		local k = 0

		local secframe = vgui.Create("DFrame")
		secframe:SetSize(1000, 700)
		secframe:Center()
		secframe:SetTitle("")
		secframe:SetDraggable(false)
		secframe:ShowCloseButton(false)
		secframe.Paint = function(s, w, h)
			if Diablos.RS.Colors.Blurs then Derma_DrawBackgroundBlur(s, 1) end
			surface.SetDrawColor(Diablos.RS.Colors.Frame) surface.DrawRect(0, 0, w, h)
		end

		secframe:MakePopup()

		local secpanel = vgui.Create("DPanel", secframe)
		secpanel:SetPos(0, 0)
		secpanel:SetSize(1000, 700)
		secpanel.Paint = function(s, w, h)
			if IsValid(ent) then
				local x, y = secframe:GetPos()
				local theorigin = ent:GetPos() + ent:GetForward() * infos.f + ent:GetUp() * infos.u + ent:GetRight() * infos.r
				render.RenderView( {
					origin = theorigin,
					angles = ent:GetAngles() + Angle(20, 140, 0),
					x = x, y = y,
					w = w, h = h
				} )

				surface.SetDrawColor(Diablos.RS.Colors.FrameLeft) surface.DrawRect(0, 350, 300, 350)
				
				if classic or avgb then
					draw.SimpleText(Diablos.RS.Strings.speedlimit .. ": ", "DiablosRSCopsDigiFont", 200, 375, Diablos.RS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
					draw.SimpleText(Diablos.RS.Strings.fineprice .. ": ", "DiablosRSCopsDigiFont", 200, 425, Diablos.RS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				elseif discri then
					draw.SimpleText(Diablos.RS.Strings.speedlimit .. " (" .. Diablos.RS.Strings.vehs .. "): ", "DiablosRSCopsDigiFont", 200, 375, Diablos.RS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
					draw.SimpleText(Diablos.RS.Strings.speedlimit .. " (" .. Diablos.RS.Strings.trucks .. "): ", "DiablosRSCopsDigiFont", 200, 425, Diablos.RS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
					draw.SimpleText(Diablos.RS.Strings.fineprice .. ": ", "DiablosRSCopsDigiFont", 200, 475, Diablos.RS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				elseif avge then
					draw.SimpleText(Diablos.RS.Strings.avgblink .. ": ", "DiablosRSCopsDigiFont", 200, 375, Diablos.RS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
					draw.SimpleText(Diablos.RS.Strings.distbegin .. ": ", "DiablosRSCopsDigiFont", 200, 425, Diablos.RS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				elseif stop_ped then
					draw.SimpleText(Diablos.RS.Strings.fineprice .. ": ", "DiablosRSCopsDigiFont", 200, 375, Diablos.RS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
					draw.SimpleText(Diablos.RS.Strings.axisx .. ": ", "DiablosRSCopsDigiFont", 200, 425, Diablos.RS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				end
				
				if stop_ped or edu then
					draw.SimpleText(Diablos.RS.Strings.roadside .. ": ", "DiablosRSCopsDigiFont", 200, 375 + k * 50 + 50, Diablos.RS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
					if edu then
						draw.SimpleText(Diablos.RS.Strings.speedlimit .. ": ", "DiablosRSCopsDigiFont", 200, 375, Diablos.RS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
						draw.SimpleText(Diablos.RS.Strings.distdetect .. ": ", "DiablosRSCopsDigiFont", 200, 425, Diablos.RS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
					end
				else
					draw.SimpleText(Diablos.RS.Strings.frontroad .. ": ", "DiablosRSCopsDigiFont", 200, 375 + k * 50 + 50, Diablos.RS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				end
				draw.SimpleText(Diablos.RS.Strings.owner .. ": ", "DiablosRSCopsDigiFont", 150, 375 + k * 50, Diablos.RS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				draw.SimpleText(Diablos.RS.Strings.length .. ": ", "DiablosRSCopsDigiFont", 200, 375 + k * 50 + 100, Diablos.RS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			end
		end

		local seccancel = vgui.Create("DButton", secframe)
		seccancel:SetPos(350, 675)
		seccancel:SetSize(300, 20)
		seccancel:SetFont("DiablosRSClientHUDBigFont1")
		seccancel:SetText(Diablos.RS.Strings.close)
		seccancel.DoClick = function()
			secframe:Close()
			ply.DrawVisible = true
		end
		seccancel.Paint = function(s, w, h)
			DiablosRSPaintButtons(s)
		end

		local speedlimit, fineprice, speedlimit_veh, speedlimit_truck, distance, axisx
		if classic or avgb then
			speedlimit = vgui.Create("DNumberWang", secframe)
			speedlimit:SetPos(195, 355)
			speedlimit:SetSize(100, 40)
			speedlimit:SetFont("DiablosRSCopsDigiFont")
			speedlimit:SetValue(ent:GetSpeedLimit())
			speedlimit:SetTooltip(Diablos.RS.Strings.valuebetween .. " " .. Diablos.RS.MinSpeedLimit .. " " .. Diablos.RS.Strings.andtxt .. " " .. Diablos.RS.MaxSpeedLimit .. ".")
			speedlimit:HideWang()
			speedlimit.Paint = function(s, w, h)
				surface.SetDrawColor(Diablos.RS.FrameBasicColors.rndbox) surface.DrawRect(0, 0, w, h)
				s:DrawTextEntryText(Diablos.RS.Colors.Label, Diablos.RS.Colors.LabelHovered, Diablos.RS.Colors.LabelDown)
			end

			fineprice = vgui.Create("DNumberWang", secframe)
			fineprice:SetPos(195, 405)
			fineprice:SetSize(100, 40)
			fineprice:SetFont("DiablosRSCopsDigiFont")
			fineprice:SetMinMax(0, 65535)
			fineprice:SetValue(ent:GetFinePrice())
			fineprice:SetTooltip(Diablos.RS.Strings.valuebetween .. " " .. Diablos.RS.MinFinePrice .. " " .. Diablos.RS.Strings.andtxt .. " " .. Diablos.RS.MaxFinePrice .. ".")
			fineprice:HideWang()
			fineprice.Paint = function(s, w, h)
				surface.SetDrawColor(Diablos.RS.FrameBasicColors.rndbox) surface.DrawRect(0, 0, w, h)
				s:DrawTextEntryText(Diablos.RS.Colors.Label, Diablos.RS.Colors.LabelHovered, Diablos.RS.Colors.LabelDown)
			end
			k = 2
		elseif discri then
			speedlimit_veh = vgui.Create("DNumberWang", secframe)
			speedlimit_veh:SetPos(195, 355)
			speedlimit_veh:SetSize(100, 40)
			speedlimit_veh:SetFont("DiablosRSCopsDigiFont")
			speedlimit_veh:SetValue(ent:GetSpeedLimitVeh())
			speedlimit_veh:SetTooltip(Diablos.RS.Strings.valuebetween .. " " .. Diablos.RS.MinSpeedLimit .. " " .. Diablos.RS.Strings.andtxt .. " " .. Diablos.RS.MaxSpeedLimit .. ".")
			speedlimit_veh:HideWang()
			speedlimit_veh.Paint = function(s, w, h)
				surface.SetDrawColor(Diablos.RS.FrameBasicColors.rndbox) surface.DrawRect(0, 0, w, h)
				s:DrawTextEntryText(Diablos.RS.Colors.Label, Diablos.RS.Colors.LabelHovered, Diablos.RS.Colors.LabelDown)
			end

			speedlimit_truck = vgui.Create("DNumberWang", secframe)
			speedlimit_truck:SetPos(195, 405)
			speedlimit_truck:SetSize(100, 40)
			speedlimit_truck:SetFont("DiablosRSCopsDigiFont")
			speedlimit_truck:SetValue(ent:GetSpeedLimitTruck())
			speedlimit_truck:SetTooltip(Diablos.RS.Strings.valuebetween .. " " .. Diablos.RS.MinSpeedLimit .. " " .. Diablos.RS.Strings.andtxt .. " " .. Diablos.RS.MaxSpeedLimit .. ".")
			speedlimit_truck:HideWang()
			speedlimit_truck.Paint = function(s, w, h)
				surface.SetDrawColor(Diablos.RS.FrameBasicColors.rndbox) surface.DrawRect(0, 0, w, h)
				s:DrawTextEntryText(Diablos.RS.Colors.Label, Diablos.RS.Colors.LabelHovered, Diablos.RS.Colors.LabelDown)
			end

			fineprice = vgui.Create("DNumberWang", secframe)
			fineprice:SetPos(195, 455)
			fineprice:SetSize(100, 40)
			fineprice:SetFont("DiablosRSCopsDigiFont")
			fineprice:SetMinMax(0, 65535)
			fineprice:SetValue(ent:GetFinePrice())
			fineprice:SetTooltip(Diablos.RS.Strings.valuebetween .. " " .. Diablos.RS.MinFinePrice .. " " .. Diablos.RS.Strings.andtxt .. " " .. Diablos.RS.MaxFinePrice .. ".")
			fineprice:HideWang()
			fineprice.Paint = function(s, w, h)
				surface.SetDrawColor(Diablos.RS.FrameBasicColors.rndbox) surface.DrawRect(0, 0, w, h)
				s:DrawTextEntryText(Diablos.RS.Colors.Label, Diablos.RS.Colors.LabelHovered, Diablos.RS.Colors.LabelDown)
			end
			k = 3
		elseif edu then
			speedlimit = vgui.Create("DNumberWang", secframe)
			speedlimit:SetPos(195, 355)
			speedlimit:SetSize(100, 40)
			speedlimit:SetFont("DiablosRSCopsDigiFont")
			speedlimit:SetValue(ent:GetSpeedLimit())
			speedlimit:SetTooltip(Diablos.RS.Strings.valuebetween .. " " .. Diablos.RS.MinSpeedLimit .. " " .. Diablos.RS.Strings.andtxt .. " " .. Diablos.RS.MaxSpeedLimit .. ".")
			speedlimit:HideWang()
			speedlimit.Paint = function(s, w, h)
				surface.SetDrawColor(Diablos.RS.FrameBasicColors.rndbox) surface.DrawRect(0, 0, w, h)
				s:DrawTextEntryText(Diablos.RS.Colors.Label, Diablos.RS.Colors.LabelHovered, Diablos.RS.Colors.LabelDown)
			end

			distance = vgui.Create("DNumberWang", secframe)
			distance:SetPos(195, 405)
			distance:SetSize(100, 40)
			distance:SetFont("DiablosRSCopsDigiFont")
			distance:SetValue(ent:GetDistanceRadar())
			distance:HideWang()
			distance.Paint = function(s, w, h)
				surface.SetDrawColor(Diablos.RS.FrameBasicColors.rndbox) surface.DrawRect(0, 0, w, h)
				s:DrawTextEntryText(Diablos.RS.Colors.Label, Diablos.RS.Colors.LabelHovered, Diablos.RS.Colors.LabelDown)
			end
			k = 2
		elseif avge then
			local avgblink = vgui.Create("DButton", secframe)
			avgblink:SetPos(195, 355)
			avgblink:SetSize(100, 40)
			avgblink:SetText(Diablos.RS.Strings.view)
			avgblink:SetFont("DiablosRSCopsDigiFont")
			avgblink.DoClick = function(s)
				if IsValid(ent:GetAverageBegin()) then
					RenderSpeedCamera(ent:GetAverageBegin())
				end
			end
			avgblink.Paint = function(s, w, h)
				surface.SetDrawColor(Diablos.RS.FrameBasicColors.rndbox) surface.DrawRect(0, 0, w, h)
				DiablosRSPaintButtons(s)
			end

			distance = vgui.Create("DNumberWang", secframe)
			distance:SetPos(195, 405)
			distance:SetSize(100, 40)
			distance:SetMinMax(0, 65535)
			distance:SetFont("DiablosRSCopsDigiFont")
			distance:SetValue(ent:GetDistanceRadar())
			distance:HideWang()
			distance.Paint = function(s, w, h)
				surface.SetDrawColor(Diablos.RS.FrameBasicColors.rndbox) surface.DrawRect(0, 0, w, h)
				s:DrawTextEntryText(Diablos.RS.Colors.Label, Diablos.RS.Colors.LabelHovered, Diablos.RS.Colors.LabelDown)
			end
			k = 2
		elseif stop_ped then
			fineprice = vgui.Create("DNumberWang", secframe)
			fineprice:SetPos(195, 355)
			fineprice:SetSize(100, 40)
			fineprice:SetFont("DiablosRSCopsDigiFont")
			fineprice:SetMinMax(0, 65535)
			fineprice:SetValue(ent:GetFinePrice())
			fineprice:SetTooltip(Diablos.RS.Strings.valuebetween .. " " .. Diablos.RS.MinFinePrice .. " " .. Diablos.RS.Strings.andtxt .. " " .. Diablos.RS.MaxFinePrice .. ".")
			fineprice:HideWang()
			fineprice.Paint = function(s, w, h)
				surface.SetDrawColor(Diablos.RS.FrameBasicColors.rndbox) surface.DrawRect(0, 0, w, h)
				s:DrawTextEntryText(Diablos.RS.Colors.Label, Diablos.RS.Colors.LabelHovered, Diablos.RS.Colors.LabelDown)
			end

			axisx = vgui.Create("DNumberWang", secframe)
			axisx:SetPos(195, 405)
			axisx:SetSize(100, 40)
			axisx:SetFont("DiablosRSCopsDigiFont")
			axisx:SetMinMax(-2048, 2048)
			axisx:SetValue(ent:GetAxisXRadar())
			axisx:HideWang()
			axisx.Paint = function(s, w, h)
				surface.SetDrawColor(Diablos.RS.FrameBasicColors.rndbox) surface.DrawRect(0, 0, w, h)
				s:DrawTextEntryText(Diablos.RS.Colors.Label, Diablos.RS.Colors.LabelHovered, Diablos.RS.Colors.LabelDown)
			end
			k = 2
		end

		local coplist = vgui.Create("DComboBox", secframe)
		coplist:SetPos(145, 355 + k * 50)
		coplist:SetSize(150, 40)
		coplist:SetTextColor(Diablos.RS.Colors.Label)
		coplist:SetFont("DiablosRSCopsDigiFont")
		coplist:AddChoice("<" .. string.upper(Diablos.RS.Strings.server) .. ">", nil)
		coplist:ChooseOptionID(1)
		for k,v in pairs(player.GetAll()) do
			if IsValid(v) then
				coplist:AddChoice(v:Nick(), v)
				if IsValid(ent:Getowning_ent()) and v == ent:Getowning_ent() then coplist:ChooseOptionID(k+1) end
			end
		end
		coplist:SetTooltip(Diablos.RS.Strings.ownerrisk)
		coplist.Paint = function(s, w, h)
			surface.SetDrawColor(Diablos.RS.FrameBasicColors.rndbox) surface.DrawRect(0, 0, w, h)
			s:DrawTextEntryText(Diablos.RS.Colors.Label, Diablos.RS.Colors.LabelHovered, Diablos.RS.Colors.LabelDown)
		end

		local frontroad = vgui.Create("DComboBox", secframe)
		frontroad:SetPos(195, 355 + k * 50 + 50)
		frontroad:SetSize(100, 40)
		frontroad:SetTextColor(Diablos.RS.Colors.Label)
		frontroad:SetFont("DiablosRSCopsDigiFont")
		if stop_ped or edu then
			frontroad:AddChoice(Diablos.RS.Strings.rightroad, 0)
			frontroad:AddChoice(Diablos.RS.Strings.leftroad, 1)
			frontroad:SetTooltip(Diablos.RS.Strings.roadsidetip)
		else
			frontroad:AddChoice(Diablos.RS.Strings.falseroad, 0)
			frontroad:AddChoice(Diablos.RS.Strings.trueroad, 1)
			frontroad:SetTooltip(Diablos.RS.Strings.frontroadtip)
		end
		if ent:GetRoadRadar() then frontroad:ChooseOptionID(2) else frontroad:ChooseOptionID(1) end

		frontroad.Paint = function(s, w, h)
			surface.SetDrawColor(Diablos.RS.FrameBasicColors.rndbox) surface.DrawRect(0, 0, w, h)
			s:DrawTextEntryText(Diablos.RS.Colors.Label, Diablos.RS.Colors.LabelHovered, Diablos.RS.Colors.LabelDown)
		end

		local length = vgui.Create("DNumberWang", secframe)
		length:SetPos(195, 355 + k * 50 + 100)
		length:SetSize(100, 40)
		length:SetFont("DiablosRSCopsDigiFont")
		length:SetValue(ent:GetLengthRadar())
		length:SetTooltip(Diablos.RS.Strings.valuebetween .. " 1 " .. Diablos.RS.Strings.andtxt .. " 8.")
		length:HideWang()
		length.Paint = function(s, w, h)
			surface.SetDrawColor(Diablos.RS.FrameBasicColors.rndbox) surface.DrawRect(0, 0, w, h)
			s:DrawTextEntryText(Diablos.RS.Colors.Label, Diablos.RS.Colors.LabelHovered, Diablos.RS.Colors.LabelDown)
		end

		if (IsValid(ent:Getowning_ent()) and ent:Getowning_ent() == ply) or (not IsValid(ent:Getowning_ent()) and Diablos.RS.OwnServerCameras) then
			local saveparameters = vgui.Create("DButton", secframe)
			saveparameters:SetPos(50, 665)
			saveparameters:SetSize(200, 30)
			saveparameters:SetFont("DiablosRSClientHUDBigFont1")
			saveparameters:SetText(Diablos.RS.Strings.save)
			saveparameters.DoClick = function()
				secframe:Close()
				local speedval, fineval, speedval_veh, speedval_truck, distanceval, axisxval = 0, 0, 0, 0, 0, 0
				if ispanel(speedlimit) then speedval = speedlimit:GetValue() end
				if ispanel(fineprice) then fineval = fineprice:GetValue() end
				if ispanel(speedlimit_veh) then speedval_veh = speedlimit_veh:GetValue() end
				if ispanel(speedlimit_truck) then speedval_truck = speedlimit_truck:GetValue() end
				if ispanel(distance) then distanceval = distance:GetValue() end
				if ispanel(axisx) then axisxval = axisx:GetValue() end
				local noneed, owner = coplist:GetSelected()
				local noneed, road = frontroad:GetSelected()
				local lengthval = length:GetValue()
				net.Start("TPRSA:RefreshRadarInfos")
					net.WriteEntity(ent)
					net.WriteUInt(speedval, 8)
					net.WriteInt(fineval, 16)
					net.WriteUInt(speedval_veh, 8)
					net.WriteUInt(speedval_truck, 8)
					net.WriteInt(distanceval, 16)
					net.WriteInt(axisxval, 12)
					net.WriteEntity(owner)
					net.WriteBit(road)
					net.WriteUInt(lengthval, 4)
				net.SendToServer()
				-- if IsValid(frame) then
				-- 	frame:Close()
				-- end
			end
			saveparameters.Paint = function(s, w, h)
				surface.SetDrawColor(Diablos.RS.Colors.Label) surface.DrawRect(0, 0, w, h)
				surface.SetDrawColor(Diablos.RS.Colors.LabelHovered) surface.DrawRect(1, 1, w-2, h-2)
				DiablosRSPaintButtons(s)
			end
		end
	end

	local function SortInfos(parentPanel, isSorted, tab)
		if tab == speedcameras then for k,v in pairs(parentPanel:GetChildren()) do if IsValid(v) then v:Remove() end end end
		-- tab argument is useful when trying to sort things since it's recursive
		
		if isSorted then

			local function WriteCategory(label)
				local panel = parentPanel:Add("DPanel")
				panel:SetSize(parentPanel:GetWide(), 40)
				panel.Paint = function(s, w, h)
					surface.SetDrawColor(Diablos.RS.Colors.FrameLeft) surface.DrawRect(320, 0, 430, h)
					draw.SimpleText(label, "DiablosRSCopsFont", w / 2, 20, Diablos.RS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
				panel.OwnLine = true
			end

			if #EnglishTab > 0 then WriteCategory(Diablos.RS.Strings.english) SortInfos(parentPanel, false, EnglishTab) end
			if #FrenchTab > 0 then WriteCategory(Diablos.RS.Strings.french) SortInfos(parentPanel, false, FrenchTab) end
			if #DiscrTab > 0 then WriteCategory(Diablos.RS.Strings.discr) SortInfos(parentPanel, false, DiscrTab) end
			if #EduTab > 0 then WriteCategory(Diablos.RS.Strings.edu) SortInfos(parentPanel, false, EduTab) end
			if #AvgBTab > 0 then WriteCategory(Diablos.RS.Strings.avg .. " - " .. Diablos.RS.Strings.beginavg) SortInfos(parentPanel, false, AvgBTab) end
			if #AvgETab > 0 then WriteCategory(Diablos.RS.Strings.avg .. " - " .. Diablos.RS.Strings.endavg) SortInfos(parentPanel, false, AvgETab) end
			if #PedTab > 0 then WriteCategory(Diablos.RS.Strings.ped) SortInfos(parentPanel, false, PedTab) end
			if #StopTab > 0 then WriteCategory(Diablos.RS.Strings.stop) SortInfos(parentPanel, false, StopTab) end
		else
			for k,v in pairs(tab) do
				if IsValid(v) then
					local panel = parentPanel:Add("DPanel")
					panel:SetSize(100, 100)
					panel.Paint = function(s, w, h)
					end

					local model = vgui.Create("SpawnIcon", panel)
					model:Dock(FILL)
					model:SetModel(v:GetModel())
					model.OnCursorEntered = function() end
					model.OnCursorExited = function() end
					model.DoClick = function(s)
						RenderSpeedCamera(v)
						ply.DrawVisible = false
					end
				end
			end
		end
	end

	local scrollframef, bytype, dontsort, filternotpaid, filtermyrecords
	local function SpeedCameras()

		scrollframef = vgui.Create("DScrollPanel", frame)
		scrollframef:SetPos(120, 120)
		scrollframef:SetSize(1070, 570)

		local scrollframefvbar = scrollframef:GetVBar()

		scrollframefvbar.Paint = function(s, w, h) end
		
		scrollframefvbar.btnGrip.Paint = function(s, w, h)
			draw.RoundedBox(8, 5, 0, 10, h, Diablos.RS.Colors.VBarGrip)
		end
		
		scrollframefvbar.btnUp.Paint = function(s, w, h) end
		scrollframefvbar.btnDown.Paint = function(s, w, h) end

		local layoutframef = vgui.Create("DIconLayout", scrollframef)
		layoutframef:SetPos(0, 0)
		layoutframef:SetSize(1070, 570)
		layoutframef:SetSpaceX(10)
		layoutframef:SetSpaceY(10)

		bytype = vgui.Create("DButton", frame)
		bytype:SetText(Diablos.RS.Strings.sorttype)
		bytype:SetFont("DiablosRSCopsFont")
		bytype:SetPos(120, 70)
		bytype:SetSize(520, 40)
		bytype.Paint = function(s, w, h)
			surface.SetDrawColor(Diablos.RS.Colors.FrameLeft) surface.DrawRect(0, 0, w, h)
			DiablosRSPaintButtons(s)
		end
		bytype.DoClick = function(s)
			SortInfos(layoutframef, true, speedcameras)
		end

		dontsort = vgui.Create("DButton", frame)
		dontsort:SetText(Diablos.RS.Strings.dontsort)
		dontsort:SetFont("DiablosRSCopsFont")
		dontsort:SetPos(670, 70)
		dontsort:SetSize(520, 40)
		dontsort.Paint = function(s, w, h)
			surface.SetDrawColor(Diablos.RS.Colors.FrameLeft) surface.DrawRect(0, 0, w, h)
			DiablosRSPaintButtons(s)
		end
		dontsort.DoClick = function(s)
			SortInfos(layoutframef, false, speedcameras)
		end

		SortInfos(layoutframef, true, speedcameras) -- default state
	end

	local function Records()
		local filter1, filter2 = false, false
		local temprecords
		
		scrollframef = vgui.Create("DScrollPanel", frame)
		scrollframef:SetPos(120, 120)
		scrollframef:SetSize(1070, 570)

		local scrollframefvbar = scrollframef:GetVBar()

		scrollframefvbar.Paint = function(s, w, h) end
		
		scrollframefvbar.btnGrip.Paint = function(s, w, h)
			draw.RoundedBox(8, 5, 0, 10, h, Diablos.RS.Colors.VBarGrip)
		end
		
		scrollframefvbar.btnUp.Paint = function(s, w, h) end
		scrollframefvbar.btnDown.Paint = function(s, w, h) end

		local function RefreshView(tab)
			scrollframef:Clear()

			for k,v in pairs(tab) do
				local vehname = list.Get("Vehicles")[v.veh].Name
				local vehmodel = list.Get("Vehicles")[v.veh].Model

				local panel = vgui.Create("DPanel", scrollframef)
				panel:SetPos(0, 210 * (k - 1))
				panel:SetSize(1055, 200)
				panel.Paint = function(s, w, h)
					surface.SetDrawColor(Diablos.RS.Colors.FrameLeft) surface.DrawRect(0, 0, w, h)
					local sizextot = 0
					surface.SetFont("DiablosRSCopsFont")

					local caughtplynick = Diablos.RS.Strings.disconnected
					if IsValid(v.caughtply) then caughtplynick = v.caughtply:Nick() end

					local sizex, sizey = surface.GetTextSize(caughtplynick)
					sizextot = sizextot + sizex
					draw.SimpleText(caughtplynick, "DiablosRSCopsFont", 5, 5, Diablos.RS.FrameBasicColors.bl)

					if v.speed == 0 then
						
						if IsValid(v.ent) then
							local label
							if v.ent:GetClass() == "pedestrian_camera" then
								label = string.lower(Diablos.RS.Strings.pedestrian)
							elseif v.ent:GetClass() == "stop_camera" then
								label = string.lower(Diablos.RS.Strings.stop)
							end
							sizex, sizey = surface.GetTextSize(" " .. Diablos.RS.Strings.takenby .. " " .. label)
							draw.SimpleText(" " .. Diablos.RS.Strings.takenby .. " " .. label, "DiablosRSCopsFont", 5 + sizextot, 5, Diablos.RS.Colors.Label)
							sizextot = sizextot + sizex
							draw.SimpleText(".", "DiablosRSCopsFont", 5 + sizextot, 5, Diablos.RS.Colors.Label)
						end
					else
						sizex, sizey = surface.GetTextSize(" " .. Diablos.RS.Strings.hasbeentaken .. " ")
						draw.SimpleText(" " .. Diablos.RS.Strings.hasbeentaken .. " ", "DiablosRSCopsFont", 5 + sizextot, 5, Diablos.RS.Colors.Label)
						sizextot = sizextot + sizex
						
						sizex, sizey = surface.GetTextSize(v.speed .. Diablos.RS.MPHKMHText)
						draw.SimpleText(v.speed .. Diablos.RS.MPHKMHText, "DiablosRSCopsFont", 5 + sizextot, 5, Diablos.RS.FrameBasicColors.rl)
						sizextot = sizextot + sizex	

						sizex, sizey = surface.GetTextSize(" " .. Diablos.RS.Strings.insteadof .. " ")
						draw.SimpleText(" " .. Diablos.RS.Strings.insteadof .. " ", "DiablosRSCopsFont", 5 + sizextot, 5, Diablos.RS.Colors.Label)
						sizextot = sizextot + sizex	

						sizex, sizey = surface.GetTextSize(v.speedlim .. Diablos.RS.MPHKMHText)
						draw.SimpleText(v.speedlim .. Diablos.RS.MPHKMHText, "DiablosRSCopsFont", 5 + sizextot, 5, Diablos.RS.FrameBasicColors.gl)
						sizextot = sizextot + sizex
						draw.SimpleText(".", "DiablosRSCopsFont", 5 + sizextot, 5, Diablos.RS.Colors.Label)
					end

					sizextot = 0 -- \n

					sizex, sizey = surface.GetTextSize(Diablos.RS.Strings.finepricewas .. " ")
					sizextot = sizextot + sizex
					draw.SimpleText(Diablos.RS.Strings.finepricewas .. " ", "DiablosRSCopsFont", 5, 55, Diablos.RS.Colors.Label)

					sizex, sizey = surface.GetTextSize(GAMEMODE.Config.currency .. v.finetopay)
					draw.SimpleText(GAMEMODE.Config.currency .. v.finetopay, "DiablosRSCopsFont", 5 + sizextot, 55, Diablos.RS.FrameBasicColors.rl)
					sizextot = sizextot + sizex

					sizex, sizey = surface.GetTextSize(" " .. Diablos.RS.Strings.amountpaid .. " ")
					draw.SimpleText(" " .. Diablos.RS.Strings.amountpaid .. " ", "DiablosRSCopsFont", 5 + sizextot, 55, Diablos.RS.Colors.Label)
					sizextot = sizextot + sizex
					

					sizex, sizey = surface.GetTextSize(GAMEMODE.Config.currency .. v.finepaid)
					
					local tempcol = Diablos.RS.FrameBasicColors.rl
					if v.finetopay == v.finepaid then tempcol = Diablos.RS.FrameBasicColors.gl end
					draw.SimpleText(GAMEMODE.Config.currency .. v.finepaid, "DiablosRSCopsFont", 5 + sizextot, 55, tempcol)
					sizextot = sizextot + sizex
					draw.SimpleText(".", "DiablosRSCopsFont", 5 + sizextot, 55, Diablos.RS.Colors.Label)

					sizextot = 0

					sizex, sizey = surface.GetTextSize(Diablos.RS.Strings.vehtxt .. ": ")
					sizextot = sizextot + sizex
					draw.SimpleText(Diablos.RS.Strings.vehtxt .. ": ", "DiablosRSCopsFont2", 5, 105, Diablos.RS.Colors.Label, TEXT_ALIGN_LEFT)

					sizex, sizey = surface.GetTextSize(vehname)
					draw.SimpleText(vehname, "DiablosRSCopsFont2", 5, 125, Diablos.RS.FrameBasicColors.gl, TEXT_ALIGN_LEFT)

					draw.SimpleText(Diablos.RS.Strings.taker .. ": ", "DiablosRSCopsFont2", w - 5, 105, Diablos.RS.Colors.Label, TEXT_ALIGN_RIGHT)
					local takerent = ""
					if IsValid(v.ply) then takerent = ply:Nick() elseif IsValid(v.ent) then takerent = Diablos.RS.Strings.speedcamera end
					draw.SimpleText(takerent, "DiablosRSCopsFont2", w - 5, 125, Diablos.RS.FrameBasicColors.gl, TEXT_ALIGN_RIGHT)
					

					draw.SimpleText(v.date, "DiablosRSCopsFont2", w - 5, h - 5, Diablos.RS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
				end

				local vehicon = vgui.Create("DModelPanel", panel)
				vehicon:SetPos(300, 90)
				vehicon:SetSize(200, 100)
				vehicon:SetModel(vehmodel)
				vehicon:SetFOV(100)

				if IsValid(v.ent) then
					local viewcamera = vgui.Create("DButton", panel)
					viewcamera:SetPos(555, 120)
					viewcamera:SetSize(200, 70)
					viewcamera:SetFont("DiablosRSClientHUDBigFont1")
					viewcamera:SetText(Diablos.RS.Strings.view)
					viewcamera.DoClick = function()
						RenderSpeedCamera(v.ent)
						ply.DrawVisible = false
					end
					viewcamera.Paint = function(s, w, h)
						surface.SetDrawColor(Diablos.RS.Colors.Label) surface.DrawRect(0, 0, w, h)
						surface.SetDrawColor(Diablos.RS.Colors.LabelHovered) surface.DrawRect(1, 1, w-2, h-2)
						DiablosRSPaintButtons(s)
					end
				end
			end
		end

		local function FilterRecords()
			temprecords = table.Copy(records)
			for i = #temprecords, 1, -1 do
				local v = temprecords[i]
				if filter1 then
					if v.finetopay == v.finepaid then 
						table.remove(temprecords, i)
					end
				end
				if filter2 then
					if (IsValid(v.ply) and v.ply != ply) or (IsValid(v.ent) and v.ent:Getowning_ent() != ply) then
						table.remove(temprecords, i)
					end
				end
			end
			temprecords = table.Reverse(temprecords)
			RefreshView(temprecords)
		end

		filternotpaid = vgui.Create("DButton", frame)
		filternotpaid:SetText(Diablos.RS.Strings.finesnotpaid)
		filternotpaid:SetFont("DiablosRSCopsFont")
		filternotpaid:SetPos(320, 70)
		filternotpaid:SetSize(420, 40)
		filternotpaid.Paint = function(s, w, h)
			surface.SetDrawColor(Diablos.RS.Colors.FrameLeft) surface.DrawRect(0, 0, w, h)
			if filter1 then
				s:SetTextColor(Diablos.RS.Colors.LabelHovered)
			else
				s:SetTextColor(Diablos.RS.Colors.Label)
			end
		end
		filternotpaid.DoClick = function(s)
			filter1 = !filter1
			FilterRecords()
		end

		filtermyrecords = vgui.Create("DButton", frame)
		filtermyrecords:SetText(Diablos.RS.Strings.myrecords)
		filtermyrecords:SetFont("DiablosRSCopsFont")
		filtermyrecords:SetPos(770, 70)
		filtermyrecords:SetSize(420, 40)
		filtermyrecords.Paint = function(s, w, h)
			surface.SetDrawColor(Diablos.RS.Colors.FrameLeft) surface.DrawRect(0, 0, w, h)
			if filter2 then
				s:SetTextColor(Diablos.RS.Colors.LabelHovered)
			else
				s:SetTextColor(Diablos.RS.Colors.Label)
			end
		end
		filtermyrecords.DoClick = function(s)
			filter2 = !filter2
			FilterRecords()
		end

		FilterRecords()
	end

	local function Governement()
		scrollframef = vgui.Create("DScrollPanel", frame)
		scrollframef:SetPos(120, 80)
		scrollframef:SetSize(1070, 570)

		local scrollframefvbar = scrollframef:GetVBar()

		scrollframefvbar.Paint = function(s, w, h) end
		
		scrollframefvbar.btnGrip.Paint = function(s, w, h)
			draw.RoundedBox(8, 5, 0, 10, h, Diablos.RS.Colors.VBarGrip)
		end
		
		scrollframefvbar.btnUp.Paint = function(s, w, h) end
		scrollframefvbar.btnDown.Paint = function(s, w, h) end

		for k,v in pairs(logs) do
			local ent = v.logent
			if IsValid(ent) then
				local class = ent:GetClass()

				local valuechanged = {}
				if v.speed then table.insert(valuechanged, Diablos.RS.Strings.speedlimit) end
				if v.fine then table.insert(valuechanged, Diablos.RS.Strings.fineprice) end
				if v.speedveh then table.insert(valuechanged, Diablos.RS.Strings.speedlimit .. " (" .. Diablos.RS.Strings.vehs .. ")") end
				if v.speedtruck then table.insert(valuechanged, Diablos.RS.Strings.speedlimit .. " (" .. Diablos.RS.Strings.trucks .. ")") end
				if v.distance then if class == "educational_camera" then table.insert(valuechanged, Diablos.RS.Strings.distdetect) elseif class == "average_camera_end" then table.insert(valuechanged, Diablos.RS.Strings.distbegin) end end
				if v.axis then table.insert(valuechanged, Diablos.RS.Strings.axisx) end
				if v.owner then table.insert(valuechanged, Diablos.RS.Strings.owner) end
				if v.road then if class == "educational_camera" or class == "pedestrian_camera" or class == "stop_camera" then table.insert(valuechanged, Diablos.RS.Strings.roadside) else table.insert(valuechanged, Diablos.RS.Strings.frontroad) end end
				if v.length then table.insert(valuechanged, Diablos.RS.Strings.length) end

				local panel = vgui.Create("DPanel", scrollframef)
				panel:SetPos(0, 110 * (k - 1))
				panel:SetSize(1055, 100)
				panel.Paint = function(s, w, h)
					surface.SetDrawColor(Diablos.RS.Colors.FrameLeft) surface.DrawRect(0, 0, w, h)
					local sizextot = 0
					surface.SetFont("DiablosRSCopsFont")

					local logownernick = Diablos.RS.Strings.disconnected
					if IsValid(v.logowner) then logownernick = v.logowner:Nick() end

					local sizex, sizey = surface.GetTextSize(logownernick)
					sizextot = sizextot + sizex
					draw.SimpleText(logownernick, "DiablosRSCopsFont", 5, 5, Diablos.RS.FrameBasicColors.bl)

					sizex, sizey = surface.GetTextSize(" " .. Diablos.RS.Strings.changed .. ": ")
					draw.SimpleText(" " .. Diablos.RS.Strings.changed .. ": ", "DiablosRSCopsFont", 5 + sizextot, 5, Diablos.RS.Colors.Label)
					
					sizex, sizey = surface.GetTextSize(table.concat(valuechanged, ", "))
					draw.SimpleText(table.concat(valuechanged, ", "), "DiablosRSCopsFont", 5, 55, Diablos.RS.FrameBasicColors.rl)
					sizextot = sizextot + sizex

					draw.SimpleText(v.date, "DiablosRSCopsFont2", w - 5, h - 5, Diablos.RS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
				end

				local viewcamera = vgui.Create("DButton", panel)
				viewcamera:SetPos(755, 15)
				viewcamera:SetSize(200, 70)
				viewcamera:SetFont("DiablosRSClientHUDBigFont1")
				viewcamera:SetText(Diablos.RS.Strings.view)
				viewcamera.DoClick = function()
					RenderSpeedCamera(ent)
					ply.DrawVisible = false
				end
				viewcamera.Paint = function(s, w, h)
					surface.SetDrawColor(Diablos.RS.Colors.Label) surface.DrawRect(0, 0, w, h)
					surface.SetDrawColor(Diablos.RS.Colors.LabelHovered) surface.DrawRect(1, 1, w-2, h-2)
					DiablosRSPaintButtons(s)
				end
			end
		end
	end

	local num = 0
	for k,v in pairs(AllButtons) do
		local time_anim, end_anim = 0, 0

		local panel = vgui.Create("DPanel", scrollframe)
		panel:SetPos(0, num * 100)
		panel:SetSize(110, 100)
		panel.Paint = function(s, w, h)
			if time_anim != 0 then
				if end_anim != 0 then
					local val = CurTime() - end_anim
					surface.SetDrawColor(v.anim_col) surface.DrawRect(0, 0, 5 - 20 * val, h)
					if val >= 0.25 then time_anim, end_anim = 0, 0 end
				else
					local val = math.min(CurTime() - time_anim, 1) * 5
					surface.SetDrawColor(v.anim_col) surface.DrawRect(0, 0, math.min(5 * val, 5), h)
				end
			end
		end
		

		local button = vgui.Create("DButton", panel)
		button:Dock(FILL)
		button:SetText("")
		button.Paint = function(s, w, h) end
		button.OnCursorEntered = function(s)
			time_anim = CurTime()
		end
		button.OnCursorExited = function(s)
			end_anim = CurTime()
		end
		button.DoClick = function(s)
			if idopen == k then return end
			if ispanel(scrollframef) then scrollframef:Remove() end
			if ispanel(bytype) then bytype:Remove() end
			if ispanel(dontsort) then dontsort:Remove() end
			if ispanel(filternotpaid) then filternotpaid:Remove() end
			if ispanel(filternotpaid) then filternotpaid:Remove() end
			if ispanel(filtermyrecords) then filtermyrecords:Remove() end
			scrollframef, bytype, dontsort = nil, nil, nil
			if k == 1 then
				-- draw things in frame so nothing is here
			elseif k == 2 then
				SpeedCameras()
			elseif k == 3 then
				Records()
			elseif k == 4 then
				Governement()
			elseif k == 5 then
				frame:Close()
			end
			idopen = k
		end

		local img = vgui.Create("DImage", panel)
		img:SetPos(30, 20) -- centered because for real the panel is 100 wide
		img:SetSize(60, 60)
		img:SetImage("materials/tprsa/"..v.icon..".png")

		num = num + 1
	end
	idopen = 1 -- default: home
	if IsValid(aimedent) then
		RenderSpeedCamera(aimedent)
		ply.DrawVisible = false
	end
end
net.Receive("TPRSA:CopsVGUI", function() TPRSACopsFrame(net.ReadTable(), net.ReadTable(), net.ReadTable(), net.ReadEntity()) end)

net.Receive("TPRSA:AdminVGUI", function(len, ply)
	local ply = LocalPlayer()
	if not Diablos.RS.AdminGroups[ply:GetUserGroup()] then return end

	local ent = net.ReadEntity()
	local num = net.ReadUInt(5)
	
	if num == 1 then
		Diablos.RS.Frame.Classic(ent, true)
	elseif num == 2 then
	 	Diablos.RS.Frame.Classic(ent, false)
	elseif num == 3 then
		Diablos.RS.Frame.Discr(ent)
	elseif num == 4 then
		Diablos.RS.Frame.Edu(ent)
	elseif num == 5 then
		Diablos.RS.Frame.AvgBegin(ent)
	elseif num == 6 then
		Diablos.RS.Frame.AvgEnd(ent)
	elseif num == 7 then
		Diablos.RS.Frame.Stop(ent)
	elseif num == 8 then
		Diablos.RS.Frame.Ped(ent)
	elseif num == 9 then
		Diablos.RS.Frame.Sign(ent)
	end
end)

net.Receive("TPRSA:Chat", function(len, ply) chat.AddText(Diablos.RS.FrameBasicColors.pre1, Diablos.RS.Strings.radarsystem .. " ", Diablos.RS.FrameBasicColors.pre2, net.ReadString()) end)

net.Receive("TPRSA:RecordsVGUI", function(len, ply) TPRSARecordsFrame(net.ReadEntity(), net.ReadTable()) end)

if Diablos.RS.Speedometer then
	hook.Add("HUDPaint", "TPRSA:Speedometer", function()
		local ply = LocalPlayer()
		if not ply:InVehicle() then return end
		local veh = ply:GetVehicle()
		if veh:GetClass() == "prop_vehicle_prisoner_pod" then
			veh = veh:GetParent()
			if not IsValid(veh) then return end
		end
		local speed
		if Diablos.RS.MPHCounter then
			speed = math.floor(veh:GetVelocity():Length() * 0.0568188)
		else
			speed = math.floor(veh:GetVelocity():Length() * 0.09144)
		end
		local scrw, scrh = ScrW(), ScrH()
		local xvalue, yvalue = Diablos.RS.SpeedometerPosX * scrw, Diablos.RS.SpeedometerPosY * scrh

		draw.RoundedBox(16, xvalue, yvalue, scrw * .08, scrh * .05, Color(255, 255, 255, 100))
		draw.RoundedBox(16, xvalue + 2, yvalue + 2, scrw * .08 - 4, scrh * .05 - 4, Diablos.RS.Colors.SpeedometerBG)
		if speed < 10 then speed = "0" .. speed end
		draw.SimpleText(speed, "DiablosRSSpeedometerFont", xvalue + scrw * .01, yvalue + scrh * .01, Diablos.RS.Colors.SpeedometerText)
		draw.SimpleText(Diablos.RS.MPHKMHText, "DiablosRSSpeedometerFont", xvalue + scrw * .04, yvalue + scrh * .01, Diablos.RS.Colors.SpeedometerText)
	end)
end