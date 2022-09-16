include("shared.lua")

surface.CreateFont("EmergencyResponse:PayPhone:DrawText", 
{
	  font = "Montserrat",
	  size = 71,
	  weight = 900,
	  antialias = true
})

local logo = Material(EmergencyDispatch.DispatchLogo)

function ENT:Draw()
	self:DrawModel()

	if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) < 250000 then
		local ang = Angle( 0, LocalPlayer():EyeAngles().y - 90, 90 )
		local angle = self.Entity:GetAngles()	
		local position = self.Entity:GetPos() + Vector( 0, 0, 0 )
		
		angle:RotateAroundAxis( angle:Forward(), 0 );
		angle:RotateAroundAxis( angle:Right(), 0 );
		angle:RotateAroundAxis( angle:Up(), 90 );
		
		cam.Start3D2D( position + angle:Right() * 0 + angle:Up() * ( math.sin( CurTime() * 1.9 ) * 2.25 + 55 ) + angle:Forward() * 0, ang, 0.1 )
			if EmergencyDispatch.DrawSomethingAbovePayPhone == "logo" then 
				surface.SetDrawColor( 255, 255, 255 )
				surface.SetMaterial( logo )
				surface.DrawTexturedRect( -75, 0, 128, 128 )
			elseif EmergencyDispatch.DrawSomethingAbovePayPhone == "price" then
				draw.SimpleTextOutlined(EmergencyDispatch.PriceToCallPayPhone..EmergencyDispatch.ServerCurrency, "EmergencyResponse:PayPhone:DrawText", -75, 0, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black )
			end
		cam.End3D2D()
	end
end