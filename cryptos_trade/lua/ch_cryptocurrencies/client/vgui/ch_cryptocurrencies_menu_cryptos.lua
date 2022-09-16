--[[
	CRYPTO MENU
--]]
function CH_CryptoCurrencies.CryptoMenu()
	local ply = LocalPlayer()

	local scr_w = ScrW()
	local scr_h = ScrH()

	local GUI_CryptoFrame = vgui.Create( "DFrame" )
	GUI_CryptoFrame:SetTitle( "" )
	GUI_CryptoFrame:SetSize( scr_w * 0.6, scr_h * 0.6875 )
	GUI_CryptoFrame:Center()
	GUI_CryptoFrame.Paint = function( self, w, h )
		-- Draw frame
		surface.SetDrawColor( CH_CryptoCurrencies.Colors.GrayFront )
		surface.DrawRect( 0, 0, w, h )
		
		-- Draw top
		surface.SetDrawColor( CH_CryptoCurrencies.Colors.GrayBG )
		surface.DrawRect( 0, 0, w, h * 0.059 )
		
		-- Draw the top title.
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Browse Cryptocurrencies" ), "CH_CryptoCurrency_Font_Size10", w / 2, h * 0.03, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		-- Draw title of crypto list
		surface.SetDrawColor( CH_CryptoCurrencies.Colors.GrayBG )
		surface.DrawRect( scr_w * 0.109, scr_h * 0.0475, scr_w * 0.4875, scr_h * 0.04 )
		
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Name" ), "CH_CryptoCurrency_Font_Size10", w * 0.245, h * 0.095, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Balance" ), "CH_CryptoCurrency_Font_Size10", w * 0.421, h * 0.095, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Price" ), "CH_CryptoCurrency_Font_Size10", w * 0.56, h * 0.095, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Performance" ), "CH_CryptoCurrency_Font_Size10", w * 0.702, h * 0.095, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
	GUI_CryptoFrame:MakePopup()
	GUI_CryptoFrame:SetDraggable( false )
	GUI_CryptoFrame:ShowCloseButton( false )

	local GUI_CloseMenu = vgui.Create( "DButton", GUI_CryptoFrame )
	GUI_CloseMenu:SetPos( scr_w * 0.582, scr_h * 0.01 )
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
		GUI_CryptoFrame:Remove()
	end
	
	local GUI_DashboardFrameBtn = vgui.Create( "DButton", GUI_CryptoFrame )
	GUI_DashboardFrameBtn:SetSize( scr_w * 0.1, scr_h * 0.04 )
	GUI_DashboardFrameBtn:SetPos( scr_w * 0.005, scr_h * 0.0475 )
	GUI_DashboardFrameBtn:SetTextColor( Color( 0, 0, 0, 255 ) )
	GUI_DashboardFrameBtn:SetText( "" )
	GUI_DashboardFrameBtn.Paint = function( self, w, h )
		if self:IsHovered() then
			surface.SetDrawColor( CH_CryptoCurrencies.Colors.GMSBlue )
		else
			surface.SetDrawColor( CH_CryptoCurrencies.Colors.GrayBG )
		end
		surface.DrawRect( 0, 0, w, h )

		surface.SetDrawColor( CH_CryptoCurrencies.Colors.GMSBlue )
		surface.DrawRect( 0, 0, 2, h )
		
		surface.SetDrawColor( color_white )
		surface.SetMaterial( CH_CryptoCurrencies.Materials.MenuDashboard )
		surface.DrawTexturedRect( w * 0.075, h * 0.25, 24, 24 )
		
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Dashboard" ), "CH_CryptoCurrency_Font_Size9", w * 0.25, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
	GUI_DashboardFrameBtn.DoClick = function()
		GUI_CryptoFrame:Remove()
		
		CH_CryptoCurrencies.DashboardMenu()
	end

	local GUI_BuyCryptoFrameBtn = vgui.Create( "DButton", GUI_CryptoFrame )
	GUI_BuyCryptoFrameBtn:SetSize( scr_w * 0.1, scr_h * 0.04 )
	GUI_BuyCryptoFrameBtn:SetPos( scr_w * 0.005, scr_h * 0.095 )
	GUI_BuyCryptoFrameBtn:SetTextColor( Color( 0, 0, 0, 255 ) )
	GUI_BuyCryptoFrameBtn:SetText( "" )
	GUI_BuyCryptoFrameBtn.Paint = function( self, w, h )
		if self:IsHovered() then
			surface.SetDrawColor( CH_CryptoCurrencies.Colors.GMSBlue )
		else
			surface.SetDrawColor( CH_CryptoCurrencies.Colors.GrayBG )
		end
		surface.DrawRect( 0, 0, w, h )

		surface.SetDrawColor( CH_CryptoCurrencies.Colors.GMSBlue )
		surface.DrawRect( 0, 0, 2, h )
		
		surface.SetDrawColor( color_white )
		surface.SetMaterial( CH_CryptoCurrencies.Materials.MenuCryptos )
		surface.DrawTexturedRect( w * 0.075, h * 0.25, 24, 24 )
		
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Cryptos" ), "CH_CryptoCurrency_Font_Size9", w * 0.25, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
	GUI_BuyCryptoFrameBtn.DoClick = function()
		GUI_CryptoFrame:Remove()
		
		CH_CryptoCurrencies.CryptoMenu()
	end
	
	local GUI_PortfolioFrameBtn = vgui.Create( "DButton", GUI_CryptoFrame )
	GUI_PortfolioFrameBtn:SetSize( scr_w * 0.1, scr_h * 0.04 )
	GUI_PortfolioFrameBtn:SetPos( scr_w * 0.005, scr_h * 0.1425 )
	GUI_PortfolioFrameBtn:SetTextColor( Color( 0, 0, 0, 255 ) )
	GUI_PortfolioFrameBtn:SetText( "" )
	GUI_PortfolioFrameBtn.Paint = function( self, w, h )
		if self:IsHovered() then
			surface.SetDrawColor( CH_CryptoCurrencies.Colors.GMSBlue )
		else
			surface.SetDrawColor( CH_CryptoCurrencies.Colors.GrayBG )
		end
		surface.DrawRect( 0, 0, w, h )

		surface.SetDrawColor( CH_CryptoCurrencies.Colors.GMSBlue )
		surface.DrawRect( 0, 0, 2, h )
	
		surface.SetDrawColor( color_white )
		surface.SetMaterial( CH_CryptoCurrencies.Materials.MenuPortfolio )
		surface.DrawTexturedRect( w * 0.075, h * 0.25, 24, 24 )
		
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Portfolio" ), "CH_CryptoCurrency_Font_Size9", w * 0.25, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
	GUI_PortfolioFrameBtn.DoClick = function()
		GUI_CryptoFrame:Remove()
		
		CH_CryptoCurrencies.PortfolioMenu()
	end
	
	if CH_CryptoCurrencies.Config.EnableSQL then
		local GUI_PortfolioFrameBtn = vgui.Create( "DButton", GUI_CryptoFrame )
		GUI_PortfolioFrameBtn:SetSize( scr_w * 0.1, scr_h * 0.04 )
		GUI_PortfolioFrameBtn:SetPos( scr_w * 0.005, scr_h * 0.19 )
		GUI_PortfolioFrameBtn:SetTextColor( Color( 0, 0, 0, 255 ) )
		GUI_PortfolioFrameBtn:SetText( "" )
		GUI_PortfolioFrameBtn.Paint = function( self, w, h )
			if self:IsHovered() then
				surface.SetDrawColor( CH_CryptoCurrencies.Colors.GMSBlue )
			else
				surface.SetDrawColor( CH_CryptoCurrencies.Colors.GrayBG )
			end
			surface.DrawRect( 0, 0, w, h )

			surface.SetDrawColor( CH_CryptoCurrencies.Colors.GMSBlue )
			surface.DrawRect( 0, 0, 2, h )
			
			surface.SetDrawColor( color_white )
		surface.SetMaterial( CH_CryptoCurrencies.Materials.MenuTransactions )
		surface.DrawTexturedRect( w * 0.075, h * 0.25, 24, 24 )
		
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Transactions" ), "CH_CryptoCurrency_Font_Size9", w * 0.25, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
		GUI_PortfolioFrameBtn.DoClick = function()
			GUI_CryptoFrame:Remove()
			
			CH_CryptoCurrencies.TransactionsMenu()
		end
	end

	local GUI_CryptoList = vgui.Create( "DPanelList", GUI_CryptoFrame )
	GUI_CryptoList:SetSize( scr_w * 0.491, scr_w * 0.33 )
	GUI_CryptoList:SetPos( scr_w * 0.109, scr_h * 0.095 )
	GUI_CryptoList:EnableVerticalScrollbar( true )
	GUI_CryptoList:EnableHorizontal( true )
	GUI_CryptoList:SetSpacing( 7 )
	GUI_CryptoList.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, color_transparent )
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
			local player_owns = math.Round( ply.CH_CryptoCurrencies_Wallet[ crypto.Currency ].Amount, 4 )
			local crypto_worth = math.Round( player_owns * crypto.Price )
			
			local price_change = crypto.Change
			local price_change_color = CH_CryptoCurrencies.Colors.Green
			if price_change < 0 then
				price_change_color = CH_CryptoCurrencies.Colors.Red
			end
			local no_change = false
			
			-- Panel per crypto
			local GUI_CryptoPanel = vgui.Create( "DPanelList" )
			GUI_CryptoPanel:SetSize( scr_w * 0.48, scr_h * 0.06 )
			GUI_CryptoPanel.Paint = function( self, w, h )
				-- Background
				surface.SetDrawColor( CH_CryptoCurrencies.Colors.GrayBG )
				surface.DrawRect( 0, 0, w, h )
				
				-- Coin Icon
				surface.SetDrawColor( color_white )
				surface.SetMaterial( crypto.Icon )
				surface.DrawTexturedRect( w * 0.01, h * 0.12, 50, 50 )
				
				-- Coin name and prefix
				draw.SimpleText( crypto.Name, "CH_CryptoCurrency_Font_Size9", w * 0.08, h * 0.3, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( crypto.Currency, "CH_CryptoCurrency_Font_Size9", w * 0.08, h * 0.7, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				
				-- Coin balance
				draw.SimpleText( CH_CryptoCurrencies.FormatMoney( crypto_worth ), "CH_CryptoCurrency_Font_Size9", w * 0.3, h * 0.3, CH_CryptoCurrencies.Colors.Green, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( player_owns .." ".. crypto.Currency, "CH_CryptoCurrency_Font_Size9", w * 0.3, h * 0.7, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				
				-- Coin price
				draw.SimpleText( crypto.Price .." ".. CH_CryptoCurrencies.CurrencyAbbreviation(), "CH_CryptoCurrency_Font_Size9", w * 0.475, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				
				-- Coin Change
				surface.SetDrawColor( color_white )
				if price_change == 0 then
					no_change = true
				elseif price_change > 0 then
					surface.SetMaterial( CH_CryptoCurrencies.Materials.ArrowUpIcon )
				else
					surface.SetMaterial( CH_CryptoCurrencies.Materials.ArrowDownIcon )
				end
				if not no_change then
					surface.DrawTexturedRect( w * 0.6525, h / 2 - 8, 16, 16 )

					draw.SimpleText( price_change .."%", "CH_CryptoCurrency_Font_Size10", w * 0.675, h / 2, price_change_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				else
					draw.SimpleText( "--", "CH_CryptoCurrency_Font_Size10", w * 0.675, h / 2, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end
			end
			
			local GUI_SellCrypto = vgui.Create( "DButton", GUI_CryptoPanel )
			GUI_SellCrypto:SetSize( scr_w * 0.04, scr_h * 0.04 )
			GUI_SellCrypto:SetPos( scr_w * 0.3915, scr_h * 0.01 )
			GUI_SellCrypto:SetTextColor( Color( 0, 0, 0, 255 ) )
			GUI_SellCrypto:SetText( "" )
			GUI_SellCrypto.Paint = function( self, w, h )
				if player_owns > 0 and self:IsHovered() then
					surface.SetDrawColor( CH_CryptoCurrencies.Colors.Red )
				else
					surface.SetDrawColor( CH_CryptoCurrencies.Colors.GrayFront )
				end
				surface.DrawRect( 0, 0, w, h )

				surface.SetDrawColor( CH_CryptoCurrencies.Colors.Red )
				surface.DrawRect( 0, 0, 2, h )
				
				draw.SimpleText( CH_CryptoCurrencies.LangString( "Sell" ), "CH_CryptoCurrency_Font_Size9", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			GUI_SellCrypto.DoClick = function()
				if player_owns <= 0 then
					surface.PlaySound( "common/wpn_denyselect.wav" )
					return
				end
			
				CH_CryptoCurrencies.SellCryptoMenu( index )
				
				GUI_CryptoFrame:Remove()
			end
			
			local GUI_BuyCrypto = vgui.Create( "DButton", GUI_CryptoPanel )
			GUI_BuyCrypto:SetSize( scr_w * 0.04, scr_h * 0.04 )
			GUI_BuyCrypto:SetPos( scr_w * 0.4355, scr_h * 0.01 )
			GUI_BuyCrypto:SetTextColor( Color( 0, 0, 0, 255 ) )
			GUI_BuyCrypto:SetText( "" )
			GUI_BuyCrypto.Paint = function( self, w, h )
				if self:IsHovered() then
					surface.SetDrawColor( CH_CryptoCurrencies.Colors.Green )
				else
					surface.SetDrawColor( CH_CryptoCurrencies.Colors.GrayFront )
				end
				surface.DrawRect( 0, 0, w, h )

				surface.SetDrawColor( CH_CryptoCurrencies.Colors.Green )
				surface.DrawRect( 0, 0, 2, h )
				
				draw.SimpleText( CH_CryptoCurrencies.LangString( "Buy" ), "CH_CryptoCurrency_Font_Size9", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			GUI_BuyCrypto.DoClick = function()
				CH_CryptoCurrencies.BuyCryptoMenu( index )
				
				GUI_CryptoFrame:Remove()
			end
			
			GUI_CryptoList:AddItem( GUI_CryptoPanel )
		end
	end
end