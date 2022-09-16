local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Bitminers"
MODULE.Name = "Hacking"
MODULE.Colour = Color( 60, 60, 60 ) 

MODULE:Setup( function()
	MODULE:Hook( "CH_BITMINER_DLC_PlayerStartedHacking", "bitminer_hacking_start", function( ply, ply2 )
		MODULE:Log( "{1} has started hacking {2}'s bitminer shelf.", GAS.Logging:FormatPlayer( ply ), GAS.Logging:FormatPlayer( ply2 ) )
	end )
	
	MODULE:Hook( "CH_BITMINER_DLC_PlayerFailedHacking", "bitminer_hacking_failed", function( ply, ply2 )
		MODULE:Log( "{1} has failed hacking {2}'s bitminer shelf.", GAS.Logging:FormatPlayer( ply ), GAS.Logging:FormatPlayer( ply2 ) )
	end )
	
	MODULE:Hook( "CH_BITMINER_DLC_PlayerSuccessfulHacking", "bitminer_hacking_successful", function( ply, ply2 )
		MODULE:Log( "{1} has successfully hacked {2}'s bitminer shelf.", GAS.Logging:FormatPlayer( ply ), GAS.Logging:FormatPlayer( ply2 ) )
	end )
end )

GAS.Logging:AddModule( MODULE )