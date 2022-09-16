--[[  
    Addon: Hitman
    By: SlownLS
]]

local TABLE = SlownLS.Hitman

function TABLE:drawRect(x,y,w,h,color)
    surface.SetDrawColor(color)
    surface.DrawRect(x,y,w,h)
end

function TABLE:drawOutline(x,y,w,h,color)
    surface.SetDrawColor(color)
    surface.DrawOutlinedRect(x,y,w,h)
end

function TABLE:drawMaterial(x,y,w,h,color,mat)
    surface.SetDrawColor(color)
    surface.SetMaterial(mat)
    surface.DrawTexturedRect(x,y,w,h)
end

function TABLE:getTextSize(strText,strFont)
    surface.SetFont(strFont)
    return surface.GetTextSize(strText)
end

function TABLE:getFont(intSize)
    return "SlownLS:Hitman:" .. intSize
end