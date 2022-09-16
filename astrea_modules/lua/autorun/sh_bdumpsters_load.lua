bDumpsters = {}
bDumpsters.Config = {}

-- bDumpsters Print
local color_main = Color(235,70,70)
local color_secondary = Color(230,230,230)

-- bDumpsters Print Function
function bDumpsters.Print(str)
	local args = {}
	table.insert(args, 1, color_main)
	if SERVER then table.insert(args, 2, "[bDumpsters Server] ") else table.insert(args, 2, "[bDumpsters Client] ") end
	table.insert(args, 3, color_secondary)
	table.insert(args, 4, str)
	MsgC(unpack(args))
	MsgC("\n")
end

-- bDumpsters Message 
function bDumpsters.Message(ply, str, prefix)
    if type(str) != "string" then return end 
    if SERVER then

	    net.Start("bdumpsters_msg")
		    net.WriteString(str)
		    net.WriteString(prefix or "Dumpsters")
	    net.Send(ply)

    end

    if CLIENT then 
        chat.AddText(color_main, "["..prefix.."] ", color_secondary, str)
    end
end


-- Useful for Astrea.
-- bDumpsters Get Config Command, this allows us to have Astrea integration.
-- We need to make sure our setting names are the same in astrea and our local config.
-- Basically we're checking 'if Astrea exists, and "Overwrite Config" is turned on, use AstreaToolbox.Core.GetSetting(), else just check our config table'
function bDumpsters.GetSetting(setting)
	return (AstreaToolbox and AstreaToolbox.Core.GetSetting("dumpster_settings")) and AstreaToolbox.Core.GetSetting(setting) or bDumpsters.Config[setting]
end

function bDumpsters.GetLootSetting(setting)
	return (AstreaToolbox and AstreaToolbox.Core.GetSetting("dumpster_loot")) and AstreaToolbox.Core.GetSetting(setting) or bDumpsters.Config[setting] 
end




-- Load the files. 
bDumpsters.Print("Loading bDumpsters")

if SERVER then 

	include("bdumpsters_core/sv_core.lua")

	AddCSLuaFile("bdumpsters_core/sh_config.lua")
	include("bdumpsters_core/sh_config.lua")

	AddCSLuaFile("bdumpsters_core/cl_core.lua")

end

if CLIENT then 
	include("bdumpsters_core/sh_config.lua")
	include("bdumpsters_core/cl_core.lua")
end

bDumpsters.Print("Loaded bDumpsters")






