
local DebugPrint = false

local function NicePrint(txt)
    if DebugPrint == false then return end

    if SERVER then
        MsgC(Color(84, 150, 197), txt .. "\n")
    else
        MsgC(Color(193, 193, 98), txt .. "\n")
    end
end


local function PreLoadFile(path)
	if CLIENT then
		include(path)
	else
		AddCSLuaFile(path)
		include(path)
	end
end

local function LoadFiles(path)
	local files, _ = file.Find(path .. "/*", "LUA")

	for _, v in ipairs(files) do
		if string.sub(v, 1, 3) == "sh_" then
			if CLIENT then
				include(path .. "/" .. v)
			else
				AddCSLuaFile(path .. "/" .. v)
				include(path .. "/" .. v)
			end

			NicePrint("// Loaded " .. v .. string.rep(" ", 38 - v:len()) .. " //")
		end
	end

	for _, v in ipairs(files) do
		if string.sub(v, 1, 3) == "cl_" then
			if CLIENT then
				include(path .. "/" .. v)
				NicePrint("// Loaded " .. v .. string.rep(" ", 38 - v:len()) .. " //")
			else
				AddCSLuaFile(path .. "/" .. v)
			end
		elseif string.sub(v, 1, 3) == "sv_" then
			include(path .. "/" .. v)
			NicePrint("// Loaded " .. v .. string.rep(" ", 38 - v:len()) .. " //")
		end
	end
end

local function Initialize()
	NicePrint(" ")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("////////////// Zeros OilRush /////////////////////")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("//                                               //")
	PreLoadFile("sh_zrush_config_main.lua")
	PreLoadFile("sh_zrush_config_fuel.lua")
	PreLoadFile("sh_zrush_config_modules.lua")
	PreLoadFile("sh_zrush_config_machines.lua")
	PreLoadFile("sh_zrush_config_oilspot.lua")
	LoadFiles("zrush_languages")
	LoadFiles("zrush/util")
	LoadFiles("zrush/util/player")
	LoadFiles("zrush/generic")
	LoadFiles("zrush/modules")
	LoadFiles("zrush/barrel")
	LoadFiles("zrush/burner")
	LoadFiles("zrush/crate")
	LoadFiles("zrush/drillhole")
	LoadFiles("zrush/drilltower")
	LoadFiles("zrush/drillpipeholder")
	LoadFiles("zrush/machine")
	LoadFiles("zrush/npc")
	LoadFiles("zrush/oilspot")
	LoadFiles("zrush/palette")
	LoadFiles("zrush/pump")
	LoadFiles("zrush/refinery")
	NicePrint("//                                               //")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("///////////////////////////////////////////////////")

	if DebugPrint == false then
        if SERVER then
            MsgC(Color(84, 150, 197), "Zeros OilRush - Loaded\n")
        else
            MsgC(Color(193, 193, 98), "Zeros OilRush - Loaded\n")
        end
    end
end

PreLoadFile("zrush/util/cl_settings.lua")

timer.Simple(0, function()
	// If zeros libary is not installed on the server then lets tell them
	if zclib == nil then
		local function Warning(ply, msg)
			if DarkRP and DarkRP.notify then
				DarkRP.notify(ply, 1, 8, msg)
			else
				ply:ChatPrint(msg)
			end
		end

		MsgC(Color(255, 0, 0), "[Zeros OilRush] > Zeros Lua Libary not found!")
		MsgC(Color(255, 0, 0), "https://steamcommunity.com/sharedfiles/filedetails/?id=2532060111")

		if CLIENT then
			surface.PlaySound("common/warning.wav")
		end

		if SERVER then
			for k, v in ipairs(player.GetAll()) do
				if IsValid(v) then
					Warning(v, "[Zeros OilRush] > Zeros Lua Libary not found!")
					Warning(v, "https://steamcommunity.com/sharedfiles/filedetails/?id=2532060111")
				end
			end
		end

		return
	end

	Initialize()
end)
