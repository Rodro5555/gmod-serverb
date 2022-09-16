include( "shared.lua" )

function ENT:Initialize()
end

--[[
	COLORS
--]]
local col_blue = Color( 62, 173, 229, 255 )

local col_bar_bg = Color( 62, 62, 62, 100 )
local col_bar_bg_notrans = Color( 30, 30, 30, 255 )

local button_col_green = Color( 0, 70, 0, 255 )
local button_col_green_hovered = Color( 0, 110, 0, 255 )

local rect_col_green = Color( 0, 100, 0, 255 )
local rect_col_orange = Color( 240, 137, 19, 255 )
local rect_col_red = Color( 100, 0, 0, 255 )

local col_red = Color( 150, 0, 0, 255 )
local col_hack_green = Color( 0, 200, 0, 255 )

local col_crypto_hover = Color( 255, 255, 255, 180 )
--[[
	MATERIALS
--]]
local mat_rgb_btn
local rgb_col
local power_btn_col

local mat_rgb_btn_on = Material( "craphead_scripts/bitminers/rgb_on.png" )
local mat_rgb_btn_off = Material( "craphead_scripts/bitminers/rgb_off.png" )
local mat_power_btn = Material( "craphead_scripts/bitminers/icon_power.png" )

local mat_lock_icon = Material( "craphead_scripts/bitminers/icon_locked.png" )
local mat_unlock_icon = Material( "craphead_scripts/bitminers/icon_unlocked.png" )

local mat_low_battery = Material( "craphead_scripts/bitminers/low_battery.png" )
local mat_full_battery = Material( "craphead_scripts/bitminers/full_battery.png" )

local mat_hack_skull = Material( "craphead_scripts/bitminers/dlc/hacking_icon.png" )

local mat_eject_bitminer_icon = Material( "craphead_scripts/bitminers/eject.png" )

--[[
	CIRCLES
--]]
local back_circle_capacity = CH_Bitminers.UTIL_CreateCircle( 290, 515, 180, 80, 360, 230 ) -- Back circle
local circle_capacity
local front_circle_capacity = CH_Bitminers.UTIL_CreateCircle( 290, 515, 180, 40, 360, 210 ) -- Front circle

local back_circle_watts = CH_Bitminers.UTIL_CreateCircle( 765, 680, 180, 80, 360, 230 ) -- Back circle
local circle_watts
local front_circle_watts = CH_Bitminers.UTIL_CreateCircle( 765, 680, 180, 40, 360, 210 ) -- Front circle

function ENT:DrawTranslucent()
	self:DrawModel()
	
	if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > CH_Bitminers.Config.ShowScreenDistance then
		return
	end
	
	local Pos = self:GetAttachment( 1 ).Pos
	local Ang = self:GetAttachment( 1 ).Ang
	
	local tr = self:WorldToLocal( LocalPlayer():GetEyeTrace().HitPos )
	
	local bitcoin_rate = CH_Bitminers.Config.BitcoinRate

	--print( tr )
	cam.Start3D2D( Pos, Ang, 0.01 )
		if not self:GetIsMining() and self:GetHasPower() then
			if tr:WithinAABox( CH_Bitminers.Config.ScreenPositions.power_btn_one, CH_Bitminers.Config.ScreenPositions.power_btn_two ) then
				if self:GetHasPower() then
					power_btn_col = button_col_green
				end
			else
				power_btn_col = color_white
			end
			
			surface.SetDrawColor( power_btn_col )
			surface.SetMaterial( mat_power_btn )
			surface.DrawTexturedRect( 700, 250, 750, 750 )
		elseif self:GetHasPower() and ( self.HackingCountdown and self.HackingCountdown > CurTime() ) then
			-- IS BEING HACKED
			surface.SetDrawColor( col_hack_green )
			surface.DrawRect( 0, 0, 2145, 1275 )

			surface.SetDrawColor( color_white )
			surface.SetMaterial( mat_hack_skull )
			surface.DrawTexturedRect( 722.5, 125, 700, 700 )
			
			-- Moving rect & text
			surface.SetDrawColor( col_bar_bg_notrans )
			surface.DrawRect( 322.5, 950, 1500, 200 )
			
			surface.SetDrawColor( col_bar_bg )
			surface.DrawRect( 322.5, 950, ( self.HackingCountdown - CurTime() ) * ( 1500 / CH_Bitminers_DLC.Config.BitminerHackingTime ), 200 )
			
			draw.DrawText( "HACKING BITMINER", "BITMINER_ScreenText23b", 1072.5, 970, color_white, TEXT_ALIGN_CENTER )
			draw.DrawText( string.ToMinutesSeconds( math.Round( self.HackingCountdown - CurTime() ) ), "BITMINER_ScreenText23b", 1072.5, 1040, color_white, TEXT_ALIGN_CENTER )
		elseif self:GetHasPower() then
			--surface.SetDrawColor( rect_col_orange )
			--surface.DrawRect( 0, 0, 2145, 1275 )
			
			-- DRAW HEALTH
			draw.DrawText( "MINER HEALTH", "BITMINER_ScreenText23b", 70, 10, color_white, TEXT_ALIGN_LEFT )
			draw.DrawText( self:Health() .."%", "BITMINER_ScreenText23b", 995, 10, color_white, TEXT_ALIGN_RIGHT )
			
			-- Rect showing health
			surface.SetDrawColor( col_bar_bg )
			surface.DrawRect( 70, 100, 925, 50 )
			
			if self:Health() >= 75 then
				surface.SetDrawColor( rect_col_green )
			elseif self:Health() >= 50 then
				surface.SetDrawColor( rect_col_orange )
			else
				surface.SetDrawColor( rect_col_red )
			end
			surface.DrawRect( 70, 100, math.Clamp( self:Health() * 9.25, 0, 925), 50 )
			
			-- DRAW MONEY MINED
			if bitcoin_rate then
				if CH_Bitminers.Config.IntegrateCryptoCurrencies and CH_CryptoCurrencies then
					if CH_CryptoCurrencies.CryptosCL[ self:GetCryptoIntegrationIndex() ] then
						local crypto_price = CH_CryptoCurrencies.CryptosCL[ self:GetCryptoIntegrationIndex() ].Price
						draw.DrawText( CH_CryptoCurrencies.CryptosCL[ self:GetCryptoIntegrationIndex() ].Name.." Mined", "BITMINER_ScreenText20b", 295, 160, color_white, TEXT_ALIGN_CENTER )
						draw.DrawText( "1".. CH_CryptoCurrencies.CryptosCL[ self:GetCryptoIntegrationIndex() ].Currency .." = ".. DarkRP.formatMoney( crypto_price ), "BITMINER_ScreenText20b", 295, 210, color_white, TEXT_ALIGN_CENTER )
					end
				else
					draw.DrawText( "BITCOINS Mined", "BITMINER_ScreenText20b", 295, 160, color_white, TEXT_ALIGN_CENTER )
					draw.DrawText( "1BTC = "..DarkRP.formatMoney( bitcoin_rate ), "BITMINER_ScreenText20b", 295, 210, color_white, TEXT_ALIGN_CENTER )
				end
			end
			CH_Bitminers.UTIL_DrawCircle( back_circle_capacity, col_bar_bg ) -- Back circle
			
			local mined_bitcoins_degrees = 361 * self:GetBitcoinsMined() / CH_Bitminers.Config.MaxBitcoinsMined
			circle_capacity = CH_Bitminers.UTIL_CreateCircle( 290, 515, 180, 80, math.Clamp( mined_bitcoins_degrees, 0, 361 ), 230 ) -- Money circle
			CH_Bitminers.UTIL_DrawCircle( circle_capacity, col_blue ) -- Money circle
			
			CH_Bitminers.UTIL_DrawCircle( front_circle_capacity, col_bar_bg_notrans ) -- Front circle
			
			draw.DrawText( "CAPACITY", "BITMINER_ScreenText23b", 290, 400, color_white, TEXT_ALIGN_CENTER )
			draw.DrawText( math.Round( self:GetBitcoinsMined() / CH_Bitminers.Config.MaxBitcoinsMined * 100, 1 ) .."%", "BITMINER_ScreenText30b", 290, 475, color_white, TEXT_ALIGN_CENTER )
			
			-- DRAW WATTS
			draw.DrawText( "WATTS", "BITMINER_ScreenText23b", 770, 340, color_white, TEXT_ALIGN_CENTER )
			
			CH_Bitminers.UTIL_DrawCircle( back_circle_watts, col_bar_bg ) -- Back circle
			
			local watts_generated_degrees = 361 * self:GetWattsGenerated() / self:GetWattsRequired()
			circle_watts = CH_Bitminers.UTIL_CreateCircle( 765, 680, 180, 80, math.Clamp( watts_generated_degrees, 0, 361 ), 230 ) -- Money circle
			CH_Bitminers.UTIL_DrawCircle( circle_watts, col_blue ) -- Money circle
			
			CH_Bitminers.UTIL_DrawCircle( front_circle_watts, col_bar_bg_notrans ) -- Front circle
			
			draw.DrawText( "Generated", "BITMINER_ScreenText20b", 770, 510, color_white, TEXT_ALIGN_CENTER )
			draw.DrawText( string.Comma( math.Round( self:GetWattsGenerated() ) ), "BITMINER_ScreenText23b", 770, 570, color_white, TEXT_ALIGN_CENTER )
			
			draw.DrawText( "Required", "BITMINER_ScreenText20b", 770, 670, color_white, TEXT_ALIGN_CENTER )
			draw.DrawText( string.Comma( math.Round( self:GetWattsRequired() ) ), "BITMINER_ScreenText23b", 770, 730, color_white, TEXT_ALIGN_CENTER )
			
			
			
			-- WITHDRAW BUTTON
			if tr:WithinAABox( CH_Bitminers.Config.ScreenPositions.withdraw_one, CH_Bitminers.Config.ScreenPositions.withdraw_two ) then
				draw.RoundedBox( 0, 70, 970, 925, 250, button_col_green_hovered )
			else
				draw.RoundedBox( 0, 70, 970, 925, 250, button_col_green )
			end
			
			if CH_Bitminers.Config.IntegrateCryptoCurrencies and CH_CryptoCurrencies then
				draw.DrawText( "Take ".. CH_CryptoCurrencies.CryptosCL[ self:GetCryptoIntegrationIndex() ].Name, "BITMINER_ScreenText23b", 525, 985, color_white, TEXT_ALIGN_CENTER )
				
				draw.DrawText( math.Round( self:GetBitcoinsMined(), 7 ) .. " ".. CH_CryptoCurrencies.CryptosCL[ self:GetCryptoIntegrationIndex() ].Currency, "BITMINER_ScreenText30b", 525, 1070, color_white, TEXT_ALIGN_CENTER )
			else
				draw.DrawText( "Sell Bitcoins (" ..math.Round( self:GetBitcoinsMined(), 7 ) .." BTC)", "BITMINER_ScreenText23b", 525, 985, color_white, TEXT_ALIGN_CENTER )
				
				if bitcoin_rate then
					draw.DrawText( DarkRP.formatMoney( math.Round( self:GetBitcoinsMined() * bitcoin_rate ) ), "BITMINER_ScreenText30b", 525, 1070, color_white, TEXT_ALIGN_CENTER )
				end
			end
			
			-- SPLIT CENTER LINE
			surface.SetDrawColor( col_bar_bg )
			surface.DrawRect( 1065, 0, 15, 1275 )
			
			-- BITMINERS
			draw.DrawText( "MINERS", "BITMINER_ScreenText23b", 1150, 10, color_white, TEXT_ALIGN_LEFT )
			draw.DrawText( self:GetMinersInstalled() .." / ".. self:GetMinersAllowed(), "BITMINER_ScreenText23b", 2075, 10, color_white, TEXT_ALIGN_RIGHT )
			
			-- Rect showing amount of bitminers
			surface.SetDrawColor( col_bar_bg )
			surface.DrawRect( 1150, 100, 925, 50 )
			
			surface.SetDrawColor( col_blue )
			local multiple_rate = 0
			
			if self:GetMinersAllowed() <= 4 then
				multiple_rate = 231.250
			elseif self:GetMinersAllowed() <= 8 then
				multiple_rate = 115.625
			elseif self:GetMinersAllowed() <= 12 then
				multiple_rate = 77.0833
			elseif self:GetMinersAllowed() <= 16 then
				multiple_rate = 57.8125
			end
			
			surface.DrawRect( 1150, 100, self:GetMinersInstalled() * multiple_rate, 50 )

			-- UPS'S INSTALLED
			draw.DrawText( "POWER SUPPLIES", "BITMINER_ScreenText23b", 1150, 175, color_white, TEXT_ALIGN_LEFT )
			draw.DrawText( self:GetUPSInstalled() .." / 4", "BITMINER_ScreenText23b", 2075, 175, color_white, TEXT_ALIGN_RIGHT )
			
			-- Rect showing amount of ups's installed
			surface.SetDrawColor( col_bar_bg )
			surface.DrawRect( 1150, 265, 925, 50 )
			
			surface.SetDrawColor( col_blue )
			surface.DrawRect( 1150, 265, self:GetUPSInstalled() * 231.25, 50 )
			
			-- VENTILATION
			draw.DrawText( "VENTILATION", "BITMINER_ScreenText23b", 1150, 340, color_white, TEXT_ALIGN_LEFT )
			draw.DrawText( self:GetFansInstalled() .." / 3", "BITMINER_ScreenText23b", 2075, 340, color_white, TEXT_ALIGN_RIGHT )
			
			-- Rect showing vents level
			surface.SetDrawColor( col_bar_bg )
			surface.DrawRect( 1150, 430, 925, 50 )
			
			surface.SetDrawColor( col_blue )
			surface.DrawRect( 1150, 430, self:GetFansInstalled() * 308.33, 50 )
			
			-- TEMPERATURE
			draw.DrawText( "TEMPERATURE", "BITMINER_ScreenText23b", 1150, 505, color_white, TEXT_ALIGN_LEFT )
			draw.DrawText( math.Round( self:GetTemperature(), 3 ) .."C", "BITMINER_ScreenText23b", 2075, 505, color_white, TEXT_ALIGN_RIGHT )
			
			-- Rect showing temp
			surface.SetDrawColor( col_bar_bg )
			surface.DrawRect( 1150, 595, 925, 50 )
			
			if self:GetTemperature() <= 33 then
				surface.SetDrawColor( rect_col_green )
			elseif self:GetTemperature() <= 66 then
				surface.SetDrawColor( rect_col_orange )
			elseif self:GetTemperature() <= 100 then
				surface.SetDrawColor( rect_col_red )
			end
			surface.DrawRect( 1150, 595, self:GetTemperature() * 9.25, 50 )
			
			-- Show RGB Button
			if tr:WithinAABox( CH_Bitminers.Config.ScreenPositions.rgb_btn_one, CH_Bitminers.Config.ScreenPositions.rgb_btn_two ) then
				if self:GetRGBInstalled() then
					rgb_col = color_white
					
					if self:GetRGBEnabled() then
						mat_rgb_btn = mat_rgb_btn_off
					else
						mat_rgb_btn = mat_rgb_btn_on
					end
				else
					rgb_col = col_bar_bg
					mat_rgb_btn = mat_rgb_btn_off
				end
			else
				if self:GetRGBInstalled() then
					rgb_col = color_white
					
					if self:GetRGBEnabled() then
						mat_rgb_btn = mat_rgb_btn_on
					else
						mat_rgb_btn = mat_rgb_btn_off
					end
				else
					rgb_col = col_bar_bg
					mat_rgb_btn = mat_rgb_btn_off
				end
			end
			
			draw.RoundedBox( 0, 1150, 970, 250, 250, col_bar_bg_notrans )
			
			surface.SetDrawColor( rgb_col )
			surface.SetMaterial( mat_rgb_btn )
			surface.DrawTexturedRectRotated( 1275, 1095, 220, 220, CurTime() * 360 )
			
			draw.RoundedBox( 0, 1470, 970, 280, 250, col_bar_bg_notrans )
			
			-- Draw battery
			if self:GetWattsGenerated() < self:GetWattsRequired() then
				draw.DrawText( "LOW", "BITMINER_ScreenText20b", 1610, 976, color_white, TEXT_ALIGN_CENTER )
				draw.DrawText( "POWER", "BITMINER_ScreenText20b", 1610, 1152, color_white, TEXT_ALIGN_CENTER )
				
				surface.SetDrawColor( Color( 255, 255, 255, 150 * math.abs( math.sin( CurTime() * 1.5 ) ) ) )
				surface.SetMaterial( mat_low_battery )
				surface.DrawTexturedRect( 1505, 985, 220, 220 )
			else
				draw.DrawText( "FULL", "BITMINER_ScreenText20b", 1610, 976, color_white, TEXT_ALIGN_CENTER )
				draw.DrawText( "POWER", "BITMINER_ScreenText20b", 1610, 1152, color_white, TEXT_ALIGN_CENTER )
				
				surface.SetDrawColor( color_white )
				surface.SetMaterial( mat_full_battery )
				surface.DrawTexturedRect( 1505, 985, 220, 220 )
			end
			
			-- Draw power button
			if tr:WithinAABox( CH_Bitminers.Config.ScreenPositions.power_btn_small_one, CH_Bitminers.Config.ScreenPositions.power_btn_small_two ) then
				power_btn_col = col_red
			else
				power_btn_col = color_white
			end
			
			draw.RoundedBox( 0, 1825, 970, 250, 250, col_bar_bg_notrans )
			
			surface.SetDrawColor( power_btn_col )
			surface.SetMaterial( mat_power_btn )
			surface.DrawTexturedRect( 1823, 968, 256, 256 )
			
			-- Draw lock/unlock icon
			draw.RoundedBox( 0, 1825, 680, 250, 250, col_bar_bg_notrans )
			
			surface.SetDrawColor( color_white )
			if self:GetIsHacked() then
				surface.SetMaterial( mat_unlock_icon )
			else
				surface.SetMaterial( mat_lock_icon )
			end
			surface.DrawTexturedRect( 1840, 690, 225, 225 )
			
			-- draw eject bitminer icon
			if CH_Bitminers.Config.EnableEjectingBitminers then
				draw.RoundedBox( 0, 1150, 680, 250, 250, col_bar_bg_notrans )
				
				if tr:WithinAABox( CH_Bitminers.Config.ScreenPositions.eject_bitminer_btn_one, CH_Bitminers.Config.ScreenPositions.eject_bitminer_btn_two ) then
					surface.SetDrawColor( rect_col_green )
				else
					surface.SetDrawColor( color_white )
				end

				surface.SetMaterial( mat_eject_bitminer_icon )
				surface.DrawTexturedRect( 1165, 695, 225, 225 )
			end
			
			-- Draw current mined coin based on Cryptos if extension is enabled
			if CH_Bitminers.Config.IntegrateCryptoCurrencies and CH_CryptoCurrencies then
				draw.RoundedBox( 0, 1470, 680, 280, 250, col_bar_bg_notrans )
				
				surface.SetMaterial( CH_CryptoCurrencies.CryptosCL[ self:GetCryptoIntegrationIndex() ].Icon )
				surface.SetDrawColor( col_crypto_hover )
				
				if tr:WithinAABox( CH_Bitminers.Config.ScreenPositions.change_mined_crypto_btn_one, CH_Bitminers.Config.ScreenPositions.change_mined_crypto_btn_two ) then
					surface.SetDrawColor( col_crypto_hover )
					surface.DrawTexturedRect( 1505, 695, 220, 220 )
				else
					surface.DrawTexturedRectRotated( 1610, 805, 220, 220, CurTime() * 100 )
				end
			end
		end
	cam.End3D2D()
end