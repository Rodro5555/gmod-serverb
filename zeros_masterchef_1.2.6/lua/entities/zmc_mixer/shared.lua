ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = "models/zerochain/props_kitchen/zmc_mixer.mdl"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Mixer"
ENT.Category = "Zeros MasterCook"
ENT.RenderGroup = RENDERGROUP_OPAQUE
-- This entity corresponds to this component
ENT.Component = "mix"

function ENT:SetupDataTables()
    self:NetworkVar("Int", 1, "ItemID")
    self:NetworkVar("Int", 2, "Progress")
    self:NetworkVar("Int", 3, "MixLevel")

    if (SERVER) then
        self:SetItemID(-1)
        self:SetProgress(-1)
        self:SetMixLevel(0)
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

function ENT:CanPickUp(ItemID)
    local ItemData = zmc.Item.GetData(self:GetItemID())
    if ItemData == nil then return end
    if ItemData.mix == nil then return end
    if ItemData.mix.items == nil then return end
    if table.HasValue(ItemData.mix.items, ItemID) == false then return end

    return true
end

function ENT:OnIncrease(ply)
    local trace = ply:GetEyeTrace()
    local lp = self:WorldToLocal(trace.HitPos)

    if lp.x > -34 and lp.x < -28 and lp.y > 15 and lp.y < 20 and lp.z > 53 and lp.z < 57 then
        return true
    else
        return false
    end
end

function ENT:OnDecrease(ply)
    local trace = ply:GetEyeTrace()
    local lp = self:WorldToLocal(trace.HitPos)

    if lp.x > -12 and lp.x < -5 and lp.y > 15 and lp.y < 20 and lp.z > 53 and lp.z < 57 then
        return true
    else
        return false
    end
end
