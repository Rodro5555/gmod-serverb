--[[
	CRYPTO MENU
--]]

net.Receive( "CH_BITMINERS_CryptoOptions", function( length, ply )
	if not CH_Bitminers.Config.IntegrateCryptoCurrencies then
		return
	end
	
	local ply = LocalPlayer()
	local bitminer = net.ReadEntity()
	
	local GUI_CryptoOptionFrame = vgui.Create( "DFrame" )
	GUI_CryptoOptionFrame:SetTitle( "" )
	GUI_CryptoOptionFrame:SetSize( ScrW() * 0.3565, ScrH() * 0.488 )
	GUI_CryptoOptionFrame:Center()
	GUI_CryptoOptionFrame.Paint = function( self, w, h )
		-- Draw frame
		surface.SetDrawColor( CH_CryptoCurrencies.Colors.GrayFront )
		surface.DrawRect( 0, 0, w, h )
		
		-- Draw top
		surface.SetDrawColor( CH_CryptoCurrencies.Colors.GrayBG )
		surface.DrawRect( 0, 0, w, h * 0.085 )
		
		-- Draw the top title.
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Select Crypto" ), "CH_CryptoCurrency_Font_Size10", w / 2, h * 0.045, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_CryptoOptionFrame:MakePopup()
	GUI_CryptoOptionFrame:SetDraggable( false )
	GUI_CryptoOptionFrame:ShowCloseButton( false )
	
	local GUI_CloseMenu = vgui.Create( "DButton", GUI_CryptoOptionFrame )
	GUI_CloseMenu:SetPos( ScrW() * 0.339, ScrH() * 0.01 )
	GUI_CloseMenu:SetSize( 24, 24 )
	GUI_CloseMenu:SetText( "" )
	GUI_CloseMenu.Paint = function( self, w, h )
		surface.SetDrawColor( color_white )
		if self:IsHovered() then
			surface.SetDrawColor( CH_CryptoCurrencies.Colors.Red )
		else
			surface.SetDrawColor( color_white )
		end
		surface.SetMaterial( CH_CryptoCurrencies.Materials.CloseIcon )
		surface.DrawTexturedRect( 0, 0, 24, 24 )
	end
	GUI_CloseMenu.DoClick = function()
		GUI_CryptoOptionFrame:Remove()
	end
	
	local GUI_CryptoList = vgui.Create( "DPanelList", GUI_CryptoOptionFrame )
	GUI_CryptoList:SetSize( ScrW() * 0.35, ScrW() * 0.244 )
	GUI_CryptoList:SetPos( ScrW() * 0.0045, ScrH() * 0.049 )
	GUI_CryptoList:EnableVerticalScrollbar( true )
	GUI_CryptoList:EnableHorizontal( true )
	GUI_CryptoList:SetSpacing( 7 )
	GUI_CryptoList.Paint = function( self, w, h )
		--draw.RoundedBox( 0, 0, 0, w, h, CH_CryptoCurrencies.Colors.Invisible )
	end
	if ( GUI_CryptoList.VBar ) then
		GUI_CryptoList.VBar.Paint = function( self, w, h ) -- BG
			surface.SetDrawColor( CH_CryptoCurrencies.Colors.GrayBG )
			surface.DrawRect( 0, 0, 7, h )
		end
		
		GUI_CryptoList.VBar.btnUp.Paint = function( self, w, h )
			surface.SetDrawColor( CH_CryptoCurrencies.Colors.GrayBG )
			surface.DrawRect( 0, 0, 7, h )
		end
		
		GUI_CryptoList.VBar.btnGrip.Paint = function( self, w, h )
			surface.SetDrawColor( CH_CryptoCurrencies.Colors.GMSBlue )
			surface.DrawRect( 0, 0, 7, h )
		end
		
		GUI_CryptoList.VBar.btnDown.Paint = function( self, w, h )
			surface.SetDrawColor( CH_CryptoCurrencies.Colors.GrayBG )
			surface.DrawRect( 0, 0, 7, h )
		end
	end
	
	for index, crypto in ipairs( CH_CryptoCurrencies.CryptosCL ) do
		if crypto.Name then
			-- Cache some variables that doesn't have to be in the Paint hook
			local player_owns = math.Round( ply.CH_CryptoCurrencies_Wallet[ crypto.Currency ].Amount, 7 )
			
			local price_change = crypto.Change
			local price_change_color = CH_CryptoCurrencies.Colors.Green
			if price_change < 0 then
				price_change_color = CH_CryptoCurrencies.Colors.Red
			end
			local no_change = false
			
			-- Panel per crypto
			local GUI_CryptoPanel = vgui.Create( "DPanelList" )
			GUI_CryptoPanel:SetSize( ScrW() * 0.065, ScrH() * 0.14 )
			GUI_CryptoPanel.Paint = function( self, w, h )
				-- Draw frame
				surface.SetDrawColor( CH_CryptoCurrencies.Colors.GrayBG )
				surface.DrawRect( 0, 0, w, h )
				
				-- Coin Icon
				surface.SetDrawColor( color_white )
				surface.SetMaterial( crypto.Icon )
				surface.DrawTexturedRect( w * 0.12, h * 0.08, 96, 96 )
				
				-- Coin Name
				draw.SimpleText( crypto.Currency, "CH_CryptoCurrency_Font_Size10", w / 2, h * 0.85, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			
			local GUI_SelectCryptoBtn = vgui.Create( "DButton", GUI_CryptoPanel )
			GUI_SelectCryptoBtn:SetSize( GUI_CryptoPanel:GetWide(), GUI_CryptoPanel:GetTall() )
			GUI_SelectCryptoBtn:SetPos( 0, 0 )
			GUI_SelectCryptoBtn:SetText( "" )
			GUI_SelectCryptoBtn.Paint = function( self, w, h )
				--draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.DarkGray )
			end
			GUI_SelectCryptoBtn.DoClick = function()
				net.Start( "CH_BITMINERS_CryptoIntegration_SelectCrypto" )
					net.WriteEntity( bitminer )
					net.WriteUInt( index, 6 )
				net.SendToServer()
				
				GUI_CryptoOptionFrame:Remove()
			end
			
			GUI_CryptoList:AddItem( GUI_CryptoPanel )
		end
	end
end )