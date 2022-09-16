ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Mushroom bottle"
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Spawnable = true
ENT.Category = "Magic Mushrooms"
ENT.AutomaticFrameAdvance = true
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "Recipe")
end

function ENT:RunEffect(ply)
    local recipe = self:GetRecipe()
    if recipe ~= "" and MMF.Recipes[recipe].Effect then
        MMF.Recipes[recipe]:Effect(ply)
    end
end