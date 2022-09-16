     
--[[
 _____            _ _     _   _        _____      _ _             _____           _                 
|  __ \          | (_)   | | (_)      |  __ \    | (_)           / ____|         | |                
| |__) |___  __ _| |_ ___| |_ _  ___  | |__) |__ | |_  ___ ___  | (___  _   _ ___| |_ ___ _ __ ___  
|  _  // _ \/ _` | | / __| __| |/ __| |  ___/ _ \| | |/ __/ _ \  \___ \| | | / __| __/ _ \ '_ ` _ \ 
| | \ \  __/ (_| | | \__ \ |_| | (__  | |  | (_) | | | (_|  __/  ____) | |_| \__ \ ||  __/ | | | | |
|_|  \_\___|\__,_|_|_|___/\__|_|\___| |_|   \___/|_|_|\___\___| |_____/ \__, |___/\__\___|_| |_| |_|
                                                                                                                                                  
--]]


Realistic_Police = Realistic_Police or {}
Realistic_Police.PlateConfig = Realistic_Police.PlateConfig or {}
Realistic_Police.Application = Realistic_Police.Application or {}
Realistic_Police.PlateVehicle = Realistic_Police.PlateVehicle or {}
Realistic_Police.FiningPolice = Realistic_Police.FiningPolice or {}
Realistic_Police.Trunk = Realistic_Police.Trunk or {}
Realistic_Police.TrunkPosition = Realistic_Police.TrunkPosition or {}
 
-----------------------------------------------------------------------------
---------------------------- Main Configuration------------------------------
-----------------------------------------------------------------------------

Realistic_Police.Lang = "es" -- You can choose fr , en , tr , cn 

Realistic_Police.DefaultJob = true -- Default Job Activate/Desactivate (Camera Repairer )

Realistic_Police.TrunkSystem = true -- Do you want to use the trunk system ? 

Realistic_Police.KeyOpenTablet = KEY_I -- Key for open the tablet into a vehicle  

Realistic_Police.WantedMessage = "Buscado" -- Message when you wanted someone with the computer 

Realistic_Police.StungunAmmo = 40 

Realistic_Police.CanConfiscateWeapon = true -- If the functionality for confiscate is activate or desactivate

Realistic_Police.UseDefaultArrest = false 

Realistic_Police.UseDarkRPNotify = false -- if you want to use the darkrp notification

Realistic_Police.CameraUpdateRate = 0.5 -- Update rate to optimise caméra

Realistic_Police.AdminRank = { -- Rank Admin 
    ["superadmin"] = true,
    ["admin"] = true, 
}

Realistic_Police.Hackers = { -- Which are not able to use the computer without hack the computer 
    ["Ladron"] = true, 
    ["Ladron Profesional"] = true, 
}

Realistic_Police.PoliceVehicle = { -- Police Vehicle
    ["sierratdm"] = true,
    ["Chevrolet Tahoe - RAID"] = true, 
}

Realistic_Police.TrunkPosition["Chevrolet Tahoe - RAID"] = {
    ["Pos"] = Vector(0,0,0),
    ["Ang"] = Angle(0,0,0),
}

Realistic_Police.RankSystem = false
-----------------------------------------------------------------------------
------------------------- Computer Configuration-----------------------------
-----------------------------------------------------------------------------

Realistic_Police.MaxReport = 5 -- Max report per persson

Realistic_Police.MaxCriminalRecord = 30 -- Max Criminal Record per persson 

Realistic_Police.Application[1] = { -- Unique Id 
    ["Name"] = "Internet", -- Name of the Application 
    ["Materials"] = Material("rpt_internet.png"), -- Material of the Application 
    ["Function"] = Realistic_Police.FireFox, -- Function Application 
    ["Type"] = "police",  
}

Realistic_Police.Application[2] = { -- Unique Id 
    ["Name"] = "Camara", -- Name of the Application 
    ["Materials"] = Material("rpt_cctv.png"), -- Material of the Application    
    ["Function"] = Realistic_Police.Camera, -- Function Application 
    ["Type"] = "police",  
}

Realistic_Police.Application[3] = { -- Unique Id 
    ["Name"] = "Antecedentes penales", -- Name of the Application 
    ["Materials"] = Material("rpt_law.png"), -- Material of the Application 
    ["Function"] = Realistic_Police.CriminalRecord, -- Function Application 
    ["Type"] = "police",  
}

Realistic_Police.Application[4] = { -- Unique Id
    ["Name"] = "Menú de Informes", -- Name of the Application 
    ["Materials"] = Material("rpt_cloud.png"), -- Material of the Application   
    ["Function"] = Realistic_Police.ReportMenu, -- Function application 
    ["Type"] = "police",  
}

Realistic_Police.Application[5] = { -- Unique Id 
    ["Name"] = "Lista de Informes", -- Name of the Application 
    ["Materials"] = Material("rpt_documents.png"), -- Material of the Application  
    ["Function"] = Realistic_Police.ListReport, -- Function Application 
    ["Type"] = "police",   
}

Realistic_Police.Application[6] = { -- Unique Id 
    ["Name"] = "Placa", -- Name of the Application  
    ["Materials"] = Material("rpt_listreport.png"), -- Material of the Application  
    ["Function"] = Realistic_Police.License, -- Function Application 
    ["Type"] = "police",  
}

Realistic_Police.Application[7] = { -- Unique Id 
    ["Name"] = "Consola de la computadora", -- Name of the Application  
    ["Materials"] = Material("rpt_cmd.png"), -- Material of the Application  
    ["Function"] = Realistic_Police.Cmd, -- Function Application  
    ["Type"] = "hacker", 
}

-----------------------------------------------------------------------------
--------------------------- Plate Configuration------------------------------
-----------------------------------------------------------------------------

Realistic_Police.PlateActivate = true -- If Module plate is activate

Realistic_Police.LangagePlate = "us" -- You can choose eu or us

Realistic_Police.PlateConfig["us"] = { 
    ["Image"] = Material("rpt_plate_us.png"), -- Background of the plate 
    ["ImageServer"] = nil, -- Image server or Image of the department 
    ["TextColor"] = Color(24, 55, 66), -- Color Text of the plate 
    ["Country"] = "ARIZONA", -- Country Name 
    ["CountryPos"] = {2, 5}, -- The pos of the text 
    ["CountryColor"] = Color(26, 134, 185), -- Color of the country text 
    ["Department"] = "",  
    ["PlatePos"] = {2, 1.5}, -- Plate Pos 
    ["PlateText"] = false, -- AABCDAA
}

Realistic_Police.PlateConfig["eu"] = { 
    ["Image"] = Material("rpt_plate_eu.png"), -- Background of the plate  
    ["ImageServer"] = Material("rpt_department_eu.png"), -- Image server or Image of the department 
    ["TextColor"] = Color(0, 0, 0, 255), -- Color Text of the plate 
    ["Country"] = "F", -- Country Name 
    ["CountryPos"] = {1.065, 1.4}, -- The pos of the text 
    ["CountryColor"] = Color(255, 255, 255), -- Color of the country text 
    ["Department"] = "77", -- Department 
    ["PlatePos"] = {2, 2}, -- Plate Pos 
    ["PlateText"] = true, -- AA-BCD-AA
}

Realistic_Police.PlateVehicle["crsk_alfaromeo_8cspider"] = "us" 

--Realistic_Police.PlateVehicle["class"] = "nameplate"

-----------------------------------------------------------------------------
---------------------------- Trunk Configuration-----------------------------
-----------------------------------------------------------------------------

Realistic_Police.KeyForOpenTrunk = KEY_E -- https://wiki.facepunch.com/gmod/Enums/KEY

Realistic_Police.KeyTrunkHUD = true -- Activate/desactivate the hud of the vehicle 

Realistic_Police.VehiclePoliceTrunk = {
    ["Airboat"] = true, 
    ["Jeep"] = true, 
}

Realistic_Police.MaxPropsTrunk = 10 -- Max props trunk 

Realistic_Police.Trunk["models/props_wasteland/barricade002a.mdl"] = {
    ["GhostPos"] = Vector(0,0,35),
    ["GhostAngle"] = Vector(0,0,0),
}

Realistic_Police.Trunk["models/props_wasteland/barricade001a.mdl"] = {
    ["GhostPos"] = Vector(0,0,30),
    ["GhostAngle"] = Vector(0,0,0),
}

Realistic_Police.Trunk["models/props_junk/TrafficCone001a.mdl"] = {
    ["GhostPos"] = Vector(0,0,16),
    ["GhostAngle"] = Vector(0,0,0),
}

Realistic_Police.Trunk["models/props_c17/streetsign004f.mdl"] = {
    ["GhostPos"] = Vector(0,0,12),
    ["GhostAngle"] = Vector(0,0,0),
}

Realistic_Police.Trunk["models/props_c17/streetsign001c.mdl"] = {
    ["GhostPos"] = Vector(0,0,12),
    ["GhostAngle"] = Vector(0,0,0),
}

-----------------------------------------------------------------------------
-------------------------- HandCuff Configuration----------------------------
-----------------------------------------------------------------------------

Realistic_Police.MaxDay = 2 -- Max Jail Day 

Realistic_Police.DayEqual = 60 -- 1 day = 60 Seconds 

Realistic_Police.PriceDay = 5000 -- Price to pay with the bailer per day 

Realistic_Police.JailerName = "Npc Carcelero" -- Jailer Name 

Realistic_Police.BailerName = "Npc Fianzas" -- Bailer Name 

Realistic_Police.SurrenderKey = KEY_T -- The key for surrender 

Realistic_Police.SurrenderInfoKey = "T" -- The Key 

Realistic_Police.SurrenderActivate = true 

Realistic_Police.CantConfiscate = { -- Tools which can't be confiscated
    ["gmod_tool"] = true,
    ["weapon_physgun"] = true, 
    ["gmod_camera"] = true, 
    ["weapon_physcannon"] = true, 
    ["keys"] = true,
    ["inventory"] = true,
    ["weapon_fists"] = true,
    ["weapon_ch_atm_card"] = true,
    ["climb_swep3"] = true,
}

-----------------------------------------------------------------------------
--------------------------- Camera Configuration-----------------------------
-----------------------------------------------------------------------------

Realistic_Police.CameraHealth = 50 -- Health of the Camera 

Realistic_Police.CameraRestart = 60 -- Camera restart when they don't have humans for repair 

Realistic_Police.CameraRepairTimer = 10 -- Time to repair the camera 10s 

Realistic_Police.CameraBrokeHud = true -- If when a camera was broken the Camera Worker have a Popup on his screen 

Realistic_Police.CameraBroke = true -- if camera broke sometime when a camera repairer is present on the server 

Realistic_Police.CameraWorker = { -- Job which can repair the camera 
    ["Administrador de Cámaras"] = true
}

Realistic_Police.CameraGiveMoney = 500 -- Money give when a player repair a camera 

-----------------------------------------------------------------------------
---------------------------- Fining System ----------------------------------
-----------------------------------------------------------------------------

Realistic_Police.PlayerWanted = true -- if the player is wanted when he doesn't pay the fine 

Realistic_Police.PourcentPay = 10 -- The amount pourcent which are give when the player pay the fine 

Realistic_Police.MaxPenalty = 2 -- Maxe Penalty on the same player 

Realistic_Police.VehicleCantHaveFine = { -- Which vehicle can't receive fine 
    ["lam_reventon_lw"] = false,
    ["sierratdm"] = true, 
}

Realistic_Police.FiningPolice[1] = { 
    ["Name"] = "Voyeurismo", -- Unique Name is require 
    ["Price"] = 1000,
    ["Vehicle"] = false, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[2] = { 
    ["Name"] = "Llamadas de broma", -- Unique Name is require 
    ["Price"] = 1500,
    ["Vehicle"] = false, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[3] = { 
    ["Name"] = "Resistiendo el arresto", -- Unique Name is require 
    ["Price"] = 2500,
    ["Vehicle"] = false, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[4] = { 
    ["Name"] = "Negarse a escuchar", -- Unique Name is require 
    ["Price"] = 1000,
    ["Vehicle"] = false, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[5] = { 
    ["Name"] = "Ayudando a un sospechoso", -- Unique Name is require 
    ["Price"] = 600,
    ["Vehicle"] = false, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[6] = { 
    ["Name"] = "Insultos/Spam", -- Unique Name is require 
    ["Price"] = 500,
    ["Vehicle"] = false, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[7] = { 
    ["Name"] = "Prostitución", -- Unique Name is require 
    ["Price"] = 1000,
    ["Vehicle"] = false, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[8] = { 
    ["Name"] = "Vandalismo", -- Unique Name is require 
    ["Price"] = 2000,
    ["Vehicle"] = false, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[8] = { 
    ["Name"] = "Posesión de Drogas", -- Unique Name is require 
    ["Price"] = 2500,
    ["Vehicle"] = false, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[9] = { 
    ["Name"] = "Desorden violento", -- Unique Name is require  
    ["Price"] = 1000,
    ["Vehicle"] = false, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[10] = { 
    ["Name"] = "Usar un vehículo con frenos defectuosos", -- Unique Name is require 
    ["Price"] = 500,
    ["Vehicle"] = true, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[11] = { 
    ["Name"] = "Usar un vehículo con dirección defectuosa", -- Unique Name is require 
    ["Price"] = 750,
    ["Vehicle"] = true, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[17] = {  
    ["Name"] = "Robo de vehículo agravado", -- Unique Name is require 
    ["Price"] = 1500,
    ["Vehicle"] = true, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[13] = { 
    ["Name"] = "Excediendo el límite de velocidad", -- Unique Name is require 
    ["Price"] = 250,
    ["Vehicle"] = true, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[14] = { 
    ["Name"] = "No detenerse después de un accidente", -- Unique Name is require 
    ["Price"] = 600,
    ["Vehicle"] = true, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[15] = { 
    ["Name"] = "Frenos defectuosos", -- Unique Name is require 
    ["Price"] = 800,
    ["Vehicle"] = true, 
    ["Category"] = "General",
}

Realistic_Police.FiningPolice[16] = { 
    ["Name"] = "Ofensa de límite de velocidad indefinida", -- Unique Name is require 
    ["Price"] = 800,
    ["Vehicle"] = true, 
    ["Category"] = "General",
}

-----------------------------------------------------------------------------
--------------------------- Hacking System ----------------------------------
-----------------------------------------------------------------------------

Realistic_Police.NameOs = "Windows" -- The name of the os 

Realistic_Police.ResolveHack = 120 -- Time which the computer will be repair 

Realistic_Police.WordCount = 10 -- How many word the people have to write for hack the computer

Realistic_Police.HackerJob = Realistic_Police.Hackers

Realistic_Police.WordHack = { -- Random Word for hack the computer 
    "run.hack.exe",
    "police.access.hack",
    "rootip64",
    "delete.password", 
    "password.breaker", 
    "run.database.sql", 
    "delete.access", 
    "recompil", 
    "connect.police.system", 
    "datacompil", 
    "username", 
    "mysqlbreaker", 
    "camera.exe",
    "criminal.record.exe",
    "deleteusergroup",
    "license.plate.exe",
    "cameracitizen.exe", 
    "loaddatapublic",
    "internet.exe",
    "reportmenu.exe",
    "listreport.exe",
}

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
 