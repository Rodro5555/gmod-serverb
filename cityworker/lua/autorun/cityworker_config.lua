CITYWORKER = CITYWORKER or {}

CITYWORKER.Config = CITYWORKER.Config or {}

-- How often should we check (in seconds) for City Workers with no assigned jobs, so we can give them?
CITYWORKER.Config.Time = 15

-- Configuration for the DarkRP job.
CITYWORKER.Config.Job = {
    name = "Reparador de la Ciudad",

    color = Color( 20, 150, 20, 255 ),
    model = {
        "models/player/Group01/Female_01.mdl",
        "models/player/Group01/Female_02.mdl",
        "models/player/Group01/Female_03.mdl",
        "models/player/Group01/Female_04.mdl",
        "models/player/Group01/Female_06.mdl",
        "models/player/group01/male_01.mdl",
        "models/player/Group01/Male_02.mdl",
        "models/player/Group01/male_03.mdl",
        "models/player/Group01/Male_04.mdl",
        "models/player/Group01/Male_05.mdl",
        "models/player/Group01/Male_06.mdl",
        "models/player/Group01/Male_07.mdl",
        "models/player/Group01/Male_08.mdl",
        "models/player/Group01/Male_09.mdl"
    },
    description = [[
        El trabajo del trabajador de la ciudad es arreglar fugas, bocas de incendios, escombros y problemas eléctricos en la ciudad, ¡y recibir un pago por hacerlo!
    ]],
	weapons = {
        "weapon_fists", "cityworker_pliers", "cityworker_shovel", "cityworker_wrench"
    },
    command = "cityworker",
    max = 1,
    salary = 75,
    category = "Ciudadanos",
}

------------
-- RUBBLE --
------------

CITYWORKER.Config.Rubble = {}

-- Whether or not rubble is enabled or disabled.
CITYWORKER.Config.Rubble.Enabled = true

-- Rubble models and the range of time (in seconds) it takes to clear them.
CITYWORKER.Config.Rubble.Models = {
    ["models/props_debris/concrete_debris128pile001a.mdl"] = { min = 20, max = 30 },
    ["models/props_debris/concrete_debris128pile001b.mdl"] = { min = 10, max = 15 },
    ["models/props_debris/concrete_floorpile01a.mdl"] = { min = 10, max = 20 },
    ["models/props_debris/concrete_cornerpile01a.mdl"] = { min = 10, max = 20 },
    ["models/props_debris/concrete_spawnplug001a.mdl"] = { min = 5, max = 10 },
    ["models/props_debris/plaster_ceilingpile001a.mdl"] = { min = 10, max = 15 },
}

-- Payout per second it takes to clear a given pile of rubble.
-- (i.e. 10 seconds = 10 * 30 = 300)
CITYWORKER.Config.Rubble.Payout = 30

-------------------
-- FIRE HYDRANTS --
-------------------

CITYWORKER.Config.FireHydrant = {}

-- Whether or not fire hydrants are enabled or disabled.
CITYWORKER.Config.FireHydrant.Enabled = true

-- The range for how long it takes to fix a fire hydrant.
-- Maximum value: 255 seconds.
CITYWORKER.Config.FireHydrant.Time = { min = 20, max = 30 }

-- Payout per second it takes to fix a fire hydrant.
CITYWORKER.Config.FireHydrant.Payout = 40

-----------
-- LEAKS --
-----------

CITYWORKER.Config.Leak = CITYWORKER.Config.Leak or {}

-- Whether or not leaks are enabled or disabled.
CITYWORKER.Config.Leak.Enabled = true

-- The range for how long it takes to fix a leak.
-- Maximum value: 255 seconds.
CITYWORKER.Config.Leak.Time = { min = 10, max = 30 }

-- Payout per second it takes to fix a leak.
CITYWORKER.Config.Leak.Payout = 20

--------------
-- ELECTRIC --
--------------

CITYWORKER.Config.Electric = CITYWORKER.Config.Electric or {}

-- Whether or not electrical problems are enabled or disabled.
CITYWORKER.Config.Electric.Enabled = true

-- The range for how long it takes to fix an electrical problem.
-- Maximum value: 255 seconds.
CITYWORKER.Config.Electric.Time = { min = 20, max = 30 }

-- Payout per second it takes to fix an electrical problem.
CITYWORKER.Config.Electric.Payout = 50

----------------------------
-- LANGUAGE CONFIGURATION --
----------------------------

CITYWORKER.Config.Language = {
    ["FireHydrant"]         = "Fixing fire hydrant...",
    ["Leak"]                = "Fixing leak..",
    ["Electric"]            = "Fixing electrical problem...",
    ["Rubble"]              = "Clearing rubble...",

    ["CANCEL"]              = "Press F2 to cancel the action.",
    ["PAYOUT"]              = "You've earned %s from your work!",
    ["CANCELLED"]           = "You've cancelled your action!",
    ["NEW_JOB"]             = "You have a new job to do!",
    ["NOT_CITY_WORKER"]     = "You are not a city worker!",
    ["JOB_WORKED"]          = "This job is already being worked!",
    ["ASSIGNED_ELSE"]       = "This job has been assigned to someone else!",
}
