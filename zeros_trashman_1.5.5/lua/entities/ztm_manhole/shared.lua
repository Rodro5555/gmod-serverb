ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true
ENT.Model = "models/zerochain/props_trashman/ztm_manhole.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Manhole"
ENT.Category = "Zeros Trashman"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Trash")
    self:NetworkVar("Bool", 0, "IsClosed")

    if (SERVER) then
        self:SetTrash(0)
        self:SetIsClosed(true)
    end
end
