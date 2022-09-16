sReward.RegisterReward("vrondakis_level", function(ply, levels)
    if !isfunction(ply.addLevels) then return end
    ply:addLevels(levels)
end, Material("sreward/level-up.png", "smooth"))

sReward.RegisterReward("vrondakis_xp", function(ply, xp)
    if !isfunction(ply.addXP) then return end
    ply:addXP(xp)
end)