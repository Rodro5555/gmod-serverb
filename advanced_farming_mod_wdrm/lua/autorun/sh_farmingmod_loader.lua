MsgC(Color(255,0,0), "[FARMINGMOD]", Color(255,255,255), "Loading files...")

FarmingMod = {}
FarmingMod.Config = {}
FarmingMod.ListOfTrough = {}
FarmingMod.ListOfBuckets = {}


-- include shared
include("farmingmod/sh_config.lua")
include("farmingmod/sh_lang.lua")

if SERVER then

	-- AddCSLuaFile shared
	AddCSLuaFile("farmingmod/sh_config.lua")
	AddCSLuaFile("farmingmod/sh_lang.lua")

	-- AddCSLuaFile client
	AddCSLuaFile("farmingmod/client/cl_farmingmod.lua")
	
	-- include server
	include("farmingmod/server/sv_farmingmod.lua")
	
elseif CLIENT then

	-- include client
	include("farmingmod/client/cl_farmingmod.lua")
	
	
end


MsgC(Color(255,0,0), "[FARMINGMOD]", Color(255,255,255), "Files loaded.")
