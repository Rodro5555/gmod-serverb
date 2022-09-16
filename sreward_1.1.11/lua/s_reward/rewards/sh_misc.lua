
sReward.RegisterReward("give_weapon", function(ply, classname)
    if !isfunction(ply.Give) then return end
    ply:Give(classname)
end)