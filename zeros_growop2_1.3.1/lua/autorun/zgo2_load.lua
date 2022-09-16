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
			NicePrint("// Loaded " .. string.sub(v,1,38) .. string.rep(" ", 38 - v:len()) .. " //")
		end
	end

	for _, v in ipairs(files) do
		if string.sub(v, 1, 3) == "cl_" then
			if CLIENT then
				include(path .. "/" .. v)
				NicePrint("// Loaded " .. string.sub(v,1,38) .. string.rep(" ", 38 - v:len()) .. " //")
			else
				AddCSLuaFile(path .. "/" .. v)
			end
		elseif string.sub(v, 1, 3) == "sv_" then
			include(path .. "/" .. v)
			NicePrint("// Loaded " .. string.sub(v,1,38) .. string.rep(" ", 38 - v:len()) .. " //")
		end
	end
end

local function Initialize()
	NicePrint(" ")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("//////////////// Zero´s GrowOP 2 //////////////////")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("//                                               //")

	LoadFiles("zgo2/util")

	PreLoadFile("sh_zgo2_config_main.lua")

	LoadFiles("zgo2/languages")

	PreLoadFile("zgo2/plant/sh_plant.lua")
	PreLoadFile("zgo2/plant/sh_plant_material.lua")
	PreLoadFile("sh_zgo2_config_plant.lua")

	PreLoadFile("sh_zgo2_config_lamp.lua")
	PreLoadFile("sh_zgo2_config_pot.lua")
	PreLoadFile("sh_zgo2_config_rack.lua")
	PreLoadFile("sh_zgo2_config_tent.lua")
	PreLoadFile("sh_zgo2_config_watertank.lua")
	PreLoadFile("sh_zgo2_config_generator.lua")
	PreLoadFile("sh_zgo2_config_bong.lua")
	PreLoadFile("sh_zgo2_config_mule.lua")
	PreLoadFile("sh_zgo2_config_edibles.lua")

	LoadFiles("zgo2/util/player")

	LoadFiles("zgo2/generic")

	LoadFiles("zgo2/plant")

	LoadFiles("zgo2/seed")
	LoadFiles("zgo2/pot")
	LoadFiles("zgo2/soil")
	LoadFiles("zgo2/lamp")
	LoadFiles("zgo2/watertank")
	LoadFiles("zgo2/generator")
	LoadFiles("zgo2/tent")
	LoadFiles("zgo2/dryline")
	LoadFiles("zgo2/clipper")
	LoadFiles("zgo2/weedbranch")
	LoadFiles("zgo2/jar")
	LoadFiles("zgo2/rack")
	LoadFiles("zgo2/crate")
	LoadFiles("zgo2/pump")

	LoadFiles("zgo2/packer")
	LoadFiles("zgo2/weedblock")
	LoadFiles("zgo2/palette")

	LoadFiles("zgo2/higheffect")
	LoadFiles("zgo2/bong")

	LoadFiles("zgo2/shop")
	LoadFiles("zgo2/multitool")

	LoadFiles("zgo2/npc")
	LoadFiles("zgo2/marketplace")

	LoadFiles("zgo2/marketplace/cargo")
	// This gets called a second time but delayed to make sure any supported script are loaded
	timer.Simple(5,function() LoadFiles("zgo2/marketplace/cargo") end)


	LoadFiles("zgo2/logbook")
	LoadFiles("zgo2/jarcrate")

	LoadFiles("zgo2/doobytable")
	LoadFiles("zgo2/joint")

	LoadFiles("zgo2/splicer")

	PreLoadFile("sh_zgo2_hooks.lua")

	LoadFiles("zgo2/sniffer")
	LoadFiles("zgo2/baggy")
	LoadFiles("zgo2/backpack")
	LoadFiles("zgo2/cooking")

	NicePrint("//                                               //")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("///////////////////////////////////////////////////")

	if DebugPrint == false then
		if SERVER then
			MsgC(Color(84, 150, 197), "Zeros GrowOP 2 - Loaded\n")
		else
			MsgC(Color(193, 193, 98), "Zeros GrowOP 2 - Loaded\n")
		end
	end
end

PreLoadFile("zgo2/util/cl_settings.lua")

// Load the script delayed
timer.Simple(0,function()

	// If zeros libary is not installed on the server then lets tell them
	if zclib == nil then
		local function Warning(ply, msg)
			if DarkRP and DarkRP.notify then
				DarkRP.notify(ply, 1, 8, msg)
			else
				ply:ChatPrint(msg)
			end
		end

		MsgC(Color(255, 0, 0), "[Zero´s GrowOP 2] > Zeros Lua Libary not found!")
		MsgC(Color(255, 0, 0), "https://steamcommunity.com/sharedfiles/filedetails/?id=2532060111")

		if CLIENT then
			surface.PlaySound( "common/warning.wav" )
		end

		if SERVER then
			for k,v in ipairs(player.GetAll()) do
				if IsValid(v) then
					Warning(v, "[Zero´s GrowOP 2] > Zeros Lua Libary not found!")
					Warning(v, "https://steamcommunity.com/sharedfiles/filedetails/?id=2532060111")
				end
			end
		end
		return
	end

	Initialize()
end)


if SERVER then return end
/*
	Keep track on fonts which are created
*/
zgo2 = zgo2 or {}
zgo2.TrackedFonts = {}
local oldFontFunc = surface.CreateFont
function surface.CreateFont(name,data)
	zgo2.TrackedFonts[name] = true
	oldFontFunc(name,data)
end
