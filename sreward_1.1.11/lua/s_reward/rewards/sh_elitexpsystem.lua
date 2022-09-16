sReward.RegisterReward("elite_xp", function(ply, xp)
    if !isfunction(EliteXP.CheckXP) then return end
    EliteXP.CheckXP(ply, xp)
end)