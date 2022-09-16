CH_AdvMedic = CH_AdvMedic or {}
CH_AdvMedic.Config = CH_AdvMedic.Config or {}
CH_AdvMedic.Config.Design = CH_AdvMedic.Config.Design or {}

-- SET LANGUAGE
-- Available languages: English: en - French: fr - Danish: da - German: de - Russian: ru - Spanish: es - Portuguese: pl - Chinese: cn - Turkish: tr
CH_AdvMedic.Config.Language = "es" -- Set the language of the script.

-- General Config
CH_AdvMedic.Config.AllowedTeams = { -- This is a list of paramedic teams. They can access the ambulance NPC and get the new health kit.
	"Medico",
	"Paramedico"
}

CH_AdvMedic.Config.DeadCanHearPlayersVoiceDistance = 250000 -- Dead players can hear alive players voices within a distance

CH_AdvMedic.Config.NotificationTime = 6 -- Amount of seconds notifications display for this addon.

-- Recharge Stations
CH_AdvMedic.Config.DefaultCharges = 10 -- Amount of charges the recharge stations has when they spawns on startup.
CH_AdvMedic.Config.RegainTime = 20 -- Amount of minutes between the recharge stations regains their 10 recharges.
CH_AdvMedic.Config.RegainCharges = 5 -- Amount of charges the recharge stations regain after the 'RegainTime'
CH_AdvMedic.Config.NotifyMedics = true -- Should all the teams in the table above be notified when it has regained it's recharges. 

-- Health Kit
CH_AdvMedic.Config.MedkitHealDelay = 0.6 -- Amount of seconds between healing yourself/others. [Default = 1.7]
CH_AdvMedic.Config.MinHealthToGive = 5 -- Minimum amount of health to give when healing others/yourself. [Default = 2]
CH_AdvMedic.Config.MaxHealthToGive = 10 -- Maximum amount of health to give when healing others/yourself. [Default = 5]
CH_AdvMedic.Config.MinimumCharge = 20 -- Percentage % the medkit must be below before the medics can recharge. [Default = 20]

CH_AdvMedic.Config.HealDistanceToTarget = 6000 -- Distance between the medic and target to heal them?

-- Defibrillator Config
CH_AdvMedic.Config.DefibrillatorDelay = 2 -- Amount of seconds between using the defibrillator swep.(Don't go below 2!)
CH_AdvMedic.Config.UnconsciousTime = 30 -- Amount of seconds a player is unconscious if killed.
CH_AdvMedic.Config.UnconsciousIfNoMedicTime = 10 -- Amount of seconds a player is unconscious if killed while there are no medics.

CH_AdvMedic.Config.BecomeDarkerWhenDead = true -- Should the screen go more and more dark/black once you get knocked unconscious?
CH_AdvMedic.Config.DarkestAlpha = 250 -- How dark will it get once you die? All black alpha is 255

CH_AdvMedic.Config.RevivalReward = 2250 -- How much a medic earns from reviving a player WITHOUT a life alert. [Default = 250]

CH_AdvMedic.Config.EnableDeathMoaning = false -- Should players emit death moaning sounds while laying unconscious?
CH_AdvMedic.Config.DisableChatWhenDead = false -- Should the dead player be able to use their chat while unconscious?

CH_AdvMedic.Config.ClickToRespawn = true -- Should the player click to respawn after the time runs out or instantly respawn?

CH_AdvMedic.Config.RevivalFailChance = 25 -- How high is the chance that a revival attempt will fail? 25% fail chance by default.

CH_AdvMedic.Config.ReviveDistanceToTarget = 8000 -- Distance between the medic and target/body to revive them?

-- Life Alert
CH_AdvMedic.Config.LifeAlertIcon = Material( "icon16/heart_delete.png" ) -- The icon to appear on the player when dead if he/she has a life alert. LIST HERE: http://www.famfamfam.com/lab/icons/silk/preview.php
CH_AdvMedic.Config.LifeAlertRevivalReward = 1000 -- How much a medic earns from reviving a player WITH a life alert.
CH_AdvMedic.Config.LifeAlertNotifyMedic = true -- Notify paramedics about location of dead bodies with life alerts.
CH_AdvMedic.Config.AutoLifeAlert = false -- Enabling this will "give" every player a life alert automatically and remove it from the F4 menu.

CH_AdvMedic.Config.LifeAlertDistance = true -- Should the life alert icon and distance show on bodies with a life alert?
CH_AdvMedic.Config.LifeAlertHalo = true -- Should bodies with a life alert glow with a red halo for medics to see on the map?
CH_AdvMedic.Config.LifeAlertHaloColor = Color( 255, 0, 0, 255 ) -- Color of the halo on dead bodies.

-- Ambulance NPC Configuration
CH_AdvMedic.Config.VehicleModel = "models/lonewolfie/ford_f350_ambu.mdl" -- This is the model for the ambulance.
CH_AdvMedic.Config.VehicleScript = "scripts/vehicles/lwcars/ford_f350_ambu.txt" -- This is the vehicle script for the vehicle.
CH_AdvMedic.Config.VehicleSkin = 0 -- 0 = default, 1 = evo city, 2 = rockford, 3 = paralake, 4 = all white, 5 = zebra, 6 = spirals, 7 = camoflage, 8 = all black
CH_AdvMedic.Config.AmbulanceHealth = 750 -- The amount of health the ambulance has.

CH_AdvMedic.Config.NPCModel = "models/kleiner.mdl" -- This is the model of the NPC to get a ambulance from.
CH_AdvMedic.Config.MaxTrucks = 3 -- The maximum amount of ambulances allowed.

-- Health NPC Configuration
CH_AdvMedic.Config.HealthNPCModel = "models/breen.mdl" -- This is the model of the NPC to regain health.
CH_AdvMedic.Config.HealthPrice = 1500 -- This is the price for full health via the NPC.
CH_AdvMedic.Config.ArmorPrice = 4000 -- This is the price for full armor via the NPC.

CH_AdvMedic.Config.OnlyWorkIfNoMedics = false -- Only allow players to heal/armor via the NPC if there are NO medics. Else defaults to config below!
CH_AdvMedic.Config.RequiredMedics = 1 -- Amount of players from the teams in the table (CH_AdvMedic.Config.AllowedTeams). Default is 1 required medic/paramedic/doctor available before you can use the health npc.
CH_AdvMedic.Config.MaximumArmor = 100 -- Maximum amount of armor the armor kit entities can heal a player to.

CH_AdvMedic.Config.NPCSellHealth = true -- Should the health NPC sell health or not? Allows you to disable it if set to false.
CH_AdvMedic.Config.NPCSellArmor = true -- Should the health NPC sell armor or not? Allows you to disable it if set to false.

-- Rank Death Times
CH_AdvMedic.Config.EnableRankDeathTimes = false -- If this feature should be enabled or not (Works only with ULX, SAM & ServerGuard).

CH_AdvMedic.Config.RankDeathTime = {
	{ UserGroup = "user", Time = 30 },
	{ UserGroup = "vipinicial", Time = 22 },
	{ UserGroup = "vipgiant", Time = 18 },
	{ UserGroup = "viplegend", Time = 15 },
	{ UserGroup = "vipblackblood", Time = 10 },
	{ UserGroup = "admin", Time = 30 },
	{ UserGroup = "superadmin", Time = 30 },
}

-- Chat Commands
CH_AdvMedic.Config.AdminReviveCommand = "!arevive" -- Command for admins to revive themselves when unconscious

-- Damage and Injuries System
CH_AdvMedic.Config.EnableInjurySystem = false -- Should the injury system be enabled or not?
CH_AdvMedic.Config.HitsBeforeInjuries = 3 -- Amount of hits from bullets the player can take before he will start to get injured.

CH_AdvMedic.Config.DisableInjuriesForCertainTeams = false -- If this is enabled, the teams below WILL NOT receive injuries when damaged.
CH_AdvMedic.Config.ImmuneInjuriesTeams = { -- The teams that won't get injuried if the config above is enabled.
	"Alien",
	"Ghost"
}

CH_AdvMedic.Config.MinHealthFixInjury = 75 -- When healing what's the minimum amount of health a player must have before an injury is fixed.

CH_AdvMedic.Config.BrokenLegWalkSpeed = 120 -- Changes the players walk speed when their leg is broken. Default in DarkRP is 160.
CH_AdvMedic.Config.BrokenLegRunSpeed = 160 -- Same as above but for run speed. Default in DarkRP is 240.

CH_AdvMedic.Config.InternalBleedingInterval = 3 -- Interval between bleedings taking damage from the player slowly.
CH_AdvMedic.Config.DamageFromBleedingMin = 3 -- Minimum amount of damage taken every time the player bleeds from injury.
CH_AdvMedic.Config.DamageFromBleedingMax = 7 -- Maximum amount of damage taken every time the player bleeds from injury.
CH_AdvMedic.Config.EnableBleedingHurtSounds = false -- Should the "im hurt" sounds be enabled when a person is bleeding from injury.

CH_AdvMedic.Config.DisallowedBrokenArmWeapons = { -- List of weapons that cannot be equipped with a broken arm!
	-- "m9k_coltpython",
	-- "m9k_colt1911",
	-- "m9k_usp",
	-- "m9k_hk45",
	-- "m9k_luger",
	-- "m9k_model500",
	-- "m9k_deagle",
	-- "m9k_glock",
	-- "m9k_m29satan",
	-- "m9k_m92baretta",
	-- "m9k_luger",
	-- "m9k_ragingbull",
	-- "m9k_scoped_taurus",
	-- "m9k_model3russian",
	-- "m9k_model627",
	-- "m9k_remington1858",
	-- "m9k_sig_p229r",
	-- "m9k_vector",
	-- "m9k_mp7",
	-- "m9k_honeybadger",
	-- "m9k_mp5",
	-- "m9k_bizonp19",
	-- "m9k_ump45",
	-- "m9k_usc",
	-- "m9k_kac_pdw",
	-- "m9k_magpulpdr",
	-- "m9k_mp40",
	-- "m9k_mp5sd",
	-- "m9k_mp9",
	-- "m9k_sten",
	-- "m9k_tec9",
	-- "m9k_thompson",
	-- "m9k_uzi",
	-- "m9k_smgp90",
	-- "m9k_winchester73",
	-- "m9k_acr",
	-- "m9k_ak47",
	-- "m9k_ak74",
	-- "m9k_amd65",
	-- "m9k_an94",
	-- "m9k_val",
	-- "m9k_f2000",
	-- "m9k_famas",
	-- "m9k_g36",
	-- "m9k_g3a3",
	-- "m9k_l85",
	-- "m9k_fal",
	-- "m9k_m14sp",
	-- "m9k_m16a4_acog",
	-- "m9k_m4a1",
	-- "m9k_m416",
	-- "m9k_scar",
	-- "m9k_tar21",
	-- "m9k_auga3",
	-- "m9k_val",
	-- "m9k_vikhr",
	-- "m9k_1887winchester",
	-- "m9k_dbarrel",
	-- "m9k_browningauto5",
	-- "m9k_jackhammer",
	-- "m9k_m3",
	-- "m9k_ithacam37",
	-- "m9k_mossberg590",
	-- "m9k_spas12",
	-- "m9k_striker12",
	-- "m9k_usas",
	-- "m9k_remington870",
	-- "m9k_1897winchester",
	-- "m9k_barret_m82",
	-- "m9k_m98b",
	-- "m9k_svt40",
	-- "m9k_svu",
	-- "m9k_dragunov",
	-- "m9k_intervention",
	-- "m9k_psg1",
	-- "m9k_aw50",
	-- "m9k_sl8",
	-- "m9k_m24",
	-- "m9k_remington7615p",
	-- "m9k_contender",
	-- "m9k_ied_detonator",
	-- "m9k_fg42",
	-- "m9k_m60",
	-- "m9k_minigun" -- NO COMMA ON THE LAST LINE!
}

-- Design Configuration
CH_AdvMedic.Config.Design.BackgroundColor = Color( 20, 20, 20, 230 )

CH_AdvMedic.Config.Design.HeaderColor = Color( 48, 151, 209, 125 )
CH_AdvMedic.Config.Design.HeaderOutline = Color( 0, 0, 0, 255 )

CH_AdvMedic.Config.Design.SecondHeaderColor = Color( 200, 0, 0, 125 )
CH_AdvMedic.Config.Design.SecondHeaderOutline = Color( 0, 0, 0, 255 )

CH_AdvMedic.Config.Design.ChargesLeftColor = Color( 48, 151, 209, 125 )
CH_AdvMedic.Config.Design.ChargesLeftOutline = Color( 0, 0, 0, 255 )

CH_AdvMedic.Config.Design.RechargeKeyColor = Color( 200, 0, 0, 125 )
CH_AdvMedic.Config.Design.RechargeKeyOutline = Color( 0, 0, 0, 255 )

CH_AdvMedic.Config.Design.BottomTextColor = Color( 48, 151, 209, 125 )
CH_AdvMedic.Config.Design.BottomTextOutline = Color( 0, 0, 0, 255 )

-- Alternative Gender Models
-- This is here so you can set genders for models male/female models that are not default from GMod. So that they will moan with the correct gender once dead.
-- If a gender is not defined it will return as a male always.
CH_AdvMedic.Config.AlternativeMaleModels = {
	"models/humans/male_gestures.mdl",
	"models/humans/male_postures.mdl",
	"models/humans/male_shared.mdl",
	"models/humans/male_ss.mdl"
}

CH_AdvMedic.Config.AlternativeFemaleModels = {
	"models/humans/female_gestures.mdl",
	"models/humans/female_postures.mdl",
	"models/humans/female_shared.mdl",
	"models/humans/female_ss.mdl"
}