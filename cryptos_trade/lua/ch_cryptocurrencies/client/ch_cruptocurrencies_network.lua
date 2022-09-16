-- Initialize
CH_CryptoCurrencies.CryptosCL = CH_CryptoCurrencies.CryptosCL or {}
CH_CryptoCurrencies.CryptoIconsCL = CH_CryptoCurrencies.CryptoIconsCL or {}
CH_CryptoCurrencies.CryptoExchangeScreen = CH_CryptoCurrencies.CryptoExchangeScreen or {}

--[[
	Receive all cryptocurrencies values
--]]
net.Receive( "CH_CryptoCurrencies_Net_NetworkCurrencies", function( len, ply )
	local amount_of_entries = net.ReadUInt( 6 )
	
	for i = 1, amount_of_entries do
		local index = net.ReadUInt( 6 )
		local crypto_rate = net.ReadDouble()
		
		-- Calculate crypto change in percentage if applicable
		local crypto_change = 0
		
		if CH_CryptoCurrencies.CryptosCL[ index ] then
			local previous_price = CH_CryptoCurrencies.CryptosCL[ index ].Price
			local crypto_difference = crypto_rate - previous_price
			
			if previous_price != 0 and crypto_difference != 0 then -- If a crypto is invalid from the API fetch then both will return 0. In this event, the below math will return undefined
				crypto_change = math.Round( ( crypto_difference / previous_price ) * 100, 2 )
			end
		end
		
		-- Write table to the client
		CH_CryptoCurrencies.CryptosCL[ index ] = {
			Currency = CH_CryptoCurrencies.Config.Currencies[ index ].Currency,
			Name = CH_CryptoCurrencies.Config.Currencies[ index ].Name,
			Icon = Material( CH_CryptoCurrencies.Config.Currencies[ index ].Icon, "noclamp smooth" ),
			Price = crypto_rate,
			Change = crypto_change,
		}
	end
	
	-- Add icons to it's own table with index as crypto prefix.
	-- We need this for the pages where we don't have a numeric index according to CryptosCL table. (like transactions for example)
	if table.IsEmpty( CH_CryptoCurrencies.CryptoIconsCL ) then
		for index, crypto in ipairs( CH_CryptoCurrencies.CryptosCL ) do
			CH_CryptoCurrencies.CryptoIconsCL[ crypto.Currency ] = {
				Icon = crypto.Icon,
			}
		end
	end
	
	-- Write a table with positions and offsets for the exchange rate screen
	CH_CryptoCurrencies.SetupScreenTable()
	
	CH_CryptoCurrencies.DebugPrint( "Network Currencies CLIENT" )
	CH_CryptoCurrencies.DebugPrint( CH_CryptoCurrencies.CryptosCL )
end )

--[[
	Receive the players wallet and network it to him
--]]
net.Receive( "CH_CryptoCurrencies_Net_NetworkWallet", function( len, ply )
	local amount_of_entries = net.ReadUInt( 6 )
	
	-- Create CL wallet if not exists
	local player = LocalPlayer()
	player.CH_CryptoCurrencies_Wallet = player.CH_CryptoCurrencies_Wallet or {}
	
	for i = 1, amount_of_entries do
		local crypto_prefix = net.ReadString()
		local crypto_amount = net.ReadDouble()
	
		player.CH_CryptoCurrencies_Wallet[ crypto_prefix ] = {
			Amount = crypto_amount,
		}
	end

	CH_CryptoCurrencies.DebugPrint( "CLIENTSIDE WALLET FOR: ".. player:Nick() )
	CH_CryptoCurrencies.DebugPrint( player.CH_CryptoCurrencies_Wallet )
end )

--[[
	Receive the players transactions and network it to him
--]]
net.Receive( "CH_CryptoCurrencies_Net_NetworkTransactions", function( len, ply )
	if not CH_CryptoCurrencies.Config.EnableSQL then
		return
	end
	
	local amount_of_entries = net.ReadUInt( 6 )
	
	-- Create CL wallet if not exists
	local player = LocalPlayer()
	player.CH_CryptoCurrencies_Transactions = CH_CryptoCurrencies_Transactions or {}
	
	for i = 1, amount_of_entries do
		local crypto_action = net.ReadString()
		local crypto_crypto = net.ReadString()
		local crypto_name = net.ReadString()
		local crypto_amount = net.ReadDouble()
		local crypto_price = net.ReadDouble()
		local crypto_timestamp = net.ReadString()
	
		player.CH_CryptoCurrencies_Transactions[ i ] = {
			Action = crypto_action,
			Crypto = crypto_crypto,
			Name = crypto_name,
			Amount = crypto_amount,
			Price = crypto_price,
			TimeStamp = crypto_timestamp,
		}
	end

	CH_CryptoCurrencies.DebugPrint( "CLIENTSIDE TRANSACTIONS FOR: ".. player:Nick() )
	CH_CryptoCurrencies.DebugPrint( player.CH_CryptoCurrencies_Transactions )
end )

--[[
	Colored chat print
--]]
net.Receive( "CH_CryptoCurrencies_Net_ColorChatPrint", function( length, ply )
	local color_r = net.ReadUInt( 8 )
	local color_g = net.ReadUInt( 8 )
	local color_b = net.ReadUInt( 8 )
	local text = net.ReadString()
	
	-- Notify everyone in chat if the config is enabled
	if CH_CryptoCurrencies.Config.NotifyPlayersChatFetch then
		chat.AddText( Color( color_r, color_g, color_b ), "[Cryptocurrencies] ", color_white, text )
	end
end )