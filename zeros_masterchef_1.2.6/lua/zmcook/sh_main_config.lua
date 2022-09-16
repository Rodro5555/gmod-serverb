zmc = zmc or {}
zmc.config = zmc.config or {}

/////////////////////////// Zero´s MasterCook //////////////////////////////

// Developed by ZeroChain:
// http://steamcommunity.com/id/zerochain/
// https://www.gmodstore.com/users/view/76561198013322242
// https://www.artstation.com/zerochain

/////////////////////////////////////////////////////////////////////////////


///////////////////////// zclib Config //////////////////////////////////////
/*
	This config can be used to overwrite the main config of zeros libary
*/

//zclib.config.Debug = true

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



// What language should we display en , fr , ru , ptbr , tr , es , cn , pl , de
zmc.config.SelectedLanguage = "es"

// Disables the 2d3d HUD above the Item / Dish Entities
zmc.config.HideItemHUD = false

// If set to true then players will download the medieval contentpack instead
// NOTE You will still need to add the medieval contentpack to your workshop collection
zmc.config.Medieval = false

// This can be used to delay certain net messages which are send as confirmation for his [SERVER SIDE] action.
zmc.config.NetDelay = 0.1

// Multiply the ingredients price with this value to get the price for the dish
zmc.config.Profit_Multiplier = 100

// Defines how much damage is needed before the entity gets destroyed, set to -1 to disable this
zmc.config.Damageable = {
	["zmc_washtable"] = 200,
	["zmc_worktable"] = 200,
	["zmc_wok"] = 200,
	["zmc_souppot"] = 200,
	["zmc_oven"] = 200,
	["zmc_ordertable"] = 200,
	["zmc_mixer"] = 200,
	["zmc_grill"] = 200,
	["zmc_garbagepin"] = 200,
	["zmc_fridge"] = 200,
	["zmc_dishtable"] = 200,
	["zmc_customertable"] = 200,
	["zmc_boilpot"] = 200,
	["zmc_dish"] = 15,
	["zmc_item"] = 15,
	["zmc_cookbook"] = 50,
}

// This automaticly blacklists the entities from the pocket swep
if GM and GM.Config and GM.Config.PocketBlacklist then
	GM.Config.PocketBlacklist["zmc_worktable"] = true
	GM.Config.PocketBlacklist["zmc_wok"] = true
	GM.Config.PocketBlacklist["zmc_souppot"] = true
	GM.Config.PocketBlacklist["zmc_oven"] = true
	GM.Config.PocketBlacklist["zmc_ordertable"] = true
	GM.Config.PocketBlacklist["zmc_mixer"] = true
	GM.Config.PocketBlacklist["zmc_grill"] = true
	GM.Config.PocketBlacklist["zmc_garbagepin"] = true
	GM.Config.PocketBlacklist["zmc_fridge"] = true
	GM.Config.PocketBlacklist["zmc_dishtable"] = true
	GM.Config.PocketBlacklist["zmc_customertable"] = true
	GM.Config.PocketBlacklist["zmc_boilpot"] = true
	GM.Config.PocketBlacklist["zmc_dish"] = true
	GM.Config.PocketBlacklist["zmc_item"] = true
	GM.Config.PocketBlacklist["zmc_cookbook"] = true
	GM.Config.PocketBlacklist["zmc_washtable"] = true
	GM.Config.PocketBlacklist["zmc_buildkit"] = true
end

// You can use this table to restrict which job is allowed to interact with the kitchen entities. Keep empty to allow everyone.
zmc.config.Jobs = {
	["Cocinero Profesional"] = true,
}

zmc.config.Item = {
	// How many items can the player own at the same time
	Limit = 15,

	// How long after it got spawned will it despawn again, Set to -1 to disable
	DespawnTime = 600,

	// How long till the food is rotten / spoiled, Set to -1 to disable
	// Food only spoils if its not in some inventory
	RotTime = 300,
}

zmc.config.Plates = {
    "models/zerochain/props_kitchen/zmc_plate01.mdl",
    "models/zerochain/props_kitchen/zmc_plate02.mdl",
    "models/zerochain/props_kitchen/zmc_plate03.mdl",
    "models/zerochain/props_kitchen/zmc_plate04.mdl",
    "models/zerochain/props_kitchen/zmc_plate05.mdl",
}

zmc.config.Gastank = {
    // If set to true the the Oven,Grill,Boilpot,Soupot,Wok requiere Gas to work
    enabled = true,

    // This defines how long till the fuel runs out in seconds
    fuel = 600, // 10 minutes of fuel

	CanExplode = true,
}

zmc.config.Grill = {

	// If set to true then objects which are on the grill while in action get ignited
	CanIgniteObjects = true,

    // If the oven is on 100% heat, how much faster will the food grill?
    heat_speed_mul = 2,

    // How often does the quick time event occur?
    qte_interval = 10,

    // How high is the chance for the QuickTimeEvent to occur if the player heats at 100% Temperatur
    qte_chance = 70,

    // How much time does the player have before the food gets destroyed
    qte_respone_time = 3,

    // How many items get destroyed should the player fail the QuickTimeEvent
    qte_fail_loss = 3,
}

// The Ordertable
zmc.config.Order = {

	// If set to true then only admins can change this option in the ordertable
	allow_customer_orders_adminonly = false,

	// If false then everyone can edit the dish whitelist of a ordertable. (This does not apply to ordertable which spawn with the map)
	edit_whitelist_adminonly = false,

    // Defines how close a customer table needs to be to a ordertable to work
    search_dist = 40000, // default 4000

    // How often should we try to spawn a customer (Depending on customer happieness this value will be somewhere between min / max)
	customer_interval = {min = 30,max = 150}, // seconds

    // How much % penality do we reduce the customer rating should the player fail to deliver the dish in time?
    rating_penaltiy_time = 10,

    // How much % reward can the player get per deliverd dish? (This scales by delivery time, so the faster the player is the more % he will get)
    rating_reward_time = 10,

	// How many food orders can the player have active at once
	player_order_limit = 3,
}

zmc.config.SpawnMoney = function(money, pos)
    if DarkRP then
        DarkRP.createMoneyBag(pos, money)
    end
end

zmc.config.CustomerTable = {

	// If set to true then only admins can change the appearance of CustomerTable
	// (This is for tables which are spawned by the player, Customertables which are used as a public entity cant be edited by normal players anyway)
	edit_appearance_adminonly = true,
}

// After the customer finishes his meal the dirty plate will be moved to the washtable where it needs to be cleaned
// If the washtable is full of dirty plates then no more customers will spawn and the player needs to clean some plates first
zmc.config.Washtable = {
	// How many clicks per plate
	progress_count = 3,

	// How many dirty plates fit on the washtable before its full.
	limit = 12,
}

zmc.config.Customers = {
    [1] = "models/player/group01/female_01.mdl",
    [2] = "models/player/group01/female_02.mdl",
    [3] = "models/player/group01/female_03.mdl",
    [4] = "models/player/group01/female_04.mdl",
    [5] = "models/player/group01/female_05.mdl",
    [6] = "models/player/group01/female_06.mdl",
    [7] = "models/player/group01/male_01.mdl",
    [8] = "models/player/group01/male_02.mdl",
    [9] = "models/player/group01/male_03.mdl",
    [10] = "models/player/group01/male_04.mdl",
    [11] = "models/player/group01/male_05.mdl",
    [12] = "models/player/group01/male_06.mdl",
    [13] = "models/player/group01/male_07.mdl",
    [14] = "models/player/group01/male_08.mdl",
    [15] = "models/player/group01/male_09.mdl",

    [16] = "models/player/mossman.mdl",
    [17] = "models/player/alyx.mdl",
    [18] = "models/player/barney.mdl",
    [19] = "models/player/breen.mdl",
    [20] = "models/player/eli.mdl",
    [21] = "models/player/gman_high.mdl",
    [22] = "models/player/kleiner.mdl",
    [23] = "models/player/monk.mdl",
    [24] = "models/player/odessa.mdl",

    [25] = "models/player/combine_soldier.mdl",
    [26] = "models/player/combine_soldier_prisonguard.mdl",
    [27] = "models/player/combine_super_soldier.mdl",
    [28] = "models/player/police.mdl",
    [29] = "models/player/police_fem.mdl",
    [30] = "models/player/magnusson.mdl",
}


zmc.config.Buildkit = {

	// How much money does the player get back when removing a machine? (This also gets used when a tent gets deconstructed and all machines inside get removed)
	Refund = 0.5, // 1 = 100%, 0.5 = 50%
}


// The seat config defines the model of seats and their offset to the center of the model, should the model have some weird root bone position
zmc.config.Seats = {}
local function AddSeat(mdl, offset, sitpos, ang_offset, sitang)
    table.insert(zmc.config.Seats, {
        mdl = mdl,
        offset = offset,
        sitpos = sitpos,
        ang_offset = ang_offset,
        sitang = sitang or angle_zero
    })
end
AddSeat("models/zerochain/props_kitchen/zmc_seat.mdl",Vector(0,0,-23),Vector(0,0,2),nil,angle_zero)
AddSeat("models/props_c17/chair02a.mdl",Vector(4.8,-25,-9),Vector(0,-6,-3))
AddSeat("models/chairs/armchair.mdl",Vector(0,-5,-36),vector_origin)
AddSeat("models/props_c17/FurnitureChair001a.mdl",vector_origin,Vector(0,0,-5))
AddSeat("models/props_combine/breenchair.mdl",Vector(0,-6,-23),Vector(0,0,-5))
AddSeat("models/props_interiors/Furniture_chair01a.mdl",Vector(0,-2,-3),Vector(0,0,-3))
AddSeat("models/props_interiors/Furniture_chair03a.mdl",Vector(0,-3,-3),Vector(0,-2,0))
AddSeat("models/props_interiors/Furniture_Couch02a.mdl",Vector(0,-10,-2),Vector(0,-5,-9))
AddSeat("models/props_wasteland/controlroom_chair001a.mdl",Vector(0,-8,-3.9),Vector(0,0,-5))
AddSeat("models/props_c17/chair_office01a.mdl",Vector(5,0,-23.3),vector_origin,Angle(0,-90,0))
AddSeat("models/props_c17/chair_stool01a.mdl",Vector(0,-5,-25.5),Vector(0,-6,12))





zmc.config.Tables = {}
local function AddTable(data) return table.insert(zmc.config.Tables,data) end

AddTable({
    // Model of the table
    mdl = "models/zerochain/props_kitchen/zmc_table.mdl",
    // The local positions for the customer and dinner plate
    positions = {
        [1] = { seat = {pos = Vector(0,30,22.5),ang = Angle(0,-90,0)}, plate = {pos = Vector(0,18,39.4),ang = angle_zero}},
        [2] = { seat = {pos = Vector(30,0,22.5),ang = Angle(0,180,0)}, plate = {pos = Vector(18,0,39.4),ang = angle_zero}},
        [3] = { seat = {pos = Vector(0,-30,22.5),ang = Angle(0,90,0)}, plate = {pos = Vector(0,-18,39.4),ang = angle_zero}},
        [4] = { seat = {pos = Vector(-30,0,22.5),ang = angle_zero}, plate = {pos = Vector(-18,0,39.4),ang = angle_zero}},
    }
})

AddTable({
    mdl = "models/props_c17/FurnitureTable001a.mdl",
    positions = {
        [1] = { seat = {pos = Vector(0,30,5),ang = Angle(0,-90,0)}, plate = {pos = Vector(0,15,18),ang = angle_zero}},
        [2] = { seat = {pos = Vector(30,0,5),ang = Angle(0,180,0)}, plate = {pos = Vector(15,0,18),ang = angle_zero}},
        [3] = { seat = {pos = Vector(0,-30,5),ang = Angle(0,90,0)}, plate = {pos = Vector(0,-15,18),ang = angle_zero}},
        [4] = { seat = {pos = Vector(-30,0,5),ang = angle_zero}, plate = {pos = Vector(-15,0,18),ang = angle_zero}},
    }
})

AddTable({
    mdl = "models/props_c17/furnituretable002a.mdl",
    positions = {
        [1] = { seat = {pos = Vector(0,40,5),ang = Angle(0,-90,0)}, plate = {pos = Vector(0,25,18),ang = angle_zero}},
        [2] = { seat = {pos = Vector(25,0,5),ang = Angle(0,180,0)}, plate = {pos = Vector(12,0,18),ang = angle_zero}},
        [3] = { seat = {pos = Vector(0,-40,5),ang = Angle(0,90,0)}, plate = {pos = Vector(0,-25,18),ang = angle_zero}},
        [4] = { seat = {pos = Vector(-25,0,5),ang = angle_zero}, plate = {pos = Vector(-12,0,18),ang = angle_zero}},
    }
})

AddTable({
    mdl = "models/props_wasteland/cafeteria_table001a.mdl",
    positions = {
        [1] = { seat = {pos = Vector(0,65,8),ang = Angle(0,-90,0)}, plate = {pos = Vector(0,55,15),ang = angle_zero}},

        [2] = { seat = {pos = Vector(25,35,8),ang = Angle(0,180,0)}, plate = {pos = Vector(11,35,15),ang = angle_zero}},
        [3] = { seat = {pos = Vector(25,12,8),ang = Angle(0,180,0)}, plate = {pos = Vector(11,12,15),ang = angle_zero}},
        [4] = { seat = {pos = Vector(25,-12,8),ang = Angle(0,180,0)}, plate = {pos = Vector(11,-12,15),ang = angle_zero}},
        [5] = { seat = {pos = Vector(25,-35,8),ang = Angle(0,180,0)}, plate = {pos = Vector(11,-35,15),ang = angle_zero}},

        [6] = { seat = {pos = Vector(0,-65,8),ang = Angle(0,90,0)}, plate = {pos = Vector(0,-55,15),ang = angle_zero}},

        [7] = { seat = {pos = Vector(-25,35,8),ang = angle_zero}, plate = {pos = Vector(-11,35,15),ang = angle_zero}},
        [8] = { seat = {pos = Vector(-25,12,8),ang = angle_zero}, plate = {pos = Vector(-11,12,15),ang = angle_zero}},
        [9] = { seat = {pos = Vector(-25,-12,8),ang = angle_zero}, plate = {pos = Vector(-11,-12,15),ang = angle_zero}},
        [10] = { seat = {pos = Vector(-25,-35,8),ang = angle_zero}, plate = {pos = Vector(-11,-35,15),ang = angle_zero}},
    }
})

AddTable({
    mdl = "models/squad/sf_plates/sf_plate1x1.mdl",
    positions = {
        [1] = { seat = {pos = Vector(5.5,5,5),ang = Angle(0,-90,0)}, plate = {pos = Vector(5.5,-15,14),ang = angle_zero}},
    }
})





////////////// SH ACCESSORY
if SH_ACC then
    if CLIENT then
        SH_ACC:DefineOffsetEasy("models/zerochain/props_kitchen/zmc_hat01.mdl", "ValveBiped.Bip01_Head1", Vector(3.6, 0, 0), Angle(-90, 23.3, 0))
    end
    SH_ACC:AddAccessory("zmc_hat01", {name = "Cooking Hat01", price = 5000, slot = SH_SLOT_HEAD, mdl = "models/zerochain/props_kitchen/zmc_hat01.mdl",scale = 0.82})

	if CLIENT then
        SH_ACC:DefineOffsetEasy("models/zerochain/props_kitchen/zmc_hat02.mdl", "ValveBiped.Bip01_Head1", Vector(4, 0, 0), Angle(-90, 30, 0))
    end
    SH_ACC:AddAccessory("zmc_hat02", {name = "Cooking Hat02", price = 5000, slot = SH_SLOT_HEAD, mdl = "models/zerochain/props_kitchen/zmc_hat02.mdl",scale = 0.85})

	if CLIENT then
        SH_ACC:DefineOffsetEasy("models/zerochain/props_kitchen/zmc_hat03.mdl", "ValveBiped.Bip01_Head1", Vector(4, 0, 0), Angle(0, 117, 90))
    end
    SH_ACC:AddAccessory("zmc_hat03", {name = "Cooking Hat03", price = 5000, slot = SH_SLOT_HEAD, mdl = "models/zerochain/props_kitchen/zmc_hat03.mdl",scale = 0.86})
end

////////////// AAS ACCESSORY
if AAS and SERVER then
	AAS.AddItem({
		["scale"] = Vector(0.6875, 0.53125, 0.875),
		["options"] = {
			["new"] = false,
			["activate"] = true,
			["iconPos"] = Vector(0, 0, 0),
			["color"] = Color(240, 240, 240, 255),
			["iconFov"] = 0,
			["vip"] = false,
			["bone"] = "ValveBiped.Bip01_Head1",
			["skin"] = "0"
		},
		["uniqueId"] = 96,
		["model"] = "models/zerochain/props_kitchen/zmc_hat01.mdl",
		["pos"] = Vector(4.875, 0, 0),
		["category"] = "Hat",
		["job"] = {},
		["ang"] = Angle(-54.375, 0, -89.59400177002),
		["price"] = 200000,
		["name"] = "Sombrero de cocina",
		["description"] = "¿Siempre has querido ser chef?"
	}, nil, false, true)

	AAS.AddItem({
		["scale"] = Vector(0.78125, 0.59375, 1),
		["options"] = {
			["new"] = false,
			["activate"] = true,
			["iconPos"] = Vector(0, 0, 0),
			["color"] = Color(240, 240, 240, 255),
			["iconFov"] = 0,
			["vip"] = false,
			["bone"] = "ValveBiped.Bip01_Head1",
			["skin"] = "0"
		},
		["uniqueId"] = 97,
		["model"] = "models/zerochain/props_kitchen/zmc_hat02.mdl",
		["pos"] = Vector(5.375, 0, 0),
		["category"] = "Hat",
		["job"] = {},
		["ang"] = Angle(-69.561996459961, 0, -89.59400177002),
		["price"] = 200000,
		["name"] = "Sombrero de cocina",
		["description"] = "¿Siempre has querido ser chef?"
	}, nil, false, true)

	AAS.AddItem({
		["scale"] = Vector(0.8125, 0.625, 1),
		["options"] = {
			["new"] = false,
			["activate"] = true,
			["iconPos"] = Vector(0, 0, 0),
			["color"] = Color(240, 240, 240, 255),
			["iconFov"] = 0,
			["vip"] = false,
			["bone"] = "ValveBiped.Bip01_Head1",
			["skin"] = "0"
		},
		["uniqueId"] = 98,
		["model"] = "models/zerochain/props_kitchen/zmc_hat03.mdl",
		["pos"] = Vector(5.09375, 0, 0),
		["category"] = "Hat",
		["job"] = {},
		["ang"] = Angle(-70.15599822998, 0, -89.75),
		["price"] = 200000,
		["name"] = "Sombrero de cocina",
		["description"] = "¿Siempre has querido ser chef?"
	}, nil, false, true)
end
