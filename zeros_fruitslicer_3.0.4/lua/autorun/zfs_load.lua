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

			NicePrint("// Loaded " .. string.sub(v, 1, 38) .. string.rep(" ", 38 - v:len()) .. " //")
		end
	end

	for _, v in ipairs(files) do
		if string.sub(v, 1, 3) == "cl_" then
			if CLIENT then
				include(path .. "/" .. v)
				NicePrint("// Loaded " .. string.sub(v, 1, 38) .. string.rep(" ", 38 - v:len()) .. " //")
			else
				AddCSLuaFile(path .. "/" .. v)
			end
		elseif string.sub(v, 1, 3) == "sv_" then
			include(path .. "/" .. v)
			NicePrint("// Loaded " .. string.sub(v, 1, 38) .. string.rep(" ", 38 - v:len()) .. " //")
		end
	end
end

local function Initialize()
	NicePrint(" ")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("///////////// Zeros Fruitslicer ///////////////////")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("//                                               //")

	PreLoadFile("sh_zfs_config_fruits.lua")
	PreLoadFile("sh_zfs_config_main.lua")
	PreLoadFile("sh_zfs_config_smoothies.lua")
	PreLoadFile("sh_zfs_config_toppings.lua")
	PreLoadFile("sv_zfs_hooks.lua")

	PreLoadFile("zfruitslicer/util/sh_util.lua")
	LoadFiles("zfs_languages")

	LoadFiles("zfruitslicer/util")
	LoadFiles("zfruitslicer/util/player")

	LoadFiles("zfruitslicer/benefit")
	LoadFiles("zfruitslicer/shop")
	LoadFiles("zfruitslicer/fruitbox")
	LoadFiles("zfruitslicer/smoothie")
	LoadFiles("zfruitslicer/topping")
	LoadFiles("zfruitslicer/fruit")

	NicePrint("//                                               //")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("///////////////////////////////////////////////////")

	if DebugPrint == false then
		if SERVER then
			MsgC(Color(84, 150, 197), "Zeros Fruitslicer - Loaded\n")
		else
			MsgC(Color(193, 193, 98), "Zeros Fruitslicer - Loaded\n")
		end
	end
end
PreLoadFile("zfruitslicer/util/cl_settings.lua")

timer.Simple(0, function()
	-- If zeros libary is not installed on the server then lets tell them
	if zclib == nil then
		local function Warning(ply, msg)
			if DarkRP and DarkRP.notify then
				DarkRP.notify(ply, 1, 8, msg)
			else
				ply:ChatPrint(msg)
			end
		end

		MsgC(Color(255, 0, 0), "[Zero´s Fruitslicer] > Zeros Lua Libary not found!")
		MsgC(Color(255, 0, 0), "https://steamcommunity.com/sharedfiles/filedetails/?id=2532060111")

		if CLIENT then
			surface.PlaySound("common/warning.wav")
		end

		if SERVER then
			for k, v in ipairs(player.GetAll()) do
				if IsValid(v) then
					Warning(v, "[Zero´s Fruitslicer] > Zeros Lua Libary not found!")
					Warning(v, "https://steamcommunity.com/sharedfiles/filedetails/?id=2532060111")
				end
			end
		end

		return
	end

	Initialize()
end)
