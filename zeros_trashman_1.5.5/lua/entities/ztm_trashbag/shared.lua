ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = "models/zerochain/props_trashman/ztm_trashbag.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Trashbag"
ENT.Category = "Zeros Trashman"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Trash")

    if (SERVER) then
        self:SetTrash(100)
    end
end
