local MODULE = GAS.Logging:MODULE()

MODULE.Category = "CH ATM"
MODULE.Name = "Other Transactions"
MODULE.Colour = Color( 52, 152, 219 )

MODULE:Setup( function()
	MODULE:Hook( "CH_ATM_bLogs_TakeMoney", "ch_atm_take_money", function( amount, ply, reason )
		MODULE:Log( "{1} has been taken from {2}'s bank account. Reason: {3}.", GAS.Logging:FormatMoney( amount ), GAS.Logging:FormatPlayer( ply ), GAS.Logging:Highlight( reason ) )
	end )
	
	MODULE:Hook( "CH_ATM_bLogs_ReceiveMoney", "ch_atm_receive_money", function( amount, ply, reason )
		MODULE:Log( "{1} has been added to {2}'s bank account. Reason: {3}.", GAS.Logging:FormatMoney( amount ), GAS.Logging:FormatPlayer( ply ), GAS.Logging:Highlight( reason ) )
	end )
end )

GAS.Logging:AddModule( MODULE )
