zrmine = zrmine or {}
zrmine.f = zrmine.f or {}

function zrmine.f.Player_GetID(ply)
    if ply:IsBot() then
        return ply:UserID()
    else
        return ply:SteamID()
    end
end

function zrmine.f.Player_GetName(ply)
    if ply:IsBot() then
        return "Bot_" .. ply:UserID()
    else
        return ply:Nick()
    end
end
