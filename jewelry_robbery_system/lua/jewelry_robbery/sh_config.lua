Jewelry_Robbery.Config.LimitedToJob = true -- is the robbbery limited to a job?
Jewelry_Robbery.Config.BagWeightMax = 20 -- max weight of a bag
Jewelry_Robbery.Config.TimeBrokenAlarmAdvert = 30 -- when the alarm is broken, it'll advert the police in ... seconds
Jewelry_Robbery.Config.TimeToResetEverything = 900 -- after this time ( in seconds ), the robbery will be ended and everything will be reset
Jewelry_Robbery.Config.NumberPoliceMin = 2-- number of police players to be able to start the robbery
Jewelry_Robbery.Config.TimeBetween2Robbery = 1200 -- time between 2 robbery

Jewelry_Robbery.Config.PercentageEarnedByPolice = 30 -- percentage of the bag value that the police earn when they stop a robber

Jewelry_Robbery.Config.TimeNPCWait = 240 -- when the black market NPC appears, how much time (in seconds) he should wait.
Jewelry_Robbery.Config.TimeBetween2CallNPC = 360 -- after a call, how much time the player should wait to call the black market NPC another time.

Jewelry_Robbery.Config.BagSlowdownType = 1 -- how to slow down a player with a bag.
/*
0 - no slowdown at all.
1 - gradually slow down dependent on how much weight is in your bag(you move more slow if your bag is full and less slow if it's half empty and you move normally if you have nothing in the bag)
2 - you move normally when you have nothing in the bag but slowdown maximum even if you have 1 kg in the bag
*/

--alarm sound
Jewelry_Robbery.Config.AlarmSound = "ambient/alarms/alarm1.wav"

Jewelry_Robbery.Config.DrawHUD = {
	["3D2D_glass_robber"] = true, -- this should be drawn? (true = yes) https://cdn.discordapp.com/attachments/471352432815898635/531095683068067840/unknown.png
	["3D2D_glass_police"] = true, -- this should be drawn? (true = yes) https://cdn.discordapp.com/attachments/471352432815898635/531097400358469633/unknown.png
	["police_icon_alarm"] = true, -- the icon which appears on the broken alarms should be drawn?
	["police_icon_glass"] = true, -- the icon which appears on the broken glass should be drawn?	
	["robber_icon_npc"] = true, -- the icon which appears on the black market dealer should be drawn? /!\ THIS ICON IS IMPORTANT, THE PLAYER WILL NEED TO SEARCH WHERE IS THE NPC IF IT'S SET TO FALSE	
}

/*
NPC success deal chances.
Key is the percentage player tries to give, value is the actual percentage.
For example, default setting works like that.
If player suggests a deal that is less or equal 10% player's cut, then dealer will always agree(cos chance is 1).
If player suggests a deal that is less or equal 50% player's cut, then the chance of success deal is 90%(chance is 0.9).
If player suggests a deal that is less or equal 90% player's cut, then the chance of success deal is 20%(chance is 0.2).
If player suggests a deal with higher percentage, then NPC would never agree.
*/
Jewelry_Robbery.Config.NPCChances = {
	[10] = 1,
	[50] = 0.9,
	[90] = 0.2,
	[100] = 0,
}

Jewelry_Robbery.Config.NPCMaxRefuses = 5 -- how many times the NPC can refuse a deal before leaving

/*
For more customizable chances you could write your function or ask any lua dev to write one.
---------------------------------------------------------
	Name: Jewelry_Robbery.Config.PercentageCheckFunction(player ply, number value, number percentage)
	Desc: Custom function that returns either NPC would agree to a deal or not.
		value is whole cost of jewelry player is trying to sell.
		It must always return a boolean.
		If your logic should only partially affect checking algorithm, then you could use Jewelry_Robbery.Config.DefaultPercentageCheckFunction to return values
	Returns: boolean success
-----------------------------------------------------------
EXAMPLE:

Jewelry_Robbery.Config.PercentageCheckFunction = function(ply, value, percentage)
	if ply:IsAdmin() then -- if player is admin, then NPC would always agree
		return true
	else -- if not, then just do default check.
		return Jewelry_Robbery.Config.DefaultPercentageCheckFunction(ply, value, percentage)
	end
end
*/



timer.Simple(1, function()

Jewelry_Robbery.Config.Jobs = {
	TEAM_LADRON,
	TEAM_LADRONPRO
}

end)

Jewelry_Robbery.Config.NPC_Model = "models/player/macdguy.mdl"

Jewelry_Robbery.Config.NPCRefuseSounds = {
	"vo/npc/male01/answer17.wav",
	"vo/npc/male01/vanswer01.wav",
	"vo/npc/male01/answer21.wav",
	"vo/npc/male01/answer39.wav"
};

Jewelry_Robbery.Config.NPCSounds = {
	"vo/npc/male01/yeah02.wav",
	"vo/npc/male01/thislldonicely01.wav",
	"vo/npc/male01/oneforme.wav",
	"vo/npc/male01/nice.wav",
	"vo/npc/male01/letsgo01.wav",
	"vo/npc/male01/letsgo02.wav",
};

Jewelry_Robbery.Config.ListJewelry = {
	[1] = {
		name = "Reloj",
		model = "models/sterling/ajr_stand_watch.mdl",
		price_blackmarket = 600,
		weight = 1,
		scale = 1,
	},
	[2] = {
		name = "Collar",
		model = "models/sterling/ajr_stand_necklace.mdl",
		price_blackmarket = 700,
		weight = 2,
		scale = 1,
	},
	[3] = {
		name = "Anillos",
		model = "models/sterling/ajr_ringbox.mdl",
		price_blackmarket = 800,
		weight = 3,
		scale = 1,
	},

}