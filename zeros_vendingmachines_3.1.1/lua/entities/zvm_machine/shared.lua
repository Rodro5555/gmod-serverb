ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true
ENT.Model = "models/zerochain/props_vendingmachine/zvm_machine.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Vendingmachine"
ENT.Category = "Zeros Vendingmachine"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()

    self:NetworkVar("Bool", 0, "EditConfig")
    self:NetworkVar("Bool", 1, "AllowCollisionInput")
    self:NetworkVar("Entity", 0, "MachineUser")

    self:NetworkVar("Bool", 2, "PublicMachine")

    self:NetworkVar("Int", 0, "Earnings")

    self:NetworkVar("Int", 1, "StyleID")


    if (SERVER) then
        self:SetAllowCollisionInput(false)
        self:SetEditConfig(false)
        self:SetMachineUser(NULL)
        self:SetPublicMachine(false)
        self:SetEarnings(0)

        self:SetStyleID(1)
    end
end

function ENT:OnStartButton(ply)
    local trace = ply:GetEyeTrace()

    local lp = self:WorldToLocal(trace.HitPos)

    if lp.x > -10 and lp.x < 15 and lp.y < 27 and lp.y > 26 and lp.z > 37 and lp.z < 92 then
        return true
    else
        return false
    end
end
