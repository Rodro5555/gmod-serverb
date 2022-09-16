local recipe = {
    Name = "Veneno",
    Price = 0,
    Special = true,
    Bottles = 1
}

if SERVER then
    function recipe:Effect(ply)
    end
end

return recipe