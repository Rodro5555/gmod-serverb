zcm = zcm or {}
zcm.f = zcm.f or {}

function zcm.f.Player_GetID(ply)
    if ply:IsBot() then
        return ply:UserID()
    else
        return ply:SteamID()
    end
end

function zcm.f.Player_GetName(ply)
    if ply:IsBot() then
        return "Bot_" .. ply:UserID()
    else
        return ply:Nick()
    end
end
