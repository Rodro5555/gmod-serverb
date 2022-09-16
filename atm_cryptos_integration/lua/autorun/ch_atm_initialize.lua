-- INITIALIZE SCRIPT

if SERVER then
	MsgC( Color( 52, 152, 219 ), "-------------------------------------------------------------------------------\n" )
	MsgC( Color( 52, 152, 219 ), "          ATM by Crap-Head | ", color_white, "Initializing server files.\n")
	MsgC( Color( 52, 152, 219 ), "-------------------------------------------------------------------------------\n" )
	
	for k, v in ipairs( file.Find( "ch_atm/shared/*.lua", "LUA" ) ) do
		include( "ch_atm/shared/" .. v )
		MsgC( Color( 52, 152, 219 ), "ATM by Crap-Head | Loaded file ", color_white, v .."\n" )
	end
	
	for k, v in ipairs( file.Find( "ch_atm/shared/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_atm/shared/" .. v )
		MsgC( Color( 52, 152, 219 ), "ATM by Crap-Head | Loaded file ", color_white, v .."\n" )
	end
	
	for k, v in ipairs( file.Find( "ch_atm/shared/currencies/*.lua", "LUA" ) ) do
		include( "ch_atm/shared/currencies/" .. v )
		MsgC( Color( 52, 152, 219 ), "ATM by Crap-Head | Loaded file ", color_white, v .."\n" )
	end
	
	for k, v in ipairs( file.Find( "ch_atm/shared/currencies/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_atm/shared/currencies/" .. v )
		MsgC( Color( 52, 152, 219 ), "ATM by Crap-Head | Loaded file ", color_white, v .."\n" )
	end
	
	for k, v in ipairs( file.Find( "ch_atm/server/*.lua", "LUA" ) ) do
		include( "ch_atm/server/" .. v )
		MsgC( Color( 52, 152, 219 ), "ATM by Crap-Head | Loaded file ", color_white, v .."\n" )
	end
	
	for k, v in ipairs( file.Find( "ch_atm/server/mysql/*.lua", "LUA" ) ) do
		include( "ch_atm/server/mysql/" .. v )
		MsgC( Color( 52, 152, 219 ), "ATM by Crap-Head | Loaded file ", color_white, v .."\n" )
	end
	
	for k, v in ipairs( file.Find( "ch_atm/server/integrations/*.lua", "LUA" ) ) do
		include( "ch_atm/server/integrations/" .. v )
		MsgC( Color( 52, 152, 219 ), "ATM by Crap-Head | Loaded file ", color_white, v .."\n" )
	end
	
	for k, v in ipairs( file.Find( "ch_atm/client/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_atm/client/" .. v )
		MsgC( Color( 52, 152, 219 ), "ATM by Crap-Head | Loaded file ", color_white, v .."\n" )
	end
	
	MsgC( Color( 52, 152, 219 ), "-----------------------------------------------------------------------------\n" )
	MsgC( Color( 52, 152, 219 ), "          ATM by Crap-Head | ", color_white, "Server files initialized\n" )
	MsgC( Color( 52, 152, 219 ), "-----------------------------------------------------------------------------\n" )
end

if CLIENT then
	MsgC( Color( 52, 152, 219 ), "-------------------------------------------------------------------------------\n" )
	MsgC( Color( 52, 152, 219 ), "       ATM by Crap-Head | ", color_white, "Initializing client/shared files\n")
	MsgC( Color( 52, 152, 219 ), "-------------------------------------------------------------------------------\n" )
	
	for k, v in ipairs( file.Find( "ch_atm/shared/*.lua", "LUA" ) ) do
		include( "ch_atm/shared/" .. v )
		MsgC( Color( 52, 152, 219 ), "ATM by Crap-Head | Loaded file ", color_white, v .."\n" )
	end
	
	for k, v in ipairs( file.Find( "ch_atm/shared/currencies/*.lua", "LUA" ) ) do
		include( "ch_atm/shared/currencies/" .. v )
		MsgC( Color( 52, 152, 219 ), "ATM by Crap-Head | Loaded file ", color_white, v .."\n" )
	end
	
	for k, v in ipairs( file.Find( "ch_atm/client/*.lua", "LUA" ) ) do
		include( "ch_atm/client/" .. v )
		MsgC( Color( 52, 152, 219 ), "ATM by Crap-Head | Loaded file ", color_white, v .."\n" )
	end
	
	MsgC( Color( 52, 152, 219 ), "-----------------------------------------------------------------------------\n" )
	MsgC( Color( 52, 152, 219 ), "          ATM by Crap-Head | ", color_white, "Client/shared files initialized\n" )
	MsgC( Color( 52, 152, 219 ), "-----------------------------------------------------------------------------\n" )
end