ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Mysterly Wheel"
ENT.Author = "Owain Owjo & The One Free-Man"
ENT.Category = "pCasino"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = false
ENT.AdminSpawnable = false

PerfectCasino.Core.RegisterEntity("pcasino_mystery_wheel", {
	general = {
		useFreeSpins = {d = true, t = "bool"} -- Can you use free spins on this machine
	},
	buySpin = {
		buy = {d = true, t = "bool"}, -- Can you buy a spin on this machine
		cost = {d = 10000, t = "int"}, 
	},
	-- Combo data
	wheel = { -- I know, 20 slots :O
		{n = "$1000", f = "money", i = 1000, p = "dolla"},
		{n = "Nada", f = "nothing", i = "nil", p = "melon"},
		{n = "$25,000", f = "money", i = 25000, p = "dolla"},
		{n = "Gira de Nuevo", f = "prize_wheel", i = "nil", p = "mystery_1"},
		{n = "Chimpance", f = "setmodel", i = "models/player/chimp/chimp.mdl", p = "bar"},
		{n = "$30,000", f = "money", i = 30000, p = "dolla"},
		{n = "2000", f = "money", i = 2000, p = "dolla"},
		{n = "Triciclo", f = "rcd_givecar", i = 18, p = "car"},
		{n = "Morir", f = "kill", i = "nil", p = "bell"},
		{n = "$20,000", f = "money", i = 20000, p = "dolla"},
		{n = "Arma del Futuro", f = "weapon", i = "m9k_f2000", p = "chest"},
		{n = "200% Chaleco", f = "armor", i = 200, p = "diamond"},
		{n = "Tommy Gun", f = "weapon", i = "m9k_thompson", p = "chest"},
		{n = "Nada", f = "nothing", i = "nil", p = "melon"},
		{n = "200% Salud", f = "health", i = 200, p = "diamond"},
		{n = "$5,000", f = "money", i = 5000, p = "dolla"},
		{n = "Zurdo", f = "setmodel", i = "models/player/charple.mdl", p = "bar"},
		{n = "$50,000", f = "money", i = 50000, p = "dolla"},
		{n = "Nada", f = "nothing", i = "nil", p = "melon"},
		{n = "Nada", f = "nothing", i = "nil", p = "melon"},
	}
},
"models/freeman/owain_mystery_wheel.mdl")