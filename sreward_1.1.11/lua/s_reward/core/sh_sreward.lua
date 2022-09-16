sReward.config["indexToName"] = {} --- Ignore this! Used for optimization.

sReward.RegisterReward = function(name, func, ico)
    sReward.Rewards = sReward.Rewards or {}
    sReward.Rewards[name] = SERVER and func or ico
end