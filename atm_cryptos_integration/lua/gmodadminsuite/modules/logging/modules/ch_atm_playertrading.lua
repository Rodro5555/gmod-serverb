local MODULE = GAS.Logging:MODULE()

MODULE.Category = "CH ATM"
MODULE.Name = "Player Transactions"
MODULE.Colour = Color( 52, 152, 219 )

MODULE:Setup( function()
	MODULE:Hook( "CH_ATM_bLogs_SendMoney", "ch_atm_send_money", function( ply, amount, receiver )
		MODULE:Log( "{1} has sent {2} to {3}.", GAS.Logging:FormatPlayer( ply ), GAS.Logging:FormatMoney( amount ), GAS.Logging:FormatPlayer( receiver ) )
	end )
end )

GAS.Logging:AddModule( MODULE )
