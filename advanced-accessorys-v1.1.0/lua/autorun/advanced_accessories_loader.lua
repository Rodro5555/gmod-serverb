local files, directories = file.Find("advanced_accessories/languages/*", "LUA")
for k,v in ipairs(files) do
    include("advanced_accessories/languages/"..v)
end

include("advanced_accessories/sh_config.lua")
include("advanced_accessories/sh_materials.lua")
include("advanced_accessories/shared/sh_functions.lua")
include("advanced_accessories/sh_advanced_config.lua")

if SERVER then 
    include("advanced_accessories/server/sv_sql.lua")
    include("advanced_accessories/server/sv_functions.lua")
    include("advanced_accessories/server/sv_hooks.lua")
    include("advanced_accessories/server/sv_nets.lua")
    include("advanced_accessories/server/sv_sql.lua")

    local files, directories = file.Find("advanced_accessories/languages/*", "LUA")
    for k,v in ipairs(files) do
        AddCSLuaFile("advanced_accessories/languages/"..v)
    end
    
    AddCSLuaFile("advanced_accessories/sh_config.lua")
    AddCSLuaFile("advanced_accessories/sh_materials.lua")
    AddCSLuaFile("advanced_accessories/shared/sh_functions.lua")
    AddCSLuaFile("advanced_accessories/sh_advanced_config.lua")

    AddCSLuaFile("advanced_accessories/client/cl_gradients.lua")
    AddCSLuaFile("advanced_accessories/client/cl_fonts.lua")
    AddCSLuaFile("advanced_accessories/client/cl_main.lua")
    AddCSLuaFile("advanced_accessories/client/cl_functions.lua")
    AddCSLuaFile("advanced_accessories/client/cl_notify.lua")
    AddCSLuaFile("advanced_accessories/client/cl_bodygroup.lua")
    AddCSLuaFile("advanced_accessories/client/cl_admin.lua")
    AddCSLuaFile("advanced_accessories/client/cl_inventory.lua")
    AddCSLuaFile("advanced_accessories/client/cl_models.lua")
    AddCSLuaFile("advanced_accessories/client/cl_player_settings.lua")
    
    AddCSLuaFile("advanced_accessories/vgui/cl_button.lua")
    AddCSLuaFile("advanced_accessories/vgui/cl_cards.lua")
    AddCSLuaFile("advanced_accessories/vgui/cl_searchbar.lua")
    AddCSLuaFile("advanced_accessories/vgui/cl_slider.lua")
    AddCSLuaFile("advanced_accessories/vgui/cl_scroll.lua")
    AddCSLuaFile("advanced_accessories/vgui/cl_textentry.lua")
    AddCSLuaFile("advanced_accessories/vgui/cl_combobox.lua")
    AddCSLuaFile("advanced_accessories/vgui/cl_dmodel.lua")
    AddCSLuaFile("advanced_accessories/vgui/cl_checkbox.lua")
else
    include("advanced_accessories/client/cl_gradients.lua")
    include("advanced_accessories/client/cl_fonts.lua")
    include("advanced_accessories/client/cl_main.lua")
    include("advanced_accessories/client/cl_functions.lua")
    include("advanced_accessories/client/cl_notify.lua")
    include("advanced_accessories/client/cl_bodygroup.lua")
    include("advanced_accessories/client/cl_admin.lua")
    include("advanced_accessories/client/cl_inventory.lua")
    include("advanced_accessories/client/cl_models.lua")
    include("advanced_accessories/client/cl_player_settings.lua")
    
    include("advanced_accessories/vgui/cl_button.lua")
    include("advanced_accessories/vgui/cl_cards.lua")
    include("advanced_accessories/vgui/cl_searchbar.lua")
    include("advanced_accessories/vgui/cl_slider.lua")
    include("advanced_accessories/vgui/cl_scroll.lua")
    include("advanced_accessories/vgui/cl_textentry.lua")
    include("advanced_accessories/vgui/cl_combobox.lua")
    include("advanced_accessories/vgui/cl_dmodel.lua")
    include("advanced_accessories/vgui/cl_checkbox.lua")
end