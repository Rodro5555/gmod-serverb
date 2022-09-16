ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Slot Machine"
ENT.Author = "Owain Owjo & The One Free-Man"
ENT.Category = "pCasino"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "CurrentJackpot")
end

PerfectCasino.Core.RegisterEntity("pcasino_slot_machine", {
	-- General data
	general = {
		limitUse = {d = false, t = "bool"}
	},
	-- Bet data
	bet = {
		default = {d = 1000, t = "num"}, -- The default bet
	},
	-- Combo data
	combo = {
		{c = {"bell", "bell", "bell"}, p = 0.5, j = false},
		{c = {"melon", "melon", "melon"}, p = 0.8, j = false},
		{c = {"cherry", "cherry", "cherry"}, p = 1, j = false},
		{c = {"seven", "seven", "seven"}, p = 1.6, j = false},
		{c = {"clover", "clover", "clover"}, p = 2, j = false},
		{c = {"diamond", "diamond", "diamond"}, p = 2.5, j = false},
		{c = {"diamond", "diamond", "anything"}, p = 2, j = false},
		{c = {"anything", "diamond", "diamond"}, p = 2, j = false},
		{c = {"berry", "berry", "berry"}, p = 2.8, j = false},
		{c = {"dollar", "dollar", "dollar"}, p = 0, j = true},
	},
	jackpot = {
		toggle = {d = true, t = "bool"}, -- The bell chance
		startValue = {d = 10000, t = "num"}, -- Jackpot start value
		betAdd = {d = 0.5, t = "num"}, -- The % of the bet to add to the jackpot
	},
	-- Chance data
	chance = {
		bell = {d = 15}, -- The bell chance
		melon = {d = 10}, -- The watermelon chance
		cherry = {d = 8}, -- The cherry chance
		seven = {d = 6}, -- The seven chance
		clover = {d = 5}, -- The clover chance
		diamond = {d = 3}, -- The diamond chance
		berry = {d = 2}, -- The strawberrry chance
		dollar = {d = 1} -- The dollar chance
	},
},
"models/freeman/owain_slotmachine.mdl")