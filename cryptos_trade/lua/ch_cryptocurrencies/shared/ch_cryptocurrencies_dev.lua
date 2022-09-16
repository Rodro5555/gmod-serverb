--[[
	Just a simple developer function to do debug prints
	Requires that debugmode is enabled
--]]
CH_CryptoCurrencies.Config.DebugMode = false

function CH_CryptoCurrencies.DebugPrint( to_print )
	if not CH_CryptoCurrencies.Config.DebugMode then
		return
	end
	
	if istable( to_print ) then
		PrintTable( to_print )
	else
		print( to_print )
	end
end