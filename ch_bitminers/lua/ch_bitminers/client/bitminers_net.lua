--[[
	NET MSG
--]]
net.Receive( "CH_BITMINERS_UpdateBitcoinRates", function( length, ply )
	if ply then
		if not ply:IsSuperAdmin() then
			return
		end
	end
	
	local rate = net.ReadUInt( 20 )
	CH_Bitminers.Config.BitcoinRate = math.Clamp( rate, CH_Bitminers.Config.MinBitcoinRate, CH_Bitminers.Config.MaxBitcoinRate )
	
	-- Notify everyone in chat if the config is enabled
	if CH_Bitminers.Config.NotifyPlayersChatRateUpdate then
		chat.AddText( Color( 52, 152, 219 ), "[Bitminers] ", Color( 255, 255, 255 ), CH_Bitminers.Config.Lang["The bitcoin exchange rate has just updated."][CH_Bitminers.Config.Language] )
		chat.AddText( Color( 52, 152, 219 ), "[Bitminers] ", Color( 255, 255, 255 ), CH_Bitminers.Config.Lang["One bitcoin exchanges for"][CH_Bitminers.Config.Language] .." ".. DarkRP.formatMoney( CH_Bitminers.Config.BitcoinRate ) )
	end
end )