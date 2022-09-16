MMF.Recipes = {}

local files, _ = file.Find("magicmushroom/recipes/*.lua", "LUA")
for _, name in pairs(files) do
    local id = string.gsub(string.lower(name), ".lua", "")
    local recipe = include("magicmushroom/recipes/" .. name)
    AddCSLuaFile("magicmushroom/recipes/" .. name)

    MMF.Recipes[id] = recipe
end