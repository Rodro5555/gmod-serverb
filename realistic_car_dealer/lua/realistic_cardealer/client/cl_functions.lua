-- [[ Thanks to GNLIB for the DrawCircle and DrawElipse function ( https://github.com/Nogitsu/GNLib/ ) ]]
function RCD.DrawComplexCircle(x, y, radius, angle_start, angle_end, color)
	local poly = {}
	angle_start = angle_start or 0
	angle_end = angle_end or 360
	
	poly[1] = { x = x, y = y }
	for i = math.min( angle_start, angle_end ), math.max( angle_start, angle_end ) do
		local a = math.rad( i )
		if angle_start < 0 then
			poly[#poly + 1] = { x = x + math.cos( a ) * radius, y = y + math.sin( a ) * radius }
		else
			poly[#poly + 1] = { x = x - math.cos( a ) * radius, y = y - math.sin( a ) * radius }
		end
	end
	poly[#poly + 1] = { x = x, y = y }

	draw.NoTexture()
	surface.SetDrawColor( color or color_white )
	surface.DrawPoly( poly )

	return poly
end

function RCD.DrawSimpleCircle(x, y, radius, seg)
	local cir = {}

	table.insert(cir, { x = x, y = y, u = 0.5, v = 0.5 })
	for i = 0, seg do
		local a = math.rad((i / seg) * -360)
		table.insert(cir, { x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5 })
	end

	local a = math.rad(0) -- This is needed for non absolute segment counts
	table.insert(cir, { x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5 })

	surface.DrawPoly(cir)
end

RCD.PrecachedCircles = RCD.PrecachedCircles or {} 

function RCD.GetCircle(x, y, radius, angle_start)
    local poly = {}

    local i = 0
    while i < 360 do
        i = i + 15
        local posx = x + math.cos(math.rad(i))*radius
        local posy = y + math.sin(math.rad(i))*radius

        poly[#poly+1] = {x=posx, y=posy}
    end

    return poly
end

function RCD.PrecacheCircle(x, y, radius, angle_start, angle_end)
    RCD.PrecachedCircles[x] = RCD.PrecachedCircles[x] or {}
    RCD.PrecachedCircles[x][y] = RCD.PrecachedCircles[x][y] or {}
    RCD.PrecachedCircles[x][y][radius] = RCD.PrecachedCircles[x][y][radius] or {}
    RCD.PrecachedCircles[x][y][radius][angle_start] = RCD.PrecachedCircles[x][y][radius][angle_start] or {}
    RCD.PrecachedCircles[x][y][radius][angle_start][angle_end] = RCD.PrecachedCircles[x][y][radius][angle_start][angle_end] or RCD.GetCircle(x, y, radius, angle_start, angle_end)
    
    return RCD.PrecachedCircles[x][y][radius][angle_start][angle_end]
end

function RCD.DrawCircle(x, y, radius, angle_start, angle_end, color)
    
    local poly = RCD.PrecacheCircle(x, y, radius, angle_start, angle_end)

    draw.NoTexture()
    surface.SetDrawColor(color or color_white)
    surface.DrawPoly(poly)

    return poly
end

-- [[ Thanks to GNLIB for the DrawCircle and DrawElipse function ( https://github.com/Nogitsu/GNLib/ ) ]]
function RCD.DrawElipse(x, y, w, h, color, hide_left, hide_right)
	surface.SetDrawColor(color or color_white)

	if hide_left then surface.DrawRect( x, y, h / 2, h ) else RCD.DrawCircle( x + h / 2, y + h / 2, h / 2, 90, -90, color ) end
	if hide_right then surface.DrawRect( x + w - h / 2, y, h / 2, h ) else RCD.DrawCircle( x + w - h / 2, y + h / 2, h / 2, -90, 90, color ) end

	surface.DrawRect( x + h / 2, y, w - h + 2, h )
end

--[[ Lerp a color to an other color ]]
function RCD.LerpColor(frameTime, color, colorTo)
	return Color(Lerp(frameTime, color.r, colorTo.r), Lerp(frameTime, color.g, colorTo.g), Lerp(frameTime, color.b, colorTo.b), Lerp(frameTime, color.a, colorTo.a))
end

--[[ Draw a blur on a specific panel ]]
function RCD.DrawBlur(panel, amount)
    local x, y = panel:LocalToScreen(0, 0)

    surface.SetDrawColor(RCD.Colors["white"])
    surface.SetMaterial(RCD.Materials["blur"])

    for i=1, 3 do
        RCD.Materials["blur"]:SetFloat("$blur", (i/3) * (amount or 6))
        RCD.Materials["blur"]:Recompute()

        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x*-1, y*-1, RCD.ScrW, RCD.ScrH)
    end
end

--[[ Change the origin point of a rotated texture ]]
function RCD.DrawTexturedRectRotatedPoint( x, y, w, h, rot, x0, y0 )
	local c = math.cos(math.rad(rot))
	local s = math.sin(math.rad(rot))
	
	local newx = y0 * s - x0 * c
	local newy = y0 * c + x0 * s
	
	surface.DrawTexturedRectRotated(x + newx, y + newy, w, h, rot)
end

--[[ Stencil function ]]
function RCD.MaskStencil(maskFunc, renderFunc, bool)
    render.ClearStencil()
    render.SetStencilEnable(true)
  
    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)
  
    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(bool and STENCILOPERATION_REPLACE or STENCILOPERATION_KEEP)
    render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)
  
	maskFunc()
  
    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(bool and STENCILOPERATION_REPLACE or STENCILOPERATION_KEEP)
    render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(bool and 0 or 1)
  
    renderFunc(self, w, h)
  
    render.SetStencilEnable(false)
    render.ClearStencil()
end

--[[ Function used to create fonts ]]
local FontTable = {}
function RCD.CreateFonts(size, fontType, fontWeight, italicOption)
	local fontSize = math.Round(size, 0)
	local fontName = "rcd_generate"..fontSize

    if FontTable[fontName] then 
        return fontName
    end

    surface.CreateFont(fontName, {
        font = (fontType or "Georama Black"), 
        size = fontSize, 
        weight = (fontWeight or 0),
        antialias = true,
        italic = italicOption,
    })
    FontTable[fontName] = true

    return fontName
end 

--[[ Function to created rounded rect ]]
function RCD.DrawRoundedRect(radius, x, y, w, h, color)
    surface.SetDrawColor(color or color_white)

    surface.DrawRect(x + radius, y, w - radius * 2, h)
    surface.DrawRect(x, y + radius, radius, h - radius * 2)
    surface.DrawRect(x + w - radius, y + radius, radius, h - radius * 2)

    RCD.DrawCircle(x + radius, y + radius, radius, -180, -90, color)
    RCD.DrawCircle(x + w - radius, y + radius, radius, -90, 0, color)
    RCD.DrawCircle(x + radius, y + h - radius, radius, -270, -180, color)
    RCD.DrawCircle(x + w - radius, y + h - radius, radius, 270, 180, color)
end

--[[ Function to created texture rect ]]
function RCD.RoundedTextureRect(radius, x, y, w, h, mat, color, rotation)
    RCD.MaskStencil(function()
        RCD.DrawRoundedRect(radius, x, y, w, h, color)
    end, function()
        surface.SetMaterial(mat)
        surface.DrawTexturedRect(x, y, w, h)
    end)
end