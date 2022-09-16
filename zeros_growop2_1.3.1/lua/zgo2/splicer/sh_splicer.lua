zgo2 = zgo2 or {}
zgo2.Splicer = zgo2.Splicer or {}

/*

	Splicers are used to create new weedseeds from existing one

*/

// How many items can fit in to the splicer, this should not be touched which is why i dont add it to the main config
zgo2.Splicer.ItemLimit = 5


/*
	Can we create new plants
*/
function zgo2.Splicer.CanUse(Splicer)
	return table.Count(zgo2.config.Plants) < 390
end

/*
	Can we use the weedbranch at the specified slot for splicing?
*/
function zgo2.Splicer.CanSplice(Splicer,ply,Slot)
	local Data = Splicer.DataSets[Slot]
	if not Data then return true end
	Data = zgo2.Plant.GetData(Data)
	if not Data then return true end
	return zgo2.Player.CanUse(ply,Data)
end

/*
	Returns how much it would cost to splice the current weedplants together
*/
function zgo2.Splicer.GetCost(Splicer)
	local cost = 0

	for k, v in pairs(Splicer.DataSets) do
		local val = (zgo2.Plant.GetTotalMoney(v) / 100) * zgo2.config.Splicer.SplicingCostPerPlant
		cost = cost + val
	end

	return cost
end

/*
	Tells us if the splicer has enough splice data sets to create a new spliced weed config
*/
function zgo2.Splicer.HasEnoughSpliceData(Splicer,ply)
	if not Splicer.DataSets then return false end
	if table.Count(Splicer.DataSets) <= 1 then return end

	local ValidSets = 0
	for slot,WeedID in pairs(Splicer.DataSets) do
		local dat = zgo2.Plant.GetData(WeedID)
		if not dat then continue end

		if zgo2.Player.CanUse(ply,dat) then
			ValidSets = ValidSets + 1
		end
	end
	return ValidSets >= 2
end
