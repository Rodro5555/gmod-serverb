CH_BankVault = CH_BankVault or {}
CH_BankVault.Config = CH_BankVault.Config or {}
CH_BankVault.Content = CH_BankVault.Content or {}
CH_BankVault.Design = CH_BankVault.Design or {}
CH_BankVault.CurrentRobbers = CH_BankVault.CurrentRobbers or { "NONE" }

-- General config options.
CH_BankVault.Config.StartMoney = 5000 -- Amount of money the bank will have from server startup. [Default = 1500]
CH_BankVault.Config.MoneyTimer = 60 -- This is the time that defines when money is added to the bank. In seconds! [Default = 60]
CH_BankVault.Config.MoneyOnTime = 1000 -- This is the amount of money to be added to the bank every x minutes/seconds. Defined by the setting above. [Default = 1000]
CH_BankVault.Config.Max = 175000 -- The maximum the bank can have. Set to 0 for no limit. [Default = 30000]

CH_BankVault.Config.AliveTime = 300 -- The amount of SECONDS the player must stay alive before he will receive what the bank has. [Default = 60 seconds]
-- If you own the transport dlc this is also the time the robbers needs to complete the heist/transport of the money in. If not, the mission will fail.

CH_BankVault.Config.CooldownTime = 600 -- The amount of SECONDS the bank is on a cooldown after a robbery! [Default = 600 (10 min)]
CH_BankVault.Config.PlayerLimit = 5 -- The amount of players there must be on the server before you can rob the bank. [Default = 5]
CH_BankVault.Config.PoliceRequired = 3 -- The amount of police officers there must be before a person can rob the bank. [Default = 3]

CH_BankVault.Config.RobberyDistance = 300000 -- The amount of space the player can move away from the armory entity, before the robbery fails. [Default = 300000]
CH_BankVault.Config.DropMoneyOnSucces = false -- Should money drop from the bank when a robbery is successful? true/false option. [Default = false]

CH_BankVault.Config.KillReward = 1750 -- The amount of money a person is rewarded for killing the bank robber. [Default = 1750]
CH_BankVault.Config.RobbersCanJoin = 300 -- Amount of seconds before robbers are no longer able to join a robbery after it has first been started. [Default = 120 (2 minutes)]

-- Alarm Sound Configs
CH_BankVault.Config.EmitSoundOnRob = true -- Should an alarm go off when the bank vault gets robbed. [Default = true]
CH_BankVault.Config.TheSound = "ambient/alarms/alarm_citizen_loop1.wav" -- The sound to be played. [Default = ambient/alarms/alarm1.wav - default gmod sound]
CH_BankVault.Config.SoundVolume = 100 -- The sound volume for the alarm sound. [Default = 100] -- AVAILABLE VALUES https://wiki.facepunch.com/gmod/Enums/SNDLVL
CH_BankVault.Config.SoundDuration = 20 -- Amount of seconds the sound should play for. [Default = 20]

CH_BankVault.Config.AllowedTeams = { -- These are the teams that are allowed to rob the bank.
	["Ladron"] = true,
	["Ladron Profesional"] = true,
	["Mafia Italiana"] = true,
	["Mafia Rusa"] = true -- THE LAST LINE SHOULD NOT HAVE A COMMA AT THE END. BE AWARE OF THIS WHEN EDITING THIS!
}

--[[
	XP SUPPORT
--]]
CH_BankVault.Config.DarkRPLevelSystemEnabled = true -- DARKRP LEVEL SYSTEM BY vrondakis https://github.com/uen/Leveling-System
CH_BankVault.Config.SublimeLevelSystemEnabled = false -- Sublime Levels by HIGH ELO CODERS https://www.gmodstore.com/market/view/6431
CH_BankVault.Config.EssentialsXPSystemEnabled = false -- Brick's Essentials and/or DarkRP Essentials by Brickwall https://www.gmodstore.com/market/view/5352 & https://www.gmodstore.com/market/view/7244
CH_BankVault.Config.EXP2SystemEnabled = false -- Elite XP SYstem (EXP2) By Axspeo https://www.gmodstore.com/market/view/4316
CH_BankVault.Config.GlorifiedLevelingXPSystem = false -- GlorifiedLeveling by GlorifiedPig https://www.gmodstore.com/market/view/7254

CH_BankVault.Config.SuccessfulBankRobberyMinXP = 20 -- Amount of XP given when succesfully robbing the bank (minimum amount)
CH_BankVault.Config.SuccessfulBankRobberyMaxXP = 50 -- Amount of XP given when succesfully robbing the bank (maximum amount). The amount is randomized between these two values.

CH_BankVault.Config.KillingRobberMinXP = 20 -- Amount of XP given when killing a robber (minimum amount)
CH_BankVault.Config.KillingRobberMaxXP = 50 -- Amount of XP given when killing a robber (maximum amount). The amount is randomized between these two values.