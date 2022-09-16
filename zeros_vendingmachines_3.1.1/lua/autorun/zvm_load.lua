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

local function PrintFile(txt) NicePrint("// Loaded " .. string.sub(txt,1,38) .. string.rep(" ", 38 - txt:len()) .. " //") end

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
			PrintFile(v)
		end
	end

	for _, v in ipairs(files) do
		if string.sub(v, 1, 3) == "cl_" then
			if CLIENT then
				include(path .. "/" .. v)
				PrintFile(v)
			else
				AddCSLuaFile(path .. "/" .. v)
			end
		elseif string.sub(v, 1, 3) == "sv_" then
			include(path .. "/" .. v)
			PrintFile(v)
		end
	end
end

local function Initialize()
	NicePrint(" ")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("/////////// Zero´s Vendingmachines ////////////////")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("//                                               //")

	PreLoadFile("sh_zvm_config.lua")

	LoadFiles("zvm_languages")

	LoadFiles("zvendingmachine/util")
	LoadFiles("zvendingmachine/util/player")
	LoadFiles("zvendingmachine/generic")
	LoadFiles("zvendingmachine/crate")
	LoadFiles("zvendingmachine/machine")
	LoadFiles("zvendingmachine/module")

	NicePrint("//                                               //")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("//                                               //")
	LoadFiles("zvm_modules")
	NicePrint("//                                               //")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("///////////////////////////////////////////////////")

	if DebugPrint == false then
        if SERVER then
            MsgC(Color(84, 150, 197), "Zeros Vendingmachines - Loaded\n")
        else
            MsgC(Color(193, 193, 98), "Zeros Vendingmachines - Loaded\n")
        end
    end
end

PreLoadFile("zvendingmachine/util/cl_settings.lua")

// NOTE The reason why we wait a bit longer then normal is to make sure any other script thats mentioned in the modules has fully Initialized
// NOTE If you encounter any (File not found) errors then this means you joined too early. [Make sure you join after this script has been loaded by the SERVER]
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

		MsgC(Color(255, 0, 0), "[Zero´s Vendingmachines] > Zeros Lua Libary not found!")
		MsgC(Color(255, 0, 0), "https://steamcommunity.com/sharedfiles/filedetails/?id=2532060111")

		if CLIENT then
			surface.PlaySound( "common/warning.wav" )
		end

		if SERVER then
			for k,v in ipairs(player.GetAll()) do
				if IsValid(v) then
					Warning(v, "[Zero´s Vendingmachines] > Zeros Lua Libary not found!")
					Warning(v, "https://steamcommunity.com/sharedfiles/filedetails/?id=2532060111")
				end
			end
		end
		return
	end

	Initialize()
end)
