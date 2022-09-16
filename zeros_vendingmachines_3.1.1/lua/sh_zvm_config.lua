zvm = zvm or {}
zvm.config = zvm.config or {}

/////////////////////////// Zeros Vendingmachines /////////////////////////////

// Developed by ZeroChain:
// http://steamcommunity.com/id/zerochain/
// https://www.gmodstore.com/users/view/76561198013322242

/////////////////////////////////////////////////////////////////////////////


/*
    Console Commands:
        zvm_save_vendingmachines - Save all the Vendingmachines
        zvm_remove_vendingmachines - Remove all the Vendingmachines
        zvm_vendingmachine_mirror - Mirrors all Vendingmachines on the server with the one you are looking at
        zvm_customweapons_add WEAPONCLASS - Add Custom Swep to Vendingmachine
        zvm_easyskins_add SKINNAME - Add EasySkins WeaponSkin to Vendingmachine

    Chat Commands:
        !savezvm - Save all the Vendingmachines
        !zvm_customweapons_add_WEAPONCLASS - Add Custom Swep to Vendingmachine
        !zvm_shaccessories_add_ITEMID - Add SH_AddAccessory Item to Vendingmachine
        !zvm_easyskins_add_SKINNAME - Add EasySkins WeaponSkin to Vendingmachine
*/


///////////////////////// zclib Config //////////////////////////////////////
/*
	This config can be used to overwrite the main config of zeros libary
*/
/*
// These Ranks are admins
// If xAdmin, sAdmin or SAM is installed then this table can be ignored
zclib.config.AdminRanks = {
	["superadmin"] = true
}

// These Police jobs get informed if a player Lockpicks a Vendingmachine
// Leaving this empty means that Players can Lockpick vendingmachines even if no Police Job is on the Server.
zclib.config.Police = {
	Jobs = {
		[TEAM_POLICE] = true,
	}
}
*/
//zclib.config.CleanUp.SkipOnTeamChange[TEAM_STAFF] = true
/////////////////////////////////////////////////////////////////////////////


if GM and GM.Config and GM.Config.PocketBlacklist then
    GM.Config.PocketBlacklist["zvm_crate"] = true
    GM.Config.PocketBlacklist["zvm_machine"] = true
end


// Switches between FastDl and Workshop
zvm.config.FastDl = false

// The language , en , ru , de , fr , pl , cn , ptbr , tr, es
zvm.config.SelectedLanguage = "es"

// Currency
zvm.config.Currency = {
    [1] = "$", // Money
    [2] = "ps", // PS Points
    [3] = "ps2", // PS2 Points
    [4] = "ps2p", // PS2 PremiumPoints
}

// This defines if the currency symbol should come before or after the value
zvm.config.CurrencyPosInvert = true

// This defines the size of the render target aka the resolution of the custom lua material
zvm.config.RenderTargetSize = 512

zvm.config.Vendingmachine = {

	// How many items can fit in the machine? 12 per Page, 4 Pages = 48 Items
	ItemCapacity = 48,

	// How many packages is the player allowed to spawn before the limit is reached
    PackageLimit = 3,

	// Should we allow the players to change the Item Name? This option only affects users not admins.
	NameChange = false,

	// If the players interacts longer then this then we auto sign him off, so he doesent block the vendingmachine
	IdleTime = 300,

	Visuals = {
        // Should we play a sound when the idle item changes?
        Shuffle_Sound = true,

		// How long till we show the next Item in idle mode
        Shuffle_Interval = 5,

		// Should the title of vendingmachines animate (letter construction) or should it just blink
	    AnimateTitle = true,

        // Makes the product image in the idle screen dance
        AnimateIdleImage = true,

        // Adds dirt arround the border of the screen
        ScreenDirt = true,
	},

    // List of class / class prefix allowed by the machine
    // Some entities have custom data which need to get defined in zvm_itemdata_sv.lua (Future Updates will add more Entity Classes with custom data)
    AllowedItems = {
        "sent_ball",
    	"weapon_",
    	"weapons_",
    	"durgz_",
    	"drug_",
    	"drugs_",
    	"item_health",
        "item_battery",
    	"item_ammo",
    	"item_box",
        "item_rpg_round",
    	"spawned_shipment",
    	"spawned_weapon",
    	"spawned_food",
        "food",
    	"spawned_ammo",
    	"m9k_",
        "ls_sniper",
        "bb_",
		"manhack_welder",
		"tfa_",
        "boost_"
    },

    // A list of banned classes.
    BannedItems = {
    	"m9k_harpoon",
    },

    // Here you can predefine Rank Groups
    RankGroups = {
        [1] = {
            // The name of the group
            name = "Owner",

            // The ranks this group allows
            ranks = {
                ["owner"] = true,
                ["superadmin"] = true,
            }
        },
        [2] = {
            name = "VIP",
            ranks = {
                ["vipinicial"] = true,
                ["vipgiant"] = true,
                ["viplegend"] = true,
                ["vipblackblood"] = true,
            }
        },
    },

    // Here you can predefine Job Groups
    JobGroups = {
        [1] = {
            // The name of the group
            name = "Police",

            // The jobs this group allows
            jobs = {
                ["TEAM_POLICE"] = true,
            }
        },
        [2] = {
            name = "Criminal",
            jobs = {
                ["TEAM_GANG"] = true,
                ["TEAM_MOB"] = true,
            }
        },
        [3] = {
            name = "Gundealers",
            jobs = {
                ["TEAM_GANG"] = true,
                ["TEAM_MOB"] = true,
            }
        },
    },

    // How many items can the player buy at once
    // This limit does not get used for Vendingmachines Owned by the Player
    ItemLimit = {
        ["Default"] = 3, // Dont Remove this
        ["vipinicial"] = 5,
        ["vipgiant"] = 7,
        ["viplegend"] = 9,
        ["vipblackblood"] = 12,
        ["superadmin"] = 3
    },

    // Lockpick Feature
    LockPick = {
        // Can Private Vendingmachines be lockpicked to get the money?
        Enabled = true,

        // How long does it take to lockpick a vendingmachine
        Time = 3,

        // How much money does the Player get if he successfully lockpicks the vendingmachine?
        // 1 = 100% , 0.5 = 50% , 0.25 = 25%
        Reward = 1,

        // How many items does the Player get if he successfully lockpicks the vendingmachine? (-1 will disable the item drop)
        // 1 = 100% , 0.5 = 50% , 0.25 = 25%
        Reward_Item = 0.25,

        // The Wanted Message
        Wanted_Message = "Robo de una máquina expendedora!",

        // How long will the player be wanted?
        Wanted_Time = 120,
    },
}

// Here you can pre define names for Classes which get used instead.
zvm.config.PredefinedNames = {
    ["sent_ball"] = "Super Bouncer",
    ["item_healthkit"] = "Health Kit",
    ["item_ammo_357"] = "357 Ammo",
    ["item_ammo_357_large"] = "357 Ammo (Large)",
    ["item_ammo_ar2"] = "AR2 Ammo",
    ["item_ammo_ar2_large"] = "AR2 Ammo (Large)",
    ["item_ammo_ar2_altfire"] = "AR2 Orb",
    ["item_ammo_crossbow"] = "Crossbow Bolts",
    ["item_healthvial"] = "Health Viral",
    ["item_ammo_pistol"] = "Pistol Ammo",
    ["item_ammo_pistol_large"] = "Pistol Ammo (Large)",
    ["item_rpg_round"] = "RPG Round",
    ["item_box_buckshot"] = "Shotgun Ammo",
    ["item_ammo_smg1"] = "SMG Ammo",
    ["item_ammo_smg1_large"] = "SMG Ammo (Large)",
    ["item_ammo_smg1_grenade"] = "SMG Grenade",
    ["item_battery"] = "Suit Battery",
}

// Here you can pre define Models for certain classes which get used instead.
zvm.config.PredefinedModels = {
    //["entity_class"] = "path/to/model.mdl",
}

zvm.config.Package = {
    // Can only the buyer of the Package open it?
    BuyerOnlyOpen = false,

    // A list of Classes and prefix which should be directly used by the player once the package opens.
    DirectPickup = {

        allowed = {
            "weapon_",
        },

        // This entity classes should not be used when the player opens the package
        banned = {"weapon_striderbuster"}
    },
}
