zgo2 = zgo2 or {}
zgo2.Player = zgo2.Player or {}

/*
	Checks if the player is a weed grower
*/
function zgo2.Player.IsWeedGrower(ply)
	local job = zclib.Player.GetJob(ply)
	local CorrectJob = true

	if (zgo2.config.Jobs.Pro and table.Count(zgo2.config.Jobs.Pro) > 0 and zgo2.config.Jobs.Pro[ job ] ~= true) and (zgo2.config.Jobs.Basic and table.Count(zgo2.config.Jobs.Basic) > 0 and zgo2.config.Jobs.Basic[ job ] ~= true) and (zgo2.config.Jobs.Amateur and table.Count(zgo2.config.Jobs.Amateur) > 0 and zgo2.config.Jobs.Amateur[ job ] ~= true) then
		CorrectJob = false
	end

	return CorrectJob
end

/*
	Performs a rank and job check for the provided player and data
*/
function zgo2.Player.CanUse(ply,data)
	// Does the player have the correct job to buy this item?
	if data.jobs and table.Count(data.jobs) > 0 and not data.jobs[zclib.Player.GetJob(ply)] then return false , true , false end

	// Does the player have the correct rank to buy this item?
	if data.ranks and table.Count(data.ranks) > 0 and not zclib.Player.RankCheck(ply, data.ranks) then return false , false ,true end
	return true
end
