zmlab2 = zmlab2 or {}
zmlab2.Tent = zmlab2.Tent or {}

zmlab2.Tent_LightColors = {
    [1] = Color(126, 181, 239),
    [2] = Color(211, 49, 49),
    [3] = Color(211, 49, 87),
    [4] = Color(211, 49, 209),
    [5] = Color(133, 49, 211),
    [6] = Color(49, 57, 211),
    [7] = Color(49, 91, 211),
    [8] = Color(49, 167, 211),
    [9] = Color(49, 211, 178),
    [10] = Color(49, 211, 87),
    [11] = Color(110, 211, 49),
    [12] = Color(197, 211, 49),
    [13] = Color(211, 144, 49),
    [14] = Color(211, 95, 49),
    [15] = color_white,
    [16] = Color(125, 125, 125),
    [17] = Color(0, 0, 0)
}

function zmlab2.Tent.Builder_Trace(start_pos,end_pos)

    debugoverlay.Line( start_pos, end_pos, 0.1, Color( 255, 255,255 ), true )

    local c_trace = zclib.util.TraceLine({
        start = start_pos,
        endpos = end_pos,
        filter = {},
        mask = MASK_SOLID_BRUSHONLY,
    }, "zmlab2.Tent.Builder_Trace")
    return c_trace.Hit
end

local function RotCheck(val)
    if val > (0 + 25) or val < (0 - 25) then
        return false
    else
        return true
    end
end

// Tells us if there is enough space for the current tent layout
function zmlab2.Tent.Builder_HasSpace(Tent)

    local TentData = zmlab2.config.Tent[Tent:GetTentID()]
    if TentData == nil then return false end

    //local min,max = Tent.PreviewModel:GetModelBounds()
    local min,max = TentData.min,TentData.max

    // Check if we got enough space
    local pos = Tent:GetPos() + Tent:GetUp() * (max.z / 4)
    local left = zmlab2.Tent.Builder_Trace(pos,pos + Tent:GetRight() * max.y)
    local right = zmlab2.Tent.Builder_Trace(pos,pos + Tent:GetRight() * min.y)
    local forward = zmlab2.Tent.Builder_Trace(pos,pos + Tent:GetForward() * max.x)
    local back = zmlab2.Tent.Builder_Trace(pos,pos + Tent:GetForward() * min.x)
    local up = zmlab2.Tent.Builder_Trace(pos,pos + Tent:GetUp() * max.z)

    local down = zmlab2.Tent.Builder_Trace(pos,pos - Tent:GetUp() * 30)

    if left or right or forward or back or up then
        return false
    else
        // Adds a extra check to see if we are on a ground
        if zmlab2.config.Equipment.OnGroundCheck == true and down == false then return false end

        // Check if the tent is rotated correctly
        local t_ang = Tent:GetAngles()
        if zmlab2.config.Equipment.RotationCheck == true and RotCheck(t_ang.p) == false or RotCheck(t_ang.r) == false then return false end

        return true
    end
end

function zmlab2.Tent.Builder_IsAreaFree(Tent)

    local TentData = zmlab2.config.Tent[Tent:GetTentID()]
    if TentData == nil then return false end

    local min,max = TentData.min,TentData.max

    local rad = (min + max):Length() * 1.5

    // Check if the area is clear
    local AreaClear = true

    for k,v in pairs(ents.FindInSphere(Tent:GetPos(),rad)) do
        if not IsValid(v) then continue end
        //if v:GetClass() == "zmlab2_tent" then continue end
        if v:IsPlayer() == false then continue end
        AreaClear = false
        break
    end
    return AreaClear
end

// Returns a value from 0 to 1 depending on when the player can use the Extinguir again
function zmlab2.Tent.GetNextExtinguish(Tent)
    return math.Clamp((1 / zmlab2.config.Extinguisher.Interval) * (CurTime() - Tent:GetLastExtinguish()), 0, 1)
end
