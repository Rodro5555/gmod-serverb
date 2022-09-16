zgo2 = zgo2 or {}
zgo2.Generator = zgo2.Generator or {}
zgo2.Generator.List = zgo2.Generator.List or {}

/*

	Generators provide power and refill over time

*/



/*
	Get the UniqueID
*/
function zgo2.Generator.GetID(ListID)
    return zgo2.Generator.GetData(ListID).uniqueid
end

/*
	Get the list id
*/
function zgo2.Generator.GetListID(UniqueID)
    return zgo2.config.Generators_ListID[UniqueID] or 0
end

/*
	Get the Generator config data
*/
function zgo2.Generator.GetData(UniqueID)
    if UniqueID == nil then return end

    // If its a list id then lets return its data
    if zgo2.config.Generators[UniqueID] then return zgo2.config.Generators[UniqueID] end

    // If its a uniqueid then lets get its list id and return the data
    local id = zgo2.Generator.GetListID(UniqueID)
    if UniqueID and id and zgo2.config.Generators[id] then
        return zgo2.config.Generators[id]
    end
end

/*
	Returns if the generator can be connected to this entity
*/
function zgo2.Generator.CanConnect(Generator,ent)
	if not IsValid(ent) then return false end
	if ent:GetClass() == "zgo2_lamp" then return true end
	if ent:GetClass() == "zgo2_pump" then return true end
	if ent:GetClass() == "zgo2_clipper" and ent:GetHasMotor() then return true end
	return false
end

/*
	Returns how much fuel the generator can hold
*/
function zgo2.Generator.GetFuelCapacity(Generator)
	local dat = zgo2.Generator.GetData(Generator:GetGeneratorID())
	return dat.Capacity or 2000
end

/*
	Returns how much power the generator produces per second
*/
function zgo2.Generator.GetPowerRate(Generator)
	local dat = zgo2.Generator.GetData(Generator:GetGeneratorID())
	return dat.PowerRate or 2000
end

/*
	Returns how much energy is currently needed from the ConnectedEntities
*/
function zgo2.Generator.GetPowerNeed(Generator)
	local val = 0
	if Generator.ConnectedEntities then
		for ent,_ in pairs(Generator.ConnectedEntities) do
			if not IsValid(ent) then continue end
			val = val + ent:GetPowerNeed()
		end
	end
	return val
end

/*
	Returns if the generator is full of fuel
*/
function zgo2.Generator.FuelLimitReached(Generator)
	return Generator:GetFuel() >= zgo2.Generator.GetFuelCapacity(Generator)
end

function zgo2.Generator.GetName(UniqueID)
	local dat = zgo2.Generator.GetData(UniqueID)
	if not dat then return "Unkown" end
	return dat.name
end
