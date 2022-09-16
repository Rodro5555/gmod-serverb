--[[---------------------------------------------------------
	Pay Phones
------------------------------------------------------------]]
-- How much does it costs to call the Emergency Services with the pay phone?
EmergencyDispatch.PriceToCallPayPhone = 30

-- What is the currency of your server?
EmergencyDispatch.ServerCurrency = "$"

-- Write 'logo' to draw the Emergency Services Logo above the pay phone;
-- Write 'price' to draw the price to call the Emergency Services;
-- Write 'none' to draw nothing.
EmergencyDispatch.DrawSomethingAbovePayPhone = "logo"

--[[-------------------------------------------------------------------------
   General Configuration
---------------------------------------------------------------------------]]
-- Command to call the police.
EmergencyDispatch.DispatchCallouts.Command = "/911"

-- Time to call the cops again, in seconds.
EmergencyDispatch.DispatchCallouts.CallCooldown = 20

-- Write the speed name of your country, it can be MPH - RPM - KM/H or other..
EmergencyDispatch.VelocityName = "KM/H"

-- The localisation or city/county of your server ?
EmergencyDispatch.GeographicLocation = "Buenos Aires"

-- KEY_E is the default key to open the backup menu, but you can change it with this website : https://wiki.facepunch.com/gmod/Enums/KEY
-- Here is the key to press as a cop to active the radio menu.
EmergencyDispatch.BackupOptionsMenuKey = KEY_E

-- KEY_F7 is the default key to open the backup menu, but you can change it with this website : https://wiki.facepunch.com/gmod/Enums/KEY
-- Here is the key to press as a cop in a vehicle.
EmergencyDispatch.BackupOptionsMenuKey_InVehicle = KEY_F7

-- KEY_F6 is the default key to active the panic-button, but you can change it with this website : https://wiki.facepunch.com/gmod/Enums/KEY
EmergencyDispatch.PanicButtonKey = KEY_F6

-- Add a chat command to active the panicbutton.
-- Write "none" if you do not want that.
EmergencyDispatch.DispatchCallouts.PanicButton_Bind = "/panic"

--[[
Seven Languages are available, select one of them:
	Chinese
	English
	French
	Russian
	Spanish
	German
	Polish
    Turkish
]]
EDLang.Settings = "Spanish"

--[[-------------------------------------------------------------------------
   True/False Configuration
---------------------------------------------------------------------------]]
-- Wether or not a blur effect is drawn in the menu?
EmergencyDispatch.DrawBlurOnMenu = true

-- Does your gamemode is a DarkRP ? If false it will block the wanted/unwanted and warrant functions!
EmergencyDispatch.DoesDarkRPGM = true

-- Write true if don't want to wait 7s during the call with the 911.
EmergencyDispatch.InstantEmergencyCall = true

-- Do you want to write a reason when you're chasing a vehicle with the vehicle tools ?
EmergencyDispatch.TypingReasonForAChase = false

-- Does your policemen can active their panic-buttons?
EmergencyDispatch.ActivatePanicButton = true

-- Does a player must be alive to call the 911 services?
EmergencyDispatch.MustBeAliveToCallEmergency = true

-- Play a sound when the vehicle owner is wanted?
EmergencyDispatch.VehicleIdentifier_PlaySoundWhenWanted = true

--[[
    I can understand that the sound of the panic button might be extreme, so you can regule it, with three status:

    - sound_and_voice: As shown in the demonstration video. ( Sound + Officer Voice ) 
    - sound_only: Just the bips sounds.
    - none: No sound.
]]
EmergencyDispatch.PanicButtonSoundStat = "sound_only"

--> Players in these jobs won't be able to call the 911:
EmergencyDispatch.BlacklistedJobs = {
    -- ["Blacklisted Job 1"] = true,
    -- ["Blacklisted Job 2"] = true
}

--> Write here the medical jobs names of your server:
EmergencyDispatch.MedicJobs = {
    ["Medic"] = true,
    ["Chief Medic"] = true
}

--> Write here the firefighters jobs names of your server:
EmergencyDispatch.FirefightersJobs = {
    ["Firefighter"] = true, 
    ["Chief Firefighter"] = true
}

EmergencyDispatch.RadioBackupButtons = {
    {
        Name = "Todas las patrullas disponibles",
        Jobs = "CP"
    },
    {
        Name = "Servicio médico", 
        Jobs = { "Medico", "Paramedico" }
    },
    -- {
    --     Name = "Cuerpo de Bomberos", 
    --     Jobs = { "Firefighter", "Chief Firefighter" }
    -- },
    {
        Name = "Servicios de avería", 
        Jobs = { "Mecanico" }
    },
}