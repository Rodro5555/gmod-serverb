ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true
ENT.Model = "models/zerochain/props_trashman/ztm_recycleblock.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Recycled Block"
ENT.Category = "Zeros Trashman"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "RecycleType")

    if (SERVER) then
        self:SetRecycleType(5)
    end
end
