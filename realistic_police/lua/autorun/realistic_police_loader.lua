--[[
 _____            _ _     _   _        _____      _ _             _____           _                 
|  __ \          | (_)   | | (_)      |  __ \    | (_)           / ____|         | |                
| |__) |___  __ _| |_ ___| |_ _  ___  | |__) |__ | |_  ___ ___  | (___  _   _ ___| |_ ___ _ __ ___  
|  _  // _ \/ _` | | / __| __| |/ __| |  ___/ _ \| | |/ __/ _ \  \___ \| | | / __| __/ _ \ '_ ` _ \ 
| | \ \  __/ (_| | | \__ \ |_| | (__  | |  | (_) | | | (_|  __/  ____) | |_| \__ \ ||  __/ | | | | |
|_|  \_\___|\__,_|_|_|___/\__|_|\___| |_|   \___/|_|_|\___\___| |_____/ \__, |___/\__\___|_| |_| |_|
                                                                                                                                         
--]]

Realistic_Police = Realistic_Police or {}

include("realistic_police/sh_rpt_config.lua")
include("realistic_police/languages/sh_language_en.lua")
include("realistic_police/languages/sh_language_tr.lua")
include("realistic_police/languages/sh_language_cn.lua")
include("realistic_police/languages/sh_language_fr.lua")
include("realistic_police/languages/sh_language_ru.lua")
include("realistic_police/languages/sh_language_es.lua")
include("realistic_police/shared/sh_functions.lua")
include("realistic_police/sh_rpt_materials.lua")
include("realistic_police/sh_rpt_advanced.lua")

timer.Simple(2,function()
    include("realistic_police/sh_rpt_config.lua")
    include("realistic_police/languages/sh_language_en.lua")
    include("realistic_police/languages/sh_language_tr.lua")
    include("realistic_police/languages/sh_language_cn.lua")
    include("realistic_police/languages/sh_language_fr.lua")
    include("realistic_police/languages/sh_language_ru.lua")
    include("realistic_police/languages/sh_language_es.lua")
    include("realistic_police/sh_rpt_materials.lua")
    include("realistic_police/sh_rpt_advanced.lua")
end) 

if SERVER then 
    include("realistic_police/server/sv_rpt_function.lua")
    include("realistic_police/server/sv_rpt_hook.lua")
    include("realistic_police/server/sv_rpt_net.lua")
    include("realistic_police/server/sv_rpt_tool.lua")

    AddCSLuaFile("realistic_police/client/cl_rpt_main.lua")
    AddCSLuaFile("realistic_police/client/cl_rpt_fonts.lua")

    AddCSLuaFile("realistic_police/client/cl_rpt_criminal.lua")
    AddCSLuaFile("realistic_police/client/cl_rpt_listreport.lua")
    AddCSLuaFile("realistic_police/client/cl_rpt_report.lua")
    AddCSLuaFile("realistic_police/client/cl_rpt_firefox.lua")
    AddCSLuaFile("realistic_police/client/cl_rpt_camera.lua")
    AddCSLuaFile("realistic_police/client/cl_rpt_license.lua")
    AddCSLuaFile("realistic_police/client/cl_rpt_cmd.lua")
    AddCSLuaFile("realistic_police/client/cl_rpt_fining.lua")
    AddCSLuaFile("realistic_police/client/cl_rpt_handcuff.lua")

    AddCSLuaFile("realistic_police/client/cl_rpt_notify.lua")
    
    AddCSLuaFile("realistic_police/sh_rpt_config.lua")
    AddCSLuaFile("realistic_police/languages/sh_language_en.lua")
    AddCSLuaFile("realistic_police/languages/sh_language_tr.lua")
    AddCSLuaFile("realistic_police/languages/sh_language_cn.lua")
    AddCSLuaFile("realistic_police/languages/sh_language_fr.lua")
    AddCSLuaFile("realistic_police/languages/sh_language_ru.lua")
    AddCSLuaFile("realistic_police/languages/sh_language_es.lua")
    AddCSLuaFile("realistic_police/shared/sh_functions.lua")
    AddCSLuaFile("realistic_police/sh_rpt_materials.lua")
    AddCSLuaFile("realistic_police/sh_rpt_advanced.lua")
else 
    include("realistic_police/client/cl_rpt_criminal.lua")
    include("realistic_police/client/cl_rpt_listreport.lua")
    include("realistic_police/client/cl_rpt_report.lua")
    include("realistic_police/client/cl_rpt_firefox.lua")
    include("realistic_police/client/cl_rpt_camera.lua")
    include("realistic_police/client/cl_rpt_license.lua")
    include("realistic_police/client/cl_rpt_cmd.lua")
    include("realistic_police/client/cl_rpt_fining.lua")
    include("realistic_police/client/cl_rpt_handcuff.lua")
    
    include("realistic_police/client/cl_rpt_notify.lua")

    include("realistic_police/client/cl_rpt_main.lua")
    include("realistic_police/client/cl_rpt_fonts.lua")
end 