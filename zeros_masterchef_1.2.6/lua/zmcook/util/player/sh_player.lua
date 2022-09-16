zmc = zmc or {}
zmc.Player = zmc.Player or {}

function zmc.Player.IsCook(ply)
    if zmc.config.Jobs and table.Count(zmc.config.Jobs) > 0 then

        //if zclib.Player.IsAdmin(ply) then return true end

        return zmc.config.Jobs[team.GetName(ply:Team())] == true
    else
        return true
    end
end
