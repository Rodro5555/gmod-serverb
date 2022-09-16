if SAM_LOADED then return end

local sam, command = sam, sam.command

command.set_category("SPZones")

command.new("clearnlr")
    :SetPermission("clearnlr", "superadmin")
    :AddArg("player")
    :Help("Clear NLR")

    :OnExecute(function(ply, targets, time)
        for i = 1, #targets do
            local v = targets[i]
            SPZones.ClearZones(v)
        end

        if sam.is_command_silent then return end

        sam.player.send_message(nil, "{A} cleared NLR from {T}", {
            A = ply, T = targets
        })
    end)
:End()

command.new("checknlr")
    :SetPermission("checknlr", "user")
    :AddArg("player")
    :Help("Check a players NLR")

    :OnExecute(function(ply, targets)
        for i = 1, #targets do
            if targets[i] and targets[i].DeathSave and #targets[i].DeathSave > 0 then
                SPCheckNlr(targets[i].DeathSave, ply)
            end
        end
    end)
:End()

command.new("clearcheck")
    :SetPermission("clearcheck", "user")

    :Help("Clears NLR check")

    :OnExecute(function(ply)
        SPClearCheckNlr(ply)
    end)
:End()