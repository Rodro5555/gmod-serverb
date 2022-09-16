if SERVER then return end
zrush = zrush or {}

net.Receive("zrush_Machine_UpdateSound", function(len)
    local ent = net.ReadEntity()

    if IsValid(ent) and zclib.util.FunctionValidater(ent.UpdateSoundInfo) then
        ent:UpdateSoundInfo()
    end
end)
