
--[[
 _____           _ _     _   _          _    _                 _            _   _            
| ___ \         | (_)   | | (_)        | |  | |               | |          | | | |           
| |_/ /___  __ _| |_ ___| |_ _  ___    | |  | | ___   ___   __| | ___ _   _| |_| |_ ___ _ __ 
|    // _ \/ _` | | / __| __| |/ __|   | |/\| |/ _ \ / _ \ / _` |/ __| | | | __| __/ _ \ '__|
| |\ \  __/ (_| | | \__ \ |_| | (__    \  /\  / (_) | (_) | (_| | (__| |_| | |_| ||  __/ |   
\_| \_\___|\__,_|_|_|___/\__|_|\___|    \/  \/ \___/ \___/ \__,_|\___|\__,_|\__|\__\___|_|   

]]

-------------------------------------------------------------------------------------------------------------------
------------------------------------------ Main Configuration ----------------------------------------------------- 
-------------------------------------------------------------------------------------------------------------------

Realistic_Woodcutter = Realistic_Woodcutter or {}

Realistic_Woodcutter.Lang = "es" -- You can Choose fr , en 

Realistic_Woodcutter.WeaponAxe = "rwc_swep_axe" -- Change the weapon to cut the tree 

Realistic_Woodcutter.DamageAxe = 5 -- Damage of the Rwc Axe 

Realistic_Woodcutter.SwepActivate = true -- Use Swep (true) or Gravity Gun (false)

Realistic_Woodcutter.JobTable = {
    ["Leñador"] = true, 
}

Realistic_Woodcutter.AdminTable = {
    ["superadmin"] = true, 
    ["admin"] = true, 
}

-------------------------------------------------------------------------------------------------------------------
--------------------------------------- Configuration PnjSeller ---------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

Realistic_Woodcutter.ModelPnjSeller = "models/breen.mdl" -- Set the model of the PnjSeller
 
Realistic_Woodcutter.NamePnjSeller = "NPC de Leñador" -- Set the name of the PnjSeller

Realistic_Woodcutter.TextTopAxe = "Hacha de Leñador" -- Set the Top-Text of the PnjSeller

Realistic_Woodcutter.Take_Axe_Price = 70 -- the price of the axe on pnj

Realistic_Woodcutter.Sell_CutLog = 250 -- The price of one CuttedLog (*18)

Realistic_Woodcutter.Sell_Plank = 900 -- The price of one plank (*18)

-------------------------------------------------------------------------------------------------------------------
--------------------------------------- Configuration CarDealer ---------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

Realistic_Woodcutter.ModelCarDealer = "models/breen.mdl" -- Set the model of the CarDealer

Realistic_Woodcutter.NameCarDealer = "Vendedor de Auto para Leñador" -- Set the name of the CarDealer

Realistic_Woodcutter.TextTopCarDealer = "Vendedor de Auto para Leñador" -- Set the Top-Text of the CarDealer

-------------------------------------------------------------------------------------------------------------------
------------------------------------------ Configuration Tree ----------------------------------------------------- 
-------------------------------------------------------------------------------------------------------------------

Realistic_Woodcutter.TimeforLog = 1 -- the time the tree takes to turn into a log

Realistic_Woodcutter.Respawn = 280 -- the Time the tree takes to respawn 

Realistic_Woodcutter.Stage1 = 1 -- the number of shots to pass the stage 1

Realistic_Woodcutter.Stage2 = 1 -- the number of shots to pass the stage 2

Realistic_Woodcutter.Stage3 = 1 -- the number of shots to pass the stage 3

Realistic_Woodcutter.Stage4 = 1 -- the number of shots to pass the stage 4

Realistic_Woodcutter.Stage5 = 1 -- the number of shots to pass the stage 5

-------------------------------------------------------------------------------------------------------------------
------------------------------------------   ChainSaw System  ----------------------------------------------------- 
-------------------------------------------------------------------------------------------------------------------

-- We create a system when the tree falls it does not disappear right away you have to use a chainsaw 
-- Addon ChainSaw : https://steamcommunity.com/sharedfiles/filedetails/?id=582366370

Realistic_Woodcutter.ActivateChainSaw = false -- Activate the ChainSaw system 

Realistic_Woodcutter.ChainSaw = "tfa_nmrih_chainsaw" -- The weapon how can cut the tree 

Realistic_Woodcutter.PriceChainSaw = 250 -- The price of the ChainSaw 

Realistic_Woodcutter.ChainSawTreehealth = 100 -- the health of the fall tree 

-------------------------------------------------------------------------------------------------------------------
---------------------------------------- Configuration Debarker ---------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

Realistic_Woodcutter.Debarker_Timer = 30 -- in seconds

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------



