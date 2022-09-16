ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = "models/zerochain/props_kitchen/zmc_worktable.mdl"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Worktable"
ENT.Category = "Zeros MasterCook"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()
    self:NetworkVar("Int", 1, "ItemID")
    self:NetworkVar("Int", 2, "Progress")
    self:NetworkVar("Int", 3, "TaskType")

    if (SERVER) then
        self:SetItemID(-1)
        self:SetProgress(-1)
        --[[
        1 = cut
        2 = knead
        3 = craft
        ]]
        self:SetTaskType(1)
    end
end

function ENT:CanPickUp(ItemID)
    return true
end

function ENT:CanProperty(ply)
    return ply:IsSuperAdmin()
end

function ENT:CanTool(ply, tab, str)
    return ply:IsSuperAdmin()
end

function ENT:CanDrive(ply)
    return ply:IsSuperAdmin()
end
