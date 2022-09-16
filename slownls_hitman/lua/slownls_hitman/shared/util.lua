--[[  
    Addon: Hitman
    By: SlownLS
]]

local TABLE = SlownLS.Hitman

function TABLE:getConfig(strName)
    return self.Config[strName]
end

function TABLE:getColor(strName)
    return self.Config.Colors[strName] or color_white
end 

function TABLE:hasJob(pPlayer)
    if( CLIENT and not pPlayer ) then
        pPlayer = LocalPlayer()
    end

    if( not IsValid(pPlayer) ) then return false end

    if( not self.Config.Jobs[team.GetName(pPlayer:Team())] ) then
        return false 
    end

    return true or pPlayer:isHitman()
end