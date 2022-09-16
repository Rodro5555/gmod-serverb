ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = "models/zerochain/props_methlab/zmlab2_tent_door.mdl"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "Tent"
ENT.Category = "Zeros Methlab 2"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()

    self:NetworkVar("Bool", 1, "IsLocked")
    self:NetworkVar("Bool", 2, "IsPublic")
    self:NetworkVar("Int", 1, "NextInteraction")
    if (SERVER) then
        self:SetIsLocked(false)
        self:SetIsPublic(false)
        self:SetNextInteraction(-1)
    end
end

function ENT:OnLockButton(ply)
    local trace = ply:GetEyeTrace()

    if trace.Hit and trace.HitPos and IsValid(trace.Entity) and trace.Entity == self and zclib.util.InDistance(self:GetPos(), ply:GetPos(), 100) then

        local lp = self:WorldToLocal(trace.HitPos)
        if lp.x > -5 and lp.x < 5 and lp.y < 11 and lp.y > -11 and lp.z > 20 and lp.z < 40 then
            return true
        else
            return false
        end
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
