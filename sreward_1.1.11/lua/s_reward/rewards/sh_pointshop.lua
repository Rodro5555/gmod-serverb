sReward.RegisterReward("ps1_points", function(ply, points)
    if !isfunction(ply.PS_GivePoints) then return end
    ply:PS_GivePoints(ply, points)
end, Material("sreward/points.png", "smooth"))

sReward.RegisterReward("ps2_standard_points", function(ply, points)
    if !isfunction(ply.PS2_AddStandardPoints) then return end
    ply:PS2_AddStandardPoints(points)
end, Material("sreward/points.png", "smooth"))

sReward.RegisterReward("ps2_premium_points", function(ply, points)
    if !isfunction(ply.PS2_AddPremiumPoints) then return end
    ply:PS2_AddPremiumPoints(points)
end, Material("sreward/points.png", "smooth"))

sReward.RegisterReward("sh_ps_standard_points", function(ply, points)
    if !isfunction(ply.SH_AddStandardPoints) then return end
    ply:SH_AddStandardPoints(points)
end, Material("sreward/points.png", "smooth"))

sReward.RegisterReward("sh_ps_premium_points", function(ply, points)
    if !isfunction(ply.SH_AddPremiumPoints) then return end
    ply:SH_AddPremiumPoints(points)
end, Material("sreward/points.png", "smooth"))