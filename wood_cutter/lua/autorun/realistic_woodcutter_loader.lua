--[[
 _____           _ _     _   _          _    _                 _            _   _            
| ___ \         | (_)   | | (_)        | |  | |               | |          | | | |           
| |_/ /___  __ _| |_ ___| |_ _  ___    | |  | | ___   ___   __| | ___ _   _| |_| |_ ___ _ __ 
|    // _ \/ _` | | / __| __| |/ __|   | |/\| |/ _ \ / _ \ / _` |/ __| | | | __| __/ _ \ '__|
| |\ \  __/ (_| | | \__ \ |_| | (__    \  /\  / (_) | (_) | (_| | (__| |_| | |_| ||  __/ |   
\_| \_\___|\__,_|_|_|___/\__|_|\___|    \/  \/ \___/ \___/ \__,_|\___|\__,_|\__|\__\___|_|   
                                                                                                                                                                                        
--]] 

Realistic_Woodcutter = {}

include("realistic_woodcutter/languages/sh_language_en.lua")
include("realistic_woodcutter/languages/sh_language_es.lua")
include("realistic_woodcutter/languages/sh_language_fr.lua")
include("realistic_woodcutter/languages/sh_language_tr.lua")
include("realistic_woodcutter/languages/sh_language_cn.lua")
include("realistic_woodcutter/languages/sh_language_de.lua")
include("realistic_woodcutter/shared/sh_functions.lua")
include("realistic_woodcutter/sh_config_rwc.lua")
include("realistic_woodcutter/sh_advanced_config.lua")
include("realistic_woodcutter/sh_materials.lua")
	
if SERVER then
	AddCSLuaFile("realistic_woodcutter/sh_config_rwc.lua")
	AddCSLuaFile("realistic_woodcutter/languages/sh_language_en.lua")
AddCSLuaFile("realistic_woodcutter/languages/sh_language_es.lua")
AddCSLuaFile("realistic_woodcutter/languages/sh_language_fr.lua")
AddCSLuaFile("realistic_woodcutter/languages/sh_language_tr.lua")
AddCSLuaFile("realistic_woodcutter/languages/sh_language_cn.lua")
AddCSLuaFile("realistic_woodcutter/languages/sh_language_de.lua")
AddCSLuaFile("realistic_woodcutter/shared/sh_functions.lua")
	AddCSLuaFile("realistic_woodcutter/sh_advanced_config.lua")
	AddCSLuaFile("realistic_woodcutter/sh_materials.lua")
	
	AddCSLuaFile("realistic_woodcutter/client/cl_realistic_woodcutter_info.lua")
	AddCSLuaFile("realistic_woodcutter/client/cl_realistic_woodcutter_fonts.lua")
	AddCSLuaFile("realistic_woodcutter/client/cl_realistic_woodcutter_hooks.lua")
	AddCSLuaFile("realistic_woodcutter/client/cl_realistic_woodcutter_npc.lua")
	AddCSLuaFile("realistic_woodcutter/client/cl_realistic_woodcutter_npccardealer.lua")
	AddCSLuaFile("realistic_woodcutter/client/cl_realistic_woodcutter_imgui.lua")
	AddCSLuaFile("realistic_woodcutter/client/cl_realistic_woodcutter_vehicle_vgui.lua")

	include("realistic_woodcutter/server/sv_realistic_woodcutter_save.lua")
	include("realistic_woodcutter/server/sv_realistic_woodcutter_functions.lua")
	include("realistic_woodcutter/server/sv_realistic_woodcutter_hook.lua")
	include("realistic_woodcutter/server/sv_realistic_woodcutter_net.lua")
	
elseif CLIENT then

	include("realistic_woodcutter/client/cl_realistic_woodcutter_info.lua")
	include("realistic_woodcutter/client/cl_realistic_woodcutter_fonts.lua")
	include("realistic_woodcutter/client/cl_realistic_woodcutter_hooks.lua")
	include("realistic_woodcutter/client/cl_realistic_woodcutter_npc.lua")
	include("realistic_woodcutter/client/cl_realistic_woodcutter_npccardealer.lua")
	include("realistic_woodcutter/client/cl_realistic_woodcutter_imgui.lua")
	include("realistic_woodcutter/client/cl_realistic_woodcutter_vehicle_vgui.lua")

end
