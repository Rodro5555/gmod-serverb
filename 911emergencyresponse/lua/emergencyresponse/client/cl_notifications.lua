local c_background = Color( 0, 0, 0, 200 )
local c_bars = Color( 141, 25, 25 )
local c_red = Color( 48, 48, 48 )

hook.Add("HUDPaint", "EmergencyMod:Notifications", function()
	local Cur = CurTime()
	local sX, sY = ScrW(), ScrH()
	
	for k, v in pairs( emergencymodNotificationSave ) do
		if v.ytimer - Cur < 0 then table.remove(emergencymodNotificationSave, k) continue end

		surface.SetFont( EmergencyResponse:ResponsiveFont( "light" ) )
		local x, y = surface.GetTextSize( v.text )

		local posy = ScrH() - 200 - 60 * k - 40 * ( 1 - ( math.Clamp( Cur - v.wtime, 0 , 1 ) ) )
		local posx = sX * 0.93 - x + math.Clamp( v.ytimer - Cur, 0, 0.25 ) * 4 * 30 + ( 0.25 - math.Clamp ( v.ytimer - Cur, 0, 0.25 ) ) * 4 * sX
			
		surface.SetDrawColor( c_background )
		surface.DrawRect( posx + 52, posy, 20 + x, 45 )

		draw.RoundedBox( 0, posx, posy, 52, 45, c_red )
		draw.RoundedBox( 0, posx, posy, 20 + x + 52, 3, c_bars )
		draw.RoundedBox( 0, posx, posy + 45 - 3, 20 + x + 52, 3, c_bars ) 

		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( EmergencyDispatch.NotificationLogo )
		surface.DrawTexturedRect( posx + 10, posy + 5, 35, 35 )
			
		surface.SetTextPos( posx + 50 + 10, posy + 45/2-y/2 )
		surface.SetTextColor( 255, 255, 255 )
		surface.DrawText( v.text )
	end	
end )

net.Receive( "EmergencyResponse:GModstoreAddon:ExplainIsValidVersion", function()
	local validVersion = net.ReadString()
	
	if validVersion == "notification" then
		local sText = net.ReadString()
		local sTime = net.ReadUInt(3) * 2

		EmergencyResponse:SendNotification( sText, sTime )
	else
		if validVersion == EmergencyResponse.AddonVersion then
			chat.AddText( Color( 238, 11, 11 ), "911 Emergency Response : ", color_white, "Your version is up to date, have a good game!" )
		else
			chat.AddText( Color( 238, 11, 11 ), "911 Emergency Response : ", color_white, "Your version is out to date, you can download the last version (" .. validVersion .. ")." )
		end
	end
end )