zrmine = zrmine or {}
zrmine.f = zrmine.f or {}


local function NicePrint(txt)
	if SERVER then
		MsgC(Color(98, 141, 193), txt .. "\n")
	else
		MsgC(Color(193, 193, 98), txt .. "\n")
	end
end

local IgnoreFileTable = {}

function zrmine.f.PreLoadFile(fdir,afile,info)
	IgnoreFileTable[afile] = true
	zrmine.f.LoadFile(fdir,afile,info)
end

function zrmine.f.LoadFile(fdir,afile,info)

	if info then
		local nfo = "// [ Initialize ]: " .. afile .. string.rep( " ", 30 - afile:len() ) .. "//"
		NicePrint( nfo )
	end

	if SERVER then
		AddCSLuaFile(fdir .. afile)
	end

	include(fdir .. afile)
end

function zrmine.f.LoadAllFiles(fdir)
	local files, dirs = file.Find(fdir .. "*", "LUA")

	for _, afile in ipairs(files) do
		if string.match(afile, ".lua") and not IgnoreFileTable[afile] then
			zrmine.f.LoadFile(fdir,afile,true)
		end
	end

	for _, dir in ipairs(dirs) do
		zrmine.f.LoadAllFiles(fdir .. dir .. "/")
	end
end

// Initializes the Script
function zrmine.f.Initialize()
	NicePrint(" ")
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("////////////////// Zeros RetroMiner ///////////////")
	NicePrint("///////////////////////////////////////////////////")

	zrmine.f.PreLoadFile("","zrmine_config.lua",true)
	zrmine.f.LoadAllFiles("zrms_languages/")


	zrmine.f.LoadAllFiles("zrms/sh/")
	if SERVER then
		zrmine.f.LoadAllFiles("zrms/sv/")
	end
	zrmine.f.LoadAllFiles("zrms/cl/")

	NicePrint("///////////////////////////////////////////////////")
	NicePrint("///////////////////////////////////////////////////")
end

if SERVER then
	timer.Simple(0,function()
		zrmine.f.Initialize()
	end)
else

	// This needs to be called instantly on client since client settings wont work otherwhise
	zrmine.f.PreLoadFile("zrms/sh/","zrmine_materials.lua",false)
	zrmine.f.PreLoadFile("zrms/cl/","zrmine_fonts.lua",false)
	zrmine.f.PreLoadFile("zrms/cl/","zrmine_settings_menu.lua",false)

	timer.Simple(0,function()
		zrmine.f.Initialize()
	end)
end
