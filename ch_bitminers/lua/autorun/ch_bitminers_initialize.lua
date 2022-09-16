-- INITIALIZE SCRIPT
if SERVER then
	for k, v in ipairs( file.Find( "ch_bitminers/shared/*.lua", "LUA" ) ) do
		include( "ch_bitminers/shared/" .. v )
		--print("shared: ".. v)
	end
	
	for k, v in ipairs( file.Find( "ch_bitminers/shared/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_bitminers/shared/" .. v )
		--print("cs shared: ".. v)
	end
	
	for k, v in ipairs( file.Find( "ch_bitminers/server/*.lua", "LUA" ) ) do
		include( "ch_bitminers/server/" .. v )
		--print("server: ".. v)
	end
	
	for k, v in ipairs( file.Find( "ch_bitminers/client/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_bitminers/client/" .. v )
		--print("cs client: ".. v)
	end
end

if CLIENT then
	for k, v in ipairs( file.Find( "ch_bitminers/shared/*.lua", "LUA" ) ) do
		include( "ch_bitminers/shared/" .. v )
		--print("shared client: ".. v)
	end
	
	for k, v in ipairs( file.Find( "ch_bitminers/client/*.lua", "LUA" ) ) do
		include( "ch_bitminers/client/" .. v )
		--print("client: ".. v)
	end
end