sReward.RegisterReward("elevel_xp", function(ply, xp)
    if !isfunction(ply.addEXP) then return end
    ply:addEXP(xp)
end)