sReward.RegisterReward("glorified_level", function(ply, levels)
    if !isfunction(GlorifiedLeveling.AddPlayerLevels) then return end
    GlorifiedLeveling.AddPlayerLevels(ply, levels)
end, Material("sreward/level-up.png", "smooth"))

sReward.RegisterReward("glorified_xp", function(ply, xp)
    if !isfunction(GlorifiedLeveling.AddPlayerXP) then return end
    GlorifiedLeveling.AddPlayerXP(ply, xp)
end)