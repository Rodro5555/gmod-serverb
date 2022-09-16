include( "shared.lua" )

function ENT:DrawTranslucent()
	self:DrawModel()
	
	if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) >= CH_Bitminers.Config.ShowDirt3D2D then
		return
	end
	
	local Pos = self:GetPos()
	Pos = Pos + self:GetUp() * 12
	
	local Ang = self:GetAngles()
	local AngEyes = LocalPlayer():EyeAngles()
	
	Ang:RotateAroundAxis( Ang:Forward(), 90 )
	Ang:RotateAroundAxis( Ang:Right(), -90 )

	cam.Start3D2D( Pos, Angle( 0, AngEyes.y - 90, 90 ), 0.015 )
		draw.SimpleText( CH_Bitminers.LangString( "Dirt Cleaning Fluid" ), "BITMINER_ScreenText30b", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	cam.End3D2D()
end