-- Job settings
MMF.AllowedJobs = {
    ["Recolector de hongos magicos"] = true
}

-- Potion preparation settings
MMF.MushroomGrowTimeSeconds = 40
MMF.PreparationTimeSeconds = 60
MMF.BurnTimeSeconds = 120

-- Potion sell
-- 1 = You just sell it to the npc
-- 2 = The npc tell you to delivery it to a portal
-- 3 = You just trow it at a random portal
MMF.SellType = 2
MMF.Currency = "$"

-- Rank specific
MMF.AdminRanks = { "superadmin", "admin" }
-- If this is enable we will check if user is Admin with Player:IsAdmin
-- If you don't know what does that mean, just leave it enabled
MMF.FallbackAdminCheck = true
MMF.DonatorRanksMultiplier = {
    ["default"] = 1.0,
    ["vipinicial"] = 1.5,
    ["vipgiant"] = 2,
    ["viplegend"] = 2.5,
    ["vipblackblood"] = 3
}

--[[
    Supported Languages:
    en - English
    pt - Português
    es - Español
    fr - Français
    pl - Polskie
    ru - Русский
    tu - Türkçe
    
    Note: Recipes are not translated, only the UI
]]
MMF.UILanguage = "es"

--[[
    If you want to configure a specific recipe or potion, please go to
    lua/magicmushroom/recipes/{recipe}.lua

    Each file is a different recipe, if you want to create a new one,
    just create a new file and follow the pattern of the others recipes.
    Pay attention to not collide the ingredients of different recipes!
]]

--[[
    If you want to configure where the buyer NPCs will spawn, put them
    in the map and run the command "mmf_savenpcs" on console
]]