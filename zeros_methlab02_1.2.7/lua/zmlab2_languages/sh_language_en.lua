zmlab2 = zmlab2 or {}
zmlab2.language = zmlab2.language or {}

if (zmlab2.config.SelectedLanguage == "en") then
    zmlab2.language["YouDontOwnThis"] = "You dont own this!"
    zmlab2.language["Minutes"] = "Minutes"
    zmlab2.language["Seconds"] = "Seconds"
    zmlab2.language["CratePickupFail"] = "Crate is empty!"
    zmlab2.language["CratePickupSuccess"] = "Collected $MethAmount $MethName, Quality: $MethQuality%"
    zmlab2.language["Interaction_Fail_Job"] = "You dont have the right job to interact with this!"
    zmlab2.language["Interaction_Fail_Dropoff"] = "This dropoff point is not assigned to you!"
    zmlab2.language["Dropoff_assinged"] = "Dropoff assigned!"
    zmlab2.language["Dropoff_cooldown"] = "Dropoff cooldown!"
    zmlab2.language["Equipment"] = "Equipment"
    zmlab2.language["Equipment_Build"] = "Build"
    zmlab2.language["Equipment_Move"] = "Move"
    zmlab2.language["Equipment_Repair"] = "Repair"
    zmlab2.language["Equipment_Remove"] = "Remove"
    zmlab2.language["NotEnoughMoney"] = "You dont have enough money!"
    zmlab2.language["ExtinguisherFail"] = "Object is not on fire!"
    zmlab2.language["Start"] = "Start"
    zmlab2.language["Drop"] = "Drop"
    zmlab2.language["Move Liquid"] = "Move Liquid"
    zmlab2.language["Frezzer_NeedTray"] = "No tray with unfrozen meth found!"
    zmlab2.language["ERROR"] = "ERROR"
    zmlab2.language["SPACE"] = "Press SPACE"
    zmlab2.language["NPC_InteractionFail01"] = "I dont deal with normies! [Wrong Job]"
    zmlab2.language["NPC_InteractionFail02"] = "You dont have any meth!"
    zmlab2.language["NPC_InteractionFail03"] = "I dont have a free dropoff point currenty, come back later."
    zmlab2.language["PoliceWanted"] = "Sold Meth!"
    zmlab2.language["MissingCrate"] = "Missing Crate"
    zmlab2.language["Storage"] = "STORAGE"
    zmlab2.language["ItemLimit"] = "You reached the entity limit for $ItemName!"
    zmlab2.language["TentFoldInfo01"] = "Are you sure you want to remove the tent?"
    zmlab2.language["TentFoldInfo02"] = "Any equipment inside will be removed too!"
    zmlab2.language["TentFoldAction"] = "FOLD"
    zmlab2.language["TentType_None"] = "NONE"
    zmlab2.language["TentAction_Build"] = "BUILD"
    zmlab2.language["TentBuild_Info"] = "Please clear the area!"
    zmlab2.language["TentBuild_Abort"] = "Something was in the way!"
    zmlab2.language["Enabled"] = "Enabled"
    zmlab2.language["Disabled"] = "Disabled"
    zmlab2.language["MethTypeRestricted"] = "You are not allowed to make this type of meth!"
    zmlab2.language["SelectMethType"] = "Select Meth Type"
    zmlab2.language["SelectTentType"] = "Select Tent Type"
    zmlab2.language["LightColor"] = "Light Color"
    zmlab2.language["Cancel"] = "Cancel"
    zmlab2.language["Deconstruct"] = "Deconstruct"
    zmlab2.language["Construct"] = "Construct"
    zmlab2.language["Choosepostion"] = "Choose new postion"
    zmlab2.language["ChooseMachine"] = "Choose Machine"
    zmlab2.language["Extinguish"] = "Extinguish"
    zmlab2.language["PumpTo"] = "Pump to"
    zmlab2.language["ConstructionCompleted"] = "Construction Completed!"
    zmlab2.language["Duration"] = "Duration"
    zmlab2.language["Amount"] = "Yield"
    zmlab2.language["Difficulty"] = "Difficulty"
    zmlab2.language["Money"] = "Money"
    zmlab2.language["Difficulty_Easy"] = "Easy"
    zmlab2.language["Difficulty_Medium"] = "Medium"
    zmlab2.language["Difficulty_Hard"] = "Hard"
    zmlab2.language["Difficulty_Expert"] = "Expert"
    zmlab2.language["Connected"] = "Connected!"
    zmlab2.language["Missed"] = "Missed!"
    -- Tent Config
    -- Note: "Vamonos Pest" and "Crystale Castle" are the names of those tents so you dont need to translate them if you dont want
    zmlab2.language["tent01_title"] = "Tent - Small"
    zmlab2.language["tent01_desc"] = "This small tent provides room for 6 machines."
    zmlab2.language["tent02_title"] = "Tent - Medium"
    zmlab2.language["tent02_desc"] = "This medium sized tent provides room for 9 machines."
    zmlab2.language["tent03_title"] = "Tent - Large"
    zmlab2.language["tent03_desc"] = "This large tent provides room for 16 machines."
    zmlab2.language["tent04_title"] = "Crystale Castle"
    zmlab2.language["tent04_desc"] = "This stolen circus tent provides room for 24 machines."
    -- Equipment Config
    zmlab2.language["ventilation_title"] = "Ventilation"
    zmlab2.language["ventilation_desc"] = "Clears the surrounding area from pollution."
    zmlab2.language["storage_title"] = "Storage"
    zmlab2.language["storage_desc"] = "Provides chemicals and equipment."
    zmlab2.language["furnace_title"] = "Thorium Furnace"
    zmlab2.language["furnace_desc"] = "Used for heating acid."
    zmlab2.language["mixer_title"] = "Mixer"
    zmlab2.language["mixer_desc"] = "Used as the main reaction vessel to combining the compounds."
    zmlab2.language["filter_title"] = "Filter"
    zmlab2.language["filter_desc"] = "Used to refine the final mixture to increase its quality."
    zmlab2.language["filler_title"] = "Filler"
    zmlab2.language["filler_desc"] = "Used to fill the final mixture on frezzer trays."
    zmlab2.language["frezzer_title"] = "Frezzer"
    zmlab2.language["frezzer_desc"] = "Used to stop the final methamphetamine solution from reacting further."
    zmlab2.language["packingtable_title"] = "Packing Table"
    zmlab2.language["packingtable_desc"] = "Provides a fast way to break / pack meth. Can hold up to 12 frezzer trays. Can be upgraded with a automatic Ice Breaker."
    -- Storage Config
    zmlab2.language["acid_title"] = "Hydrofluoric Acid"
    zmlab2.language["acid_desc"] = "A catalyst to increase the rate of reaction."
    zmlab2.language["methylamine_title"] = "Methylamine"
    zmlab2.language["methylamine_desc"] = "Methylamine (CH3NH2) is an organic compound and one of the main ingredients for the production of methamphetamine."
    zmlab2.language["aluminum_title"] = "Aluminum"
    zmlab2.language["aluminum_desc"] = "Aluminum amalgam is used as a chemical reagent to reduce compounds."
    zmlab2.language["lox_title"] = "Liquid Oxygen"
    zmlab2.language["lox_desc"] = "Liquid Oxygen is used in the Frezzer to stop the final methamphetamine solution from reacting any further."
    zmlab2.language["crate_title"] = "Transportcrate"
    zmlab2.language["crate_desc"] = "Used for transporting big amounts of meth."
    zmlab2.language["palette_title"] = "Palette"
    zmlab2.language["palette_desc"] = "Used for transporting large amounts of meth."
    zmlab2.language["crusher_title"] = "Ice Breaker"
    zmlab2.language["crusher_desc"] = "Automaticly breaks and packs meth when intalled on a packing table."
    -- Meth Config
    -- Note: Hard to say what about the meth should be translated and what not. Decide for yourself whats important here.
    zmlab2.language["meth_title"] = "Meth"
    zmlab2.language["meth_desc"] = "Normal street meth."
    zmlab2.language["bluemeth_title"] = "Crystal Blue"
    zmlab2.language["bluemeth_desc"] = "The original Heisenberg formula."
    zmlab2.language["kalaxi_title"] = "Kalaxian Crystal"
    zmlab2.language["kalaxi_desc"] = "The Kalaxian Crystals are very similar to many drugs, as the crystals give you a good sensation."
    zmlab2.language["glitter_title"] = "Glitter"
    zmlab2.language["glitter_desc"] = "Glitter is a highly psychedelic drug and recent arrival on Night City's streets. It's truly strong stuff, even for the booster glutted residents of Night City."
    zmlab2.language["kronole_title"] = "Kronole"
    zmlab2.language["kronole_desc"] = "Kronole is a street-drug sold aboard Snowpiercer on the black market. The drug has the ability to block pain receptors, Kronole is so powerful it blocks out all feelings, not just pain."
    zmlab2.language["melange_title"] = "Melange"
    zmlab2.language["melange_desc"] = "Melange (Spice) is a drug able to prolong life, bestow heightened vitality and awareness, and unlock prescience in some humans."
    zmlab2.language["mdma_title"] = "MDMA"
    zmlab2.language["mdma_desc"] = "MDMA was first developed in 1912 by Merck. It was used to enhance psychotherapy beginning in the 1970s and became popular as a street drug in the 1980s."
    -- Update 1.0.5
    zmlab2.language["tent05_title"] = "Round Tent"
    zmlab2.language["tent05_desc"] = "This round tent provides room for 8 machines."
end
