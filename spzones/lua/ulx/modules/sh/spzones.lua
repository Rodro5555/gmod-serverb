local CATEGORY_NAME = "SPZones"

function ulx.clearnlr(calling_ply, target_plys)
    local affected_plys = {}

    for i = 1, #target_plys do
        local v = target_plys[i]
        SPZones.ClearZones(v)
    end

    ulx.fancyLogAdmin(calling_ply, "#A removed nlr zone from #T", affected_plys, dmg)
end

local clearnlr = ulx.command(CATEGORY_NAME, "ulx clearnlr", ulx.clearnlr, "!clearnlr")

clearnlr:addParam{
    type = ULib.cmds.PlayersArg
}

clearnlr:defaultAccess(ULib.ACCESS_ADMIN)
clearnlr:help("Removes target(s) nlr zones.")

function ulx.checknlr(calling_ply, target_plys)
    for i = 1, #target_plys do
        if target_plys[i] and target_plys[i].DeathSave and #target_plys[i].DeathSave > 0 then
            SPCheckNlr(target_plys[i].DeathSave, calling_ply)
        end
    end
end

local checknlr = ulx.command(CATEGORY_NAME, "ulx checknlr", ulx.checknlr, "!checknlr")

checknlr:addParam{
    type = ULib.cmds.PlayersArg
}

checknlr:defaultAccess(ULib.ACCESS_ALL)
checknlr:help("Display a players death positions.")

function ulx.clearcheck(calling_ply)
    SPClearCheckNlr(calling_ply)
end

local clearcheck = ulx.command(CATEGORY_NAME, "ulx clearcheck", ulx.clearcheck, "!clearcheck")
clearcheck:defaultAccess(ULib.ACCESS_ALL)
clearcheck:help("Removes positions from checknlr")