--[[---------------------------------------------------------------------------
DarkRP custom jobs
---------------------------------------------------------------------------
This file contains your custom jobs.
This file should also contain jobs from DarkRP that you edited.

Note: If you want to edit a default DarkRP job, first disable it in darkrp_config/disabled_defaults.lua
      Once you've done that, copy and paste the job to this file and edit it.

The default jobs can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/jobrelated.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomJobFields

Add your custom jobs under the following line:
---------------------------------------------------------------------------]]

TEAM_CIUDADANO = DarkRP.createJob("Ciudadano", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/player/Group01/Female_01.mdl",
        "models/player/Group01/Female_02.mdl",
        "models/player/Group01/Female_03.mdl",
        "models/player/Group01/Female_04.mdl",
        "models/player/Group01/Female_06.mdl",
        "models/player/group01/male_01.mdl",
        "models/player/Group01/Male_02.mdl",
        "models/player/Group01/male_03.mdl",
        "models/player/Group01/Male_04.mdl",
        "models/player/Group01/Male_05.mdl",
        "models/player/Group01/Male_06.mdl",
        "models/player/Group01/Male_07.mdl",
        "models/player/Group01/Male_08.mdl",
        "models/player/Group01/Male_09.mdl"
    },
    description = [[
        El ciudadano es el nivel mas basico de la sociedad que puede tener ademas de ser un vagabundo.
        No tienes un papel especifico en la vida de la ciudad.
    ]],
    weapons = {
    },
    command = "ciudadano",
    max = 0,
    salary = GM.Config.normalsalary,
    category = "Ciudadanos",
    unlockPrice = 0,
})

TEAM_VAGABUNDO = DarkRP.createJob("Vagabundo", {
    color = Color(80, 45, 0, 255),
    model = {
        "models/player/corpse1.mdl",
    },
    description = [[
        El miembro mas bajo de la sociedad.
        Todo el mundo se rie de ti.
        Ruega por tu comida y dinero
        Canta para todos los que pasan para conseguir dinero.
        Prueba tu suerte buscando en los contenedores de basura.
        Ve a construir tu casa de madera en algun lugar de una esquina o fuera de la puerta de otra persona
        Complaces al rey vagabundo con cosas al azar que encuentras
    ]],
    weapons = {
        "weapon_bugbait"
    },
    command = "vagabundo",
    max = 5,
    salary = 0,
    hobo = true,
    category = "Ciudadanos",
    unlockPrice = 0,
})

TEAM_DJ = DarkRP.createJob("Dj", {
    color = Color(150, 0, 125),
    model = {
        "models/player/dewobedil/mortal_kombat/baby_default_p.mdl"
    },
    description = [[

    ]],
    weapons = {},
    command = "dj",
    max = 1,
    salary = GM.Config.normalsalary,
    category = "Criminales",
    unlockPrice = 0,
})

--[[---------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
Crimen
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
---------------------------------------------------------------------------]]--

TEAM_REYVAGABUNDO = DarkRP.createJob("Rey Vagabundo", {
    color = Color(142, 83, 0, 255),
    model = {
        "models/player/corpse1.mdl",
    },
    description = [[
        Puedes asaltar, pero solo si tienes compañeros vagabundos contigo
        Ve a arrojar mierda a los cadaveres
        Puedes vender cualquier cosa que encuentres
        Haz un poderoso imperio con tus vagabundos.
    ]],
    weapons = {
        "weapon_bugbait", "weapon_crowbar"
    },
    command = "reyvagabundo",
    max = 1,
    salary = GM.Config.normalsalary,
    hobo = true,
    level = 5,
    category = "Criminales",
    unlockPrice = 0,
})

TEAM_LADRON = DarkRP.createJob("Ladron", {
    color = Color(86, 86, 86, 255),
    model = {
        "models/player/robber.mdl",
    },
    description = [[
        Eres un ladron, roba a la gente, abre sus casas y roba sus cosas.
        Consigue el lockpick normal en el armero.
    ]],
    weapons = {
    },
    command = "ladron",
    max = 3,
    salary = GM.Config.normalsalary,
    category = "Criminales",
    unlockPrice = 0,
})

TEAM_LADRONPRO = DarkRP.createJob("Ladron Profesional", {
    color = Color(86, 86, 86, 255),
    model = {
        "models/code_gs/robber/robberplayer.mdl",
    },
    description = [[
        Eres un ladrón experimentado, robas todo lo que se te plazca.
        Consigue el lockpick profesional en el armero.
    ]],
    weapons = {
        "jewelry_robbery_cellphone", "lockpick"
    }, -- You may wanna find a pickpocket swep and add it here.
    command = "ladronpro",
    max = 3,
    salary = GM.Config.normalsalary * 1.2,
    level = 5,
    category = "Criminales",
    unlockPrice = 15000,
    customCheck = function(ply)
        return CLIENT or ply:CheckGroup("vipgiant")
    end,
    CustomCheckFailMsg = "Necesitas ser VIP Giant para ser Ladron Profesional",
})

TEAM_TERRORISTA = DarkRP.createJob("Terrorista", {
    color = Color(255, 140, 0, 255),
    model = {
        "models/player/phoenix.mdl",
    },
    description = [[
    Encargate de matar policias, asusta y mata a la gente(con advertencias).
    ]],
    weapons = {}, -- You may wanna find a pickpocket swep and add it here.
    command = "terrorista",
    max = 2,
    salary = GM.Config.normalsalary,
    level = 10,
    category = "Criminales",
    unlockPrice = 300000,
})

TEAM_LIDERRESISTENCIA = DarkRP.createJob("Lider de Resistencia", {
    color = Color(255, 140, 0, 255),
    model = {
        "models/player/elvis_fix/t_leet.mdl",
    },
    description = [[
        Te encargas de dirigir al grupo de terrorista, el cual atacara al gobierno.
    ]],
    weapons = {
        "m9k_sig_p229r"
    },
    command = "liderresistencia",
    max = 1,
    salary = GM.Config.normalsalary * 4,
    level = 15,
    category = "Criminales",
    unlockPrice = 90000,
})

TEAM_DICTADOR = DarkRP.createJob("Dictador", {
    color = Color(255, 140, 0, 255),
    model = {
        "models/player/hitler/hitler.mdl",
    },
    description = [[
        Sos como Hitler.
        Podes hacer golpe de estado dando un tiempo al gobierno a prepararse y poniendo: /advert golpe de estado en x cantidad de tiempo
    ]],
    weapons = {
        "m9k_sig_p229r"
    },
    command = "dictador",
    max = 1,
    salary = GM.Config.normalsalary * 2,
    level = 15,
    category = "Criminales",
    unlockPrice = 75000,
})

TEAM_CRIPS = DarkRP.createJob("Pandilla Crips", {
    color = Color(45, 94, 255),
    model = {
        "models/player/cripz/slow_1.mdl",
        "models/player/cripz/slow_2.mdl",
        "models/player/cripz/slow_3.mdl",
    },
    description = [[
        Perteneces a la pandilla de los crips.
        Si te encontras a alguien de los bloods podes matarlo, siempre y cuando la policia no te vea.
    ]],
    weapons = {},
    command = "crips",
    max = 5,
    salary = GM.Config.normalsalary,
    level = 3,
    category = "Criminales",
    unlockPrice = 5000,
})

TEAM_BLOODS = DarkRP.createJob("Pandilla Bloods", {
    color = Color(255, 45, 45),
    model = {
        "models/player/bloodz/slow_1.mdl",
        "models/player/bloodz/slow_2.mdl",
        "models/player/bloodz/slow_3.mdl",
    },
    description = [[
        Perteneces a la pandilla de los bloods.
        Si te encontras a alguien de los crips podes matarlo, siempre y cuando la policia no te vea.
    ]],
    weapons = {},
    command = "bloods",
    max = 5,
    salary = GM.Config.normalsalary,
    level = 3,
    category = "Criminales",
    unlockPrice = 5000,
})

TEAM_MAFIARUSA = DarkRP.createJob("Mafia Rusa", {
    color = Color(45, 94, 255),
    model = {
        "models/player/putin.mdl",
        "models/ex-mo/quake3/players/doom.mdl",
    },
    description = [[
        Perteneces a la mafia rusa, eres como cualquier otro grupo de criminales
    ]],
    weapons = {},
    command = "mafiarusa",
    max = 4,
    salary = GM.Config.normalsalary * 2,
    level = 3,
    category = "Criminales",
    unlockPrice = 5000,
})

TEAM_MAFIAITALIANA = DarkRP.createJob("Mafia Italiana", {
    color = Color(45, 94, 255),
    model = {
        "models/player/tommy_vercetti.mdl",
        "models/hotlinemiami/russianmafia/mafia02pm.mdl",
        "models/hotlinemiami/russianmafia/mafia04pm.mdl",
        "models/hotlinemiami/russianmafia/mafia06pm.mdl",
        "models/hotlinemiami/russianmafia/mafia07pm.mdl",
        "models/hotlinemiami/russianmafia/mafia08pm.mdl",
        "models/hotlinemiami/russianmafia/mafia09pm.mdl",
    },
    description = [[
        Perteneces a la mafia italiana, eres como cualquier otro grupo de criminales
    ]],
    weapons = {},
    command = "mafiaitaliana",
    max = 4,
    salary = GM.Config.normalsalary * 2,
    level = 3,
    category = "Criminales",
    unlockPrice = 5000,
})

--[[---------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
Farmeo / Servicios Ilegales
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
---------------------------------------------------------------------------]]--

TEAM_RECOLECTORHONGOS = DarkRP.createJob("Recolector de hongos magicos", {
    color = Color(230, 41, 204),
    model = {
        "models/dom/magicmushroomfactory/gnomio/gnomio_pm.mdl"
    },
    description = [[
        ¡Vendes hongos raros!
    ]],
    max = 2,
    salary = GM.Config.normalsalary * 0.5,
    command = "gnomier",
    weapons = {},
    category = "Criminales",
    unlockPrice = 0,
})

TEAM_HACKER = DarkRP.createJob("Hacker", {
    color = Color(84 ,255 ,255 ,167),
    model = {
        "models/code_gs/robber/robberplayer.mdl"
    },
    description = [[
        Sos una persona, la cual se dedica a poner musica y divertirte.
    ]],
    weapons = {
        "weapon_acracker_fast",
    },
    command = "hacker",
    salary = GM.Config.normalsalary * 2,
    max = 3,
    level = 3,
    category = "Criminales",
    unlockPrice = 5000,
})

TEAM_ASESINO = DarkRP.createJob("Hitman", {
    color = Color(45, 94, 255),
    model = {
        "models/player/big_boss.mdl",
    },
    description = [[
        Eres un asesino a sueldo.
        Pide o espera a que la gente te de hit para salir a matar.
        Hay que respetar un intervalo de 5 minutos entre hit y hit.
    ]],
    weapons = {
        "slownls_hitman_binoculars", "slownls_hitman_tablet",
        "m9k_acr",
    },
    command = "asesino",
    max = 3,
    salary = GM.Config.normalsalary,
    hasLicense = true,
    level = 5,
    category = "Asesinos",
    unlockPrice = 15000,
})

TEAM_VENGADOR = DarkRP.createJob("Vengador", {
    color = Color(255, 51, 0),
    model = {
        "models/player/aphaztech.mdl",
    },
    description = [[
        
    ]],
    weapons = {
        "m9k_coltpython",
    },
    command = "vengador",
    max = 1,
    salary = GM.Config.normalsalary * 2,
    level = 5,
    category = "Criminales",
    unlockPrice = 150000,
    customCheck = function(ply)
        return CLIENT or ply:CheckGroup("viplegend")
    end,
    CustomCheckFailMsg = "Necesitas ser VIP Legend para ser Vengador",
})

TEAM_JEFEDEMAFIA = DarkRP.createJob("Jefe de Mafia", {
    color = Color(0, 3, 49),
    model = {
        "models/player/aphaztech.mdl",
    },
    description = [[
        
    ]],
    weapons = {
        "m9k_coltpython",
    },
    command = "jefedemafia",
    max = 1,
    salary = GM.Config.normalsalary * 2,
    category = "Criminales",
    unlockPrice = 35000,
    customCheck = function(ply)
        return CLIENT or ply:CheckGroup("viplegend")
    end,
    CustomCheckFailMsg = "Necesitas ser VIP Legend para ser Vengador",
})

TEAM_BLUEMETHDEALER = DarkRP.createJob("Traficante de Meta Azul", {
    color = Color(0, 128, 255, 255),
    model = { "models/player/aphaztech.mdl" },
    description = [[
        Cocina meta ilegalmente sin que la policia te agarre!
        Puedes vender esa meta que cocinaste con el npc que esta por el mapa.
        Podes acceder a los items de metanfetamina desde el f4
    ]],
    weapons = {},
    command = "bluemethdealer",
    max = 2,
    salary = GM.Config.normalsalary,
    level = 5,
    category = "Criminales",
    unlockPrice = 45000,
})

TEAM_METHDEALER = DarkRP.createJob("Traficante de Meta", {
    color = Color(0, 128, 255, 255),
    model = { "models/player/aphaztech.mdl" },
    description = [[
        Cocina meta ilegalmente sin que la policia te agarre!
        Puedes vender esa meta que cocinaste con el npc que esta por el mapa.
        Podes acceder a los items de metanfetamina desde el f4
    ]],
    weapons = {},
    command = "methdealer",
    max = 2,
    salary = GM.Config.normalsalary,
    level = 5,
    category = "Criminales",
    unlockPrice = 75000,
})

TEAM_COCAINEDEALER = DarkRP.createJob("Traficante de Cocaina", {
    color = Color(187, 216, 211, 255),
    model = { "models/player/aphaztech.mdl" },
    description = [[
        Cocina cocaina sin que la policia te agarre!
        Luego vendesela al dealer de coca que estara por el mapa
        Podes acceder a los items de cocaina desde el f4
    ]],
    weapons = {},
    command = "cocainedealer",
    max = 2,
    salary = GM.Config.normalsalary,
    level = 5,
    category = "Criminales",
    unlockPrice = 65000,
})

TEAM_PRODRUGDEALER = DarkRP.createJob("Traficante de Droga Profesional", {
    color = Color(45, 220, 255, 255),
    model = { "models/Agent_47/agent_47.mdl" },
    description = [[
        Con tu nuevo conocimiento sobre el cultivo de drogas,
        Ahora puedes cultivar marihuana y cocaína de una manera mejor y más rápida y cultivar hongos
        Compra la marihuana/coca Pot VIP en la pestaña de cultivo de marihuana
        puedes venderlo o consumirlo
    ]],
    weapons = {},
    command = "prodrugdealer",
    max = 1,
    salary = GM.Config.normalsalary * 2,
    level = 5,
    category = "Criminales",
    unlockPrice = 120000,
    customCheck = function(ply)
        return CLIENT or ply:CheckGroup("vipblackblood")
    end,
    CustomCheckFailMsg = "Necesitas ser VIP Black Blood para ser traficante de droga profesional",
})

TEAM_ZGO2_PRO = DarkRP.createJob("Cultivador de Marihuana", {
    color = Color(111, 150, 97, 255),
    model = {
        "models/player/group03/male_02.mdl"
    },
    description = [[
        Sos el encargado de hacer crecer y vender marihuana.
    ]],
    weapons = {
        "zgo2_multitool","zgo2_backpack"
    },
    command = "zgo2_pro",
    max = 2,
    salary = GM.Config.normalsalary,
    level = 5,
    category = "Criminales",
    unlockPrice = 150000,
})

--[[---------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
Farmeo / Servicios Legales
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
---------------------------------------------------------------------------]]--

TEAM_ZFRUITSLICER = DarkRP.createJob("Rebanador de frutas", {
    color = Color(0, 128, 255, 255),
    model = {
        "models/dannio/noahg/gordonramsay.mdl"
    },
    description = [[
        ¡Vendes batidos!
    ]],
    weapons = {
        "zfs_knife"
    },
    command = "zfs_slicer",
    max = 2,
    salary = GM.Config.normalsalary * 3,
    category = "Ciudadanos",
    unlockPrice = 0,
})

TEAM_ZMC_COOK = DarkRP.createJob("Cocinero Profesional", {
    color = Color(111, 150, 97, 255),
    model = {
        "models/dannio/noahg/gordonramsay.mdl"
    },
    description = [[
        Cocinas tryhard.
    ]],
    weapons = {},
    command = "zmc_cook",
    max = 2,
    salary = GM.Config.normalsalary * 5,
    category = "Ciudadanos",
    unlockPrice = 15000,
    customCheck = function(ply)
        return CLIENT or ply:CheckGroup("viplegend")
    end,
    CustomCheckFailMsg = "Necesitas ser VIP Legend para ser cocinero profesional",
})

TEAM_VENDEDORARMAS = DarkRP.createJob("Vendedor de armas", {
    color = Color(243, 122, 0),
    model = {
        "models/player/monk.mdl",
    },
    description = [[
        El vendedor de armas es la persona encargada de vender armas y municion a la ciudadania.
        Puedes acceder a la mercaderia desde el F4.
    ]],
    weapons = {},
    command = "vendedorarmas",
    max = 2,
    salary = GM.Config.normalsalary * 5,
    hasLicense = true,
    category = "Ciudadanos",
    level = 5,
    unlockPrice = 10000,
})

TEAM_ZCM_FIREWORKMAKER = DarkRP.createJob("Fabricante de fuegos artificiales", {
    color = Color(101, 17, 17),
    model = {
        "models/player/group03/male_04.mdl"
    },
    description = [[
        ¡Haces fuegos artificiales ilegales!
    ]],
    weapons = {},
    command = "zcm_fireworkmaker",
    max = 1,
    salary = GM.Config.normalsalary * 2,
    category = "Criminales",
    level = 10,
    unlockPrice = 100000,
})

TEAM_ZPIZ_CHEF = DarkRP.createJob("Pizzero", {
    color = Color(225, 75, 75, 255),
    model = {
        "models/dannio/noahg/gordonramsay.mdl"
    },
    description = [[
        ¡Horneas pizzas!
    ]],
    weapons = {},
    command = "zpiz_pizzachef01",
    max = 2,
    salary = GM.Config.normalsalary * 2,
    category = "Ciudadanos",
    unlockPrice = 45000,
})

TEAM_ZRUSH_FUELPRODUCER = DarkRP.createJob("Refinador de combustible", {
    color = Color(0, 128, 255, 255),
    model = {
        "models/player/group03/male_04.mdl"
    },
    description = [[
        ¡Haces combustible!
    ]],
    weapons = {},
    command = "zrush_fuelrefiner",
    max = 2,
    salary = GM.Config.normalsalary,
    category = "Ciudadanos",
    level = 10,
    unlockPrice = 0,
})

TEAM_LENHADOR = DarkRP.createJob("Leñador", {
    color = Color(239, 142, 14),
    model = {
        "models/player/group01/male_01.mdl",
    },
    description = [[
        Corre al bosque y compra un hacha antes de empezar a trabajar.
    ]],
    weapons = {
    },
    command = "lenhador",
    max = 2,
    salary = GM.Config.normalsalary,
    category = "Ciudadanos",
    level = 10,
    unlockPrice = 0,
})

TEAM_BANQUERO = DarkRP.createJob("Banquero", {
    color = Color(121, 121, 121, 255),
    model = {
        "models/player/breen.mdl"
    },
    description = [[
        Administrador del banco de la ciudad
    ]],
    weapons = {},
    command = "banquero",
    max = 1,
    salary = GM.Config.normalsalary * 8,
    level = 4,
    category = "Ciudadanos",
    unlockPrice = 30000,
})

TEAM_GRANJERO = DarkRP.createJob("Granjero", {
    color = Color(232, 222, 64, 255),
    model = {
        "models/player/breen.mdl",
    },
    description = [[
        Cuida a tus animales en tu granja
        Tienes derecho a defender tu tierra de intrusos
    ]],
    weapons = {},
    command = "granjero",
    max = 2,
    salary = GM.Config.normalsalary,
    category = "Ciudadanos",
    unlockPrice = 50000,
})

TEAM_ZTM_TRASHMAN = DarkRP.createJob("Recolector de Basura", {
    color = Color(225, 75, 75, 255),
    model = {
        "models/player/group03/male_04.mdl"
    },
    description = [[
        Te encargas de limpiar la ciudad y sus ciudadanos.
    ]],
    weapons = {
        "ztm_trashcollector"
    },
    command = "ztm_trashman",
    max = 2,
    salary = GM.Config.normalsalary,
    category = "Ciudadanos",
    unlockPrice = 0,
})

TEAM_MECANICO = DarkRP.createJob("Mecanico", {
    color = Color(158, 38, 228),
    model = {
        "models/player/odessa.mdl"
    },
    description = [[
        Te encargas de reparar los autos averiados y vender!
    ]],
    weapons = {},
    command = "mecanico",
    max = 2,
    salary = GM.Config.normalsalary,
    category = "Ciudadanos",
    unlockPrice = 0,
})

TEAM_CAMERAREPAIRER = DarkRP.createJob("Reparador de Camaras", {
    color =  Color(252, 133, 0),
    model = {
        "models/player/odessa.mdl"
    },
    description = [[ Repara las camaras de la ciudad.]],
    weapons = {
        "weapon_rpt_wrench"
    },
    command = "camerarepairer",
    max = 1,
    salary = GM.Config.normalsalary * 4,
    category = "Ciudadanos",
    unlockPrice = 0,
})

TEAM_MEDICO = DarkRP.createJob("Medico", {
    color = Color(151, 196, 255, 255),
    model = {
        "models/player/Group03m/male_07.mdl",
        "models/player/Group03m/female_01.mdl",
        "models/player/Group03m/male_02.mdl"
    },
    description = [[
        Responsable de mantener la buena salud de los ciudadanos
    ]],
    weapons = {},
    command = "medico",
    max = 3,
    salary = GM.Config.normalsalary * 3,
    medic = true,
    PlayerLoadout = function(ply)
        ply:SetMaxArmor( 100 )
        ply:SetArmor( 100 )
    end,
    level = 3,
    category = "Ciudadanos",
    unlockPrice = 0,
})

TEAM_PARAMEDICO = DarkRP.createJob("Paramedico", {
    color = Color(151, 196, 255, 255),
    model = {
        "models/player/Group03m/male_07.mdl",
        "models/player/Group03m/female_01.mdl",
        "models/player/Group03m/male_02.mdl"
    },
    description = [[
        Responsable de mantener la buena salud de los ciudadanos
    ]],
    weapons = {},
    command = "paramedico",
    max = 2,
    salary = GM.Config.normalsalary * 2.5,
    medic = true,
    PlayerLoadout = function(ply)
        ply:SetMaxArmor( 100 )
        ply:SetArmor( 100 )
    end,
    category = "Ciudadanos",
    unlockPrice = 0,
    customCheck = function(ply)
        return CLIENT or ply:CheckGroup("viplegend")
    end,
    CustomCheckFailMsg = "Necesitas ser VIP Legend para ser Paramedico!",
})

TEAM_ZRMINE_MINER = DarkRP.createJob("Minero", {
    color = Color(0, 128, 255, 255),
    model = {
        "models/player/miner_m.mdl",
        "models/player/miner_f.mdl",
    },
    description = [[
        Picas minerales, para luego fundirlos y venderlos.
    ]],
    weapons = {
        "zrms_pickaxe","zrms_builder"
    },
    command = "zrmine_retrominer01",
    max = 2,
    salary = GM.Config.normalsalary * 1.5,
    level = 2,
    category = "Ciudadanos",
    unlockPrice = 35000,
})

--[[---------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
Gobierno
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
---------------------------------------------------------------------------]]--

TEAM_POLICIA = DarkRP.createJob("Policia", {
    color = Color(45, 94, 255),
    model = {
        "models/kerry/player/police_chicago_01.mdl",
        "models/kerry/player/police_chicago_02.mdl",
        "models/kerry/player/police_chicago_03.mdl",
        "models/kerry/player/police_chicago_04.mdl",
        "models/kerry/player/police_chicago_05.mdl",
        "models/kerry/player/police_chicago_06.mdl",
        "models/kerry/player/police_chicago_07.mdl",
        "models/kerry/player/police_chicago_08.mdl",
        "models/kerry/player/police_chicago_09.mdl",
    },
    description = [[
        Sos el encargado de mantener el orden en la ciudad.
        Tenes que hacerle caso a tus superiores.
    ]],
    weapons = {
        "weapon_rpt_handcuff", "weapon_rpt_stungun", "stunstick", "heavy_shield", "weaponchecker",
        "m9k_m92beretta",
    },
    command = "policia",
    max = 3,
    salary = GM.Config.normalsalary * 4,
    hasLicense = true,
    PlayerLoadout = function(ply)
        ply:SetMaxArmor( 100 )
        ply:SetArmor( 100 )
    end,
    level = 3,
    category = "Gobierno",
    unlockPrice = 10000,
})

TEAM_PRESIDENTE = DarkRP.createJob("Presidente", {
    color = Color(150, 20, 20, 255),
    model = {
        "models/argentina/javier_milei.mdl",
    },
    description = [[
        El alcalde de la ciudad crea leyes para gobernar la ciudad.
        Si usted es el alcalde, puede crear y aceptar órdenes judiciales.
        Escriba /wanted <name> para autorizar a un jugador.
        Escriba /jailpos para establecer la posición de la cárcel.
        Escriba /lockdown iniciar un bloqueo de la ciudad.
        Todos deben estar adentro durante un encierro.
        Los policías patrullan la zona.
        /unlockdown para finalizar un bloqueo
    ]],
    weapons = {
        "weapon_rpt_handcuff", "weapon_rpt_stungun", "stunstick", "heavy_shield", "weaponchecker",
    },
    command = "presidente",
    max = 1,
    salary = GM.Config.normalsalary * 12,
    hasLicense = true,
    mayor = true,
    PlayerLoadout = function(ply)
        ply:SetMaxArmor( 150 )
        ply:SetArmor( 150 )
    end,
    level = 15,
    category = "Gobierno",
    unlockPrice = 90000,
})

TEAM_SWAT = DarkRP.createJob("SWAT", {
    color = Color(25, 25, 170, 255),
    model = {
        "models/player/kerry/swat_ls.mdl",
    },
    description = [[
        Buscas acabar con la mafia.
    ]],
    weapons = {
        "weapon_rpt_handcuff", "weapon_rpt_stungun", "stunstick", "heavy_shield", "weaponchecker",
        "m9k_hk45", "m9k_mp5sd", "m9k_m16a4_acog"
    },
    command = "swat",
    max = 2,
    salary = GM.Config.normalsalary * 5,
    hasLicense = true,
    PlayerLoadout = function(ply)
        ply:SetMaxArmor( 150 )
        ply:SetArmor( 150 )
    end,
    level = 4,
    category = "Gobierno",
    unlockPrice = 30000,
})

TEAM_SWATSNIPER = DarkRP.createJob("Sniper SWAT", {
    color = Color(25, 25, 170, 255),
    model = {
        "models/player/kerry/swat_ls.mdl",
    },
    description = [[
        Buscas acabar con la mafia.
    ]],
    weapons = {
        "weapon_rpt_handcuff", "weapon_rpt_stungun", "stunstick", "heavy_shield", "weaponchecker",
        "m9k_hk45", "m9k_intervention",
    },
    command = "swatsniper",
    max = 2,
    salary = GM.Config.normalsalary * 6,
    hasLicense = true,
    category = "Gobierno",
    PlayerLoadout = function(ply)
        ply:SetMaxArmor( 150 )
        ply:SetArmor( 150 )
    end,
    level = 6,
    unlockPrice = 35000,
    customCheck = function(ply)
        return CLIENT or ply:CheckGroup("viplegend")
    end,
    CustomCheckFailMsg = "Necesitas ser VIP Legend para ser Sniper SWAT!",
})

TEAM_POLICIAINVESTIGACION = DarkRP.createJob("Policia de Investigación", {
    color = Color(25, 25, 170, 255),
    model = {
        "models/fbi_pack/fbi_01.mdl",
        "models/fbi_pack/fbi_02.mdl",
        "models/fbi_pack/fbi_03.mdl",
        "models/fbi_pack/fbi_04.mdl",
        "models/fbi_pack/fbi_05.mdl",
        "models/fbi_pack/fbi_06.mdl",
        "models/fbi_pack/fbi_07.mdl",
        "models/fbi_pack/fbi_08.mdl",
        "models/fbi_pack/fbi_09.mdl"
    },
    description = [[
        Debe hacer investigaciones, debe encontrar a los culpables y encarcelarlos!
    ]],
    weapons = {
        "weapon_rpt_handcuff", "weapon_rpt_stungun", "stunstick", "heavy_shield", "weaponchecker",
        "investigation_flashlight", "m9k_hk45", "m9k_m16a4_acog"
    },
    command = "fbi",
    max = 3,
    salary = GM.Config.normalsalary * 6,
    category = "Gobierno",
    hasLicense = true,
    PlayerLoadout = function(ply)
        ply:SetMaxArmor( 100 )
        ply:SetArmor( 100 )
    end,
    level = 7,
    unlockPrice = 15000,
})

TEAM_COMISARIO = DarkRP.createJob("Comisario", {
    color = Color(0, 221, 255, 255),
    model = {
        "models/player/PMC_5/PMC__06.mdl"
    },
    description = [[
        Eres el comisario, tu eres el encargado de manejar a toda la fuerza policial del pais y eres el segundo al mando
    ]],
    weapons = {
        "weapon_rpt_handcuff", "weapon_rpt_stungun", "stunstick", "heavy_shield", "weaponchecker",
        "m9k_m92beretta", "m9k_m416", "gmod_flashbang", "m9k_m61_frag"
    },
    command = "comisario",
    max = 1,
    salary = GM.Config.normalsalary * 8,
    chief = true,
    hasLicense = true,
    category = "Gobierno",
    PlayerLoadout = function(ply)
        ply:SetMaxArmor( 125 )
        ply:SetArmor( 125 )
    end,
    level = 10,
    unlockPrice = 75000,
})

TEAM_COALITION = DarkRP.createJob("Coalition Operative", {
    color = Color(1, 2, 31, 255),
    model = {
        "models/player/xuvon/xuvon_goc_re_base.mdl"
    },
    description = [[
        Eres una unidad de Elite bien equipada
    ]],
    weapons = {
        "weapon_rpt_handcuff", "weapon_rpt_stungun", "stunstick", "heavy_shield", "weaponchecker",
        "m9k_m92beretta", "m9k_acr", "m9k_remington870"
    },
    command = "coalitionoperative",
    max = 2,
    salary = GM.Config.normalsalary * 6,
    hasLicense = true,
    category = "Gobierno",
    PlayerLoadout = function(ply)
        ply:SetMaxArmor( 135 )
        ply:SetArmor( 135 )
    end,
    level = 7,
    unlockPrice = 50000,
})

TEAM_JUGGERNAUT = DarkRP.createJob("Juggernaut", {
    color = Color(1, 2, 31, 255),
    model = {
        "models/cyox/goc/jagger.mdl"
    },
    description = [[
        Eres un Juggernaut, tu eres el mas resistente de todos, tienes que proteger a las fuerzas policiales.
    ]],
    weapons = {
        "weapon_rpt_handcuff", "weapon_rpt_stungun", "stunstick", "heavy_shield", "weaponchecker",
        "m9k_m14sp", "riot_shield",
    },
    command = "juggernaut",
    max = 1,
    salary = GM.Config.normalsalary * 4,
    hasLicense = true,
    category = "Gobierno",
    PlayerLoadout = function(ply)
        ply:SetRunSpeed(210)
        ply:SetWalkSpeed(150)
        ply:SetMaxArmor( 200 )
        ply:SetArmor( 200 )
    end,
    level = 5,
    unlockPrice = 250000,
})

TEAM_POLICIAANTIDROGAS = DarkRP.createJob("Policia Antidrogas", {
    color = Color(60, 58, 130, 255),
    model = {
        "models/player/kerry/swat_ls.mdl"
    },
    description = [[
        Te encargas de buscar a los criminales que hacen drogas y meterlos tras las rejas.
        Puedes usar el detector de drogas para encontrar a los traficantes.
    ]],
    weapons = {
        "weapon_rpt_handcuff", "weapon_rpt_stungun", "stunstick", "heavy_shield", "weaponchecker",
        "m9k_m92beretta", "m9k_remington870", "m9k_mp5sd"
    },
    command = "policiaantidrogas",
    max = 2,
    salary = GM.Config.normalsalary * 3,
    hasLicense = true,
    category = "Gobierno",
    PlayerLoadout = function(ply)
        ply:SetMaxArmor( 100 )
        ply:SetArmor( 100 )
    end,
    level = 5,
    unlockPrice = 0,
})

TEAM_POLICIATRANSITO = DarkRP.createJob("Policia de Transito", {
    color = Color(45, 94, 255),
    model = {
        "models/player/jackbauer.mdl",
    },
    description = [[
        Te encargas de mantener el orden de transito
    ]],
    weapons = {
        "weapon_rpt_handcuff", "weapon_rpt_stungun", "stunstick", "heavy_shield", "weaponchecker",
        "speed_gun", "weapon_rpt_finebook", "radar_infos", "m9k_m92beretta"
    },
    command = "policiatransito",
    max = 2,
    salary = GM.Config.normalsalary,
    hasLicense = true,
    category = "Gobierno",
    PlayerLoadout = function(ply)
        ply:SetMaxArmor( 100 )
        ply:SetArmor( 100 )
    end,
    level = 2,
    unlockPrice = 0,
})

TEAM_POLICIACIVIL = DarkRP.createJob("Policia de Civil", {
    color = Color(45, 94, 255),
    model = {
        "models/player/Group01/Female_01.mdl",
        "models/player/Group01/Female_02.mdl",
        "models/player/Group01/Female_03.mdl",
        "models/player/Group01/Female_04.mdl",
        "models/player/Group01/Female_06.mdl",
        "models/player/group01/male_01.mdl",
        "models/player/Group01/Male_02.mdl",
        "models/player/Group01/male_03.mdl",
        "models/player/Group01/Male_04.mdl",
        "models/player/Group01/Male_05.mdl",
        "models/player/Group01/Male_06.mdl",
        "models/player/Group01/Male_07.mdl",
        "models/player/Group01/Male_08.mdl",
        "models/player/Group01/Male_09.mdl"
    },
    description = [[
        Te encargas de mantener el orden en la ciudad.
        Tenes que hacerle caso a tus superiores.
    ]],
    weapons = {
        "weapon_rpt_handcuff", "weapon_rpt_stungun", "stunstick", "heavy_shield", "weaponchecker",
        "m9k_hk45", "m9k_uzi"
    },
    command = "policiacivil",
    max = 1,
    salary = GM.Config.normalsalary * 3,
    hasLicense = true,
    level = 3,
    category = "Gobierno",
    unlockPrice = 0,
})

TEAM_PERROPOLICIA = DarkRP.createJob("Perro Policia", {
    color = Color(0, 17, 255, 255),
    model = {
        "models/player/chimp/chimp.mdl",
        "models/scvtt/police_shepherd/belgian_shepherd.mdl"
    },
    description = [[
        
    ]],
    weapons = {
        "stunstick"
    },
    command = "perropolicia",
    max = 3,
    salary = GM.Config.normalsalary,
    hasLicense = true,
    level = 3,
    category = "Gobierno",
    unlockPrice = 0,
})

--[[---------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
STAFF
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
---------------------------------------------------------------------------]]--

TEAM_AYUDANTE = DarkRP.createJob("Ayudante", {
    color = Color(208, 215, 0),
    model = {
        "models/player/superheroes/greenlantern.mdl"
    },
    description = [[
        Ayudante
    ]],
    weapons = {},
    command = "jobayudante",
    max = 2,
    salary = GM.Config.normalsalary,
    category = "Staff",
    unlockPrice = 0,
    customCheck = function(ply)
        if CLIENT then return ply:CheckGroup("respetado")
        else return ply:CheckGroup("ayudante") end
    end,
    CustomCheckFailMsg = "No permitido",
})

TEAM_MODERADORDEPRUEBA = DarkRP.createJob("Moderador de Prueba", {
    color = Color(208, 215, 0),
    model = {
        "models/player/harry_potter.mdl"
    },
    description = [[
        Moderador de Prueba
    ]],
    weapons = {},
    command = "jobmoderadorprueba",
    max = 2,
    salary = GM.Config.normalsalary,
    category = "Staff",
    unlockPrice = 0,
    customCheck = function(ply)
        if CLIENT then return ply:CheckGroup("respetado")
        else return ply:CheckGroup("moderador-de-prueba") end
    end,
    CustomCheckFailMsg = "No permitido",
})

TEAM_MODERADOR = DarkRP.createJob("Moderador", {
    color = Color(0, 164, 246),
    model = {
        "models/custom/cmankarthecat/helluvaboss/moxxie_pm.mdl",
        "models/player/superheroes/flash.mdl",
    },
    description = [[
        Moderador
    ]],
    weapons = {},
    command = "jobmoderador",
    max = 2,
    salary = GM.Config.normalsalary,
    category = "Staff",
    unlockPrice = 0,
    customCheck = function(ply)
        if CLIENT then return ply:CheckGroup("respetado")
        else return ply:CheckGroup("moderador") end
    end,
    CustomCheckFailMsg = "No permitido",
})

TEAM_ADMIN = DarkRP.createJob("Admin", {
    color = Color(99, 0, 129),
    model = {
        "models/Avengers/Iron Man/mark7_player.mdl"
    },
    description = [[
        Admin
    ]],
    weapons = {},
    command = "jobadmin",
    max = 2,
    salary = GM.Config.normalsalary,
    category = "Staff",
    unlockPrice = 0,
    customCheck = function(ply)
        if CLIENT then return ply:CheckGroup("respetado")
        else return ply:CheckGroup("admin") end
    end,
    CustomCheckFailMsg = "No permitido",
})

TEAM_SUPERADMIN = DarkRP.createJob("Super Admin", {
    color = Color(12, 0, 73),
    model = {
        "models/player/superheroes/batman.mdl"
    },
    description = [[
        Super Admin
    ]],
    weapons = {},
    command = "jobsuperadmin",
    max = 2,
    salary = GM.Config.normalsalary,
    category = "Staff",
    unlockPrice = 0,
    customCheck = function(ply)
        if CLIENT then return ply:CheckGroup("respetado")
        else return ply:CheckGroup("super-admin") end
    end,
    CustomCheckFailMsg = "No permitido",
})

TEAM_DESARROLLADOR = DarkRP.createJob("Desarrollador", {
    color = Color(0, 0, 0),
    model = {
        "models/player/superheroes/superman.mdl"
    },
    description = [[
        Desarrollador
    ]],
    weapons = {},
    command = "jobadminprincipal",
    max = 1,
    salary = GM.Config.normalsalary,
    category = "Staff",
    unlockPrice = 0,
    customCheck = function(ply)
        if CLIENT then return ply:CheckGroup("respetado")
        else return ply:CheckGroup("desarrollador") end
    end,
    CustomCheckFailMsg = "No permitido",
})

--[[---------------------------------------------------------------------------
Define which team joining players spawn into and what team you change to if demoted
---------------------------------------------------------------------------]]
GAMEMODE.DefaultTeam = TEAM_CIUDADANO
--[[---------------------------------------------------------------------------
Define which teams belong to civil protection
Civil protection can set warrants, make people wanted and do some other police related things
---------------------------------------------------------------------------]]
GAMEMODE.CivilProtection = {
    [TEAM_POLICIA] = true,
    [TEAM_PRESIDENTE] = true,
    [TEAM_SWAT] = true,
    [TEAM_SWATSNIPER] = true,
    [TEAM_JUGGERNAUT] = true,
    [TEAM_POLICIAINVESTIGACION] = true,
    [TEAM_COMISARIO] = true,
    [TEAM_COALITION] = true,
    [TEAM_POLICIAANTIDROGAS] = true,
    [TEAM_POLICIATRANSITO] = true,
    [TEAM_POLICIACIVIL] = true,
}
--[[---------------------------------------------------------------------------
Jobs that are hitmen (enables the hitman menu)
---------------------------------------------------------------------------]]
-- DarkRP.addHitmanTeam(TEAM_HITMAN)
