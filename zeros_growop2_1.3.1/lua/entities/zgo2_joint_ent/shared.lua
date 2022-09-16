ENT.Type                    = "anim"
ENT.Base                    = "base_anim"
ENT.AutomaticFrameAdvance   = false
ENT.PrintName               = "Joint"
ENT.Author                  = "ZeroChain"
ENT.Category                = "Zeros GrowOP 2"
ENT.Spawnable               = false
ENT.AdminSpawnable          = false
ENT.Model                   = "models/zerochain/props_growop2/zgo2_joint.mdl"
ENT.RenderGroup             = RENDERGROUP_OPAQUE


function ENT:SetupDataTables()
    self:NetworkVar("Int", 1, "WeedID")
    self:NetworkVar("Int", 2, "WeedTHC")
    self:NetworkVar("Int", 3, "WeedAmount")
    self:NetworkVar("Bool", 0, "IsBurning")

    if (SERVER) then
        self:SetWeedID(-1)
        self:SetWeedTHC(-1)
        self:SetWeedAmount(0)
        self:SetIsBurning(false)
    end
end
