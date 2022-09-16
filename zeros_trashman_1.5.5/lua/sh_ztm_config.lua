ztm = ztm or {}
ztm.config = ztm.config or {}

/////////////////////////// Zeros Trashman /////////////////////////////

// Developed by ZeroChain:
// http://steamcommunity.com/id/zerochain/
// https://www.gmodstore.com/users/view/76561198013322242

/////////////////////////////////////////////////////////////////////////////

///////////////////////// zclib Config //////////////////////////////////////
/*
	This config can be used to overwrite the main config of zeros libary
*/

// The Currency
zclib.config.Currency = "$"

// Should the Currency symbol be in front or after the money value?
zclib.config.CurrencyInvert = true

// These Ranks are admins
// If xAdmin, sAdmin or SAM is installed then this table can be ignored
zclib.config.AdminRanks = {
	["superadmin"] = true
}

//zclib.config.CleanUp.SkipOnTeamChange[TEAM_STAFF] = true
/////////////////////////////////////////////////////////////////////////////


// Switches between FastDl and Workshop
ztm.config.FastDl = false

// The language , en , de , cn , ru , fr , es , pl , dk , tr
ztm.config.SelectedLanguage = "es"

// Unit of weight
ztm.config.UoW = "kg"

// This function will spawn the money
ztm.config.MoneySpawn = function(pos, money , ply)

	// Give the player the money directly
	/*
	if IsValid(ply) then
		zclib.Money.Give(ply, money)
		zclib.Notify(ply, "+" .. zclib.Money.Display(money), 0)
		zclib.NetEvent.Create("zclib_sell", {ply:GetPos()})
	end
	*/
    // The default DarkRP way to spawn money
    return DarkRP.createMoneyBag(pos, money)
end

/*
	Because people asked, thats how you could allow players to pickup trashbags / recycledblocks via USE
*/
if SERVER then
	local AllowedClass = {
		[ "ztm_trashbag" ] = true,
		[ "ztm_recycled_block" ] = true,
		[ "ztm_trash" ] = true,
	}
	hook.Add("KeyPress", "ztm_custom_pickup", function(ply, key)
		if key == IN_USE then
			local tr = ply:GetEyeTrace()

			if tr and tr.Hit and IsValid(tr.Entity) and AllowedClass[ tr.Entity:GetClass() ] and not tr.Entity:IsPlayerHolding() then
				// Enable physics
				local phys = tr.Entity:GetPhysicsObject()
				if IsValid(phys) then
					phys:Wake()
					phys:EnableMotion(true)
				end

				// We need to delay the pickup action for one frame because reasons
				timer.Simple(0,function()
					if IsValid(ply) and IsValid(tr.Entity) then
						ply:PickupObject(tr.Entity)
					end
				end)
			end
		end
	end)
end

// Those jobs will be regonized as trashmans
ztm.config.Jobs = {}
// If the job gets not fully removed then atleast now it wont break the script anymore :I
if TEAM_ZTM_TRASHMAN then ztm.config.Jobs[TEAM_ZTM_TRASHMAN] = true end


// Here you can define what entities are considered trash
ztm.config.TrashClass = {
    ["money_printer"] = {
        // How much trash are we getting from this trashclass?
        Trash = function(ply,ent)
            return 10
        end,

        // Can we collect this trashclass?
        CanCollect = function(ply,ent)
            return true
        end,

        // What should happen when we collect this trashclass
        OnCollect = function(ply,ent)
            ztm.TrashCollector.XP(ply,5)
        end,
    },
    ["spawned_shipment"] = {
        Trash = function(ply,ent)
            return 25
        end,
        CanCollect = function(ply,ent)
            return true
        end,
        OnCollect = function(ply,ent)
            ztm.TrashCollector.XP(ply,5)
        end,
    },
    ["spawned_weapon"] = {
        Trash = function(ply,ent)
            return 5
        end,
        CanCollect = function(ply,ent)
            return true
        end,
        OnCollect = function(ply,ent)
        end,
    },
    ["spawned_money"] = {
        Trash = function(ply,ent)
            return 1
        end,
        CanCollect = function(ply,ent)
            return true
        end,
        OnCollect = function(ply,ent)
        end,
    },
    ["spawned_food"] = {
        Trash = function(ply,ent)
            return 5
        end,
        CanCollect = function(ply,ent)
            return true
        end,
        OnCollect = function(ply,ent)
        end,
    },
    ["spawned_ammo"] = {
        Trash = function(ply,ent)
            return 5
        end,
        CanCollect = function(ply,ent)
            return true
        end,
        OnCollect = function(ply,ent)
        end,
    },
    ["zbl_corpse"] = {
        Trash = function(ply,ent)
            return 50
        end,
        CanCollect = function(ply,ent)
            return true
        end,
        OnCollect = function(ply,ent)
            ztm.TrashCollector.XP(ply,5)
        end,
    },
}

// How much damage is needed to destroy the entity, Change it -1 to disable it
ztm.config.Damageable = {
    ["ztm_trashbag"] = 100,
}

// General Trash config
ztm.config.Trash = {
    // Custom Spawn Points can be created with the Trash Spawner Toolgun
    spawn = {
        // Do we want to spawn trash using custom spawn points?
        enabled = true,

        // How often should we try to spawn new trash?
        time = 15, // seconds

        // How many trash entities are allowed to exist on the map at the same time?
        count = 10,

        // The max amount of trash a trash entitiy can have
        trash_max = 30, // kg

        // The min amount of trash a trash entitiy can have
        trash_min = 15, // kg
    },

    // How long does the trash entity has to be idle before it gets removed
    cleanup_time = 120,

    // These models will be used as trash models
    models = {
        "models/zerochain/props_trashman/ztm_trash_apple.mdl",
        "models/zerochain/props_trashman/ztm_trash_box01.mdl",
        "models/zerochain/props_trashman/ztm_trash_box02.mdl",
        "models/zerochain/props_trashman/ztm_trash_can01.mdl",
        "models/zerochain/props_trashman/ztm_trash_can02.mdl",
        "models/zerochain/props_trashman/ztm_trash_cap01.mdl",
        "models/zerochain/props_trashman/ztm_trash_fish.mdl",
        "models/zerochain/props_trashman/ztm_trash_paper.mdl",

        "models/props_junk/garbage_bag001a.mdl",
        "models/props_junk/garbage_milkcarton001a.mdl",
        "models/props_junk/garbage_milkcarton002a.mdl",
        "models/props_junk/garbage_newspaper001a.mdl",
        "models/props_junk/garbage_plasticbottle001a.mdl",
        "models/props_junk/garbage_plasticbottle002a.mdl",
        "models/props_junk/garbage_plasticbottle003a.mdl",
        "models/props_junk/metal_paintcan001a.mdl",
        "models/props_junk/garbage_metalcan001a.mdl",
        "models/props_junk/garbage_metalcan002a.mdl",
        "models/props_junk/Shoe001a.mdl",
        "models/props_lab/box01a.mdl"
    }
}

// Makes players a source of trash
ztm.config.PlayerTrash = {

    // Do we want to make players dirty, which makes them a source of trash? :p
    Enabled = true,

    // How often should we try to make players dirty?
    Interval = 60,

    // How many players can be dirty at the same time?
    Count = 3,

    // How much trash can a player get
    Limit = 50, //kg

    // The max increase amount
    trash_max = 30, // kg

    // The min increase amount
    trash_min = 15, // kg

    // This restrict so that only certain jobs get dirty (Leave empty to disable the job check)
    jobs = {
        //["Gangster"] = true,
    },
}

// World props which can be used as a trash source
ztm.config.TrashCans = {

    // Do we want to use entities on the map with trashcan models to be used as a source of getting trash?
    Enabled = true,

    // How often should the trashcans increase their trash
    Refresh_Interval = 60,

    // How much should the trash increase
    Refresh_Amount = 5,

    // These classes are allowed to be trashcans, just to make sure we dont use any random entity which might have one of the models below
    class = {
        ["prop_dynamic"] = true,
        ["prop_physics"] = true,
    },

    // These models will be searched in the map on server start and used as trashcans where the player can collect trash
    // Note: Models on the map which are prop_static cant be detected
    // You can use ztm_debug_GetModel in the console to check if the model you are looking can be detected via lua and what its model is
    models = {
        ["models/props_lab/scrapyarddumpster_static.mdl"] = 200, // This value defines how much trash the entity can hold
        ["models/props_junk/trashdumpster01a.mdl"] = 100,
        ["models/props_junk/trashbin01a.mdl"] = 50,
        ["models/props_trainstation/trashcan_indoor001a.mdl"] = 30,
        ["models/props_trainstation/trashcan_indoor001b.mdl"] = 30,
    }
}

// Trash source which sometimes reveals trash
ztm.config.Manhole = {
    // The max amount of trash Manhole can have
    max_amount = 100, // kg

    // The min amount of trash Manhole can have
    min_amount = 50, // kg

    // How long til a manhole can have trash again
    cooldown = 60, // seconds

    // The chance of the manhole having trash
    chance = 60, // %
}

// Leafpile which needs to get blown away and may reveal trash
ztm.config.LeafPile = {
    // The max amount of trash a leafpile can have
    trash_max = 30, // kg

    // The min amount of trash a leafpile can have
    trash_min = 15, // kg

    // How many trash entities can a leafpile spawn
    trash_count = 6,

    //How high is the chance that the leafpile actully has trash
    trash_chance = 50, // %


    /////// Spawn ///////

    // How many leaf piles are allowed to be active at once
    refresh_count = 3,

    // How often do we refresh random leafpiles, only if the spawn_count limit isnt reached yet.
    refresh_interval = 120,

    // How long til a leafpile can be used again
    refresh_cooldown = 60
}

ztm.config.Trashbags = {
    // How many trashbags can the player spawn?
    limit = 3,

    // How much trash can a trashbag hold?
    capacity = 100,
}

// The SWEP for collecting trash
ztm.config.TrashSWEP = {

    // Should the player drop any trash he had in the gun when he dies?
    DropTrashOnDeath = true,

    // How much xp does the player gain per kg of trash
    xp_per_kg = 1,

    // Here you can modify the xp a player gets for collecting trash
    xp_modify = function(ply,xp)

        if ply:IsSuperAdmin() then
            xp = xp * 2
        end

        return xp
    end,

    // Do we allow the player to manipulate phys objects with the Blast function of the swep?
    allow_physmanipulation = false,

    // Should the level data be saved on the server?
    data_save = true,

    // How often should we save the level data from the players if it has changed.
    data_save_interval = 100,

    // If set then we only save the data for players with these ranks. Leave empty to save everyones data.
    data_save_whitelist = {
        //["vipinicial"] = true,
        //["vipgiant"] = true,
        //["viplegend"] = true,
        //["vipblackblood"] = true,
    },

    // Here you can add more levels
    level = {
        [1] = {
            next_xp = 1000, // The needed xp to get the next level
            primaty_interval = 3, // The interval for the Air Burst action
            secondary_interval = 0.5, // The trash sucking interval
            inv_cap = 100 // The trash capacity of the swep
        },
        [2] = {
            next_xp = 3000,
            primaty_interval = 2,
            secondary_interval = 0.4,
            inv_cap = 150
        },
        [3] = {
            next_xp = 6000,
            primaty_interval = 1,
            secondary_interval = 0.3,
            inv_cap = 200
        },
        [4] = {
            next_xp = 9000,
            primaty_interval = 0.5,
            secondary_interval = 0.2,
            inv_cap = 250
        },
        [5] = {
            next_xp = 15000,
            primaty_interval = 0.25,
            secondary_interval = 0.1,
            inv_cap = 300
        },
    }
}

// Used to burn trash and earn money
ztm.config.TrashBurner = {

    // How much trash can the burner chamber hold
    burn_load = 1000,

    // How long does it take to burn 1kg of trash
    burn_time = 0.1, // seconds per kg

    // How much money does the player get per kg of trash
    money_per_kg = 10,
}

// Used to recycle trash
ztm.config.Recycler = {

    // How much trash can the recycle chamber hold
    capacity = 1000,

    // These jobs are allowed to use the recycler (Leave empty to disable)
    job_restriction = {
        //["Trashman"] = true,
    },

    // These ranks are allowed to use the recycler (Leave empty to disable)
    rank_restriction = {
        //["vipinicial"] = true,
        //["vipgiant"] = true,
        //["viplegend"] = true,
        //["vipblackblood"] = true,
        //["superadmin"] = true,
    },

    // Here you can add more recycle types
    recycle_types = {
        [1] = {
            // Name of the Recycled Ressource
            name = "Paper",

            // How much trash will be need to make one block of this ressource
            trash_per_block = 100, //kg

            // How long does it take to recycle the trash to this ressource
            recycle_time = 10,

             // The money the player gets for one block of this ressouce
            money = 800,

            // The material which gets used on the Recycled Ressource model
            mat = "zerochain/props_trashman/recycleblock/ztm_recycledblock_paper_diff",

            // These Ranks are allowed to use this recycle type (Leave empty to disable)
            ranks = {
                //["superadmin"] = true,
            }
        },
        [2] = {
            name = "Aluminium",
            trash_per_block = 200,
            recycle_time = 30,
            money = 2000,
            mat = "zerochain/props_trashman/recycleblock/ztm_recycledblock_aluminium_diff",
            ranks = {}
        },
        [3] = {
            name = "Plastic",
            trash_per_block = 300,
            recycle_time = 60,
            money = 4000,
            mat = "zerochain/props_trashman/recycleblock/ztm_recycledblock_plastic_diff",
            ranks = {}
        },
        [4] = {
            name = "Glass",
            trash_per_block = 400,
            recycle_time = 100,
            money = 6000,
            mat = "zerochain/props_trashman/recycleblock/ztm_recycledblock_glass_diff",
            ranks = {}
        },

        [5] = {
            name = "Precious Metals",
            trash_per_block = 700,
            recycle_time = 240,
            money = 15000,
            mat = "zerochain/props_trashman/recycleblock/ztm_recycledblock_metal_diff",
            ranks = {}
        },
    }
}

// The machine which buys recycled trash blocks
ztm.config.Buyermachine = {

    // Do we want to use the dynamic buy rate which modifys the Price for recycled trash blocks for each machine indivdiualy
    DynamicBuyRate = false,

    // The maximal buy rate in % (Set to 100 for now no price change)
    MaxBuyRate = 125,

    // The minimal buy rate in % (Set to 100 for now no price change)
    MinBuyRate = 95,

    // The interval at which the sell price changes in second
    RefreshRate = 600,
}
