--[[
 _____            _ _     _   _        _____      _ _             _____           _                 
|  __ \          | (_)   | | (_)      |  __ \    | (_)           / ____|         | |                
| |__) |___  __ _| |_ ___| |_ _  ___  | |__) |__ | |_  ___ ___  | (___  _   _ ___| |_ ___ _ __ ___  
|  _  // _ \/ _` | | / __| __| |/ __| |  ___/ _ \| | |/ __/ _ \  \___ \| | | / __| __/ _ \ '_ ` _ \ 
| | \ \  __/ (_| | | \__ \ |_| | (__  | |  | (_) | | | (_|  __/  ____) | |_| \__ \ ||  __/ | | | | |
|_|  \_\___|\__,_|_|_|___/\__|_|\___| |_|   \___/|_|_|\___\___| |_____/ \__, |___/\__\___|_| |_| |_|
                                                                                                                                         
--]]

Realistic_Police.ManipulateBoneCuffed = {
	["ValveBiped.Bip01_R_UpperArm"] = Angle(-28,18,-21),
	["ValveBiped.Bip01_L_Hand"] = Angle(0,0,119),
	["ValveBiped.Bip01_L_Forearm"] = Angle(22.5,20,40),
	["ValveBiped.Bip01_L_UpperArm"] = Angle(15, 26, 0),
	["ValveBiped.Bip01_R_Forearm"] = Angle(0,47.5,0),
	["ValveBiped.Bip01_R_Hand"] = Angle(45,34,-15),
	["ValveBiped.Bip01_L_Finger01"] = Angle(0,50,0),
	["ValveBiped.Bip01_R_Finger0"] = Angle(10,2,0),
	["ValveBiped.Bip01_R_Finger1"] = Angle(-10,0,0),
	["ValveBiped.Bip01_R_Finger11"] = Angle(0,-40,0),
	["ValveBiped.Bip01_R_Finger12"] = Angle(0,-30,0)
}

Realistic_Police.ManipulateBoneSurrender = {
    ["ValveBiped.Bip01_R_UpperArm"] = Angle(60,33,118),
    ["ValveBiped.Bip01_L_Hand"] = Angle(-8,11,90),
    ["ValveBiped.Bip01_L_Forearm"] = Angle(-25,-23,36),
    ["ValveBiped.Bip01_R_Forearm"] = Angle(-22,1,15),
    ["ValveBiped.Bip01_L_UpperArm"] = Angle(-67,-40,2),
    ["ValveBiped.Bip01_R_Hand"] = Angle(30,42,-45),
    ["ValveBiped.Bip01_L_Finger01"] = Angle(0,30,0),
    ["ValveBiped.Bip01_L_Finger1"] = Angle(0,45,0),
    ["ValveBiped.Bip01_L_Finger11"] = Angle(0,45,0),
    ["ValveBiped.Bip01_L_Finger2"] = Angle(0,45,0),
    ["ValveBiped.Bip01_L_Finger21"] = Angle(0,45,0),
    ["ValveBiped.Bip01_L_Finger3"] = Angle(0,45,0),
    ["ValveBiped.Bip01_L_Finger31"] = Angle(0,45,0),
    ["ValveBiped.Bip01_L_Finger4"] = Angle(0,40,0),
    ["ValveBiped.Bip01_L_Finger41"] = Angle(-10,30,0),
    ["ValveBiped.Bip01_R_Finger0"] = Angle(0,-40,0),
    ["ValveBiped.Bip01_R_Finger11"] = Angle(0,50,20),
    ["ValveBiped.Bip01_R_Finger2"] = Angle(10,30,0),
    ["ValveBiped.Bip01_R_Finger21"] = Angle(0,80,0),
    ["ValveBiped.Bip01_R_Finger22"] = Angle(10,40,0),  
    ["ValveBiped.Bip01_R_Finger3"] = Angle(0,30,0),
    ["ValveBiped.Bip01_R_Finger31"] = Angle(0,80,-0),
    ["ValveBiped.Bip01_R_Finger32"] = Angle(0,80,-0),
    ["ValveBiped.Bip01_R_Finger4"] = Angle(0,40,0),
    ["ValveBiped.Bip01_R_Finger41"] = Angle(0,90,-20),
    ["ValveBiped.Bip01_R_Finger42"] = Angle(0,80,-0),
}

Realistic_Police.BaseVehicles = Realistic_Police.BaseVehicles or {} -- All TDM Cars & LW Cars 
Realistic_Police.BaseVehicles = {
    ["models/tdmcars/alfa_stradale.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 717.9905,
            ["PlateSizeH"] = 329.2647,
            ["PlateAngle"] = Angle(0, 0.125, 103.5),
            ["PlateVector"] = Vector(-7.1562, -94.2812, 33.4375)
        }
    },
    ["models/tdmcars/chr_ptcruiser.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 786.3617,
            ["PlateSizeH"] = 416.2717,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-7.75, -103.6875, 25.0625)
        }
    },
    ["models/lonewolfie/nis_skyline_r32.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1029.2994,
            ["PlateSizeH"] = 266.879,
            ["PlateAngle"] = Angle(0, 0, 107.1875),
            ["PlateVector"] = Vector(-10.2812, -109.0312, 25.2812)
        }
    },
    ["models/tdmcars/gtaiv_airtug.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1395.8636,
            ["PlateSizeH"] = 390.8299,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-14.0938, -47.375, 29.0625)
        }
    },
    ["models/lonewolfie/morgan_3wheeler.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 620.0,
            ["PlateSizeH"] = 475.4545,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-6.3125, -74.3125, 26.2188)
        }
    },
    ["models/tdmcars/trailers/dump.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.4062, -237, 73.8438)
        }
    },
    ["models/tdmcars/morg_aeross.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.4688, -100.0625, 28.3438)
        }
    },
    ["models/tdmcars/s5.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 78.9688),
            ["PlateVector"] = Vector(-13.875, -107.4375, 42.5938)
        }
    },
    ["models/lonewolfie/2000gtr_stock.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1082.8025,
            ["PlateSizeH"] = 285.9873,
            ["PlateAngle"] = Angle(0, 0, 100.3125),
            ["PlateVector"] = Vector(-10.7812, -117.3438, 32.7812)
        }
    },
    ["models/tdmcars/audi_r8_spyder.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.625, 81.8125),
            ["PlateVector"] = Vector(-13.3438, -103.4062, 39.2188)
        },
        ["Plate2"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -178.625, 90),
            ["PlateVector"] = Vector(13.75, 109.3125, 30.875)
        }
    },
    ["models/lonewolfie/bently_pmcontinental.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1292.5387,
            ["PlateSizeH"] = 379.5394,
            ["PlateAngle"] = Angle(0.625, 2.0938, 75.9062),
            ["PlateVector"] = Vector(-13.3125, -121.6562, 35.9375)
        }
    },
    ["models/tdmcars/hon_s2000.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 936.3636,
            ["PlateSizeH"] = 491.8182,
            ["PlateAngle"] = Angle(0, 3, 90),
            ["PlateVector"] = Vector(-9.4688, -98.0938, 26.6562)
        }
    },
    ["models/lonewolfie/corvette_c7r.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-13.1875, -107.2812, 26.5)
        }
    },
    ["models/lonewolfie/renault_alpine_zar.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1230.9091,
            ["PlateSizeH"] = 300.9091,
            ["PlateAngle"] = Angle(0, -0.9062, 90),
            ["PlateVector"] = Vector(-9.8438, -109.0938, 23.125)
        }
    },
    ["models/tdmcars/dod_challenger15.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 1, 91.625),
            ["PlateVector"] = Vector(-13.1875, -121.8125, 33.4688)
        }
    },
    ["models/tdmcars/emergency/lex_is300_jamesmay.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1120.1784,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-11.0625, -100, 42.0625)
        }
    },
    ["models/tdmcars/lambo_diablo.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1416.3636,
            ["PlateSizeH"] = 295.4545,
            ["PlateAngle"] = Angle(0, -2, 90),
            ["PlateVector"] = Vector(-13.6562, -106.4688, 32.9688)
        }
    },
    ["models/tdmcars/mit_eclipsegsx.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1307.2727,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 2, 90),
            ["PlateVector"] = Vector(-12.7812, -100.5312, 33.7188)
        }
    },
    ["models/tdmcars/vw_beetleconv.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 854.6412,
            ["PlateSizeH"] = 387.7499,
            ["PlateAngle"] = Angle(0, 0.0312, 70.1562),
            ["PlateVector"] = Vector(-8.5625, -94.75, 26.875)
        }
    },
    ["models/lonewolfie/jaguar_xj220.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 373.8854,
            ["PlateAngle"] = Angle(0, -0.125, 90),
            ["PlateVector"] = Vector(-13.5, -119.8125, 24.0625)
        }
    },
    ["models/tdmcars/lam_gallardospyd.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1252.7273,
            ["PlateSizeH"] = 295.4545,
            ["PlateAngle"] = Angle(0, 3, 90),
            ["PlateVector"] = Vector(-11.375, -108.1562, 24.0938)
        }
    },
    ["models/tdmcars/hsvw427_pol.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.0938, 79.125),
            ["PlateVector"] = Vector(-13.9062, -114.25, 47.2812)
        }
    },
    ["models/tdmcars/mitsu_eclipgt.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1012.7273,
            ["PlateSizeH"] = 442.7273,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-10.5, -103.6875, 34.0938)
        }
    },
    ["models/lonewolfie/ford_mustang_whitegirl.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 845.8599,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 95.7188),
            ["PlateVector"] = Vector(-8.5, -116.125, 29.25)
        }
    },
    ["models/tdmcars/nissan_silvias15.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 870.9091,
            ["PlateSizeH"] = 382.7273,
            ["PlateAngle"] = Angle(0, 0, 88.3438),
            ["PlateVector"] = Vector(-8.1875, -105.0625, 25.2812)
        }
    },
    ["models/tdmcars/hud_hornet.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1001.8182,
            ["PlateSizeH"] = 388.1818,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-10.4062, -127.875, 28.4062)
        }
    },
    ["models/tdmcars/trucks/scania_4x2.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.25, 90),
            ["PlateVector"] = Vector(-14.25, -131, 39.3125)
        }
    },
    ["models/tdmcars/gmc_syclone.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 870.9091,
            ["PlateSizeH"] = 344.5455,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-8.5312, -110.7188, 26.3438)
        }
    },
    ["models/tdmcars/vaux_astra12.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.4375, -105.125, 32.2812)
        }
    },
    ["models/tdmcars/landrover.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1274.8416,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.8125, 89.75),
            ["PlateVector"] = Vector(-12.5, -116, 51.9062)
        }
    },
    ["models/tdmcars/sub_legacygt10.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1332.9492,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0.5, 82.6562),
            ["PlateVector"] = Vector(-13.1875, -108.7812, 41.7812)
        }
    },
    ["models/tdmcars/vw_camper65.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1107.2746,
            ["PlateSizeH"] = 463.9351,
            ["PlateAngle"] = Angle(0, 0.2188, 79.2188),
            ["PlateVector"] = Vector(-11, -99.1875, 39.9375)
        }
    },
    ["models/lonewolfie/spyker_aileron.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.0312, -105.5312, 28.5)
        }
    },
    ["models/lonewolfie/suzuki_liana_glx.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1335.0318,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 86.5312),
            ["PlateVector"] = Vector(-13.375, -101.25, 41.3438)
        }
    },
    ["models/tdmcars/gtav/zentorno.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 434.5455,
            ["PlateSizeH"] = 257.2727,
            ["PlateAngle"] = Angle(0, -3, 90),
            ["PlateVector"] = Vector(-4.5625, -104.3125, 20.4688)
        }
    },
    ["models/lonewolfie/lam_countach.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1258.5987,
            ["PlateSizeH"] = 301.2739,
            ["PlateAngle"] = Angle(0, -2.125, 90),
            ["PlateVector"] = Vector(-12.6875, -99.5625, 30.5938)
        }
    },
    ["models/tdmcars/civic_typer.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1296.3636,
            ["PlateSizeH"] = 382.7273,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-12.625, -96.2812, 41.5312)
        }
    },
    ["models/tdmcars/minicooper_offroad.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1383.6364,
            ["PlateSizeH"] = 300.9091,
            ["PlateAngle"] = Angle(0, -3, 90),
            ["PlateVector"] = Vector(-13.3125, -78.8438, 62)
        }
    },
    ["models/tdmcars/trailers/dolly.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.0312, 90),
            ["PlateVector"] = Vector(-14.0625, -60.1562, 38.25)
        }
    },
    ["models/lonewolfie/caterham_r500_superlight.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.7812, 81.5625),
            ["PlateVector"] = Vector(-13.3125, -72.25, 25.5625)
        }
    },
    ["models/tdmcars/mini_coopers11.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1307.2727,
            ["PlateSizeH"] = 333.6364,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.4375, -82.7812, 40.625)
        }
    },
    ["models/tdmcars/tesla_models.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-13.5938, -121.875, 42.5938)
        }
    },
    ["models/tdmcars/crownvic_taxi.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 81.8125),
            ["PlateVector"] = Vector(-14.0625, -113.8125, 41.5938)
        }
    },
    ["models/lonewolfie/ferrari_365gts.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1090.4459,
            ["PlateSizeH"] = 335.6688,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-10.7812, -107, 27.1562)
        }
    },
    ["models/lonewolfie/bugatti_veyron_grandsport.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 881.8182,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0.0938, 0.9375, 85.4688),
            ["PlateVector"] = Vector(-8.4688, -107.875, 32.4375)
        }
    },
    ["models/lonewolfie/uaz_3907_jaguar.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1198.5442,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-10.0938, -102.2812, 49.5938)
        }
    },
    ["models/lonewolfie/2000gtr_speedhunters.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 998.7261,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 95.7188),
            ["PlateVector"] = Vector(-9.8125, -115.5625, 29.3438)
        }
    },
    ["models/tdmcars/aud_rs4avant.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 78.5312),
            ["PlateVector"] = Vector(-13.7812, -110.125, 38.125)
        },
        ["Plate2"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -180, 85.0625),
            ["PlateVector"] = Vector(13.1875, 108.4688, 23.75)
        }
    },
    ["models/tdmcars/toy_mr2gt.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 775.9468,
            ["PlateSizeH"] = 299.9008,
            ["PlateAngle"] = Angle(0, 1.0625, 90),
            ["PlateVector"] = Vector(-7.8125, -98.2812, 25.375)
        }
    },
    ["models/tdmcars/trucks/scania_firetruck.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 815.1163,
            ["PlateSizeH"] = 299.3892,
            ["PlateAngle"] = Angle(0, -0.3438, 90),
            ["PlateVector"] = Vector(22.375, -163.875, 32.0938)
        }
    },
    ["models/lonewolfie/kamaz.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1268.3195,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-51.7812, -166.5938, 53)
        }
    },
    ["models/tdmcars/trucks/vol_fh1612_long.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0.1562, 90),
            ["PlateVector"] = Vector(-14.2188, -124.5312, 28.3125)
        }
    },
    ["models/tdmcars/maz_rx7.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 868.7898,
            ["PlateSizeH"] = 385.3503,
            ["PlateAngle"] = Angle(0, 0, 86.5312),
            ["PlateVector"] = Vector(-8.5, -101.9375, 25.1875)
        }
    },
    ["models/tdmcars/courier_truck.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 342.4242,
            ["PlateAngle"] = Angle(0, -2, 90),
            ["PlateVector"] = Vector(-14.9375, -158.25, 29.5625)
        }
    },
    ["models/tdmcars/trucks/freight_argosy.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.9688, -169.7188, 35.4375)
        }
    },
    ["models/tdmcars/gallardo.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1318.1818,
            ["PlateSizeH"] = 311.8182,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.6562, -102.9062, 22.0625)
        }
    },
    ["models/lonewolfie/chev_tahoe_police.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(1.625, 0.8125, 94.9062),
            ["PlateVector"] = Vector(-14.125, -114.2188, 51.9375)
        }
    },
    ["models/tdmcars/lambo_murcielagosv.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1.9375, 73),
            ["PlateVector"] = Vector(-13.3125, -107.125, 33.1562)
        }
    },
    ["models/tdmcars/murcielago.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 442.7273,
            ["PlateAngle"] = Angle(0, -2, 90),
            ["PlateVector"] = Vector(-13.625, -108.875, 34.7188)
        }
    },
    ["models/lonewolfie/maz_miata_94.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 937.5796,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 81.9688),
            ["PlateVector"] = Vector(-9.625, -91.5, 36.375)
        }
    },
    ["models/lonewolfie/for_country_squire.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 876.4331,
            ["PlateSizeH"] = 370.0637,
            ["PlateAngle"] = Angle(0, -1, 95.7188),
            ["PlateVector"] = Vector(-8.375, -132.7188, 22.875)
        }
    },
    ["models/tdmcars/trucks/vol_fh1612_short.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.9688, -116.3438, 32.0938)
        }
    },
    ["models/lonewolfie/ford_capri_rs3100.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1327.3885,
            ["PlateSizeH"] = 370.0637,
            ["PlateAngle"] = Angle(0, 0, 86.5312),
            ["PlateVector"] = Vector(-13.0625, -103.8125, 35.9375)
        }
    },
    ["models/tdmcars/trucks/peterbilt_579_med.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.2812, 90),
            ["PlateVector"] = Vector(-14.1875, -175.1562, 56.6875)
        }
    },
    ["models/tdmcars/pon_fierogt.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 881.8182,
            ["PlateSizeH"] = 415.4545,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-9.0312, -97.8438, 22.875)
        }
    },
    ["models/tdmcars/emergency/for_crownvic.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 774.941,
            ["PlateSizeH"] = 293.8112,
            ["PlateAngle"] = Angle(0, -361, 81.7812),
            ["PlateVector"] = Vector(-7.5938, -123.3438, 41.25)
        }
    },
    ["models/tdmcars/mas_quattroporte.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-12.4688, -125.6562, 30.625)
        }
    },
    ["models/lonewolfie/merc_sprinter_boxtruck.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1281.5287,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0.125, 90),
            ["PlateVector"] = Vector(-12.6562, -127.4375, 24.8125)
        }
    },
    ["models/tdmcars/maz_furai.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-13.875, -107.125, 22.9375)
        }
    },
    ["models/tdmcars/pon_firetransam.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 870.9091,
            ["PlateSizeH"] = 426.3636,
            ["PlateAngle"] = Angle(0, 3, 75.25),
            ["PlateVector"] = Vector(-8.4688, -112.5312, 37.25)
        }
    },
    ["models/tdmcars/gtav/police4.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1045.4545,
            ["PlateSizeH"] = 360.9091,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-10, -116.4062, 39.9062)
        }
    },
    ["models/lonewolfie/jaguar_xfr_pol_und.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 393.6364,
            ["PlateAngle"] = Angle(0, 1, 78.5312),
            ["PlateVector"] = Vector(-14.375, -113.375, 44.625)
        }
    },
    ["models/lonewolfie/ford_rs200.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1434.3949,
            ["PlateSizeH"] = 350.9554,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-14.125, -90.625, 35.125)
        }
    },
    ["models/tdmcars/fer_f430.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 1, 88.3438),
            ["PlateVector"] = Vector(-12.2812, -105.5, 30.6875)
        }
    },
    ["models/lonewolfie/volvo_s60_pol.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1667.2727,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-15.9688, -111.0625, 57.6562)
        }
    },
    ["models/lonewolfie/subaru_22b.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1189.8089,
            ["PlateSizeH"] = 381.5287,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-11.7812, -105.0312, 23.2188)
        }
    },
    ["models/tdmcars/gtav/policeb.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 478.1818,
            ["PlateSizeH"] = 219.0909,
            ["PlateAngle"] = Angle(0, 3.9062, 90),
            ["PlateVector"] = Vector(-4.8438, -54.6875, 27.6875)
        }
    },
    ["models/tdmcars/bug_veyronss.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 75.25),
            ["PlateVector"] = Vector(-13.8438, -93.5, 34.125)
        }
    },
    ["models/tdmcars/emergency/chargersrt8.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1042.9289,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-10.6562, -120.875, 33.4062)
        }
    },
    ["models/tdmcars/dodgeram.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.8438, -122.75, 31.5625)
        }
    },
    ["models/lonewolfie/chev_suburban_pol_und.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 437.2727,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-13.25, -129.8125, 51.2188)
        }
    },
    ["models/tdmcars/emergency/for_taurus_13.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.9062, -125.5938, 30.9688)
        }
    },
    ["models/lonewolfie/ferrari_ff.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 366.242,
            ["PlateAngle"] = Angle(0, 0, 77.375),
            ["PlateVector"] = Vector(-14, -117.1875, 33.375)
        }
    },
    ["models/tdmcars/chev_c10.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 2, 90),
            ["PlateVector"] = Vector(-13.625, -108.5938, 26.1562)
        }
    },
    ["models/tdmcars/wrangler.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.0312, -85.7812, 30.7812)
        }
    },
    ["models/tdmcars/for_raptor.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1187.2727,
            ["PlateSizeH"] = 355.4545,
            ["PlateAngle"] = Angle(0, 2, 90),
            ["PlateVector"] = Vector(-10.6562, -131.125, 36.75)
        }
    },
    ["models/lonewolfie/polaris_6x6.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 794.5455,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 1, 75.25),
            ["PlateVector"] = Vector(-8.3438, -73.6562, 34.8125)
        }
    },
    ["models/tdmcars/cad_escalade.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1.625, 81.8125),
            ["PlateVector"] = Vector(-14.4062, -123.7812, 47.8438)
        }
    },
    ["models/lonewolfie/subaru_brz.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 373.8854,
            ["PlateAngle"] = Angle(0, -1, 77.375),
            ["PlateVector"] = Vector(-13.9688, -100.25, 41.6562)
        }
    },
    ["models/lonewolfie/renault_alpine.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 914.5455,
            ["PlateSizeH"] = 311.8182,
            ["PlateAngle"] = Angle(0, 2, 90),
            ["PlateVector"] = Vector(-9.0938, -95.3125, 24.25)
        }
    },
    ["models/tdmcars/lambo_miuracon.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 268.1818,
            ["PlateAngle"] = Angle(0, -4, 90),
            ["PlateVector"] = Vector(-14.3125, -103.9062, 30.4688)
        }
    },
    ["models/lonewolfie/chev_camaro_68.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-13.375, -108.8125, 35.4688)
        }
    },
    ["models/lonewolfie/chev_impala_09_taxi.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 920.8116,
            ["PlateSizeH"] = 399.8423,
            ["PlateAngle"] = Angle(0, 0.1875, 84.7188),
            ["PlateVector"] = Vector(-9.0625, -119.8438, 31.9688)
        }
    },
    ["models/tdmcars/for_focussvt.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1285.4545,
            ["PlateSizeH"] = 355.4545,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-12.2812, -99.1875, 46.125)
        }
    },
    ["models/lonewolfie/jaguar_xfr.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 77.375),
            ["PlateVector"] = Vector(-14, -112.6875, 45.0625)
        }
    },
    ["models/lonewolfie/lykan_hypersport.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1182.1656,
            ["PlateSizeH"] = 354.7771,
            ["PlateAngle"] = Angle(0, 1, 77.375),
            ["PlateVector"] = Vector(-12.4062, -102.9688, 29.1562)
        }
    },
    ["models/tdmcars/chev_corv_gsc.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.4062, -103.25, 34.125)
        }
    },
    ["models/lonewolfie/ren_5turbo.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 355.4545,
            ["PlateAngle"] = Angle(0, 0, 65.4375),
            ["PlateVector"] = Vector(-13.5, -80.5625, 38.4688)
        }
    },
    ["models/lonewolfie/shelby_glhs.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1, 81.9688),
            ["PlateVector"] = Vector(-14.2812, -93.75, 36.875)
        }
    },
    ["models/lonewolfie/ford_capri_rs3100_police.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1372.7273,
            ["PlateSizeH"] = 480.9091,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.2188, -104.8125, 36.75)
        }
    },
    ["models/lonewolfie/lada_2108.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1452.6433,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.6562, 90),
            ["PlateVector"] = Vector(-14.5938, -88.6562, 38.2812)
        }
    },
    ["models/tdmcars/zondagr.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 892.7273,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -3, 90),
            ["PlateVector"] = Vector(5.8438, -107.1562, 18.7188)
        }
    },
    ["models/tdmcars/trailers/reefer3000r.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-14.125, -264.625, 53.375)
        }
    },
    ["models/tdmcars/lex_is300.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1122.6864,
            ["PlateSizeH"] = 345.107,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-10.25, -99.6562, 41.375)
        }
    },
    ["models/tdmcars/gtav/turismor.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 696.3636,
            ["PlateSizeH"] = 306.3636,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-6.1562, -106.0312, 20.4062)
        }
    },
    ["models/tdmcars/gmc_sierra.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.0625, -133.625, 48.9688)
        }
    },
    ["models/tdmcars/hummerh1_open.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 903.6364,
            ["PlateSizeH"] = 344.5455,
            ["PlateAngle"] = Angle(0, 2, 90),
            ["PlateVector"] = Vector(-22.375, -112.4375, 35.0938)
        }
    },
    ["models/tdmcars/bmwm5e34.mdl"] = {
        ["Plate2"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 179, 90),
            ["PlateVector"] = Vector(13.8125, 115, 24.4062)
        },
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-14.7812, -112.2812, 42.3438)
        }
    },
    ["models/tdmcars/fer_250gto.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 2, 94.9062),
            ["PlateVector"] = Vector(-14.0312, -102.2812, 27.875)
        }
    },
    ["models/tdmcars/del_dmc.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 85.0625),
            ["PlateVector"] = Vector(-14.4688, -101.7812, 45.2188)
        }
    },
    ["models/tdmcars/mclaren_mp412cgt3.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1472.6115,
            ["PlateSizeH"] = 324.2038,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-14.375, -106.4375, 28.2812)
        }
    },
    ["models/tdmcars/cad_lmp.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-14.9688, -113.9375, 23.0312)
        }
    },
    ["models/tdmcars/reventon_roadster.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0.1875, 0.25, 66.375),
            ["PlateVector"] = Vector(-13.875, -111.1875, 35.6875)
        }
    },
    ["models/tdmcars/ast_db5.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 333.6364,
            ["PlateAngle"] = Angle(0, -0.9062, 85.0625),
            ["PlateVector"] = Vector(-13.9375, -106.5, 34.3438)
        }
    },
    ["models/tdmcars/hsvw427.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1203.6445,
            ["PlateSizeH"] = 370.0093,
            ["PlateAngle"] = Angle(0, 0, 77.5),
            ["PlateVector"] = Vector(-11.4375, -114.375, 46.5938)
        }
    },
    ["models/tdmcars/emergency/mer_eclass.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1152.407,
            ["PlateSizeH"] = 329.8089,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-11.5, -120.9062, 44.6875)
        }
    },
    ["models/tdmcars/auditt.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1296.6116,
            ["PlateSizeH"] = 324.2313,
            ["PlateAngle"] = Angle(0.125, -0.5, 68.9688),
            ["PlateVector"] = Vector(-9.7188, -90.9062, 33.1875)
        }
    },
    ["models/tdmcars/trailers/dolly2.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0.9062, 80.625),
            ["PlateVector"] = Vector(-14.4375, -9.5, 30.7188)
        }
    },
    ["models/lonewolfie/volvo_s60.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.25, -111, 58.375)
        }
    },
    ["models/tdmcars/bmw_1m.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1068.3395,
            ["PlateSizeH"] = 359.4323,
            ["PlateAngle"] = Angle(0, 0, 79.125),
            ["PlateVector"] = Vector(-10.0312, -97.6875, 42.1562)
        }
    },
    ["models/tdmcars/242turbo.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(-0.1875, 0.0312, 90),
            ["PlateVector"] = Vector(-14.1562, -107.1562, 31.9062)
        }
    },
    ["models/lonewolfie/daf_xfeuro6_4x2.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -2, 90),
            ["PlateVector"] = Vector(-12.75, -122.4375, 33.3438)
        }
    },
    ["models/tdmcars/ast_rapide.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 81.8125),
            ["PlateVector"] = Vector(-14.0312, -118.5, 35)
        }
    },
    ["models/lonewolfie/dodge_daytona.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1132.7273,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 1, 104.7188),
            ["PlateVector"] = Vector(-10.75, -143.5938, 34.375)
        }
    },
    ["models/lonewolfie/dodge_monaco.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 838.1818,
            ["PlateSizeH"] = 300.9091,
            ["PlateAngle"] = Angle(0, 0.3438, 88.3438),
            ["PlateVector"] = Vector(-8.0625, -133.6875, 27.9062)
        }
    },
    ["models/lonewolfie/merc_sprinter_swb.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1396.1783,
            ["PlateSizeH"] = 350.9554,
            ["PlateAngle"] = Angle(0, -3, 88.8438),
            ["PlateVector"] = Vector(-31.25, -111.3438, 28.3125)
        }
    },
    ["models/tdmcars/gtav/futo.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 652.7273,
            ["PlateSizeH"] = 284.5455,
            ["PlateAngle"] = Angle(0, -2, 78.5312),
            ["PlateVector"] = Vector(-6.3438, -84.5312, 32.0938)
        }
    },
    ["models/lonewolfie/smart_fortwo.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 373.8854,
            ["PlateAngle"] = Angle(0, 0, 86.5312),
            ["PlateVector"] = Vector(-13.9688, -63.9062, 47.5312)
        }
    },
    ["models/tdmcars/dod_charger12.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 81.8125),
            ["PlateVector"] = Vector(-13.8438, -125.5, 35.25)
        }
    },
    ["models/tdmcars/chargersrt8.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.9062, -119, 33.5312)
        },
        ["Plate2"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -178, 90),
            ["PlateVector"] = Vector(14.3438, 116.9375, 21.9688)
        }
    },
    ["models/tdmcars/trucks/peterbilt_579.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1434.2601,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.2812, 90),
            ["PlateVector"] = Vector(-14.125, -123.375, 51.5938)
        }
    },
    ["models/tdmcars/trailers/singleaxlebox.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-14.5938, -180.5, 54.0625)
        }
    },
    ["models/tdmcars/aston_v12vantage.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1265.2598,
            ["PlateSizeH"] = 354.7094,
            ["PlateAngle"] = Angle(0, 0, 80.75),
            ["PlateVector"] = Vector(-12.5938, -109.4375, 27.75)
        }
    },
    ["models/lonewolfie/cad_eldorado_limo.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 740.0,
            ["PlateSizeH"] = 448.1818,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-7.75, -241.4688, 28.6875)
        }
    },
    ["models/lonewolfie/ford_f350_ambu.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 885.9261,
            ["PlateSizeH"] = 570.4733,
            ["PlateAngle"] = Angle(0, 0.2188, 90),
            ["PlateVector"] = Vector(-9.6875, -170.5, 40.8438)
        }
    },
    ["models/lonewolfie/lan_delta_int.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 358.5987,
            ["PlateAngle"] = Angle(0, 0, 75.0938),
            ["PlateVector"] = Vector(-13.5312, -94.1562, 40.125)
        }
    },
    ["models/tdmcars/ktm_xbow.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-13.5938, -92.125, 30.125)
        }
    },
    ["models/lonewolfie/mclaren_f1_gtr97.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 1, 104.7188),
            ["PlateVector"] = Vector(-13.125, -122.125, 22.75)
        }
    },
    ["models/tdmcars/bmw_isetta.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1085.4801,
            ["PlateSizeH"] = 251.3539,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-10.3438, -48.625, 22)
        }
    },
    ["models/lonewolfie/uaz_452.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-15.0625, -91.1562, 32.7812)
        }
    },
    ["models/tdmcars/lex_isf.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1234.7547,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.2188, 88.3125),
            ["PlateVector"] = Vector(-12.3438, -104.875, 42.75)
        }
    },
    ["models/tdmcars/jee_willys.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-13.25, -84.4688, 33.5)
        }
    },
    ["models/tdmcars/bmwm3e92.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 81.8125),
            ["PlateVector"] = Vector(-13.3438, -105.2812, 34.7812)
        }
    },
    ["models/tdmcars/ferrari250gt.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-12.8438, -98.9688, 29.25)
        }
    },
    ["models/lonewolfie/bentley_arnage_t.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(-0.5938, 0.0312, 72.375),
            ["PlateVector"] = Vector(-14.0938, -113.0625, 40.0938)
        }
    },
    ["models/lonewolfie/dodge_charger_2015.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1110.9091,
            ["PlateSizeH"] = 371.8182,
            ["PlateAngle"] = Angle(0, 2, 90),
            ["PlateVector"] = Vector(-10.875, -127.5938, 32.75)
        }
    },
    ["models/tdmcars/mini_clubman.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1241.8182,
            ["PlateSizeH"] = 311.8182,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-12.25, -91.625, 23.3125)
        }
    },
    ["models/tdmcars/mer_slr.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 312.7389,
            ["PlateAngle"] = Angle(0, 0, 72.7812),
            ["PlateVector"] = Vector(-14.1562, -106.625, 43.3125)
        }
    },
    ["models/lonewolfie/subaru_impreza_2004.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1335.0318,
            ["PlateSizeH"] = 381.5287,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-13.4688, -105.4062, 25.6875)
        }
    },
    ["models/lonewolfie/tvr_cerbera12.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1437.1292,
            ["PlateSizeH"] = 333.1158,
            ["PlateAngle"] = Angle(0, 0.5625, 58.125),
            ["PlateVector"] = Vector(-14.4062, -102.25, 30.25)
        }
    },
    ["models/tdmcars/chevelless.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -2, 90),
            ["PlateVector"] = Vector(-13.4688, -125.5312, 31.5)
        }
    },
    ["models/lonewolfie/tvr_sagaris.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 980.3453,
            ["PlateSizeH"] = 273.6715,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-9.6875, -100.5625, 34.8438)
        }
    },
    ["models/tdmcars/bmwm5e60.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.4688, 92.9375),
            ["PlateVector"] = Vector(-13.5938, -113.9688, 33.5938)
        }
    },
    ["models/lonewolfie/suzuki_kingquad.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 4.8438, 86.5312),
            ["PlateVector"] = Vector(-14.0625, -41, 33.1875)
        }
    },
    ["models/lonewolfie/ren_meganers.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 72),
            ["PlateVector"] = Vector(-13.7812, -103.3438, 31.1875)
        }
    },
    ["models/tdmcars/focusrs.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.9062, -103.7188, 41.6562)
        },
        ["Plate2"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -179, 90),
            ["PlateVector"] = Vector(15.7188, 101.75, 23.125)
        }
    },
    ["models/tdmcars/fer_enzo.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 85.0625),
            ["PlateVector"] = Vector(-12.6875, -113.3125, 30.5)
        }
    },
    ["models/tdmcars/gmc_sierralow.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1274.5455,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.2188, -129.5938, 41.8125)
        }
    },
    ["models/lonewolfie/dodge_charger_2015_undercover.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1064.9304,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.5, 75.25),
            ["PlateVector"] = Vector(-10.3125, -125.4375, 33.4062)
        }
    },
    ["models/lonewolfie/lam_huracan.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 107.1875),
            ["PlateVector"] = Vector(-13.6875, -99.8438, 33.4375)
        }
    },
    ["models/tdmcars/bug_eb110.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1399.6793,
            ["PlateSizeH"] = 356.0162,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-14.0625, -104.75, 36.6562)
        }
    },
    ["models/lonewolfie/chev_impala_09.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 839.5655,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 79.9375),
            ["PlateVector"] = Vector(-8.0625, -119.0312, 31.9375)
        }
    },
    ["models/lonewolfie/dodge_viper.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1165.4545,
            ["PlateSizeH"] = 355.4545,
            ["PlateAngle"] = Angle(0, 2, 90),
            ["PlateVector"] = Vector(-12, -103.7188, 43.7812)
        }
    },
    ["models/tdmcars/audi_r8_plus.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1, 72),
            ["PlateVector"] = Vector(-13.2812, -101.1562, 37.875)
        }
    },
    ["models/lonewolfie/citroen_ds3_rally.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 76.3438),
            ["PlateVector"] = Vector(-13.9062, -92.5, 24.5625)
        }
    },
    ["models/lonewolfie/dodge_monaco_police.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 838.1818,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-8.5312, -134.25, 30.25)
        }
    },
    ["models/tdmcars/mer_ml63.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.9375, 90),
            ["PlateVector"] = Vector(-13.5625, -116.8438, 27.6562)
        }
    },
    ["models/lonewolfie/nissan_silvia_s14.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1403.8217,
            ["PlateSizeH"] = 297.4522,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-14.0938, -112.7188, 24.9688)
        }
    },
    ["models/lonewolfie/trailer_medbox.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-14.625, -107.4688, 29.0625)
        }
    },
    ["models/tdmcars/hummerh1.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-14.3125, -112.9688, 37.5938)
        }
    },
    ["models/tdmcars/for_f350.mdl"] = {
        ["Plate2"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 178, 90),
            ["PlateVector"] = Vector(13.75, 137.2188, 37.5)
        },
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-14.4375, -158.3125, 39.125)
        }
    },
    ["models/lonewolfie/lancia_037_stradale.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1335.0318,
            ["PlateSizeH"] = 347.1338,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-13.3125, -95.0312, 22.9375)
        }
    },
    ["models/lonewolfie/porsche_911_rsr_74.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 355.4545,
            ["PlateAngle"] = Angle(0, 0, 88.3438),
            ["PlateVector"] = Vector(-16.5938, -109.4375, 22.25)
        }
    },
    ["models/tdmcars/cooper65.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1350.9091,
            ["PlateSizeH"] = 300.9091,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.5625, -75.6875, 31.3438)
        }
    },
    ["models/tdmcars/nissan_gtr.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1234.5207,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0.625, 78.5312),
            ["PlateVector"] = Vector(-12.75, -109.0312, 34.7188)
        }
    },
    ["models/tdmcars/cayenne.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-13.3125, -115.75, 29.75)
        }
    },
    ["models/lonewolfie/nissan_silvia_s14_wide.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1312.1019,
            ["PlateSizeH"] = 343.3121,
            ["PlateAngle"] = Angle(0, -0.4375, 100.3125),
            ["PlateVector"] = Vector(-12.5312, -115.1875, 25.3125)
        }
    },
    ["models/tdmcars/scion_frs.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-13.7812, -100.5312, 44.4062)
        }
    },
    ["models/tdmcars/coltralliart.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 442.7273,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-12.375, -89.6875, 25.7812)
        }
    },
    ["models/lonewolfie/mercedes_actros_2014_4x2.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-14, -122.75, 33.5)
        }
    },
    ["models/lonewolfie/jaguar_xfr_pol.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.5, 80.1875),
            ["PlateVector"] = Vector(-13.7188, -112.8125, 45.0938)
        }
    },
    ["models/tdmcars/trucks/gmc_c5500.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0.3125, 90),
            ["PlateVector"] = Vector(-14.125, -210.6562, 23.6875)
        }
    },
    ["models/tdmcars/noblem600.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1361.8182,
            ["PlateSizeH"] = 284.5455,
            ["PlateAngle"] = Angle(0, 2, 90),
            ["PlateVector"] = Vector(-13.4688, -100.4375, 27.1875)
        }
    },
    ["models/lonewolfie/nissan_sileighty.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 876.4331,
            ["PlateSizeH"] = 350.9554,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-8.8125, -109.625, 23.9062)
        }
    },
    ["models/tdmcars/chev_blazer.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1516.0184,
            ["PlateSizeH"] = 354.5373,
            ["PlateAngle"] = Angle(0, -0.5, 90),
            ["PlateVector"] = Vector(-15.0625, -105.75, 30.3125)
        }
    },
    ["models/lonewolfie/ford_falcon_xb.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 960.5096,
            ["PlateSizeH"] = 312.7389,
            ["PlateAngle"] = Angle(0, 1, 81.9688),
            ["PlateVector"] = Vector(-9.4688, -118.125, 26.8125)
        }
    },
    ["models/lonewolfie/honda_nsxr.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 934.3685,
            ["PlateSizeH"] = 356.4911,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-9.5625, -109.8438, 28.5625)
        }
    },
    ["models/tdmcars/chev_impala96.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 968.9642,
            ["PlateSizeH"] = 429.2049,
            ["PlateAngle"] = Angle(0, -0.0938, 85.1875),
            ["PlateVector"] = Vector(-9.7812, -139.2188, 39.0938)
        }
    },
    ["models/lonewolfie/chev_suburban.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-14.4062, -134.9375, 32.125)
        }
    },
    ["models/lonewolfie/chev_suburban_pol.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1601.8182,
            ["PlateSizeH"] = 410.0,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-15.2812, -129.2188, 50.3125)
        }
    },
    ["models/lonewolfie/fiat_595.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 960.5096,
            ["PlateSizeH"] = 282.1656,
            ["PlateAngle"] = Angle(0, 1, 68.1875),
            ["PlateVector"] = Vector(-9.2188, -68.3438, 33.0625)
        }
    },
    ["models/lonewolfie/nissan_silvia_s14_works.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 98),
            ["PlateVector"] = Vector(-13.6875, -115.3125, 26.625)
        }
    },
    ["models/tdmcars/landrover_defender.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1043.5937,
            ["PlateSizeH"] = 357.3024,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-36.0312, -94.7812, 53.5312)
        }
    },
    ["models/tdmcars/maz_speed3.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1281.5287,
            ["PlateSizeH"] = 335.6688,
            ["PlateAngle"] = Angle(0, 1, 93.4375),
            ["PlateVector"] = Vector(-12.375, -109.0312, 26.2188)
        }
    },
    ["models/tdmcars/bmw_340i.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.5625, -108.875, 42.4375)
        }
    },
    ["models/lonewolfie/trailer_glass.mdl"] = {
        ["Plate2"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-15.5938, -221.0625, 35.5312)
        },
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-12.9688, -226.9375, 24.125)
        }
    },
    ["models/tdmcars/dod_ram_1500.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13, -128.7188, 34.0312)
        }
    },
    ["models/tdmcars/zondac12.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 663.6364,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 3, 90),
            ["PlateVector"] = Vector(-27.625, -101.4062, 18.2188)
        }
    },
    ["models/tdmcars/gt05.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 2, 90),
            ["PlateVector"] = Vector(-12.6875, -111.2812, 36.9062)
        }
    },
    ["models/lonewolfie/uaz_469b.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1.625, 90),
            ["PlateVector"] = Vector(-30.7188, -80.3125, 40.4375)
        }
    },
    ["models/lonewolfie/ford_foxbody_stock.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 845.8599,
            ["PlateSizeH"] = 400.6369,
            ["PlateAngle"] = Angle(0, 1, 86.5312),
            ["PlateVector"] = Vector(-8.5, -106.2188, 38.1562)
        }
    },
    ["models/tdmcars/rx8.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 373.8854,
            ["PlateAngle"] = Angle(0, 1, 81.9688),
            ["PlateVector"] = Vector(-14.0938, -104.1562, 32.625)
        }
    },
    ["models/lonewolfie/lam_reventon.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 381.5287,
            ["PlateAngle"] = Angle(0, -2, 75.0938),
            ["PlateVector"] = Vector(-14.0312, -102, 34.8125)
        }
    },
    ["models/tdmcars/emergency/mitsu_evox.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1365.8495,
            ["PlateSizeH"] = 386.7,
            ["PlateAngle"] = Angle(0, 0.0312, 90),
            ["PlateVector"] = Vector(-13.6562, -105.125, 27.4688)
        }
    },
    ["models/tdmcars/bmw507.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.9375, -104.9688, 31.2188)
        }
    },
    ["models/tdmcars/for_f100.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.6875, -112.7188, 37.8125)
        }
    },
    ["models/lonewolfie/uaz_31519.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-14.1562, -80.9062, 31.1562)
        }
    },
    ["models/tdmcars/gtav/gauntlet.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 685.4545,
            ["PlateSizeH"] = 360.9091,
            ["PlateAngle"] = Angle(0, 0, 111.25),
            ["PlateVector"] = Vector(-6.8125, -114.625, 23.7812)
        }
    },
    ["models/tdmcars/mer_300slgull.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1059.8726,
            ["PlateSizeH"] = 331.8471,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-10.5625, -110.7812, 22.7812)
        }
    },
    ["models/tdmcars/ford_transit.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1296.3636,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -2, 90),
            ["PlateVector"] = Vector(-13.3125, -112.0938, 44.6562)
        }
    },
    ["models/tdmcars/for_focus_rs16.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 81.8125),
            ["PlateVector"] = Vector(-13.6562, -100.6562, 49.2188)
        },
        ["Plate2"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -180, 90),
            ["PlateVector"] = Vector(14.6562, 104.6562, 22.1562)
        }
    },
    ["models/tdmcars/fer_f12.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-12.875, -110.0312, 36.3125)
        }
    },
    ["models/tdmcars/gtav/rebel.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 663.6364,
            ["PlateSizeH"] = 355.4545,
            ["PlateAngle"] = Angle(0, -177, 90),
            ["PlateVector"] = Vector(6.0625, 107.2812, 41.5)
        }
    },
    ["models/lonewolfie/ferrari_458.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 70.5),
            ["PlateVector"] = Vector(-14.0312, -109.8438, 32.6562)
        }
    },
    ["models/lonewolfie/astonmartin_cygnet.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1199.8871,
            ["PlateSizeH"] = 379.115,
            ["PlateAngle"] = Angle(0, -1.0938, 72.75),
            ["PlateVector"] = Vector(-12.4375, -69.4688, 30.1562)
        }
    },
    ["models/lonewolfie/trailer_transporter.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.5625, 90),
            ["PlateVector"] = Vector(-14.6562, -276.5312, 30.1875)
        }
    },
    ["models/tdmcars/gtav/mesa3.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 532.7273,
            ["PlateSizeH"] = 279.0909,
            ["PlateAngle"] = Angle(0, -3, 90),
            ["PlateVector"] = Vector(24.875, -94.9688, 52.0625)
        }
    },
    ["models/tdmcars/dod_challenger70.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1136.1503,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0.0625, 109.75),
            ["PlateVector"] = Vector(-10.2812, -119.1875, 30.8125)
        }
    },
    ["models/tdmcars/golfvr6_mk3.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 948.4002,
            ["PlateSizeH"] = 407.0997,
            ["PlateAngle"] = Angle(0, 0.5938, 90),
            ["PlateVector"] = Vector(-9.9062, -90.4688, 41.5312)
        }
    },
    ["models/lonewolfie/chev_nascar.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-12.75, -128.4375, 31.4062)
        }
    },
    ["models/tdmcars/gtav/patriot2.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1700.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-17.2812, -149.1875, 55.9688)
        }
    },
    ["models/tdmcars/vol_s60.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 379.83,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.25, -112.625, 16.4062)
        }
    },
    ["models/tdmcars/vw_golfr32.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1249.8568,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0.3125, 90),
            ["PlateVector"] = Vector(-12.1875, -98.1562, 27.7812)
        }
    },
    ["models/tdmcars/nis_370z.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 513.6364,
            ["PlateAngle"] = Angle(0, -1, 78.5312),
            ["PlateVector"] = Vector(-13.6562, -99.4688, 33.6875)
        }
    },
    ["models/tdmcars/bmwm1.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1401.8752,
            ["PlateSizeH"] = 311.0037,
            ["PlateAngle"] = Angle(0, 0, 68.5),
            ["PlateVector"] = Vector(-13.7188, -101.7812, 36.6875)
        }
    },
    ["models/lonewolfie/trailer_profiliner.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.1562, -265.875, 32.7812)
        }
    },
    ["models/tdmcars/trailers/flatbed.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0.4688, 90),
            ["PlateVector"] = Vector(-14.1562, -296.1562, 50)
        }
    },
    ["models/tdmcars/mx5.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1304.4586,
            ["PlateSizeH"] = 373.8854,
            ["PlateAngle"] = Angle(0, 0, 77.375),
            ["PlateVector"] = Vector(-12.875, -89.625, 37.1562)
        }
    },
    ["models/tdmcars/jag_ftype.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 78.5312),
            ["PlateVector"] = Vector(-13.5312, -105.25, 40.125)
        }
    },
    ["models/lonewolfie/mer_c63_amg.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1327.3885,
            ["PlateSizeH"] = 385.3503,
            ["PlateAngle"] = Angle(0, 0, 75.0938),
            ["PlateVector"] = Vector(-13.4062, -109.3125, 51.4062)
        }
    },
    ["models/tdmcars/mer_300sel.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 975.7962,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-9.5625, -119.5312, 31.9375)
        }
    },
    ["models/tdmcars/mclaren_p1.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 350.9554,
            ["PlateAngle"] = Angle(0, 2, 98),
            ["PlateVector"] = Vector(-13.5625, -103.4375, 22.2188)
        }
    },
    ["models/tdmcars/vw_sciroccor.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1039.6557,
            ["PlateSizeH"] = 327.6685,
            ["PlateAngle"] = Angle(0.125, 0.4375, 73.4688),
            ["PlateVector"] = Vector(-10.875, -96.0938, 30.1562)
        }
    },
    ["models/tdmcars/landrover12.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.6875, 90),
            ["PlateVector"] = Vector(-14.0312, -116.7188, 53.8438)
        }
    },
    ["models/tdmcars/ford_coupe_40.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 2, 78.5312),
            ["PlateVector"] = Vector(-12.2188, -105.1562, 28.8438)
        }
    },
    ["models/tdmcars/nis_leaf.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1274.5455,
            ["PlateSizeH"] = 284.5455,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-12.8438, -102.2188, 25.0312)
        }
    },
    ["models/lonewolfie/lotus_esprit_80.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1335.8376,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0.25, 90),
            ["PlateVector"] = Vector(-13.3438, -95.9375, 39.3438)
        }
    },
    ["models/tdmcars/trailers/car_trailer.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.5, 90),
            ["PlateVector"] = Vector(-12.875, -94.4375, 28.7188)
        }
    },
    ["models/lonewolfie/trailer_livestock.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.75, 90),
            ["PlateVector"] = Vector(-13.4688, -246.5938, 31.9062)
        }
    },
    ["models/tdmcars/emergency/dod_charger12.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 843.1667,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.0938, 85.8438),
            ["PlateVector"] = Vector(-8.25, -125.25, 34.9688)
        }
    },
    ["models/tdmcars/kia_ceed.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0.4688, 90),
            ["PlateVector"] = Vector(-12.4062, -100.1562, 26.6875)
        }
    },
    ["models/lonewolfie/hummer_h1_tc.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1067.5159,
            ["PlateSizeH"] = 457.9618,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-51.0625, -118.75, 42.25)
        }
    },
    ["models/lonewolfie/hot_twinmill.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 762.5186,
            ["PlateSizeH"] = 283.7536,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-7.6875, -90.3438, 29)
        }
    },
    ["models/tdmcars/vol_xc90.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-13.9375, -118.1875, 26.0312)
        }
    },
    ["models/tdmcars/for_mustanggt.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 838.1818,
            ["PlateSizeH"] = 486.3636,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-7.9062, -114.7188, 32.0938)
        }
    },
    ["models/lonewolfie/merc_sprinter_openchassis.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1281.5287,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-12.625, -127.4375, 25.5625)
        }
    },
    ["models/lonewolfie/shelby_gt500kr.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 838.2166,
            ["PlateSizeH"] = 301.2739,
            ["PlateAngle"] = Angle(0, 0, 91.125),
            ["PlateVector"] = Vector(-8.2812, -113.0938, 28)
        }
    },
    ["models/tdmcars/trucks/scania_4x2_nojiggle.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.375, 90),
            ["PlateVector"] = Vector(-14.9688, -131.0312, 38.9062)
        }
    },
    ["models/tdmcars/for_she_gt500.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 459.0909,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-13.3125, -113.625, 38.1562)
        }
    },
    ["models/lonewolfie/trailer_schmied.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-13.25, -163.9688, 69.25)
        }
    },
    ["models/tdmcars/bowler_exrs.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.2188, 98.0312),
            ["PlateVector"] = Vector(-13.4062, -106.1562, 31.875)
        }
    },
    ["models/lonewolfie/tvr_tuscans.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 903.6364,
            ["PlateSizeH"] = 246.3636,
            ["PlateAngle"] = Angle(0, -3, 90),
            ["PlateVector"] = Vector(-8.3438, -99.6875, 23.2812)
        }
    },
    ["models/tdmcars/kia_fortekoup.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1209.0909,
            ["PlateSizeH"] = 290.0,
            ["PlateAngle"] = Angle(0, 3, 90),
            ["PlateVector"] = Vector(-12.2188, -110.5312, 27.8125)
        }
    },
    ["models/tdmcars/skyline_r34.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 903.6364,
            ["PlateSizeH"] = 426.3636,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-9.125, -107.1562, 27.9688)
        }
    },
    ["models/tdmcars/bus.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-14.0625, -269.125, 58.5625)
        }
    },
    ["models/tdmcars/350z.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 834.8114,
            ["PlateSizeH"] = 420.6626,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-8.1875, -103.875, 31.2812)
        }
    },
    ["models/tdmcars/gmcvan.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 849.0909,
            ["PlateSizeH"] = 400.5,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-7.6875, -111.9062, 23.6875)
        }
    },
    ["models/tdmcars/aud_s4.mdl"] = {
        ["Plate2"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -178, 90),
            ["PlateVector"] = Vector(13.8125, 106.8438, 27.125)
        },
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 344.5455,
            ["PlateAngle"] = Angle(0, 1, 88.3438),
            ["PlateVector"] = Vector(-13.5, -109.9062, 41.9062)
        }
    },
    ["models/lonewolfie/trailer_truck.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.3125, 90.125),
            ["PlateVector"] = Vector(-13.9688, -254.25, 17.3438)
        }
    },
    ["models/tdmcars/mitsu_evox.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 2, 90),
            ["PlateVector"] = Vector(-13.125, -106.1562, 44.4375)
        }
    },
    ["models/tdmcars/gtav/police3.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 718.1818,
            ["PlateSizeH"] = 344.5455,
            ["PlateAngle"] = Angle(0, 1, 68.7188),
            ["PlateVector"] = Vector(-7.25, -111.5, 47.9688)
        }
    },
    ["models/tdmcars/fer_lafer.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-14.4375, -104.3125, 38.7188)
        }
    },
    ["models/tdmcars/fer_f50.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 81.8125),
            ["PlateVector"] = Vector(-13.75, -108.3438, 24.4375)
        }
    },
    ["models/tdmcars/chr_300c_12.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.625, 75.25),
            ["PlateVector"] = Vector(-13.625, -117.6562, 32.5312)
        }
    },
    ["models/tdmcars/trucks/kenworth_t800.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-13.0938, -183.6562, 37.8438)
        }
    },
    ["models/tdmcars/jeep_wrangler_fnf.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 363.8354,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-11.4375, -113.9062, 41.6875)
        }
    },
    ["models/tdmcars/zen_st1.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1285.2635,
            ["PlateSizeH"] = 319.7326,
            ["PlateAngle"] = Angle(-0.2188, -0.8438, 75.8125),
            ["PlateVector"] = Vector(-12.8438, -112.375, 25.5)
        }
    },
    ["models/tdmcars/jeep_wrangler88.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 750.9091,
            ["PlateSizeH"] = 339.0909,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-37.0938, -81.0312, 41.4375)
        }
    },
    ["models/tdmcars/bmw_m3_gtr.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1301.7263,
            ["PlateSizeH"] = 371.4849,
            ["PlateAngle"] = Angle(-0.5938, -0.2188, 77.4688),
            ["PlateVector"] = Vector(-13.0938, -101.5, 42.4062)
        }
    },
    ["models/lonewolfie/nis_s13.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1036.9427,
            ["PlateSizeH"] = 377.707,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-10.3438, -109.3438, 23.1875)
        }
    },
    ["models/tdmcars/trailers/reefer3000r_long.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-14.0625, -315.4062, 52.9688)
        }
    },
    ["models/lonewolfie/asc_kz1r.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 330.472,
            ["PlateAngle"] = Angle(0.4375, 0.0625, 84.75),
            ["PlateVector"] = Vector(-13.9688, -107.1875, 32.1875)
        }
    },
    ["models/lonewolfie/dodge_charger_2015_police.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1167.9345,
            ["PlateSizeH"] = 331.3393,
            ["PlateAngle"] = Angle(0, 0, 77.7812),
            ["PlateVector"] = Vector(-11.8125, -125.5625, 32.875)
        }
    },
    ["models/tdmcars/jag_etype.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1176.3636,
            ["PlateSizeH"] = 333.6364,
            ["PlateAngle"] = Angle(0, 4, 90),
            ["PlateVector"] = Vector(-10.4688, -103.8438, 28.0625)
        }
    },
    ["models/tdmcars/cit_2cv.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 338.3337,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.5938, -88.5625, 31.0938)
        }
    },
    ["models/lonewolfie/mercedes_actros_6x4.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -2.9062, 90),
            ["PlateVector"] = Vector(-12.9375, -156.9062, 33.0312)
        }
    },
    ["models/tdmcars/citroen_c1.mdl"] = {
        ["Plate2"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -180.9062, 90),
            ["PlateVector"] = Vector(13.3125, 84.75, 26.5625)
        },
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.4375, -82.2188, 21.9688)
        }
    },
    ["models/lonewolfie/austin_healey_3000.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.2188, -99.875, 23.5938)
        }
    },
    ["models/tdmcars/trailers/gooseneck.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.125, 90),
            ["PlateVector"] = Vector(-13.5625, -230.0938, 46.25)
        }
    },
    ["models/tdmcars/bmw_m6_13.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 78.5312),
            ["PlateVector"] = Vector(-14.0625, -116.9062, 36.5625)
        }
    },
    ["models/lonewolfie/gmc_typhoon.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 838.2166,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-8.5, -97.0312, 26.2812)
        }
    },
    ["models/lonewolfie/subaru_impreza_2001.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1380.8917,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-13.7188, -107, 24.125)
        }
    },
    ["models/lonewolfie/mer_g65_6x6.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1411.465,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 91.125),
            ["PlateVector"] = Vector(-14.1562, -161.375, 44.0625)
        }
    },
    ["models/lonewolfie/bentley_blower.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1025.2608,
            ["PlateSizeH"] = 371.5492,
            ["PlateAngle"] = Angle(0, -0.0625, 90),
            ["PlateVector"] = Vector(-2.25, -87.4375, 26.5312)
        }
    },
    ["models/tdmcars/ferrari512tr.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 952.836,
            ["PlateSizeH"] = 306.8675,
            ["PlateAngle"] = Angle(0, 0, 100.5938),
            ["PlateVector"] = Vector(-9.6562, -107.0938, 24.3438)
        }
    },
    ["models/tdmcars/golf_mk2.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0.0625, 0.5625, 84.75),
            ["PlateVector"] = Vector(-13.9375, -90.9375, 46.8125)
        }
    },
    ["models/lonewolfie/maz.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -2, 90),
            ["PlateVector"] = Vector(-13.125, -191.375, 68.125)
        }
    },
    ["models/tdmcars/gtav/utillitruck.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 674.5455,
            ["PlateSizeH"] = 388.1818,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(32.5625, -136.5625, 29.0312)
        }
    },
    ["models/lonewolfie/mer_g65.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1335.0318,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 86.5312),
            ["PlateVector"] = Vector(-13.375, -96.9375, 38.125)
        }
    },
    ["models/lonewolfie/mercedes_slk55_amg.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1105.7325,
            ["PlateSizeH"] = 297.4522,
            ["PlateAngle"] = Angle(0, 0, 68.1875),
            ["PlateVector"] = Vector(-10.9688, -90.875, 40.0625)
        }
    },
    ["models/lonewolfie/uaz_452_ambu.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-14.0625, -90.9688, 33.9375)
        }
    },
    ["models/tdmcars/spark.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.9062, -85, 42.5)
        },
        ["Plate2"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -179, 90),
            ["PlateVector"] = Vector(13.5312, 88.9375, 25.3438)
        }
    },
    ["models/tdmcars/bug_veyron.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 78.5312),
            ["PlateVector"] = Vector(-13.0938, -108.4688, 34.4688)
        }
    },
    ["models/tdmcars/jeep_grandche.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-11.7188, -114.5312, 56.5)
        }
    },
    ["models/lonewolfie/ferrari_laferrari.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1052.2293,
            ["PlateSizeH"] = 320.3822,
            ["PlateAngle"] = Angle(0, 0, 65.9062),
            ["PlateVector"] = Vector(-10.5938, -106.6875, 28.0625)
        }
    },
    ["models/tdmcars/chev_camzl1.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-13.7188, -112.5938, 37.0312)
        }
    },
    ["models/tdmcars/chev_stingray427.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 1, 121.0625),
            ["PlateVector"] = Vector(-13.8438, -107.25, 28.8438)
        }
    },
    ["models/tdmcars/mclaren_f1.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1220.3822,
            ["PlateSizeH"] = 347.1338,
            ["PlateAngle"] = Angle(0, 0, 93.4375),
            ["PlateVector"] = Vector(-12.3125, -107.5625, 31.3438)
        }
    },
    ["models/tdmcars/audir8.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 68.7188),
            ["PlateVector"] = Vector(-15.5938, -102.5312, 32.875)
        }
    },
    ["models/lonewolfie/trailer_panel.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-12.75, -258.5625, 40.9688)
        }
    },
    ["models/tdmcars/alfa_giulietta.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1152.3438,
            ["PlateSizeH"] = 340.1955,
            ["PlateAngle"] = Angle(0, 0, 77.6562),
            ["PlateVector"] = Vector(-11.4375, -100.375, 29.7812)
        }
    },
    ["models/tdmcars/dod_ram_3500.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.8438, -155.375, -5.8438)
        }
    },
    ["models/lonewolfie/audi_r18.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.375, 90),
            ["PlateVector"] = Vector(-12.7188, -109.875, 17.2812)
        }
    },
    ["models/tdmcars/dbs.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 81.8125),
            ["PlateVector"] = Vector(-14.0938, -106.75, 43.7188)
        }
    },
    ["models/tdmcars/fer_458spid.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 85.0625),
            ["PlateVector"] = Vector(-13.125, -106.5312, 32.4375)
        }
    },
    ["models/lonewolfie/merc_sprinter_lwb.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1273.8854,
            ["PlateSizeH"] = 328.0255,
            ["PlateAngle"] = Angle(0, -3, 88.8438),
            ["PlateVector"] = Vector(-30.3438, -155.3438, 27.9688)
        }
    },
    ["models/tdmcars/hon_civic97.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 497.2727,
            ["PlateAngle"] = Angle(0, 1, 90),
            ["PlateVector"] = Vector(-14.4062, -97.3438, 45.125)
        }
    },
    ["models/tdmcars/trailers/aerodynamic.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-12.8438, -254.5625, 45.7812)
        }
    },
    ["models/lonewolfie/mercedes_190e_evo.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1335.0318,
            ["PlateSizeH"] = 450.3185,
            ["PlateAngle"] = Angle(0, 1, 75.0938),
            ["PlateVector"] = Vector(-13.2188, -104.0312, 36.0312)
        }
    },
    ["models/tdmcars/hsvgts.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-12.9375, -121.6562, 28.875)
        }
    },
    ["models/lonewolfie/gmc_yukon.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 293.6306,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-14.625, -131.4062, 34.6562)
        }
    },
    ["models/tdmcars/hon_crxsir.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 827.2727,
            ["PlateSizeH"] = 262.7273,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-8.2812, -86.625, 23.9375)
        }
    },
    ["models/lonewolfie/chev_tahoe.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -0.0938, 88.3125),
            ["PlateVector"] = Vector(-13.9688, -112.9375, 51.4062)
        }
    },
    ["models/tdmcars/lam_miura_p400.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 729.0909,
            ["PlateSizeH"] = 333.6364,
            ["PlateAngle"] = Angle(0, 4, 90),
            ["PlateVector"] = Vector(-7.5625, -106.0312, 31.6875)
        }
    },
    ["models/tdmcars/vol_xc70.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0.0625, 89.9375),
            ["PlateVector"] = Vector(-13.5938, -119.9062, 18.7812)
        }
    },
    ["models/lonewolfie/polaris_4x4.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 696.3636,
            ["PlateSizeH"] = 262.7273,
            ["PlateAngle"] = Angle(0, 2, 90),
            ["PlateVector"] = Vector(-6.4688, -41.5938, 33.3125)
        }
    },
    ["models/lonewolfie/fer_458_compe.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 438.8535,
            ["PlateAngle"] = Angle(0, 0, 75.0938),
            ["PlateVector"] = Vector(-13.5625, -111.7188, 35.0938)
        }
    },
    ["models/tdmcars/cit_c4.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 85.0625),
            ["PlateVector"] = Vector(-14.3438, -99.3125, 29.1875)
        }
    },
    ["models/lonewolfie/thebigbooper.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.0625, -72.0938, 88.75)
        }
    },
    ["models/tdmcars/vw_golfgti_14.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1318.1818,
            ["PlateSizeH"] = 361.7689,
            ["PlateAngle"] = Angle(0, -0.6562, 90),
            ["PlateVector"] = Vector(-13.125, -101.6562, 25.125)
        }
    },
    ["models/tdmcars/gtav/police.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 685.4545,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 1.3438, 78.5312),
            ["PlateVector"] = Vector(-6.5, -116.375, 39.5)
        }
    },
    ["models/tdmcars/vol_850r.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0.0312, 90),
            ["PlateVector"] = Vector(-13.2188, -115.5, 26.0625)
        }
    },
    ["models/tdmcars/mas_ghibli.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1.25, 79.7812),
            ["PlateVector"] = Vector(-13.375, -118.25, 43.375)
        }
    },
    ["models/tdmcars/chr_300c.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 78.5312),
            ["PlateVector"] = Vector(-13.6875, -121.875, 33.5)
        }
    },
    ["models/tdmcars/69camaro.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 798.3468,
            ["PlateSizeH"] = 343.6616,
            ["PlateAngle"] = Angle(0, 0.0625, 112.5312),
            ["PlateVector"] = Vector(-7.8438, -104.0312, 29.625)
        }
    },
    ["models/tdmcars/mini_coupe.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1296.3636,
            ["PlateSizeH"] = 300.9091,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.625, -79.5938, 39.7188)
        }
    },
    ["models/tdmcars/trailers/logtrailer.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0.0312, 90),
            ["PlateVector"] = Vector(-13.4688, -238.75, 80.0312)
        }
    },
    ["models/lonewolfie/nfs_mustanggt.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 838.1818,
            ["PlateSizeH"] = 420.9091,
            ["PlateAngle"] = Angle(0, 0, 81.8125),
            ["PlateVector"] = Vector(-8.5625, -106.9375, 36.75)
        }
    },
    ["models/tdmcars/mitsu_evo8.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1514.5455,
            ["PlateSizeH"] = 371.8182,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-15.3438, -103.4062, 24.8438)
        }
    },
    ["models/lonewolfie/ferrari_f40.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.875, -108.2812, 23.0625)
        }
    },
    ["models/lonewolfie/detomaso_pantera.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 787.5257,
            ["PlateSizeH"] = 414.4941,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-7.8438, -101.5938, 33.0312)
        }
    },
    ["models/lonewolfie/hummer_h1_tc_offroad.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 937.7644,
            ["PlateSizeH"] = 423.6171,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-50, -118.7812, 42.0312)
        }
    },
    ["models/lonewolfie/mitsu_evo_six.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 81.2812),
            ["PlateVector"] = Vector(-12.8438, -103.375, 46.7188)
        }
    },
    ["models/lonewolfie/gmc_savana_news.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1178.2411,
            ["PlateSizeH"] = 333.1506,
            ["PlateAngle"] = Angle(0, -0.375, 90),
            ["PlateVector"] = Vector(-11.125, -131.4375, 27.6875)
        }
    },
    ["models/tdmcars/courier_truck.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -179, 90),
            ["PlateVector"] = Vector(0.9375, 73.5625, 99.4375)
        }
    },
    ["models/lonewolfie/gmc_savana.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1266.1965,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(-0.1562, -0.2812, 90),
            ["PlateVector"] = Vector(-12.5625, -131.7188, 29.2812)
        }
    },
    ["models/tdmcars/gtav/camper_trailer.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 1, 102.5938),
            ["PlateVector"] = Vector(-14.1875, -214.2188, 37.1875)
        }
    },
    ["models/lonewolfie/detomaso_pantera.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 787.5257,
            ["PlateSizeH"] = 414.4941,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-7.8438, -101.5938, 33.0312)
        }
    },
    ["models/tdmcars/gtav/tractor.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 662.4204,
            ["PlateSizeH"] = 373.8854,
            ["PlateAngle"] = Angle(0, 2, 86.5312),
            ["PlateVector"] = Vector(-6.5312, -76.875, 24.375)
        }
    },
    ["models/lonewolfie/gmc_savana.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1266.1965,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(-0.1562, -0.2812, 90),
            ["PlateVector"] = Vector(-12.5625, -131.7188, 29.2812)
        }
    },
    ["models/lonewolfie/hummer_h1_tc_offroad.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 937.7644,
            ["PlateSizeH"] = 423.6171,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-50, -118.7812, 42.0312)
        }
    },
    ["models/tdmcars/gtav/rebel.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 845.8599,
            ["PlateSizeH"] = 301.2739,
            ["PlateAngle"] = Angle(0, 0, 91.125),
            ["PlateVector"] = Vector(-33.2188, -110.4062, 40.4062)
        }
    },
    ["models/tdmcars/gtav/gauntlet.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 853.5032,
            ["PlateSizeH"] = 392.9936,
            ["PlateAngle"] = Angle(0, 0, 109.4688),
            ["PlateVector"] = Vector(-8.6562, -114.375, 24.25)
        }
    },
    ["models/tdmcars/gtav/nemesis.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 540.1274,
            ["PlateSizeH"] = 270.7006,
            ["PlateAngle"] = Angle(0, 0, 72.7812),
            ["PlateVector"] = Vector(-5.2812, -35.3125, 38.2188)
        }
    },
    ["models/tdmcars/gtav/police3.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 707.2727,
            ["PlateSizeH"] = 360.9091,
            ["PlateAngle"] = Angle(0, 1, 78.5312),
            ["PlateVector"] = Vector(-6.8125, -112.5938, 48.8438)
        }
    },
    ["models/tdmcars/gtav/riot.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1029.2994,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-9.9688, -158.5, 37.0625)
        }
    },
    ["models/tdmcars/gtav/utillitruck.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 838.2166,
            ["PlateSizeH"] = 446.4968,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(30.625, -135.25, 29.6875)
        }
    },
    ["models/tdmcars/gtav/ambulance.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -1, 90),
            ["PlateVector"] = Vector(-11.8438, -173.7188, 26.5938)
        }
    },
    ["models/tdmcars/gtav/adder.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 783.6364,
            ["PlateSizeH"] = 290.0,
            ["PlateAngle"] = Angle(0, 0.3438, 75.25),
            ["PlateVector"] = Vector(-7.5938, -92.5312, 28.75)
        }
    },
    ["models/tdmcars/gtav/bati.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 336.3636,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 1, 58.9062),
            ["PlateVector"] = Vector(-3.5, -41.625, 35.9062)
        }
    },
    ["models/tdmcars/gtav/camper.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 408.2803,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.8125, -207.1875, 48.7812)
        }
    },
    ["models/tdmcars/gtav/baletrailer.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 6, 90),
            ["PlateVector"] = Vector(-14.875, -197.5625, 40.5)
        }
    },
    ["models/lonewolfie/gmc_savana_news.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1178.2411,
            ["PlateSizeH"] = 333.1506,
            ["PlateAngle"] = Angle(0, -0.375, 90),
            ["PlateVector"] = Vector(-11.125, -131.4375, 27.6875)
        }
    },
    ["models/tdmcars/courier_truck.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, -179, 90),
            ["PlateVector"] = Vector(0.9375, 73.5625, 99.4375)
        }
    },
    ["models/tdmcars/gtav/patriot2.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.9688, -144.0312, 55.9062)
        }
    },
    ["models/tdmcars/gtav/futo.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 845.8599,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 81.9688),
            ["PlateVector"] = Vector(-8.3125, -84.5, 32.875)
        }
    },
    ["models/tdmcars/gtav/mesa3.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 609.0909,
            ["PlateSizeH"] = 322.7273,
            ["PlateAngle"] = Angle(0, 1, 94.9062),
            ["PlateVector"] = Vector(23.7812, -94.5312, 52.2188)
        }
    },
    ["models/tdmcars/gtav/policeb.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 448.4076,
            ["PlateSizeH"] = 270.7006,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-4.4062, -53.5625, 28.1875)
        }
    },
    ["models/tdmcars/gtav/zentorno.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 723.5669,
            ["PlateSizeH"] = 259.2357,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-7.3438, -104.25, 21.4062)
        }
    },
    ["models/lonewolfie/mitsu_evo_six.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 81.2812),
            ["PlateVector"] = Vector(-12.8438, -103.375, 46.7188)
        }
    },
    ["models/tdmcars/gtav/bus.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 891.7197,
            ["PlateSizeH"] = 354.7771,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-8.875, -292.125, 55.5312)
        }
    },
    ["models/lonewolfie/ferrari_f40.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 1400.0,
            ["PlateSizeH"] = 400.0,
            ["PlateAngle"] = Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.875, -108.2812, 23.0625)
        }
    },
    ["models/tdmcars/gtav/turismor.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] = 578.3439,
            ["PlateSizeH"] = 320.3822,
            ["PlateAngle"] = Angle(0, 0, 109.4688),
            ["PlateVector"] = Vector(-5.5625, -106.0938, 21.7188)
        }
    },
    ["models/lonewolfie/cad_eldorado.mdl"] = {
        ["Plate1"] =  {
            ["PlateSizeW"] =  730.5147,
            ["PlateSizeH"] =  280.9912,
            ["PlateAngle"] =  Angle(0, 0.2812, 90),
            ["PlateVector"] = Vector(-7.3125, -132.875, 26.5)
        }
    },
    ["models/lonewolfie/lotus_exiges_roadster.mdl"] = {
        ["Plate1"] =  {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0.4062, 90),
            ["PlateVector"] = Vector(-13.9062, -99.0312, 33.1562)
        }
    },
    ["models/lonewolfie/dodge_ram_1500_outdoorsman.mdl"] = {
        ["Plate1"] =  {
            ["PlateSizeW"] =  805.4552,
            ["PlateSizeH"] =  287.69,
            ["PlateAngle"] =  Angle(0, -0.25, 90),
            ["PlateVector"] = Vector(-8.2188, -121.2812, 35.8125)
        }
    },
    ["models/lonewolfie/chev_impala_09_police.mdl"] = {
        ["Plate1"] =  {
            ["PlateSizeW"] =  829.8935,
            ["PlateSizeH"] =  449.5775,
            ["PlateAngle"] =  Angle(0, -0.5312, 80.2188),
            ["PlateVector"] = Vector(-8.125, -119.4688, 32.4688)
        }
    },
    ["models/buggy.mdl"] = {
        ["Plate1"] =  {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] = Vector(-13.4062, -100.2812, 36.3125)
        }
    },
    ["models/lonewolfie/uaz_31519_pol.mdl"] = {
        ["Plate1"] =  {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.5625, 96.625),
            ["PlateVector"] = Vector(-13.5625, -79.0625, 40.5)
        }
    },
    ["models/airboat.mdl"] = {
        ["Plate1"] =  {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 2, 90),
            ["PlateVector"] = Vector(-13.9375, -70.9688, 29.2812)
        }
    },
    ["models/lonewolfie/uaz_3170.mdl"] = {
        ["Plate1"] =  {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0.125, 89.7812),
            ["PlateVector"] = Vector(-13.875, -62.3438, 42.9375)
        }
    },
    ["models/lonewolfie/dacia_duster.mdl"] = {
        ["Plate1"] =  {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0.5625, 70.625),
            ["PlateVector"] = Vector(-14.0938, -106.6562, 45.5938)
        }
    },
    ["models/crsk_autos/hyundai/solaris_2010.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0.2812, 90),
            ["PlateVector"] =  Vector(-13.8125, -114, 46.0625)
        }
    },
    ["models/crsk_autos/saab/900turbo_1989.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-14.4375, -107.875, 33)
        }
    },
    ["models/crsk_autos/w_motors/fenyr_supersport.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -180, 113.2188),
            ["PlateVector"] =  Vector(14.1875, 110.5, 19.625)
        }
    },
    ["models/crsk_autos/tofas/kartal.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1317.6796,
            ["PlateSizeH"] =  284.5269,
            ["PlateAngle"] =  Angle(0, -180, 92.4375),
            ["PlateVector"] =  Vector(13.2188, 97.3438, 23.75)
        }
    },
    ["models/crsk_autos/hyundai/solaris_2010_black.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 2, 90),
            ["PlateVector"] =  Vector(-13.7812, -114.0938, 45.9375)
        }
    },
    ["models/crsk_autos/skoda/rapid_2014.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0.2812, 70.875),
            ["PlateVector"] =  Vector(-14.3125, -110, 45.2812)
        }
    },
    ["models/crsk_autos/bmw/alpina_b10.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1236.3636,
            ["PlateSizeH"] =  318.1818,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-11.5625, -115.1562, 39.5625)
        }
    },
    ["models/crsk_autos/bmw/750i_e38_1995.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  924.0548,
            ["PlateSizeH"] =  324.2424,
            ["PlateAngle"] =  Angle(0.125, -0.1562, 85.3125),
            ["PlateVector"] =  Vector(-9.3438, -122.375, 40.1562)
        }
    },
    ["models/crsk_autos/saab/93aero_2002.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-13.9375, -103.3438, 44.0312)
        }
    },
    ["models/crsk_autos/dodge/challenger_hellcat_2015.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1062.6931,
            ["PlateSizeH"] =  304.5184,
            ["PlateAngle"] =  Angle(0, 1, 90),
            ["PlateVector"] =  Vector(-10.75, -123.7812, 32.2188)
        }
    },
    ["models/crsk_autos/audi/rs6_avant_2016_black.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0.4062, 76.7812),
            ["PlateVector"] =  Vector(-13.1875, -119.7188, 41.1875)
        }
    },
    ["models/crsk_autos/mercedes-benz/clk_gtr_amg_coupe_1998.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.0938, 90),
            ["PlateVector"] =  Vector(-13.6875, -106.625, 29.5938)
        }
    },
    ["models/crsk_autos/mercedes-benz/cls_c218.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 78.5312),
            ["PlateVector"] =  Vector(-13.875, -100.0938, 42.3438)
        }
    },
    ["models/crsk_autos/mitsubishi/lancer_evo_ix.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 1, 90),
            ["PlateVector"] =  Vector(-14.2188, -99, 26.6875)
        }
    },
    ["models/crsk_autos/mercedes-benz/gt63s_coupe_amg_2018_black.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1414.4473,
            ["PlateSizeH"] =  361.2371,
            ["PlateAngle"] =  Angle(0.3438, 0.0625, 82.1875),
            ["PlateVector"] =  Vector(-14.0625, -122.5312, 28.1875)
        },
        ["Plate2"] = {
            ["PlateSizeW"] =  1212.8278,
            ["PlateSizeH"] =  350.1005,
            ["PlateAngle"] =  Angle(0, -180, 90),
            ["PlateVector"] =  Vector(12.25, 126, 18.875)
        }
    },
    ["models/crsk_autos/chevrolet/corvette_c1_1957.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  960.3454,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0.4688, -0.3438, 89.5),
            ["PlateVector"] =  Vector(-9.6875, -113, 19.5312)
        }
    },
    ["models/crsk_autos/mclaren/720s_2017.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.2188, 90),
            ["PlateVector"] =  Vector(-13.875, -101.0625, 24.8438)
        }
    },
    ["models/crsk_autos/gaz/24_volga.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0.0938, 90),
            ["PlateVector"] =  Vector(-13.7812, -131.9062, 37.5)
        }
    },
    ["models/crsk_autos/rolls-royce/silverspiritmk3.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.2188, 88.6875),
            ["PlateVector"] =  Vector(-14.25, -130.2812, 38.0312)
        }
    },
    ["models/crsk_autos/gtasa/buffalo.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  940.1491,
            ["PlateSizeH"] =  348.4052,
            ["PlateAngle"] =  Angle(0, -0.4688, 74.6562),
            ["PlateVector"] =  Vector(-9.5, -104.9688, 40.7188)
        }
    },
    ["models/crsk_autos/volvo/xc90_t8_2015.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1405.4545,
            ["PlateSizeH"] =  290.0,
            ["PlateAngle"] =  Angle(0, -179.5938, 102.1875),
            ["PlateVector"] =  Vector(14.625, 92.9375, 30.7812)
        }
    },
    ["models/crsk_autos/toyota/mark_ii_jzx90_tourerv_1995.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  936.3636,
            ["PlateSizeH"] =  322.7273,
            ["PlateAngle"] =  Angle(0.0938, -178.4688, 90),
            ["PlateVector"] =  Vector(9.7188, 95.7188, 26.2812)
        }
    },
    ["models/crsk_autos/alfaromeo/alfasud.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  372.4484,
            ["PlateAngle"] =  Angle(0, -0.2188, 101.5312),
            ["PlateVector"] =  Vector(-14.0625, -102.25, 40.9375)
        }
    },
    ["models/crsk_autos/kia/stinger_gt_2018.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.0938, 82.3125),
            ["PlateVector"] =  Vector(-13.375, -128.7812, 39.4688)
        }
    },
    ["models/crsk_autos/fiat/126p.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-14.5625, -72.6562, 31.0938)
        }
    },
    ["models/crsk_autos/audi/a4_quattro_2016.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1356.6484,
            ["PlateSizeH"] =  362.2359,
            ["PlateAngle"] =  Angle(0, -0.1562, 79.4062),
            ["PlateVector"] =  Vector(-13.9062, -109.0312, 40.875)
        }
    },
    ["models/crsk_autos/seat/leon_cupra_r_2003.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0.375, 78.1562),
            ["PlateVector"] =  Vector(-14.2812, -105.4688, 25.5312)
        }
    },
    ["models/crsk_autos/paz/3205.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -180, 90),
            ["PlateVector"] =  Vector(14.4375, 155.875, 29.9688)
        },
        ["Plate2"] = {
            ["PlateSizeW"] =  1263.4411,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-12.9375, -162.125, 59.3438)
        }
    },
    ["models/crsk_autos/rolls-royce/dawn_2016.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0.0625, 85.0938),
            ["PlateVector"] =  Vector(-14.3438, -125.0312, 43.2812)
        }
    },
    ["models/crsk_autos/hyundai/solaris_2010_taxi.mdl"] = {
        ["Plate2"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(-0.4688, 0.5, 89.6875),
            ["PlateVector"] =  Vector(-13.8125, -113.5625, 46.0312)
        },
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -180, 90),
            ["PlateVector"] =  Vector(14.3438, 90.1875, 23.7188)
        }
    },
    ["models/crsk_autos/toyota/crown_hybrid_athlete_s_2016.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1262.0957,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 77.4688),
            ["PlateVector"] =  Vector(-12.4688, -118.5625, 43.9062)
        },
        ["Plate2"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0.0625, -175.7188, 97.0938),
            ["PlateVector"] =  Vector(13.75, 123.0625, 23.5625)
        }
    },
    ["models/crsk_autos/lexus/lx570_2016.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.3438, 90),
            ["PlateVector"] =  Vector(-14.6875, -134.8125, 44.5938)
        }
    },
    ["models/crsk_autos/chevrolet/elcamino_1973.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.1875, 64.4688),
            ["PlateVector"] =  Vector(-13.9062, -128.6562, 40.5)
        }
    },
    ["models/crsk_autos/cadillac/fleetwood_brougham_1985.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1333.1969,
            ["PlateSizeH"] =  417.1394,
            ["PlateAngle"] =  Angle(0.5625, -0.25, 83.4062),
            ["PlateVector"] =  Vector(-13.5625, -156.0312, 41.9062)
        }
    },
    ["models/crsk_autos/chrysler/300_hurst_1970.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  878.9415,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0.5312, 90),
            ["PlateVector"] =  Vector(-8.8125, -143.9375, 26.875)
        }
    },
    ["models/crsk_autos/saleen/s7_twinturbo.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-14.125, -102.125, 25.5938)
        }
    },
    ["models/crsk_autos/rolls-royce/silvercloud3.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1298.3708,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 76.3438),
            ["PlateVector"] =  Vector(-12.8438, -124.6562, 37.375)
        }
    },
    ["models/crsk_autos/uaz/patriot_2014_investigation.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 87.2812),
            ["PlateVector"] =  Vector(-30.875, -121.2188, 42.8125)
        },
        ["Plate2"] = {
            ["PlateSizeW"] =  1419.8592,
            ["PlateSizeH"] =  327.4657,
            ["PlateAngle"] =  Angle(0, 179.875, 90),
            ["PlateVector"] =  Vector(14.1562, 97.2188, 39.1562)
        }
    },
    ["models/crsk_autos/mercedes-benz/500sl_1994.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1186.6543,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-11.5, -116.7188, 37.8125)
        }
    },
    ["models/crsk_autos/chevrolet/caprice_1993.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  988.86,
            ["PlateSizeH"] =  435.4638,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-10.0312, -134.5625, 36.6562)
        }
    },
    ["models/crsk_autos/uaz/patriot_2014_police.mdl"] = {
        ["Plate2"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.2812, 90),
            ["PlateVector"] =  Vector(-30.5312, -121.5, 42.9062)
        },
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 179.6562, 90),
            ["PlateVector"] =  Vector(14.125, 97.5938, 38.9062)
        }
    },
    ["models/crsk_autos/mercedes-benz/cklasse_w205_2014.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.1875, 80.75),
            ["PlateVector"] =  Vector(-14, -114.7188, 44.8125)
        }
    },
    ["models/crsk_autos/peugeot/308gti_2011.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.2812, 90),
            ["PlateVector"] =  Vector(-13.875, -108.5312, 19.9688)
        }
    },
    ["models/crsk_autos/nissan/370z_2016.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.0625, 77.4375),
            ["PlateVector"] =  Vector(-14.1562, -102.2812, 32.9688)
        }
    },
    ["models/crsk_autos/honda/civic_typer_fk8_2017.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 1, 90),
            ["PlateVector"] =  Vector(-13.5938, -95.5625, 38.625)
        }
    },
    ["models/crsk_autos/cadillac/cts-v_2016.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-14.4062, -119.625, 41.4375)
        }
    },
    ["models/crsk_autos/avtovaz/2170priora_2008.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-14.3438, -104.8125, 39.1875)
        }
    },
    ["models/crsk_autos/avtovaz/2109.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -179, 104.7188),
            ["PlateVector"] =  Vector(13.5625, 100.9688, 23.5625)
        }
    },
    ["models/crsk_autos/mercedes-benz/wolf.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1137.7241,
            ["PlateSizeH"] =  338.7403,
            ["PlateAngle"] =  Angle(0, -0.2812, 90),
            ["PlateVector"] =  Vector(-11.4375, -89.0625, 46.9688)
        }
    },
    ["models/crsk_autos/skoda/octavia_mk3.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.3125, 76.5938),
            ["PlateVector"] =  Vector(-14.125, -120.7812, 39.9375)
        }
    },
    ["models/crsk_autos/avtovaz/vesta.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 1, 90),
            ["PlateVector"] =  Vector(-13.125, -103.3125, 44.5938)
        },
        ["Plate2"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -178, 90),
            ["PlateVector"] =  Vector(12.375, 104.7188, 26.625)
        }
    },
    ["models/crsk_autos/jawa/350_634.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  545.946,
            ["PlateSizeH"] =  327.4901,
            ["PlateAngle"] =  Angle(0, 1, 76.2812),
            ["PlateVector"] =  Vector(-5.4062, -46.1875, 25.4062)
        }
    },
    ["models/crsk_autos/mitsubishi/galante39a_1987.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -1, 90),
            ["PlateVector"] =  Vector(-15.875, -102.2812, 36.875)
        }
    },
    ["models/crsk_autos/mercedes-benz/e500_w124_1994.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-14.5938, -107.5938, 39.875)
        }
    },
    ["models/crsk_autos/renault/magnum_iii_2005.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(-0.0938, 179.875, 95.8438),
            ["PlateVector"] =  Vector(14.2812, 105.4062, 25.5625)
        }
    },
    ["models/crsk_autos/rolls-royce/wraith_2013.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.0938, 76.4375),
            ["PlateVector"] =  Vector(-14.1562, -117.6562, 43.1875)
        }
    },
    ["models/crsk_autos/volkswagen/karmann_ghia.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1143.6364,
            ["PlateSizeH"] =  240.9091,
            ["PlateAngle"] =  Angle(0, 0, 97.4688),
            ["PlateVector"] =  Vector(-11.8438, -96.5, 26)
        }
    },
    ["models/crsk_autos/ford/focus_mk3_2012.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0.0625, 85.7812),
            ["PlateVector"] =  Vector(-13.7812, -116.2812, 43.9375)
        }
    },
    ["models/crsk_autos/honda/accord_2008.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-14.4375, -113.6875, 47.6562)
        }
    },
    ["models/crsk_autos/bmw/m135i_f21_2012.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.5625, 90.8438),
            ["PlateVector"] =  Vector(-14.6562, -110.5312, 29.125)
        }
    },
    ["models/crsk_autos/maserati/alfieri_concept_2014.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0.4688, 74.9062),
            ["PlateVector"] =  Vector(-14.5312, -116.75, 35.875)
        }
    },
    ["models/crsk_autos/toyota/camry_xv50_2016_black.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 179.2812, 91.8438),
            ["PlateVector"] =  Vector(14.1875, 116.4062, 24.25)
        }
    },
    ["models/crsk_autos/avtovaz/2107.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.5, 90),
            ["PlateVector"] =  Vector(-14.0938, -90.4062, 33.5)
        }
    },
    ["models/crsk_autos/audi/s5_2017.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.3125, 71.0312),
            ["PlateVector"] =  Vector(-14.25, -103.6875, 39.5)
        }
    },
    ["models/crsk_autos/mercedes-benz/c63s_amg_coupe_2016.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 74.9688),
            ["PlateVector"] =  Vector(-13.4375, -117.7188, 28.8438)
        }
    },
    ["models/crsk_autos/honda/prelude_1996.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.2812, 90),
            ["PlateVector"] =  Vector(-14.375, -106.625, 27.4062)
        }
    },
    ["models/crsk_autos/lamborghini/jalpa_1984.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.2188, 90),
            ["PlateVector"] =  Vector(-14.1562, -105.1562, 18.9375)
        }
    },
    ["models/crsk_autos/toyota/camry_xv50_2016.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0.0938, 178.0938, 90.0312),
            ["PlateVector"] =  Vector(14.4375, 116.0312, 24.4062)
        }
    },
    ["models/crsk_autos/gmc/sierra_1500slt_2014.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-14.1562, -149.0625, 34.1875)
        }
    },
    ["models/crsk_autos/mercedes-benz/g63_amg_2019.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0.4688, 90),
            ["PlateVector"] =  Vector(-13.75, -93.0938, 31.0312)
        }
    },
    ["models/crsk_autos/porsche/911_turbos_2017.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 75.2812),
            ["PlateVector"] =  Vector(-14.1875, -108.2188, 28.125)
        }
    },
    ["models/crsk_autos/iveco/stralis_hi-way_2013.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -180, 90),
            ["PlateVector"] =  Vector(14.8438, 126.1875, 23.9375)
        }
    },
    ["models/crsk_autos/skoda/karoq_2018.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-13.0625, -118.7188, 43.3125)
        }
    },
    ["models/crsk_autos/peugeot/205_t16_1984.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.3438, 90),
            ["PlateVector"] =  Vector(-14.6562, -94.5625, 21.25)
        }
    },
    ["models/crsk_autos/tesla/model_x_2015.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0.6875, 86.6562),
            ["PlateVector"] =  Vector(-14.5, -145.25, 49.25)
        }
    },
    ["models/crsk_autos/scania/164l_580_2004.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -180, 90),
            ["PlateVector"] =  Vector(14.1562, 126.0625, 44.4062)
        }
    },
    ["models/crsk_autos/dodge/charger_srt_hellcat_2015_black.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-14.125, -125.375, 31.375)
        }
    },
    ["models/crsk_autos/honda/prelude_1980.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-14.1562, -97.8438, 38.375)
        }
    },
    ["models/crsk_autos/aston_martin/vantagev600_1998.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1458.2497,
            ["PlateSizeH"] =  351.3857,
            ["PlateAngle"] =  Angle(0, 0.0625, 71.5625),
            ["PlateVector"] =  Vector(-14.5938, -124.9375, 44.6562)
        },
        ["Plate2"] = {
            ["PlateSizeW"] =  1294.1509,
            ["PlateSizeH"] =  313.5714,
            ["PlateAngle"] =  Angle(0, -180.2188, 87.5938),
            ["PlateVector"] =  Vector(12.9688, 102.9688, 25.2812)
        }
    },
    ["models/crsk_autos/rolls-royce/phantom_viii_2018.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1269.2988,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.6875, 84.5312),
            ["PlateVector"] =  Vector(-13.0938, -149.0312, 42.2812)
        }
    },
    ["models/crsk_autos/toyota/crown_hybrid_athlete_s_2016_black.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  827.2727,
            ["PlateSizeH"] =  401.5679,
            ["PlateAngle"] =  Angle(0.2812, -180.0938, 90),
            ["PlateVector"] =  Vector(8.1875, 121.1875, 24.4688)
        }
    },
    ["models/crsk_autos/ford/crownvictoria_1994.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  448.4119,
            ["PlateAngle"] =  Angle(0, 1, 90),
            ["PlateVector"] =  Vector(-13.4688, -127.4375, 26.6875)
        }
    },
    ["models/crsk_autos/peugeot/406_1998.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-14.125, -110.1875, 29.0625)
        }
    },
    ["models/crsk_autos/bmw/z4_m40i_g29_2019.mdl"] = {
        ["Plate2"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 179, 90),
            ["PlateVector"] =  Vector(13.6562, 100.2812, 22.5938)
        },
        ["Plate1"] = {
            ["PlateSizeW"] =  1310.6023,
            ["PlateSizeH"] =  336.2354,
            ["PlateAngle"] =  Angle(0.2812, 0.6875, 83),
            ["PlateVector"] =  Vector(-12.9688, -98.25, 32.4062)
        }
    },
    ["models/crsk_autos/mercedes-benz/500se_w140_1992.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-13.7812, -112.5625, 41.4062)
        }
    },
    ["models/crsk_autos/honda/nsx_2017.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-14.5, -100.2812, 23.6875)
        }
    },
    ["models/crsk_autos/ferrari/360stradale_2003.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.5, 90),
            ["PlateVector"] =  Vector(-14.4062, -101.125, 27.9375)
        }
    },
    ["models/crsk_autos/bmw/x6m_f86_2015_black.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.0938, 75.7188),
            ["PlateVector"] =  Vector(-13.3438, -110.5, 53.9375)
        }
    },
    ["models/crsk_autos/ford/bronco_1982.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-14.5, -120.7188, 34.0625)
        }
    },
    ["models/crsk_autos/holden/commodore_ute_ss_2012.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.125, 82.6562),
            ["PlateVector"] =  Vector(-13.6562, -132.875, 38.0312)
        }
    },
    ["models/crsk_autos/bmw/z4_m40i_g29_2019_black.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1268.9202,
            ["PlateSizeH"] =  403.7195,
            ["PlateAngle"] =  Angle(0, -0.6875, 88.0938),
            ["PlateVector"] =  Vector(-12.75, -98.75, 32.8125)
        },
        ["Plate2"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 180, 90),
            ["PlateVector"] =  Vector(13.9062, 100.625, 22.6875)
        }
    },
    ["models/crsk_autos/peugeot/406_taxi.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0.0938, 90),
            ["PlateVector"] =  Vector(-14.2812, -109.875, 29.9062)
        }
    },
    ["models/crsk_autos/avtovaz/2114_trafficpolice.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.0938, 90),
            ["PlateVector"] =  Vector(-14.0938, -81.1875, 33.1562)
        },
        ["Plate2"] = {
            ["PlateSizeW"] =  1301.4344,
            ["PlateSizeH"] =  303.2819,
            ["PlateAngle"] =  Angle(0, 179.6875, 90),
            ["PlateVector"] =  Vector(13.0938, 100, 24.7812)
        }
    },
    ["models/crsk_autos/tofas/dogan.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 1, 90),
            ["PlateVector"] =  Vector(-13.5, -97.0625, 32.5)
        }
    },
    ["models/crsk_autos/ford/falcon_gtho_xy_1971.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-15.1562, -127.375, 23.9688)
        }
    },
    ["models/crsk_autos/toyota/chaservtourerx100_1998.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  782.9974,
            ["PlateSizeH"] =  401.4582,
            ["PlateAngle"] =  Angle(0, -180, 90.1875),
            ["PlateVector"] =  Vector(8.1562, 97.3438, 19.0312)
        }
    },
    ["models/crsk_autos/porsche/911_gt2_993_1995.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0.3125, 90),
            ["PlateVector"] =  Vector(-13.8125, -103.5312, 21.8125)
        }
    },
    ["models/crsk_autos/mercedes-benz/gl63_amg_2013.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.25, 90),
            ["PlateVector"] =  Vector(-14.4062, -133.9375, 47.9688)
        }
    },
    ["models/crsk_autos/zil/130_bortovoi.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 1, 90),
            ["PlateVector"] =  Vector(-14.6562, -176.5, 50.375)
        },
        ["Plate2"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -180, 90),
            ["PlateVector"] =  Vector(15.125, 127.8438, 38.9375)
        }
    },
    ["models/crsk_autos/zaz/968m.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.25, 90),
            ["PlateVector"] =  Vector(-14.3125, -94.5625, 33.1562)
        }
    },
    ["models/crsk_autos/dodge/charger_srt_hellcat_2015.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.2812, 79.125),
            ["PlateVector"] =  Vector(-14.0625, -123.9375, 30.5938)
        }
    },
    ["models/crsk_autos/mercedes-benz/vito_panel_2014.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -2, 90),
            ["PlateVector"] =  Vector(-31, -121.0625, 42.6875)
        },
        ["Plate2"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -180.2812, 90),
            ["PlateVector"] =  Vector(13.75, 116.0938, 24.4688)
        }
    },
    ["models/crsk_autos/avtovaz/2115_trafficpolice.mdl"] = {
        ["Plate2"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.0625, 90),
            ["PlateVector"] =  Vector(-14.375, -93.9688, 21.2812)
        },
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  303.6733,
            ["PlateAngle"] =  Angle(0, -180, 90),
            ["PlateVector"] =  Vector(14.0938, 100.1875, 25.1875)
        }
    },
    ["models/crsk_autos/smz/s-3d.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  532.7273,
            ["PlateSizeH"] =  423.8357,
            ["PlateAngle"] =  Angle(0, -0.0938, 85.7812),
            ["PlateVector"] =  Vector(-5.2188, -63.375, 34.5)
        }
    },
    ["models/crsk_autos/toyota/landcruiser_200_2013.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  850.8904,
            ["PlateSizeH"] =  235.7299,
            ["PlateAngle"] =  Angle(-0.3125, 179.25, 91.9062),
            ["PlateVector"] =  Vector(8.7812, 130.3125, 34.9688)
        }
    },
    ["models/crsk_autos/moskvich/412_1970.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.25, 90),
            ["PlateVector"] =  Vector(-14.4375, -89.0312, 31.6875)
        }
    },
    ["models/crsk_autos/mercedes-benz/gt63s_coupe_amg_2018.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-14.6562, -124.0625, 28.3438)
        }
    },
    ["models/crsk_autos/gtasa/tampa.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0.5, 90),
            ["PlateVector"] =  Vector(-15.2812, -114.5625, 20.7812)
        }
    },
    ["models/crsk_autos/ford/ltd_lx_1986.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  801.9343,
            ["PlateSizeH"] =  311.4339,
            ["PlateAngle"] =  Angle(0, -1.0938, 75.6875),
            ["PlateVector"] =  Vector(-8.0312, -129.4688, 35.5)
        }
    },
    ["models/crsk_autos/alfaromeo/montreal.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1297.3968,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.125, 90),
            ["PlateVector"] =  Vector(-13.0938, -102.3438, 35.4688)
        }
    },
    ["models/crsk_autos/audi/rs6_avant_2016.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0.125, 0.0312, 78),
            ["PlateVector"] =  Vector(-13.875, -120.5625, 41.375)
        }
    },
    ["models/crsk_autos/avtovaz/2101.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -1, 90),
            ["PlateVector"] =  Vector(-13.4062, -95.0312, 33.6875)
        }
    },
    ["models/crsk_autos/mercedes-benz/g63_amg_2019_black.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-14, -93, 31.25)
        }
    },
    ["models/crsk_autos/hyundai/solaris_2010_trafficpolice.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.5, 81.7812),
            ["PlateVector"] =  Vector(-14.875, -112.375, 45.9375)
        }
    },
    ["models/crsk_autos/mercedes-benz/g500_2008.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-14.1562, -114.25, 27.6875)
        }
    },
    ["models/crsk_autos/subaru/wrx_sti_2015.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.5, 87.0938),
            ["PlateVector"] =  Vector(-14.6875, -113.3438, 44.75)
        }
    },
    ["models/crsk_autos/skoda/octavia_mk1_1999.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -1, 90),
            ["PlateVector"] =  Vector(-14.5625, -124.4688, 42.4375)
        }
    },
    ["models/crsk_autos/daf/95xf_4x2_2003.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0.0938, 179.6875, 89.875),
            ["PlateVector"] =  Vector(14.6875, 125.6562, 26.375)
        }
    },
    ["models/crsk_autos/bmw/z4e89_2012.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.4375, 90),
            ["PlateVector"] =  Vector(-14.0312, -100.9375, 22.0312)
        }
    },
    ["models/crsk_autos/avtovaz/2114.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-13.875, -82.6562, 33.4688)
        }
    },
    ["models/crsk_autos/jeep/grandcherokee_srt_2014.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 1, 90),
            ["PlateVector"] =  Vector(-14.8125, -116.125, 51.875)
        }
    },
    ["models/crsk_autos/skoda/fabia_mk1_2001.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.25, 80.75),
            ["PlateVector"] =  Vector(-14.1875, -88.8125, 41.75)
        }
    },
    ["models/crsk_autos/avtovaz/2113.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.0938, 90),
            ["PlateVector"] =  Vector(-13.8125, -81.2188, 33.1562)
        },
        ["Plate2"] = {
            ["PlateSizeW"] =  1296.8569,
            ["PlateSizeH"] =  278.0346,
            ["PlateAngle"] =  Angle(0, -180, 90),
            ["PlateVector"] =  Vector(13.1875, 100.4375, 24.7188)
        }
    },
    ["models/crsk_autos/alfaromeo/giulia_quadrifoglio_2017.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 79.7812),
            ["PlateVector"] =  Vector(-12.8438, -115.2188, 38.8125)
        }
    },
    ["models/crsk_autos/bmw/x6m_f86_2015.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.4375, 78.4062),
            ["PlateVector"] =  Vector(-13.9688, -110.875, 54.1562)
        }
    },
    ["models/crsk_autos/aston_martin/db11_2017.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(-0.2188, -0.125, 87.2188),
            ["PlateVector"] =  Vector(-13.625, -109.0312, 24.4688)
        }
    },
    ["models/crsk_autos/ford/grantorino_1972.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  818.0583,
            ["PlateSizeH"] =  338.6185,
            ["PlateAngle"] =  Angle(0, -0.0312, 90),
            ["PlateVector"] =  Vector(-8.4062, -133.0938, 28.7188)
        }
    },
    ["models/crsk_autos/bmw/7er_g11_2015.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 82.0312),
            ["PlateVector"] =  Vector(-13.0312, -124.5938, 34.125)
        }
    },
    ["models/crsk_autos/toyota/landcruiser_200_2013_black.mdl"] = {
        ["Plate2"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(-0.3125, 1.25, 100.2188),
            ["PlateVector"] =  Vector(-13.9375, -111.8438, 47.0312)
        },
        ["Plate1"] = {
            ["PlateSizeW"] =  782.5969,
            ["PlateSizeH"] =  234.918,
            ["PlateAngle"] =  Angle(0.0938, -175.9375, 90),
            ["PlateVector"] =  Vector(7.8438, 131.9688, 35)
        }
    },
    ["models/crsk_autos/avtovaz/2106.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.4688, 90),
            ["PlateVector"] =  Vector(-14.9375, -93.0625, 33.2812)
        }
    },
    ["models/crsk_autos/ford/bronco_1982_police.mdl"] = {
        ["Plate2"] = {
            ["PlateSizeW"] =  737.4595,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -180, 90),
            ["PlateVector"] =  Vector(7.6562, 100.9688, 34.6875)
        },
        ["Plate1"] = {
            ["PlateSizeW"] =  781.0237,
            ["PlateSizeH"] =  424.0259,
            ["PlateAngle"] =  Angle(-0.0625, 0, 90),
            ["PlateVector"] =  Vector(-7.9062, -116.5625, 34.2188)
        }
    },
    ["models/crsk_autos/avtovaz/2115.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-14.4062, -95.6875, 21.4688)
        },
        ["Plate2"] = {
            ["PlateSizeW"] =  1330.0076,
            ["PlateSizeH"] =  301.1844,
            ["PlateAngle"] =  Angle(0, -180.0938, 90),
            ["PlateVector"] =  Vector(13.5312, 99.9062, 24.625)
        }
    },
    ["models/crsk_autos/ford/mustang_gt_2018.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-13.5625, -122.6875, 29.7812)
        }
    },
    ["models/crsk_autos/alfaromeo/8cspider.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0.4688, 85.75),
            ["PlateVector"] =  Vector(-14.25, -106.375, 19.6562)
        }
    },
    ["models/crsk_autos/bmw/i8_2015.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.25, 72.625),
            ["PlateVector"] =  Vector(-14.6875, -125.6562, 28.5)
        }
    },
    ["models/crsk_autos/jaguar/fpace_2016.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 72.4688),
            ["PlateVector"] =  Vector(-14.25, -126.6875, 48.6875)
        }
    },
    ["models/crsk_autos/ferrari/812superfast_2017.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 70.7812),
            ["PlateVector"] =  Vector(-14.7812, -117.3438, 31.4375)
        }
    },
    ["models/crsk_autos/mercedes-benz/560sel_1985.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0.2812, 80.6875),
            ["PlateVector"] =  Vector(-13.6562, -134.0312, 39.5312)
        }
    },
    ["models/crsk_autos/honda/integra_dc2_typer_1998.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0.125, 90),
            ["PlateVector"] =  Vector(-14.2188, -107.8125, 26.5938)
        }
    },
    ["models/crsk_autos/mercedes-benz/e63amg_w212_facelift.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 84.75),
            ["PlateVector"] =  Vector(-14.25, -117.9062, 40.75)
        }
    },
    ["models/crsk_autos/peugeot/206rc_2003.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  281.8448,
            ["PlateAngle"] =  Angle(0, -0.0625, 80.1562),
            ["PlateVector"] =  Vector(-14, -84.7812, 36.8438)
        }
    },
    ["models/crsk_autos/zil/41047.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1230.9091,
            ["PlateSizeH"] =  251.8182,
            ["PlateAngle"] =  Angle(0, -180.25, 98.3438),
            ["PlateVector"] =  Vector(12.7188, 124.5312, 24.9375)
        }
    },
    ["models/crsk_autos/ford/mustang_rtr_2018.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 1, 90),
            ["PlateVector"] =  Vector(-13.5312, -122.7188, 29.6562)
        }
    },
    ["models/crsk_autos/mercedes-benz/g500_short_2008.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0.0938, 90),
            ["PlateVector"] =  Vector(-14.5938, -93.7188, 26.875)
        }
    },
    ["models/crsk_autos/toyota/mark_ii_jzx90_grande_1992.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  932.3895,
            ["PlateSizeH"] =  306.3636,
            ["PlateAngle"] =  Angle(-0.0312, -177.375, 90),
            ["PlateVector"] =  Vector(9.625, 95.7188, 26.125)
        }
    },
    ["models/crsk_autos/uaz/patriot_2014.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.2812, 87.3438),
            ["PlateVector"] =  Vector(-30.5625, -120.7188, 43.4375)
        },
        ["Plate2"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 179.875, 90),
            ["PlateVector"] =  Vector(14.0938, 97.125, 38.0938)
        }
    },
    ["models/crsk_autos/ford/crownvictoria_1987.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, -0.4062, 74.5938),
            ["PlateVector"] =  Vector(-13.8125, -105.125, 35.5312)
        }
    },
    ["models/crsk_autos/peugeot/508_2011.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0.0938, 90),
            ["PlateVector"] =  Vector(-14.3438, -115.0312, 18.8125)
        }
    },
    ["models/crsk_autos/landrover/series_iia_stationwagon.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-28.25, -131.5312, 87.4688)
        }
    },
    ["models/crsk_autos/bmw/750li_f02_2009.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 81),
            ["PlateVector"] =  Vector(-13.7188, -119.7812, 40.1875)
        }
    },
    ["models/crsk_autos/apollo/intensa_emozione.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-13.4375, -128.875, 22.9688)
        }
    },
    ["models/crsk_autos/nissan/skyline_r32_gtr_custom.mdl"] = {
        ["Plate1"] = {
            ["PlateSizeW"] =  1400.0,
            ["PlateSizeH"] =  400.0,
            ["PlateAngle"] =  Angle(0, 0, 90),
            ["PlateVector"] =  Vector(-14.8125, -111.0625, 27.9375)
        }
    }
}