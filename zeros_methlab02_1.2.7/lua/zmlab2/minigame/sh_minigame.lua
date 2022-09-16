zmlab2 = zmlab2 or {}
zmlab2.MiniGame = zmlab2.MiniGame or {}


function zmlab2.MiniGame.GetPenalty(Machine)
    return math.Round(zmlab2.config.MiniGame.Quality_Penalty)
end

function zmlab2.MiniGame.GetReward(Machine)
    return math.Round(zmlab2.config.MiniGame.Quality_Reward)
end
