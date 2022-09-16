include( "shared.lua" )

local mat_overhead_icon = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/bar_graph.png", "noclamp smooth" )
local color_gray_trans = Color( 20, 20, 20, 235 )

function ENT:DrawTranslucent()
	self:DrawModel()
	
	if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) >= CH_CryptoCurrencies.Config.DistanceTo3D2D then
		return
	end
	
	local Ang = self:GetAngles()
	local AngEyes = LocalPlayer():EyeAngles()

	Ang:RotateAroundAxis( Ang:Forward(), 90 )
	Ang:RotateAroundAxis( Ang:Right(), -90 )
	
	cam.Start3D2D( self:GetPos() + self:GetUp() * 85, Angle( 0, AngEyes.y - 90, 90 ), 0.05 )
		draw.RoundedBox( 8, -225, 40, 450, 150, color_gray_trans )

		-- Wallet icon
		surface.SetDrawColor( color_white )
		surface.SetMaterial( mat_overhead_icon )
		surface.DrawTexturedRect( -210, 52, 126, 126 )
		
		local ply_name = CH_CryptoCurrencies.LangString( "Hey" ) .." ".. LocalPlayer():Nick() ..","
		if string.len( ply_name ) > 17 then
			ply_name = string.Left( ply_name, 17 ) ..".."
		end
		
		draw.SimpleTextOutlined( CH_CryptoCurrencies.LangString( "Crypto Trading" ), "CH_CryptoCurrency_Font_Size14", -70, 80, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, color_black )
		draw.SimpleTextOutlined( ply_name, "CH_CryptoCurrency_Font_Size12", -70, 122, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, color_black )
		draw.SimpleTextOutlined( CH_CryptoCurrencies.LangString( "Fancy taking a risk?" ), "CH_CryptoCurrency_Font_Size12", -70, 157, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, color_black )
	cam.End3D2D()
end