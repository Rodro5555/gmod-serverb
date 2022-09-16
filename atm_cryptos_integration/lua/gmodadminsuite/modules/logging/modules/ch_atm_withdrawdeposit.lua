local MODULE = GAS.Logging:MODULE()

MODULE.Category = "CH ATM"
MODULE.Name = "Withdraw / Deposit"
MODULE.Colour = Color( 52, 152, 219 )

MODULE:Setup( function()
	MODULE:Hook( "CH_ATM_bLogs_DepositMoney", "ch_atm_deposit_money", function( ply, amount )
		MODULE:Log( "{1} has deposited {2} into their bank account.", GAS.Logging:FormatPlayer( ply ), GAS.Logging:FormatMoney( amount ) )
	end )

	MODULE:Hook( "CH_ATM_bLogs_WithdrawMoney", "ch_atm_withdraw_money", function( ply, amount )
		MODULE:Log( "{1} has withdrawn {2} from their bank account.", GAS.Logging:FormatPlayer( ply ), GAS.Logging:FormatMoney( amount ) )
	end )
end )

GAS.Logging:AddModule( MODULE )
