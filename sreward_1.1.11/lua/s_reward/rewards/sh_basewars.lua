sReward.RegisterReward("basewars_money", function(ply, amount)
    if !isfunction(ply.GiveMoney) then return end
    ply:GiveMoney(amount)
end, Material("sreward/money.png", "smooth"))

sReward.RegisterReward("basewars_level", function(ply, level)
    if !isfunction(ply.AddLevel) then return end
    ply:AddLevel(level)
end, Material("sreward/level.png", "smooth"))