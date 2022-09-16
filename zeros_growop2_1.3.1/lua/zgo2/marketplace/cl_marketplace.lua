zgo2 = zgo2 or {}
zgo2.Marketplace = zgo2.Marketplace or {}

/*

	The Marketplace manages which players has what weed in which Marketplace in the world
	Players can sell large amounts of weed from here

*/

/*
	Updates buy_rate of the marketplaces
*/
zgo2.Marketplace.LastUpdateRate = CurTime()
net.Receive("zgo2.Marketplace.UpdateRate", function(len,ply)
    zclib.Debug_Net("zgo2.Marketplace.UpdateRate", len)
	local MarketID = net.ReadUInt(10)
	local BuyRate = net.ReadUInt(10)

	zgo2.Marketplace.List[MarketID].buy_rate = BuyRate

	zgo2.Marketplace.LastUpdateRate = net.ReadUInt(32)
end)

/*
	Updates what cargo the player has in the specified marketplace
*/
net.Receive("zgo2.Marketplace.UpdateCargo", function(len,ply)
    zclib.Debug_Net("zgo2.Marketplace.UpdateCargo", len)

	local id = net.ReadUInt(10)

	local dataLength = net.ReadUInt(16)
    local dataDecompressed = util.Decompress(net.ReadData(dataLength))
    local list = util.JSONToTable(dataDecompressed)

	zgo2.Marketplace.List[id].Cargo = list or {}

	hook.Run("zgo2.Marketplace.OnCargoUpdate",id)
end)

/*
	Adds a newly created transfer to the transfer list
*/
zgo2.Marketplace.Transfers = {
	/*
		[TransferID] = {StartID = NUMBER,DestinationID = NUMBER, WeedList = TABLE}
	*/
}
net.Receive("zgo2.Marketplace.SendCargo", function(len,ply)
    zclib.Debug_Net("zgo2.Marketplace.SendCargo", len)

	local TransferID = net.ReadString()
	local StartID = net.ReadUInt(10)
	local DestinationID = net.ReadUInt(10)

	local TravelDuration = net.ReadUInt(32)
	local MuleID = net.ReadUInt(32)

	zgo2.Marketplace.Transfers[TransferID] = {
		MuleID = MuleID,
		StartID = StartID,
		DestinationID = DestinationID,
		TravelDuration = TravelDuration,
		TravelStart = CurTime(),
		// This will be used to auto remove the transfer item later
		ArivalTime = CurTime() + TravelDuration
	}

	hook.Run("zgo2.Marketplace.OnTransferCreated",TransferID)
end)
