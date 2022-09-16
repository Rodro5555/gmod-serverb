--[[
	PORTFOLIO MENU
--]]
local buy_icon = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/plus.png" )
local sold_icon = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/minus.png" )

function CH_CryptoCurrencies.TransactionsMenu()
	local ply = LocalPlayer()
	
	local scr_w = ScrW()
	local scr_h = ScrH()
	
	local GUI_TransactionsFrame = vgui.Create( "DFrame" )
	GUI_TransactionsFrame:SetTitle( "" )
	GUI_TransactionsFrame:SetSize( scr_w * 0.6, scr_h * 0.6875 )
	GUI_TransactionsFrame:Center()
	GUI_TransactionsFrame.Paint = function( self, w, h )
		-- Draw frame
		surface.SetDrawColor( CH_CryptoCurrencies.Colors.GrayFront )
		surface.DrawRect( 0, 0, w, h )
		
		-- Draw top
		surface.SetDrawColor( CH_CryptoCurrencies.Colors.GrayBG )
		surface.DrawRect( 0, 0, w, h * 0.059 )
		
		-- Draw the top title.
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Transactions" ), "CH_CryptoCurrency_Font_Size10", w / 2, h * 0.03, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		-- Draw title of crypto list
		surface.SetDrawColor( CH_CryptoCurrencies.Colors.GrayBG )
		surface.DrawRect( scr_w * 0.109, scr_h * 0.0475, scr_w * 0.4875, scr_h * 0.04 )
		
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Name" ), "CH_CryptoCurrency_Font_Size10", w * 0.245, h * 0.095, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Action" ), "CH_CryptoCurrency_Font_Size10", w * 0.421, h * 0.095, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Earn/Cost" ), "CH_CryptoCurrency_Font_Size10", w * 0.56, h * 0.095, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Timestamp" ), "CH_CryptoCurrency_Font_Size10", w * 0.702, h * 0.095, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
	GUI_TransactionsFrame:MakePopup()
	GUI_TransactionsFrame:SetDraggable( false )
	GUI_TransactionsFrame:ShowCloseButton( false )

	local GUI_CloseMenu = vgui.Create( "DButton", GUI_TransactionsFrame )
	GUI_CloseMenu:SetPos( scr_w * 0.582, scr_h * 0.01 )
	GUI_CloseMenu:SetSize( 24, 24 )
	GUI_CloseMenu:SetText( "" )
	GUI_CloseMenu.Paint = function( self, w, h )
		if self:IsHovered() then
			surface.SetDrawColor( CH_CryptoCurrencies.Colors.Red )
		else
			surface.SetDrawColor( color_white )
		end
		surface.SetMaterial( CH_CryptoCurrencies.Materials.CloseIcon )
		surface.DrawTexturedRect( 0, 0, 24, 24 )
	end
	GUI_CloseMenu.DoClick = function()
		GUI_TransactionsFrame:Remove()
	end
	
	local GUI_DashboardFrameBtn = vgui.Create( "DButton", GUI_TransactionsFrame )
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
		GUI_TransactionsFrame:Remove()
		
		CH_CryptoCurrencies.DashboardMenu()
	end

	local GUI_BuyCryptoFrameBtn = vgui.Create( "DButton", GUI_TransactionsFrame )
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
		GUI_TransactionsFrame:Remove()
		
		CH_CryptoCurrencies.CryptoMenu()
	end
	
	local GUI_PortfolioFrameBtn = vgui.Create( "DButton", GUI_TransactionsFrame )
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
		GUI_TransactionsFrame:Remove()
		
		CH_CryptoCurrencies.PortfolioMenu()
	end
	
	if CH_CryptoCurrencies.Config.EnableSQL then
		local GUI_PortfolioFrameBtn = vgui.Create( "DButton", GUI_TransactionsFrame )
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
			GUI_TransactionsFrame:Remove()
			
			CH_CryptoCurrencies.TransactionsMenu()
		end
	end
	
	local GUI_CryptoList = vgui.Create( "DPanelList", GUI_TransactionsFrame )
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
	
	if not ply.CH_CryptoCurrencies_Transactions then
		return
	end
	
	for index, crypto in ipairs( ply.CH_CryptoCurrencies_Transactions ) do
		if crypto then -- Check if this exists. If this doesn't exist it means we have some coins that are no longer available on the server and thus we don't show that.
			local prefix = crypto.Crypto
			
			local GUI_CryptoTransactionPanel = vgui.Create( "DPanelList" )
			GUI_CryptoTransactionPanel:SetSize( scr_w * 0.48, scr_h * 0.06 )
			GUI_CryptoTransactionPanel.Paint = function( self, w, h )
				-- Background
				surface.SetDrawColor( CH_CryptoCurrencies.Colors.GrayBG )
				surface.DrawRect( 0, 0, w, h )
				
				-- Coin Icon
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_CryptoCurrencies.CryptoIconsCL[ prefix ].Icon )
				surface.DrawTexturedRect( w * 0.01, h * 0.12, 50, 50 )
				
				-- Coin name and prefix
				draw.SimpleText( crypto.Name, "CH_CryptoCurrency_Font_Size9", w * 0.08, h * 0.3, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( prefix, "CH_CryptoCurrency_Font_Size9", w * 0.08, h * 0.7, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				
				-- Action (purchased or sold)
				if crypto.Action == "buy" then
					draw.SimpleText( CH_CryptoCurrencies.LangString( "Purchased" ), "CH_CryptoCurrency_Font_Size9", w * 0.3, h / 2, CH_CryptoCurrencies.Colors.Green, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				else
					draw.SimpleText( CH_CryptoCurrencies.LangString( "Sold" ), "CH_CryptoCurrency_Font_Size9", w * 0.3, h / 2, CH_CryptoCurrencies.Colors.Red, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end
				
				-- Price of the transaction (earned or cost)
				draw.SimpleText( string.Comma( crypto.Price ) .." ".. CH_CryptoCurrencies.CurrencyAbbreviation(), "CH_CryptoCurrency_Font_Size9", w * 0.475, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				
				-- Timestamp
				draw.SimpleText( crypto.TimeStamp, "CH_CryptoCurrency_Font_Size9", w * 0.65, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				--[[
				
				if crypto.Action == "buy" then
					draw.SimpleText( CH_CryptoCurrencies.LangString( "Cost" ), "CH_CryptoCurrency_Font_Size14", w * 0.974, h * 0.25, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				else
					draw.SimpleText( CH_CryptoCurrencies.LangString( "Earned" ), "CH_CryptoCurrency_Font_Size14", w * 0.974, h * 0.25, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				end
				draw.SimpleText( string.Comma( crypto.Price ), "CH_CryptoCurrency_Font_Size14", w * 0.92, h * 0.75, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				draw.SimpleText( CH_CryptoCurrencies.CurrencyAbbreviation(), "CH_CryptoCurrency_Font_Size10", w * 0.974, h * 0.7825, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				
				
				if crypto.Action == "buy" then
					draw.SimpleText( CH_CryptoCurrencies.LangString( "Purchased" ), "CH_CryptoCurrency_Font_Size14", w * 0.55, h * 0.25, CH_CryptoCurrencies.Colors.Green, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				else
					draw.SimpleText( CH_CryptoCurrencies.LangString( "Sold" ), "CH_CryptoCurrency_Font_Size14", w * 0.55, h * 0.25, CH_CryptoCurrencies.Colors.Red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
				draw.SimpleText( crypto.TimeStamp, "CH_CryptoCurrency_Font_Size8", w * 0.55, h * 0.775, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				--]]
			end

			GUI_CryptoList:AddItem( GUI_CryptoTransactionPanel )
		end
	end
end