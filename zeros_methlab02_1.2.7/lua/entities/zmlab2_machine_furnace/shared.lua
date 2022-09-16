ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = "models/zerochain/props_methlab/zmlab2_furnance.mdl"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Furnace"
ENT.Category = "Zeros Methlab 2"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()
    self:NetworkVar("Int", 1, "AcidAmount")
    self:NetworkVar("Int", 2, "Temperatur")
    self:NetworkVar("Int", 3, "Heater")

    self:NetworkVar("Int", 4, "ProcessState")
    self:NetworkVar("Int", 5, "HeatingStart")

    /*
        0 = Needs more Acid
        1 = Press the Start Button
        2 = Is Heating Acid
        3 = Requieres heat change
        4 = Acid is ready and needs to be pumped to next machine
        5 = Moving Acid (Loading)
        6 = Needs to be cleaned
    */

    if (SERVER) then
        self:SetAcidAmount(0)
        self:SetTemperatur(0)
        self:SetHeater(0)
        self:SetProcessState(0)
        self:SetHeatingStart(0)
    end
end

function ENT:OnIncrease(ply)
    local trace = ply:GetEyeTrace()
    local lp = self:WorldToLocal(trace.HitPos)

    if lp.x > -25 and lp.x < -22 and lp.y < 14 and lp.y > 10 and lp.z > 52 and lp.z < 55 then
        return true
    else
        return false
    end
end

function ENT:OnDecrease(ply)
    local trace = ply:GetEyeTrace()
    local lp = self:WorldToLocal(trace.HitPos)

    if lp.x > -12.7 and lp.x < -11 and lp.y < 14 and lp.y > 10 and lp.z > 52 and lp.z < 55 then
        return true
    else
        return false
    end
end

function ENT:OnStart(ply)
    local trace = ply:GetEyeTrace()
    local lp = self:WorldToLocal(trace.HitPos)

    if lp.x > -23 and lp.x < -12 and lp.y < 14 and lp.y > 10 and lp.z > 51 and lp.z < 56.5 then
        return true
    else
        return false
    end
end

function ENT:OnErrorButton(ply)
    local trace = ply:GetEyeTrace()
    local lp = self:WorldToLocal(trace.HitPos)

    if lp.x > -23 and lp.x < -12 and lp.y < 14 and lp.y > 10 and lp.z > 51 and lp.z < 56.5 then
        return true
    else
        return false
    end
end


// Returns the start position and direction for a hose
function ENT:GetHose_Out()
    local attach = self:GetAttachment(1)
    if attach == nil then return self:GetPos(),self:GetAngles() end
    local ang = attach.Ang
    ang:RotateAroundAxis(ang:Up(),90)
    return attach.Pos - ang:Up() * 1,ang
end


function ENT:CanProperty(ply)
    return zclib.Player.IsAdmin(ply)
end

function ENT:CanTool(ply, tab, str)
    return zclib.Player.IsAdmin(ply)
end

function ENT:CanDrive(ply)
    return zclib.Player.IsAdmin(ply)
end
