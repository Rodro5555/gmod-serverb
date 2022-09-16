if SERVER then
	AddCSLuaFile()
	AddCSLuaFile('cl_mayorvoting.lua')
	AddCSLuaFile('sh_votingconfig.lua')
	AddCSLuaFile('cl_votingfonts.lua')
	//AddCSLuaFile('cl_tabs.lua')
	//AddCSLuaFile('cl_addtabs.lua')
	//AddCSLuaFile('cl_addservers.lua')
	
	--Add panel files
	AddCSLuaFile('panels/cl_votingpanel.lua')
	AddCSLuaFile('panels/cl_playericon.lua')
	
	--Add server files
	include('sv_mayorvoting.lua')
end

if CLIENT then
	include('cl_mayorvoting.lua')
end