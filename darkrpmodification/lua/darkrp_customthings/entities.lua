--[[---------------------------------------------------------------------------
DarkRP custom entities
---------------------------------------------------------------------------

This file contains your custom entities.
This file should also contain entities from DarkRP that you edited.

Note: If you want to edit a default DarkRP entity, first disable it in darkrp_config/disabled_defaults.lua
Once you've done that, copy and paste the entity to this file and edit it.

The default entities can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomEntityFields

Add entities under the following line:
---------------------------------------------------------------------------]]

--[[---------------------------------------------------------------------------
Fruit Slicer
---------------------------------------------------------------------------]]--

DarkRP.createEntity("Tienda de Batidos", {
	ent = "zfs_shop",
	model = "models/zerochain/fruitslicerjob/fs_shop.mdl",
	price = 4000,
	max = 1,
	cmd = "buyzfs_shop",
	allowed = { TEAM_ZFRUITSLICER },
	category = "Rebanador de frutas",
})

timer.Simple(1, function()
    if zfs and zfs.config and zfs.config.Fruits then
        for k, v in pairs(zfs.config.Fruits) do
            DarkRP.createEntity(v.Name, {
                ent = "zfs_fruitbox",
                model = "models/zerochain/fruitslicerjob/fs_cardboardbox.mdl",
                price = 1000,
                max = 5,
                cmd = "buy" .. v.Name,
                allowed = { TEAM_ZFRUITSLICER },
                category = "Rebanador de frutas",
                spawn = function(ply, tr, tblEnt)
                    local ent = ents.Create("zfs_fruitbox")
                    ent:SetFruitID(k)
                    ent:SetPos(tr.HitPos + Vector(0,0,10))
                    ent:Spawn()
                    ent:Activate()
                    ent:SetFruitID(k)
                    return ent
                end,
            })
        end
    end
end)

--[[---------------------------------------------------------------------------
Masterchef
---------------------------------------------------------------------------]]--

DarkRP.createEntity("Tanque de Gas", {
	ent = "zmc_gastank",
	model = "models/zerochain/props_kitchen/zmc_gastank.mdl",
	price = 500,
	max = 5,
	cmd = "buyzmcgastank",
	allowTools = true,
	allowed = { TEAM_ZMC_COOK },
	category = "Cocinero Profesional",
})

DarkRP.createEntity("Kit de Construcción", {
	ent = "zmc_buildkit",
	model = "models/zerochain/props_kitchen/zmc_buildkit.mdl",
	price = 500,
	max = 1,
	cmd = "buyzmc_buildkit",
	allowTools = true,
	allowed = { TEAM_ZMC_COOK },
	category = "Cocinero Profesional",
})

--[[---------------------------------------------------------------------------
ZMLAB2
---------------------------------------------------------------------------]]--

DarkRP.createEntity("Kit de Carpa", {
    ent = "zmlab2_tent",
    model = "models/zerochain/props_methlab/zmlab2_tentkit.mdl",
    price = 800,
    max = 1,
    cmd = "buyzm2tent",
    allowTools = true,
    allowed = { TEAM_METHDEALER, TEAM_PRODRUGDEALER },
    category = "Cocinero de Metanfetamina",
})

DarkRP.createEntity("Caja de Equipamiento", {
    ent = "zmlab2_equipment",
    model = "models/zerochain/props_methlab/zmlab2_chest.mdl",
    price = 1000,
    max = 1,
    cmd = "buyzm2equipment",
    allowed = { TEAM_METHDEALER, TEAM_PRODRUGDEALER },
    category = "Cocinero de Metanfetamina",
})

--[[---------------------------------------------------------------------------
EML
---------------------------------------------------------------------------]]--

DarkRP.createEntity("Gas", {
    ent = "eml_gas",
    model = "models/props_c17/canister01a.mdl",
    price = 20,
    max = 2,
    cmd = "buyemlgas",
    allowed = { TEAM_BLUEMETHDEALER, TEAM_PRODRUGDEALER },
    category = "Laboratorio de Metanfetamina",
})

DarkRP.createEntity("Yodo Liquido", {
    ent = "eml_iodine",
    model = "models/props_lab/jar01b.mdl",
    price = 26,
    max = 3,
    cmd = "buyemliodine",
    allowed = { TEAM_BLUEMETHDEALER, TEAM_PRODRUGDEALER },
    category = "Laboratorio de Metanfetamina",
})

DarkRP.createEntity("Frasco de Yodo Cristalizado", {
    ent = "eml_jar",
    model = "models/props_lab/jar01a.mdl",
    price = 75,
    max = 3,
    cmd = "buyemljar",
    allowed = { TEAM_BLUEMETHDEALER, TEAM_PRODRUGDEALER },
    category = "Laboratorio de Metanfetamina",
})

DarkRP.createEntity("acido muriatico", {
    ent = "eml_macid",
    model = "models/props_junk/garbage_plasticbottle001a.mdl",
    price = 22,
    max = 3,
    cmd = "buyemlmacid",
    allowed = { TEAM_BLUEMETHDEALER, TEAM_PRODRUGDEALER },
    category = "Laboratorio de Metanfetamina",
})

DarkRP.createEntity("Olla de Fosforo Rojo", {
    ent = "eml_pot",
    model = "models/props_c17/metalPot001a.mdl",
    price = 20,
    max = 4,
    cmd = "buyemlpot",
    allowed = { TEAM_BLUEMETHDEALER, TEAM_PRODRUGDEALER },
    category = "Laboratorio de Metanfetamina",
})

DarkRP.createEntity("Olla de Meta", {
    ent = "eml_spot",
    model = "models/props_c17/metalPot001a.mdl",
    price = 20,
    max = 4,
    cmd = "buyemlspot",
    allowed = { TEAM_BLUEMETHDEALER, TEAM_PRODRUGDEALER },
    category = "Laboratorio de Metanfetamina",
})

DarkRP.createEntity("Estufa", {
    ent = "eml_stove",
    model = "models/props_c17/furnitureStove001a.mdl",
    price = 400,
    max = 2,
    cmd = "buyemlstove",
    allowed = { TEAM_BLUEMETHDEALER, TEAM_PRODRUGDEALER },
    category = "Laboratorio de Metanfetamina",
})

DarkRP.createEntity("Azufre Liquido", {
    ent = "eml_sulfur",
    model = "models/props_lab/jar01b.mdl",
    price = 28,
    max = 3,
    cmd = "buyemlsulfur",
    allowed = { TEAM_BLUEMETHDEALER, TEAM_PRODRUGDEALER },
    category = "Laboratorio de Metanfetamina",
})

DarkRP.createEntity("Agua", {
    ent = "eml_water",
    model = "models/props_junk/garbage_plasticbottle003a.mdl",
    price = 5,
    max = 3,
    cmd = "buyemlwater",
    allowed = { TEAM_BLUEMETHDEALER, TEAM_PRODRUGDEALER },
    category = "Laboratorio de Metanfetamina",
})

--[[---------------------------------------------------------------------------
Investigation Mod
---------------------------------------------------------------------------]]--

DarkRP.createEntity("Scanner de Policia", {
	ent = "investigation_scanner",
	model = "models/venatuss/investigation_scanner/scanner.mdl",
	price = 400,
	max = 1,
	cmd = "investigation_scanner_pro",
    allowed = { TEAM_POLICIAINVESTIGACION },
    category = "Policia",
})

--[[---------------------------------------------------------------------------
Realistic Car Dealer
---------------------------------------------------------------------------]]--

DarkRP.createEntity("Mostrador", {
	ent = "rcd_showcase",
	model = "models/dimitri/kobralost/stand.mdl",
	price = 500,
	max = 2,
	cmd = "rcd_showcase",
    allowed = { TEAM_MECANICO },
    category = "Mecanico",
})

DarkRP.createEntity("Impresora", {
	ent = "rcd_printer",
	model = "models/dimitri/kobralost/printer.mdl",
	price = 500,
	max = 2,
	cmd = "rcd_printer",
    allowed = { TEAM_MECANICO },
    category = "Mecanico",
})

--[[---------------------------------------------------------------------------
The Cocaine Factory
---------------------------------------------------------------------------]]--

DarkRP.createEntity("Botella de Agua", {
    ent = "cocaine_water",
    model = "models/craphead_scripts/the_cocaine_factory/utility/water.mdl",
    price = 75,
    max = 5,
    category = "Fabrica de Cocaina",
    cmd = "buytcfwater",
    allowed = { TEAM_COCAINEDEALER, TEAM_PRODRUGDEALER },
})

DarkRP.createEntity("Horno", {
    ent = "cocaine_stove",
    model = "models/craphead_scripts/the_cocaine_factory/stove/gas_stove.mdl",
    price = 1500,
    max = 2,
    category = "Fabrica de Cocaina",
    cmd = "buytcfstove",
    allowed = { TEAM_COCAINEDEALER, TEAM_PRODRUGDEALER },
})

DarkRP.createEntity("Olla", {
    ent = "cocaine_cooking_pot",
    model = "models/craphead_scripts/the_cocaine_factory/utility/pot.mdl",
    price = 50,
    max = 10,
    category = "Fabrica de Cocaina",
    cmd = "buytcfpot",
    allowed = { TEAM_COCAINEDEALER, TEAM_PRODRUGDEALER },
})

DarkRP.createEntity("Balde", {
    ent = "cocaine_bucket",
    model = "models/craphead_scripts/the_cocaine_factory/utility/bucket.mdl",
    price = 75,
    max = 10,
    category = "Fabrica de Cocaina",
    cmd = "buytcfbucket",
    allowed = { TEAM_COCAINEDEALER, TEAM_PRODRUGDEALER },
})

DarkRP.createEntity("Hojas", {
    ent = "cocaine_leaves",
    model = "models/craphead_scripts/the_cocaine_factory/utility/leaves.mdl",
    price = 50,
    max = 10,
    category = "Fabrica de Cocaina",
    cmd = "buytcfleaves",
    allowed = { TEAM_COCAINEDEALER, TEAM_PRODRUGDEALER },
})

DarkRP.createEntity("Bateria", {
    ent = "cocaine_battery",
    model = "models/craphead_scripts/the_cocaine_factory/utility/battery.mdl",
    price = 150,
    max = 10,
    category = "Fabrica de Cocaina",
    cmd = "buytcfbattery",
    allowed = { TEAM_COCAINEDEALER, TEAM_PRODRUGDEALER },
})

DarkRP.createEntity("Contenedor de Gas", {
    ent = "cocaine_gas",
    model = "models/craphead_scripts/the_cocaine_factory/utility/gas_tank.mdl",
    price = 350,
    max = 8,
    category = "Fabrica de Cocaina",
    cmd = "buytcfgas",
    allowed = { TEAM_COCAINEDEALER, TEAM_PRODRUGDEALER },
})

DarkRP.createEntity("Tendedero", {
    ent = "cocaine_drying_rack",
    model = "models/craphead_scripts/the_cocaine_factory/drying_rack/drying_rack.mdl",
    price = 1500,
    max = 2,
    category = "Fabrica de Cocaina",
    cmd = "buytcfdryingrack",
    allowed = { TEAM_COCAINEDEALER, TEAM_PRODRUGDEALER },
})

DarkRP.createEntity("Caja de Cocaina", {
    ent = "cocaine_box",
    model = "models/craphead_scripts/the_cocaine_factory/utility/cocaine_box.mdl",
    price = 100,
    max = 4,
    category = "Fabrica de Cocaina",
    cmd = "buytcfcocainebox",
    allowed = { TEAM_COCAINEDEALER, TEAM_PRODRUGDEALER },
})

DarkRP.createEntity("Placa de Coccion", {
    ent = "cocaine_cooking_plate",
    model = "models/craphead_scripts/the_cocaine_factory/utility/stove_upgrade.mdl",
    price = 250,
    max = 4,
    category = "Fabrica de Cocaina",
    cmd = "buytcfplateupgrade",
    allowed = { TEAM_COCAINEDEALER, TEAM_PRODRUGDEALER },
})

DarkRP.createEntity("Extractor de Cocaina", {
    ent = "cocaine_extractor",
    model = "models/craphead_scripts/the_cocaine_factory/extractor/extractor.mdl",
    price = 1750,
    max = 2,
    category = "Fabrica de Cocaina",
    cmd = "buytcfextractor",
    allowed = { TEAM_COCAINEDEALER, TEAM_PRODRUGDEALER },
})

DarkRP.createEntity("Bicarbonato de sodio", {
    ent = "cocaine_baking_soda",
    model = "models/craphead_scripts/the_cocaine_factory/utility/soda.mdl",
    price = 50,
    max = 5,
    category = "Fabrica de Cocaina",
    cmd = "buytcfbakingsoda",
    allowed = { TEAM_COCAINEDEALER, TEAM_PRODRUGDEALER },
})

--[[---------------------------------------------------------------------------
Zero Trash Man
---------------------------------------------------------------------------]]--

DarkRP.createEntity("Quemador de basura", {
    ent = "ztm_trashburner",
    model = "models/zerochain/props_trashman/ztm_trashburner.mdl",
    price = 1000,
    max = 1,
    cmd = "buyztm_trashburner",
    allowed = { TEAM_ZTM_TRASHMAN },
    category = "Recolector de Basura",
})

DarkRP.createEntity("Reciclador de Basura", {
    ent = "ztm_recycler",
    model = "models/zerochain/props_trashman/ztm_recycler.mdl",
    price = 1000,
    max = 1,
    cmd = "buyztm_recycler",
    allowed = { TEAM_ZTM_TRASHMAN },
    category = "Recolector de Basura",
})

--[[---------------------------------------------------------------------------
Zero Retrominer
---------------------------------------------------------------------------]]--

DarkRP.createEntity("Grava - Caja", {
    ent = "zrms_gravelcrate",
	model = "models/zerochain/props_mining/zrms_refiner_basket.mdl",
	price = 250,
	max = 6,
	cmd = "buyzrms_gravelcrate",
	allowed = { TEAM_ZRMINE_MINER },
	category = "Minero",
})

DarkRP.createEntity("Refinador - Caja", {
    ent = "zrms_basket",
	model = "models/zerochain/props_mining/zrms_refiner_basket.mdl",
	price = 250,
	max = 12,
	cmd = "buyzrms_basket",
	allowed = { TEAM_ZRMINE_MINER },
	category = "Minero",
})

DarkRP.createEntity("Caja de Almacenamiento", {
    ent = "zrms_storagecrate",
	model = "models/zerochain/props_mining/zrms_storagecrate.mdl",
	price = 25,
	max = 6,
	cmd = "buyzrms_storagecrate",
	allowed = { TEAM_ZRMINE_MINER },
	category = "Minero",
})

DarkRP.createEntity("Minero Automático", {
    ent = "zrms_mineentrance_base",
	model = "models/zerochain/props_mining/mining_entrance.mdl",
	price = 100000,
	max = 3,
	cmd = "buyzrms_mineentrance_base",
	allowed = { TEAM_ZRMINE_MINER },
	category = "Minero",
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 7
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 7 then
            return "Necesitas ser nivel 7 para comprar esto!"
        end
    end,
})

DarkRP.createEntity("Fundidor", {
    ent = "zrms_melter",
	model = "models/zerochain/props_mining/zrms_melter.mdl",
	price = 750,
	max = 2,
	cmd = "buyzrms_melter",
	allowed = { TEAM_ZRMINE_MINER },
	category = "Minero",
})

--[[---------------------------------------------------------------------------
Perfect Radar System
---------------------------------------------------------------------------]]--

DarkRP.createEntity("Camara de Velocidad", {
    ent = "english_speed_camera",
    model = "models/speed_camera/speed_camera.mdl",
    price = 500,
    max = 3,
    cmd = "buyenglishspeedcamera",
    allowed = { TEAM_POLICIATRANSITO },
    category = "Policia",
})

--[[---------------------------------------------------------------------------
Advanced Farming Mod
---------------------------------------------------------------------------]]--

DarkRP.createEntity("Vaca", {
    ent = "fmod_cow",
    model = "models/farmingmod/cow/cow.mdl",
    price = 1000,
    max = 2,
    cmd = "buycow",
    allowed = { TEAM_GRANJERO },
    category = "Granjero",
})

DarkRP.createEntity("Cubo de agua (SOLO VACAS)", {
    ent = "fmod_water_cow",
    model = "models/props_junk/metalbucket02a.mdl",
    price = 100,
    max = 2,
    cmd = "buycowbuket",
    allowed = { TEAM_GRANJERO },
    category = "Granjero",
})

DarkRP.createEntity("Cubo de agua", {
    ent = "fmod_water",
    model = "models/props_junk/MetalBucket01a.mdl",
    price = 100,
    max = 4,
    cmd = "buywaterbucket",
    allowed = { TEAM_GRANJERO },
    category = "Granjero",
})

DarkRP.createEntity("Caja de huevos", {
    ent = "fmod_crate_egg",
    model = "models/farmingmod/crate/crate.mdl",
    price = 50,
    max = 3,
    cmd = "buyegg",
    allowed = { TEAM_GRANJERO },
    category = "Granjero",
})

DarkRP.createEntity("Gallina", {
    ent = "fmod_hen",
    model = "models/farmingmod/hen/hen.mdl",
    price = 1000,
    max = 2,
    cmd = "buyhen",
    allowed = { TEAM_GRANJERO },
    category = "Granjero",
})

DarkRP.createEntity("Cabra", {
    ent = "fmod_sheep",
    model = "models/farmingmod/sheep/sheep.mdl",
    price = 1000,
    max = 2,
    cmd = "buygoat",
    allowed = { TEAM_GRANJERO },
    category = "Granjero",
})

DarkRP.createEntity("Barril de leche", {
    ent = "fmod_barrel",
    model = "models/farmingmod/milk_barrel/milk_barrel.mdl",
    price = 50,
    max = 2,
    cmd = "buybarrel",
    allowed = { TEAM_GRANJERO },
    category = "Granjero",
})

DarkRP.createEntity("Cubo de leche", {
    ent = "fmod_milk_bucket",
    model = "models/props_junk/MetalBucket01a.mdl",
    price = 100,
    max = 1,
    cmd = "buymilkbucket",
    allowed = { TEAM_GRANJERO },
    category = "Granjero",
})

DarkRP.createEntity("Cerdo", {
    ent = "fmod_pig",
    model = "models/farmingmod/pig/pig.mdl",
    price = 1000,
    max = 2,
    cmd = "buypig",
    allowed = { TEAM_GRANJERO },
    category = "Granjero",
})

DarkRP.createEntity("Comedero", {
    ent = "fmod_trough",
    model = "models/props_junk/metalbucket02a.mdl",
    price = 50,
    max = 4,
    cmd = "buytrough",
    allowed = { TEAM_GRANJERO },
    category = "Granjero",
})

DarkRP.createEntity("Bolsa de trigo", {
    ent = "fmod_wheat",
    model = "models/farmingmod/wheat_bag/wheat_bag.mdl",
    price = 100,
    max = 2,
    cmd = "buygrainelcrp",
    allowed = { TEAM_GRANJERO },
    category = "Granjero",
})

DarkRP.createEntity("Fuente de Agua", {
    ent = "fmod_well",
    model = "models/farmingmod/well/well.mdl",
    price = 1200,
    max = 1,
    cmd = "buyfmodwell",
    allowed = { TEAM_GRANJERO },
    category = "Granjero",
})

--[[---------------------------------------------------------------------------
Especiales
---------------------------------------------------------------------------]]--

DarkRP.createEntity("Pyrozooka", {
	ent = "pyrozooka",
	model = "models/zerochain/pyrozooka/w_pyrozooka.mdl",
	price = 200000,
	max = 1,
	cmd = "buypyrozooka",
	-- allowed = TEAM_ZFRUITSLICER,
	category = "Especiales",
})

DarkRP.createEntity("Chaleco Juggernaut", {
    ent = "ent_djagger_armor",
    model = "models/props_junk/cardboard_box002b.mdl",
    price = 20000,
    max = 1,
    cmd = "buydjaggerarmor",
    allowed = { TEAM_MEDICO },
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 7
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 7 then
            return "Necesitas ser nivel 7 para comprar esto!"
        end
    end,
    category = "Especiales",
})

DarkRP.createEntity("Chaleco Pesado", {
    ent = "ent_hard_armor",
    model = "models/props_junk/cardboard_box003b.mdl",
    price = 10000,
    max = 1,
    cmd = "buyhardarmor",
    allowed = { TEAM_MEDICO },
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 5
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 5 then
            return "Necesitas ser nivel 5 para comprar esto!"
        end
    end,
    category = "Especiales",
})

DarkRP.createEntity("Chaleco Kevlar", {
    ent = "ent_kevlar_armor",
    model = "models/props_junk/cardboard_box004a.mdl",
    price = 2000,
    max = 1,
    cmd = "buykevlararmor",
    allowed = { TEAM_MEDICO },
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 4
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 4 then
            return "Necesitas ser nivel 4 para comprar esto!"
        end
    end,
    category = "Especiales",
})

--[[---------------------------------------------------------------------------
Paramedic Essentials
---------------------------------------------------------------------------]]--

DarkRP.createEntity( "Kit Medico +25", {
    ent = "medic_healthkit_25",
	model = "models/craphead_scripts/paramedic_essentials/weapons/w_medpack.mdl",
	price = 800,
	max = 5,
	cmd = "buyhealth25",
	allowed = { TEAM_MEDIC },
	category = "Medico",
})

DarkRP.createEntity( "Kit Medico +50", {
    ent = "medic_healthkit_50",
	model = "models/craphead_scripts/paramedic_essentials/weapons/w_medpack.mdl",
	price = 1500,
	max = 5,
	cmd = "buyhealth50",
	allowed = { TEAM_MEDIC },
	category = "Medico",
})

DarkRP.createEntity( "Alerta de Vida", {
    ent = "ch_medic_lifealert",
	model = "models/craphead_scripts/paramedic_essentials/props/alarm.mdl",
	price = 4000,
	max = 1,
	cmd = "buylifealert",
	allowed = { TEAM_MEDIC },
	category = "Medico",
})

--[[---------------------------------------------------------------------------
Illegal Firework Maker
---------------------------------------------------------------------------]]--

DarkRP.createEntity("Maquina de fuegos artificiales", {
    ent = "zcm_crackermachine",
    model = "models/zerochain/props_crackermaker/zcm_base.mdl",
    price = 5000,
    max = 1,
    cmd = "buyzcm_crackermachine",
    allowed = {TEAM_ZCM_FIREWORKMAKER},
    category = "Fuegos Artificiales",
    description = [[
        Es tan facil como ponerle un poco de pólvora y encenderla.
        Reglas:
        - No spawnear dentro de un cuarto pequeño porque puede explotar.
    ]],
    -- customCheck = function(ply)
    -- end,
    -- CustomCheckFailMsg = "No hay suficiente espacio para colocar esto!",
})

DarkRP.createEntity("Polvora", {
    ent = "zcm_blackpowder",
    model = "models/zerochain/props_crackermaker/zcm_blackpowder.mdl",
    price = 1000,
    max = 3,
    cmd = "buyzcm_blackpowder",
    allowed = {TEAM_ZCM_FIREWORKMAKER},
    category = "Fuegos Artificiales",
})

DarkRP.createEntity("Papel", {
    ent = "zcm_paperroll",
    model = "models/zerochain/props_crackermaker/zcm_paper.mdl",
    price = 1000,
    max = 3,
    cmd = "buyzcm_paperroll",
    allowed = {TEAM_ZCM_FIREWORKMAKER},
    category = "Fuegos Artificiales",
})

DarkRP.createEntity("Caja", {
    ent = "zcm_box",
    model = "models/zerochain/props_crackermaker/zcm_box.mdl",
    price = 100,
    max = 3,
    cmd = "buyzcm_box",
    allowed = {TEAM_ZCM_FIREWORKMAKER},
    category = "Fuegos Artificiales",
})

DarkRP.createEntity("Paleta", {
    ent = "zcm_palette",
    model = "models/props_junk/wood_pallet001a.mdl",
    price = 100,
    max = 2,
    cmd = "buyzcm_palette",
    allowed = {TEAM_ZCM_FIREWORKMAKER},
    category = "Fuegos Artificiales",
})

--[[---------------------------------------------------------------------------
Oil Rush
---------------------------------------------------------------------------]]--

DarkRP.createEntity("Kit de construcción", {
    ent = "zrush_machinecrate",
    model = "models/zerochain/props_oilrush/zor_machinecrate.mdl",
    price = 250,
    max = 8,
    cmd = "buyzrushmachinecrate",
    allowed = { TEAM_ZRUSH_FUELPRODUCER },
    category = "Refinador de combustible",
})

DarkRP.createEntity("Barril", {
    ent = "zrush_barrel",
    model = "models/zerochain/props_oilrush/zor_barrel.mdl",
    price = 100,
    max = 10,
    cmd = "buyzrushbarrel",
    allowed = { TEAM_ZRUSH_FUELPRODUCER },
    category = "Refinador de combustible",
})

DarkRP.createEntity("10x tubos", {
    ent = "zrush_drillpipe_holder",
    model = "models/zerochain/props_oilrush/zor_drillpipe_holder.mdl",
    price = 100,
    max = 10,
    cmd = "buyzrushdrillpipeholder",
    allowed = { TEAM_ZRUSH_FUELPRODUCER },
    category = "Refinador de combustible",
})

DarkRP.createEntity("Paleta", {
    ent = "zrush_palette",
    model = "models/props_junk/wood_pallet001a.mdl",
    price = 100,
    max = 2,
    cmd = "buyzrush_palette",
    allowed = { TEAM_ZRUSH_FUELPRODUCER },
    category = "Refinador de combustible",
})

--[[---------------------------------------------------------------------------
Pizza Maker
---------------------------------------------------------------------------]]--

DarkRP.createEntity("Horno para pizzas", {
    ent = "zpiz_oven",
    model = "models/zerochain/props_pizza/zpizmak_oven.mdl",
    price = 250,
    max = 3,
    cmd = "buyzpiz_PizzaOven",
    allowed = { TEAM_ZPIZ_CHEF },
    category = "Pizzero",
})

DarkRP.createEntity("Nevera", {
    ent = "zpiz_fridge",
    model = "models/props_c17/FurnitureFridge001a.mdl",
    price = 100,
    max = 1,
    cmd = "buyzpiz_fridge",
    allowed = { TEAM_ZPIZ_CHEF },
    category = "Pizzero",
})

DarkRP.createEntity("Mesa de clientes", {
    ent = "zpiz_customertable",
    model = "models/props_c17/FurnitureTable001a.mdl",
    price = 200,
    max = 3,
    cmd = "buyzpiz_customertable",
    allowed = { TEAM_ZPIZ_CHEF },
    category = "Pizzero",
})

DarkRP.createEntity("Letrero para abrir", {
    ent = "zpiz_opensign",
    model = "models/props_trainstation/TrackSign02.mdl",
    price = 50,
    max = 1,
    cmd = "buyzpiz_opensign",
    allowed = { TEAM_ZPIZ_CHEF },
    category = "Pizzero",
})

--[[---------------------------------------------------------------------------
Magic Mushroomfactory
---------------------------------------------------------------------------]]--

DarkRP.createEntity("Plantador", {
    model = "models/dom/magicmushroomfactory/planter.mdl",
    ent = "mmf_planter",
    price = 1000,
    max = 12,
    cmd = "buymmfplanter",
    allowed = { TEAM_RECOLECTORHONGOS },
    category = "Hongos Magicos",
})

DarkRP.createEntity("Caldero", {
    model = "models/dom/magicmushroomfactory/cdd/caldeidom.mdl",
    ent = "mmf_caldeidom",
    price = 4000,
    max = 12,
    cmd = "buymmfcaldeidom",
    allowed = { TEAM_RECOLECTORHONGOS },
    category = "Hongos Magicos",
})

DarkRP.createEntity("Calentador", {
    model = "models/dom/magicmushroomfactory/cdd/heater.mdl",
    ent = "mmf_heater",
    price = 1000,
    max = 12,
    cmd = "buymmfheater",
    allowed = { TEAM_RECOLECTORHONGOS },
    category = "Hongos Magicos",
})

DarkRP.createEntity("Libro Guía", {
    model = "models/dom/magicmushroomfactory/book.mdl",
    ent = "mmf_guide",
    price = 100,
    max = 2,
    cmd = "buymmfguide",
    allowed = { TEAM_RECOLECTORHONGOS },
    category = "Hongos Magicos",
})

timer.Simple(1, function()
    if MMF then 
        for key, mushroom in pairs(MMF.Mushrooms) do
            DarkRP.createEntity("Hongo " .. mushroom.Name, {
                model = "models/dom/magicmushroomfactory/seed.mdl",
                skin = mushroom.Skin,
                ent = "mmf_" .. key .. "_seed",
                price = 100,
                max = 100,
                cmd = "buyseed" .. key,
                allowed = { TEAM_RECOLECTORHONGOS },
                category = "Hongos Magicos",
            })
        end
    end
end)

--[[---------------------------------------------------------------------------
CH Bitminers
---------------------------------------------------------------------------]]--

-- Entities
DarkRP.createEntity("Cable de energia", {
    ent = "ch_bitminer_power_cable",
    model = "models/craphead_scripts/bitminers/utility/plug.mdl",
    price = 150,
    max = 5,
    category = "Criptomineria",
    cmd = "buypowercable",
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 4
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 4 then
            return "Necesitas ser nivel 4 para comprar esto!"
        end
    end,
})

DarkRP.createEntity("Generador", {
    ent = "ch_bitminer_power_generator",
    model = "models/craphead_scripts/bitminers/power/generator.mdl",
    price = 1500,
    max = 4,
    category = "Criptomineria",
    cmd = "buypowergenerator",
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 4
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 4 then
            return "Necesitas ser nivel 4 para comprar esto!"
        end
    end,
})

DarkRP.createEntity("Panel solar", {
    ent = "ch_bitminer_power_solar",
    model = "models/craphead_scripts/bitminers/power/solar_panel.mdl",
    price = 3000,
    max = 2,
    category = "Criptomineria",
    cmd = "buysolarpanel",
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 4
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 4 then
            return "Necesitas ser nivel 4 para comprar esto!"
        end
    end,
})

DarkRP.createEntity("Combinador de potencia", {
    ent = "ch_bitminer_power_combiner",
    model = "models/craphead_scripts/bitminers/power/power_combiner.mdl",
    price = 1000,
    max = 2,
    category = "Criptomineria",
    cmd = "buypowercombiner",
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 4
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 4 then
            return "Necesitas ser nivel 4 para comprar esto!"
        end
    end,
})

DarkRP.createEntity("Generador termoelectrico de radioisotopos", {
    ent = "ch_bitminer_power_rtg",
    model = "models/craphead_scripts/bitminers/power/rtg.mdl",
    price = 4500,
    max = 2,
    category = "Criptomineria",
    cmd = "buynucleargenerator",
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 4
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 4 then
            return "Necesitas ser nivel 4 para comprar esto!"
        end
    end,
})

DarkRP.createEntity("Estante de Mineria", {
    ent = "ch_bitminer_shelf",
    model = "models/craphead_scripts/bitminers/rack/rack.mdl",
    price = 5000,
    max = 1,
    category = "Criptomineria",
    cmd = "buyminingshelf",
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 4
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 4 then
            return "Necesitas ser nivel 4 para comprar esto!"
        end
    end,
})

DarkRP.createEntity("Actualizacion de refrigeracion 1", {
    ent = "ch_bitminer_upgrade_cooling1",
    model = "models/craphead_scripts/bitminers/utility/cooling_upgrade_1.mdl",
    price = 3000,
    max = 10,
    category = "Criptomineria",
    cmd = "buycooling1",
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 4
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 4 then
            return "Necesitas ser nivel 4 para comprar esto!"
        end
    end,
})

DarkRP.createEntity("Actualizacion de refrigeracion 2", {
    ent = "ch_bitminer_upgrade_cooling2",
    model = "models/craphead_scripts/bitminers/utility/cooling_upgrade_2.mdl",
    price = 4000,
    max = 10,
    category = "Criptomineria",
    cmd = "buycooling2",
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 4
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 4 then
            return "Necesitas ser nivel 4 para comprar esto!"
        end
    end,
})

DarkRP.createEntity("Actualizacion de refrigeracion 3", {
    ent = "ch_bitminer_upgrade_cooling3",
    model = "models/craphead_scripts/bitminers/utility/cooling_upgrade_3.mdl",
    price = 5000,
    max = 10,
    category = "Criptomineria",
    cmd = "buycooling3",
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 4
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 4 then
            return "Necesitas ser nivel 4 para comprar esto!"
        end
    end,
})

DarkRP.createEntity("Minero unico", {
    ent = "ch_bitminer_upgrade_miner",
    model = "models/craphead_scripts/bitminers/utility/miner_solo.mdl",
    price = 450,
    max = 8,
    category = "Criptomineria",
    cmd = "buysingleminer",
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 4
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 4 then
            return "Necesitas ser nivel 4 para comprar esto!"
        end
    end,
})

DarkRP.createEntity("Actualizacion del kit RGB", {
    ent = "ch_bitminer_upgrade_rgb",
    model = "models/craphead_scripts/bitminers/utility/rgb_kit.mdl",
    price = 1000,
    max = 8,
    category = "Criptomineria",
    cmd = "buyrgbkit",
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 4
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 4 then
            return "Necesitas ser nivel 4 para comprar esto!"
        end
    end,
})

DarkRP.createEntity("Actualizacion de la fuente de alimentacion", {
    ent = "ch_bitminer_upgrade_ups",
    model = "models/craphead_scripts/bitminers/utility/ups_solo.mdl",
    price = 500,
    max = 8,
    category = "Criptomineria",
    cmd = "buyupsupgrade",
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 4
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 4 then
            return "Necesitas ser nivel 4 para comprar esto!"
        end
    end,
})

DarkRP.createEntity("Combustible - Pequeño", {
    ent = "ch_bitminer_power_generator_fuel_small",
    model = "models/craphead_scripts/bitminers/utility/jerrycan.mdl",
    price = 500,
    max = 5,
    category = "Criptomineria",
    cmd = "buygeneratorfuelsmall",
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 4
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 4 then
            return "Necesitas ser nivel 4 para comprar esto!"
        end
    end,
})

DarkRP.createEntity("Combustible - Medio", {
    ent = "ch_bitminer_power_generator_fuel_medium",
    model = "models/craphead_scripts/bitminers/utility/jerrycan.mdl",
    price = 1000,
    max = 5,
    category = "Criptomineria",
    cmd = "buygeneratorfuelmedium",
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 4
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 4 then
            return "Necesitas ser nivel 4 para comprar esto!"
        end
    end,
})

DarkRP.createEntity("Combustible - Grande", {
    ent = "ch_bitminer_power_generator_fuel_large",
    model = "models/craphead_scripts/bitminers/utility/jerrycan.mdl",
    price = 1500,
    max = 5,
    category = "Criptomineria",
    cmd = "buygeneratorfuellarge",
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 4
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 4 then
            return "Necesitas ser nivel 4 para comprar esto!"
        end
    end,
})

DarkRP.createEntity("Liquido de limpieza", {
    ent = "ch_bitminer_upgrade_clean_dirt",
    model = "models/craphead_scripts/bitminers/cleaning/spraybottle.mdl",
    price = 500,
    max = 5,
    category = "Criptomineria",
    cmd = "buydirtcleanfluid",
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 4
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 4 then
            return "Necesitas ser nivel 4 para comprar esto!"
        end
    end,
})

DarkRP.createEntity("USB de Hacker", {
    ent = "ch_bitminer_hacking_usb",
    model = "models/craphead_scripts/bitminers/dlc/usb.mdl",
    price = 1500,
    max = 2,
    category = "Criptomineria",
    cmd = "buyhackingusb",
})

DarkRP.createEntity("USB Antivirus", {
    ent = "ch_bitminer_antivirus_usb",
    model = "models/craphead_scripts/bitminers/dlc/usb_second.mdl",
    price = 1500,
    max = 2,
    category = "Criptomineria",
    cmd = "buyantivirususb",
})

DarkRP.createEntity("Terminal para tarjetas de credito", {
    ent = "ch_atm_card_scanner",
    model = "models/craphead_scripts/ch_atm/terminal.mdl",
    price = 250,
    max = 2,
    cmd = "buycreditcardterminal",
    category = "Dinero",
})

DarkRP.createEntity("Camara de seguridad", {
	ent = "realistic_police_camera",
	model = "models/wasted/wasted_kobralost_camera.mdl",
	price = 500,
	max = 3,
	cmd = "realistic_police_camera",
	category = "Administrador de Camaras",
})

DarkRP.createEntity("Pantalla de seguridad", {
	ent = "realistic_police_screen",
	model = "models/props/cs_office/tv_plasma.mdl",
	price = 500,
	max = 1,
	cmd = "realistic_police_screen",
	category = "Administrador de Camaras",
})

--[[---------------------------------------------------------------------------
Tomas Custom Printers
---------------------------------------------------------------------------]]--

DarkRP.createEntity("Impresora Azul", {
    ent = "boost_printer",
    model = "models/props_c17/consolebox01a.mdl",
    price = 2000,
    max = 1,
    cmd = "buyblueprinter",
    category = "Dinero",
})

DarkRP.createEntity("Impresora Roja", {
    ent = "boost_printer_red",
    model = "models/props_c17/consolebox01a.mdl",
    price = 3000,
    max = 1,
    cmd = "buyredprinter",
    category = "Dinero",
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 2
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 2 then
            return "Necesitas ser nivel 2 o superior para comprar esta impresora."
        end
    end,
})

DarkRP.createEntity("Impresora Verde", {
    ent = "boost_printer_green",
    model = "models/props_c17/consolebox01a.mdl",
    price = 5000,
    max = 1,
    cmd = "buygreenprinter",
    category = "Dinero",
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 4
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 4 then
            return "Necesitas ser nivel 4 o superior para comprar esta impresora."
        end
    end,
})

DarkRP.createEntity("Impresora Amarilla", {
    ent = "boost_printer_yellow",
    model = "models/props_c17/consolebox01a.mdl",
    price = 8000,
    max = 1,
    cmd = "buyyellowprinter",
    category = "Dinero",
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 7
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 7 then
            return "Necesitas ser nivel 7 o superior para comprar esta impresora."
        end
    end,
})

DarkRP.createEntity("Impresora Morada", {
    ent = "boost_printer_purple",
    model = "models/props_c17/consolebox01a.mdl",
    price = 10000,
    max = 1,
    cmd = "buypurpleprinter",
    category = "Dinero",
    customCheck = function(ply)
        return CLIENT or ply:getDarkRPVar("level") >= 9
    end,
    CustomCheckFailMsg = function(ply)
        if ply:getDarkRPVar("level") < 9 then
            return "Necesitas ser nivel 9 o superior para comprar esta impresora."
        end
    end,
})

DarkRP.createEntity("Bateria de Impresora", {
    ent = "boost_battery",
    model = "models/Items/car_battery01.mdl",
    price = 100,
    max = 3,
    cmd = "buyprinterbattery",
    category = "Dinero",
})
