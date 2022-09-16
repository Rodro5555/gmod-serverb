SP = SP or {}
SPZones = SPZones or {}
SPZones.Restricted = SPZones.Restricted or {}
SPZones.PunishFunc = SPZones.PunishFunc or {}
SPZones.Menus = SPZones.Menus or {}
-- This is the only part you are allowed to edit --
SPZones.Debug = false

-- What ranks should it ignore
SPZones.IgnoreRanks = {
    ["superadmin"] = true
}

-- What jobs should it ignore
SPZones.IgnoreJobs = {
    ["Desarrollador"] = true,
    ["Super Admin"] = true,
    ["Admin"] = true,
    ["Moderador"] = true,
    ["Moderador de Prueba"] = true
}

--  What steamids should it ignore
SPZones.IgnoreSteamid = {
    --["STEAM_1:1:65391559"] = true,
}

----- Rank Premission -----
-- The ranks which are allowed to use the command (Use lowercase!)
SPZones.AllowedRanks = {
    ["superadmin"] = true,
    ["super-admin"] = true,
    ["admin"] = true
}

-- Ranks which receives messages when nlr is broken
SPZones.AdminMessageRanks = {
    ["superadmin"] = true,
    ["super-admin"] = true,
    ["admin"] = true,
    ["moderador"] = true,
    ["moderador-de-prueba"] = true
}

----- Language -----
SPZones.GhostText = "¡Has sido convertido en fantasma!" -- Text that will appere when ghosted
SPZones.WarnText = "¡Estás a punto de romper NLR!" -- Text to be displaied
SPZones.WarnTimeText = " restantes" -- The text after how many seconds is left
SPZones.WarnTextDelay = "¡Estás rompiendo NLR!" -- Text to be displaied
SPZones.WarnTimeTextDelay = " Segundos restantes!"
SPZones.Reason = "¡Ha sido expulsado por violar NLR!" -- Reason for kicking / banning
SPZones.UlxFreezeText = "Has estado congelado por" -- Ulx will not tell by default how long you are frozen this will print in the player chat
SPZones.AWarnText = "Violando NLR" -- Reason for warning the player though AWarn

--------------------------------------------------
----- DO NOT CHANGE ANYTHING BELOW THIS LINE -----
SPZones.Punishments = SPZones.Punishments or {"Ghost", "Push", "Freeze", "Slay", "Kick", "Ban"}

-- Style 1 is combobox 
-- Style 2 is slider
-- Style 3 is NOT USED
-- Style 4 is table with add and remove
-- Style 5 is zones
-- Style 6 is button with function
-- Style 7 is color selector menu
SP["SPZones"] = {
    ["title"] = "SPZones",
    ["menus"] = {},
    ["shouldDisplay"] = {},
    ["settings"] = {
        ["Enabled"] = {
            Tab = "General",
            Text = "SPZones status",
            Order = 1,
            Style = 1,
            Options = {"Enabled", "Disabled"},
            Value = 1
        },
        ["ZoneRadius"] = {
            Tab = "General",
            Text = "NLR radius",
            Order = 2,
            Style = 2,
            Min = 400,
            Max = 1800,
            Value = 800
        },
        ["ZoneTime"] = {
            Tab = "General",
            Text = "NLR lenght",
            Order = 3,
            Style = 2,
            Min = 30,
            Max = 1000,
            Value = 120
        },
        ["Punishment"] = {
            Tab = "General",
            Text = "Punishment",
            Order = 4,
            Style = 1,
            Options = SPZones.Punishments,
            Value = 1
        },
        ["PunishmentLenght"] = {
            Tab = "General",
            Text = "Punishment time lenght",
            Order = 5,
            Style = 2,
            Min = 0,
            Max = 1800,
            Value = 1800
        },
        ["PunishmentDelay"] = {
            Tab = "General",
            Text = "Punishment delay",
            Order = 6,
            Style = 2,
            Min = 0,
            Max = 300,
            Value = 0
        },
        ["MsgAdmins"] = {
            Tab = "General",
            Text = "Message admins",
            Order = 7,
            Style = 1,
            Options = {"Disabled", "Chat message", "Console"},
            Value = 3
        },
        ["RevengeCombat"] = {
            Tab = "General",
            Text = "Prevent revenge combat",
            Order = 8,
            Style = 1,
            Options = {"Disabled", "Enabled"},
            Value = 1
        },
        ["WorldKill"] = {
            Tab = "General",
            Text = "Remove zone on worldkill",
            Order = 9,
            Style = 1,
            Options = {"Disabled", "Enabled"},
            Value = 2
        },
        ["Suicide"] = {
            Tab = "General",
            Text = "Remove zone on suicide",
            Order = 10,
            Style = 1,
            Options = {"Disabled", "Enabled"},
            Value = 1
        },
        ["Arrest"] = {
            Tab = "General",
            Text = "Remove zones when arrest",
            Order = 11,
            Style = 1,
            Options = {"Disabled", "Enabled"},
            Value = 2
        },
        ["JailTP"] = {
            Tab = "Punishment options",
            Text = "When jailed teleport to position",
            Order = 101,
            Style = 1,
            Options = {"Disabled", "Enabled"},
            Value = 1
        },
        ["JailTPPos"] = {
            Tab = "Punishment options",
            Text = "Jail position",
            BtnText = "Set position",
            Order = 102,
            Style = 6,
            Value = Vector(0, 0, 0)
        },
        ["GhostTransparency"] = {
            Tab = "Punishment options",
            Text = "Ghosted person transparency",
            Order = 103,
            Style = 2,
            Min = 0,
            Max = 255,
            Value = 50
        },
        ["ServerDelay"] = {
            Tab = "Performance",
            Text = "Server delay",
            Order = 201,
            Style = 2,
            Min = 0.01,
            Max = 2,
            Decimals = 2,
            Value = 0.1
        },
        ["ClientDelay"] = {
            Tab = "Performance",
            Text = "Client delay",
            Order = 202,
            Style = 2,
            Min = 0.01,
            Max = 2,
            Decimals = 2,
            Value = 0.1
        },
        ["FadeBeing"] = {
            Tab = "Performance",
            Text = "Fade begin distance",
            Order = 202,
            Style = 2,
            Min = 250,
            Max = 3000,
            Value = 750
        },
        ["FadeOut"] = {
            Tab = "Performance",
            Text = "Fade out distance",
            Order = 203,
            Style = 2,
            Min = 0,
            Max = 1000,
            Value = 250
        },
        ["ZoneStyle"] = {
            Tab = "Appearance",
            Text = "What style should the zones be",
            Order = 301,
            Style = 1,
            Options = {"Sphere", "Flat Sphere", "Dotted circle"},
            Value = 1
        },
        ["ZoneColor"] = {
            Tab = "Appearance",
            Text = "Zone color",
            Order = 302,
            Style = 7,
            Value = Color(52, 73, 94, 220)
        },
        ["ZoneMaterial"] = {
            Tab = "Appearance",
            Text = "Zone material",
            Order = 303,
            Style = 1,
            Options = {"Disabled", "models/wireframe", "models/props_combine/com_shield001a", "models/props_c17/frostedglass_01a"},
            Value = 1
        },
        ["EnterWarn"] = {
            Tab = "Appearance",
            Text = "Warn player before entering zone",
            Order = 304,
            Style = 1,
            Options = {"Disabled", "Enabled"},
            Value = 2
        },
        ["EnterWarnDist"] = {
            Tab = "Appearance",
            Text = "Warn when distance to zone is",
            Order = 305,
            Style = 2,
            Min = 250,
            Max = 1000,
            Value = 500
        },
        ["FlatSphereHeight"] = {
            Tab = "Appearance",
            Text = "Flat sphere height",
            Order = 306,
            Style = 2,
            Min = 0,
            Max = 50,
            Value = 0
        },
        ["DottedSquareSize"] = {
            Tab = "Appearance",
            Text = "Dotted circle square size",
            Order = 307,
            Style = 2,
            Min = 5,
            Max = 10,
            Value = 6
        },
        ["DottedHeight"] = {
            Tab = "Appearance",
            Text = "Dotted circle height",
            Order = 308,
            Style = 2,
            Min = 0,
            Max = 50,
            Value = 25
        },
        ["WarnDisplay"] = {
            Tab = "Appearance",
            Text = "How should NLR warnings be displayed",
            Order = 309,
            Style = 1,
            Options = {"3d2d text", "2d text box", "Notifications"},
            Value = 1
        },
        ["RestrictedZones"] = {
            Tab = "Restricted zones",
            Text = "There aren't any zones created!\nYou can create zones with the SP PP tool under\nQ Menu > Weapons > Splash > SP Zones",
            Order = 400,
            Style = 4
        }
    }
}

----- Punishment Functions -----
SPZones.PunishFunc = {
    ["ghost"] = function(ply)
        SPZones.Ghost(ply)
    end,
    ["push"] = function(ply)
        SPZones.Push(ply)
    end,
    ["freeze"] = function(ply)
        ply:Freeze(true)
        ply:ChatPrint(SPZones.UlxFreezeText .. string.ToMinutesSeconds(SP["SPZones"]["settings"]["PunishmentLenght"].Value) .. " minutes!")
        ply:ChatPrint(SP["SPZones"]["settings"]["PunishmentLenght"].Value)

        if timer.Exists(ply:SteamID() .. "FreezeCheck") then
            timer.Remove(ply:SteamID() .. "FreezeCheck")
        end

        timer.Create(ply:SteamID() .. "FreezeCheck", SP["SPZones"]["settings"]["PunishmentLenght"].Value, 0, function()
            if not ply:IsValid() then
                timer.Remove(ply:SteamID() .. "FreezeCheck")
            else
                if ply:IsFrozen() then
                    ply:Freeze(false)
                    timer.Remove(ply:SteamID() .. "FreezeCheck")
                else
                    timer.Remove(ply:SteamID() .. "FreezeCheck")
                end
            end
        end)
    end,
    ["awarn"] = function(ply)
        awarn_warnplayer(nil, ply, SPZones.AWarnText)
    end,
    ["slay"] = function(ply)
        ply:Kill()
    end,
    ["kick"] = function(ply)
        ply:Kick(SPZones.Reason)
    end,
    ["ban"] = function(ply)
        ply:Ban(string.ToMinutesSeconds(SP["SPZones"]["settings"]["PunishmentLenght"].Value), true)
    end,
    ["sgban"] = function(ply)
        serverguard.command.Run(ply, "ban", SP["SPZones"]["settings"]["PunishmentLenght"].Value, SPZones.Reason)
    end,
    ["sgkick"] = function(ply)
        serverguard.command.Run(ply, "kick", SPZones.Reason)
    end,
    ["sgslay"] = function(ply)
        serverguard.command.Run(ply, "slay")
    end,
    ["sgfreeze"] = function(ply)
        serverguard.command.Run(ply, "freeze")
    end,
    ["sgjail"] = function(ply)
        serverguard.command.Run(ply, "jail", SP["SPZones"]["settings"]["PunishmentLenght"].Value)
    end,
    ["sgrestrict"] = function(ply)
        serverguard.command.Run(ply, "restrict", SP["SPZones"]["settings"]["PunishmentLenght"].Value)
    end,
    ["ulxjail"] = function(ply)
        if SP["SPZones"]["settings"]["JailTP"].Value == 1 then
            ulx.jail(Entity(0), {ply}, SP["SPZones"]["settings"]["PunishmentLenght"].Value, false, SPZones.Reason)
        else
            ply.Jailpos = ply:GetPos()
            ply:SetPos(SP["SPZones"]["settings"]["JailTPPos"].Value)

            ulx.jail(Entity(0), {ply}, SP["SPZones"]["settings"]["PunishmentLenght"].Value, false, SPZones.Reason)

            if timer.Exists(ply:SteamID() .. "TeleportBackJailtp") then
                timer.Remove(ply:SteamID() .. "TeleportBackJailtp")
            end

            timer.Create(ply:SteamID() .. "TeleportBackJailtp", SP["SPZones"]["settings"]["PunishmentLenght"].Value, 0, function()
                -- This ensures the player is still in jail and have not been unjailed 
                if not ply:IsValid() or SP["SPZones"]["settings"]["JailTPPos"].Value:Distance(ply:GetPos()) > 80 then
                    timer.Remove(ply:SteamID() .. "TeleportBackJailtp")
                else
                    ply:SetPos(ply.Jailpos)
                    timer.Remove(ply:SteamID() .. "TeleportBackJailtp")
                end
            end)
        end
    end,
    ["ulxfreeze"] = function(ply)
        ulx.freeze(Entity(0), {ply}, false)

        ply:ChatPrint(SPZones.UlxFreezeText .. string.ToMinutesSeconds(SP["SPZones"]["settings"]["PunishmentLenght"].Value) .. " minutes!")

        if timer.Exists(ply:SteamID() .. "FreezeCheck") then
            timer.Remove(ply:SteamID() .. "FreezeCheck")
        end

        timer.Create(ply:SteamID() .. "FreezeCheck", SP["SPZones"]["settings"]["PunishmentLenght"].Value, 0, function()
            if not ply:IsValid() then
                timer.Remove(ply:SteamID() .. "FreezeCheck")
            else
                if ply:IsFrozen() then
                    ulx.freeze(ply, {ply}, true)

                    timer.Remove(ply:SteamID() .. "FreezeCheck")
                else
                    timer.Remove(ply:SteamID() .. "FreezeCheck")
                end
            end
        end)
    end,
    ["ulxslay"] = function(ply)
        ulx.slay(Entity(0), {ply})
    end,
    ["ulxkick"] = function(ply)
        ulx.kick(Entity(0), {ply}, SPZones.Reason)
    end,
    ["ulxban"] = function(ply)
        ulx.ban(Entity(0), {ply}, string.ToMinutesSeconds(SP["SPZones"]["settings"]["PunishmentLenght"].Value), SPZones.Reason)
    end,
    ["fadminfreeze"] = function(ply)
        RunConsoleCommand("Fadmin", "freeze", ply:SteamID(), SP["SPZones"]["settings"]["PunishmentLenght"].Value)
    end,
    ["fadminslay"] = function(ply)
        RunConsoleCommand("Fadmin", "slay", ply:SteamID())
    end,
    ["fadminkick"] = function(ply)
        RunConsoleCommand("Fadmin", "kick", ply:SteamID(), SPZones.Reason)
    end,
    ["fadminban"] = function(ply)
        RunConsoleCommand("Fadmin", "ban", ply:SteamID(), string.ToMinutesSeconds(SP["SPZones"]["settings"]["PunishmentLenght"].Value), SPZones.Reason)
    end
}

if serverguard then
    serverguard.permission:Add("SPZones_Admin")
    serverguard.permission:Add("SPZones_User")
    local command = {}
    command.help = "Clear a players nlr zone."
    command.command = "clearnlr"

    command.arguments = {"player"}

    command.permissions = "SPZones_Admin"

    function command:OnPlayerExecute(ply, target, arg)
        if target:IsPlayer() then
            SPZones.ClearZones(target)

            return true
        else
            return false
        end
    end

    serverguard.command:Add(command)
    command = {}
    command.help = "Checks a player death positions."
    command.command = "checknlr"

    command.arguments = {"player"}

    command.permissions = "SPZones_User"

    function command:OnPlayerExecute(ply, target, arg)
        if target:IsPlayer() then
            if not target.DeathSave or #target.DeathSave < 1 then return true end
            SPCheckNlr(target.DeathSave, ply)

            return true
        else
            return false
        end
    end

    serverguard.command:Add(command)
    command = {}
    command.help = "Clears the checknlr."
    command.command = "clearcheck"
    command.permissions = "SPZones_User"

    function command:Execute(ply, silent, arg)
        SPClearCheckNlr(ply)

        return true
    end

    serverguard.command:Add(command)
end