CH_PoliceArmory = {}
-- Section one. Handles money in the armory.
ARMORY_MONEY_MoneyTimer = 60 -- This is the time that defines when money is added to the armory. In seconds! [Default = 60 (1 Minute)]
ARMORY_MONEY_MoneyOnTime = 250 -- This is the amount of money to be added to the armory every x minutes/seconds. Defined by the setting above. [Default = 2500]
ARMORY_MONEY_Max = 50000 -- The maximum amount of money the armory can have. Set to 0 for no limit. [Default = 50000]

-- Section two. Handles the ammonition part.
ARMORY_AMMO_AmmoTimer = 240 -- This is the time that defines when ammo is added to the armory. In seconds! [Default = 240 (4 Minutes)]
ARMORY_AMMO_AmmoOnTime = 5 -- This is the amount of ammo to be added to the armory every x minutes/seconds. Defined by the setting above. [Default = 5]
ARMORY_AMMO_Max = 0 -- The maximum amount of ammo the armory can have. Set to 0 for no limit. [Default = 100]

-- Section tree. Handles the shitment part.
ARMORY_SHIPMENTS_ShipmentsTimer = 360 -- This is the time that defines when shipments are added to the armory. In seconds! [Default = 360 (6 Minutes)]
ARMORY_SHIPMENTS_ShipmentsOnTime = 1 -- This is the amount of shipments to be added to the armory every x minutes/seconds. Defined by the setting above. [Default = 1]
ARMORY_SHIPMENTS_Max = 5 -- The maximum amount of shipments the armory can have. Set to 0 for no limit. [Default = 5]
ARMORY_SHIPMENTS_Amount = 10 -- Amount of weapons inside of one shipment. [Default = 10]

-- General settings.
ARMORY_Custom_AliveTime = 5 -- The amount of MINUTES the player must stay alive before he will receive what the armory has. IN MINUTES! [Default = 5]
ARMORY_Custom_CooldownTime = 20 -- The amount of MINUTES the armory is on a cooldown after a robbery! (Doesn't matter if the robbery failed or not) [Default = 20]
ARMORY_Custom_RobberyDistance = 500 -- The amount of space the player can move away from the armory entity, before the robbery fails. [Default = 500]
ARMORY_Custom_PlayerLimit = 5 -- The amount of players there must be on the server before you can rob the armory. [Default = 5]
ARMORY_Custom_KillReward = 2200 -- The amount of money a person is rewarded for killing the armory robber. [Default = 2500]
ARMORY_Custom_PoliceRequired = 2 -- The amount of police officers there must be before a person can rob the armory. [Default = 3]

ARMORY_AllowedTeams = { -- These are the teams that are allowed to rob the armory.
	"Ladron Profesional",
	"Terrorista",
	"Lider de Resistencia",
	"Ladron" -- THE LAST LINE SHOULD NOT HAVE A COMMA AT THE END. BE AWARE OF THIS WHEN EDITING THIS!
}

-- Design options for the armory entity display.
ARMORY_DESIGN_ArmoryTextColor = Color(60, 60, 60, 255)
ARMORY_DESIGN_ArmoryTextBoarder = Color(0,0,0,255)

ARMORY_DESIGN_CooldownTextColor = Color(60, 60, 60, 255)
ARMORY_DESIGN_CooldownTextBoarder = Color(0,0,0,255)

ARMORY_DESIGN_CountdownTextColor = Color(60, 60, 60, 255)
ARMORY_DESIGN_CountdownTextBoarder = Color(0,0,0,255)

ARMORY_DESIGN_CooldownTimerTextColor = Color(150, 150, 150, 255)
ARMORY_DESIGN_CooldownTimerTextBoarder = Color(0,0,0,255)

ARMORY_DESIGN_CountdownTimerTextColor = Color(150, 150, 150, 255)
ARMORY_DESIGN_CountdownTimerTextBoarder = Color(0,0,0,255)

ARMORY_DESIGN_ScreenColor = Color( 60, 60, 60, 200 )
ARMORY_DESIGN_ScreenBoxColor = Color( 1, 1, 1, 200 )

ARMORY_DESIGN_MoneyTextColor = Color(60, 100, 60, 255)
ARMORY_DESIGN_MoneyTextBoarder = Color(0,0,0,255)

ARMORY_DESIGN_AmmoTextColor = Color(60, 60, 100, 255)
ARMORY_DESIGN_AmmoTextBoarder = Color(0,0,0,255)

ARMORY_DESIGN_ShipmentsTextColor = Color(100, 60, 60, 255)
ARMORY_DESIGN_ShipmentsTextBoarder = Color(0,0,0,255)

ARMORY_DESIGN_TheYes = Color( 0, 153, 0, 255 )
ARMORY_DESIGN_TheNo = Color( 153, 0, 0, 255 )
ARMORY_DESIGN_TheBoarder = Color( 0, 0, 0, 255 )

-- Weapon armory configuration.
ARMORY_WEAPONS_LIST = {
	[1] = {
		["name"] = "HK MP7",
		["wepname"] = "m9k_mp7",
		["ammotype"] = "m9k_ammo_smg",
		["ammo"] = 60,
		["model"] = "models/weapons/w_mp7_silenced.mdl"
	},
	[2] = {
		["name"] = "MP9",
		["wepname"] = "m9k_mp9",
		["ammotype"] = "m9k_ammo_smg",
		["ammo"] = 60,
		["model"] = "models/weapons/w_brugger_thomet_mp9.mdl"
	},
	[3] = {
		["name"] = "AAC Honeybadger",
		["wepname"] = "m9k_honeybadger",
		["ammotype"] = "m9k_ammo_smg",
		["ammo"] = 60,
		["model"] = "models/weapons/w_aac_honeybadger.mdl"
	}
}

ARMORY_WEAPON_Cooldown = 1 -- Amount of minutes between being able to retrieve a weapon from the police armory as a government official. [Default = 5]
ARMORY_WEAPON_ArmorAmount = 100 -- How much armor should the police jobs get when they press E on the armory. [Default = 100]
ARMORY_WEAPON_Enabled = true -- Should the weapon armory for police jobs be enabled or not? true/false option. [Default = true]
