zgo2 = zgo2 or {}
zgo2.Logbook = zgo2.Logbook or {}

// This keeps track who allows which player to share his logbook
zgo2.Logbook.Share = zgo2.Logbook.Share or {}

/*
	[SteamID64] = {
		[SteamID64] = true,
		[SteamID64] = true,
		[SteamID64] = true,
		[SteamID64] = true,
	}
*/

/*
	Returns all the player steamdid64 which share their data with you and which you also share your data with
*/
function zgo2.Logbook.GetShared(ply)
	local ply_steamid64 = ply:SteamID64()
	if not zgo2.Logbook.Share[ply_steamid64] then zgo2.Logbook.Share[ply_steamid64] = {} end

	// Get all the players which you share your and they share their data with.
	local SharedPlayers = {}
	for p_sid64,_ in pairs(zgo2.Logbook.Share[ply_steamid64]) do
		if not zgo2.Logbook.Share[p_sid64] then zgo2.Logbook.Share[p_sid64] = {} end

		// Does this player share his data with you?
		if zgo2.Logbook.Share[p_sid64][ply_steamid64] then
			SharedPlayers[p_sid64] = true
		end
	end
	return SharedPlayers
end

if CLIENT then

	/*
		Send a net message to the SERVER and let the SERVER ask the player if he wants to share his logbook data with you
	*/
	function zgo2.Logbook.RequestShare(target)
		net.Start("zgo2.Logbook.RequestShare")
		net.WriteEntity(target)
		net.SendToServer()
	end

	net.Receive("zgo2.Logbook.RequestShare", function(len,ply)

		zgo2.Logbook.Share = {}

		local count = net.ReadUInt(32)
		for i = 1, count do
			zgo2.Logbook.Share[ net.ReadString() ] = true
		end

		zgo2.Logbook.ShareList()
	end)
else

	/*
		Called from the CLIENT to ask another player if he wants to share his logbook data with the caller
	*/
	util.AddNetworkString("zgo2.Logbook.RequestShare")
	net.Receive("zgo2.Logbook.RequestShare", function(len,ply)
	    zclib.Debug_Net("zgo2.Logbook.RequestShare", len)
	    if zclib.Player.Timeout(nil,ply) == true then return end

	    local target = net.ReadEntity()
		if not IsValid(target) then return end
		if not target:IsPlayer() then return end

		if ply == target then return end

		local ply_steamid64 = ply:SteamID64()
		if not ply_steamid64 then return end

		local target_steamid64 = target:SteamID64()
		if not target_steamid64 then return end

		if not zgo2.Logbook.Share[ply_steamid64] then zgo2.Logbook.Share[ply_steamid64] = {} end

		if zgo2.Logbook.Share[ply_steamid64][target_steamid64] then
			zgo2.Logbook.Share[ply_steamid64][target_steamid64] = nil
		else
			zgo2.Logbook.Share[ply_steamid64][target_steamid64] = true
		end

		net.Start("zgo2.Logbook.RequestShare")
		net.WriteUInt(table.Count(zgo2.Logbook.Share[ply_steamid64]),32)
		for k,_ in pairs(zgo2.Logbook.Share[ply_steamid64]) do
			net.WriteString(k)
		end
		net.Send(ply)
	end)

end
