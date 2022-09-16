function MMF.ColorToCymk(color)
    local cyan = 255 - color.r
    local magenta = 255 - color.g
    local yellow = 255 - color.b
    local black = math.min(cyan, magenta, yellow)
    cyan = ((cyan - black) / (255 - black))
    magenta = ((magenta - black) / (255 - black))
    yellow = ((yellow - black) / (255 - black))

    return {
        c = cyan,
        m = magenta,
        y = yellow,
        k = black / 255,
        a = color.a
    }
end

function MMF.CymkToColor(cymk)
    local R = cymk.c * (1.0 - cymk.k) + cymk.k
    local G = cymk.m * (1.0 - cymk.k) + cymk.k
    local B = cymk.y * (1.0 - cymk.k) + cymk.k
    R = math.Round((1.0 - R) * 255.0 + 0.5)
    G = math.Round((1.0 - G) * 255.0 + 0.5)
    B = math.Round((1.0 - B) * 255.0 + 0.5)

    return Color(R, G, B, cymk.a)
end

function MMF.MixColors(colors)
    local C = 0
    local M = 0
    local Y = 0
    local K = 0
    local A = 0

    for i, color in ipairs(colors) do
        local cmyk = MMF.ColorToCymk(color)
        C = C + cmyk.c
        M = M + cmyk.m
        Y = Y + cmyk.y
        K = K + cmyk.k
        A = A + cmyk.a
    end

    C = C / #colors
    M = M / #colors
    Y = Y / #colors
    K = K / #colors
    A = A / #colors

    local color = {
        c = C,
        m = M,
        y = Y,
        k = K,
        a = A
    }

    color = MMF.CymkToColor(color)

    return color
end

function MMF.LiveColor(color)
    local h = color:ToHSL()
    return HSLToColor(h, 1, .5)
end

function MMF.ColorFromTable(colorTable)
    return Color(colorTable.r, colorTable.g, colorTable.b, colorTable.a)
end