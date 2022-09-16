ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true
ENT.Model = "models/zerochain/props_crackermaker/zcm_crackerpack.mdl"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "CrackerPack"
ENT.Category = "Zeros Crackermachine"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "CrackerCount")

    if (SERVER) then
        self:SetCrackerCount(0)
    end
end
