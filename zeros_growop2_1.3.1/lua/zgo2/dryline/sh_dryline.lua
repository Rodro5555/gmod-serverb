zgo2 = zgo2 or {}
zgo2.Dryline = zgo2.Dryline or {}

/*

	Drylines are used to dry weed, they are 2 anker points connected by a rope / line

*/

/*
	How many branches can fit on that rope
*/
function zgo2.Dryline.GetBranchLimit(Dryline)
	if Dryline.BranchLimit == nil then
		Dryline.BranchLimit = math.Clamp(math.Round(Dryline:GetPos():Distance(Dryline:GetEndPoint()) / 15),2,zgo2.config.Dryline.BranchLimit)
	end
	return Dryline.BranchLimit
end

/*
	How much does this rope cost
*/
function zgo2.Dryline.GetCost(startPos,endPos)
	return math.Round((startPos:Distance(endPos) / 10) * zgo2.config.Dryline.CostPerUnit)
end

/*
	Returns how long it takes for this weedbranch spot to dry
*/
function zgo2.Dryline.GetTime(Dryline,spot)
	if not Dryline.WeedBranches[spot] then return 0 end

	local drytime = zgo2.config.Dryline.DryTime

	// TODO Modify drytime later when a fan is pointed at this spot

	return drytime
end

/*
	Returns if the weedbranch is done drying
*/
function zgo2.Dryline.IsDried(Dryline,spot)
	if not Dryline.WeedBranches[spot] then return false end
	return CurTime() > (Dryline.WeedBranches[spot].time + zgo2.Dryline.GetTime(Dryline,spot))
end
