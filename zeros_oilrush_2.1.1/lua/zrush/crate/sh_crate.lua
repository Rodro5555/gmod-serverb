zrush = zrush or {}
zrush.Machinecrate = zrush.Machinecrate or {}

local function GetLookAng(ent01,ent02,offset)
    local dir = ent01:GetPos() - ent02:GetPos()
    dir = dir:Angle()
    return ent02:LocalToWorldAngles(Angle(0,dir.y - offset,0))
end

local function RotCheck(val)
    if val > 25 or val < -25 then
        return false
    else
        return true
    end
end

local CustomMachineCheck = {}
CustomMachineCheck[ZRUSH_DRILL] = function(tr,ply)
    local HitEntity = tr.Entity

    local ang
    if IsValid(HitEntity) then
        ang = GetLookAng(ply,HitEntity,180)
    else
        ang = tr.HitNormal:Angle()
        ang:RotateAroundAxis(ang:Right(), -90)
        ang:RotateAroundAxis(ang:Up(), 90)
    end

    // Did we hit a oilspot?
    if IsValid(HitEntity) and not tr.HitWorld and HitEntity:GetClass() == "zrush_oilspot" and (zrush.config.Drill_Mode == 1) then
        // Is the OilSpot not used yet?
        if (not HitEntity:GetHasDrillHole()) then
            return HitEntity:GetPos() , ang
        else
            if (SERVER) then
                zclib.Notify(ply, zrush.language["AllreadyInUse"], 1)
            end
        end
    elseif (IsValid(HitEntity) and HitEntity:GetClass() == "zrush_drillhole") then
        if (not zclib.Player.IsOwner(ply, HitEntity)) then
            if (SERVER) then
                zclib.Notify(ply, zrush.language["YouDontOwnThis"], 1)
            end

            return
        end

        if zrush.DrillHole.ReadyForMachine(HitEntity, ZRUSH_DRILL, ply) then
            return HitEntity:GetPos() , ang
        end
    elseif (tr.HitWorld and zrush.config.Drill_Mode == 0 and zrush.Machinecrate.ValidHeight(tr, ply)) then

        // Do we have enoguh space do build a drilltwoer here?
        if (zrush.Machinecrate.ValidDrillSpace(tr.HitPos) and zrush.Machinecrate.EnoughSpace(tr.HitPos, 30)) then
            return tr.HitPos , ang
        else
            if (SERVER) then
                zclib.Notify(ply, zrush.language["ToocloseDrillHole"], 1)
            end
        end
    else
        if (SERVER) then
            if (zrush.config.Drill_Mode == 0) then
                zclib.Notify(ply, zrush.language["CanonlybuildGround"], 1)
            else
                zclib.Notify(ply, zrush.language["CanonlybuildOilSpots"], 1)
            end
        end
    end
end

CustomMachineCheck[ZRUSH_BURNER] = function(tr,ply)
    local HitEntity = tr.Entity

    // Did we hit a drillhole?
    if (not tr.HitWorld and IsValid(HitEntity) and HitEntity:GetClass() == "zrush_drillhole") then
        // Is the Drillhole not used yet?
        if (zrush.DrillHole.ReadyForMachine(HitEntity, ZRUSH_BURNER, ply)) then
            return HitEntity:GetPos() , GetLookAng(ply,HitEntity,-90)
        end
    else
        if (SERVER) then
            zclib.Notify(ply, zrush.language["CanonlybuildDrillhole"], 1)
        end
    end
end

CustomMachineCheck[ZRUSH_PUMP] = function(tr,ply)
    local HitEntity = tr.Entity

    // Did we hit a drillhole?
    if (not tr.HitWorld and IsValid(HitEntity) and HitEntity:GetClass() == "zrush_drillhole") then
        // Is the drillhole ready do get pumped

        if zrush.DrillHole.ReadyForMachine(HitEntity, ZRUSH_PUMP, ply) then

            return HitEntity:GetPos() , GetLookAng(ply,HitEntity,90)
        end
    else
        if (SERVER) then
            zclib.Notify(ply, zrush.language["CanonlybuildDrillhole"], 1)
        end
    end
end

CustomMachineCheck[ZRUSH_REFINERY] = function(tr,ply)
    if not IsValid(ply) or tr == nil or tr.HitPos == nil or tr.HitNormal == nil then
        return
    end

    local dir = ply:GetPos() - tr.HitPos
    dir = dir:Angle()

    local hitAng = tr.HitNormal:Angle()
    hitAng:RotateAroundAxis(hitAng:Right(),-90)
    hitAng:RotateAroundAxis(hitAng:Up(),90)

    local ang = Angle(hitAng.p,dir.y + 90,hitAng.r)

    // Did we hit the world
    if (tr.HitWorld and zrush.Machinecrate.ValidHeight(tr, ply)) and RotCheck(ang.p) and RotCheck(ang.r) then

        // Add Function do make sure we have enough space
        if (zrush.Machinecrate.EnoughSpace(tr.HitPos, 60)) then


            return tr.HitPos , ang
        else
            if (SERVER) then
                zclib.Notify(ply, zrush.language["NotenoughSpace"], 1)
            end
        end
    else
        if (SERVER) then
            zclib.Notify(ply, zrush.language["CanonlybuildGround"], 1)
        end
    end
end

// This checks if we are lookinga t a valid space for building a entity
function zrush.Machinecrate.CanBuild(ply, MachineID, Machinecrate)
    if not IsValid(Machinecrate) or not IsValid(ply) then return false end

    local tr = ply:GetEyeTrace()
    if tr == nil or tr.Hit == false or tr.HitPos == nil then return false end

    if zclib.util.InDistance(tr.HitPos,ply:GetPos(),1000) == false or zclib.util.InDistance(tr.HitPos,Machinecrate:GetPos(),1000) == false then
        if (SERVER) then zclib.Notify(ply, zrush.language["ConnectionLost"], 2) end
        return false
    end

    local m_BuildPos,m_BuildAng,m_CanBuild
    if CustomMachineCheck[MachineID] then
        m_BuildPos , m_BuildAng = CustomMachineCheck[MachineID](tr,ply)
    end

     if m_BuildPos ~= nil then
         m_CanBuild = true
     else
         m_BuildPos = tr.HitPos
         m_BuildAng = angle_zero
     end

    return m_CanBuild , m_BuildPos , m_BuildAng , tr.Entity
end


// This returns the total sell value of the machine
function zrush.Machinecrate.GetValue(Machinecrate, InstalledModules)
    local totalValue = 0

    if (InstalledModules and table.Count(InstalledModules) > 0) then
        for k, v in pairs(InstalledModules) do
            local mData = zrush.AbilityModules[v]
            local earning = mData.price * zrush.config.MachineBuilder.SellValue
            totalValue = totalValue + earning
        end
    end

    local machineData = zrush.Machine.GetData(Machinecrate:GetMachineID())
    totalValue = totalValue + machineData.price * zrush.config.MachineBuilder.SellValue

    return totalValue
end

// Are there any DrillHoles in the way?
function zrush.Machinecrate.ValidDrillSpace(pos)
    local ValidSpace = true

    for k, v in pairs(ents.FindInSphere(pos, zrush.config.Machine["Drill"].NewDrillRadius)) do
        if (IsValid(v) and v:GetClass() == "zrush_drillhole") then
            ValidSpace = false
            break
        end
    end

    return ValidSpace
end

// Are there any objects in the way?
function zrush.Machinecrate.EnoughSpace(pos, distance)
    local FreeSpace = true

    for k, v in pairs(ents.FindInSphere(pos, distance)) do
        if (IsValid(v) and v:EntIndex() ~= -1 and v:GetClass() == "prop_physics" or v:GetClass() == "prop_dynamics" or v:GetClass() == "player" or string.sub(v:GetClass(), 1, 5) == "zrush") then
            FreeSpace = false
            break
        end
    end
    return FreeSpace
end

//Is the trace pos on the player height range?
function zrush.Machinecrate.ValidHeight(tr, ply)
    local validHeight = true
    local plyPos = ply:GetPos().z
    local range = 200

    if (tr.HitPos.z < (plyPos - range)) then
        validHeight = false
    elseif (tr.HitPos.z > (plyPos + range)) then
        validHeight = false
    end

    return validHeight
end
