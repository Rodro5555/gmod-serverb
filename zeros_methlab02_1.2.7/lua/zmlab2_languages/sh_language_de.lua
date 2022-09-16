zmlab2 = zmlab2 or {}
zmlab2.language = zmlab2.language or {}

if (zmlab2.config.SelectedLanguage == "de") then
    zmlab2.language["YouDontOwnThis"] = "Das gehört dir nicht!"
    zmlab2.language["Minutes"] = "Minuten"
    zmlab2.language["Seconds"] = "Sekunden"
    zmlab2.language["CratePickupFail"] = "Transport Kiste is leer!"
    zmlab2.language["CratePickupSuccess"] = "Gesammelt $MethAmount $MethName, Qualität: $MethQuality%"
    zmlab2.language["Interaction_Fail_Job"] = "Du hast nicht den richtigen Job, um damit zu interagieren!"
    zmlab2.language["Interaction_Fail_Dropoff"] = "Dieser Abwurfs Punkt ist dir nicht zugewiesen!"
    zmlab2.language["Dropoff_assinged"] = "Abwurfs Punkt zugewiesen!"
    zmlab2.language["Dropoff_cooldown"] = "Abwurfs Punkt cooldown!"
    zmlab2.language["Equipment"] = "Ausrüstung"
    zmlab2.language["Equipment_Build"] = "Bauen"
    zmlab2.language["Equipment_Move"] = "Bewegen"
    zmlab2.language["Equipment_Repair"] = "Reparieren"
    zmlab2.language["Equipment_Remove"] = "Löschen"
    zmlab2.language["NotEnoughMoney"] = "Du hast nicht genug geld!"
    zmlab2.language["ExtinguisherFail"] = "Objekt brennet nicht!"
    zmlab2.language["Start"] = "Starten"
    zmlab2.language["Drop"] = "Entnehmen"
    zmlab2.language["Move Liquid"] = "Weiter Pumpen"
    zmlab2.language["Frezzer_NeedTray"] = "Kein Tablett mit nicht gefrorenem Meth gefunden!"
    zmlab2.language["ERROR"] = "ERROR"
    zmlab2.language["SPACE"] = "Drücke SPACE"
    zmlab2.language["NPC_InteractionFail01"] = "Mit dir handel ich nicht! [Falscher Job]"
    zmlab2.language["NPC_InteractionFail02"] = "Du hast kein meth bei dir!"
    zmlab2.language["NPC_InteractionFail03"] = "Ich habe momentan keinen freien Abwurfs Punkt, Komm später wieder."
    zmlab2.language["PoliceWanted"] = "Meth verkauft!"
    zmlab2.language["MissingCrate"] = "Kiste fehlt!"
    zmlab2.language["Storage"] = "LAGER"
    zmlab2.language["ItemLimit"] = "Du hast das Limit für $ItemName erreicht!"
    zmlab2.language["TentFoldInfo01"] = "Bist du sicher, dass du das zelt abbauen willst?"
    zmlab2.language["TentFoldInfo02"] = "Jede Maschine im zelt wird auch verkauft!"
    zmlab2.language["TentFoldAction"] = "ABBAUEN"
    zmlab2.language["TentType_None"] = "NICHTS"
    zmlab2.language["TentAction_Build"] = "BAUEN"
    zmlab2.language["TentBuild_Info"] = "Bitte machen Sie den Bereich frei!"
    zmlab2.language["TentBuild_Abort"] = "Etwas war im weg!"
    zmlab2.language["Enabled"] = "Eingeschalten"
    zmlab2.language["Disabled"] = "Ausgeschalten"
    zmlab2.language["MethTypeRestricted"] = "Sie dürfen diese Art von Meth nicht herstellen!"
    zmlab2.language["SelectMethType"] = "Wählen Sie Meth Art"
    zmlab2.language["SelectTentType"] = "Wählen Sie Zelt Art"
    zmlab2.language["LightColor"] = "Lichtfarbe"
    zmlab2.language["Cancel"] = "Abbrechen"
    zmlab2.language["Deconstruct"] = "Abbauen"
    zmlab2.language["Construct"] = "Bauen"
    zmlab2.language["Choosepostion"] = "Wähle eine neue Position"
    zmlab2.language["ChooseMachine"] = "Wähle eine Maschine"
    zmlab2.language["Extinguish"] = "Auslöschen"
    zmlab2.language["PumpTo"] = "Abpumpen nach"
    zmlab2.language["ConstructionCompleted"] = "Bau abgeschlossen!"
    zmlab2.language["Duration"] = "Dauer"
    zmlab2.language["Amount"] = "Menge"
    zmlab2.language["Difficulty"] = "Schwierigkeit"
    zmlab2.language["Money"] = "Geld"
    zmlab2.language["Difficulty_Easy"] = "Leicht"
    zmlab2.language["Difficulty_Medium"] = "Mittel"
    zmlab2.language["Difficulty_Hard"] = "Hart"
    zmlab2.language["Difficulty_Expert"] = "Experte"
    zmlab2.language["Connected"] = "Verbunden!"
    zmlab2.language["Missed"] = "Verfehlt!"

    // Tent shop
    // Note: "Vamonos Pest" and "Crystale Castle" are the names of those tents so you dont need to translate them if you dont want
    zmlab2.language["tent01_title"] = "Vamonos Pest Zelt - Klein"
    zmlab2.language["tent01_desc"] = "Dieses kleine Zelt bietet Platz für 6 Maschinen. "
    zmlab2.language["tent02_title"] = "Vamonos Pest Zelt - Mittel"
    zmlab2.language["tent02_desc"] = "Dieses mittelgroße Zelt bietet Platz für 9 Maschinen. "
    zmlab2.language["tent03_title"] = "Vamonos Pest Zelt - Groß"
    zmlab2.language["tent03_desc"] = "Dieses große Zelt bietet Platz für 16 Maschinen."
    zmlab2.language["tent04_title"] = "Crystale Castle"
    zmlab2.language["tent04_desc"] = "Dieses gestohlene Zirkuszelt bietet Platz für 24 Maschinen. "

    // Machine Shop
    zmlab2.language["ventilation_title"] = "Ventilation"
    zmlab2.language["ventilation_desc"] = "Reinigt die Umgebung von Verschmutzung."
    zmlab2.language["storage_title"] = "Lager"
    zmlab2.language["storage_desc"] = "Bietet Chemikalien und Ausrüstung."
    zmlab2.language["furnace_title"] = "Thorium Herd"
    zmlab2.language["furnace_desc"] = "Wird zum Erhitzen von Säure benötigt."
    zmlab2.language["mixer_title"] = "Mischer"
    zmlab2.language["mixer_desc"] = "Wird als Hauptreaktionsgefäß zur Kombination der Chemikalien verwendet."
    zmlab2.language["filter_title"] = "Filtermaschine"
    zmlab2.language["filter_desc"] = "Wird verwendet, um die endgültige Mischung zu verfeinern und ihre Qualität zu verbessern."
    zmlab2.language["filler_title"] = "Füllmaschine"
    zmlab2.language["filler_desc"] = "Wird verwendet, um die endgültige Mischung in Gefrierbleche zu füllen."
    zmlab2.language["frezzer_title"] = "Gefrierschrank "
    zmlab2.language["frezzer_desc"] = "Wird verwendet, um zu verhindern, dass die fertige Methamphetaminlösung weiter reagiert."
    zmlab2.language["packingtable_title"] = "Packtisch"
    zmlab2.language["packingtable_desc"] = "Bietet eine schnelle Möglichkeit, Meth zu brechen / zu verpacken. Kann bis zu 12 Gefrierbleche aufnehmen. Kann mit einem automatischen Meth-brecher aufgerüstet werden."

    // Item Shop
    zmlab2.language["acid_title"] = "Fluorwasserstoffsäure"
    zmlab2.language["acid_desc"] = "Ein Katalysator zur Erhöhung der Reaktionsgeschwindigkeit."
    zmlab2.language["methylamine_title"] = "Methylamine"
    zmlab2.language["methylamine_desc"] = "Methylamin (CH3NH2) ist eine organische Verbindung und einer der Hauptbestandteile für die Herstellung von Methamphetamin."
    zmlab2.language["aluminum_title"] = "Aluminium"
    zmlab2.language["aluminum_desc"] = "Aluminiumamalgam wird als chemisches Reagenz zur Reduktion von Verbindungen verwendet."
    zmlab2.language["lox_title"] = "Flüssiger Sauerstoff"
    zmlab2.language["lox_desc"] = "Im Gefrierschrank wird flüssiger Sauerstoff verwendet, um zu verhindern, dass die endgültige Methamphetaminlösung weiter reagiert."
    zmlab2.language["crate_title"] = "Transportkiste"
    zmlab2.language["crate_desc"] = "Wird für den Transport großer Mengen Meth verwendet."
    zmlab2.language["palette_title"] = "Palette"
    zmlab2.language["palette_desc"] = "Wird zum Transport großer Mengen Meth verwendet."
    zmlab2.language["crusher_title"] = "Meth-Zerkleinerer"
    zmlab2.language["crusher_desc"] = "Bricht und verpackt Meth automatisch, wenn es auf einem Packtisch installiert wird."

    // Meth Config
    // Note: Hard to say what about the meth should be translated and what not. Decide for yourself whats important here.
    zmlab2.language["meth_title"] = "Meth"
    zmlab2.language["meth_desc"] = "Normales junkie meth."
    zmlab2.language["bluemeth_title"] = "Crystal Blue"
    zmlab2.language["bluemeth_desc"] = "Die ursprüngliche Heisenberg-Formel."
    zmlab2.language["kalaxi_title"] = "Kalaxianischer Kristall"
    zmlab2.language["kalaxi_desc"] = "Die Kalaxianischen Kristalle sind vielen Drogen sehr ähnlich, da die Kristalle ein gutes Gefühl vermitteln."
    zmlab2.language["glitter_title"] = "Glitter"
    zmlab2.language["glitter_desc"] = "Glitter ist eine hochpsychedelische Droge welche kürzlich auf den Straßen von Night City erschien. Es ist wirklich ein starkes Zeug, selbst für die ärgsten junkies von Night City."
    zmlab2.language["kronole_title"] = "Kronole"
    zmlab2.language["kronole_desc"] = "Kronole ist eine Straßendroge, die an Bord von Snowpiercer auf dem Schwarzmarkt verkauft wird. Das Medikament hat die Fähigkeit, Schmerzrezeptoren zu blockieren. Kronole ist so stark, dass es alle Gefühle blockiert, nicht nur Schmerzen."
    zmlab2.language["melange_title"] = "Melange"
    zmlab2.language["melange_desc"] = "Melange (Spice) ist ein Medikament, das in der Lage ist, das Leben zu verlängern, die Vitalität zu steigern und kann bei manchen Menschen sogar das Bewusstsein stärken."
    zmlab2.language["mdma_title"] = "MDMA"
    zmlab2.language["mdma_desc"] = "MDMA wurde erstmals 1912 von Merck entwickelt. Es wurde ab den 1970er Jahren zur Verbesserung der Psychotherapie eingesetzt und wurde in den 1980er Jahren als Straßendroge populär."

    // Update 1.0.5
    zmlab2.language["tent05_title"] = "Rundes Zelt"
    zmlab2.language["tent05_desc"] = "Dieses runde Zelt bietet Platz für 8 Maschinen."
end
