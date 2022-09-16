zgo2 = zgo2 or {}
zgo2.NPC = zgo2.NPC or {}
zgo2.NPC.List = zgo2.NPC.List or {}

/*
	Check if the player is allowed to buy this bong
*/
function zgo2.NPC.CanBuyBong(ply,id)
	local BongData = zgo2.Bong.GetData(id)
	if not BongData then return end

	local CanBuy = true

	// Does the player have the correct job to buy this item?
	if BongData.jobs and table.Count(BongData.jobs) > 0 and not BongData.jobs[zclib.Player.GetJob(ply)] then
		CanBuy = false
	end

	// Does the player have the correct rank to buy this item?
	if BongData.ranks and table.Count(BongData.ranks) > 0 and not zclib.Player.RankCheck(ply, BongData.ranks) then
		CanBuy = false
	end

	return CanBuy
end

/*
	Checks if the players is customer
*/
function zgo2.NPC.IsCustomer(ply)
	local job = zclib.Player.GetJob(ply)
	local CorrectJob = true

	if zgo2.config.NPC.jobs and table.Count(zgo2.config.NPC.jobs) > 0 and zgo2.config.NPC.jobs[ job ] ~= true then
		CorrectJob = false
	end

	return CorrectJob
end
