-- INITIALIZE SCRIPT
 
if SERVER then
	MsgC( Color( 52, 152, 219 ), "-------------------------------------------------------------------------------\n" )
	MsgC( Color( 52, 152, 219 ), "          CryptoCurrencies by Crap-Head | ", color_white, "Initializing server files.\n")
	MsgC( Color( 52, 152, 219 ), "-------------------------------------------------------------------------------\n" )
	
	for k, v in ipairs( file.Find( "ch_cryptocurrencies/shared/*.lua", "LUA" ) ) do
		include( "ch_cryptocurrencies/shared/" .. v )
		MsgC( Color( 52, 152, 219 ), "CryptoCurrencies by Crap-Head | Loaded file ", color_white, v .."\n" )
	end
	
	for k, v in ipairs( file.Find( "ch_cryptocurrencies/shared/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_cryptocurrencies/shared/" .. v )
		MsgC( Color( 52, 152, 219 ), "CryptoCurrencies by Crap-Head | Loaded file ", color_white, v .."\n" )
	end
	
	for k, v in ipairs( file.Find( "ch_cryptocurrencies/shared/currencies/*.lua", "LUA" ) ) do
		include( "ch_cryptocurrencies/shared/currencies/" .. v )
		MsgC( Color( 52, 152, 219 ), "CryptoCurrencies by Crap-Head | Loaded file ", color_white, v .."\n" )
	end
	
	for k, v in ipairs( file.Find( "ch_cryptocurrencies/shared/currencies/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_cryptocurrencies/shared/currencies/" .. v )
		MsgC( Color( 52, 152, 219 ), "CryptoCurrencies by Crap-Head | Loaded file ", color_white, v .."\n" )
	end
	
	for k, v in ipairs( file.Find( "ch_cryptocurrencies/server/*.lua", "LUA" ) ) do
		include( "ch_cryptocurrencies/server/" .. v )
		MsgC( Color( 52, 152, 219 ), "CryptoCurrencies by Crap-Head | Loaded file ", color_white, v .."\n" )
	end
	
	for k, v in ipairs( file.Find( "ch_cryptocurrencies/server/mysql/*.lua", "LUA" ) ) do
		include( "ch_cryptocurrencies/server/mysql/" .. v )
		MsgC( Color( 52, 152, 219 ), "CryptoCurrencies by Crap-Head | Loaded file ", color_white, v .."\n" )
	end
	
	for k, v in ipairs( file.Find( "ch_cryptocurrencies/client/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_cryptocurrencies/client/" .. v )
		MsgC( Color( 52, 152, 219 ), "CryptoCurrencies by Crap-Head | Loaded file ", color_white, v .."\n" )
	end
	
	for k, v in ipairs( file.Find( "ch_cryptocurrencies/client/vgui/*.lua", "LUA" ) ) do
		AddCSLuaFile( "ch_cryptocurrencies/client/vgui/" .. v )
		MsgC( Color( 52, 152, 219 ), "CryptoCurrencies by Crap-Head | Loaded file ", color_white, v .."\n" )
	end
	
	MsgC( Color( 52, 152, 219 ), "-----------------------------------------------------------------------------\n" )
	MsgC( Color( 52, 152, 219 ), "          CryptoCurrencies by Crap-Head | ", color_white, "Server files initialized\n" )
	MsgC( Color( 52, 152, 219 ), "-----------------------------------------------------------------------------\n" )
end

if CLIENT then
	MsgC( Color( 52, 152, 219 ), "-------------------------------------------------------------------------------\n" )
	MsgC( Color( 52, 152, 219 ), "       CryptoCurrencies by Crap-Head | ", color_white, "Initializing client/shared files\n")
	MsgC( Color( 52, 152, 219 ), "-------------------------------------------------------------------------------\n" )
	
	for k, v in ipairs( file.Find( "ch_cryptocurrencies/shared/*.lua", "LUA" ) ) do
		include( "ch_cryptocurrencies/shared/" .. v )
		MsgC( Color( 52, 152, 219 ), "CryptoCurrencies by Crap-Head | Loaded file ", color_white, v .."\n" )
	end
	
	for k, v in ipairs( file.Find( "ch_cryptocurrencies/shared/currencies/*.lua", "LUA" ) ) do
		include( "ch_cryptocurrencies/shared/currencies/" .. v )
		MsgC( Color( 52, 152, 219 ), "CryptoCurrencies by Crap-Head | Loaded file ", color_white, v .."\n" )
	end
	
	for k, v in ipairs( file.Find( "ch_cryptocurrencies/client/*.lua", "LUA" ) ) do
		include( "ch_cryptocurrencies/client/" .. v )
		MsgC( Color( 52, 152, 219 ), "CryptoCurrencies by Crap-Head | Loaded file ", color_white, v .."\n" )
	end
	
	for k, v in ipairs( file.Find( "ch_cryptocurrencies/client/vgui/*.lua", "LUA" ) ) do
		include( "ch_cryptocurrencies/client/vgui/" .. v )
		MsgC( Color( 52, 152, 219 ), "CryptoCurrencies by Crap-Head | Loaded file ", color_white, v .."\n" )
	end
	
	MsgC( Color( 52, 152, 219 ), "-----------------------------------------------------------------------------\n" )
	MsgC( Color( 52, 152, 219 ), "          CryptoCurrencies by Crap-Head | ", color_white, "Client/shared files initialized\n" )
	MsgC( Color( 52, 152, 219 ), "-----------------------------------------------------------------------------\n" )
end