local recipe = {
    Name = "Poción de Vida",
    Description = [[
        Si mezclas algunos ingredientes algo aparecerá,
        él creía en eso y accidentalmente creó la poción de la vida,
        esta poción te dará la vida que te mereces.
    ]],
    Ingredients = {
        ["amanita"] = 2,
        ["candy"] = 6,
        ["bluesky"] = 1
    },
    Bottles = 2,
    Price = 1000
}

if SERVER then
    function recipe:Effect(ply)
        timer.Create("MMF_Regen_" .. ply:UniqueID(), 0.5, 65, function()
            local newHealth = ply:Health() + 1

            if newHealth <= ply:GetMaxHealth() then
                ply:SetHealth(newHealth)
            end
        end)
    end
end

return recipe