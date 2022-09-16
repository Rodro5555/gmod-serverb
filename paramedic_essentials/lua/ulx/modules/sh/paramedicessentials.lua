local CATEGORY_NAME = "Paramedic Essentials"

function ulx.revive(calling_ply, target_plys)
    local affected_plys = {}

    for i = 1, #target_plys do
        local v = target_plys[i]
        v.WasRevived = true
        v:Spawn()
        if IsValid( v.DeathRagdoll ) then
            v:SetPos( v.DeathRagdoll:GetPos() )
        end
        for _, v2 in ipairs( v.WeaponsOnKilled ) do
            v:Give( v2 )
        end
    end

    ulx.fancyLogAdmin(calling_ply, "#A revived #T", affected_plys, dmg)
end

local revive = ulx.command(CATEGORY_NAME, "ulx revive", ulx.revive, "!revive")

revive:addParam{
    type = ULib.cmds.PlayersArg
}

revive:defaultAccess(ULib.ACCESS_ADMIN)
revive:help("Revives killed players.")