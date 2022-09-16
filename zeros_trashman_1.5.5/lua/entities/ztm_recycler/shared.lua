ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true
ENT.Model = "models/zerochain/props_trashman/ztm_recycler.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Recycler"
ENT.Category = "Zeros Trashman"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Trash")
    self:NetworkVar("Int", 1, "SelectedType")
    self:NetworkVar("Int", 2, "RecycleStage")
    self:NetworkVar("Float", 0, "StartTime")


    if (SERVER) then
        self:SetTrash(0)
        self:SetSelectedType(1)
        //self:SetIsRecycling(false)
        self:SetRecycleStage(0)
        self:SetStartTime(-1)
    end
end


function ENT:OnStartButton(ply)
    local trace = ply:GetEyeTrace()

    local lp = self:WorldToLocal(trace.HitPos)

    if lp.x > 35 and lp.x < 36 and lp.y < 20.6 and lp.y > -9.5 and lp.z > 49.17 and lp.z < 54.4 then
        return true
    else
        return false
    end
end

function ENT:OnSwitchButton_Left(ply)
    local trace = ply:GetEyeTrace()

    local lp = self:WorldToLocal(trace.HitPos)

    if lp.x > 35 and lp.x < 36 and lp.y < -4.3 and lp.y > -9.5 and lp.z > 56.90 and lp.z < 62.0 then
        return true
    else
        return false
    end
end

function ENT:OnSwitchButton_Right(ply)
    local trace = ply:GetEyeTrace()

    local lp = self:WorldToLocal(trace.HitPos)

    if lp.x > 35 and lp.x < 36 and lp.y < 20.6 and lp.y > 15.4 and lp.z > 56.90 and lp.z < 62.0 then
        return true
    else
        return false
    end
end
