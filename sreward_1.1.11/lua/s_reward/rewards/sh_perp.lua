sReward.RegisterReward("perp_cash", function(ply, amount)
    if !isfunction(ply.AddCash) then return end
    ply:AddCash(amount)
end, Material("sreward/money.png", "smooth"))