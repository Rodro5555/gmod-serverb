ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Oven"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "Zeros PizzaMaker"
ENT.Model = "models/zerochain/props_pizza/zpizmak_oven.mdl"
ENT.AutomaticFrameAdvance = true
ENT.DisableDuplicator = false

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "PizzaSlot01")
    self:NetworkVar("Entity", 1, "PizzaSlot02")

    if (SERVER) then
        self:SetPizzaSlot01(NULL)
        self:SetPizzaSlot02(NULL)
    end
end
