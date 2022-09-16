-- INITIALIZE SCRIPT
if SERVER then
	for k, v in pairs( file.Find( "ch_adv_medic/server/*.lua", "LUA" ) ) do
		include( "ch_adv_medic/server/" .. v )
		--print("server: ".. v)
	end
	
	for k, v in pairs( file.Find( "ch_adv_medic/client/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_adv_medic/client/" .. v )
		--print("cs client: ".. v)
	end
	
	for k, v in pairs( file.Find( "ch_adv_medic/shared/*.lua", "LUA" ) ) do
		include( "ch_adv_medic/shared/" .. v )
		--print("shared: ".. v)
	end
	
	for k, v in pairs( file.Find( "ch_adv_medic/shared/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_adv_medic/shared/" .. v )
		--print("cs shared: ".. v)
	end
end

if CLIENT then
	for k, v in pairs( file.Find( "ch_adv_medic/client/*.lua", "LUA" ) ) do
		include( "ch_adv_medic/client/" .. v )
		--print("client: ".. v)
	end
	
	for k, v in pairs( file.Find( "ch_adv_medic/shared/*.lua", "LUA" ) ) do
		include( "ch_adv_medic/shared/" .. v )
		--print("shared client: ".. v)
	end
end