zcm = zcm || {}
zcm.f = zcm.f || {}

local function NicePrint(txt)
	if SERVER then
		MsgC(Color(193, 98, 98), txt .. "\n")
	else
		MsgC(Color(193, 193, 98), txt .. "\n")
	end
end

local IgnoreFileTable = {}
function zcm.f.PreLoadFile(fdir,afile,info)
	IgnoreFileTable[afile] = true
	zcm.f.LoadFile(fdir,afile,info)
end

function zcm.f.LoadFile(fdir,afile,info)

	if info then
		local nfo = "// [ Initialize ]: " .. afile .. string.rep( " ", 30 - afile:len() ) .. "//"
		NicePrint(nfo)
	end

	if SERVER then
		AddCSLuaFile(fdir .. afile)
	end

	include(fdir .. afile)
end

function zcm.f.LoadAllFiles(fdir)
	local files, dirs = file.Find(fdir .. "*", "LUA")

	for _, afile in ipairs(files) do
		if string.match(afile, ".lua") and not IgnoreFileTable[afile] then
			zcm.f.LoadFile(fdir,afile,true)
		end
	end

	for _, dir in ipairs(dirs) do
		zcm.f.LoadAllFiles(fdir .. dir .. "/")
	end
end

// Initializes the Script
function zcm.f.Initialize()
	NicePrint("///////////////////////////////////////////////////")
	NicePrint("////////////// Zeros Crackermachine ///////////////")
	NicePrint("///////////////////////////////////////////////////")

	zcm.f.PreLoadFile("zcrackermachine/sh/","zcm_materials.lua",true)
	zcm.f.PreLoadFile("zcrackermachine/sh/","zcm_config.lua",true)

	zcm.f.LoadAllFiles("zcm_languages/")


	zcm.f.LoadAllFiles("zcrackermachine/sh/")
	if SERVER then
		zcm.f.LoadAllFiles("zcrackermachine/sv/")
	end
	zcm.f.LoadAllFiles("zcrackermachine/cl/")

	NicePrint("///////////////////////////////////////////////////")
	NicePrint("///////////////////////////////////////////////////")
end

if SERVER then
	timer.Simple(0,function()
		zcm.f.Initialize()
	end)
else


	// This needs to be called instantly on client since client settings wont work otherwhise
	zcm.f.PreLoadFile("zcrackermachine/sh/","zcm_materials.lua",false)
	zcm.f.PreLoadFile("zcrackermachine/cl/","zcm_fonts.lua",false)
	zcm.f.PreLoadFile("zcrackermachine/cl/","zcm_settings_menu.lua",false)

	timer.Simple(0,function()
		zcm.f.Initialize()
	end)
end
