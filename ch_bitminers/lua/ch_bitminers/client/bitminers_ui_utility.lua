function CH_Bitminers.UTIL_CreateCircle( x, y, ang, seg, p, rad )
	local circle = {}

	table.insert( circle, { x = x, y = y } )
	
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -p + ang )
		table.insert( circle, { x = x + math.sin( a ) * rad, y = y + math.cos( a ) * rad } )
	end
	
	return circle
end

function CH_Bitminers.UTIL_DrawCircle( circle, color )
	surface.SetDrawColor( color )
	draw.NoTexture()
	surface.DrawPoly( circle )
end