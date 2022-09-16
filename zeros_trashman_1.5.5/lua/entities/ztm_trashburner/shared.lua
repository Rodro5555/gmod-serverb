ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true
ENT.Model = "models/zerochain/props_trashman/ztm_trashburner.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Trashburner"
ENT.Category = "Zeros Trashman"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Trash")
    self:NetworkVar("Bool", 1, "IsBurning")
    self:NetworkVar("Bool", 0, "IsClosed")
    self:NetworkVar("Float", 0, "StartTime")

    if (SERVER) then
        self:SetTrash(0)

        self:SetIsClosed(false)
        self:SetIsBurning(false)
        self:SetStartTime(-1)
    end
end

function ENT:OnCloseButton(ply)
    local trace = ply:GetEyeTrace()

    local lp = self:WorldToLocal(trace.HitPos)

    if lp.x > -40 and lp.x < -38 and lp.y < 10.5 and lp.y > 0 and lp.z > 52 and lp.z < 60 then
        return true
    else
        return false
    end
end

function ENT:OnStartButton(ply)
    local trace = ply:GetEyeTrace()

    local lp = self:WorldToLocal(trace.HitPos)

    if lp.x > -40 and lp.x < -38 and lp.y < -0.6 and lp.y > -11 and lp.z > 52 and lp.z < 60 then
        return true
    else
        return false
    end
end
