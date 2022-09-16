--[[
	Receive the players bank account and network it to him
--]]
net.Receive( "CH_ATM_Net_NetworkBankAccount", function( len, ply )
	local bank_account = net.ReadUInt( 32 )
	local bank_account_level = net.ReadUInt( 8 )
	local player = LocalPlayer()
	
	player.CH_ATM_BankAccount = bank_account
	player.CH_ATM_BankAccountLevel = bank_account_level

	CH_ATM.DebugPrint( "CLIENTSIDE BANK ACCOUNT FOR: ".. player:Nick() )
	CH_ATM.DebugPrint( player.CH_ATM_BankAccount )
	CH_ATM.DebugPrint( player.CH_ATM_BankAccountLevel )
end )

--[[
	Receive the players bank interest rate and network it to him
--]]
net.Receive( "CH_ATM_Net_NetworkInterestRate", function( len, ply )
	local interest_rate = net.ReadDouble()
	local player = LocalPlayer()
	
	player.CH_ATM_InterestRate = interest_rate

	CH_ATM.DebugPrint( "CLIENTSIDE BANK INTEREST RATE FOR: ".. player:Nick() )
	CH_ATM.DebugPrint( player.CH_ATM_InterestRate )
end )

--[[
	Receive the players bank transactions and network it to him
--]]
net.Receive( "CH_ATM_Net_NetworkTransactions", function( len, ply )
	if not CH_ATM.Config.EnableSQL then
		return
	end
	
	local amount_of_entries = net.ReadUInt( 6 )
	
	-- Create the clientside table if it does not exist
	local player = LocalPlayer()
	player.CH_ATM_Transactions = player.CH_ATM_Transactions or {}
	
	for i = 1, amount_of_entries do
		local crypto_action = net.ReadString()
		local crypto_amount = net.ReadDouble()
		local crypto_timestamp = net.ReadString()
	
		player.CH_ATM_Transactions[ i ] = {
			Action = crypto_action,
			Amount = crypto_amount,
			TimeStamp = crypto_timestamp,
		}
	end

	CH_ATM.DebugPrint( "CLIENTSIDE ATM TRANSACTIONS FOR: ".. player:Nick() )
	CH_ATM.DebugPrint( player.CH_ATM_Transactions )
end )