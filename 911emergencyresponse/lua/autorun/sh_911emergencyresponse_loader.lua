MsgC(Color( 199, 42, 42 ), "911 Emergency Response : ", color_white, "Loading files..\n")

EmergencyDispatch = EmergencyDispatch or {}
EmergencyResponse = EmergencyResponse or {}

EmergencyDispatch.Sound = {}
EmergencyDispatch.DispatchCallouts = {}
EmergencyDispatch.ColorsConfiguration = {}
EmergencyDispatch.AllJobsTable = EmergencyDispatch.AllJobsTable or {}

EmergencyResponse.DispatchServices = {
	["police"] = true,
	["fire"] = true,
	["ems"] = true
}

EDLang = EDLang or {}

-- Include shared
include("emergencyresponse/shared/sh_config.lua")
include("emergencyresponse/shared/sh_lang.lua")
include("emergencyresponse/shared/sh_materials.lua")

if SERVER then
	
	-- AddCSLuaFile shared
	AddCSLuaFile("emergencyresponse/shared/sh_config.lua")
	AddCSLuaFile("emergencyresponse/shared/sh_lang.lua")
	AddCSLuaFile("emergencyresponse/shared/sh_materials.lua")
	
	-- AddCSLuaFile client
	AddCSLuaFile("emergencyresponse/client/cl_fonts.lua")
	AddCSLuaFile("emergencyresponse/client/cl_functions.lua")
	AddCSLuaFile("emergencyresponse/client/cl_notifications.lua")
	AddCSLuaFile("emergencyresponse/client/cl_victim_interface.lua")
	AddCSLuaFile("emergencyresponse/client/cl_respond_interface.lua")

	-- include server
	include("emergencyresponse/server/sv_engine.lua")
	include("emergencyresponse/server/sv_functions.lua")
	include("emergencyresponse/server/sv_hooks.lua")
	include("emergencyresponse/server/sv_nets.lua")

elseif CLIENT then

	-- include client
	include("emergencyresponse/client/cl_fonts.lua")
	include("emergencyresponse/client/cl_functions.lua")
	include("emergencyresponse/client/cl_notifications.lua")
	include("emergencyresponse/client/cl_victim_interface.lua")
	include("emergencyresponse/client/cl_respond_interface.lua")
	
end