if SERVER then
	local function InitializeTomasPrinters()
		print("[Tomas Printers] Printer config file loaded :]")		
		TPRINTERS_CONFIG = {}		
		TPRINTERS_CONFIG.BatteryAdd = 75 -- How much battery entity adds battery to the printer.

		------------------------------------------BLUE PRINTER----------------------------------------------------------

		TPRINTERS_CONFIG.Name = "Impresora Azul" -- Printer name		
		TPRINTERS_CONFIG.Battery = 3 -- How much battery does it take from the printer when it prints something		
		TPRINTERS_CONFIG.Money = 10 -- How much money does it prints. This number is multiplied by the printer speed (stars).		
		TPRINTERS_CONFIG.PrintRate = math.random(25,55) -- That will give random number between 30 and 60 for the print rate. Time is in seconds.
		TPRINTERS_CONFIG.UpgradePrice = 28 -- This is the upgrade price of the printer for 1 star
		TPRINTERS_CONFIG.XP = 10 -- How much XP does the player get when he prints something with this printer
		
		------------------------------------------BLUE PRINTER----------------------------------------------------------
		
		------------------------------------------RED PRINTER----------------------------------------------------------

		TPRINTERS_CONFIG.Name_Red = "Impresora Roja" -- Printer name		
		TPRINTERS_CONFIG.Battery_Red = 4 -- How much battery does it take from the printer when it prints something		
		TPRINTERS_CONFIG.Money_Red = 15 -- How much money does it prints. This number is multiplied by the printer speed (stars).		
		TPRINTERS_CONFIG.PrintRate_Red = math.random(38,70) -- That will give random number between 30 and 60 for the print rate. Time is in seconds.
		TPRINTERS_CONFIG.UpgradePrice_Red = 32 -- This is the upgrade price of the printer for 1 star
		TPRINTERS_CONFIG.XP_Red = 15 -- How much XP does the player get when he prints something with this printer
		
		------------------------------------------RED PRINTER----------------------------------------------------------
		
		------------------------------------------GREEN PRINTER----------------------------------------------------------

		TPRINTERS_CONFIG.Name_Green = "Impresora Verde" -- Printer name		
		TPRINTERS_CONFIG.Battery_Green = 5 -- How much battery does it take from the printer when it prints something		
		TPRINTERS_CONFIG.Money_Green = 20 -- How much money does it prints. This number is multiplied by the printer speed (stars).		
		TPRINTERS_CONFIG.PrintRate_Green = math.random(45,80) -- That will give random number between 30 and 60 for the print rate. Time is in seconds.
		TPRINTERS_CONFIG.UpgradePrice_Green = 48 -- This is the upgrade price of the printer for 1 star
		TPRINTERS_CONFIG.XP_Green = 20 -- How much XP does the player get when he prints something with this printer
		
		------------------------------------------GREEN PRINTER----------------------------------------------------------

		------------------------------------------YELLOW PRINTER----------------------------------------------------------

		TPRINTERS_CONFIG.Name_Yellow = "Impresora Amarilla" -- Printer name		
		TPRINTERS_CONFIG.Battery_Yellow = 6 -- How much battery does it take from the printer when it prints something		
		TPRINTERS_CONFIG.Money_Yellow = 30 -- How much money does it prints. This number is multiplied by the printer speed (stars).		
		TPRINTERS_CONFIG.PrintRate_Yellow = math.random(53,90) -- That will give random number between 30 and 60 for the print rate. Time is in seconds.
		TPRINTERS_CONFIG.UpgradePrice_Yellow = 58 -- This is the upgrade price of the printer for 1 star
		TPRINTERS_CONFIG.XP_Yellow = 30 -- How much XP does the player get when he prints something with this printer
		
		------------------------------------------YELLOW PRINTER----------------------------------------------------------

		------------------------------------------PURPLE PRINTER----------------------------------------------------------

		TPRINTERS_CONFIG.Name_Purple = "Impresora Morada" -- Printer name		
		TPRINTERS_CONFIG.Battery_Purple = 7 -- How much battery does it take from the printer when it prints something		
		TPRINTERS_CONFIG.Money_Purple = 35 -- How much money does it prints. This number is multiplied by the printer speed (stars).		
		TPRINTERS_CONFIG.PrintRate_Purple = math.random(65,100) -- That will give random number between 30 and 60 for the print rate. Time is in seconds.
		TPRINTERS_CONFIG.UpgradePrice_Purple = 63 -- This is the upgrade price of the printer for 1 star
		TPRINTERS_CONFIG.XP_Purple = 40 -- How much XP does the player get when he prints something with this printer
		
		------------------------------------------PURPLE PRINTER----------------------------------------------------------
	end
	
	hook.Add("Initialize","InitializeTomasPrinters",InitializeTomasPrinters)

end
