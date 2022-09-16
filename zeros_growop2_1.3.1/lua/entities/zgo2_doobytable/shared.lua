ENT.Type                    = "anim"
ENT.Base                    = "base_anim"
ENT.AutomaticFrameAdvance   = false
ENT.PrintName               = "DoobyTable"
ENT.Author                  = "ZeroChain"
ENT.Category                = "Zeros GrowOP 2"
ENT.Spawnable               = true
ENT.AdminSpawnable          = false
ENT.Model                   = "models/zerochain/props_growop2/zgo2_doobytable.mdl"
ENT.RenderGroup             = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "DoobyProgress")
    self:NetworkVar("Int", 1, "WeedID")
    self:NetworkVar("Int", 3, "WeedAmount")
    self:NetworkVar("Int", 4, "WeedTHC")

    self:NetworkVar("Vector", 0, "GamePos")

    if (SERVER) then
        self:SetDoobyProgress(0)
        self:SetWeedID(-1)
        self:SetWeedAmount(0)
        self:SetWeedTHC(0)
        self:SetGamePos(Vector(0,0,0))
    end
end

function ENT:OnRemoveButton(ply)
    local trace = ply:GetEyeTrace()

    local lp = self:WorldToLocal(trace.HitPos)

    if lp.x > -5 and lp.x < -2 and lp.y < 22 and lp.y > 13 and lp.z > 5 and lp.z < 6 then
        return true
    else
        return false
    end
end

function ENT:OnStartButton(ply)
    local trace = ply:GetEyeTrace()

    local lp = self:WorldToLocal(trace.HitPos)

    if lp.x > -8.5 and lp.x < -5 and lp.y < 22 and lp.y > 13 and lp.z > 5 and lp.z < 6 then
        return true
    else
        return false
    end
end

function ENT:OnPaper(ply)
    local trace = ply:GetEyeTrace()

    local lp = self:WorldToLocal(trace.HitPos)

    if lp.x > -2.2 and lp.x < 2.5 and lp.y < 2.8 and lp.y > -2.8 and lp.z > 5 and lp.z < 6 then
        return true
    else
        return false
    end
end

function ENT:OnGrinder(ply)
    local trace = ply:GetEyeTrace()

    local lp = self:WorldToLocal(trace.HitPos)

    if lp.x > -9 and lp.x < -4.9 and lp.y < -14 and lp.y > -20 and lp.z > 5 and lp.z < 6 then
        return true
    else
        return false
    end
end

function ENT:OnHitButton(ply)
    local trace = ply:GetEyeTrace()
    local lp = self:WorldToLocal(trace.HitPos)

    local LGP = self:GetGamePos()


    if lp.x < (LGP.x + 1) and lp.x > (LGP.x - 4) and lp.y < (LGP.y + 3) and lp.y > (LGP.y - 3) then
        return true
    else
        return false
    end
end
