local files, directories = file.Find("realistic_cardealer/languages/*", "LUA")
for k,v in ipairs(files) do
    include("realistic_cardealer/languages/"..v)
end

include("realistic_cardealer/sh_config.lua")
 // 
include("realistic_cardealer/sh_materials.lua")
include("realistic_cardealer/shared/sh_functions.lua")
include("realistic_cardealer/sh_advanced_config.lua")

 // 
if SERVER then
    AddCSLuaFile("realistic_cardealer/sh_config.lua")
    AddCSLuaFile("realistic_cardealer/sh_materials.lua")
    AddCSLuaFile("realistic_cardealer/shared/sh_functions.lua")
    AddCSLuaFile("realistic_cardealer/sh_advanced_config.lua")
    
    for k,v in ipairs(files) do
        AddCSLuaFile("realistic_cardealer/languages/"..v)
    end
    
    include("realistic_cardealer/sv_sql.lua")
    include("realistic_cardealer/server/sv_core.lua")
    include("realistic_cardealer/server/sv_admin.lua")
    include("realistic_cardealer/server/sv_accident.lua")
    include("realistic_cardealer/server/sv_customization.lua")
    include("realistic_cardealer/server/sv_dealer.lua")
    include("realistic_cardealer/server/sv_job.lua")
    include("realistic_cardealer/server/sv_compatibilities.lua")
    include("realistic_cardealer/server/sv_hooks.lua")
    include("realistic_cardealer/server/sv_nets.lua")

    AddCSLuaFile("realistic_cardealer/client/cl_fonts.lua")
    AddCSLuaFile("realistic_cardealer/client/cl_functions.lua")
    AddCSLuaFile("realistic_cardealer/client/cl_dealer.lua")
    AddCSLuaFile("realistic_cardealer/client/cl_admin.lua")
    AddCSLuaFile("realistic_cardealer/client/cl_notify.lua")
    AddCSLuaFile("realistic_cardealer/client/cl_speedometers.lua")
    AddCSLuaFile("realistic_cardealer/client/cl_job.lua")
    AddCSLuaFile("realistic_cardealer/client/cl_3d2d_lib.lua")

    AddCSLuaFile("realistic_cardealer/vgui/cl_button.lua")
    AddCSLuaFile("realistic_cardealer/vgui/cl_toggle.lua")
    AddCSLuaFile("realistic_cardealer/vgui/cl_dmodel.lua")
    AddCSLuaFile("realistic_cardealer/vgui/cl_slider_button.lua")
    AddCSLuaFile("realistic_cardealer/vgui/cl_slider_vehc.lua")
    AddCSLuaFile("realistic_cardealer/vgui/cl_colormixer.lua")
    AddCSLuaFile("realistic_cardealer/vgui/cl_vehicle_button.lua")
    AddCSLuaFile("realistic_cardealer/vgui/cl_checkbox.lua")
    AddCSLuaFile("realistic_cardealer/vgui/cl_dscroll.lua")
    AddCSLuaFile("realistic_cardealer/vgui/cl_dtextentry.lua")
    AddCSLuaFile("realistic_cardealer/vgui/cl_dcombobox.lua")
    AddCSLuaFile("realistic_cardealer/vgui/cl_accordion.lua")
    AddCSLuaFile("realistic_cardealer/vgui/cl_slider.lua")
    AddCSLuaFile("realistic_cardealer/vgui/cl_circular_avatar.lua")
else
    include("realistic_cardealer/client/cl_fonts.lua")
    include("realistic_cardealer/client/cl_functions.lua")
    include("realistic_cardealer/client/cl_dealer.lua")
    include("realistic_cardealer/client/cl_admin.lua")
    include("realistic_cardealer/client/cl_notify.lua")
    include("realistic_cardealer/client/cl_speedometers.lua")
    include("realistic_cardealer/client/cl_job.lua")
    include("realistic_cardealer/client/cl_3d2d_lib.lua")
    
    include("realistic_cardealer/vgui/cl_button.lua")
    include("realistic_cardealer/vgui/cl_toggle.lua")
    include("realistic_cardealer/vgui/cl_dmodel.lua")
    include("realistic_cardealer/vgui/cl_slider_button.lua")
    include("realistic_cardealer/vgui/cl_slider_vehc.lua")
    include("realistic_cardealer/vgui/cl_colormixer.lua")
    include("realistic_cardealer/vgui/cl_vehicle_button.lua")
    include("realistic_cardealer/vgui/cl_checkbox.lua")
    include("realistic_cardealer/vgui/cl_dscroll.lua")
    include("realistic_cardealer/vgui/cl_dtextentry.lua")
    include("realistic_cardealer/vgui/cl_dcombobox.lua")
    include("realistic_cardealer/vgui/cl_accordion.lua")
    include("realistic_cardealer/vgui/cl_slider.lua")
    include("realistic_cardealer/vgui/cl_circular_avatar.lua")
end