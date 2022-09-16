zgo2 = zgo2 or {}
zgo2.config = zgo2.config or {}
zgo2.config.Racks = {}
zgo2.config.Racks_ListID = zgo2.config.Racks_ListID or {}

local function AddRack(data)
	local PlantID = table.insert(zgo2.config.Racks,data)
	zgo2.config.Racks_ListID[data.uniqueid] = PlantID
	return PlantID
end

AddRack({
	uniqueid = "fasdgalkj343",
	class = "zgo2_rack",
	name = zgo2.language[ "Rack" ],
	mdl = "models/zerochain/props_growop2/zgo2_rack01.mdl",
	price = 1000,
	jobs = zgo2.config.Jobs.Pro,
	PotPositions = {
		[ 1 ] = { Vector(30, 0, 12), Angle(0, -90, 0) },
		[ 2 ] = { Vector(-30, 0, 12), Angle(0, -90, 0) }
	}
})

AddRack({
	uniqueid = "fsk48ffsf588",
	class = "zgo2_rack",
	name = zgo2.language[ "Rack" ],
	mdl = "models/zerochain/props_growop2/zgo2_rack.mdl",
	price = 2000,
	jobs = zgo2.config.Jobs.Pro,
	PotPositions = {
		[ 1 ] = { Vector(30, 30, 12), Angle(0, -90, 0) },
		[ 2 ] = { Vector(-30, 30, 12), Angle(0, -90, 0) },
		[ 3 ] = { Vector(30, 0, 41), Angle(0, -90, 0) },
		[ 4 ] = { Vector(-30, 0, 41), Angle(0, -90, 0) },
	}
})
