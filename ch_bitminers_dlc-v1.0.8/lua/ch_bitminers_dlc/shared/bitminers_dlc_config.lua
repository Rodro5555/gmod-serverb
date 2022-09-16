CH_Bitminers_DLC = CH_Bitminers_DLC or {}
CH_Bitminers_DLC.Config = CH_Bitminers_DLC.Config or {}

-- Remote Tablet
CH_Bitminers_DLC.Config.BitminerLinkDistance = 5000 -- Distance between player with tablet and bitminer before they're allowed to connect.
CH_Bitminers_DLC.Config.UseIdleAnimation = false -- Should the tablet swep use the IDLE animation after equipped (wobs a bit on the screen when you stand still)

-- Bitminer Hacking
CH_Bitminers_DLC.Config.HackingUSBHealth = 25 -- Amount of health for the usb entity.
CH_Bitminers_DLC.Config.BitminerHackingTime = 7 -- Amount of seconds it takes to hack into a bitminer and gain access to the screen.
CH_Bitminers_DLC.Config.BitminerHackingDistance = 10000 -- Max distance between bitminer shelf and hacker to succeed hacking attempt.

CH_Bitminers_DLC.Config.HackingFailChance = 25 -- How high is the chance that a hacking attempt will fail? 25% fail chance by default.

-- Bitminer Repair Wrench
CH_Bitminers_DLC.Config.RepairMinHealth = 5 -- Minimum amount of health to heal when reparing a bitminer entity (left click)
CH_Bitminers_DLC.Config.RepairMaxHealth = 15 -- Maximum amount of health to heal when reparing a bitminer entity (THE VALUE IS RANDOMIZED) (left click)

CH_Bitminers_DLC.Config.ShowHealthDistance = 100 -- Distance between player with wrench and bitminer entities before health shows above ent.

-- Antivirus USB
CH_Bitminers_DLC.Config.AntivirusUSBHealth = 25 -- Amount of health for the usb entity.
CH_Bitminers_DLC.Config.AntivirusSecureTime = 10 -- How many seconds does it take the antivirus to secure the bitminer?

-- XP System Support
CH_Bitminers_DLC.Config.DarkRPLevelSystemEnabled = false -- DARKRP LEVEL SYSTEM BY vrondakis https://github.com/uen/Leveling-System
CH_Bitminers_DLC.Config.SublimeLevelSystemEnabled = false -- Sublime Levels by HIGH ELO CODERS https://www.gmodstore.com/market/view/6431
CH_Bitminers_DLC.Config.EXP2SystemEnabled = false -- Elite XP System (EXP2) by Axspeo https://www.gmodstore.com/market/view/4316

CH_Bitminers_DLC.Config.XPHackingReward = 25 -- Amount of experience to give on successfully hacking a bitminer.