ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true
ENT.Model = "models/zerochain/props_vendingmachine/zvm_package.mdl"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "Crate"
ENT.Category = "Zeros Vendingmachine"
ENT.RenderGroup = RENDERGROUP_BOTH
function ENT:SetupDataTables()
    self:NetworkVar("Int",1,"Progress")
    if (SERVER) then
        self:SetProgress(-1)
    end
end
