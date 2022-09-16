include( "shared.lua" )

function ENT:Initialize()
end

local col_gray_dark = Color( 30, 30, 30, 255 )
local col_gray_light = Color( 50, 50, 50, 255 )

local col_green = Color( 0, 100, 0, 255 )
local col_red = Color( 100, 0, 0, 255 )
local col_white_alpha = Color( 255, 255, 255, 5 )

local color_icon = Color( 100, 100, 100, 50 )
local mat_bg_icon = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/bar_graph.png", "noclamp smooth" )
local arrow_up = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/screen_arrow_up.png", "noclamp smooth" )
local arrow_down = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/screen_arrow_down.png", "noclamp smooth" )

function CH_CryptoCurrencies.SetupScreenTable()
	-- Loop through CryptosCL table and set positions based on index and an offset
	for index, crypto in ipairs( CH_CryptoCurrencies.CryptosCL ) do
		local x_pos = -1050
		local y_pos = -680
	
		local x_offset = 0
		local y_offset = 0
		if index <= 6 then
			y_offset = index * 170
			y_pos = y_pos + y_offset
		elseif index <= 12 then
			y_offset = ( index - 6 ) * 170
			y_pos = y_pos + y_offset
			
			x_pos = -325
		elseif index <= 18 then
			y_offset = ( index - 12 ) * 170
			y_pos = y_pos + y_offset
			
			x_pos = 390
		else
			break
		end
		
		-- Write to the new clientside table
		CH_CryptoCurrencies.CryptoExchangeScreen[ index ] = {
			XPos = x_pos,
			YPos = y_pos,
		}
	end
end

function ENT:DrawTranslucent()
	self:DrawModel()
	
	if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) >= CH_CryptoCurrencies.Config.DistanceTo3D2D then
		return
	end
	
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	
	Ang:RotateAroundAxis( Ang:Forward(), 90 )
	Ang:RotateAroundAxis( Ang:Right(), 180 )

	cam.Start3D2D( Pos + Ang:Up() * 0.5, Ang, 0.1 )		
		-- Draw frame
		draw.RoundedBox( 0, -1115, -715, 2230, 1230, col_gray_light )
		
		-- Draw top
		draw.RoundedBox( 0, -1115, -715, 2230, 150, col_gray_dark )
		
		-- Black horizontal line
		draw.RoundedBox( 0, -1115, -570, 2230, 5, color_black )
		
		-- Icon
		surface.SetDrawColor( color_icon )
		surface.SetMaterial( mat_bg_icon )
		surface.DrawTexturedRect( -512, -540, 1024, 1024 )
		
		-- Draw the top title.
		draw.SimpleTextOutlined( CH_CryptoCurrencies.LangString( "Crypto Exchange Rates" ), "CH_CryptoCurrency_Font_Screen_Size100", 0, -640, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 4, color_black )
		
		-- Draw as many exchange rates as we can fit
		for index, crypto in ipairs( CH_CryptoCurrencies.CryptoExchangeScreen ) do
			local crypto_cl = CH_CryptoCurrencies.CryptosCL[ index ]
			-- Adjust position
			local price_change = crypto_cl.Change
			local price_change_color = col_green
			if price_change < 0 then
				price_change_color = col_red
			end
			local no_change = false
			
			-- Background
			draw.RoundedBox( 8, crypto.XPos, crypto.YPos, 655, 120, col_gray_dark )
			
			-- Coin Icon
			surface.SetDrawColor( color_white )
			surface.SetMaterial( crypto_cl.Icon )
			surface.DrawTexturedRect( crypto.XPos + 10, crypto.YPos + 10, 100, 100 )
			
			-- Vertical seperator line
			surface.SetDrawColor( col_white_alpha )
			surface.DrawRect( crypto.XPos + 120, crypto.YPos + 10, 2.5, 100 )
			
			-- Vertical seperator line END
			surface.SetDrawColor( col_white_alpha )
			surface.DrawRect( crypto.XPos + 642.5, crypto.YPos + 10, 2.5, 100 )
			
			-- Horizontal seperator line
			surface.SetDrawColor( col_white_alpha )
			surface.DrawRect( crypto.XPos + 132.5, crypto.YPos + 60, 500, 2.5 )
			
			--[[
				Coin Name & Price
			--]]
			draw.SimpleTextOutlined( crypto_cl.Name, "CH_CryptoCurrency_Font_Screen_Size60", crypto.XPos + 130, crypto.YPos + 30, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, color_black )
			
			surface.SetFont( "CH_CryptoCurrency_Font_Screen_Size60" )
			local x, y = surface.GetTextSize( crypto_cl.Price )
			
			draw.SimpleTextOutlined( crypto_cl.Price, "CH_CryptoCurrency_Font_Screen_Size60", crypto.XPos + 130, crypto.YPos + 90, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, color_black )
			draw.SimpleTextOutlined( CH_CryptoCurrencies.CurrencyAbbreviation(), "CH_CryptoCurrency_Font_Screen_Size40", crypto.XPos + 130 + ( x + 5 ), crypto.YPos + 96, col_green, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, color_black )
			
			--[[
				Coin Change
			--]]
			surface.SetDrawColor( color_white )
			if price_change == 0 then
				no_change = true
			elseif price_change > 0 then
				surface.SetMaterial( arrow_up )
			else
				surface.SetMaterial( arrow_down )
			end
			if not no_change then
				surface.DrawTexturedRect(  crypto.XPos + 600, crypto.YPos + 15, 32, 32 )

				draw.SimpleTextOutlined( price_change .."%", "CH_CryptoCurrency_Font_Screen_Size60", crypto.XPos + 630, crypto.YPos + 90, price_change_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 2, color_black )
			end

		end
	cam.End3D2D()
end