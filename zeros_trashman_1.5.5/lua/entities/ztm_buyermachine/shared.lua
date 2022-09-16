ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true
ENT.Model = "models/zerochain/props_trashman/ztm_buyermachine.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Buyermachine"
ENT.Category = "Zeros Trashman"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "IsInserting")
    self:NetworkVar("Float", 0, "Money")
    self:NetworkVar("Int", 0, "BlockType")
    self:NetworkVar("Entity", 0, "MoneyEnt")
    self:NetworkVar("Int", 1, "PriceModify")
    if (SERVER) then
        self:SetIsInserting(false)
        self:SetMoney(0)
        self:SetBlockType(1)
        self:SetPriceModify(100)
    end
end


function ENT:OnPayoutButton(ply)
    local trace = ply:GetEyeTrace()

    local lp = self:WorldToLocal(trace.HitPos)

    if lp.x > -13 and lp.x < 13 and lp.y < 10 and lp.y > 9 and lp.z > 79 and lp.z < 85.3 then
        return true
    else
        return false
    end
end
