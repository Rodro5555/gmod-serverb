ENT.Type                    = "anim"
ENT.Base                    = "base_anim"
ENT.AutomaticFrameAdvance   = true
ENT.PrintName               = "Mixer"
ENT.Author                  = "ZeroChain"
ENT.Category                = "Zeros GrowOP 2"
ENT.Spawnable               = true
ENT.AdminSpawnable          = false
ENT.Model                   = "models/zerochain/props_growop2/zgo2_mixer.mdl"
ENT.RenderGroup             = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "HasBowl")
    self:NetworkVar("Bool", 1, "HasDough")

    self:NetworkVar("Int", 0, "WeedID")
    self:NetworkVar("Int", 1, "WeedAmount")
    self:NetworkVar("Int", 2, "WeedTHC")

    // 0 = idle, 1 = open , 2 = close , 3 = run
    self:NetworkVar("Int", 3, "WorkState")

	self:NetworkVar("Int", 4, "EdibleID")


    if (SERVER) then
		self:SetEdibleID(0)

        self:SetWorkState(0)
        self:SetHasBowl(true)
        self:SetHasDough(false)

        self:SetWeedID(-1)
        self:SetWeedAmount(0)
        self:SetWeedTHC(0)
    end
end

function ENT:OnRemoveButton(ply)
    local trace = ply:GetEyeTrace()

    local lp = self:WorldToLocal(trace.HitPos)

    if lp.x > -12 and lp.x < 4 and lp.y < 12 and lp.y > 11 and lp.z > 9 and lp.z < 20 then
        return true
    else
        return false
    end
end
