Jewelry_Robbery = {}
Jewelry_Robbery.Config = {}
Jewelry_Robbery.Config.HealthAlarm = 1
Jewelry_Robbery.Config.HealthGlass = 100

-- include shared
include("jewelry_robbery/sh_lang.lua")
include("jewelry_robbery/sh_config.lua")

if SERVER then
	
	-- AddCSLuaFile shared
	AddCSLuaFile("jewelry_robbery/sh_lang.lua")
	AddCSLuaFile("jewelry_robbery/sh_config.lua")
	
	-- AddCSLuaFile client
	AddCSLuaFile("jewelry_robbery/client/cl_jewelry_robbery.lua")
	AddCSLuaFile("jewelry_robbery/client/cl_notifications.lua")
	
	-- include server
	include("jewelry_robbery/server/sv_jewelry_robbery.lua")
	include("jewelry_robbery/server/sv_notifications.lua")
	
elseif CLIENT then
	
	-- include client
	include("jewelry_robbery/client/cl_jewelry_robbery.lua")
	include("jewelry_robbery/client/cl_notifications.lua")

	
end