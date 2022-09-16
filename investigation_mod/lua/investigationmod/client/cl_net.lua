net.Receive( "InvestigationMod.SendFootPrints", function()
	local len = net.ReadUInt( 32 )
	local compressedData = net.ReadData( len )
	local jsonData = util.Decompress( compressedData )
	local tFootprints = util.JSONToTable( jsonData )

	InvestigationMod.FootSteps = InvestigationMod.FormatFootsteps( tFootprints )
end )

net.Receive( "InvestigationMod.SendDoorPrints", function()
	local len = net.ReadUInt( 32 )
	local compressedData = net.ReadData( len )
	local jsonData = util.Decompress( compressedData )
	local tDoorPrints = util.JSONToTable( jsonData )

	InvestigationMod.DoorFingerprint = tDoorPrints
end )