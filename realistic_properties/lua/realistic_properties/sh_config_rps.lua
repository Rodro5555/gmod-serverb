-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
--[[
 _____           _ _     _   _       ______                          _   _           
| ___ \         | (_)   | | (_)      | ___ \                        | | (_)          
| |_/ /___  __ _| |_ ___| |_ _  ___  | |_/ / __ ___  _ __   ___ _ __| |_ _  ___  ___ 
|    // _ \/ _` | | / __| __| |/ __| |  __/ '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
| |\ \  __/ (_| | | \__ \ |_| | (__  | |  | | | (_) | |_) |  __/ |  | |_| |  __/\__ \
\_| \_\___|\__,_|_|_|___/\__|_|\___| \_|  |_|  \___/| .__/ \___|_|   \__|_|\___||___/                          

]]
-------------------------------------------------------------------------------------------------------------------
------------------------------------------ Main Configuration ----------------------------------------------------- 
-------------------------------------------------------------------------------------------------------------------

Realistic_Properties = Realistic_Properties or {}

Realistic_Properties.Lang = "es" -- You can Choose fr , en , de, pl , ru , pt , tr , cn

Realistic_Properties.TypeProperties = { -- Type of Properties
    "Casa",
    "Apartamento",
    "Actividad",
    "Hangar",
    "Almacen",
    "Restaurante",
    "Comercio",
}

Realistic_Properties.UseCustomNotify = true -- Do you want to use custom notify

Realistic_Properties.Sell = 50 -- Pourcent that recive player when he sell Property (%) 

Realistic_Properties.TimeToDelivery = 2 -- Time to delivery your entity (seconds)

Realistic_Properties.DayEqual = 1 -- If day = 1 (24h) , day = 0.5 (12h)

Realistic_Properties.MaxProperties = 2 -- How Much properties can buy player 

Realistic_Properties.NameDeliveryEnterprise = "FedEx" -- Name of the properties which delivery 

Realistic_Properties.CommandModification = "/rpsconfig" -- Command for the configuration of property 

Realistic_Properties.DistanceEnt = 200 -- Distance to spawn the entity which was delivery 

Realistic_Properties.Package = 3 -- How much order can do the player

Realistic_Properties.NameNpc = "Vendedor de Propiedades" -- Name of the NPC

Realistic_Properties.DoorsLock = true -- If all doors which is in the data was lock 

Realistic_Properties.EntitiesRemove = true -- If when the property was sell the entities are removed

Realistic_Properties.DeliverySystem = false -- true == Activate / false == Desactivate

Realistic_Properties.SaveProps = true -- Save props when the property is rented 

Realistic_Properties.SpawnProps = true -- Desactivate = false / Activate = true spawn props outside property

Realistic_Properties.MaxRentalDay = 5 -- Max Rental Day

Realistic_Properties.PropertyPermanent = true -- When you buy a property does it's permanent ?

Realistic_Properties.PourcentRent = 100 -- Pourcent per Day of rent 

Realistic_Properties.ModelOfTheBox = "models/kobralost/case/caseveeds.mdl" -- Model of the Delivery Box 

Realistic_Properties.Activate3D2DNpc = true -- Activate / Desactivate the 3D2D of the npc 

Realistic_Properties.Activate3D2DComputer = false -- Activate / Desactivate the 3D2D of the computer

Realistic_Properties.HudDoor = true -- Activate/Desactivate the HUD on the door  

Realistic_Properties.PlayerSeeOwner = true -- If the player can see the owner of the door  

Realistic_Properties.AdminCanSpawnProps = true -- If admins can spawn props outside his property 

Realistic_Properties.DefaultTheme = "darktheme" -- You can choose darktheme/lighttheme

Realistic_Properties.OverridingF2 = false -- If you want than the player can't buy/sell property with f2 

Realistic_Properties.CanBuyPropertyWithF2 = false  -- When you buy a property with f2 all door will be buy
 
Realistic_Properties.PropsDelivery = false -- Delivery system for the props 

Realistic_Properties.PriceProps = 10 -- Price when you try to spawn a props with the props delivery system

Realistic_Properties.EntityWhitelist = { -- Here you can put class of all entity which can be bought directly and not with the delivery system
    ["money_printer"] = true
}

Realistic_Properties.JobCanSpawnProps = { -- Which job can spawn props outside his property when the Realistic_Properties.SpawnProps = false 
    ["Civil Protection Chef"] = true,
    ["Civil Protection"] = true
}

Realistic_Properties.PropertiesDelivery = true -- If when the player don't have property he can buy an entity ( The entity will spawn on him )

Realistic_Properties.BuyEntitiesWithoutProperties = { -- Which job can buy entities without property when Realistic_Properties.PropertiesDelivery = false
    ["Civil Protection Chef"] = true,
    ["Scientific Police"] = true
}

Realistic_Properties.AdminRank = { -- Admin rank 
    ["superadmin"] = true,
    ["admin"] = true
}

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
