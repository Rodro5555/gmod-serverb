-- INITIALIZE SCRIPT
if SERVER then
	for k, v in ipairs( file.Find( "ch_bitminers_dlc/shared/*.lua", "LUA" ) ) do
		include( "ch_bitminers_dlc/shared/" .. v )
		--print("shared: ".. v)
	end
	
	for k, v in ipairs( file.Find( "ch_bitminers_dlc/shared/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_bitminers_dlc/shared/" .. v )
		--print("cs shared: ".. v)
	end
	
	for k, v in ipairs( file.Find( "ch_bitminers_dlc/server/*.lua", "LUA" ) ) do
		include( "ch_bitminers_dlc/server/" .. v )
		--print("server: ".. v)
	end
	
	for k, v in ipairs( file.Find( "ch_bitminers_dlc/client/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_bitminers_dlc/client/" .. v )
		--print("cs client: ".. v)
	end
end

if CLIENT then
	for k, v in ipairs( file.Find( "ch_bitminers_dlc/shared/*.lua", "LUA" ) ) do
		include( "ch_bitminers_dlc/shared/" .. v )
		--print("shared client: ".. v)
	end
	
	for k, v in ipairs( file.Find( "ch_bitminers_dlc/client/*.lua", "LUA" ) ) do
		include( "ch_bitminers_dlc/client/" .. v )
		--print("client: ".. v)
	end
end