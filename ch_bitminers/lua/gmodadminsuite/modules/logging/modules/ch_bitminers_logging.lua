local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Bitminers"
MODULE.Name = "Withdrawals"
MODULE.Colour = Color( 0, 100, 0, 255 )

MODULE:Setup(function()
	MODULE:Hook("CH_BITMINER_PlayerWithdrawMoney", "bitminer_withdrawals", function(ply, amount)
		MODULE:Log("{1} has sold bitcoins worth {2} from their bitminer shelf.", GAS.Logging:FormatPlayer( ply ), GAS.Logging:FormatMoney( amount ) )
	end)
	
	MODULE:Hook("CH_BITMINER_PlayerWithdrawMoneyCrypto", "bitminer__cryptowithdrawals", function(ply, amount, crypto)
		MODULE:Log("{1} has withdrawn {2} {3} from their bitminer shelf to their crypto wallet.", GAS.Logging:FormatPlayer( ply ), GAS.Logging:Highlight( amount ), GAS.Logging:Highlight( crypto ) )
	end)
end)

GAS.Logging:AddModule(MODULE)