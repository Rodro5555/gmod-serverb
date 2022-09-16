include( "shared.lua" )

local col_bg = Color( 60, 60, 60, 200 )
local col_dirt = Color( 102, 51, 0, 200 )

function ENT:DrawTranslucent()
	self:DrawModel()
	
	if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) >= CH_Bitminers.Config.ShowDirt3D2D then
		return
	end
	
	local Pos = self:GetPos()
	Pos = Pos + self:GetUp() * 38 + self:GetForward() * -12
	
	local Ang = self:GetAngles()

	Ang:RotateAroundAxis( Ang:Forward(), 90 )
	Ang:RotateAroundAxis( Ang:Right(), -90 )

	cam.Start3D2D( Pos, Ang, 0.015 )
		draw.SimpleText( CH_Bitminers.LangString( "Dirt" ) .." - ".. self:GetDirtAmount() .."%", "BITMINER_ScreenText30b", 350, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		draw.RoundedBox( 12, -150, 100, 1000, 150, col_bg )
		
		draw.RoundedBox( 12, -150, 100, self:GetDirtAmount() * 10, 150, col_dirt )
	cam.End3D2D()
end