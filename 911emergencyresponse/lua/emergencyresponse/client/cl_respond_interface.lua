local popupCallouts = popupCallouts or {}
local popupPanicButtons = popupPanicButtons or {}

local pPlayer_IsMuted = true
local pPlayer_CanHear = true

net.Receive( "EmergencyDispatch:DispatchCallout:SendingCalloutToUnit", function()
	local bool = net.ReadBool()
	local IsChase = net.ReadBool()
	
	local callCaller 		= nil
	local callLocation 		= nil
	local callReason 		= ""
	local callEmergency 	= ""

	if IsChase then 
	    callCaller = net.ReadEntity()
	    callReason = net.ReadString()
	    callEmergency = "police"
	    callLocation = callCaller:GetPos()
	else
		callCaller = net.ReadEntity()
	   	callReason = net.ReadString()
	    callEmergency = net.ReadString()
	   	callLocation = net.ReadVector()
	end

	local mat_icon_delete = Material( EmergencyDispatch.IconGPSRemove )
	local mat_icon_accept = Material( EmergencyDispatch.IconGPSAccept )

	local x, y = 350, 200
	local rX, rY = ( ScrW() - x - ScrW() * 0.01 ), ( ScrH() - y - ScrH() * 0.04 )

    local popupCall = vgui.Create( "DFrame" )
	popupCall:SetSize( x, y )
	popupCall:SetPos( ScrW() * 8, rY + ( -210 * #popupCallouts ) )
	popupCall:SetSizable( true )
	if #popupCallouts > 0 then 
		popupCall:MoveTo( rX, rY + ( -210 * #popupCallouts ), 0.2, 0,1, function()
			if !EmergencyDispatch.SoundConfiguration then return end
			surface.PlaySound( table.Random( EmergencyDispatch.Sound.CalloutReceptList ) )

			if bool then
				timer.Simple( 0.5, function() 
					if IsValid( popupCall ) then 
						surface.PlaySound( EmergencyDispatch.OfficerNeedAssistanceCallout )
					end
				end )
			end
		end )
	else
		popupCall:MoveTo( rX, rY, 0.2, 0,1, function()
			if !EmergencyDispatch.SoundConfiguration then return end
			surface.PlaySound( table.Random( EmergencyDispatch.Sound.CalloutReceptList ) )

			if bool or IsChase then
				timer.Simple( 0.5, function() 
					if IsValid( popupCall ) then 
						surface.PlaySound( EmergencyDispatch.OfficerNeedAssistanceCallout )
					end
				end )
			end
		end )
	end
	popupCall:SetTitle( "" )
	popupCall:ShowCloseButton( false )
	function popupCall.Paint( self, w, h )
		if not IsValid( callCaller ) then return end

		draw.RoundedBox( 3, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.RespondTicketBackgroundColor )

		if IsChase then
			draw.RoundedBox( 3, 0, 0, w, h * 0.3, EmergencyDispatch.ColorsConfiguration.RespondTicketBarColor )
			draw.SimpleText( string.upper( EDLang[EDLang.Settings]["OfficerNeedAssistance_Chase"] ), EmergencyResponse:GetResponsiveFont(), x * 0.02, y * 0.01, EmergencyDispatch.ColorsConfiguration.TitlesMenusColors, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( EDLang[EDLang.Settings]["denomination_policer"] .. " " .. callCaller:Nick(), "Trebuchet24", x * 0.02, y * 0.15, EmergencyDispatch.ColorsConfiguration.TitlesMenusColors, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		else
			if callEmergency == "backup" then
				draw.RoundedBox( 3, 0, 0, w, h * 0.28, EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBarColor )
				draw.SimpleText( "BACKUP", EmergencyResponse:GetResponsiveFont(), x * 0.02, y * 0.01, EmergencyDispatch.ColorsConfiguration.TitlesMenusColors, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			else
				draw.RoundedBox( 3, 0, 0, w, h * 0.28, EmergencyDispatch.ColorsConfiguration.RespondTicketBarColor )
				draw.SimpleText( EDLang[EDLang.Settings]["EmergencyText"], EmergencyResponse:GetResponsiveFont(), x * 0.02, y * 0.01, EmergencyDispatch.ColorsConfiguration.TitlesMenusColors, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end
			draw.SimpleText( EDLang[EDLang.Settings]["responderderma_From"] .. callCaller:Nick(), "EmergencyMod:RichText9", x * 0.03, y * 0.33, EmergencyDispatch.ColorsConfiguration.TitlesMenusColors, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( EDLang[EDLang.Settings]["DistanceText"] .. math.Round( LocalPlayer():GetPos():Distance( callLocation ) / 20 ) .. "m", "PoliceDispatch:Font:Montserrat:25", x * 0.02, y * 0.14, EmergencyDispatch.ColorsConfiguration.TitlesMenusColors, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end
	end
    table.insert( popupCallouts, popupCall )
    
    local popupComment = vgui.Create( "RichText", popupCall )
	popupComment:SetSize( x + 10, y * 0.5 )
	if IsChase then 
		popupComment:SetPos( x * 0.02, y * 0.32 )
	else
		popupComment:SetPos( x * 0.02, y * 0.45 )
	end
	popupComment:SetText( callReason )
	function popupComment:PerformLayout()
		self:SetFontInternal( "EmergencyMod:RichText9" )
		self:SetFGColor( EmergencyDispatch.ColorsConfiguration.TitlesMenusColors )
	end
	
	local popupTakeOut = vgui.Create( "DButton", popupCall )
    popupTakeOut:SetSize( x * 0.1, y * 0.2 )
    popupTakeOut:SetPos( x * 0.9, y * 0.03 )
	popupTakeOut:SetText( "" )
	popupTakeOut:SetTextColor( EmergencyDispatch.ColorsConfiguration.TitlesMenusColors )
	popupTakeOut:SetFont( "Trebuchet18" )
    function popupTakeOut.OnCursorEntered( self ) self.hover = true surface.PlaySound( "UI/buttonrollover.wav" ) end
	function popupTakeOut.OnCursorExited( self ) self.hover = false end
	function popupTakeOut.DoClick()
		popupCall:MoveTo( ScrW() * 8, rY, 0.2, 0, 1 )
		timer.Simple( 0.2, function()
			if IsValid( popupCall ) then
				popupCall:Remove()
			end
		end )
		
		table.remove( popupCallouts, #popupCallouts )
		if IsChase then 
			hook.Remove( "HUDPaint", "EmergencyResponse:CreateGPSPoint:ConnectedToHuntersVehicle" )
		else
			hook.Remove( "HUDPaint", "EmergencyMod:GPSPoint:Callout" )
		end

		if EmergencyDispatch.SoundConfiguration then
			surface.PlaySound( EmergencyDispatch.CalloutRemove )
		end 
	end
    function popupTakeOut.Paint( self, w, h )
		surface.SetDrawColor( EmergencyDispatch.ColorsConfiguration.CloseButton )
		surface.SetMaterial( mat_icon_delete )
		surface.DrawTexturedRect( 5, 1, 22, 22 )
	end

	if IsChase then 
		EmergencyResponse:CreateGPSHUDPaintChaseInGoing( "police", callCaller )
	else
		local popupClaim = vgui.Create( "DButton", popupCall )
	    popupClaim:SetSize( x * 0.1, y * 0.2 )
	    popupClaim:SetPos( x * 0.8, y * 0.03 )
		popupClaim:SetText( "" )
		popupClaim:SetTextColor( EmergencyDispatch.ColorsConfiguration.TitlesMenusColors )
		popupClaim:SetFont( "Trebuchet18" )
	    popupClaim.Status = false
	    function popupClaim.OnCursorEntered( self ) self.hover = true surface.PlaySound( "UI/buttonrollover.wav" ) end
		function popupClaim.OnCursorExited( self ) self.hover = false end
		function popupClaim.DoClick( self )
	        if popupClaim.Status == false then
				popupClaim.Status = true
				self:Remove()

				EmergencyResponse:CreateGPSHUDPaint( callLocation, callEmergency, callCaller )

				if EmergencyDispatch.SoundConfiguration then
					surface.PlaySound( table.Random( EmergencyDispatch.Sound.CalloutClaim ) )
				end
	        else
				popupClaim.Status = false
	            popupCall:MoveTo( ScrW() * 3, rY, 0.2, 0, 1)
				timer.Simple( 0.2, function() 
					if IsValid( popupCall ) then 
						popupCall:Remove()
					end
				end )

				table.remove( popupCallouts, #popupCallouts )
				hook.Remove( "HUDPaint", "EmergencyMod:GPSPoint:Callout" )
				
				if EmergencyDispatch.SoundConfiguration then
					surface.PlaySound( EmergencyDispatch.CalloutRemove )
				end
	        end
	    end
	    function popupClaim.Paint( self, w, h )
			surface.SetDrawColor( EmergencyDispatch.ColorsConfiguration.CloseButton )
			surface.SetMaterial( mat_icon_accept )
			surface.DrawTexturedRect( 5, 1, 22, 22 )
		end
	end
end )

net.Receive("EmergencyDispatch:DispatchRadio:PanicButton:AlertPatrols", function() 
	local pCaller = net.ReadEntity() 
	local pLocation = net.ReadVector()
	local playerIsCivilian = net.ReadBool()
	
	local x, y = 350, 75
	local rX, rY = ( ScrW() - x ) * 0.99, ( ScrH() - x ) * 0.02

	local mat_icon_delete = Material( EmergencyDispatch.IconGPSRemove )
	local mat_icon_cancel = Material( "materials/emergencyresponse_fleodon/cross.png" )
	local mat_icon_alert = Material( "materials/emergencyresponse_fleodon/alert_icon.png" )

	local urgenceDispatch = vgui.Create( "DFrame" )
	urgenceDispatch:SetSize( x, y )
	urgenceDispatch:SetPos( rX, 0 )
	urgenceDispatch:MoveTo( rX, rY + (90 * ( #popupPanicButtons + 1 )), 0.2, 0,1, function()
		if EmergencyDispatch.SoundConfiguration then
			surface.PlaySound( table.Random( EmergencyDispatch.Sound.CalloutReceptList ) )
		end

		EmergencyResponse:CreateGPSPanicButton( pLocation, "police", pCaller )
	end )
	urgenceDispatch:ShowCloseButton( false )
	urgenceDispatch:SetTitle( "" )
	function urgenceDispatch.Paint( self, w, h )
		if not IsValid( pCaller ) then return end

		draw.RoundedBox( 0, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.RespondTicketBackgroundColor )
        draw.RoundedBox( 0, 0, y - ( y*0.05) + 1, w, y * 0.05, EmergencyDispatch.ColorsConfiguration.RespondTicketBarColor )
        draw.RoundedBox( 0, 0, 0, w, y * 0.05, EmergencyDispatch.ColorsConfiguration.RespondTicketBarColor )
        
        surface.SetDrawColor( color_white )
		surface.SetMaterial( mat_icon_alert )
		surface.DrawTexturedRect( 5, 5, 60, 60 )

        draw.SimpleText( "PANIC-BUTTON", EmergencyResponse:GetResponsiveFont(), x * 0.22, y * 0.1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

		if playerIsCivilian then 
        	draw.SimpleText( pCaller:Nick() .. " | " .. math.Round( LocalPlayer():GetPos():Distance( pLocation ) / 20 ) .. "m", "PoliceDispatch:Font:Montserrat:SizeLight", x * 0.22, y * 0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		else
			draw.SimpleText( EDLang[EDLang.Settings]["denomination_policer"] .. " " .. pCaller:Nick() .. " | " .. math.Round( LocalPlayer():GetPos():Distance( pLocation ) / 20 ) .. "m", "PoliceDispatch:Font:Montserrat:SizeLight", x * 0.22, y * 0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end
	end 
	table.insert( popupPanicButtons, urgenceDispatch )
	
	local urgenceTakeOut = vgui.Create( "DButton", urgenceDispatch ) 
	urgenceTakeOut:SetSize( x, y ) 
	urgenceTakeOut:SetPos( x * 0.92, y * 0.05 ) 
	urgenceTakeOut:SetText( "" ) 
	urgenceTakeOut.Slide = 0 
	function urgenceTakeOut.OnCursorEntered( self )
		if EmergencyDispatch.SoundConfiguration then 
			surface.PlaySound( EmergencyDispatch.UIButtonSound ) 
		end 
		self.hover = true 
	end 
	function urgenceTakeOut.OnCursorExited( self ) 
		self.hover = false 
	end 
	function urgenceTakeOut.Paint( self, w, h ) 
		if self.hover then 
			self.Slide = Lerp( 0.05, self.Slide, w ) 
		else
			self.Slide = Lerp( 0.05, self.Slide, 0 ) 
		end

		surface.SetDrawColor( color_white )
		surface.SetMaterial( mat_icon_cancel )
		surface.DrawTexturedRect( 5, 5, 16, 16 )
	end
	function urgenceTakeOut.DoClick() 
		urgenceDispatch:MoveTo( rX, -rY, 0.2, 0, 1 ) 

		timer.Simple(0.2, function() 
			if IsValid( urgenceDispatch ) then 
				urgenceDispatch:Remove() 
			end 
		end ) 

		table.remove( popupPanicButtons, #popupPanicButtons ) 

		hook.Remove( "HUDPaint", "EmergencyMod:GPSPoint:PanicButton" ) 
		if EmergencyDispatch.SoundConfiguration then 
			surface.PlaySound( EmergencyDispatch.CalloutRemove ) 
		end 
	end
end )

net.Receive("EmergencyDispatch:DispatchRadio:TraficPolicerMenu", function()
	local frameClosed = net.ReadBool()
	local frameButton = net.ReadBool()
	local x, y = 450, 600
	local rX, rY = ( ScrW() - x ) * 0.05, ( ScrH() - x ) * 0.1

	local c_transparent = Color( 0, 0, 0, 0 )
	local policeFont = ""
	local responsiveDecal = 0
	local icSize = 90
	
	local pFrame = LocalPlayer().EmergencyResponse_TraficPolicerFrame 

	if IsValid( pFrame ) and not frameButton then
		pFrame:MoveTo( -600, rY, 0.2, 0, 1 )
		timer.Simple(0.2, function()
			if IsValid( pFrame ) then
				pFrame:Remove()
				pFrame = nil
			end 
		end )
	elseif IsValid( pFrame ) and frameButton then
		if #pFrame.RadioButtons == pFrame.ActiveButton then
			pFrame.RadioButtons[pFrame.ActiveButton].MouseOn = false
			pFrame.RadioButtons[1].MouseOn = true
			pFrame.ActiveButton = 1

			pFrame.ActiveButtonID = pFrame.RadioButtons[pFrame.ActiveButton]
		else
			pFrame.RadioButtons[pFrame.ActiveButton].MouseOn = false
			pFrame.RadioButtons[pFrame.ActiveButton+1].MouseOn = true
			pFrame.ActiveButton = pFrame.ActiveButton + 1

			if pFrame.ActiveButton <= 2 then
				pFrame.ActiveButtonID = pFrame.RadioButtons[pFrame.ActiveButton]
			else
				pFrame.ActiveButtonID = nil
			end
		end
		
		surface.PlaySound( "emergencyresponse/callouts/buttons/click.wav" )
	else
		if ScrW() > 1920 then
			policeFont = "EmergencyMod:TraficPolicer:DFrameTitle"
			responsiveDecal = ( ScrH() * 0.01 )
		elseif EmergencyResponse:GetResponsiveFont() == "PoliceDispatch:Font:Montserrat:30" then
			policeFont = "EmergencyMod:TraficPolicer:DFrameTitle"
			responsiveDecal = ( ScrH() * 0.04 )
		else
			policeFont = "EmergencyMod:TraficPolicer:DFrameTitle:Middle"
			responsiveDecal = ( ScrH() * 0.06 )
		end

		local traficPolicer = vgui.Create( "DFrame" )
		traficPolicer:SetSize( x, y )
		traficPolicer:SetPos( -600, rY )
		traficPolicer:MoveTo( rX, rY, 0.2, 0, 1 )
		traficPolicer:SetTitle( "" )
		traficPolicer.RadioButtons = {}
		traficPolicer.ActiveButton = 1
		traficPolicer.ActiveButtonID = nil
		traficPolicer.UIFont = policeFont
		traficPolicer:SetDraggable( false )
		traficPolicer:ShowCloseButton( false )
		function traficPolicer.Paint( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBackground2 )
			draw.RoundedBox( 0, 0, 0, w, y * 0.15, EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBarColor )

			draw.RoundedBox( 0, 0, y * 0.15, w, h * 0.075, EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBackground )
			draw.SimpleText( "BACKUP & OPTIONS", EmergencyResponse:GetResponsiveFont(), x * 0.02, y * 0.16, EmergencyDispatch.ColorsConfiguration.TitlesMenusColors, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( "Backup Services", policeFont, x * 0.02, y * 0.021, EmergencyDispatch.ColorsConfiguration.TitlesMenusColors, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		end
		LocalPlayer().EmergencyResponse_TraficPolicerFrame = traficPolicer

		local tPanel = vgui.Create( "DScrollPanel", traficPolicer )
		tPanel:SetSize( x, y * 0.8 )
		tPanel:SetPos( 0, y * 0.15 + ( y * 0.075 ) )

		if EmergencyResponse_DLC_PoliceEquipmentGear then 
			for i = 1, 2 do 
				traficPolicer_MuteAll = vgui.Create( "DButton", tPanel )
				traficPolicer_MuteAll:SetSize( x, 40 )
				traficPolicer_MuteAll:Dock( TOP )
				traficPolicer_MuteAll:SetText( "" )
				traficPolicer_MuteAll.ID = i
				traficPolicer_MuteAll.CanSpeak = false
				traficPolicer_MuteAll.dataService = nil
				traficPolicer_MuteAll.MouseOn = (i == 1)
				traficPolicer_MuteAll.CanHear = (i == 2)
				function traficPolicer_MuteAll.Paint( self, w, h )
					if self.MouseOn then
						draw.RoundedBox( 0, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.TraficPolicerButtonHover )
					else 
						draw.RoundedBox( 0, 0, 0, w, h, c_transparent )
					end

					if i == 1 then
						if pPlayer_IsMuted then
							draw.SimpleText( ED_PEGDLCLang[ED_PEGDLCLang.Language]["everybodyhearsyou"], "EmergencyMod:TraficPolicerButtons", w * 0.02, h * 0.085, EmergencyResponse_DLC_PoliceEquipmentGear.Color_CalloutsStatus_Available, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
						else
							draw.SimpleText( ED_PEGDLCLang[ED_PEGDLCLang.Language]["nobodyhearsyou"], "EmergencyMod:TraficPolicerButtons", w * 0.02, h * 0.085, EmergencyResponse_DLC_PoliceEquipmentGear.Color_DispatchCallout_VictimTitle, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
						end
					else
						if pPlayer_CanHear then
							draw.SimpleText( ED_PEGDLCLang[ED_PEGDLCLang.Language]["hearseverybody"], "EmergencyMod:TraficPolicerButtons", w * 0.02, h * 0.085, EmergencyResponse_DLC_PoliceEquipmentGear.Color_CalloutsStatus_Available, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
						else
							draw.SimpleText( ED_PEGDLCLang[ED_PEGDLCLang.Language]["hearsnobody"], "EmergencyMod:TraficPolicerButtons", w * 0.02, h * 0.085, EmergencyResponse_DLC_PoliceEquipmentGear.Color_DispatchCallout_VictimTitle, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
						end
					end
				end
				function traficPolicer_MuteAll.OnCursorEntered( self ) 
					if LocalPlayer():InVehicle() then
						self.MouseOn = true
						surface.PlaySound( "emergencyresponse/callouts/buttons/blip.wav" )
					end
				end
				function traficPolicer_MuteAll.OnCursorExited( self ) 
					if LocalPlayer():InVehicle() then
						self.MouseOn = false
					end
				end
				function traficPolicer_MuteAll.DoClick()
					if LocalPlayer():InVehicle() then
						if i == 1 then
							if pPlayer_IsMuted then
								pPlayer_IsMuted = false
							else
								pPlayer_IsMuted = true
							end

							LocalPlayer().EmergencyResponse_DLC_PlayerIsMuted = pPlayer_IsMuted

							net.Start( "EmergencyResponseDLCPEG:TraficPolicerRadio:UpdateVoiceStatus" )
								net.WriteBool( true )
								net.WriteBool( pPlayer_IsMuted )
							net.SendToServer()
						else
							if pPlayer_CanHear then
								pPlayer_CanHear = false
							else
								pPlayer_CanHear = true
							end

							net.Start( "EmergencyResponseDLCPEG:TraficPolicerRadio:UpdateVoiceStatus" )
								net.WriteBool( false )
								net.WriteBool( pPlayer_CanHear )
							net.SendToServer()
						end
					end
				end
				if i == 1 then 
					traficPolicer.ActiveButtonID = traficPolicer_MuteAll
				end

				table.insert( traficPolicer.RadioButtons, traficPolicer_MuteAll )
			end

			LocalPlayer().EmergencyResponse_DLC_PlayerIsMuted = pPlayer_IsMuted
		end

		for i=1, #EmergencyDispatch.RadioBackupButtons do
			local service = EmergencyDispatch.RadioBackupButtons[i]

			local bOptions = vgui.Create( "DButton", tPanel )
			bOptions:SetSize( x, 40 )
			bOptions:Dock( TOP )
			bOptions:SetText( "" )
			if EmergencyResponse_DLC_PoliceEquipmentGear then
				bOptions.MouseOn = false
			elseif i == 1 then
				bOptions.MouseOn = true
			end
			bOptions.dataService = service
			function bOptions.Paint( self, w, h )
				if self.MouseOn then
					draw.RoundedBox( 0, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.TraficPolicerButtonHover )
				else 
					draw.RoundedBox( 0, 0, 0, w, h, c_transparent )
				end

				draw.SimpleText( service.Name, "EmergencyMod:TraficPolicerButtons", w * 0.02, h * 0.085, EmergencyDispatch.ColorsConfiguration.TitlesMenusColors, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end
			function bOptions.OnCursorEntered( self ) 
				if LocalPlayer():InVehicle() then
					self.MouseOn = true
					surface.PlaySound( "emergencyresponse/callouts/buttons/blip.wav" )
				end
			end
			function bOptions.OnCursorExited( self ) 
				if LocalPlayer():InVehicle() then
					self.MouseOn = false
				end
			end
			function bOptions.DoClick()
				if not LocalPlayer():InVehicle() then return end

				local requestJobs = {}
				for k, v in pairs( player.GetAll() ) do
					if istable(service.Jobs) and table.HasValue( service.Jobs, team.GetName( v:Team() ) ) or ( service.Jobs == "CP" and v:isCP() ) then	
						requestJobs[team.GetName( v:Team() )] = true
					end
				end

				if #requestJobs == 0 then
					EmergencyResponse:SendNotification( EDLang[EDLang.Settings]["notif_BackupRequestNotSent"], 5 )
				else
					EmergencyResponse:RequestReason( requestJobs, service.Name, traficPolicer.UIFont, false )
				end

				traficPolicer:Remove()
				surface.PlaySound( "emergencyresponse/callouts/buttons/click_2.wav" )
				net.Start( "EmergencyDispatch:DispatchRadio:TraficPolicerMenu:FrameClosed" )
				net.SendToServer()
			end

			table.insert( traficPolicer.RadioButtons, bOptions )
		end

		if LocalPlayer():InVehicle() then
			local mat_tool = Material( "materials/emergencyresponse_fleodon/tools_icon.png" )
			local mat_panic = Material( "materials/emergencyresponse_fleodon/alert_icon.png" )

			local bVehicleModules = vgui.Create( "DButton", traficPolicer )
			bVehicleModules:SetSize( icSize, icSize )
			bVehicleModules:SetPos( x * 0.2, y * 0.8 )
			bVehicleModules:SetText( "" )
			function bVehicleModules.OnCursorEntered( self ) surface.PlaySound( "emergencyresponse/callouts/buttons/blip.wav" ) end
			function bVehicleModules.Paint( self, w, h )
				surface.SetDrawColor( color_white )
				surface.SetMaterial( mat_tool )
				surface.DrawTexturedRect( 0, 0, icSize, icSize )
			end
			function bVehicleModules.DoClick() 
				traficPolicer:Remove()
				net.Start( "EmergencyDispatch:DispatchRadio:TraficPolicerMenu:FrameClosed" )
				net.SendToServer()
				
				surface.PlaySound( EmergencyDispatch.RadioButtonScroll )
				LocalPlayer().EmergencyResponse_TraficPolicerFrame = nil
				EmergencyResponse:CreateDashboardVehicleMenu( policeFont, responsiveDecal, c_transparent )
			end

			local bPanic = vgui.Create( "DButton", traficPolicer )
			bPanic:SetSize( icSize, icSize )
			bPanic:SetPos( x * 0.6, y * 0.8 )
			bPanic:SetText( "" )
			function bPanic.OnCursorEntered( self ) surface.PlaySound( "emergencyresponse/callouts/buttons/blip.wav" ) end
			function bPanic.Paint( self, w, h )
				surface.SetDrawColor( color_white )
				surface.SetMaterial( mat_panic )
				surface.DrawTexturedRect( 0, 0, icSize, icSize )
			end
			function bPanic.DoClick()
				if EmergencyDispatch.ActivatePanicButton then
					traficPolicer:Remove()
					net.Start( "EmergencyDispatch:DispatchRadio:TraficPolicerMenu:FrameClosed" )
					net.SendToServer()
					
					surface.PlaySound( EmergencyDispatch.RadioButtonScroll )
					LocalPlayer().EmergencyResponse_TraficPolicerFrame = nil
				else
					chat.AddText( Color( 222, 39, 39 ), "911 Emergency Response - Error:", color_white, " The Panic-Button is not activated in this server!" )
				end
			end
		end 
	end 
end )

local keycooldown = 0
hook.Add( "KeyPress", "EmergencyResponse:NaviguateInTheRadioPolice:KeyE", function( pPlayer )
	if not IsValid( pPlayer ) then return end
	if not pPlayer:IsPlayer() then return end
	if not pPlayer:Alive() then return end
	if not IsValid( pPlayer:GetActiveWeapon() ) then return end
	if not IsValid( LocalPlayer().EmergencyResponse_TraficPolicerFrame ) then return end
	if not pPlayer:isCP() then return end
	if pPlayer:GetActiveWeapon():GetClass() != "emergencyresponse_improved_walkietalkie" and pPlayer:GetActiveWeapon():GetClass() != "emergencyresponse_walkietalkie" then return end

	local pFrame = LocalPlayer().EmergencyResponse_TraficPolicerFrame
	local pService = pFrame.RadioButtons[pFrame.ActiveButton].dataService

	if pPlayer:KeyDown( IN_USE ) and not (keycooldown > CurTime()) then
		if EmergencyResponse_DLC_PoliceEquipmentGear and (pFrame.ActiveButton == 1 or pFrame.ActiveButton == 2) then
			if pFrame.ActiveButton == 1 then 
				if pPlayer_IsMuted then
					pPlayer_IsMuted = false
				else
					pPlayer_IsMuted = true
				end

				LocalPlayer().EmergencyResponse_DLC_PlayerIsMuted = pPlayer_IsMuted

				net.Start( "EmergencyResponseDLCPEG:TraficPolicerRadio:UpdateVoiceStatus" )
					net.WriteBool( true )
					net.WriteBool( pPlayer_IsMuted )
				net.SendToServer()
			else
				if pPlayer_CanHear then
					pPlayer_CanHear = false
				else
					pPlayer_CanHear = true
				end

				net.Start( "EmergencyResponseDLCPEG:TraficPolicerRadio:UpdateVoiceStatus" )
					net.WriteBool( false )
					net.WriteBool( pPlayer_CanHear )
				net.SendToServer()
			end
		else
			local requestJobs = {}
			for k, v in pairs( player.GetAll() ) do
				if istable(pService.Jobs) and table.HasValue( pService.Jobs, team.GetName( v:Team() ) ) or ( pService.Jobs == "CP" and v:isCP() ) then
					requestJobs[ team.GetName( v:Team() ) ] = true
				end
			end

			if #requestJobs == 0 then 
				EmergencyResponse:SendNotification( EDLang[EDLang.Settings]["notif_BackupRequestNotSent"], 5 )
			else
				EmergencyResponse:RequestReason( requestJobs, pService.Name, pFrame.UIFont, false )
			end
					
			net.Start( "EmergencyDispatch:DispatchRadio:TraficPolicerMenu:FrameClosed" )
			net.SendToServer()
			
			LocalPlayer().EmergencyResponse_TraficPolicerFrame:Remove()
			surface.PlaySound( "emergencyresponse/callouts/buttons/click_2.wav" )
		end
	end 

	keycooldown = CurTime() + 0.15
end )

net.Receive( "EmergencyResponse:TraficPolicer:VehicleOptions:WhenIdentified:ShowVehIdentity", function()
	local ownerWanted = net.ReadBool()
	local vehOwner = net.ReadString()
	local vehName = net.ReadString()
	local vehSpeed = net.ReadString()

	local x, y = 475, 150
	local rX, rY = ( ScrW() - x ) * 0.5, ( ScrH() - x ) * 0.093

	local DrawRoundedBoxTimer = CurTime() + 5
	local matCloseB = Material( "materials/emergencyresponse_fleodon/cross.png" )

	local dotFinder = string.find( vehSpeed, "." )
	local realSpeed = string.sub( vehSpeed, 1, dotFinder + 1 )

	if string.len( vehName ) > 30 then x = 575 end

	local redColor = Color( 231, 65, 51 )

	local VehPanel = vgui.Create( "DFrame" )
	VehPanel:SetSize( x, y )
	VehPanel:SetPos( rX, 0 )
	VehPanel:MoveTo( rX, rY, 0.2, 0, 1, function() 
		EmergencyResponse:SlideTextDLabel( VehPanel, EmergencyResponse:GetResponsiveFont(), "Name: " .. vehName, x, y * 0.5, x * 0.02, y * 0.25, color_white, 1 )

		if ownerWanted then
			EmergencyResponse:SlideTextDLabel( VehPanel, EmergencyResponse:GetResponsiveFont(), EDLang[EDLang.Settings]["traficpolicer_Owner"] .. vehOwner .. " " .. "(WANTED)", x * 0.9, y * 0.5, x * 0.02, y * 0.005, redColor, 1 )
		else
			EmergencyResponse:SlideTextDLabel( VehPanel, EmergencyResponse:GetResponsiveFont(), EDLang[EDLang.Settings]["traficpolicer_Owner"] .. vehOwner, x * 0.9, y * 0.5, x * 0.02, y * 0.005, color_white, 1 )
		end

		EmergencyResponse:SlideTextDLabel( VehPanel, EmergencyResponse:GetResponsiveFont(), EDLang[EDLang.Settings]["traficpolicer_Velocity"] .. realSpeed .. EmergencyDispatch.VelocityName, x * 0.9, y * 0.5, x * 0.02, y * 0.5, color_white, 1 )
	end )
	VehPanel:SetTitle( "" )
	VehPanel:ShowCloseButton( false )
	function VehPanel.Think()
		if CurTime() > DrawRoundedBoxTimer then return end 

		local TimerLeft = DrawRoundedBoxTimer - CurTime()
		local RoundedBoxP1 = ( TimerLeft / ( 5 / 100 ) ) / 100
		RoundedLong = 1 - RoundedBoxP1
	end
	function VehPanel.Paint( self, w, h )
		draw.RoundedBox( 2.5, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBackground2 )
		draw.RoundedBox( 1.5, 0, 0, w * RoundedLong, h * 0.05, EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBarColor )
		draw.RoundedBox( 1.5, 0, h * 0.96, w * RoundedLong, h * 0.05, EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBarColor )
	end

	timer.Simple(5, function()
		if not IsValid( VehPanel ) then return end
		VehPanel:MoveTo( rX, -400, 0.2, 0, 1 )

		timer.Simple(.2, function()
			if not IsValid( VehPanel ) then return end
			VehPanel:Remove()
		end )
	end )
end )