NotificationTable_Venatuss = NotificationTable_Venatuss or {}

function JEWNOTIF( msg, time )
	
	local time = time or 10
	
	NotificationTable_Venatuss[#NotificationTable_Venatuss + 1] = {
		text = msg,
		apptime = CurTime() + 0.2,
		timeremove = CurTime() + 0.2 + 1 + time,
		type = "jewelry",
	}

end

local iconMat = Material( "materials/advancedrobbery/steal.png" )

hook.Add("HUDPaint", "Jewelry.HUDNotifications", function()
		
	for k, v in pairs( NotificationTable_Venatuss ) do
		if v.type == "jewelry" then
			if v.timeremove - CurTime() < 0 then table.remove(NotificationTable_Venatuss,k) continue end
		
			local alpha = ( math.Clamp(CurTime() - v.apptime, 0 , 1) )
			local posy = ScrH() - 200 - 60 * k - 40 * ( 1 - ( math.Clamp(CurTime() - v.apptime, 0 , 1) ) )
			local posx = math.Clamp(v.timeremove - CurTime(),0,0.25) * 4 * 30 + (0.25 - math.Clamp(v.timeremove - CurTime(),0,0.25)) * 4 * - 340
			
			surface.SetFont( "JewelryFont6" )
			local x,y = surface.GetTextSize( v.text ) 
			
			draw.RoundedBox( 5, posx, posy , 60, 40, Color(0, 0, 0,255 * alpha ) )	
			
			surface.SetDrawColor( 255, 255, 255, 255 * alpha )
			surface.DrawRect( posx + 50, posy, 20 + x, 40 )
		
			surface.SetMaterial( iconMat )
			surface.DrawTexturedRect( posx + 10, posy + 5, 30, 30 )
			
			
			surface.SetTextPos( posx + 50 + 10, posy + 40/2-y/2 )
			surface.SetTextColor( 0, 0, 0, 255 * alpha)
			surface.DrawText( v.text )
		end
	end	
	
end)

net.Receive("Jewelry.NotifyPlayer", function()
	local msg = net.ReadString()
	local time = net.ReadInt( 32 )
	JEWNOTIF( msg, time )
end)