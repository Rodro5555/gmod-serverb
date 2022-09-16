-- INITIALIZE SCRIPT
if SERVER then
	
	for k, v in pairs( file.Find( "ch_cocaine/server/*.lua", "LUA" ) ) do
		include( "ch_cocaine/server/" .. v )
		--print("server: ".. v)
	end
	
	for k, v in pairs( file.Find( "ch_cocaine/client/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_cocaine/client/" .. v )
		--print("cs client: ".. v)
	end
	
	for k, v in pairs( file.Find( "ch_cocaine/shared/*.lua", "LUA" ) ) do
		include( "ch_cocaine/shared/" .. v )
		--print("shared: ".. v)
	end
	
	for k, v in pairs( file.Find( "ch_cocaine/shared/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_cocaine/shared/" .. v )
		--print("cs shared: ".. v)
	end
	
	--[[
	if TCF.Config.EnableItemStore then
		for k, v in pairs( file.Find( "autorun/ch_cocaine/itemstore/items/*.lua", "LUA" ) ) do
			include( "autorun/ch_cocaine/itemstore/items/" .. v )
			--print("itemstore: ".. v)
		end
		
		for k, v in pairs( file.Find( "autorun/ch_cocaine/itemstore/items/*.lua", "LUA" ) ) do
			AddCSLuaFile( "autorun/ch_cocaine/itemstore/items/" .. v )
			--print("cs itemstore: ".. v)
		end
	end
	--]]
end

if CLIENT then
	for k, v in pairs( file.Find( "ch_cocaine/client/*.lua", "LUA" ) ) do
		include( "ch_cocaine/client/" .. v )
		--print("client: ".. v)
	end
	
	for k, v in pairs( file.Find( "ch_cocaine/shared/*.lua", "LUA" ) ) do
		include( "ch_cocaine/shared/" .. v )
		--print("shared client: ".. v)
	end
	
	--[[
	if TCF.Config.EnableItemStore then
		for k, v in pairs( file.Find( "autorun/ch_cocaine/itemstore/items/*.lua", "LUA" ) ) do
			include( "autorun/ch_cocaine/itemstore/items/" .. v )
			--print("itemstore client: ".. v)
		end
	end
	--]]
end