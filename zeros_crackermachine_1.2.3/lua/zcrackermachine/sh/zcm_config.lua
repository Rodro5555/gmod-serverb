zcm = zcm or {}
zcm.f = zcm.f or {}
zcm.config = zcm.config or {}

/////////////////////////// Zeros Crackermaker /////////////////////////////

// Developed by ZeroChain:
// http://steamcommunity.com/id/zerochain/
// https://www.gmodstore.com/users/view/76561198013322242

// If you wish to contact me:
// clemensproduction@gmail.com

/////////////////////////////////////////////////////////////////////////////

// This enables the Debug Mode
zcm.config.Debug = false

// Switches between FastDl and Workshop
zcm.config.EnableResourceAddfile = false

// Currency
zcm.config.Currency = "$"

// The language , en , de , fr , pl , ru , pt , es , cn
zcm.config.SelectedLanguage = "es"

// These Ranks are allowed to use the debug commands and the save command for the buyer npcs  !savezcm
zcm.config.AdminRanks = {
    ["superadmin"] = true,
    ["owner"] = true
}

// These Jobs can sell the illegal firework, Leave empty to disable the Job restriction
zcm.config.Jobs = {
    [TEAM_ZCM_FIREWORKMAKER] = true,
}

// This will add the Player as the Owner of the entities for Falcos Prop Protection System
zcm.config.CPPI = true

zcm.config.Damageable = {
    ["zcm_palette"] = 50,
    ["zcm_box"] = 50,
    ["zcm_crackermachine"] = 150,
    ["zcm_paperroll"] = 25,
    ["zcm_blackpowder"] = 25,
    ["zcm_firecracker"] = 25,
}

zcm.config.Pallet = {
    // How much crackerpacks fit on the pallet?
    Count = 36
}



zcm.config.CrackerMachine = {
    // How much paper can the machine hold
    Paper_Cap = 400,

    // How much blackpowder can the machine hold
    BlackPowder_Cap = 200,

    // How many paperrolls can the machine hold
    PaperRoll_Cap = 25,

    // How much blackpowder gets used per firework
    Usage_BlackPowder = 25,

    // How much paper gets used to create 4 PaperRolls
    Usage_Paper = 10,

    // The upgrades influence the work speed of the machine
    Upgrades = {

        // These ranks are allowed to buy a upgrade, Leave empty to disable the rank restriction
        Ranks = {
            //["superadmin"] = true
        },

        // How many levels can the machine have
        Count = 10,

        // How much does a upgrade cost
        Cost = 5000,

        // How long till the player can buy another upgrade
        Cooldown = 120,

        // How much firework does the machine need to produce before it gets a LevelUp by itself, Set to 0 to disable the auto upgrade
        AutoUpgrade_Count = 16,

        // How much paper can be more stored per upgrade?
        Paper_Cap_Upgrade = 25,

        // How much paper can be more stored per upgrade?
        BlackPowder_Cap_Upgrade = 25,
    },
}

zcm.config.BlackPowder = {
    // How much BlackPowder does one bag contain
    Amount = 100,

    // How much damages does the BlackPowder inflict on players if it explodes
    Damage = 0,
}

zcm.config.Paper = {
    // How much Paper does one roll contain
    Amount = 400,
}

zcm.config.FireCracker = {
    // How many cracker will it spawn on explosion, Note* The crackers entities are only created on client and
    // the spawn amount will also be reduced if necessary by the clients zcm_cl_vfx_effectcount setting to prevent a OverFlow
    CrackerCount = 15,
}

zcm.config.NPC = {
    // The model of the npc
    Model = "models/odessa.mdl",

    // Setting this to false will improve network performance but disables the npc reactions for the player
    Capabilities = true,

    // The values below define the minimum and maximum buy rate of the npc in percentage.
    // The base money the player will recieve is still defined in the SellPrice var above but this modifies it to be diffrent from npc to npc.
    // If you dont want this then just set both to 100
    MaxBuyRate = 115,
    MinBuyRate = 75,

    // The interval at which the buy rate changes in seconds, set to -1 to disable the refreshing of the price modifier
    RefreshRate = 600,

    // The Sell price for each crackerpack per player rank
    SellPrice = {
        ["Default"] = 2328.75, // Dont Remove this value, its used for every rank thats not specified!
        ["vipinicial"] = 3150,
        ["vipgiant"] = 3600,
        ["viplegend"] = 4500,
        ["vipblackblood"] = 5400,
    },
}

zcm.config.Player = {
    // Do we want to reset the players collected firework if he dies?
    ResetFirework_OnDeath = true,
}
