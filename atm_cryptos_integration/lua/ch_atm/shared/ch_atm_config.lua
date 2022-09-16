CH_ATM = CH_ATM or {}
CH_ATM.Config = CH_ATM.Config or {}
CH_ATM.Currencies = CH_ATM.Currencies or {}

--[[
	Language Config
	English: en - Danish: da - French: fr - Spanish: es - Polish: pl - Turkish: tr - Russian: ru
--]]
CH_ATM.Config.Language = "es" -- Set the language of the script.

--[[
	Default Config
--]]
CH_ATM.Config.AccountStartMoney = 5000 -- How much money is there on a bank account when it's created?
CH_ATM.Config.ATMCurrency = "darkrp" -- What gamemode/currency do you want to store in the ATM? Supported are basewars, bricks_credit_store, darkrp, helix, mtokens, pointshop2, pointshop2_premium, santosrp, sh_pointshop, sh_pointshop_premium, underdone

CH_ATM.Config.NotificationTime = 8 -- Amount of seconds to show notifications
CH_ATM.Config.DistanceToScreen3D2D = 5000 -- Distance between the player and the 3d2d to draw

CH_ATM.Config.WalletLooseOnDeathPercentage = 0 -- How many percetange of the players wallet to loose on death (not bank account)? Set to 0 to disable.
CH_ATM.Config.MaximumToLooseOnDeath = 10000 -- How much money can a player maximum loose on death?
CH_ATM.Config.DropMoneyOnDeath = false -- Should the money lost be dropped on death? If true it will drop, if false they will just vanish.

CH_ATM.Config.ReplaceATMPropsOnMap = true -- Should we try to replace static ATM props with interactive ATM entities? Only works on some maps.

CH_ATM.Config.WithdrawToBankFromPrinter = false -- If you have a supported money printer and this enabled then you can withdraw directly from printer to your bank account.
CH_ATM.Config.SendPaycheckToBank = false -- If this is enabled then their paycheck will be sent directly to their bank account instead of wallet.

CH_ATM.Config.EnableResetAllAccounts = true -- Should super admins be allowed to reset all bank accounts?

--[[
	ATM Admin Config
--]]
CH_ATM.Config.AdminATMChatCommand = "!adminatm" -- Chat command to open ATM admin menu
CH_ATM.Config.EnableCustomAdminGroups = false -- Normally it just checks IsAdmin that works with all admin mods. If you want to specify your own usergroups then you can enable this.
CH_ATM.Config.CustomAdminGroups = { -- List of admin usergroups. Only applicable if above setting is enabled.
	["superadmin"] = true,
	["admin"] = true,
}

--[[
	ATM Config
--]]
CH_ATM.Config.ActivateWithCreditCard = false -- Should the ATM be activated by inserting the credit card? true to enable or false to activate with pressing E
CH_ATM.Config.FinePlayerIfForgetCard = true -- Should the player be fined if they forget their credit card in the ATM?
CH_ATM.Config.ForgetCardFee = 20 -- How much should they be fined for getting their credit card in the ATM?

CH_ATM.Config.SlideMoneyOutOfATM = false -- Should we spawn money and slide them in/out of the ATM on deposit/withdraw? If not it just adds directly to wallet.
CH_ATM.Config.OnlyOwnerCanTakeMoney = false -- Should we only allow the person that withdraws the money to be able to take the money that slides out of the ATM?

CH_ATM.Config.AllowKeyboardInputForKeypad = false -- Should the user be able to use their keyboard to input numbers/actions when the keypad is active?

CH_ATM.Config.PayoutMoneyToWalletIfMax = false -- If player receives money, but his bank reaches maximum then we can pay out the money to his wallet?

--[[
	ATM Color Config
--]]
CH_ATM.Config.ActiveColor = Color( 255, 255, 255, 255 ) -- The color we want the ATM sides to have when it is actively being used by someone
CH_ATM.Config.ActionSuccessfulColor = Color( 75, 174, 79, 255 ) -- The color the ATM gets for a few seconds when an action is successful (like deposit)
CH_ATM.Config.ActionUnsuccessfulColor = Color( 243, 66, 53, 255 ) -- The color the ATM gets for a few seconds when an action is NOT successful (like fail deposit)

CH_ATM.Config.EnableInactiveColor = false -- Should the ATM be lit up in a different color when inactive (not in use)?
CH_ATM.Config.InactiveColor = Color( 0, 0, 200, 255 ) -- The color we want the ATM sides to have when it is NOT being used by someone (if enabled)

CH_ATM.Config.OutOfOrderColor = Color( 243, 66, 53, 255 ) -- The color the ATM has when it is out of order (after a hack attempt)

--[[
	Teams Config
--]]
CH_ATM.Config.PoliceTeams = { -- The DarkRP team name that defines the police teams on your server (put the names as shown on your scoreboard).
	["Police Officer"] = true,
	["Police Chief"] = true,
}

CH_ATM.Config.CriminalTeams = { -- The DarkRP team name that defines who can hack/lockpick ATM's (put the names as shown on your scoreboard).
	["Ladron"] = true,
	["Hacker"] = true,
	["Ladron Profesional"] = true,
}

--[[
	Interest Config
	See more interest configs in ch_atm_config_upgrades.lua
--]]
CH_ATM.Config.InterestInterval = 600 -- Once a player joins this interval starts to count. Every x second it will generate a percentage interval based on the config.

CH_ATM.Config.InterestToTakeOnBankRobbery = 0.0005 -- SUPPORT FOR BANK ROBBERY 2 AND PVAULT How much interest to take from all players when bank is robbed
CH_ATM.Config.MoneyPercentToTakeOnBankRobbery = 0.002 -- SUPPORT FOR BANK ROBBERY 2 AND PVAULT How many percent of a players bank account money should we take from all players when bank is robbed

--[[
	ATM Hacking/Lockpicking
--]]
CH_ATM.Config.HackingTime = 60 -- How many seconds does it take to lockpick an ATM successfully

CH_ATM.Config.HackingPlayersRequired = 1 -- How many online players required to lockpick an ATM?
CH_ATM.Config.HackingPoliceOfficersRequired = 0 -- How many online players must be police officer in order to lockpick ATMs?

CH_ATM.Config.PlayerHackingCooldownTime = 1200 -- For how many seconds do we cooldown the player before they can lockpick any ATM again
CH_ATM.Config.ATMHackCooldownTime = 600 -- For how many seconds should the ATM be on cooldown after a hack (making it un-useable for everybody). 0 to disable.

CH_ATM.Config.MoneyRewardForHackingMin = 100 -- Minimum amount of money to be "rewarded" for hacking an ATM.
CH_ATM.Config.MoneyRewardForHackingMax = 10000 -- Maximum amount of money to be "rewarded" for hacking an ATM.

CH_ATM.Config.InterestToTakeForHacking = 0.0002 -- How much interest to take from all players when an ATM is hacked?

CH_ATM.Config.EmitSoundOnHacking = true -- Should we emit an alarm sound from the ATM once hacking begins?
CH_ATM.Config.TheAlarmSound = "ambient/_period.wav ambient/alarms/alarm1.wav" -- The alarm sound path
CH_ATM.Config.AlarmSoundVolume = 100 -- The volume the sound is emitted at

CH_ATM.Config.MakePlayerWantedOnHack = true -- Should we make the hacker wanted once he begins lockpicking the ATM?
CH_ATM.Config.PlayerWantedTime = 120 -- For how long should we make him wanted?

CH_ATM.Config.UnwantedAfterHacking = false -- Once hacking finishes (success or failed) do we make him unwanted?

CH_ATM.Config.KillHackerReward = 500 -- How much money is rewarded if a police officer kills a hacker?
CH_ATM.Config.ArrestHackerReward = 2000 -- How much money is rewarded if a police officer arrests a hacker?

--[[
	Credit Card / Terminal Config
--]]
CH_ATM.Config.DistanceToTerminal = 7000 -- Distance between player with a credit card and credit card scanner for it to swipe.
CH_ATM.Config.UseCreditCardDelay = 4 -- How many seconds delay on using your credit card? MINIMUM 3 SECONDS!

CH_ATM.Config.TerminalDefaultColor = Color( 255, 255, 255, 255 ) -- What color should the credit card terminal be by default?

--[[
	MySQLOO
	If you want to use MySQLOO then enable this config.
	Then go to lua/ch_atm/server/mysql/mysql_connect.lua and type in your sql credentials.
--]]
CH_ATM.Config.EnableSQL = false -- Enable or disable using SQL.

CH_ATM.Config.MaximumTransactionsToShow = 10 -- How many transactions should we maximum network to the player?

--[[
	XP SUPPORT
--]]
CH_ATM.Config.DarkRPLevelSystemEnabled = true -- DARKRP LEVEL SYSTEM BY vrondakis https://github.com/uen/Leveling-System
CH_ATM.Config.SublimeLevelSystemEnabled = false -- Sublime Levels by HIGH ELO CODERS https://www.gmodstore.com/market/view/6431
CH_ATM.Config.EssentialsXPSystemEnabled = false -- Brick's Essentials and/or DarkRP Essentials by Brickwall https://www.gmodstore.com/market/view/5352 & https://www.gmodstore.com/market/view/7244
CH_ATM.Config.EXP2SystemEnabled = false -- Elite XP SYstem (EXP2) By Axspeo https://www.gmodstore.com/market/view/4316
CH_ATM.Config.GlorifiedLevelingXPSystem = false -- GlorifiedLeveling by GlorifiedPig https://www.gmodstore.com/market/view/7254

CH_ATM.Config.SuccessfulHackXP = 20 -- Amount of XP given when a player successfully hacks an ATM.

CH_ATM.Config.KillingHackerMinXP = 20 -- Minimum amount of XP given for killing hacker.
CH_ATM.Config.KillingHackerMaxXP = 50 -- Maximum amount of XP given for killing hacker.

CH_ATM.Config.ArrestingHackerMinXP = 20 -- Minimum amount of XP given for arresting hacker.
CH_ATM.Config.ArrestingHackerMaxXP = 50 -- Maximum amount of XP given for arresting hacker.