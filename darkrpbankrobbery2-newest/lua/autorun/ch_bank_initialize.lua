-- INITIALIZE SCRIPT
if SERVER then
	for k, v in ipairs( file.Find( "ch_bank_robbery/shared/*.lua", "LUA" ) ) do
		include( "ch_bank_robbery/shared/" .. v )
		--print("shared: ".. v)
	end
	
	for k, v in ipairs( file.Find( "ch_bank_robbery/shared/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_bank_robbery/shared/" .. v )
		--print("cs shared: ".. v)
	end
	
	for k, v in ipairs( file.Find( "ch_bank_robbery/server/*.lua", "LUA" ) ) do
		include( "ch_bank_robbery/server/" .. v )
		--print("server: ".. v)
	end
	
	for k, v in ipairs( file.Find( "ch_bank_robbery/client/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_bank_robbery/client/" .. v )
		--print("cs client: ".. v)
	end
end

if CLIENT then
	for k, v in ipairs( file.Find( "ch_bank_robbery/shared/*.lua", "LUA" ) ) do
		include( "ch_bank_robbery/shared/" .. v )
		--print("shared client: ".. v)
	end
	
	for k, v in ipairs( file.Find( "ch_bank_robbery/client/*.lua", "LUA" ) ) do
		include( "ch_bank_robbery/client/" .. v )
		--print("client: ".. v)
	end
end