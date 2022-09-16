-- [[ This is the configuration file. ]] --

-- [[ General Configuration ]] --

	Diablos.RS.Language = "english" -- Language of the script. Available languages are written at http://diabloscoder.com/languages.

	Diablos.RS.AdminGroups = { -- Groups able to use the Radar Placer toolgun.
		["superadmin"] = true, 
		["admin"] = true,
	} 

	Diablos.RS.MPHCounter = false -- true = MPH system / false = KMH system.

	Diablos.RS.Speedometer = true -- true = enable a (very very) basic speedometer (a rounded box with the speed). You must restart the server when you change this value.

	-- [ If Diablos.RS.Speedometer is set to true ] --

		Diablos.RS.SpeedometerPosX = 0.9 -- X pos of the Speedometer. The value must be between 0 and 1, 0 at the left and 1 at the right.

		Diablos.RS.SpeedometerPosY = 0.85 -- Y pos of the Speedometer. The value must be between 0 and 1, 0 at the top and 1 at the bottom.

	-- [[ End of this If ]] --

	Diablos.RS.OwnerOrDriver = true -- true = man who will be caught at an excessive speed will be the OWNER of the vehicle / false = will be the DRIVER of the vehicle.

	Diablos.RS.GovernementVehicles = { -- Classnames of vehicles (which are probably governement ones) which can't be caught at an excessive speed by a speed gun or by a speed camera.
		-- put your vehicles here.
		-- ["charger12poltdm"] = true,
	}

	Diablos.RS.JobVehicles = { -- Jobs which can't be caught at an excessive speed whatsoever the vehicles they are driving.
		-- ["Civil Protection"] = true,
		-- ["Civil Protection Chief"] = true,
	}

	Diablos.RS.NPCModel = "models/gman.mdl" -- Model of the NPC to pay fines (if you use it).

	Diablos.RS.NPCHeadMessage = "ADMINISTRADOR DE MULTAS" -- Message ('title') above the NPC to pay fines. "" to disable.

	Diablos.RS.AutoFine = false -- [SEP19 UPDATE] true = when you are caught the person caught automatically pays the fine (or what he can pay). false = you have to go to a NPC to pay your fines!

	Diablos.RS.Indulgence = 0.1 -- The indulgence (speed allowed above the speedlimit before being taken for real). Can be a percent or a real value, it's the speed allowed compared to the speedlimit (0.1 = 10% of tolerance: you can be at 55MPH/KMH instead of 50 // 5 = 5MPH/KMH of tolerance: you can be at 95 instead of 90). 0 = disable.
	
	Diablos.RS.IndulgenceSpeedGun = true -- If Diablos.RS.Indulgence is not at 0, then you can set this feature to true / false. true = the indulgence also applies for speed guns.

	Diablos.RS.ARCBank = false -- [ONLY WORKS ON THE PAID VERSION!] true = you use the ARCBank addon (https://www.gmodstore.com/scripts/view/324/) AND you want to make that the money will be taken from the bank account of the man himself if he doesn't have enough money in wallet.

	Diablos.RS.DriverLicense = false -- true = you use the Driver License System addon (https://www.gmodstore.com/scripts/view/3152) AND you want to make that if someone is caught by a radar he will win/loose (depending of country) some points on his license.

	-- [[ If Diablos.RS.DriverLicense is set to true ]] --

		Diablos.RS.DLAmountMoreSpeed = 10 -- Amount of kilometers/miles above the speed limit to add 1 driver point to win/loose. 0 means it's 1 point removed whatsoever the speeding regarding the speed limit.

	-- [[ End of this If ]] --

	Diablos.RS.ShowBestRecords = true -- true = by pressing the +USE (E) key in front of a speed camera, you will have a frame showing the best speed records.

	-- [[ If Diablos.RS.DriverLicense is set to true ]] --

		Diablos.RS.BestRecordsTop = 10 -- Amount of records showed. It depends of if you want a top 3, top 5, top 10 or whatsoever.

	-- [[ End of this If ]] --

	Diablos.RS.AutomaticWanted = true -- true = the man who will pay the fine will be wanted too due to his excessive speed.

	-- [[ If Diablos.RS.AutomaticWanted is set to true ]] --

		Diablos.RS.AutomaticWantedReason = "Atrapado a una velocidad excesiva!" -- Reason text when the player will be in the wanted state due to his excessive speed. 

	-- [[ End of this If ]] --

	Diablos.RS.WantedIfNotEnoughMoney = true -- true = the man who will pay the fine will be wanted if he can't pay the entire fine.

	-- [[ If Diablos.RS.AutomaticWanted is set to true ]] --

		Diablos.RS.NotEnoughMoneyWantedReason = "No pagó todo el precio total de la multa!" -- Reason text when the player will be in the wanted state due to the lack of money to pay the entire fine. 

	-- [[ End of this If ]] --

-- [[ Money depending speed settings ]] --

	-- [[ Example usage: You have the value Diablos.RS.MoneyMoreSpeed set to 5 & Diablos.RS.MoneyAdded set to 0.2:
	-- Let's say you are driving at 50MPH while the radar is fixed at 40MPH. The fine price when you are caught by the radar is set at $100.
	-- You are 10MPH above the speed limit, which means it's 2* the value Diablos.RS.MoneyMoreSpeed you set. Since Diablos.RS.MoneyAdded is set to 0.2, 
	-- it means that you pay 0.2*fine price = 0.2*100 = $20 more and since you are 2*Diablos.RS.MoneyMoreSpeed above the speed limit, you'll pay 2*20=$40 
	-- plus the initial fine price which is $100 so you'll pay $140 total. If you are 15MPH above the speed limit it will be $160 total and so on.
	-- TO-KNOW: if the man caught is at 49MPH he will pay $120; $140 are only when you are at 50MPH or more.
	-- ]]

	Diablos.RS.MoneyMoreSpeed = 5 -- This is the amount of kilometers/miles above the speed limit to add some money (the value Diablos.RS.MoneyToAdd) for the final fine price. 0 to disable.

	Diablos.RS.MoneyToAdd = 0.2 -- This is the amount of money relative to the fine price which will be added every Diablos.RS.MoneyMoreSpeed MPH/KMH more than the speed limit. 0 to disable.

-- [[ Speed Gun (SWEP) settings ]] --

	Diablos.RS.SpeedLimit = 50 -- Default speed limit on the server. This value can be changed for every camera you put!

	Diablos.RS.FinePrice = 200 -- Default fine price the caught player has to pay. This value can be changed for every camera you put!
	
-- [[ Speed Camera & Cops settings ]] --

	Diablos.RS.ShowSpeedAboveRadar = true -- true  = speed limit above all radar entities are shown (kind of help for drivers).

	Diablos.RS.MoneyForCops = true -- true  = for the speed cameras placed by the server, we detect all the cops which are on the server (there is no hierarchy system) and the money is subdivided by the amount of people in the GAMEMODE.CivilProtection.

	Diablos.RS.MoneyForRadarOwners = true -- true  = if you placed a speed camera by yourself, you receive the money taken by someone who has been caught (in other terms, the money is for you).

	Diablos.RS.MinFinePrice = 0 -- Minimum fine price cops can put to apply parameters of their speed cameras.

	Diablos.RS.MaxFinePrice = 1000 -- Maximum fine price cops can put to apply parameters of their speed cameras.

	Diablos.RS.MinSpeedLimit = 10 -- Minimum speed limit cops can put to apply parameters of their speed cameras OR speedgun.

	Diablos.RS.MaxSpeedLimit = 150 -- Maximum speed limit cops can put to apply parameters of their speed cameras OR speedgun.
	
	Diablos.RS.OwnServerCameras = true -- true = cops can make they own or they change any parameter of the cameras initially owned by servers / false = they can't.

	Diablos.RS.CopsCommand = "/speed" -- Text a cop must type on his chat to change the speedlimit of it's speedgun. He must type "<THECOMMAND> <THEVALUE>", "/speed 50" by example. "" = disable.

	Diablos.RS.CopsMessage = "Escribe " .. Diablos.RS.CopsCommand .. " seguido de la cantidad de velocidad (Entre " .. Diablos.RS.MinSpeedLimit .. " y " .. Diablos.RS.MaxSpeedLimit .. ") si quieres elegir la velocidad de tu propio radar."
	-- This text will appear if a cop takes his speedgun, if he is trying to edit the speedlimit value of a speed camera or when he drives a vehicle equipped by a car camera. Be careful when you try to modify the string.

-- [[ Color Theme Configuration ]] --

	Diablos.RS.Colors.Blurs = true -- true = enable blur effects (around the frames NOT in them).

	Diablos.RS.Colors.Frame = Color(50, 50, 50, 255) -- Color of the frame.

	Diablos.RS.Colors.FrameLeft = Color(40, 40, 40, 255) -- Color of the frame menu, the left part on the records frame you can see by using the Radar Infos SWEP. It's also things as boxes around the records frame.

	Diablos.RS.Colors.VBarGrip = Color(100, 100, 100, 120) -- Color of the vertical bar grip.

	Diablos.RS.Colors.VBarBG = Color(20, 75, 75, 255) -- Color of the vertical bar background.

	Diablos.RS.Colors.Label = Color(220, 220, 220, 220) -- Color of the labels (text in frames).

	Diablos.RS.Colors.LabelHovered = Color(50, 50, 50, 220) -- If it's a button, color of the labels when they are in the "hovered" mode (there is the mouse on the label).

	Diablos.RS.Colors.LabelDown = Color(0, 0, 0, 220) -- If it's a button, color of the labels when they are in the "down" mode (you press left click on the label).

	Diablos.RS.Colors.AboveRadarText = Color(230, 230, 230, 250) -- Color of the 'metric limit' above the radars. Also applies above NPC.

	Diablos.RS.Colors.AboveRadarBorder = Color(50, 50, 50, 200) -- Color of the borders around the 'metric limit' of the radars. Also applies above NPC.

	Diablos.RS.Colors.SpeedometerBG = Color(0, 0, 255, 200) -- Color of the speedometer background.

	Diablos.RS.Colors.SpeedometerText = Color(255, 255, 255, 255) -- Color of the speedometer text.

-- [[ Content Download Configuration ]] --

	Diablos.RS.Download.FastDL = false -- true = clients install the contents via FastDL.

	Diablos.RS.Download.Workshop = true -- true = clients install the contents via Workshop.

-- [[ End of the configuration file ]] --

TPRSAExtensions() -- DO NOT DELETE THIS LINE. This line updates the language strings and some informations of the addon.