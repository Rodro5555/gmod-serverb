zgo2 = zgo2 or {}
zgo2.Edible = zgo2.Edible or {}
zgo2.Edible.List = zgo2.Edible.List or {}

/*

	Edibles can be consumed by players and could make them high

*/



/*
	Get the UniqueID
*/
function zgo2.Edible.GetID(ListID)
    return zgo2.Edible.GetData(ListID).uniqueid
end

/*
	Get the list id
*/
function zgo2.Edible.GetListID(UniqueID)
    return zgo2.config.Edibles_ListID[UniqueID] or 0
end

/*
	Get the Edible config data
*/
function zgo2.Edible.GetData(UniqueID)
    if UniqueID == nil then return end

    // If its a list id then lets return its data
    if zgo2.config.Edibles[UniqueID] then return zgo2.config.Edibles[UniqueID] end

    // If its a uniqueid then lets get its list id and return the data
    local id = zgo2.Edible.GetListID(UniqueID)
    if UniqueID and id and zgo2.config.Edibles[id] then
        return zgo2.config.Edibles[id]
    end
end

/*
	Returns the name of the edible
*/
function zgo2.Edible.GetName(UniqueID)
	local dat = zgo2.Edible.GetData(UniqueID)
	if not dat then return "Unkown" end
	return dat.name
end

function zgo2.Edible.GetWeedCapacity(UniqueID)
	local dat = zgo2.Edible.GetData(UniqueID)
	if not dat then return 15 end
	return dat.weed_capacity
end

function zgo2.Edible.GetMixDuration(UniqueID)
	local dat = zgo2.Edible.GetData(UniqueID)
	if not dat then return 25 end
	return dat.mix_duration
end

function zgo2.Edible.GetBakeDuration(UniqueID)
	local dat = zgo2.Edible.GetData(UniqueID)
	if not dat then return 45 end
	return dat.bake_duration
end
