sReward.RegisterReward("wos_level", function(ply, level)
    if !isfunction(ply.SetSkillLevel) then return end
    local oldLevel = ply:GetSkillLevel()
    ply:SetSkillLevel(oldLevel + level)
end)

sReward.RegisterReward("wos_xp", function(ply, xp)
    if !isfunction(ply.SetSkillXP) then return end
    local oldXP = ply:GetSkillXP()
    ply:SetSkillXP(oldXP + xp)
end)

sReward.RegisterReward("wos_points", function(ply, points)
    if !isfunction(ply.SetSkillPoints) then return end
    local oldPoints = ply:GetSkillPoints()
    ply:SetSkillPoints(oldPoints + points)
end)

sReward.RegisterReward("wos_giveitem", function(ply, item_name)
    if !isfunction(wOS.HandleItemPickup) then return end

    wOS:HandleItemPickup(ply, item_name)
end)