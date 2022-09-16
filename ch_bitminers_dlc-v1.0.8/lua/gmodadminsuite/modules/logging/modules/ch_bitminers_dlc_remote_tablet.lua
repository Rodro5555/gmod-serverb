local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Bitminers"
MODULE.Name = "Remote Tablet"
MODULE.Colour = Color( 240, 137, 19, 255 )

MODULE:Setup( function()
	MODULE:Hook( "CH_BITMINER_DLC_PlayerLinkedBitminer", "bitminer_link_remotely", function( ply, ply2 )
		MODULE:Log( "{1} has linked their remote tablet with {2}'s bitminer shelf.", GAS.Logging:FormatPlayer( ply ), GAS.Logging:FormatPlayer( ply2 ) )
	end )
	
	MODULE:Hook( "CH_BITMINER_DLC_PlayerWithdrawRemotely", "bitminer_withdraw_remotely", function( ply, amount )
		MODULE:Log( "{1} has sold bitcoins worth {2} from their bitminer shelf using the remote tablet.", GAS.Logging:FormatPlayer( ply ), GAS.Logging:FormatMoney( amount ) )
	end )
end )

GAS.Logging:AddModule( MODULE )