ENT.Type                    = "anim"
ENT.Base                    = "base_anim"
ENT.AutomaticFrameAdvance   = true
ENT.PrintName               = "Oven"
ENT.Author                  = "ZeroChain"
ENT.Category                = "Zeros GrowOP 2"
ENT.Spawnable               = true
ENT.AdminSpawnable          = false
ENT.Model                   = "models/zerochain/props_growop2/zgo2_oven.mdl"
ENT.RenderGroup             = RENDERGROUP_BOTH

function ENT:SetupDataTables()

    self:NetworkVar("Bool", 0, "IsBaking")

	self:NetworkVar("Int", 1, "EdibleID")
	self:NetworkVar("Int", 2, "WeedID")

    if (SERVER) then
		self:SetEdibleID(0)
        self:SetIsBaking(false)
		self:SetWeedID(-1)
    end
end

function ENT:OnRemoveButton(ply)
    local trace = ply:GetEyeTrace()

    local lp = self:WorldToLocal(trace.HitPos)

    if lp.x > -8.5 and lp.x < 0 and lp.y < 12 and lp.y > 11 and lp.z > 14 and lp.z < 18 then
        return true
    else
        return false
    end
end

function ENT:OnStartButton(ply)
    local trace = ply:GetEyeTrace()

    local lp = self:WorldToLocal(trace.HitPos)

    if lp.x > 2.5 and lp.x < 8 and lp.y < 7 and lp.y > 6 and lp.z > 24.7 and lp.z < 27.2 then
        return true
    else
        return false
    end
end
