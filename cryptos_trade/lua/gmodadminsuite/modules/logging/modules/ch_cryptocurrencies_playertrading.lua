local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Crypto"
MODULE.Name = "Player Trading"
MODULE.Colour = Color( 70, 70, 70 )

MODULE:Setup( function()
	MODULE:Hook( "CH_CryptoCurrencies_bLogs_SendCrypto", "ch_cryptocurrencies_send_crypto", function( ply, amount, currency, receiver )
		MODULE:Log( "{1} has sent {2} {3}'s to {4}.", GAS.Logging:FormatPlayer( ply ), GAS.Logging:Highlight( amount ), GAS.Logging:Highlight( currency ), GAS.Logging:FormatPlayer( receiver ) )
	end )
end )

GAS.Logging:AddModule( MODULE )