include( "shared.lua" )

function ENT:Initialize()
end

local color_green = Color( 0, 125, 0, 255 )
local color_orange = Color( 240, 137, 19, 255 )

local color_icon = Color( 100, 100, 100, 150 )
local bitcoin_icon = Material( "craphead_scripts/bitminers/bitcoin.png" )

function ENT:DrawTranslucent()
	if self:GetPos():DistToSqr( LocalPlayer():GetPos() ) > 3000000 then
		return
	end
	
	self:DrawModel()
	
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	
	Ang:RotateAroundAxis( Ang:Forward(), 90 )
	Ang:RotateAroundAxis( Ang:Right(), 180 )
	
	local bitcoin_rate = 0
	
	if CH_Bitminers.Config.IntegrateCryptoCurrencies then
		if CH_CryptoCurrencies then
			if CH_CryptoCurrencies.CryptosCL[ CH_Bitminers.CryptoBTCIndexCL ] then
				bitcoin_rate = CH_CryptoCurrencies.CryptosCL[ CH_Bitminers.CryptoBTCIndexCL ].Price
			end
		end
	else
		bitcoin_rate = CH_Bitminers.Config.BitcoinRate
	end
	
	cam.Start3D2D( Pos + Ang:Up() * 0.5, Ang, 0.1 )		
		surface.SetDrawColor( color_icon )
		surface.SetMaterial( bitcoin_icon )
		surface.DrawTexturedRect( -256, -300, 512, 512 )

		-- Text
		draw.DrawText( DarkRP.formatMoney( bitcoin_rate ), "BITMINER_RateScreenText", 0, -200, color_green, TEXT_ALIGN_CENTER )
		
		draw.DrawText( CH_Bitminers.LangString( "Bitcoin Price" ), "BITMINER_RateScreenText", 0, -80, color_orange, TEXT_ALIGN_CENTER )
	cam.End3D2D()
end