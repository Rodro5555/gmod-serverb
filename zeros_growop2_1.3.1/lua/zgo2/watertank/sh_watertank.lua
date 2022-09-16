zgo2 = zgo2 or {}
zgo2.Watertank = zgo2.Watertank or {}
zgo2.Watertank.List = zgo2.Watertank.List or {}

/*

	Watertanks provide water and refill over time

*/

/*
	Get the UniqueID
*/
function zgo2.Watertank.GetID(ListID)
    return zgo2.Watertank.GetData(ListID).uniqueid
end

/*
	Get the list id
*/
function zgo2.Watertank.GetListID(UniqueID)
    return zgo2.config.Watertanks_ListID[UniqueID] or 0
end

/*
	Get the Watertank config data
*/
function zgo2.Watertank.GetData(UniqueID)
    if UniqueID == nil then return end

    // If its a list id then lets return its data
    if zgo2.config.Watertanks[UniqueID] then return zgo2.config.Watertanks[UniqueID] end

    // If its a uniqueid then lets get its list id and return the data
    local id = zgo2.Watertank.GetListID(UniqueID)
    if UniqueID and id and zgo2.config.Watertanks[id] then
        return zgo2.config.Watertanks[id]
    end
end

/*
	Returns the plant name
*/
function zgo2.Watertank.GetName(UniqueID)
    local dat = zgo2.Watertank.GetData(UniqueID)
	if not dat then return "Unknown" end
	return dat.name or "Unknown"
end

/*
	Returns how much water the Watertank can hold
*/
function zgo2.Watertank.GetCapacity(Watertank)
	local dat = zgo2.Watertank.GetData(Watertank:GetWatertankID())
	return dat.Capacity or 2000
end

/*
	Returns how much power the Watertank produces per second
*/
function zgo2.Watertank.GetRefillRate(Watertank)
	local dat = zgo2.Watertank.GetData(Watertank:GetWatertankID())
	return dat.RefillRate or 3
end

/*
	Returns the position and scale for the UI
*/
function zgo2.Watertank.GetUIPos(Watertank)
	local dat = zgo2.Watertank.GetData(Watertank:GetWatertankID())
	return dat.UIPos or {
		vec = Vector(0,0,0),
		ang = Angle(0,0,0),
		scale = 0.1,
	}
end

/*
	How much water can we use
*/
function zgo2.Watertank.GetUseWater(Watertank)
	return math.Clamp(Watertank:GetWater(),0,zgo2.config.Watertank.UseAmount)
end
