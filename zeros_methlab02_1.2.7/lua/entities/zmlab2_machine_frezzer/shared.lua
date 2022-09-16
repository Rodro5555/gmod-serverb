ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = "models/zerochain/props_methlab/zmlab2_frezzer.mdl"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Frezzer"
ENT.Category = "Zeros Methlab 2"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()
    self:NetworkVar("Int", 1, "ProcessState")
    /*
        0 = Needs Lox
        1 = Idle
        2 = Frezzing
    */
    self:NetworkVar("Int", 2, "FrezzeStart")
    if (SERVER) then
        self:SetProcessState(0)
        self:SetFrezzeStart(0)
    end
end

function ENT:OnDropTray(ply)
    local trace = ply:GetEyeTrace()
    local lp = self:WorldToLocal(trace.HitPos)

    if lp.x > 8 and lp.x < 16.3 and lp.y < 11 and lp.y > 10 and lp.z > 49 and lp.z < 52.5 then
        return true
    else
        return false
    end
end

function ENT:OnStart(ply)
    local trace = ply:GetEyeTrace()
    local lp = self:WorldToLocal(trace.HitPos)

    if lp.x > 8 and lp.x < 16.3 and lp.y < 11 and lp.y > 10 and lp.z > 52.5 and lp.z < 56 then
        return true
    else
        return false
    end
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
