local allPanicButtonFrames = allPanicButtonFrames or {}
local blur = Material("pp/blurscreen")

local function DrawBlur( p, a, d )
	local x, y = p:LocalToScreen( 0, 0 )
	
	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( blur )
	
	for i = 1, d do
		blur:SetFloat( "$blur", (i / d ) * ( a ) )
		blur:Recompute()
		
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
	end
end

function EmergencyResponse:VictimSendEmergency( emergency )
	local x, y = 700, 300
	local rX, rY = ( ScrW() - x ) / 2, ( ScrH() - y ) / 2

	local DrawRoundedBoxTimer = CurTime() + 5

	local UIEmergency = vgui.Create( "DFrame" )
	UIEmergency:SetSize( x, y )
	UIEmergency:SetPos( rX, rY )
	UIEmergency:SetTitle( "" )
	UIEmergency:ShowCloseButton( false )
	UIEmergency:SetDraggable( false )
	UIEmergency:MakePopup()
	function UIEmergency.Think()
		if CurTime() > DrawRoundedBoxTimer then return end 

		local TimerLeft = DrawRoundedBoxTimer - CurTime()
		local RoundedBoxP1 = ( TimerLeft / ( 5 / 100 ) ) / 100
		RoundedLong = 1 - RoundedBoxP1
	end
	function UIEmergency.Paint( self, w, h )
		if EmergencyDispatch.DrawBlurOnMenu then
			DrawBlur( self, 2, 10 )
			draw.RoundedBox( 0, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.PlayerMenu_Blur )
		else
			draw.RoundedBox( 0, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.PlayerMenu )
		end

		draw.RoundedBox( 1, 0, 0, w * RoundedLong * 3, h * 0.01, EmergencyDispatch.ColorsConfiguration.HoveringButton )
		draw.RoundedBox( 1, 0, h * 0.99, w * RoundedLong * 3, h * 0.01, EmergencyDispatch.ColorsConfiguration.HoveringButton )
	end

	local UIRemove = vgui.Create( "DButton", UIEmergency )
	UIRemove:SetSize( 23, 23 )
	UIRemove:SetPos( x * 0.95, y * 0.035 )
	UIRemove:SetText( "" )
	function UIRemove.OnCursorEntered( self ) 
		if EmergencyDispatch.SoundConfiguration then
			surface.PlaySound( EmergencyDispatch.UIButtonSound )
		end 

		self.hover = true
	end
	function UIRemove.OnCursorExited( self ) self.hover = false end 
	function UIRemove.Paint( self, w, h )
		if self.hover then 
			surface.SetDrawColor( 255, 255, 255 )
		else
			surface.SetDrawColor( 255, 255, 255, 175 )
		end

		surface.SetMaterial( EmergencyDispatch.CloseMenuIcon )
		surface.DrawTexturedRect( 0, 0, 23, 23 )
	end
	function UIRemove.DoClick()
		UIEmergency:MoveTo( ScrW() * 2, rY, 0.2, 0, 1 )
		timer.Simple( 0.2, function() 
			if IsValid( UIEmergency ) then 
				UIEmergency:Remove()
			end
		end )
	end

	EmergencyResponse:SlideTextDLabel( UIEmergency, EmergencyResponse:GetResponsiveFont(), EDLang[EDLang.Settings]["victimderma_WriteMessage"], x * 0.9, y * 0.2, x * 0.05, y * 0.03, color_white, 1.25 )

	local sendMaterial = Material( EmergencyDispatch.IconSend )
	local cancelMaterial = Material( EmergencyDispatch.IconCancel )

	local UIMessage = vgui.Create( "DTextEntry", UIEmergency )
	UIMessage:SetSize( x * 0.9, y * 0.38 )
	UIMessage:SetPos( x * 0.05, y * 0.25 )
	UIMessage:SetMultiline( true )
	UIMessage:SetDrawLanguageID( false )
	UIMessage:SetFont( "Trebuchet24" )
	UIMessage.CalloutReason = "N/A"
	UIMessage:SetTextColor( EmergencyDispatch.ColorsConfiguration.TextEntryColor )
	function UIMessage.Paint( self, w, h )
		if EmergencyDispatch.DrawBlurOnMenu then 
			draw.RoundedBox( 2, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.PlayerMenu_ButtonsBackground_Blur2 )
		else
			draw.RoundedBox( 5, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.PlayerMenu_ButtonsBackground )
		end 

		self:DrawTextEntryText( color_white, EmergencyDispatch.ColorsConfiguration.PlayerMenu_ButtonsBackground, color_white )
	end

	if EmergencyResponse_DLC_PoliceEquipmentGear and EmergencyResponse_DLC_PoliceEquipmentGear.DispatchCallout_Theme == "lspdfr" then
		UIMessage:SetSize( x * 0.9, y * 0.25 )
		UIMessage:SetPos( x * 0.05, ((y * 0.725) - y * 0.31) )

		local dReason = vgui.Create( "DComboBox", UIEmergency )
		dReason:SetSize( x * 0.9, y * 0.1 )
		dReason:SetPos( x * 0.05, (((y * 0.725) - y * 0.3) - y * 0.17) )
		dReason:SetText( EDLang[EDLang.Settings]["ChooseReason"] )
		dReason:SetTextColor( color_white )
		dReason:SetFont( EmergencyResponse_DLC_PoliceEquipmentGear:ResponsiveFont( "extra_light_light" ) )
		function dReason.Paint( self, w, h )
			if EmergencyDispatch.DrawBlurOnMenu then 
				draw.RoundedBox( 2, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.PlayerMenu_ButtonsBackground_Blur2 )
			else
				draw.RoundedBox( 5, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.PlayerMenu_ButtonsBackground )
			end 
		end
		for k, v in SortedPairs( EmergencyResponse_DLC_PoliceEquipmentGear.PreconfiguredEmergencyMessages[emergency] ) do
			dReason:AddChoice( v )
		end
		function dReason:OnSelect( index, value, data )
			UIMessage.CalloutReason = value
		end
	end
	
	local c_GREEN = Color( 20, 187, 18 )

	local UISend = vgui.Create( "DButton", UIEmergency )
	UISend:SetSize( UIMessage:GetWide(), y * 0.175 )
	UISend:SetPos( x * 0.05, y * 0.725 )
	UISend:SetText( "" )
	UISend.Slide = 0
	UISend.OnCursorEntered = function( self ) 
		if EmergencyDispatch.SoundConfiguration then
			surface.PlaySound( EmergencyDispatch.UIButtonSound )
		end

		self.hover = true
	end
	function UISend.OnCursorExited( self ) self.hover = false end
	UISend.Paint = function( self, w, h )
		if EmergencyDispatch.DrawBlurOnMenu then 
			draw.RoundedBox( 2, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.PlayerMenu_ButtonsBackground_Blur2 )
		else
			draw.RoundedBox( 5, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.PlayerMenu_ButtonsBackground )
		end

		if self.hover then
			self.Slide = Lerp( 0.05, self.Slide, w )

			draw.NoTexture()
			surface.SetDrawColor( EmergencyDispatch.ColorsConfiguration.HoveringButton )
			surface.DrawTexturedRectRotated( -20, 40, self.Slide, h * h, 20 )
		else
			self.Slide = Lerp( 0.05, self.Slide, 0 )

			draw.NoTexture()
			surface.SetDrawColor( EmergencyDispatch.ColorsConfiguration.HoveringButton )
			surface.DrawTexturedRectRotated( -20, 40, self.Slide, h * h, 20 )
		end

		draw.DrawText( EDLang[EDLang.Settings]["sendCalout"], EmergencyResponse:GetResponsiveFont(), w * 0.5, h * 0.175, color_white, 1 )
	end
	UISend.DoClick = function()
		local nUse = cookie.GetNumber( "_cooldown_menuderma_Victim", 0 )
		local nTime = os.time()
		if nTime < nUse then return end

		if ( string.len( UIMessage:GetValue() ) < 4 ) then
			EmergencyResponse:SendNotification( EDLang[EDLang.Settings]["notif_ErrorDTextEntry"], 3)
			cookie.Set( "_cooldown_menuderma_Victim", nTime + 5 )
			return
		end

		if EmergencyResponse_DLC_PoliceEquipmentGear and EmergencyResponse_DLC_PoliceEquipmentGear.DispatchCallout_Theme == "lspdfr" then
			if UIMessage.CalloutReason == "" then
				EmergencyResponse:SendNotification( EDLang[EDLang.Settings]["notif_ErrorDCombo"], 3)
				cookie.Set( "_cooldown_menuderma_Victim", nTime + 5 )
				return
			end 
		end
		
		UIEmergency:MoveTo( ScrW() * 3, rY, 0.2, 0, 1)
		timer.Simple( 0.2, function() 
			if IsValid( UIEmergency ) then 
				UIEmergency:Remove()
			end
		end )

		net.Start( "EmergencyDispatch:DispatchCallout:ServerReception" )
			net.WriteString( emergency )
			net.WriteString( UIMessage:GetValue() )
			net.WriteString( UIMessage.CalloutReason )
		net.SendToServer()

		EmergencyResponse:SendNotification( EDLang[EDLang.Settings]["notif_CalloutSent"], 3)
	end

end

function EmergencyResponse:CreateVictimInterface( bool, text )
	local x, y = 700, 425
	local rX, rY = ( ScrW() - x ) / 2, ( ScrH() - y ) / 2

	local DrawRoundedBoxTimer = CurTime() + 5
	local RoundedLong = 0

	local FrameUI = vgui.Create( "DFrame" )
	FrameUI:SetSize( x, y )
	FrameUI:SetPos( ScrW() * 3, rY )
	FrameUI:MoveTo( rX, rY, 0.2, 0, 1, function() surface.PlaySound( EmergencyDispatch.FramesTransitionSound ) end )
	FrameUI:SetTitle( "" )
	FrameUI:ShowCloseButton( false )
	FrameUI:SetDraggable( true )
	FrameUI:MakePopup()
	function FrameUI.Think()
		if CurTime() > DrawRoundedBoxTimer then return end 

		local TimerLeft = DrawRoundedBoxTimer - CurTime()
		local RoundedBoxP1 = ( TimerLeft / ( 5 / 100 ) ) / 100
		RoundedLong = 1 - RoundedBoxP1
	end
	function FrameUI.Paint( self, w, h )
		if EmergencyDispatch.DrawBlurOnMenu then
			DrawBlur( self, 2, 10 )
			draw.RoundedBox( 0, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.PlayerMenu_Blur )
		else
			draw.RoundedBox( 0, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.PlayerMenu )
		end

		draw.RoundedBox( 0, 0, 0, w * RoundedLong * 3, h * 0.01, EmergencyDispatch.ColorsConfiguration.HoveringButton )
		draw.RoundedBox( 0, 0, h * 0.991, w * RoundedLong * 3, h * 0.01, EmergencyDispatch.ColorsConfiguration.HoveringButton )
	end

	local UIRemove = vgui.Create( "DButton", FrameUI )
	UIRemove:SetSize( 23, 23 )
	UIRemove:SetPos( x * 0.95, y * 0.035 )
	UIRemove:SetText( "" )
	function UIRemove.OnCursorEntered( self ) 
		if EmergencyDispatch.SoundConfiguration then
			surface.PlaySound( EmergencyDispatch.UIButtonSound )
		end 

		self.hover = true
	end
	function UIRemove.OnCursorExited( self ) self.hover = false end 
	function UIRemove.Paint( self, w, h )
		if self.hover then 
			surface.SetDrawColor( 255, 255, 255 )
		else
			surface.SetDrawColor( 255, 255, 255, 175 )
		end

		surface.SetMaterial( EmergencyDispatch.CloseMenuIcon )
		surface.DrawTexturedRect( 0, 0, 23, 23 )
	end
	function UIRemove.DoClick()
		FrameUI:MoveTo( ScrW() * 2, rY, 0.2, 0, 1 )
		timer.Simple( 0.2, function() 
			if IsValid( FrameUI ) then 
				FrameUI:Remove()
			end
		end )
	end

	EmergencyResponse:SlideTextDLabel( FrameUI, EmergencyResponse:GetResponsiveFont(), EDLang[EDLang.Settings]["victimderma_TextIntro"], x * 0.9, y * 0.2, x * 0.065, 0, color_white, 1 )
	local serverEmergencyServices = { 
		EDLang[EDLang.Settings]["victimderma_LawEnforcement"], 
		EDLang[EDLang.Settings]["victimderma_EMS"], 
		EDLang[EDLang.Settings]["victimderma_Firefighters"] 
	}

	timer.Simple(0.65, function()
		if not IsValid( FrameUI ) then return end

		local TimeSTOP = CurTime() + 5

		local DScrollPanel = vgui.Create( "DPanel", FrameUI )
		DScrollPanel:SetSize( x * 0.9, 0 )
		DScrollPanel:SetPos( x * 0.05, y * 0.175 )
		function DScrollPanel.Paint( self, w , h )
		end
		function DScrollPanel.Think()
			if CurTime() > TimeSTOP then return end 

			local TimeLeft = TimeSTOP - CurTime()
			local PanelSizeP1 = ( TimeLeft / ( 5 / 100 ) ) / 100
			local PanelLong = 1 - PanelSizeP1

			DScrollPanel:SetSize( x * 0.9, ( y * 5 ) * PanelLong )
		end

		for k, v in pairs( serverEmergencyServices ) do
			local mat_Services = Material( EmergencyResponse:ReturnMaterialIcon( k ) )

			local SPanel = vgui.Create( "DPanel", DScrollPanel )
			SPanel:SetSize( x * 0.9, y * 0.2 )
			SPanel:Dock( TOP )
			SPanel:DockMargin( 10, 10, 10, 10 )
			function SPanel.Paint( self, w, h )
				draw.RoundedBox( 2, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.PlayerMenu_ButtonsBackground )

				surface.SetDrawColor( color_white )
				surface.SetMaterial( mat_Services )
				surface.DrawTexturedRect( SPanel:GetWide() * 0.01, SPanel:GetTall() - 75, 75, 75 )

				draw.SimpleText( string.upper( v ), EmergencyResponse:GetResponsiveFont(), w * 0.15, h * 0.27, EmergencyDispatch.ColorsConfiguration.TitlesFramesColors, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end

			local c_RED = Color( 204, 19, 19 )
			local c_GREEN = Color( 20, 187, 18 )
			local c_DIFF = Color( 255, 255, 255, 10 )

			local SDesc = vgui.Create( "DLabel", SPanel )
			SDesc:SetSize( x * 0.6, y * 0.1 )
			SDesc:SetPos( SPanel:GetWide() * 0.1475, SPanel:GetTall() * 0.475 )
			SDesc:SetFont( "Trebuchet24" )
			SDesc.Status = 0
			if v == EDLang[EDLang.Settings]["victimderma_LawEnforcement"] then 
				SDesc:SetText( EDLang[EDLang.Settings]["victimderma_TextIntro_Available"] .. EmergencyResponse:GetPlayersInJob( "CP" ) )
				SDesc.Status = EmergencyResponse:GetPlayersInJob( "CP" )
			elseif v == EDLang[EDLang.Settings]["victimderma_EMS"] then
				SDesc:SetText( EDLang[EDLang.Settings]["victimderma_TextIntro_Available"] .. EmergencyResponse:GetPlayersInJob( EmergencyDispatch.MedicJobs ) )
				SDesc.Status = EmergencyResponse:GetPlayersInJob( EmergencyDispatch.MedicJobs )
			else
				SDesc:SetText( EDLang[EDLang.Settings]["victimderma_TextIntro_Available"] .. EmergencyResponse:GetPlayersInJob( EmergencyDispatch.FirefightersJobs ) )
				SDesc.Status = EmergencyResponse:GetPlayersInJob( EmergencyDispatch.FirefightersJobs )
			end
			if SDesc.Status > 0 then
				SDesc:SetTextColor( c_GREEN )
			else
				SDesc:SetTextColor( c_RED )
			end

			local SChoice = vgui.Create( "DButton", SPanel )
			SChoice:SetSize( SPanel:GetWide() * 0.17, SPanel:GetTall() * 0.5 )
			SChoice:SetPos( SPanel:GetWide() * 0.93 - SChoice:GetWide(), y * 0.05 )
			SChoice:SetText( "" )
			SChoice.Slide = 0
			if SDesc.Status > 0 then 
				function SChoice.OnCursorEntered( self ) self.hover = true surface.PlaySound( EmergencyDispatch.UIButtonSound ) end
				function SChoice.OnCursorExited( self ) self.hover = false end
			end
			function SChoice.Paint( self, w, h )
				if SDesc.Status > 0 then 
					draw.RoundedBox( 4, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.HoveringButton )
					draw.DrawText( EDLang[EDLang.Settings]["Calltxt"], EmergencyResponse:GetResponsiveFont(), w * 0.5, h * 0.15, color_white, 1 )
				else
					draw.RoundedBox( 4, 0, 0, w, h, c_DIFF )
					draw.DrawText( "N/A", EmergencyResponse:GetResponsiveFont(), w * 0.5, h * 0.15, color_white, 1 )
				end
			end
			function SChoice.DoClick()
				if SDesc.Status > 0 then
					FrameUI:Remove()

					if bool and ( string.len( text ) > 3 ) then 
						net.Start( "EmergencyDispatch:DispatchCallout:ServerReception" )
							net.WriteString( EmergencyResponse:GetClientEmergency( v ) )
							net.WriteString( text )
						net.SendToServer()

						EmergencyResponse:SendNotification( EDLang[EDLang.Settings]["notif_CalloutSent"], 3)
					else
						EmergencyResponse:VictimSendEmergency( EmergencyResponse:GetClientEmergency( v ) )
					end
				end
			end

		end

	end )
end

net.Receive("EmergencyDispatch:DispatchCallout:VictimMenu", function()
	local bool = net.ReadBool()

	local DPhone = vgui.Create( 'DFrame' )
	DPhone:SetSize( ScrW() / 2, ScrH() / 2 )
	DPhone:SetPos( ScrW() * 0.3, ScrH() * 3 )
	DPhone:MoveTo( ScrW() * 0.3, ScrH() / 2, 0.2, 0, 1 )
	DPhone:SetTitle( '' )
	DPhone:ShowCloseButton( false )
	DPhone.Paint = function()
		draw.RoundedBox( 0, 0, 0, DPhone:GetWide(), DPhone:GetTall(), EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBackgroundTransparent )
	end

	if EmergencyDispatch.InstantEmergencyCall then 
		if not bool then 
			return EmergencyResponse:SendNotification( EDLang[EDLang.Settings]["notif_Call911Failed"], 6 )
		end
		
		EmergencyResponse:CreateVictimInterface( false, nil )
	else
		local thePhone = vgui.Create( "DImage", DPhone )
		thePhone:SetPos( 10, 35 )
		thePhone:SetSize( DPhone:GetWide(), DPhone:GetTall() )
		thePhone:SetImage( EmergencyDispatch.PhoneMaterial )

		EmergencyResponse:SendNotification( EDLang[EDLang.Settings]["notif_Call911Operator"], 6 )
		timer.Simple(7, function()

			if IsValid( DPhone ) then

				DPhone:MoveTo( ScrW() / 4, ScrH() / 1, 0.2, 0, 1, function()
					DPhone:Remove()

					if not bool then 
						EmergencyResponse:SendNotification( EDLang[EDLang.Settings]["notif_Call911Failed"], 6 ) 
						return 
					end
					EmergencyResponse:CreateVictimInterface( false, nil ) 
				end )

			end 

		end )
	end
end )

net.Receive( "EmergencyDispatch:DispatchRadio:PanicButton:KeyPressed", function()
	local frameCheck = net.ReadBool()
	local frameNotif = net.ReadBool()
	local x, y = 600, 150
	local rX, rY = ( ScrW() - x ) * 0.05, ( ScrH() - y ) * 0.05
	local frameParent = nil

	for k, frames in pairs( allPanicButtonFrames ) do
		if frameCheck then
			if k < 0 then return end

			frames:MoveTo( ScrW() * 3, rY, 0.2, 0, 1 )
			timer.Simple(0.2, function() 
				if IsValid( frames ) then
					frames:Remove()
				end
			end )

			table.remove( allPanicButtonFrames, #allPanicButtonFrames )
			if frameNotif then EmergencyResponse:SendNotification( EDLang[EDLang.Settings]["dermapanic_PanicButtonSent"], 5 ) end
			return
		end
	end

	timer.Simple(0.3, function()
		if not IsValid( LocalPlayer() ) then return end 

		local DrawRoundedBoxTimer = CurTime() + 5
		local RoundedLong = 0

		local UIPanicButton = vgui.Create( "DFrame" )
		UIPanicButton:SetSize( x, y )
		UIPanicButton:SetPos( rX, 0 )
		UIPanicButton:MoveTo( rX, rY, 0.2, 0, 1, function() 
			EmergencyResponse:SlideTextDLabel( UIPanicButton, EmergencyResponse:GetResponsiveFont(), EDLang[EDLang.Settings]["dermapanic_pressRAgain"], x * 0.9, y * 0.5, x * 0.05, y * 0.25, color_white, 1.5 )
		end )
		UIPanicButton:SetTitle( "" )
		UIPanicButton:ShowCloseButton( false )
		UIPanicButton:SetDraggable( false )
		function UIPanicButton.Think()
			if CurTime() > DrawRoundedBoxTimer then return end 

			local TimerLeft = DrawRoundedBoxTimer - CurTime()
			local RoundedBoxP1 = ( TimerLeft / ( 5 / 100 ) ) / 100
			RoundedLong = 1 - RoundedBoxP1
		end
		function UIPanicButton.Paint( self, w, h )
			draw.RoundedBox( 4, 0, 0, w, h, EmergencyDispatch.ColorsConfiguration.PlayerMenu )
			draw.RoundedBox( 1.5, 0, 0, w * RoundedLong, h * 0.05, EmergencyDispatch.ColorsConfiguration.HoveringButton )
			draw.RoundedBox( 1.5, 0, h * 0.96, w * RoundedLong, h * 0.05, EmergencyDispatch.ColorsConfiguration.HoveringButton )
		end
		frameParent = UIPanicButton
		table.insert( allPanicButtonFrames, UIPanicButton )
	end )

	timer.Simple(5.3, function()
		if IsValid( frameParent ) then

			frameParent:MoveTo( ScrW() * 3, rY, 0.2, 0, 1 )
			timer.Simple(0.2, function() 
				if IsValid( frameParent ) then
					frameParent:Remove()
				end
			end )

			table.remove( allPanicButtonFrames, #allPanicButtonFrames )

			net.Start( "EmergencyDispatch:DispatchRadio:BackupOptions:PanicButton:CancelOperation" )
			net.SendToServer()
		end 
	end )
end )

net.Receive( "EmergencyDispatch:DispatchCallout:VictimMenu:WithoutWritingText", function()
	local text = net.ReadString()

	local DPhone = vgui.Create( 'DFrame' )
	DPhone:SetSize( ScrW() / 2, ScrH() / 2 )
	DPhone:SetPos( ScrW() * 0.3, ScrH() * 3 )
	DPhone:MoveTo( ScrW() * 0.3, ScrH() / 2, 0.2, 0, 1 )
	DPhone:SetTitle( '' )
	DPhone:ShowCloseButton( false )
	DPhone.Paint = function()
		draw.RoundedBox( 0, 0, 0, DPhone:GetWide(), DPhone:GetTall(), EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBackgroundTransparent )
	end

	if EmergencyDispatch.InstantEmergencyCall then 
		EmergencyResponse:CreateVictimInterface( true, text )
	else
		local thePhone = vgui.Create( "DImage", DPhone )
		thePhone:SetPos( 10, 35 )
		thePhone:SetSize( DPhone:GetWide(), DPhone:GetTall() )
		thePhone:SetImage( EmergencyDispatch.PhoneMaterial )

		EmergencyResponse:SendNotification( EDLang[EDLang.Settings]["notif_Call911Operator"], 6 )
		timer.Simple(7, function()
			if IsValid( DPhone ) then
				DPhone:MoveTo( ScrW() / 4, ScrH() / 1, 0.2, 0, 1, function()
					DPhone:Remove()

					EmergencyResponse:CreateVictimInterface( true, text )
				end )
			end 
		end )
	end
end )