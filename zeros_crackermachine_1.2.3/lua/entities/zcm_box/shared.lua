ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true
ENT.Model = "models/zerochain/props_crackermaker/zcm_box.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Transport Box"
ENT.Category = "Zeros Crackermachine"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "FireworkCount")
    self:NetworkVar("Bool", 0, "IsOpen")

    if (SERVER) then
        self:SetFireworkCount(0)
        self:SetIsOpen(true)
    end
end

function ENT:OnSellButton(ply)
    local trace = ply:GetEyeTrace()

    local lp = self:WorldToLocal(trace.HitPos)

    if lp.y > -17.5 and lp.y < -11.7 and lp.x < 10 and lp.x > -10 then
        return true
    else
        return false
    end
end
