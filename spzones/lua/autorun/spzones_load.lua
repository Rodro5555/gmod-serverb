AddCSLuaFile()

if SERVER then
    include"spzones/spconfig.lua"
    include"spzones/sv_spmain.lua"
    AddCSLuaFile("spzones/spconfig.lua")
    AddCSLuaFile("spzones/cl_spmain.lua")
end

if CLIENT then
    include"spzones/spconfig.lua"
    include"spzones/cl_spmain.lua"
end