local PublicAddonName = "DOOM Eternal SNPCs"
local AddonName = "DOOM Eternal SNPCs"
local AddonType = "SNPC"
local AutorunFile = "autorun/vj_doometernal_autorun.lua"
-------------------------------------------------------
include('autorun/vj_controls.lua')

local vCat = "DOOM Eternal"

-- DOOM Eternal SNPCs
VJ.AddNPC("Baron of Hell (fireborn)","npc_vj_baron",vCat)
VJ.AddNPC("Hell Knight","npc_vj_hellknight",vCat)
------ PrecacheParticles ------

util.PrecacheModel("models/metros/doometernal/baron.mdl")
util.PrecacheModel("models/metros/doometernal/hellknight.mdl")

game.AddParticles("particles/DE1.pcf")
game.AddParticles("particles/DE2.pcf")
game.AddParticles("particles/IconLaser.pcf")
local particlename = {
    "ScreecherDeathbuff1", 
    "ScreecherDeathbuff1", 
    "ScreecherAura", 
    "ScreecherBuffAuraSmall", 
    "ScreecherBuffAuraMid", 
    "ScreecherBuffAuraBig", 
    "GBDOOMhunterpool", 
    "Archvile_teleport1", 
    "Archvile_teleport2", 
    "Archvile_teleport3", 
    "Archvile_teleport4", 
    "Archvile_teleport5", 
    "Doomhunterthruster2", 
    "Doomhunterthruster1", 
    "DemonicTroopsball", 
    "Spiritauratest", 
    "Bufftotemaurabig", 
    "Bufftotemauramid", 
    "Bufftotemaurasmall", 
    "DarkSlayer_NoExistence", 
    "DarkSlayer_NoExistence1", 
    "DarkSlayer_NoExistence2", 
    "DarkSlayer_NoExistence3",
    "DarkSlayer_NoExistence4",  
    "DarkSlayer_Shieldeffect1", 
    "DarkSlayer_Incineratemarker", 
    "DarkSlayer_Grenadeboom", 
    "DarkSlayer_Grenadeboom1", 
    "DarkSlayer_Grenadeboom2", 
    "BloodMaykrSpear1", 
    "BloodMaykrSpearImpact", 
    "BloodMaykrShielded", 
    "BloodMaykrShield",
    "BloodMaykrEnergyBall",
    "BloodMaykrPreCruciform",
    "BloodMaykrCruciform",
    "TurretGlow",
    "DE_turretball",
    "Armoredbaron_armorlose",
    "Armoredbaron_armorgain",
    "Armoredbaron_armorregen",
    "gargoyle_ball",   
	"gargoyle_ball1",   
	"gargoyle_ball2", 
    "gargoyle_ballEnergy",   
    "gargoyle_ballEnergy1", 
    "gargoyle_ballEnergy2",
    "gargoyle_ballEnergy3", 	
    "DE_EnergyBall1",
	"DE_EnergyBall2",
	"DE_EnergyBomb1",
	"DE_EnergyBombExplode1",
	"DemonSpawn",
	"Mecha_flamethrower",
	"imp_fastball",
	"imp_fastball1",
	"imp_fastball2",
	"imp_fireball",
	"imp_fireball1",
	"imp_fireball2",
	"imp_fireballexplode",
	"imp_fireballexplode1",
	"imp_fireballexplode2",
	"imp_fastballexplode",
	"imp_fastballexplode1",
	"imp_fastballexplode2",
	"MaykrBall", 
	"DemonDeathDisolve",
	"DemonDeathDisolveHeavy",
	"DemonDeathDisolveSuperHeavy",
	"Caco_ball",
	"Caco_ball1",
	"Caco_ball2",
	"Caco_ballexplode",
	"HK_Groundpound",
	"Mancu_ball",
	"MancuCyber_ball",
	"Mancu_flamethrower",
	"Mancu_GroundShoot",
	"MancuCyber_GroundShoot",
	"MancuCyber_GroundPool",
	"Whiplash_lash",
	"Whiplash_lash1",
	"Whiplash_lash2",
	"Whiplash_lashexplode",
	"Whiplash_lashexplode1",
	"Whiplash_lashexplode2",
	"carcass_ring",
	"Prowler_shadowbolt",
	"Prowler_shadowbolt1",
	"Prowler_shadowbolt2",
	"Carcass_seismic1",
	"Dreadknight_range",
	"Prowler_shadowport1",
	"Prowler_shadowport2",
	"Prowler_shadowport3",
	"Prowler_shadowport4",
	"Prowler_shadowport5",
	"CursedProwler_shadowbolt",
	"CursedProwler_shadowbolt1",
	"CursedProwler_shadowbolt2",
	"DemonSpawn3",
	"SpiritDeath",
	"SpiritedAuraBig",
    "SpiritedAuraMid",
	"SpiritedAuraSmall",
	"IconMark",
	"IconMarkBeam",
	"IconLaserCharge",
	"dreadknight_groundpoolsmall",
	"Baron_firecircle",
	"LostSoulFlame",
	"ShieldExplode",
	"CursedProwler_shadowport1",
	"CursedProwler_shadowport2",
	"CursedProwler_shadowport3",
	"CursedProwler_shadowport4",
	"CursedProwler_shadowport5",
	"BloodMaykrCruciformImpact", 
    "ArchvileFlameUp",  
    "MaligogEffect1",
	"MaligogGlow1",
	"Archvile_groundpool1",
	"ArchvileIgnite",
	"Tyrant_Beam1",
	"DE_DHGauss",
	"IconLaser",
	"IconFlameball",
	"IconFlameball1",
	"IconFlameball2",
	"IconFlameballexplode",
	"Icon_Flamethrower",
	"IconMarkoftheBeast",
}

timer.Simple(5,function()
			
    if (SERVER) then
        PrintMessage( HUD_PRINTTALK, "[VJ] DOOM Eternal SNPCs updated." )
        PrintMessage( HUD_PRINTTALK, "adjusted the addon to the latest VJ Base version" )
        PrintMessage( HUD_PRINTTALK, "minor fixes and changes" )
        PrintMessage( HUD_PRINTTALK, "-see changelog on the workshop page for details" )
    end
end)

AddCSLuaFile(AutorunFile)
VJ.AddAddonProperty(AddonName,AddonType)