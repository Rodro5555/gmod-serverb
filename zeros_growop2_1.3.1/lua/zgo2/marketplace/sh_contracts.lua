zgo2 = zgo2 or {}
zgo2.Contracts = zgo2.Contracts or {}
zgo2.Contracts.List = zgo2.Contracts.List or {}

/*

	This system will create global contracts for products in the marketplaces
	The player which delivers the goods the fastest will get the money

*/

if SERVER then

	concommand.Add("zgo2_spawn_contract", function(ply, cmd, args)
		if zclib.Player.IsAdmin(ply) then
			zgo2.Contracts.AddRandom()
			zclib.Notify(ply, "Random contract spawned!", 0)
		end
	end)


	/*
		Creates a new random global contract
	*/
	function zgo2.Contracts.AddRandom()
		// Get a random cargo class
		local _,class = table.Random(zgo2.Cargo.List)
		local CargoConfig = zgo2.Cargo.Get(class)

		// How much more money will the player get in %
		local profit = math.random(zgo2.config.Marketplace.Contracts.Profit.min,zgo2.config.Marketplace.Contracts.Profit.max)

		// Get a random cargo data set
		local CargoData = CargoConfig.GetRandom()

		// Where do we want the cargo to be delivered?
		local market = math.random(#zgo2.Marketplace.List)

		// How long do we have time?
		local time = math.random(zgo2.config.Marketplace.Contracts.Time.min,zgo2.config.Marketplace.Contracts.Time.max)

		zgo2.Contracts.Add(CargoData,profit,market,time)
	end

	/*
		Creates a new global contract
	*/
	util.AddNetworkString("zgo2.Contracts.Added")
	local NextID = 0
	function zgo2.Contracts.Add(CargoData, profit, market, time)
		NextID = NextID + 1
		local data = {
			cargo = CargoData,
			profit = profit,
			market = market,
			time = time,
			start = CurTime(),
			// All the players who will accept this contract
			Players = {}
		}
		zgo2.Contracts.List[NextID] = data

		local e_String = util.TableToJSON(data)
		local e_Compressed = util.Compress(e_String)

		net.Start("zgo2.Contracts.Added")
		net.WriteUInt(NextID,10)
		net.WriteUInt(#e_Compressed,16)
	    net.WriteData(e_Compressed,#e_Compressed)
		net.Broadcast()
	end

	/*
		Removes a contract
	*/
	util.AddNetworkString("zgo2.Contracts.Removed")
	function zgo2.Contracts.Remove(id)

		local data = zgo2.Contracts.List[id]

		local MarketID = data.market
		local MarketData = zgo2.Marketplace.List[MarketID]

		local RequestedCargo = data.cargo
		local CargoConfig = zgo2.Cargo.Get(RequestedCargo[1])
		local RequieredAmount = CargoConfig.GetAmount(RequestedCargo)

		//local Profit = data.profit

		// Before you remove it make sure you payout any player who has opt in for it and check if he delivered the cargo
		if data.Players == nil then data.Players = {} end
		for steamid64,OptIn in pairs(data.Players) do
			if not OptIn then continue end

			// This player does not have any cargo in this marketplace
			if not MarketData.Cargo[steamid64] then continue end

			local ply = player.GetBySteamID64( steamid64 )
			if not IsValid(ply) then continue end

			// Get the id of the cargo we want to sell
			local FoundID
			for cargo_id,cargo_data in pairs(MarketData.Cargo[steamid64]) do

				// Is this the requested cargo and does this player have enough?
				if CargoConfig.CanMerge(RequestedCargo,cargo_data) and CargoConfig.GetAmount(cargo_data) >= RequieredAmount then
					FoundID = cargo_id
					break
				end
			end

			if FoundID then
				// 229407176
				local cargo_data = MarketData.Cargo[steamid64][FoundID]
				local cargo_name = CargoConfig.GetFullName(cargo_data)

				local cargo_value = zgo2.Contracts.GetEarnings(id,ply)

				// Give him the cash
				zclib.Money.Give(ply,cargo_value)
				zclib.Notify(ply, "+" .. zclib.Money.Display(cargo_value), 0)

				hook.Run("zgo2.Marketplace.OnCargoSold",ply,MarketID,cargo_name,RequieredAmount,cargo_value,cargo_data)

				// Remove the amount
				CargoConfig.SetAmount(cargo_data,CargoConfig.GetAmount(cargo_data) - RequieredAmount)

				// Remove the cargo if its amount is equal or smaller then 0
				if CargoConfig.GetAmount(cargo_data) <= 0 then
					MarketData.Cargo[steamid64][FoundID] = nil
				end

				zgo2.Marketplace.UpdateCargo(ply,MarketID)
			end
		end

		zgo2.Contracts.List[id] = nil

		net.Start("zgo2.Contracts.Removed")
		net.WriteUInt(id,10)
		net.Broadcast()
	end

	/*
		Informs all players or a specific one about all the open contracts
	*/
	util.AddNetworkString("zgo2.Contracts.Update")
	function zgo2.Contracts.Update(ply)
		local e_String = util.TableToJSON(zgo2.Contracts.List)
		local e_Compressed = util.Compress(e_String)
		net.Start("zgo2.Contracts.Update")
		net.WriteUInt(#e_Compressed,16)
	    net.WriteData(e_Compressed,#e_Compressed)
		if ply then net.Send(ply) else net.Broadcast() end
	end

	/*
		Updates the buy rate for all the marketplaces at once
	*/
	local LastAdded = CurTime()
	zclib.Timer.Remove("zgo2.Contracts.Update")
	zclib.Timer.Create("zgo2.Contracts.Update",1, 0, function()

		if not zgo2.config.Marketplace.Contracts.Enabled then
			zclib.Timer.Remove("zgo2.Contracts.Update")
			return
		end

		for k, v in pairs(zgo2.Contracts.List) do
			if v and CurTime() >= (v.start + v.time) then
				zgo2.Contracts.Remove(k)
			end
		end

		if CurTime() > (LastAdded + zgo2.config.Marketplace.Contracts.Interval) and table.Count(zgo2.Contracts.List) < zgo2.config.Marketplace.Contracts.Limit then
			LastAdded = CurTime()
			zgo2.Contracts.AddRandom()
		end
	end)

	/*
		Called from the client to OptIn / OptOut of the contract
	*/
	util.AddNetworkString("zgo2.Contracts.Request")
	net.Receive("zgo2.Contracts.Request", function(len,ply)
	    zclib.Debug_Net("zgo2.Contracts.Request", len)
	    if zclib.Player.Timeout(nil,ply) == true then return end

		local ContractID = net.ReadUInt(32)

		if not ContractID then return end

		local ContractData = zgo2.Contracts.List[ContractID]
		if not ContractData then return end

		if zgo2.Contracts.List[ContractID].Players == nil then zgo2.Contracts.List[ContractID].Players = {} end

		if not zgo2.Contracts.CanAccept(ContractID,ply) then return end

		local steamID64 = ply:SteamID64()

		// Does the player already have signed this contract?
		if zgo2.Contracts.List[ContractID].Players[steamID64] then return end

		// Make the player pay first the signing fee
		local SigningFee = (zgo2.Contracts.GetEarnings(ContractID,ply) / 100) * zgo2.config.Marketplace.Contracts.SigningFee

		if not zclib.Money.Has(ply,SigningFee) then
			zclib.PanelNotify.Create(ply,zgo2.language[ "NotEnoughMoney" ], 1)
			return
		end

		zclib.Money.Take(ply, SigningFee)
		zclib.PanelNotify.Create(ply,"-" .. zclib.Money.Display(SigningFee), 0)

		zgo2.Contracts.List[ContractID].Players[steamID64] = true

		local Result = zgo2.Contracts.List[ContractID].Players[steamID64] == true

		// Confirmation
		net.Start("zgo2.Contracts.Request")
		net.WriteUInt(ContractID,32)
		net.WriteBool(Result)
		net.Send(ply)
	end)
else

	net.Receive("zgo2.Contracts.Update", function(len,ply)
	    zclib.Debug_Net("zgo2.Contracts.Update", len)
		local dataLength = net.ReadUInt(16)
	    local dataDecompressed = util.Decompress(net.ReadData(dataLength))
	    local list = util.JSONToTable(dataDecompressed)
		zgo2.Contracts.List = list or {}
	end)

	net.Receive("zgo2.Contracts.Added", function(len,ply)
	    zclib.Debug_Net("zgo2.Contracts.Added", len)

		local id = net.ReadUInt(10)
		local dataLength = net.ReadUInt(16)
	    local dataDecompressed = util.Decompress(net.ReadData(dataLength))
	    local data = util.JSONToTable(dataDecompressed)

		zgo2.Contracts.List[id] = data

		hook.Run("zgo2.Contracts.OnAdded",data.market,data,id)
	end)

	net.Receive("zgo2.Contracts.Removed", function(len,ply)
	    zclib.Debug_Net("zgo2.Contracts.Removed", len)

		local id = net.ReadUInt(10)
		local data = zgo2.Contracts.List[id]

		if data then hook.Run("zgo2.Contracts.OnRemoved",data.market,data,id) end

		zgo2.Contracts.List[id] = nil
	end)

	function zgo2.Contracts.Request(contract_id)
		net.Start("zgo2.Contracts.Request")
		net.WriteUInt(contract_id,32)
		net.SendToServer()
	end

	net.Receive("zgo2.Contracts.Request", function(len, ply)
		local ContractID = net.ReadUInt(32)
		local result = net.ReadBool()

		if zgo2.Contracts.List[ ContractID ].Players == nil then
			zgo2.Contracts.List[ ContractID ].Players = {}
		end

		zgo2.Contracts.List[ ContractID ].Players[ LocalPlayer():SteamID64() ] = result
	end)
end

/*
	Returns how much money the player would be getting
*/
function zgo2.Contracts.GetEarnings(contract_id,ply)

	local ContractData = zgo2.Contracts.List[contract_id]
	if not ContractData then return 0 end

	local CargoConfig = zgo2.Cargo.Get(ContractData.cargo[ 1 ])
	if not CargoConfig then return 0 end

	local RequestedCargo = ContractData.cargo

	local RequieredAmount = CargoConfig.GetAmount(RequestedCargo)

	local cargo_data = RequestedCargo
	local cargo_sellvalue = CargoConfig.GetSellValue(cargo_data)

	local BuyRate = (1 / 100) * (100 + ContractData.profit)

	local cargo_value = cargo_sellvalue * RequieredAmount * BuyRate

	return cargo_value
end

/*
	Returns if the player is allowed to take on this contract
*/
function zgo2.Contracts.CanAccept(contract_id,ply)

	local ContractData = zgo2.Contracts.List[contract_id]
	if not ContractData then return false end

	local CargoConfig = zgo2.Cargo.Get(ContractData.cargo[ 1 ])
	if not CargoConfig then return false end

	// Is the player even allowed to sell this cargo?
	if not zgo2.Cargo.CanSell(ContractData.cargo,ply) then return false end

	// Is the player even allowed todo this contract?
	if CargoConfig.ContractCheck and not CargoConfig.ContractCheck(contract_id,ContractData,ContractData.cargo,ply) then return false end

	return true
end

/*
	Get all the active contracts for the specified marketplace id
*/
function zgo2.Contracts.GetAll(ply,MarketID)
	local list = {}
	for k, v in pairs(zgo2.Contracts.List) do

		if v.market ~= MarketID then continue end

		if not zgo2.Contracts.CanAccept(k,ply) then continue end

		list[ k ] = v
	end
	return list
end
