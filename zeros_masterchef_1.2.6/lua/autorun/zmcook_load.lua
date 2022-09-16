
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
	NicePrint("////////////// Zero´s MasterCook //////////////////")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("//                                               //")

	PreLoadFile("zmcook/sh_main_config.lua")

	LoadFiles("zmc_languages")

	PreLoadFile("zmcook/sh_item_config.lua")
	PreLoadFile("zmcook/sh_dish_config.lua")
	PreLoadFile("zmcook/sh_buildkit_config.lua")
	PreLoadFile("zmcook/sh_hooks.lua")

	LoadFiles("zmcook/util")
	LoadFiles("zmcook/util/player")
	LoadFiles("zmcook/vgui")
	LoadFiles("zmcook/item")
	LoadFiles("zmcook/dish")
	LoadFiles("zmcook/save")
	LoadFiles("zmcook/inventory")
	LoadFiles("zmcook/generic")
	LoadFiles("zmcook/dishtable")
	LoadFiles("zmcook/fridge")
	LoadFiles("zmcook/worktable")
	LoadFiles("zmcook/oven")
	LoadFiles("zmcook/grill")
	LoadFiles("zmcook/mixer")
	LoadFiles("zmcook/wok")
	LoadFiles("zmcook/ordertable")
	LoadFiles("zmcook/customertable")
	LoadFiles("zmcook/garbagebin")
	LoadFiles("zmcook/souppot")
	LoadFiles("zmcook/boilpot")
	LoadFiles("zmcook/rotsystem")
	LoadFiles("zmcook/cookbook")
	LoadFiles("zmcook/washtable")

	LoadFiles("zmcook/buildkit")

	NicePrint("//                                               //")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("//                                               //")
	LoadFiles("zmcook_modules")
	NicePrint("//                                               //")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("///////////////////////////////////////////////////")

	if DebugPrint == false then
        if SERVER then
            MsgC(Color(84, 150, 197), "Zeros MasterCook - Loaded\n")
        else
            MsgC(Color(193, 193, 98), "Zeros MasterCook - Loaded\n")
        end
    end
end

PreLoadFile("zmcook/util/cl_settings.lua")


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

		MsgC(Color(255, 0, 0), "[Zero´s MasterCook] > Zeros Lua Libary not found!")
		MsgC(Color(255, 0, 0), "https://steamcommunity.com/sharedfiles/filedetails/?id=2532060111")

		if CLIENT then
			surface.PlaySound( "common/warning.wav" )
		end

		if SERVER then
			for k,v in ipairs(player.GetAll()) do
				if IsValid(v) then
					Warning(v, "[Zero´s MasterCook] > Zeros Lua Libary not found!")
					Warning(v, "https://steamcommunity.com/sharedfiles/filedetails/?id=2532060111")
				end
			end
		end
		return
	end

	Initialize()
end)
