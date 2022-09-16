ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = "models/props_junk/PopCan01a.mdl"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "Item"
ENT.Category = "Zeros MasterCook"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:SetupDataTables()
    self:NetworkVar("String", 1, "ItemID")
    self:NetworkVar("Bool", 1, "IsRotten")

    if (SERVER) then
        self:SetItemID("nil")
        self:SetIsRotten(false)
    end
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
