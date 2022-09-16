-- Requires custom GetSetting function made in sh_bdumpsters_load.lua


-- This is the main hook everything is loaded in. This runs before we load the modules, which is the perfect time for you to add your own.
hook.Add("AstreaLoadThirdParty", "bdumpsters_astrea_load", function()
	
	-- We just print to console that we're adding the module. 
	bDumpsters.Print("Astrea Exists - Enabling Module")


	-- Enable the module
	-- This adds the module to both our backend and frontend. 
	AstreaToolbox.Core.EnableModule("dumpster", true) 

	-- We want to add the module print name to the translations. 
	-- Note 'dumpster' is the same as our module name in enable module.
	AstreaToolbox.Translations["dumpster"] = "bDumpsters"

	-- If we're on the client, we want to download the icon and set it as our material. The icon is an imgur id and the 
	-- second arguement is the folder name containing it.
	if CLIENT then 
	    AstreaToolbox.derma.downloadImage("uRBPbJM", "main", function(fileName)
	        AstreaToolbox.Config["dumpster"]["Material"] = AstreaToolbox.derma.images[fileName] or Material("astrea/main/"..fileName..".png")
	    end)
	end 


	-- These are the actual settings, a little more to unpack but, here we are.
	-- More about how these work on the home page.
	AstreaToolbox.Core.AddSetting("dumpster_settings", "dumpster", {["type"] = "bool", ["clientside"] = true}, false, "Override Dumpster Settings", "Configure the dumpsters settings to your liking.")
	AstreaToolbox.Core.AddSubSetting("dumpster_settings", "dumpster_limit_jobs", "dumpster",{["type"] = "bool", ["clientside"] = false},false,"Limit Jobs","Should we limit the jobs that can rummage through dumpsters?")
	AstreaToolbox.Core.AddSubSetting("dumpster_settings", "dumpster_jobs","dumpster",{["type"] = "list", ["clientside"] = false, {["type"] = "job"}},{},"Job Table","What jobs can open dumpsters?")
	AstreaToolbox.Core.AddSubSetting("dumpster_settings", "dumpster_incorrect_job", "dumpster",{["type"] = "string", ["clientside"] = false, ["min"]=0, ["max"]=128, ["printname"] = "Message"},"You're too prestigious to be going around looking in bins.","Incorrect Job Message","What should we tell the player when they arent the correct job?")
	AstreaToolbox.Core.AddSubSetting("dumpster_settings", "dumpster_cooldown", "dumpster",{["type"] = "number", ["clientside"] = false, ["min"] = 1, ["max"] = 256}, 75, "Dumpster Cooldown","How often should you be able to open a dumpster?")
	AstreaToolbox.Core.AddSubSetting("dumpster_settings", "dumpster_props","dumpster",{["type"] = "list", ["clientside"] = false, {["type"] = "string", ["min"]=0, ["max"]=128, ["printname"] = "Model", ["case"] = "lower"}},{},"Dumpster Props","What props should come out of the dumpster when opened?")
	AstreaToolbox.Core.AddSubSetting("dumpster_settings", "dumpster_props_count", "dumpster",{["type"] = "number", ["clientside"] = false, ["min"] = 1, ["max"] = 20}, 5, "Dumpster Prop Count","How many props should come out of a dumpster?")
	AstreaToolbox.Core.AddSubSetting("dumpster_settings", "dumpster_props_throw", "dumpster",{["type"] = "bool", ["clientside"] = false},false,"Throw Props","Should players rummaging through bins throw props out behind them?")
	AstreaToolbox.Core.AddSubSetting("dumpster_settings", "dumpster_time_to_open", "dumpster",{["type"] = "number", ["clientside"] = false, ["min"] = 1, ["max"] = 50}, 12, "Time To Open","How long should it take to open a dumpster? (For example, 12 is 4 seconds.)")


	AstreaToolbox.Core.AddSetting("dumpster_loot", "dumpster", {["type"] = "bool", ["clientside"] = true}, false, "Override Dumpster Loot Table", "Configure the dumpsters loot and chances to your liking.")
	AstreaToolbox.Core.AddSubSetting("dumpster_loot", "chances_per_dumpster", "dumpster",{["type"] = "number", ["clientside"] = false, ["min"] = 1, ["max"] = 10}, 2, "Chances Per Dumpster","How many chances should we give the player to get an item per dumpster?")
	AstreaToolbox.Core.AddSubSetting("dumpster_loot", "chance_to_get_bronze", "dumpster",{["type"] = "number", ["clientside"] = false, ["min"] = 1, ["max"] = 100}, 30, "Chance For Bronze Item","What should the chance be to get a bronze item?")
	AstreaToolbox.Core.AddSubSetting("dumpster_loot", "chance_to_get_silver", "dumpster",{["type"] = "number", ["clientside"] = false, ["min"] = 1, ["max"] = 100}, 15, "Chance For Silver Item","What should the chance be to get a silver item?")
	AstreaToolbox.Core.AddSubSetting("dumpster_loot", "chance_to_get_gold", "dumpster",{["type"] = "number", ["clientside"] = false, ["min"] = 1, ["max"] = 100}, 3, "Chance For Gold Item","What should the chance be to get a gold item?")
	AstreaToolbox.Core.AddSubSetting("dumpster_loot", "chance_to_get_platinum", "dumpster",{["type"] = "number", ["clientside"] = false, ["min"] = 1, ["max"] = 100}, 1, "Chance For Platinum Item","What should the chance be to get a platinum item?")
	AstreaToolbox.Core.AddSubSetting("dumpster_loot", "dumpster_luck_bronze","dumpster",{["type"] = "list", ["clientside"] = false, {["type"] = "string", ["min"]=0, ["max"]=128, ["printname"] = "Item Class", ["case"] = "lower"}},{},"Bronze Loot Table","What entities should be in this loot table?")
	AstreaToolbox.Core.AddSubSetting("dumpster_loot", "dumpster_luck_silver","dumpster",{["type"] = "list", ["clientside"] = false, {["type"] = "string", ["min"]=0, ["max"]=128, ["printname"] = "Item Class", ["case"] = "lower"}},{},"Silver Loot Table","What entities should be in this loot table?")
	AstreaToolbox.Core.AddSubSetting("dumpster_loot", "dumpster_luck_gold","dumpster",{["type"] = "list", ["clientside"] = false, {["type"] = "string", ["min"]=0, ["max"]=128, ["printname"] = "Item Class", ["case"] = "lower"}},{},"Gold Loot Table","What entities should be in this loot table?")
	AstreaToolbox.Core.AddSubSetting("dumpster_loot", "dumpster_luck_platinum","dumpster",{["type"] = "list", ["clientside"] = false, {["type"] = "string", ["min"]=0, ["max"]=128, ["printname"] = "Item Class", ["case"] = "lower"}},{},"Platinum Loot Table","What entities should be in this loot table?")
	AstreaToolbox.Core.AddSubSetting("dumpster_loot", "dumpster_money_chance", "dumpster",{["type"] = "number", ["clientside"] = false, ["min"] = 1, ["max"] = 100}, 20, "Chance To Get Money","How often should a player find money in the dumpsters?")
	AstreaToolbox.Core.AddSubSetting("dumpster_loot", "dumpster_minimum_money", "dumpster",{["type"] = "number", ["clientside"] = false, ["min"] = 1, ["max"] = 1000000}, 1000, "Minimum Money","What should the minimum amount of money to be found be?")
	AstreaToolbox.Core.AddSubSetting("dumpster_loot", "dumpster_maximum_money", "dumpster",{["type"] = "number", ["clientside"] = false, ["min"] = 1, ["max"] = 1000000}, 3500, "Maximum Money","What should the maximum amount of money to be found be?")

end)


-- We also want to add a few defaults to settings on the first time Astrea has loaded this module.
-- This hook runs on our first time loading this module. 
hook.Add("AstreaToolboxInitialModule", "bdumpsters_astrea_load_initial", function(module)
	if module == "dumpster" then 
		
		-- We're pretty much just adding a bunch of things to the lists made in the hook above. 
		AstreaToolbox.Core.AddToList("dumpster_props", "models/props_junk/garbage_milkcarton001a.mdl")
		AstreaToolbox.Core.AddToList("dumpster_props", "models/props_junk/garbage_bag001a.mdl")
		AstreaToolbox.Core.AddToList("dumpster_props", "models/props_junk/garbage_metalcan001a.mdl")
		AstreaToolbox.Core.AddToList("dumpster_props", "models/props_junk/Shoe001a.mdl")
		AstreaToolbox.Core.AddToList("dumpster_props", "models/props_junk/garbage_plasticbottle002a.mdl")

		AstreaToolbox.Core.AddToList("dumpster_jobs", "hobo")
		AstreaToolbox.Core.AddToList("dumpster_jobs", "citizen")


		AstreaToolbox.Core.AddToList("dumpster_luck_bronze","weapon_glock2")
		AstreaToolbox.Core.AddToList("dumpster_luck_bronze","weapon_fiveseven2")
		AstreaToolbox.Core.AddToList("dumpster_luck_bronze","weapon_bugbait")
		AstreaToolbox.Core.AddToList("dumpster_luck_bronze","item_ammo_pistol")
		AstreaToolbox.Core.AddToList("dumpster_luck_bronze","item_ammo_smg1")


		AstreaToolbox.Core.AddToList("dumpster_luck_silver", "med_kit")
		AstreaToolbox.Core.AddToList("dumpster_luck_silver", "weapon_deagle2")


		AstreaToolbox.Core.AddToList("dumpster_luck_gold","weapon_mac102")
		AstreaToolbox.Core.AddToList("dumpster_luck_gold","weapon_mp52")
		AstreaToolbox.Core.AddToList("dumpster_luck_gold","weapon_m42")

		AstreaToolbox.Core.AddToList("dumpster_luck_platinum", "ls_sniper")
		AstreaToolbox.Core.AddToList("dumpster_luck_platinum", "weapon_ak472")
		AstreaToolbox.Core.AddToList("dumpster_luck_platinum", "weapon_pumpshotgun2")		

	end
end) 
