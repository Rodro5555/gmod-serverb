emergencymodNotificationSave = emergencymodNotificationSave or {}

function EmergencyResponse:GetClientMaterial( k )
	if k == 1 then
		return EmergencyDispatch.gpsPoliceLogo
	elseif k == 2 then
		return EmergencyDispatch.gpsEMSLogo
	elseif k == 3 then
		return EmergencyDispatch.gpsFirefightersLogo
	end
end 

function EmergencyResponse:GetClientEmergency( v )
	if v == EDLang[EDLang.Settings].victimderma_LawEnforcement then
		return "police"
	elseif v == EDLang[EDLang.Settings].victimderma_EMS then
		return "ems"
	elseif v == EDLang[EDLang.Settings].victimderma_Firefighters then
		return "fire"
	end
end

function EmergencyResponse:GetResponsiveFont()
	if ScrW() > 1919 then
		return "PoliceDispatch:Font:Montserrat:30"
	elseif ScrW() > 1279 && ScrW() < 1920 and ScrH() > 719 && ScrH() < 1080 then
		return "PoliceDispatch:Font:Montserrat:25"
	else
		return "PoliceDispatch:Font:Montserrat:20"
	end
end

function EmergencyResponse:SendNotification( text, time )
	local timer = time

	emergencymodNotificationSave[#emergencymodNotificationSave + 1] = {
		text = text,
		wtime = CurTime() + 0.2,
		ytimer = CurTime() + 0.2 + 1 + timer,
	}
end

function EmergencyResponse:GetAlignment( font, text, value )
	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )

	if value == "w" then 
		return w
	else
		return h
	end
end

function EmergencyResponse:SlideTextDLabel( Base, font, text, x, y, xpos, ypos, color, time )
	Base = Base or ""
	font = font or "Roboto"
	text = text or ""
	x = x or 100
	y = y or 100
	xpos = xpos or 0
	ypos = ypos or 0
	color = color or Color(255, 255, 255, 255)
	time = time or 0

	local TimeSTOP = CurTime() + time
	local MeterString = string.len( text )
	
	local Label = vgui.Create( "DLabel", Base )
	Label:SetPos( xpos, ypos )
	Label:SetSize( x, y )
	if time == 0 then
		Label:SetText( text )
	else
		Label:SetText( "" )
	end
	Label:SetWrap( true )
	Label:SetTextColor( color )
	Label:SetFont( font )
	function Label.Think()
		if Label:GetText() == text then
			return
		end
			
		local TimeLeft = TimeSTOP - CurTime()
		local StringSizeP1 = ( TimeLeft / ( time / 100 ) ) / 100
		local StringLong = 1 - StringSizeP1

		Label:SetText( string.sub( text, 0, MeterString * StringLong ) )
			
	end
	return Label
end

function EmergencyResponse:CreateGPSHUDPaintChaseInGoing( emergency, caller )
	if not IsValid( caller ) then return end
	if not caller:InVehicle() then return end
	if not IsValid( caller:GetVehicle() ) then return end
	if not LocalPlayer():isCP() then return end

	local gpsMatType =  Material( EmergencyDispatch.gpsPoliceLogo )

	hook.Add( "HUDPaint", "EmergencyResponse:CreateGPSPoint:ConnectedToHuntersVehicle", function()
		if not IsValid( LocalPlayer() ) then return end
		if not LocalPlayer():Alive() then return end 
		if not LocalPlayer():InVehicle() then return end
		if not IsValid( caller:GetVehicle() ) then return end
		if not LocalPlayer():isCP() then return end 

		local nearPosition = ""
		local callLocation = caller:GetVehicle():GetPos()
		local gpsPosition = ( callLocation + Vector( 0, 0, 100 ) ):ToScreen()
		local gpsDistance = math.Round( LocalPlayer():GetPos():Distance( callLocation ) / 20 )

		if gpsDistance < 150 then
			nearPosition = EDLang[EDLang.Settings]['gpspoint_near']
		elseif gpsDistance > 150 && gpsDistance < 500 then
			nearPosition = EDLang[EDLang.Settings]['gpspoint_seminear']
		elseif gpsDistance > 500 then
			nearPosition = EDLang[EDLang.Settings]['gpspoint_far']
		end

		timer.Simple(35, function()
			if not IsValid( LocalPlayer() ) then return end
			hook.Remove( "HUDPaint", "EmergencyResponse:CreateGPSPoint:ConnectedToHuntersVehicle" )
		end )
	
		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( gpsMatType )
		surface.DrawTexturedRect( gpsPosition.x - 20, gpsPosition.y - 45, 32, 32 )
	
		draw.SimpleText( string.upper( EDLang[EDLang.Settings]["OfficerNeedAssistance_Chase"] ), "PoliceDispatch:GPSPoint:Montserrat", gpsPosition.x, gpsPosition.y + 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( nearPosition, "PoliceDispatch:GPSPoint:Montserrat", gpsPosition.x, gpsPosition.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end )
end

function EmergencyResponse:CreateGPSHUDPaint( vector, emergency, caller )
	local gpsMatType = Material( EmergencyDispatch.gpsPoliceLogo )
	local option = 1

	if emergency == "police" or emergency == "backup" then
		gpsMatType = Material( EmergencyDispatch.gpsPoliceLogo )
		if not LocalPlayer():isCP() then return end
		option = 1
	elseif emergency == "ems" then
		gpsMatType = Material( EmergencyDispatch.gpsEMSLogo )
		if not EmergencyDispatch.MedicJobs[ team.GetName( LocalPlayer():Team() ) ] then return end 
		option = 2
	elseif emergency == "fire" then
		gpsMatType = Material( EmergencyDispatch.gpsFirefightersLogo )
		if not EmergencyDispatch.FirefightersJobs[ team.GetName( LocalPlayer():Team() ) ] then return end 
		option = 3
	end

	hook.Add( "HUDPaint", "EmergencyMod:GPSPoint:Callout", function()
		if option == 1 then
			if not LocalPlayer():isCP() then return end
		elseif option == 2 then
			if not EmergencyDispatch.MedicJobs[ team.GetName( LocalPlayer():Team() ) ] then return end
		elseif option == 3 then
			if not EmergencyDispatch.FirefightersJobs[ team.GetName( LocalPlayer():Team() ) ] then return end
		end
		if not LocalPlayer():Alive() then return end 

		local nearPosition = ""
		local callLocation = Vector( vector )

		local gpsPosition = ( callLocation + Vector( 0, 0, 100 ) ):ToScreen()
		local gpsDistance = math.Round( LocalPlayer():GetPos():Distance( callLocation ) / 20 )

		if gpsDistance < 150 then
			nearPosition = EDLang[EDLang.Settings]['gpspoint_near']
		elseif gpsDistance > 150 && gpsDistance < 500 then
			nearPosition = EDLang[EDLang.Settings]['gpspoint_seminear']
		elseif gpsDistance > 500 then
			nearPosition = EDLang[EDLang.Settings]['gpspoint_far']
		end

		timer.Simple(60, function()
			if not IsValid( LocalPlayer() ) then return end
			hook.Remove( "HUDPaint", "EmergencyMod:GPSPoint:Callout" )
		end )
	
		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( gpsMatType )
		surface.DrawTexturedRect( gpsPosition.x - 20, gpsPosition.y - 45, 32, 32 )

		draw.SimpleText( nearPosition, "PoliceDispatch:GPSPoint:Montserrat", gpsPosition.x, gpsPosition.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end )
end

function EmergencyResponse:CreateGPSPanicButton( vector, emergency, caller )
	hook.Add( "HUDPaint", "EmergencyMod:GPSPoint:PanicButton", function()
		if not LocalPlayer():Alive() then return end
		if not LocalPlayer():isCP() then return end

		local nearPosition = ""
		local gpsPosition = ( vector + Vector( 0, 0, 100 ) ):ToScreen()
		local gpsDistance = math.Round( LocalPlayer():GetPos():Distance( vector ) / 20 )
		local matGPSPanic = Material( EmergencyDispatch.gpsPoliceLogo )

		if gpsDistance < 150 then
			nearPosition = EDLang[EDLang.Settings]['gpspoint_near']
		elseif gpsDistance > 150 && gpsDistance < 500 then
			nearPosition = EDLang[EDLang.Settings]['gpspoint_seminear']
		elseif gpsDistance > 500 then
			nearPosition = EDLang[EDLang.Settings]['gpspoint_far']
		end

		timer.Simple(120, function()
			if not IsValid( LocalPlayer() ) then return end
			hook.Remove( "HUDPaint", "EmergencyMod:GPSPoint:PanicButton" )
		end )

		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( matGPSPanic )
		surface.DrawTexturedRect( gpsPosition.x - 20, gpsPosition.y - 45, 32, 32 )

		draw.SimpleText( "PANIC-BUTTON : " .. caller:Nick(), "PoliceDispatch:GPSPoint:Montserrat", gpsPosition.x, gpsPosition.y + 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( nearPosition, "PoliceDispatch:GPSPoint:Montserrat", gpsPosition.x, gpsPosition.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end )
end

function EmergencyResponse:RequestReason( sTable, sName, policeFont, isChase )
	local x, y = 450, 300
	local rX, rY = ( ScrW() - x ) * 0.05, ( ScrH() - y ) * 0.05

	if isChase then 
		rX, rY = ( ScrW() - x ) * 0.075 + 450, ( ScrH() - y ) * 0.08
	end

	local serviceReason = vgui.Create( "DFrame" )
	serviceReason:SetSize( x, y )
	serviceReason:SetPos( -600, rY )
	serviceReason:MoveTo( rX, rY, 0.2, 0, 1 )
	serviceReason:SetTitle( "" )
	serviceReason:MakePopup()
	serviceReason:SetDraggable( false )
	serviceReason:ShowCloseButton( false )
	function serviceReason.Paint( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBackground2 )
		draw.RoundedBox( 0, 0, 0, w, y * 0.25, EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBarColor )

		draw.RoundedBox( 0, 0, y * 0.25, w, y * 0.15, EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBackground )
		draw.SimpleText( sName, EmergencyResponse:GetResponsiveFont(), x * 0.035, y * 0.27, EmergencyDispatch.ColorsConfiguration.TitlesMenusColors, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		draw.SimpleText( "Backup Message", policeFont, x * 0.025, y * 0.02, EmergencyDispatch.ColorsConfiguration.TitlesMenusColors, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end

	local uiMessDrawColor = Color( 17, 17, 17 )
	local uiMessage = vgui.Create( "DTextEntry", serviceReason )
	uiMessage:SetSize( x * 0.94, y * 0.375 )
	uiMessage:SetPos( x * 0.03, y * 0.43 )
	uiMessage:SetMultiline( true )
	uiMessage:SetDrawLanguageID( false )
	uiMessage:SetFont( "EmergencyMod:TraficPolicerButtons" )
	uiMessage:SetTextColor( EmergencyDispatch.ColorsConfiguration.TextEntryColor )
	function uiMessage.Paint( self )
		surface.SetDrawColor( uiMessDrawColor )
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
		self:DrawTextEntryText( color_white, color_white, color_white )
	end

	if EmergencyResponse_DLC_PoliceEquipmentGear then 
		local dPreconfiguredMessages = vgui.Create( "DComboBox", serviceReason )
		dPreconfiguredMessages:SetSize( 110, 25 )
		dPreconfiguredMessages:SetPos( ( x - 110 ) * 0.945, ( y - 25 ) * 0.31 )
		dPreconfiguredMessages:SetText( "Messages" )
		dPreconfiguredMessages:SetTextColor( color_white )
		dPreconfiguredMessages:SetFont( EmergencyResponse_DLC_PoliceEquipmentGear:ResponsiveFont( "extra_light_light" ) )
		function dPreconfiguredMessages.Paint( self, w, h )
			draw.RoundedBox( 5, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.PlayerMenu_ButtonsBackground )
		end
		for k, v in pairs( EmergencyResponse_DLC_PoliceEquipmentGear.PreconfiguredBackupMessages ) do
			dPreconfiguredMessages:AddChoice( v )
		end
		function dPreconfiguredMessages:OnSelect( index, value, data )
			uiMessage:SetValue( value )
			dPreconfiguredMessages:SetText( "Messages" )
		end
	end

	local bSend = vgui.Create( "DButton", serviceReason )
	bSend:SetSize( x * 0.25, y * 0.135 )
	bSend:SetPos( x * 0.1, y * 0.83 )
	bSend:SetText( EDLang[EDLang.Settings]['backupoptions_btnSend'] )
	bSend:SetTextColor( EmergencyDispatch.ColorsConfiguration.TitlesMenusColors )
	bSend:SetFont( "EmergencyMod:TraficPolicerButtons" )
	function bSend.OnCursorEntered( self ) self.hover = true surface.PlaySound( "emergencyresponse/callouts/buttons/blip.wav" ) end
	function bSend.OnCursorExited( self ) self.hover = false end
	function bSend.Paint( self, w, h )
		if self.hover then
			draw.RoundedBox( 0, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.TraficPolicerButtonHover )
			bSend:SetTextColor( EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBarColor )
		else 
			draw.RoundedBox( 0, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBackgroundTransparent )
			bSend:SetTextColor( EmergencyDispatch.ColorsConfiguration.TitlesMenusColors )
		end
	end
	function bSend.DoClick() 
		if ( string.len( uiMessage:GetValue() ) < 5 ) then 
			serviceReason:MoveTo( rX, ScrH() * 0.32, 0.2, 0, 1)
			timer.Simple(4, function() 
				if IsValid( serviceReason ) then 
					serviceReason:MoveTo( rX, rY, 0.2, 0, 1) 
				end 
			end )

			EmergencyResponse:SendNotification( EDLang[EDLang.Settings]["notif_ErrorDTextEntry"], 4 )
		else
			serviceReason:MoveTo( -600, rY, 0.2, 0, 1) 
			timer.Simple(0.2, function() 
				if IsValid( serviceReason ) then
					serviceReason:Remove()
				end
			end )

			if isChase then 
				net.Start( "EmergencyResponse:TraficPolicer:VehicleOption:StartAlertVehicleChaseInGoing" )
					net.WriteString( uiMessage:GetValue() )
				net.SendToServer()

				EmergencyResponse:SendNotification( EDLang[EDLang.Settings]["notif_BackupRequestSent"], 3 )
			else
				net.Start( "EmergencyDispatch:DispatchRadio:BackupOptions:CallPatrol" )
					net.WriteTable( sTable )
					net.WriteString( uiMessage:GetValue() )
				net.SendToServer()

				EmergencyResponse:SendNotification( EDLang[EDLang.Settings]["notif_BackupRequestSent"], 5 )
			end

			if EmergencyResponse_DLC_PoliceEquipmentGear then
				net.Start( "EmergencyResponseDLCPEG:CloseTraficPolicer" )
					net.WriteString("backup_dlc")
				net.SendToServer()
			end
		end
	end

	local bCancel = vgui.Create( "DButton", serviceReason )
	bCancel:SetSize( x * 0.25, y * 0.135 )
	bCancel:SetPos( x * 0.6, y * 0.83 )
	bCancel:SetText( EDLang[EDLang.Settings]['backupoptions_btnCancel'] )
	bCancel:SetTextColor( EmergencyDispatch.ColorsConfiguration.TitlesMenusColors )
	bCancel:SetFont( "EmergencyMod:TraficPolicerButtons" )
	function bCancel.OnCursorEntered( self ) self.hover = true surface.PlaySound( "emergencyresponse/callouts/buttons/blip.wav" ) end
	function bCancel.OnCursorExited( self ) self.hover = false end
	function bCancel.Paint( self, w, h )
		if self.hover then
			draw.RoundedBox( 0, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.TraficPolicerButtonHover )
			bCancel:SetTextColor( EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBarColor )
		else 
			draw.RoundedBox( 0, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBackgroundTransparent )
			bCancel:SetTextColor( EmergencyDispatch.ColorsConfiguration.TitlesMenusColors )
		end
	end
	function bCancel.DoClick() 
		serviceReason:MoveTo( -600, rY, 0.2, 0, 1) 
		timer.Simple(0.2, function()
			if IsValid( serviceReason ) then
				serviceReason:Remove()

				net.Start( "EmergencyDispatch:DispatchRadio:BackupOptions:CloseFrame" )
				net.SendToServer()
			end
		end )

		if EmergencyResponse_DLC_PoliceEquipmentGear then
			net.Start( "EmergencyResponseDLCPEG:CloseTraficPolicer" )
			net.SendToServer()
		end
	end
end

local function WantedOrWarrantRequestReason( mode, parent, font, cowboy )
	local x, y = 450, 300
	local rX, rY = ( ScrW() - x ) * 0.05, ( ScrH() - y ) * 0.07

	local matCloseB = Material( "materials/emergencyresponse_fleodon/cross.png" )

	local Reason = vgui.Create( "DFrame" )
	Reason:SetSize( x, y )
	Reason:SetPos( -600, rY )
	Reason:MoveTo( rX, rY, 0.2, 0, 1 )
	Reason:SetTitle( "" )
	Reason:MakePopup()
	Reason:ShowCloseButton( true )
	function Reason.Paint( self, w, h )
		draw.RoundedBox( 1, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBackground2 )
		draw.RoundedBox( 1, 0, 0, w, h * 0.25, EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBarColor )

		if mode == "wanted" then 
			draw.SimpleText( EDLang[EDLang.Settings]["traficPolicerVehiclePanelTitle_Wanted"], font, w * 0.05, h * 0.02, EmergencyDispatch.ColorsConfiguration.TitlesMenusColors, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		elseif mode == "warrant" then
			draw.SimpleText( EDLang[EDLang.Settings]["traficPolicerVehiclePanelTitle_Warrant"], font, w * 0.05, h * 0.02, EmergencyDispatch.ColorsConfiguration.TitlesMenusColors, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end
	end

	EmergencyResponse:SlideTextDLabel( Reason, EmergencyResponse:GetResponsiveFont(), EDLang[EDLang.Settings]["EnterAReason"], x * 0.9, y * 0.2, x * 0.05, y * 0.26, color_white, 1 )

	local Message = vgui.Create( "DTextEntry", Reason )
	Message:SetSize( x * 0.9, y * 0.22 )
	Message:SetPos( x * 0.05, y * 0.475 )
	Message:SetMultiline( true )
	Message:SetDrawLanguageID( false )
	Message:SetFont( "Trebuchet24" )
	Message:SetTextColor( EmergencyDispatch.ColorsConfiguration.TextEntryColor )
	function Message.Paint( self )
		draw.RoundedBox( 5, 0, 0, self:GetWide(), self:GetTall(), EmergencyDispatch.ColorsConfiguration.PlayerMenu_ButtonsBackground )
		self:DrawTextEntryText( color_white, EmergencyDispatch.ColorsConfiguration.PlayerMenu_ButtonsBackground, color_white )
	end

	local BSend = vgui.Create( "DButton", Reason )
	BSend:SetSize( Message:GetWide(), y * 0.15 )
	BSend:SetPos( x * 0.05, y * 0.76 )
	BSend:SetText( "" )
	BSend.Slide = 0
	BSend.OnCursorEntered = function( self ) 
		if EmergencyDispatch.SoundConfiguration then
			surface.PlaySound( EmergencyDispatch.UIButtonSound )
		end

		self.hover = true
	end
	function BSend.OnCursorExited( self ) self.hover = false end
	BSend.Paint = function( self, w, h )
		draw.RoundedBox( 5, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.PlayerMenu_ButtonsBackground )

		if self.hover then
			self.Slide = Lerp( 0.05, self.Slide, w )

			draw.NoTexture()
			surface.SetDrawColor( EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBarColor )
			surface.DrawTexturedRectRotated( -20, 40, self.Slide, h * h, 20 )
		else
			self.Slide = Lerp( 0.05, self.Slide, 0 )

			draw.NoTexture()
			surface.SetDrawColor( EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBarColor )
			surface.DrawTexturedRectRotated( -20, 40, self.Slide, h * h, 20 )
		end

		draw.DrawText( EDLang[EDLang.Settings]["sendCalout"], EmergencyResponse:GetResponsiveFont(), w * 0.5, h * 0.175, color_white, 1 )
	end
	BSend.DoClick = function()
		if ( string.len( Message:GetValue() ) < 4 ) then 
			EmergencyResponse:SendNotification( EDLang[EDLang.Settings]["notif_ErrorDTextEntry"], 3 )
			return
		end
		
		Reason:MoveTo( -600, rY, 0.2, 0, 1 )
		timer.Simple(0.2, function()
			if not IsValid( Reason ) then return end
			if not IsValid( parent ) then return end

			Reason:Remove()
			parent:SetVisible( true )
		end )

		net.Start( "EmergencyDispatch:TraficPolicerInVehicle:SendSearchNoticeOrWarrant" )
			net.WriteString( mode )
			net.WriteString( Message:GetValue() )
			net.WriteEntity( cowboy )
		net.SendToServer()

		EmergencyResponse:SendNotification( EDLang[EDLang.Settings]["notif_RequestedSent"], 3 )
	end
end

local DashboardVehicleButtons = {
    {
        Name = EDLang[EDLang.Settings]["traficPolicer_IdentifyFrontVeh"],
        Icon = Material( "materials/emergencyresponse_fleodon/cctv.png" )
    },
    {
        Name = EDLang[EDLang.Settings]["traficPolicer_StartChaseVehicle"],            
        Icon = Material( "materials/emergencyresponse_fleodon/alert_icon.png" )
    },
    {
        Name = EDLang[EDLang.Settings]["traficPolicer_RedNotices"], 
        Icon = Material( "materials/emergencyresponse_fleodon/wanted.png" )
    },
    {
        Name = EDLang[EDLang.Settings]["traficPolicer_UnWanted"], 
        Icon = Material( "materials/emergencyresponse_fleodon/unwanted.png" )
    },
    {
        Name = EDLang[EDLang.Settings]["traficPolicer_SearchWarrant"], 
        Icon = Material( "materials/emergencyresponse_fleodon/warrant.png" )
    },
}

function EmergencyResponse:CreateDashboardVehicleMenu( titleFont, responsiveDec, colorTransparent )
	local x, y = 450, 300
	local rX, rY = ( ScrW() - x ) * 0.05, ( ScrH() - x ) * 0.1

	local DrawRoundedBoxTimer = CurTime() + 5
	local matCloseB = Material( "materials/emergencyresponse_fleodon/cross.png" )

	if string.len( EDLang[EDLang.Settings]["traficPolicerVehiclePanelTitle"] ) > 16 then 
		x = 560
	end

	local VehPanel = vgui.Create( "DFrame" )
	VehPanel:SetSize( x, y )
	VehPanel:SetPos( rX, rY )
	VehPanel:SetTitle( "" )
	VehPanel:ShowCloseButton( true )
	function VehPanel.Paint( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBackground2 )
		draw.RoundedBox( 0, 0, 0, w, h * 0.26, EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBarColor )

		draw.SimpleText( EDLang[EDLang.Settings]["traficPolicerVehiclePanelTitle"], titleFont, w * 0.02, h * 0.02, EmergencyDispatch.ColorsConfiguration.TitlesMenusColors, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end

	local DScroll = vgui.Create( "DScrollPanel", VehPanel )
	DScroll:SetSize( x, y-(y * 0.26) )
	DScroll:SetPos( 0, y*0.26 )
	DScroll.Paint = function() end 

	for k, v in pairs( DashboardVehicleButtons ) do
		local c_GREEN = Color( 20, 187, 18 )
		local c_RED = Color( 214, 32, 17 )
		local myKas = { 3, 4, 5 }

		local bOptions = vgui.Create( "DButton", DScroll )
		bOptions:SetSize( x, 40 )
		bOptions:Dock( TOP )
		bOptions:DockMargin( 0, 0, 0, 0 )
		bOptions:SetText( v.Name )
		bOptions:SetTextColor( color_white )
		bOptions:SetFont( "EmergencyMod:TraficPolicerButtons" )
		bOptions.Status = false
		function bOptions.OnCursorEntered( self ) self.hover = true surface.PlaySound( "emergencyresponse/callouts/buttons/blip.wav" ) end
		function bOptions.OnCursorExited( self ) self.hover = false end
		function bOptions.Paint( self, w, h )
			if self.hover then
				draw.RoundedBox( 0, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.TraficPolicerButtonHover )
			else 
				draw.RoundedBox( 0, 0, 0, w, h, colorTransparent )
			end

			surface.SetDrawColor( color_white )
			surface.SetMaterial( v.Icon )
			surface.DrawTexturedRect( w * 0.02, h * 0.1, 30, 30 )
		end
		function bOptions.DoClick( self )
			if k == 1 then
				if self.Status then
					self:SetTextColor( color_white )
					self.Status = false
				else
					self:SetTextColor( c_GREEN )
					self.Status = nil

					EmergencyResponse:ProceedVehiclesDetection( LocalPlayer() )

					timer.Simple(2, function()
						if IsValid( VehPanel ) then
							self:SetTextColor( color_white )

							self.Status = false
						end
						hook.Remove( "PostDrawOpaqueRenderables", "EmergencyResponse:FindInCone:ScanMode" )
					end )
				end
			elseif k == 2 then
				if not self.Status then
					if EmergencyDispatch.TypingReasonForAChase then
						EmergencyResponse:RequestReason( nil, v.Name, titleFont, true )
					else
						net.Start( "EmergencyResponse:TraficPolicer:VehicleOption:StartAlertVehicleChaseInGoing" )
							net.WriteString( LocalPlayer():Nick() .. " is chasing a vehicle, join the chase!" )
						net.SendToServer()

						EmergencyResponse:SendNotification( EDLang[EDLang.Settings]["notif_BackupRequestSent"], 5 )
					end

					self:SetTextColor( c_RED )

					self.Status = true

					timer.Simple(35, function()
						if IsValid( VehPanel ) then
							self:SetTextColor( color_white )
							
							self.Status = false
						end
					end )
				end
			elseif table.HasValue( myKas, k ) then
				local Menu = DermaMenu()

				for id, cowboy in pairs( player.GetAll() ) do

					Menu:AddOption( cowboy:Nick(), function()

						if k == 3 then
							WantedOrWarrantRequestReason( "wanted", VehPanel, titleFont, cowboy )
							VehPanel:SetVisible( false )
						elseif k == 4 then
							net.Start( "EmergencyDispatch:TraficPolicerInVehicle:SendSearchNoticeOrWarrant" )
								net.WriteString( "unwanted" )
								net.WriteString( "" )
								net.WriteEntity( cowboy )
							net.SendToServer()
						elseif k == 5 then
							WantedOrWarrantRequestReason( "warrant", VehPanel, titleFont, cowboy )
							VehPanel:SetVisible( false )
						end

					end )

				end

				Menu:Open()
			end
		end
	end 
end

function EmergencyResponse:GetPlayersInJob( tableJob )
	local tupinambas = 0

	for k, v in pairs( player.GetAll() ) do
		if istable(tableJob) and tableJob[ team.GetName( v:Team() ) ] or (tableJob == "CP" and v:isCP()) then
			tupinambas = tupinambas + 1
		end
	end

	return tupinambas
end

function EmergencyResponse:ReturnMaterialIcon( k )
	if k == 1 then
		return EmergencyDispatch.IconPolice
	elseif k == 2 then
		return EmergencyDispatch.IconEMS
	elseif k == 3 then
		return EmergencyDispatch.IconFire
	end
end

function EmergencyResponse:ProceedVehiclesDetection( tupinamba )
	local mat = Material( "models/shiny" )
	mat:SetFloat( "$alpha", 0.5 )

	if not IsValid( tupinamba ) then return end
	if not tupinamba:InVehicle() then return end
	if not tupinamba:isCP() then return end

	local ShouldOccure = true

	hook.Add( "PostDrawOpaqueRenderables", "EmergencyResponse:FindInCone:ScanMode", function()
		local size = 100
		local dir = tupinamba:GetAimVector()
		local angle = math.cos( math.rad( 180 ) )

		if not IsValid( tupinamba ) then return end
		if not tupinamba:InVehicle() then return end
		if not tupinamba:GetVehicle():IsValidVehicle() then return end 

		local startPos = tupinamba:GetVehicle():LocalToWorld( Vector( 0, 500, 50 ) )
		local entities = ents.FindInCone( startPos, dir, size, angle )
		local mins = Vector( -size * 2, -size, -size )
		local maxs = Vector( size * 2, size, size )

		render.SetMaterial( mat )
		render.DrawWireframeBox( startPos, tupinamba:GetAngles(), mins, maxs, color_white, true )
		render.DrawBox( startPos, tupinamba:GetAngles(), -mins, -maxs, color_white )

		if not IsValid( tupinamba ) then return end
		if not tupinamba:InVehicle() then return end

		if ShouldOccure then
			ShouldOccure = false
			for k, v in pairs( entities ) do
				if k > 0 then
					tupinamba:GetVehicle():EmitSound( "emergencyresponse/scanner.wav" )

					if IsValid( v ) then
						timer.Simple(2, function()
							if not IsValid( tupinamba ) then return end
							if not tupinamba:InVehicle() then return end

							if not IsValid( v ) then return end
							if not v:IsVehicle() then return end

							net.Start( "EmergencyResponse:TraficPolicer:VehicleOption:ReceivingEntityAndProceedtoScan" )
								net.WriteEntity( v )
							net.SendToServer()

							hook.Remove( "PostDrawOpaqueRenderables", "EmergencyResponse:FindInCone:ScanMode" )
						end )
					end
				end
			end
		end
	end )
end

function EmergencyResponse:ResponsiveFont( mode )
	if mode == "basic" then
		if ScrW() > 1920 then
			return "Fleodon:Montserrat:35"
		elseif ScrW() == 1920 then
			return "Fleodon:Montserrat:30"
		else
			return "Fleodon:Montserrat:25"
		end
	elseif mode == "large" then
		if ScrW() > 1920 then
			return "Fleodon:Montserrat:50"
		elseif ScrW() == 1920 then
			return "Fleodon:Montserrat:45"
		else
			return "Fleodon:Montserrat:40"
		end
	elseif mode == "light" then
		if ScrW() > 1920 then
			return "Fleodon:Montserrat:30"
		elseif ScrW() == 1920 then
			return "Fleodon:Montserrat:25"
		else
			return "Fleodon:Montserrat:20"
		end
	elseif mode == "extra_light" then
		if ScrW() > 1920 then
			return "Fleodon:Montserrat:25"
		elseif ScrW() == 1920 then
			return "Fleodon:Montserrat:20"
		else
			return "Fleodon:Montserrat:15"
		end
	elseif mode == "extra_light_light" then 
		if ScrW() > 1920 then
			return "Fleodon:Montserrat:25:Light"
		elseif ScrW() == 1920 then
			return "Fleodon:Montserrat:20:Light"
		else
			return "Fleodon:Montserrat:15:Light"
		end
	end
end