local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Bank Robbery 2"
MODULE.Name = "Robbery"
MODULE.Colour = Color( 0, 0, 200 )  

MODULE:Setup(function()
	MODULE:Hook("CH_BankRobbery2_bLogs_RobberyInitiated", "ch_bank_robbery_initiated", function( ply, amount )
		MODULE:Log( "{1} has started a robbery on the bank vault.", GAS.Logging:FormatPlayer( ply ) )
	end)
	
	MODULE:Hook("CH_BankRobbery2_bLogs_JoinRobbery", "ch_bank_robbery_join", function( ply, amount )
		MODULE:Log( "{1} has joined the ongoing bank vault robbery.", GAS.Logging:FormatPlayer( ply ) )
	end)
	
	MODULE:Hook("CH_BankRobbery2_bLogs_RobberySuccessful", "ch_bank_robbery_successful", function( ply, money )
		MODULE:Log( "{1} has successfully robbed the bank vault containing a total of {2}.", GAS.Logging:FormatPlayer( ply ), GAS.Logging:FormatMoney( money ) )
	end)
	
	MODULE:Hook("CH_BankRobbery2_bLogs_RobberyFailed", "ch_bank_robbery_failed", function( ply, amount )
		MODULE:Log( "{1} has failed robbing the bank vault.", GAS.Logging:FormatPlayer( ply ) )
	end)
	
	MODULE:Hook("CH_BankRobbery2_bLogs_RobberyFailedEntirely", "ch_bank_robbery_failed_entirely", function( ply, amount )
		MODULE:Log( "{1} has failed robbing the bank vault. The entire robbery has failed and the police forces are victorious!", GAS.Logging:FormatPlayer( ply ) )
	end)
end)

GAS.Logging:AddModule(MODULE)