zgo2 = zgo2 or {}
zgo2.Rack = zgo2.Rack or {}

/*

	Players can place pots on the rack, just so the pots just stand randomly in a room. Idk looks better

*/

/*
	Get the UniqueID
*/
function zgo2.Rack.GetID(ListID)
    return zgo2.Rack.GetData(ListID).uniqueid
end

/*
	Get the list id
*/
function zgo2.Rack.GetListID(UniqueID)
    return zgo2.config.Racks_ListID[UniqueID] or 0
end

/*
	Get the Rack config data
*/
function zgo2.Rack.GetData(UniqueID)
    if UniqueID == nil then return end

    // If its a list id then lets return its data
    if zgo2.config.Racks[UniqueID] then return zgo2.config.Racks[UniqueID] end

    // If its a uniqueid then lets get its list id and return the data
    local id = zgo2.Rack.GetListID(UniqueID)
    if UniqueID and id and zgo2.config.Racks[id] then
        return zgo2.config.Racks[id]
    end
end

/*
	Returns the name
*/
function zgo2.Rack.GetName(UniqueID)
	local dat = zgo2.Rack.GetData(UniqueID)
	if not dat then return "Unkown" end
	return dat.name
end
