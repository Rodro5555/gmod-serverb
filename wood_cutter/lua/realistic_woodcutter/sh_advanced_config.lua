-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

--[[
 _____           _ _     _   _          _    _                 _            _   _            
| ___ \         | (_)   | | (_)        | |  | |               | |          | | | |           
| |_/ /___  __ _| |_ ___| |_ _  ___    | |  | | ___   ___   __| | ___ _   _| |_| |_ ___ _ __ 
|    // _ \/ _` | | / __| __| |/ __|   | |/\| |/ _ \ / _ \ / _` |/ __| | | | __| __/ _ \ '__|
| |\ \  __/ (_| | | \__ \ |_| | (__    \  /\  / (_) | (_) | (_| | (__| |_| | |_| ||  __/ |   
\_| \_\___|\__,_|_|_|___/\__|_|\___|    \/  \/ \___/ \___/ \__,_|\___|\__,_|\__|\__\___|_|   

]]

-------------------------------------------------------------------------------------------------------------------
---------------------------------------- Configuration Entities ---------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
Realistic_Woodcutter.BaseVehicle = Realistic_Woodcutter.BaseVehicle or {}

Realistic_Woodcutter.Entities = {
    ["realistic_woodcutter_debarker_machine"] = true,
    ["realistic_woodcutter_npccardealer"] = true,
    ["realistic_woodcutter_sawmill_machine"] = true,
    ["realistic_woodcutter_npc"] = true,
    ["realistic_woodcutter_splitter_machine"] = true,
    ["realistic_woodcutter_stumps"] = true,
    ["realistic_woodcutter_maintree"] = true,
}

Realistic_Woodcutter.Optimisation = {
	["realistic_woodcutter_demi_log"] = false,
	["realistic_woodcutter_log"] = false,
	["realistic_woodcutter_plank"] = false,
	["realistic_woodcutter_quart_log"] = false,
	["realistic_woodcutter_small_log"] = false,
}

Realistic_Woodcutter.swep = {
    [1] = "rwc_swep_log",
    [2] = "rwc_swep_small_log",
	[3] = "rwc_swep_log_demi_split",
    [4] = "rwc_swep_log_quart_split",
	[5] = "rwc_swep_plank",
}

Realistic_Woodcutter.SwepList = {
	["rwc_swep_log"] = true,
	["rwc_swep_small_log"] = true,
	["rwc_swep_log_demi_split"] = true,
	["rwc_swep_log_quart_split"] = true,
	["rwc_swep_plank"] = true,
}

-------------------------------------------------------------------------------------------------------------------
---------------------------------------- Configuration SetupVehc --------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

Realistic_Woodcutter.SetupVehc = {}

Realistic_Woodcutter.SetupVehc[1] = {
	["model"] = "models/props_rwc/rwc_tree_trunk.mdl",
}
Realistic_Woodcutter.SetupVehc[2] = {
	["model"] = "models/props_rwc/rwc_small_log.mdl",
}
Realistic_Woodcutter.SetupVehc[3] = {
	["model"] = "models/props_rwc/rwc_split_log_demi.mdl",
}
Realistic_Woodcutter.SetupVehc[4] = {
	["model"] = "models/props_rwc/rwc_split_log_quart.mdl",
}
Realistic_Woodcutter.SetupVehc[5] = {
	["model"] = "models/props_rwc/rwc_plank.mdl",
}

-------------------------------------------------------------------------------------------------------------------
---------------------------------------- Configuration InfosMenu --------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

Realistic_Woodcutter.InfosMenu = {}

Realistic_Woodcutter.InfosMenu[1] = { 
	["model"] = "materials/rwc_image/rwc_imageinfos_10.png",
	["text"] = Realistic_Woodcutter.GetSentence("takeJobNPCTutorial"),	
}

Realistic_Woodcutter.InfosMenu[2] = { 
	["model"] = "materials/rwc_image/rwc_imageinfos_1.png",
	["text"] = Realistic_Woodcutter.GetSentence("vehicleLocation"),	
}

Realistic_Woodcutter.InfosMenu[3] = { 
	["model"] = "materials/rwc_image/rwc_imageinfos_3.png",
	["text"] = Realistic_Woodcutter.GetSentence("cutterTutorial"),	
}

Realistic_Woodcutter.InfosMenu[4] = { 
	["model"] = "materials/rwc_image/rwc_imageinfos_4.png",
	["text"] = Realistic_Woodcutter.GetSentence("cuttingTutorial"),	
}

Realistic_Woodcutter.InfosMenu[5] = { 
	["model"] = "materials/rwc_image/rwc_imageinfos_5.png",
	["text"] = Realistic_Woodcutter.GetSentence("treatLogsTutorial"),	
}

Realistic_Woodcutter.InfosMenu[6] = { -- Choice 
	["model"] = "materials/rwc_image/rwc_imageinfos_6.png",
	["text"] = Realistic_Woodcutter.GetSentence("fabricationTutorial"),		
}

Realistic_Woodcutter.InfosMenu[7] = { 
	["model"] = "materials/rwc_image/rwc_imageinfos_7.png",
	["text"] = Realistic_Woodcutter.GetSentence("barkMachineTutorial"),		
}

Realistic_Woodcutter.InfosMenu[8] = { 
	["model"] = "materials/rwc_image/rwc_imageinfos_8.png",
	["text"] = Realistic_Woodcutter.GetSentence("cutMachineTutorial"),		
}

Realistic_Woodcutter.InfosMenu[9] = { 
	["model"] = "materials/rwc_image/rwc_imageinfos_9.png",
	["text"] = Realistic_Woodcutter.GetSentence("fillTrunkTutorial"),		
}

Realistic_Woodcutter.InfosMenu[10] = { 
	["model"] = "materials/rwc_image/rwc_imageinfos_10.png",
	["text"] = Realistic_Woodcutter.GetSentence("sellMerchandiseTutorial"),		
}

Realistic_Woodcutter.InfosMenu[11] = { 
	["model"] = "materials/rwc_image/rwc_imageinfos_8.png",
	["text"] = Realistic_Woodcutter.GetSentence("sawmillTutorial"),		
}

Realistic_Woodcutter.InfosMenu[12] = { 
	["model"] = "materials/rwc_image/rwc_imageinfos_12.png",
	["text"] = Realistic_Woodcutter.GetSentence("splitterMachineTutorial"),		
}

Realistic_Woodcutter.InfosMenu[13] = { 
	["model"] = "materials/rwc_image/rwc_imageinfos_13.png",
	["text"] = Realistic_Woodcutter.GetSentence("fillTrunkTutorial"),		
}

Realistic_Woodcutter.InfosMenu[14] = { 
	["model"] = "materials/rwc_image/rwc_imageinfos_10.png",
	["text"] = Realistic_Woodcutter.GetSentence("sellMerchandiseTutorial"),		
}

-------------------------------------------------------------------------------------------------------------------
---------------------------------------- Configuration PnjSeller --------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

Realistic_Woodcutter.PnjSeller = {}

Realistic_Woodcutter.PnjSeller[1] = {
	["model"] = "models/props_rwc/rwc_axe.mdl", 
	["price"] = Realistic_Woodcutter.Take_Axe_Price 
}

Realistic_Woodcutter.PnjSeller[2] = {
	["model"] = "models/weapons/tfa_nmrih/w_me_chainsaw.mdl", 
	["price"] = Realistic_Woodcutter.PriceChainSaw
}

-------------------------------------------------------------------------------------------------------------------
----------------------------------------- Configuration Ents ------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

Realistic_Woodcutter.ToolsEnts = {}

Realistic_Woodcutter.ToolsEnts[1] = {
	["rwc_model"] = "models/props_rwc/rwc_tree.mdl",
	["rwc_ent"] = "realistic_woodcutter_stumps"
}


Realistic_Woodcutter.ToolsEnts[2] = {
	["rwc_model"] = "models/wasted/wasted_kobralost_machineb.mdl",
	["rwc_ent"] = "realistic_woodcutter_debarker_machine"

}

Realistic_Woodcutter.ToolsEnts[3] = {
	["rwc_model"] = "models/props_rwc/rwc_splitter_machine.mdl",
	["rwc_ent"] = "realistic_woodcutter_splitter_machine"

}

Realistic_Woodcutter.ToolsEnts[4] = {
	["rwc_model"] = "models/props_rwc/rwc_sawmill_machine.mdl",
	["rwc_ent"] = "realistic_woodcutter_sawmill_machine"

}

Realistic_Woodcutter.ToolsEnts[5] = {
	["rwc_model"] = "models/breen.mdl",
	["rwc_ent"] = "realistic_woodcutter_npc"

}

Realistic_Woodcutter.ToolsEnts[6] = {
	["rwc_model"] = "models/breen.mdl",
	["rwc_ent"] = "realistic_woodcutter_npccardealer"

}

-------------------------------------------------------------------------------------------------------------------
---------------------------------------- Configuration Trunk ------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------


Realistic_Woodcutter.BaseVehicle["models/tdmcars/gmc_syclone.mdl"] = {
	["ModelVehicle"] = "models/tdmcars/gmc_syclone.mdl",
	["Log"] = {
		{
			["AngleEnt"] = Angle(4.5948,2.2741,-60.765),
			["PosEnt"] =  Vector(-17.1582 ,-49.4312, 73.3841),
		},
		{
			["AngleEnt"] = Angle(-4.681 ,-2.8996 ,-61.4217),
			["PosEnt"] = Vector(12.2437, -51.4351 ,72.8893),
		},
		{
			["AngleEnt"] = Angle(6.0189 ,2.5568, -61.1111),
			["PosEnt"] = Vector(-3.0901 ,-61.1284 ,96.5004),
		}
	},
	["SmallLog"] = {
		{
			["AngleEnt"] = Angle(-0.0524, 147.2352, 0.5162),
			["PosEnt"] = Vector(-13.1736 ,-34.2373 ,32.1253),
		},
		{
			["AngleEnt"] = Angle(-0.0247 ,83.2728, 0.2703),
			["PosEnt"] = Vector(16.3433 ,-34.4468 ,32.036),
		},
		{
			["AngleEnt"] = Angle(0.0222 ,92.7553 ,0.1145),
			["PosEnt"] = Vector(-12.1616 ,-63.542 ,32.1318),
		},
		{
			["AngleEnt"] = Angle(3.5035,92.0315 ,1.0231),
			["PosEnt"] = Vector(-13.8123, -95.6812, 33.9828),
		},
		{
			["AngleEnt"] = Angle(0.0002 ,90.4618, 0.0001),
			["PosEnt"] = Vector(16.1118 ,-93.6821, 33.1081),
		},
		{
			["AngleEnt"] = Angle(0.3002 ,-30.3478, 0.2161),
			["PosEnt"] = Vector(17.3157, -63.9233 ,32.209),
		}
	},
	["DemiLog"] = {
		{
			["AngleEnt"] = Angle(-2.7131, 177.122, 50.6883),
			["PosEnt"] = Vector(12.8093 ,-43.8623 ,32.0823),
		},
		{
			["AngleEnt"] = Angle(-4.2889, -174.7092, 48.8172),
			["PosEnt"] = Vector(14.0669 ,-64.022, 32.3592),
		},
		{
			["AngleEnt"] = Angle(-1.8102 ,179.4004, 49.299),
			["PosEnt"] = Vector(-16.6067 ,-42.8262, 32.1289),
		},
		{
			["AngleEnt"] = Angle(-2.6793, 179.6159 ,48.1499),
			["PosEnt"] = Vector(-21.145 ,-63.3823 ,32.0549),
		},
		{
			["AngleEnt"] = Angle(-3.7561, -172.5004 ,48.8996),
			["PosEnt"] = Vector(19.6655 ,-84.2505 ,32.2603),
		},
		{
			["AngleEnt"] = Angle(1.1934 ,-175.1885 ,48.0535),
			["PosEnt"] = Vector(-18.9187 ,-82.9814 ,32.8041),
		}
	},
	["PlatePos"] = Vector(47.6436 ,-74.3228, 52.6785),
	["Class"] = "prop_vehicle_jeep",
	["PlateAngle"] = Angle(90 ,-180, 0),
	["QuartLog"] = {
		{
			["AngleEnt"] = Angle(-88.6762 ,-61.4531 ,151.4698),
			["PosEnt"] = Vector(-22.5806 ,-23.2783, 33.0413)
		},
		{
			["AngleEnt"] = Angle(40.2905 ,172.9212, -89.6066),
			["PosEnt"] = Vector(-3.9834, -21.3789, 47.0056)
		},
		{
			["AngleEnt"] = Angle(-57.9324, -6.9004, 94.4885),
			["PosEnt"] = Vector(32.6666 ,-59.2075, 43.2063)
		},
		{
			["AngleEnt"] = Angle(25.382, 172.4214, -90.0319),
			["PosEnt"] = Vector(15.2168, -24.7886 ,47.3018)
		},
		{
			["AngleEnt"] = Angle(-51.5241, 167.5512 ,98.0766),
			["PosEnt"] = Vector(-18.408 ,-59.1855 ,40.8133)
		},
		{
			["AngleEnt"] = Angle(-1.8013, 173.9547 ,89.1159),
			["PosEnt"] = Vector(20.512 ,-106.0479 ,31.859)
		},
		{
			["AngleEnt"] = Angle(29.8937 ,168.453, -89.9595),
			["PosEnt"] = Vector(2.6038 ,-65.6577 ,47.335)
		},
		{
			["AngleEnt"] = Angle(29.5524, 161.5458, -91.9763),
			["PosEnt"] = Vector(-7.5928 ,-62.4688 ,57.7567)
		},
		{
			["AngleEnt"] = Angle(-85.2475 ,150.8296 ,-58.6334),
			["PosEnt"] = Vector(21.4824 ,-22.166 ,46.6123)
		},
		{
			["AngleEnt"] = Angle(-1.6258 ,-8.6172 ,88.8218),
			["PosEnt"] = Vector(22.5459 ,-21.6719 ,31.7558)
		},
		{
			["AngleEnt"] = Angle(-0.2801, -22.7382 ,88.726),
			["PosEnt"] = Vector(-21.3767 ,-57.3237 ,31.9893)
		},
		{
			["AngleEnt"] = Angle(-41.8141, -10.8039, 92.2395),
			["PosEnt"] = Vector(10.6628, -63.9473 ,38.3764)
		}
	},
	["Plank"] = {
		{
			["AngleEnt"] = Angle(0.0055 ,-90.2336 ,16.8299),
			["PosEnt"] = Vector(12.1948 ,-31.8442, 45.4908)
		},
		{
			["AngleEnt"] = Angle(-0.5553 ,89.9456 ,-19.2459),
			["PosEnt"] = Vector(17.458, -52.2075 ,47.017)
		},
		{
			["AngleEnt"] = Angle(0.6605 ,-87.3315, -161.972),
			["PosEnt"] = Vector(21.6338 ,-37.3955, 53.2743)
		},
		{
			["AngleEnt"] = Angle(-8.4642 ,92.5869, 163.3589),
			["PosEnt"] = Vector(16.6472 ,-95.4741, 49.9971)
		},
		{
			["AngleEnt"] = Angle(-0.303 ,89.8982, -17.0765),
			["PosEnt"] = Vector(13.0273, -72.3325 ,45.7079)
		},
		{
			["AngleEnt"] = Angle(-0.0544 ,89.8428 ,-16.5718),
			["PosEnt"] = Vector(11.1086 ,-92.5396, 45.3182)
		},
		{
			["AngleEnt"] = Angle(1.5915, -91.2137 ,18.0506),
			["PosEnt"] = Vector(14.4551 ,-43.9258, 48.8911)
		},
		{
			["AngleEnt"] = Angle(6.1776 ,-86.0338, 18.588),
			["PosEnt"] = Vector(28.0248 ,-57.8804, 54.6373)
		},
		{
			["AngleEnt"] = Angle(-0.3612, -88.468 ,16.6651),
			["PosEnt"] = Vector(25.5801 ,-79.2012, 51.7034)
		},
		{
			["AngleEnt"] = Angle(0.3419, -90.3834 ,18.5636),
			["PosEnt"] = Vector(18.0911, -42.4302, 54.5733)
		},
		{
			["AngleEnt"] = Angle(-9.7791 ,-88.9912 ,-163.9083),
			["PosEnt"] = Vector(24.8405, -83.6328, 55.4575)
		},
		{
			["AngleEnt"] = Angle(-17.4528, 99.9201 ,-20.2362),
			["PosEnt"] = Vector(22.941, -53.542, 58.1927)
		},
		{
			["AngleEnt"] = Angle(1.353 ,-91.2673, 17.2533),
			["PosEnt"] = Vector(20.5413 ,-71.3843, 56.3194)
		},
	},
}

