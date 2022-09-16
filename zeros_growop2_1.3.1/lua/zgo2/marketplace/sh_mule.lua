zgo2 = zgo2 or {}
zgo2.Mule = zgo2.Mule or {}

function zgo2.Mule.GetData(MuleID)
	return zgo2.config.Mules[MuleID]
end

function zgo2.Mule.GetCost(MuleID)
	return zgo2.config.Mules[MuleID].cost
end

function zgo2.Mule.CanUse(MuleID,ply)
	local MuleData = zgo2.Mule.GetData(MuleID)
	if not MuleData then return false end

	// Does the player have the correct job to use this mule?
	if MuleData.jobs and table.Count(MuleData.jobs) > 0 and not MuleData.jobs[zclib.Player.GetJob(ply)] then
		zclib.PanelNotify.Create(ply,zgo2.language[ "WrongJob" ], 1)
		zclib.Notify(ply, zclib.table.JobToString(MuleData.jobs), 1)
		return false
	end

	// Does the player have the correct rank to use this mule?
	if MuleData.ranks and table.Count(MuleData.ranks) > 0 and not zclib.Player.RankCheck(ply, MuleData.ranks) then
		zclib.PanelNotify.Create(ply,zgo2.language[ "WrongRank" ], 1)
		zclib.Notify(ply, zclib.table.ToString(MuleData.ranks), 1)
		return false
	end

	return true
end
