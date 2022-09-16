if SERVER then return end

timer.Simple(2,function()
    for k,v in pairs(zmlab2.config.Equipment.List) do zclib.CacheModel(v.model) end
    for k,v in pairs(zmlab2.config.Tent) do zclib.CacheModel(v.model) end
    zclib.CacheModel("models/zerochain/props_methlab/zmlab2_pipe_vent.mdl")
    zclib.CacheModel("models/zerochain/props_methlab/zmlab2_crate.mdl")
    zclib.CacheModel("models/hunter/misc/sphere025x025.mdl")
end)
