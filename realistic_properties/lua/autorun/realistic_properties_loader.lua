Realistic_Properties = {}

include("realistic_properties/sh_config_rps.lua")
include("realistic_properties/languages/sh_language_en.lua")
include("realistic_properties/languages/sh_language_es.lua")
include("realistic_properties/languages/sh_language_ru.lua")
include("realistic_properties/languages/sh_language_fr.lua")
include("realistic_properties/languages/sh_language_de.lua")
include("realistic_properties/languages/sh_language_pl.lua")
include("realistic_properties/languages/sh_language_da.lua")
include("realistic_properties/languages/sh_language_pt.lua")
include("realistic_properties/languages/sh_language_tr.lua")
include("realistic_properties/languages/sh_language_cn.lua")
include("realistic_properties/shared/sh_functions.lua")
include("realistic_properties/sh_materials_rps.lua")
	
if SERVER then

	AddCSLuaFile("realistic_properties/sh_config_rps.lua")
	AddCSLuaFile("realistic_properties/languages/sh_language_en.lua")
	AddCSLuaFile("realistic_properties/languages/sh_language_es.lua")
	AddCSLuaFile("realistic_properties/languages/sh_language_ru.lua")
	AddCSLuaFile("realistic_properties/languages/sh_language_fr.lua")
	AddCSLuaFile("realistic_properties/languages/sh_language_de.lua")
	AddCSLuaFile("realistic_properties/languages/sh_language_pl.lua")
	AddCSLuaFile("realistic_properties/languages/sh_language_da.lua")
	AddCSLuaFile("realistic_properties/languages/sh_language_pt.lua")
	AddCSLuaFile("realistic_properties/languages/sh_language_tr.lua")
	AddCSLuaFile("realistic_properties/languages/sh_language_cn.lua")
	AddCSLuaFile("realistic_properties/shared/sh_functions.lua")
	AddCSLuaFile("realistic_properties/sh_materials_rps.lua")

	AddCSLuaFile("realistic_properties/client/cl_main.lua")
	AddCSLuaFile("realistic_properties/client/cl_font.lua")
	AddCSLuaFile("realistic_properties/client/cl_notify.lua")
	AddCSLuaFile("realistic_properties/client/cl_hook.lua")

	include("realistic_properties/server/sv_net.lua")
	include("realistic_properties/server/sv_function.lua")
	include("realistic_properties/server/sv_hook.lua")
	include("realistic_properties/server/sv_tool.lua")

elseif CLIENT then

	include("realistic_properties/client/cl_main.lua")
	include("realistic_properties/client/cl_font.lua")
	include("realistic_properties/client/cl_notify.lua")
	include("realistic_properties/client/cl_hook.lua")

end
