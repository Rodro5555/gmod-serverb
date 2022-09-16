sReward.RegisterReward("darkrp_money", function(ply, amount)
    if !isfunction(ply.addMoney) then return end
    ply:addMoney(amount)
end, Material("sreward/money.png", "smooth"))