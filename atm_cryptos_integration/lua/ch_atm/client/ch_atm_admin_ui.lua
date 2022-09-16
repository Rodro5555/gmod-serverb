--[[
	Net message to show atm admin menu.
--]]
net.Receive( "CH_ATM_Net_AdminMenu", function( len, ply )
	if not LocalPlayer():CH_ATM_IsAdmin() then
		return
	end
	
	CH_ATM.AdminMenu()
end )

--[[
	ATM ADMIN MENU
--]]
function CH_ATM.AdminMenu()
	local scr_w = ScrW()
	local scr_h = ScrH()
	
	CH_ATM.GUI_AdminMenu = vgui.Create( "DFrame" )
	CH_ATM.GUI_AdminMenu:SetTitle( "" )
	CH_ATM.GUI_AdminMenu:SetSize( scr_w * 0.5, scr_h * 0.6 )
	CH_ATM.GUI_AdminMenu:Center()
	CH_ATM.GUI_AdminMenu.Paint = function( self, w, h )
		-- Draw frame
		surface.SetDrawColor( CH_ATM.Colors.LightGray )
		surface.DrawRect( 0, 0, w, h )
		
		-- Draw top
		surface.SetDrawColor( CH_ATM.Colors.DarkGray )
		surface.DrawRect( 0, 0, w, scr_h * 0.04 )
		
		-- Draw left navigation panel
		surface.SetDrawColor( CH_ATM.Colors.DarkGray )
		surface.DrawRect( 0, 0, scr_w * 0.1, h )
		
		-- Draw the top title.
		draw.SimpleText( CH_ATM.LangString( "Admin Menu" ), "CH_ATM_Font_ATMScreen_Size35", w / 2, scr_h * 0.02, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	CH_ATM.GUI_AdminMenu:MakePopup()
	CH_ATM.GUI_AdminMenu:SetDraggable( false )
	CH_ATM.GUI_AdminMenu:ShowCloseButton( false )
	
	local GUI_CloseMenu = vgui.Create( "DButton", CH_ATM.GUI_AdminMenu )
	GUI_CloseMenu:SetPos( scr_w * 0.4825, scr_h * 0.01 )
	GUI_CloseMenu:SetSize( 24, 24 )
	GUI_CloseMenu:SetText( "" )
	GUI_CloseMenu.Paint = function( self, w, h )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( CH_ATM.Materials.CloseIcon )
		surface.DrawTexturedRect( 0, 0, 24, 24 )
	end
	GUI_CloseMenu.DoClick = function()
		CH_ATM.GUI_AdminMenu:Remove()
	end
	
	local GUI_PlayerListBtn = vgui.Create( "DButton", CH_ATM.GUI_AdminMenu )
	GUI_PlayerListBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_PlayerListBtn:SetPos( 0, scr_h * 0.04 )
	GUI_PlayerListBtn:SetText( "" )
	GUI_PlayerListBtn.Paint = function( self, w, h )
		surface.SetDrawColor( CH_ATM.Colors.GMSBlue )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Players" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_PlayerListBtn.DoClick = function()
	end
	
	local GUI_SettingsBtn = vgui.Create( "DButton", CH_ATM.GUI_AdminMenu )
	GUI_SettingsBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_SettingsBtn:SetPos( 0, scr_h * 0.09 )
	GUI_SettingsBtn:SetText( "" )
	GUI_SettingsBtn.Paint = function( self, w, h )
		surface.SetDrawColor( color_transparent )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "ATM Settings" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_SettingsBtn.DoClick = function()
		CH_ATM.AdminMenuSettings()
		
		CH_ATM.GUI_AdminMenu:Remove()
	end
	
	local GUI_ConvertDataBtn = vgui.Create( "DButton", CH_ATM.GUI_AdminMenu )
	GUI_ConvertDataBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_ConvertDataBtn:SetPos( 0, scr_h * 0.14 )
	GUI_ConvertDataBtn:SetText( "" )
	GUI_ConvertDataBtn.Paint = function( self, w, h )
		surface.SetDrawColor( color_transparent )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Import Data" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_ConvertDataBtn.DoClick = function()
		CH_ATM.AdminMenuConvertData()
		
		CH_ATM.GUI_AdminMenu:Remove()
	end
	
	local GUI_OfflineBtn = vgui.Create( "DButton", CH_ATM.GUI_AdminMenu )
	GUI_OfflineBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_OfflineBtn:SetPos( 0, scr_h * 0.19 )
	GUI_OfflineBtn:SetText( "" )
	GUI_OfflineBtn.Paint = function( self, w, h )
		surface.SetDrawColor( color_transparent )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Manage Offline" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_OfflineBtn.DoClick = function()
		CH_ATM.AdminMenuLookupOffline()
		
		CH_ATM.GUI_AdminMenu:Remove()
	end
	
	-- The players list
	local GUI_PlayerList = vgui.Create( "DPanelList", CH_ATM.GUI_AdminMenu )
	GUI_PlayerList:SetSize( scr_w * 0.391, scr_w * 0.3075 )
	GUI_PlayerList:SetPos( scr_w * 0.105, scr_h * 0.0465 )
	GUI_PlayerList:EnableVerticalScrollbar( true )
	GUI_PlayerList:EnableHorizontal( true )
	GUI_PlayerList:SetSpacing( 8 )
	GUI_PlayerList.Paint = function( self, w, h )
		--draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 100, 100, 10 ) )
	end
	
	if ( GUI_PlayerList.VBar ) then
		GUI_PlayerList.VBar.Paint = function( self, w, h ) -- BG
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
			surface.DrawRect( 0, 0, w, h )
		end
		
		GUI_PlayerList.VBar.btnUp.Paint = function( self, w, h )
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
			surface.DrawRect( 0, 0, w, h )
		end
		
		GUI_PlayerList.VBar.btnGrip.Paint = function( self, w, h )
			surface.SetDrawColor( CH_ATM.Colors.WhiteAlpha )
			surface.DrawRect( 0, 0, w, h )
		end
		
		GUI_PlayerList.VBar.btnDown.Paint = function( self, w, h )
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
			surface.DrawRect( 0, 0, w, h )
		end
	end
	
	for k, ply in ipairs( player.GetAll() ) do
		if IsValid( ply ) then
			-- Panel per player
			local GUI_PlayerPanel = vgui.Create( "DPanelList" )
			GUI_PlayerPanel:SetSize( scr_w * 0.38, scr_h * 0.075 )
			GUI_PlayerPanel.Paint = function( self, w, h )
				-- Background
				surface.SetDrawColor( CH_ATM.Colors.DarkGray )
				surface.DrawRect( 0, 0, w, h )
			
				-- Player namd and usergroup
				draw.SimpleText( ply:Nick(), "CH_ATM_Font_ATMScreen_Size25", w * 0.11, h * 0.225, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( ply:SteamID64() or "BOT", "CH_ATM_Font_ATMScreen_Size20", w * 0.11, h * 0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				if ply:GetUserGroup() then
					draw.SimpleText( ply:GetUserGroup(), "CH_ATM_Font_ATMScreen_Size20", w * 0.11, h * 0.75, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				else
					draw.SimpleText( "N/A", "CH_ATM_Font_ATMScreen_Size20", w * 0.11, h * 0.75, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end
			end
			
			local GUI_PlayerAvatar = vgui.Create( "AvatarImage", GUI_PlayerPanel )
			GUI_PlayerAvatar:SetSize( 65, 65 )
			GUI_PlayerAvatar:SetPos( scr_w * 0.005, scr_h * 0.0075 )
			GUI_PlayerAvatar:SetPlayer( ply, 128 )
			
			local GUI_ViewPlayer = vgui.Create( "DButton", GUI_PlayerPanel )
			GUI_ViewPlayer:SetSize( scr_w * 0.08, scr_h * 0.061 )
			GUI_ViewPlayer:SetPos( scr_w * 0.296, scr_h * 0.0075 )
			GUI_ViewPlayer:SetText( "" )
			GUI_ViewPlayer.Paint = function( self, w, h )
				if self:IsHovered() then
					surface.SetDrawColor( CH_ATM.Colors.GMSBlue )
				else
					surface.SetDrawColor( CH_ATM.Colors.LightGray )
				end
				surface.DrawRect( 0, 0, w, h )
				
				draw.SimpleText( CH_ATM.LangString( "View Player" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			GUI_ViewPlayer.DoClick = function()
				net.Start( "CH_ATM_Net_AdminViewPlayer" )
					net.WriteEntity( ply )
				net.SendToServer()
				
				CH_ATM.GUI_AdminMenu:Remove()
			end
			
			GUI_PlayerList:AddItem( GUI_PlayerPanel )
			
		end
	end
end






--[[
	ATM SETTINGS ADMIN MENU
--]]
function CH_ATM.AdminMenuSettings()
	local ply = LocalPlayer()
	
	local scr_w = ScrW()
	local scr_h = ScrH()
	
	CH_ATM.GUI_AdminMenuSettings = vgui.Create( "DFrame" )
	CH_ATM.GUI_AdminMenuSettings:SetTitle( "" )
	CH_ATM.GUI_AdminMenuSettings:SetSize( scr_w * 0.5, scr_h * 0.6 )
	CH_ATM.GUI_AdminMenuSettings:Center()
	CH_ATM.GUI_AdminMenuSettings.Paint = function( self, w, h )
		-- Draw frame
		surface.SetDrawColor( CH_ATM.Colors.LightGray )
		surface.DrawRect( 0, 0, w, h )
		
		-- Draw top
		surface.SetDrawColor( CH_ATM.Colors.DarkGray )
		surface.DrawRect( 0, 0, w, scr_h * 0.04 )
		
		-- Draw left navigation panel
		surface.SetDrawColor( CH_ATM.Colors.DarkGray )
		surface.DrawRect( 0, 0, scr_w * 0.1, h )
		
		-- Draw the top title.
		draw.SimpleText( CH_ATM.LangString( "ATM Settings" ), "CH_ATM_Font_ATMScreen_Size35", w / 2, scr_h * 0.02, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	CH_ATM.GUI_AdminMenuSettings:MakePopup()
	CH_ATM.GUI_AdminMenuSettings:SetDraggable( false )
	CH_ATM.GUI_AdminMenuSettings:ShowCloseButton( false )
	
	local GUI_CloseMenu = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuSettings )
	GUI_CloseMenu:SetPos( scr_w * 0.4825, scr_h * 0.01 )
	GUI_CloseMenu:SetSize( 24, 24 )
	GUI_CloseMenu:SetText( "" )
	GUI_CloseMenu.Paint = function( self, w, h )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( CH_ATM.Materials.CloseIcon )
		surface.DrawTexturedRect( 0, 0, 24, 24 )
	end
	GUI_CloseMenu.DoClick = function()
		CH_ATM.GUI_AdminMenuSettings:Remove()
	end

	local GUI_PlayerListBtn = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuSettings )
	GUI_PlayerListBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_PlayerListBtn:SetPos( 0, scr_h * 0.04 )
	GUI_PlayerListBtn:SetText( "" )
	GUI_PlayerListBtn.Paint = function( self, w, h )
		surface.SetDrawColor( color_transparent )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Players" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_PlayerListBtn.DoClick = function()
		CH_ATM.AdminMenu()
		
		CH_ATM.GUI_AdminMenuSettings:Remove()
	end
	
	local GUI_SettingsBtn = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuSettings )
	GUI_SettingsBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_SettingsBtn:SetPos( 0, scr_h * 0.09 )
	GUI_SettingsBtn:SetText( "" )
	GUI_SettingsBtn.Paint = function( self, w, h )
		surface.SetDrawColor( CH_ATM.Colors.GMSBlue )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "ATM Settings" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_SettingsBtn.DoClick = function()
	end
	
	local GUI_ConvertDataBtn = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuSettings )
	GUI_ConvertDataBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_ConvertDataBtn:SetPos( 0, scr_h * 0.14 )
	GUI_ConvertDataBtn:SetText( "" )
	GUI_ConvertDataBtn.Paint = function( self, w, h )
		surface.SetDrawColor( color_transparent )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Import Data" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_ConvertDataBtn.DoClick = function()
		CH_ATM.AdminMenuConvertData()
		
		CH_ATM.GUI_AdminMenuSettings:Remove()
	end
	
	local GUI_OfflineBtn = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuSettings )
	GUI_OfflineBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_OfflineBtn:SetPos( 0, scr_h * 0.19 )
	GUI_OfflineBtn:SetText( "" )
	GUI_OfflineBtn.Paint = function( self, w, h )
		surface.SetDrawColor( color_transparent )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Manage Offline" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_OfflineBtn.DoClick = function()
		CH_ATM.AdminMenuLookupOffline()
		
		CH_ATM.GUI_AdminMenuSettings:Remove()
	end

	-- Setting buttons
	local GUI_SaveATMEntities = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuSettings )
	GUI_SaveATMEntities:SetSize( scr_w * 0.391, scr_h * 0.075 )
	GUI_SaveATMEntities:SetPos( scr_w * 0.105, scr_h * 0.0465 )
	GUI_SaveATMEntities:SetTextColor( Color( 0, 0, 0, 255 ) )
	GUI_SaveATMEntities:SetText( "" )
	GUI_SaveATMEntities.Paint = function( self, w, h )
		if self:IsHovered() then
			surface.SetDrawColor( CH_ATM.Colors.GMSBlue )
		else
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
		end
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Save ATM entities" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_SaveATMEntities.DoClick = function()
		LocalPlayer():ConCommand( "ch_atm_saveall" )
	end
	
	local GUI_ShowAllATMOnMap = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuSettings )
	GUI_ShowAllATMOnMap:SetSize( scr_w * 0.391, scr_h * 0.075 )
	GUI_ShowAllATMOnMap:SetPos( scr_w * 0.105, scr_h * 0.129 )
	GUI_ShowAllATMOnMap:SetTextColor( Color( 0, 0, 0, 255 ) )
	GUI_ShowAllATMOnMap:SetText( "" )
	GUI_ShowAllATMOnMap.Paint = function( self, w, h )
		if self:IsHovered() then
			surface.SetDrawColor( CH_ATM.Colors.GMSBlue )
		else
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
		end
		surface.DrawRect( 0, 0, w, h )
		
		if not LocalPlayer().CH_ATM_ShowATMEntitiesOnMap then
			draw.SimpleText( CH_ATM.LangString( "Show ATM entities on map" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( CH_ATM.LangString( "Stop showing ATM entities on map" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	GUI_ShowAllATMOnMap.DoClick = function()
		if not LocalPlayer().CH_ATM_ShowATMEntitiesOnMap then
			LocalPlayer().CH_ATM_ShowATMEntitiesOnMap = true
		else
			LocalPlayer().CH_ATM_ShowATMEntitiesOnMap = false
		end
	end
	
	local GUI_LockdownATMs = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuSettings )
	GUI_LockdownATMs:SetSize( scr_w * 0.391, scr_h * 0.075 )
	GUI_LockdownATMs:SetPos( scr_w * 0.105, scr_h * 0.2115 )
	GUI_LockdownATMs:SetTextColor( Color( 0, 0, 0, 255 ) )
	GUI_LockdownATMs:SetText( "" )
	GUI_LockdownATMs.Paint = function( self, w, h )
		if self:IsHovered() then
			surface.SetDrawColor( CH_ATM.Colors.GMSBlue )
		else
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
		end
		surface.DrawRect( 0, 0, w, h )
		
		if not CH_ATM.HasAdminEmergencyLockdownATM then
			draw.SimpleText( CH_ATM.LangString( "Initiate emergency ATM lockdown" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( CH_ATM.LangString( "Cancel emergency ATM lockdown" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	GUI_LockdownATMs.DoClick = function()
		if CH_ATM.HasAdminEmergencyLockdownATM then
			CH_ATM.HasAdminEmergencyLockdownATM = false
			
			net.Start( "CH_ATM_Net_AdminATMEmergencyLockdown" )
				net.WriteBool( CH_ATM.HasAdminEmergencyLockdownATM )
			net.SendToServer()
		else
			CH_ATM.HasAdminEmergencyLockdownATM = true
			
			net.Start( "CH_ATM_Net_AdminATMEmergencyLockdown" )
				net.WriteBool( CH_ATM.HasAdminEmergencyLockdownATM )
			net.SendToServer()
		end
	end
	
	if CH_ATM.Config.EnableSQL and CH_ATM.Config.EnableResetAllAccounts then
		local reset_confirm = false
		local GUI_ResetAllAccounts = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuSettings )
		GUI_ResetAllAccounts:SetSize( scr_w * 0.391, scr_h * 0.075 )
		GUI_ResetAllAccounts:SetPos( scr_w * 0.105, scr_h * 0.516 )
		GUI_ResetAllAccounts:SetTextColor( Color( 0, 0, 0, 255 ) )
		GUI_ResetAllAccounts:SetText( "" )
		GUI_ResetAllAccounts.Paint = function( self, w, h )
			if self:IsHovered() then
				surface.SetDrawColor( CH_ATM.Colors.GMSBlue )
			else
				surface.SetDrawColor( CH_ATM.Colors.DarkGray )
			end
			surface.DrawRect( 0, 0, w, h )
			
			if not reset_confirm then
				draw.SimpleText( CH_ATM.LangString( "Reset all balances" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( CH_ATM.LangString( "Reset all balances (Confirmation)" ), "CH_ATM_Font_ATMScreen_Size35", w / 2, h / 2, CH_ATM.Colors.Red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
		GUI_ResetAllAccounts.DoClick = function()
			if not reset_confirm then
				reset_confirm = true
			else
				-- SECOND CLICK = RESET ALL
				net.Start( "CH_ATM_Net_AdminResetAllAccounts" )
				net.SendToServer()
				
				CH_ATM.GUI_AdminMenuSettings:Remove()
			end
		end
	end
end






--[[
	ATM IMPORT DATA ADMIN MENU
--]]
function CH_ATM.AdminMenuConvertData()
	local ply = LocalPlayer()
	
	local scr_w = ScrW()
	local scr_h = ScrH()
	
	CH_ATM.GUI_AdminMenuConvertData = vgui.Create( "DFrame" )
	CH_ATM.GUI_AdminMenuConvertData:SetTitle( "" )
	CH_ATM.GUI_AdminMenuConvertData:SetSize( scr_w * 0.5, scr_h * 0.6 )
	CH_ATM.GUI_AdminMenuConvertData:Center()
	CH_ATM.GUI_AdminMenuConvertData.Paint = function( self, w, h )
		-- Draw frame
		surface.SetDrawColor( CH_ATM.Colors.LightGray )
		surface.DrawRect( 0, 0, w, h )
		
		-- Draw top
		surface.SetDrawColor( CH_ATM.Colors.DarkGray )
		surface.DrawRect( 0, 0, w, scr_h * 0.04 )
		
		-- Draw left navigation panel
		surface.SetDrawColor( CH_ATM.Colors.DarkGray )
		surface.DrawRect( 0, 0, scr_w * 0.1, h )
		
		-- Draw the top title.
		draw.SimpleText( CH_ATM.LangString( "Import Data" ), "CH_ATM_Font_ATMScreen_Size35", w / 2, scr_h * 0.02, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	CH_ATM.GUI_AdminMenuConvertData:MakePopup()
	CH_ATM.GUI_AdminMenuConvertData:SetDraggable( false )
	CH_ATM.GUI_AdminMenuConvertData:ShowCloseButton( false )
	
	local GUI_CloseMenu = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuConvertData )
	GUI_CloseMenu:SetPos( scr_w * 0.4825, scr_h * 0.01 )
	GUI_CloseMenu:SetSize( 24, 24 )
	GUI_CloseMenu:SetText( "" )
	GUI_CloseMenu.Paint = function( self, w, h )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( CH_ATM.Materials.CloseIcon )
		surface.DrawTexturedRect( 0, 0, 24, 24 )
	end
	GUI_CloseMenu.DoClick = function()
		CH_ATM.GUI_AdminMenuConvertData:Remove()
	end

	local GUI_PlayerListBtn = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuConvertData )
	GUI_PlayerListBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_PlayerListBtn:SetPos( 0, scr_h * 0.04 )
	GUI_PlayerListBtn:SetText( "" )
	GUI_PlayerListBtn.Paint = function( self, w, h )
		surface.SetDrawColor( color_transparent )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Players" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_PlayerListBtn.DoClick = function()
		CH_ATM.AdminMenu()
		
		CH_ATM.GUI_AdminMenuConvertData:Remove()
	end
	
	local GUI_SettingsBtn = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuConvertData )
	GUI_SettingsBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_SettingsBtn:SetPos( 0, scr_h * 0.09 )
	GUI_SettingsBtn:SetText( "" )
	GUI_SettingsBtn.Paint = function( self, w, h )
		surface.SetDrawColor( color_transparent )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "ATM Settings" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_SettingsBtn.DoClick = function()
		CH_ATM.AdminMenuSettings()
		
		CH_ATM.GUI_AdminMenuConvertData:Remove()
	end
	
	local GUI_ConvertDataBtn = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuConvertData )
	GUI_ConvertDataBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_ConvertDataBtn:SetPos( 0, scr_h * 0.14 )
	GUI_ConvertDataBtn:SetText( "" )
	GUI_ConvertDataBtn.Paint = function( self, w, h )
		surface.SetDrawColor( CH_ATM.Colors.GMSBlue )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Import Data" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_ConvertDataBtn.DoClick = function()
	end
	
	local GUI_OfflineBtn = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuConvertData )
	GUI_OfflineBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_OfflineBtn:SetPos( 0, scr_h * 0.19 )
	GUI_OfflineBtn:SetText( "" )
	GUI_OfflineBtn.Paint = function( self, w, h )
		surface.SetDrawColor( color_transparent )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Manage Offline" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_OfflineBtn.DoClick = function()
		CH_ATM.AdminMenuLookupOffline()
		
		CH_ATM.GUI_AdminMenuConvertData:Remove()
	end

	-- Setting buttons
	local GUI_ImportSlownAccounts = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuConvertData )
	GUI_ImportSlownAccounts:SetSize( scr_w * 0.391, scr_h * 0.075 )
	GUI_ImportSlownAccounts:SetPos( scr_w * 0.105, scr_h * 0.0465 )
	GUI_ImportSlownAccounts:SetText( "" )
	GUI_ImportSlownAccounts.Paint = function( self, w, h )
		if self:IsHovered() then
			surface.SetDrawColor( CH_ATM.Colors.GMSBlue )
		else
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
		end
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Import SlownLS Accounts" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_ImportSlownAccounts.DoClick = function()
		net.Start( "CH_ATM_Net_ConvertAccountsFromSlownLS" )
		net.SendToServer()
	end
	
	local GUI_ImportBlueATMAccounts = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuConvertData )
	GUI_ImportBlueATMAccounts:SetSize( scr_w * 0.391, scr_h * 0.075 )
	GUI_ImportBlueATMAccounts:SetPos( scr_w * 0.105, scr_h * 0.129 )
	GUI_ImportBlueATMAccounts:SetText( "" )
	GUI_ImportBlueATMAccounts.Paint = function( self, w, h )
		if self:IsHovered() then
			surface.SetDrawColor( CH_ATM.Colors.GMSBlue )
		else
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
		end
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Import Blues ATM Accounts" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_ImportBlueATMAccounts.DoClick = function()
		net.Start( "CH_ATM_Net_ConvertAccountsFromBlueATM" )
		net.SendToServer()
	end
	--[[
	local GUI_ImportBetterBankingAccounts = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuConvertData )
	GUI_ImportBetterBankingAccounts:SetSize( scr_w * 0.391, scr_h * 0.075 )
	GUI_ImportBetterBankingAccounts:SetPos( scr_w * 0.105, scr_h * 0.2115 )
	GUI_ImportBetterBankingAccounts:SetText( "" )
	GUI_ImportBetterBankingAccounts.Paint = function( self, w, h )
		if self:IsHovered() then
			surface.SetDrawColor( CH_ATM.Colors.GMSBlue )
		else
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
		end
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Import Better Banking Accounts" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_ImportBetterBankingAccounts.DoClick = function()
	end
	
	local GUI_ImportGlorifiedBankingAccounts = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuConvertData )
	GUI_ImportGlorifiedBankingAccounts:SetSize( scr_w * 0.391, scr_h * 0.075 )
	GUI_ImportGlorifiedBankingAccounts:SetPos( scr_w * 0.105, scr_h * 0.294 )
	GUI_ImportGlorifiedBankingAccounts:SetText( "" )
	GUI_ImportGlorifiedBankingAccounts.Paint = function( self, w, h )
		if self:IsHovered() then
			surface.SetDrawColor( CH_ATM.Colors.GMSBlue )
		else
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
		end
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Import Glorified Banking Accounts" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
	end
	GUI_ImportGlorifiedBankingAccounts.DoClick = function()
	end
	--]]
end






--[[
	ATM IMPORT DATA ADMIN MENU
--]]
function CH_ATM.AdminMenuLookupOffline()
	local ply = LocalPlayer()
	
	local scr_w = ScrW()
	local scr_h = ScrH()
	
	CH_ATM.GUI_AdminMenuLookupOffline = vgui.Create( "DFrame" )
	CH_ATM.GUI_AdminMenuLookupOffline:SetTitle( "" )
	CH_ATM.GUI_AdminMenuLookupOffline:SetSize( scr_w * 0.5, scr_h * 0.6 )
	CH_ATM.GUI_AdminMenuLookupOffline:Center()
	CH_ATM.GUI_AdminMenuLookupOffline.Paint = function( self, w, h )
		-- Draw frame
		surface.SetDrawColor( CH_ATM.Colors.LightGray )
		surface.DrawRect( 0, 0, w, h )
		
		-- Draw top
		surface.SetDrawColor( CH_ATM.Colors.DarkGray )
		surface.DrawRect( 0, 0, w, scr_h * 0.04 )
		
		-- Draw left navigation panel
		surface.SetDrawColor( CH_ATM.Colors.DarkGray )
		surface.DrawRect( 0, 0, scr_w * 0.1, h )
		
		-- Draw the top title.
		draw.SimpleText( CH_ATM.LangString( "Manage Offline" ), "CH_ATM_Font_ATMScreen_Size35", w / 2, scr_h * 0.02, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		-- Text Entry BG
		surface.SetDrawColor( CH_ATM.Colors.DarkGray )
		surface.DrawRect( w * 0.21, h * 0.078, w * 0.782, scr_h * 0.075 )
		
	end
	CH_ATM.GUI_AdminMenuLookupOffline:MakePopup()
	CH_ATM.GUI_AdminMenuLookupOffline:SetDraggable( false )
	CH_ATM.GUI_AdminMenuLookupOffline:ShowCloseButton( false )
	
	local GUI_CloseMenu = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuLookupOffline )
	GUI_CloseMenu:SetPos( scr_w * 0.4825, scr_h * 0.01 )
	GUI_CloseMenu:SetSize( 24, 24 )
	GUI_CloseMenu:SetText( "" )
	GUI_CloseMenu.Paint = function( self, w, h )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( CH_ATM.Materials.CloseIcon )
		surface.DrawTexturedRect( 0, 0, 24, 24 )
	end
	GUI_CloseMenu.DoClick = function()
		CH_ATM.GUI_AdminMenuLookupOffline:Remove()
	end

	local GUI_PlayerListBtn = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuLookupOffline )
	GUI_PlayerListBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_PlayerListBtn:SetPos( 0, scr_h * 0.04 )
	GUI_PlayerListBtn:SetText( "" )
	GUI_PlayerListBtn.Paint = function( self, w, h )
		surface.SetDrawColor( color_transparent )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Players" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_PlayerListBtn.DoClick = function()
		CH_ATM.AdminMenu()
		
		CH_ATM.GUI_AdminMenuLookupOffline:Remove()
	end
	
	local GUI_SettingsBtn = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuLookupOffline )
	GUI_SettingsBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_SettingsBtn:SetPos( 0, scr_h * 0.09 )
	GUI_SettingsBtn:SetText( "" )
	GUI_SettingsBtn.Paint = function( self, w, h )
		surface.SetDrawColor( color_transparent )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "ATM Settings" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_SettingsBtn.DoClick = function()
		CH_ATM.AdminMenuSettings()
		
		CH_ATM.GUI_AdminMenuLookupOffline:Remove()
	end
	
	local GUI_ConvertDataBtn = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuLookupOffline )
	GUI_ConvertDataBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_ConvertDataBtn:SetPos( 0, scr_h * 0.14 )
	GUI_ConvertDataBtn:SetText( "" )
	GUI_ConvertDataBtn.Paint = function( self, w, h )
		surface.SetDrawColor( color_transparent )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Import Data" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_ConvertDataBtn.DoClick = function()
		CH_ATM.AdminMenuConvertData()
		
		CH_ATM.GUI_AdminMenuLookupOffline:Remove()
	end
	
	local GUI_OfflineBtn = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuLookupOffline )
	GUI_OfflineBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_OfflineBtn:SetPos( 0, scr_h * 0.19 )
	GUI_OfflineBtn:SetText( "" )
	GUI_OfflineBtn.Paint = function( self, w, h )
		surface.SetDrawColor( CH_ATM.Colors.GMSBlue )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Manage Offline" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_OfflineBtn.DoClick = function()
	end

	local GUI_SteamIDEntry = vgui.Create( "DTextEntry", CH_ATM.GUI_AdminMenuLookupOffline )
	GUI_SteamIDEntry:SetPos( scr_w * 0.105, scr_h * 0.0475 )
	GUI_SteamIDEntry:SetSize( scr_w * 0.39, scr_h * 0.074 )
	GUI_SteamIDEntry:SetFont( "CH_ATM_Font_ATMScreen_Size50" )
	GUI_SteamIDEntry:SetTextColor( color_white )
	GUI_SteamIDEntry:SetPlaceholderText( "Enter SteamID64" )
	GUI_SteamIDEntry:SetAllowNonAsciiCharacters( false ) -- When allowing non-ASCII characters, a small box appears inside the text entry, indicating your keyboard's current language.  That makes the user unable to input some letters from German, French, Swedish, etc. alphabet. 
	GUI_SteamIDEntry:SetMultiline( false )
	GUI_SteamIDEntry:SetNumeric( true )
	GUI_SteamIDEntry:SetDrawBackground( false )
	
	local GUI_LookupOfflinePlayer = vgui.Create( "DButton", CH_ATM.GUI_AdminMenuLookupOffline )
	GUI_LookupOfflinePlayer:SetSize( scr_w * 0.391, scr_h * 0.075 )
	GUI_LookupOfflinePlayer:SetPos( scr_w * 0.105, scr_h * 0.129 )
	GUI_LookupOfflinePlayer:SetText( "" )
	GUI_LookupOfflinePlayer.Paint = function( self, w, h )
		if self:IsHovered() then
			surface.SetDrawColor( CH_ATM.Colors.GMSBlue )
		else
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
		end
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Lookup Player" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_LookupOfflinePlayer.DoClick = function()
		net.Start( "CH_ATM_Net_AdminCheckOfflineAccount" )
			net.WriteString( GUI_SteamIDEntry:GetValue() )
		net.SendToServer()
		
		CH_ATM.GUI_AdminMenuLookupOffline:Remove()
	end
end






--[[
	View Offline Player
--]]
net.Receive( "CH_ATM_Net_AdminShowOfflineAccount", function( len, ply )
	local ply = LocalPlayer()
	
	if not ply:CH_ATM_IsAdmin() then
		return
	end
	
	local target_steamid = net.ReadString()
	local target_bank_account = net.ReadUInt( 32 )
	local target_bank_level = net.ReadUInt( 8 )
	
	local scr_w = ScrW()
	local scr_h = ScrH()
	
	local GUI_ViewOfflinePlayerMenu = vgui.Create( "DFrame" )
	GUI_ViewOfflinePlayerMenu:SetTitle( "" )
	GUI_ViewOfflinePlayerMenu:SetSize( scr_w * 0.5, scr_h * 0.6 )
	GUI_ViewOfflinePlayerMenu:Center()
	GUI_ViewOfflinePlayerMenu.Paint = function( self, w, h )
		-- Draw frame
		surface.SetDrawColor( CH_ATM.Colors.LightGray )
		surface.DrawRect( 0, 0, w, h )
		
		-- Draw top
		surface.SetDrawColor( CH_ATM.Colors.DarkGray )
		surface.DrawRect( 0, 0, w, scr_h * 0.04 )
		
		-- Draw left navigation panel
		surface.SetDrawColor( CH_ATM.Colors.DarkGray )
		surface.DrawRect( 0, 0, scr_w * 0.1, h )
		
		-- Draw the top title.
		draw.SimpleText( CH_ATM.LangString( "View Player" ), "CH_ATM_Font_ATMScreen_Size35", w / 2, scr_h * 0.02, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_ViewOfflinePlayerMenu:MakePopup()
	GUI_ViewOfflinePlayerMenu:SetDraggable( false )
	GUI_ViewOfflinePlayerMenu:ShowCloseButton( false )

	local GUI_CloseMenu = vgui.Create( "DButton", GUI_ViewOfflinePlayerMenu )
	GUI_CloseMenu:SetPos( scr_w * 0.4825, scr_h * 0.01 )
	GUI_CloseMenu:SetSize( 24, 24 )
	GUI_CloseMenu:SetText( "" )
	GUI_CloseMenu.Paint = function( self, w, h )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( CH_ATM.Materials.CloseIcon )
		surface.DrawTexturedRect( 0, 0, 24, 24 )
	end
	GUI_CloseMenu.DoClick = function()
		GUI_ViewOfflinePlayerMenu:Remove()
	end

	local GUI_PlayerListBtn = vgui.Create( "DButton", GUI_ViewOfflinePlayerMenu )
	GUI_PlayerListBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_PlayerListBtn:SetPos( 0, scr_h * 0.04 )
	GUI_PlayerListBtn:SetText( "" )
	GUI_PlayerListBtn.Paint = function( self, w, h )
		surface.SetDrawColor( color_transparent )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Players" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_PlayerListBtn.DoClick = function()
		CH_ATM.AdminMenu()
		
		GUI_ViewOfflinePlayerMenu:Remove()
	end
	
	local GUI_SettingsBtn = vgui.Create( "DButton", GUI_ViewOfflinePlayerMenu )
	GUI_SettingsBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_SettingsBtn:SetPos( 0, scr_h * 0.09 )
	GUI_SettingsBtn:SetText( "" )
	GUI_SettingsBtn.Paint = function( self, w, h )
		surface.SetDrawColor( color_transparent )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "ATM Settings" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_SettingsBtn.DoClick = function()
		CH_ATM.AdminMenuSettings()
		
		GUI_ViewOfflinePlayerMenu:Remove()
	end
	
	local GUI_ConvertDataBtn = vgui.Create( "DButton", GUI_ViewOfflinePlayerMenu )
	GUI_ConvertDataBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_ConvertDataBtn:SetPos( 0, scr_h * 0.14 )
	GUI_ConvertDataBtn:SetText( "" )
	GUI_ConvertDataBtn.Paint = function( self, w, h )
		surface.SetDrawColor( color_transparent )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Import Data" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_ConvertDataBtn.DoClick = function()
		CH_ATM.AdminMenuConvertData()
		
		GUI_ViewOfflinePlayerMenu:Remove()
	end
	
	local GUI_OfflineBtn = vgui.Create( "DButton", GUI_ViewOfflinePlayerMenu )
	GUI_OfflineBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_OfflineBtn:SetPos( 0, scr_h * 0.19 )
	GUI_OfflineBtn:SetText( "" )
	GUI_OfflineBtn.Paint = function( self, w, h )
		surface.SetDrawColor( CH_ATM.Colors.GMSBlue )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Manage Offline" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_OfflineBtn.DoClick = function()
		CH_ATM.AdminMenuLookupOffline()
		
		GUI_ViewOfflinePlayerMenu:Remove()
	end
	
	-- VIEW PLAYER SECTION
	local GUI_ViewPlayerPanel = vgui.Create( "DPanel", GUI_ViewOfflinePlayerMenu )
	GUI_ViewPlayerPanel:SetSize( scr_w * 0.391, scr_w * 0.3075 )
	GUI_ViewPlayerPanel:SetPos( scr_w * 0.105, scr_h * 0.0465 )
	GUI_ViewPlayerPanel.Paint = function( self, w, h )
		surface.SetDrawColor( CH_ATM.Colors.DarkGray )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Viewing profile of" ).. " ".. target_steamid, "CH_ATM_Font_ATMScreen_Size30", w / 2, h * 0.05, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		draw.SimpleText( CH_ATM.LangString( "Total Balance" ).. ": ".. CH_ATM.FormatMoney( target_bank_account ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h * 0.11, CH_ATM.Colors.Green, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		draw.SimpleText( CH_ATM.LangString( "Account Level" ) ..": ".. target_bank_level, "CH_ATM_Font_ATMScreen_Size25", w / 2, h * 0.16, CH_ATM.Colors.Red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		--Text Entry BG
		surface.SetDrawColor( CH_ATM.Colors.LightGray )
		surface.DrawRect( w * 0.015, h * 0.2, w * 0.97, h * 0.1 )
		
		surface.SetDrawColor( CH_ATM.Colors.LightGray )
		surface.DrawRect( w * 0.015, h * 0.32, w * 0.97, h * 0.1 )
	end
	
	local GUI_PlayerMoneyField = vgui.Create( "DTextEntry", GUI_ViewPlayerPanel )
	GUI_PlayerMoneyField:SetPos( scr_w * 0.006, scr_h * 0.11 )
	GUI_PlayerMoneyField:SetSize( scr_w * 0.379, scr_h * 0.055 )
	GUI_PlayerMoneyField:SetFont( "CH_ATM_Font_ATMScreen_Size50" )
	GUI_PlayerMoneyField:SetTextColor( color_white )
	GUI_PlayerMoneyField:SetValue( target_bank_account )
	GUI_PlayerMoneyField:SetAllowNonAsciiCharacters( false ) -- When allowing non-ASCII characters, a small box appears inside the text entry, indicating your keyboard's current language.  That makes the user unable to input some letters from German, French, Swedish, etc. alphabet. 
	GUI_PlayerMoneyField:SetMultiline( false )
	GUI_PlayerMoneyField:SetNumeric( true )
	GUI_PlayerMoneyField:SetDrawBackground( false )
	
	local GUI_PlayerLevelField = vgui.Create( "DTextEntry", GUI_ViewPlayerPanel )
	GUI_PlayerLevelField:SetPos( scr_w * 0.006, scr_h * 0.175 )
	GUI_PlayerLevelField:SetSize( scr_w * 0.379, scr_h * 0.055 )
	GUI_PlayerLevelField:SetFont( "CH_ATM_Font_ATMScreen_Size50" )
	GUI_PlayerLevelField:SetTextColor( color_white )
	GUI_PlayerLevelField:SetValue( target_bank_level )
	GUI_PlayerLevelField:SetAllowNonAsciiCharacters( false ) -- When allowing non-ASCII characters, a small box appears inside the text entry, indicating your keyboard's current language.  That makes the user unable to input some letters from German, French, Swedish, etc. alphabet. 
	GUI_PlayerLevelField:SetMultiline( false )
	GUI_PlayerLevelField:SetNumeric( true )
	GUI_PlayerLevelField:SetDrawBackground( false )
	
	local GUI_UpdateOfflinePlayer = vgui.Create( "DButton", GUI_ViewPlayerPanel )
	GUI_UpdateOfflinePlayer:SetPos( scr_w * 0.006, scr_h * 0.24 )
	GUI_UpdateOfflinePlayer:SetSize( scr_w * 0.379, scr_h * 0.055 )
	GUI_UpdateOfflinePlayer:SetText( "" )
	GUI_UpdateOfflinePlayer.Paint = function( self, w, h )
		if self:IsHovered() then
			surface.SetDrawColor( CH_ATM.Colors.GMSBlue )
		else
			surface.SetDrawColor( CH_ATM.Colors.LightGray )
		end
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Update Player Profile" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_UpdateOfflinePlayer.DoClick = function()
		net.Start( "CH_ATM_Net_AdminUpdateOfflineAccount" )
			net.WriteString( target_steamid )
			net.WriteUInt( GUI_PlayerMoneyField:GetValue(), 32 )
			net.WriteUInt( GUI_PlayerLevelField:GetValue(), 8 )
		net.SendToServer()
		
		GUI_ViewOfflinePlayerMenu:Remove()
	end
end )






--[[
	View Player
--]]
net.Receive( "CH_ATM_Net_AdminViewPlayerMenu", function( len, ply )
	local ply = LocalPlayer()
	
	if not ply:CH_ATM_IsAdmin() then
		return
	end
	
	local target_ply = net.ReadEntity()
	local target_bank_account = net.ReadUInt( 32 )
	local target_bank_level = net.ReadUInt( 8 )
	
	local scr_w = ScrW()
	local scr_h = ScrH()
	
	local GUI_ViewPlayerMenu = vgui.Create( "DFrame" )
	GUI_ViewPlayerMenu:SetTitle( "" )
	GUI_ViewPlayerMenu:SetSize( scr_w * 0.5, scr_h * 0.6 )
	GUI_ViewPlayerMenu:Center()
	GUI_ViewPlayerMenu.Paint = function( self, w, h )
		-- Draw frame
		surface.SetDrawColor( CH_ATM.Colors.LightGray )
		surface.DrawRect( 0, 0, w, h )
		
		-- Draw top
		surface.SetDrawColor( CH_ATM.Colors.DarkGray )
		surface.DrawRect( 0, 0, w, scr_h * 0.04 )
		
		-- Draw left navigation panel
		surface.SetDrawColor( CH_ATM.Colors.DarkGray )
		surface.DrawRect( 0, 0, scr_w * 0.1, h )
		
		-- Draw the top title.
		draw.SimpleText( CH_ATM.LangString( "View Player" ), "CH_ATM_Font_ATMScreen_Size35", w / 2, scr_h * 0.02, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_ViewPlayerMenu:MakePopup()
	GUI_ViewPlayerMenu:SetDraggable( false )
	GUI_ViewPlayerMenu:ShowCloseButton( false )

	local GUI_CloseMenu = vgui.Create( "DButton", GUI_ViewPlayerMenu )
	GUI_CloseMenu:SetPos( scr_w * 0.4825, scr_h * 0.01 )
	GUI_CloseMenu:SetSize( 24, 24 )
	GUI_CloseMenu:SetText( "" )
	GUI_CloseMenu.Paint = function( self, w, h )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( CH_ATM.Materials.CloseIcon )
		surface.DrawTexturedRect( 0, 0, 24, 24 )
	end
	GUI_CloseMenu.DoClick = function()
		GUI_ViewPlayerMenu:Remove()
	end

	local GUI_PlayerListBtn = vgui.Create( "DButton", GUI_ViewPlayerMenu )
	GUI_PlayerListBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_PlayerListBtn:SetPos( 0, scr_h * 0.04 )
	GUI_PlayerListBtn:SetText( "" )
	GUI_PlayerListBtn.Paint = function( self, w, h )
		surface.SetDrawColor( CH_ATM.Colors.GMSBlue )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Players" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_PlayerListBtn.DoClick = function()
		CH_ATM.AdminMenu()
		
		GUI_ViewPlayerMenu:Remove()
	end
	
	local GUI_SettingsBtn = vgui.Create( "DButton", GUI_ViewPlayerMenu )
	GUI_SettingsBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_SettingsBtn:SetPos( 0, scr_h * 0.09 )
	GUI_SettingsBtn:SetText( "" )
	GUI_SettingsBtn.Paint = function( self, w, h )
		surface.SetDrawColor( color_transparent )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "ATM Settings" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_SettingsBtn.DoClick = function()
		CH_ATM.AdminMenuSettings()
		
		GUI_ViewPlayerMenu:Remove()
	end
	
	local GUI_ConvertDataBtn = vgui.Create( "DButton", GUI_ViewPlayerMenu )
	GUI_ConvertDataBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_ConvertDataBtn:SetPos( 0, scr_h * 0.14 )
	GUI_ConvertDataBtn:SetText( "" )
	GUI_ConvertDataBtn.Paint = function( self, w, h )
		surface.SetDrawColor( color_transparent )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Import Data" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_ConvertDataBtn.DoClick = function()
		CH_ATM.AdminMenuConvertData()
		
		GUI_ViewPlayerMenu:Remove()
	end
	
	local GUI_OfflineBtn = vgui.Create( "DButton", GUI_ViewPlayerMenu )
	GUI_OfflineBtn:SetSize( scr_w * 0.1, scr_h * 0.05 )
	GUI_OfflineBtn:SetPos( 0, scr_h * 0.19 )
	GUI_OfflineBtn:SetText( "" )
	GUI_OfflineBtn.Paint = function( self, w, h )
		surface.SetDrawColor( color_transparent )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Manage Offline" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_OfflineBtn.DoClick = function()
		CH_ATM.AdminMenuLookupOffline()
		
		GUI_ViewPlayerMenu:Remove()
	end
	
	-- VIEW PLAYER SECTION
	local GUI_ViewPlayerPanel = vgui.Create( "DPanel", GUI_ViewPlayerMenu )
	GUI_ViewPlayerPanel:SetSize( scr_w * 0.391, scr_w * 0.3075 )
	GUI_ViewPlayerPanel:SetPos( scr_w * 0.105, scr_h * 0.0465 )
	GUI_ViewPlayerPanel.Paint = function( self, w, h )
		surface.SetDrawColor( CH_ATM.Colors.DarkGray )
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Viewing profile of" ).. " ".. target_ply:Nick(), "CH_ATM_Font_ATMScreen_Size30", w / 2, h * 0.21, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		draw.SimpleText( CH_ATM.LangString( "Total Balance" ).. ": ".. CH_ATM.FormatMoney( target_bank_account ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h * 0.265, CH_ATM.Colors.Green, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		draw.SimpleText( CH_ATM.LangString( "Account Level" ) ..": ".. target_bank_level, "CH_ATM_Font_ATMScreen_Size25", w / 2, h * 0.31, CH_ATM.Colors.Red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		--Text Entry BG
		surface.SetDrawColor( CH_ATM.Colors.LightGray )
		surface.DrawRect( w * 0.26, h * 0.35, w * 0.5, scr_h * 0.035 )
	end
	
	local GUI_PlayerAvatar = vgui.Create( "AvatarImage", GUI_ViewPlayerPanel )
	GUI_PlayerAvatar:SetSize( 100, 100 )
	GUI_PlayerAvatar:SetPos( GUI_ViewPlayerPanel:GetWide() / 2 - 50, scr_h * 0.0075 )
	GUI_PlayerAvatar:SetPlayer( ply, 128 )
	
	local GUI_TextField = vgui.Create( "DTextEntry", GUI_ViewPlayerPanel )
	GUI_TextField:SetPos( scr_w * 0.1025, scr_h * 0.1925 )
	GUI_TextField:SetSize( scr_w * 0.197, scr_h * 0.035 )
	GUI_TextField:SetFont( "CH_ATM_Font_ATMScreen_Size30" )
	GUI_TextField:SetTextColor( color_white )
	GUI_TextField:SetPlaceholderText( "0" )
	GUI_TextField:SetAllowNonAsciiCharacters( false ) -- When allowing non-ASCII characters, a small box appears inside the text entry, indicating your keyboard's current language.  That makes the user unable to input some letters from German, French, Swedish, etc. alphabet. 
	GUI_TextField:SetMultiline( false )
	GUI_TextField:SetNumeric( true )
	GUI_TextField:SetDrawBackground( false )
	
	
	-- Give Money
	local GUI_GiveMoneyBtn = vgui.Create( "DButton", GUI_ViewPlayerPanel )
	GUI_GiveMoneyBtn:SetSize( scr_w * 0.123, scr_h * 0.045 )
	GUI_GiveMoneyBtn:SetPos( scr_w * 0.0055, scr_h * 0.235 )
	GUI_GiveMoneyBtn:SetText( "" )
	GUI_GiveMoneyBtn.Paint = function( self, w, h )
		if self:IsHovered() then
			surface.SetDrawColor( CH_ATM.Colors.GMSBlue )
		else
			surface.SetDrawColor( CH_ATM.Colors.LightGray )
		end
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Give Money" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_GiveMoneyBtn.DoClick = function()
		if not tonumber( GUI_TextField:GetValue() ) or tonumber( GUI_TextField:GetValue() ) <= 0 then
			return
		end
		
		net.Start( "CH_ATM_Net_AdminGiveMoney" )
			net.WriteEntity( target_ply )
			net.WriteUInt( GUI_TextField:GetValue(), 32 )
		net.SendToServer()
		
		GUI_ViewPlayerMenu:Remove()
	end
	
	-- Take Money
	local GUI_TakeMoneyBtn = vgui.Create( "DButton", GUI_ViewPlayerPanel )
	GUI_TakeMoneyBtn:SetSize( scr_w * 0.123, scr_h * 0.045 )
	GUI_TakeMoneyBtn:SetPos( scr_w * 0.134, scr_h * 0.235 )
	GUI_TakeMoneyBtn:SetText( "" )
	GUI_TakeMoneyBtn.Paint = function( self, w, h )
		if self:IsHovered() then
			surface.SetDrawColor( CH_ATM.Colors.GMSBlue )
		else
			surface.SetDrawColor( CH_ATM.Colors.LightGray )
		end
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Take Money" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_TakeMoneyBtn.DoClick = function()
		if not tonumber( GUI_TextField:GetValue() ) or tonumber( GUI_TextField:GetValue() ) <= 0 then
			return
		end
		
		net.Start( "CH_ATM_Net_AdminTakeMoney" )
			net.WriteEntity( target_ply )
			net.WriteUInt( GUI_TextField:GetValue(), 32 )
		net.SendToServer()
		
		GUI_ViewPlayerMenu:Remove()
	end
	
	-- Reset Level
	local GUI_ResetLevelBtn = vgui.Create( "DButton", GUI_ViewPlayerPanel )
	GUI_ResetLevelBtn:SetSize( scr_w * 0.123, scr_h * 0.045 )
	GUI_ResetLevelBtn:SetPos( scr_w * 0.2625, scr_h * 0.235 )
	GUI_ResetLevelBtn:SetText( "" )
	GUI_ResetLevelBtn.Paint = function( self, w, h )
		if self:IsHovered() then
			surface.SetDrawColor( CH_ATM.Colors.GMSBlue )
		else
			surface.SetDrawColor( CH_ATM.Colors.LightGray )
		end
		surface.DrawRect( 0, 0, w, h )
		
		draw.SimpleText( CH_ATM.LangString( "Reset Level" ), "CH_ATM_Font_ATMScreen_Size25", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_ResetLevelBtn.DoClick = function()
		net.Start( "CH_ATM_Net_AdminResetAccountLevel" )
			net.WriteEntity( target_ply )
		net.SendToServer()
		
		GUI_ViewPlayerMenu:Remove()
	end
end )