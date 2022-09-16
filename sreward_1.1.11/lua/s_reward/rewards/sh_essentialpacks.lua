sReward.RegisterReward("essentials_level", function(ply, levels)
    if !isfunction(ply.AddLevel) then return end
    ply:AddLevel(levels)
end, Material("sreward/level-up.png", "smooth"))

sReward.RegisterReward("essentials_xp", function(ply, xp)
    if !isfunction(ply.AddExperience) then return end
    ply:AddExperience(xp, "")
end)