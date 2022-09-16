MMF = MMF or {}
MMF.__index = MMF
MMF.Phrases = {}

-- include("magicmushroom/sh_dev.lua")
include("magicmushroom/sh_config.lua")
include("magicmushroom/sh_mushrooms.lua")
include("magicmushroom/sh_recipes.lua")
include("magicmushroom/sh_colors.lua")
include("magicmushroom/sh_animations.lua")
include("magicmushroom/i18n/" .. MMF.UILanguage .. ".lua")

if SERVER then
    AddCSLuaFile()
    AddCSLuaFile("magicmushroom/sh_config.lua")
    AddCSLuaFile("magicmushroom/sh_mushrooms.lua")
    AddCSLuaFile("magicmushroom/sh_recipes.lua")
    AddCSLuaFile("magicmushroom/sh_colors.lua")
    AddCSLuaFile("magicmushroom/sh_animations.lua")
    AddCSLuaFile("magicmushroom/i18n/" .. MMF.UILanguage .. ".lua")
    AddCSLuaFile("magicmushroom/cl_gnomes.lua")
    AddCSLuaFile("magicmushroom/cl_guide_vgui.lua")
    AddCSLuaFile("magicmushroom/cl_fonts.lua")
    AddCSLuaFile("magicmushroom/thirdparty/imgui.lua")
    include("magicmushroom/sv_sell.lua")
else
    include("magicmushroom/cl_gnomes.lua")
    include("magicmushroom/cl_guide_vgui.lua")
    include("magicmushroom/cl_fonts.lua")
end
