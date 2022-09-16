InvestigationMod = {}
InvestigationMod.Lang = {}
InvestigationMod.Configuration = {}
InvestigationMod.Configuration.JobsAllowed = {}

if CLIENT then
	InvestigationMod.Actions = InvestigationMod.Actions or {}
	InvestigationMod.Informations = InvestigationMod.Informations or {}
end

function InvestigationMod:LoadLanguage()
	local chosenLang = InvestigationMod.Configuration.Language or "en"

	local dirLang = "investigationmod/languages/" .. chosenLang .. ".lua"

	if not file.Exists(dirLang, "LUA") then chosenLang = "en" end

	if SERVER then
		AddCSLuaFile(dirLang)
	end
	InvestigationMod.Lang = include(dirLang)
end

function InvestigationMod:Init()

	local directories = { -- for priority order
		[ 1 ] = 'shared',
		[ 2 ] = 'server',
		[ 3 ] = 'client'
	}
	for _, file_name in pairs( file.Find( 'investigationmod/sh_*.lua', 'LUA' ) ) do

		-- include shared
		include( 'investigationmod/' .. file_name )
		if SERVER then
			-- AddCSLuaFile shared
			AddCSLuaFile( 'investigationmod/' .. file_name )
			print('loading ' .. file_name)
		end
	end
	for _, file_name in pairs( file.Find( 'investigationmod/cl_*.lua', 'LUA' ) ) do
		if SERVER then	
			-- AddCSLuaFile client
			AddCSLuaFile( 'investigationmod/' .. file_name )
			print('loading ' .. file_name)
		elseif CLIENT then
			-- include client
			include( 'investigationmod/' .. file_name )
		end
	end
	for _, file_name in pairs( file.Find( 'investigationmod/sv_*.lua', 'LUA' ) ) do
		if SERVER then	
			-- include server
			include( 'investigationmod/' .. file_name )
			print('loading ' .. file_name)
		end
	end

	for _, dir in pairs( directories ) do
		for _, file_name in pairs( file.Find( 'investigationmod/' .. dir .. '/sh_*.lua', 'LUA' ) ) do

			-- include shared
			include( 'investigationmod/' .. dir .. '/' .. file_name )
			if SERVER then
				-- AddCSLuaFile shared
				AddCSLuaFile( 'investigationmod/' .. dir .. '/' .. file_name )
				print('loading ' .. file_name)
			end
		end
		for _, file_name in pairs( file.Find( 'investigationmod/' .. dir .. '/cl_*.lua', 'LUA' ) ) do
			if SERVER then	
				-- AddCSLuaFile client
				AddCSLuaFile( 'investigationmod/' .. dir .. '/' .. file_name )
				print('loading ' .. file_name)
			elseif CLIENT then
				-- include client
				include( 'investigationmod/' .. dir .. '/' .. file_name )
			end
		end
		for _, file_name in pairs( file.Find( 'investigationmod/' .. dir .. '/sv_*.lua', 'LUA' ) ) do
			if SERVER then	
				-- include server
				include( 'investigationmod/' .. dir .. '/' .. file_name )
				print('loading ' .. file_name)
			end
		end
	end

	InvestigationMod:LoadLanguage()
end

InvestigationMod:Init()

function InvestigationMod:L(sKey)
	return InvestigationMod.Lang[sKey] or sKey
end