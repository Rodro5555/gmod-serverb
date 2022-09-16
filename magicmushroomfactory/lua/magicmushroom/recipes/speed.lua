local recipe = {
    Name = "Poción de velocidad",
    Description = [[
        Esta receta era uno de los secretos más preciados del ejército élfico,
        esta poción fue robada del bolsillo de Malala durante una expedición de gnomos contra el reino de los elfos,
        esta poción te hará alcanzar una velocidad supersónica.
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
        local walkSpeed = ply:GetWalkSpeed()

        ply:SetColor(ColorRand())
        ply:SetWalkSpeed(walkSpeed + 300)

        timer.Simple(20, function()
            if not IsValid(ply) then return end
            ply:SetColor(color_white)
            ply:SetWalkSpeed(walkSpeed)
        end)
    end
end

return recipe