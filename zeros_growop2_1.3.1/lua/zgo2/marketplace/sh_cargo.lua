zgo2 = zgo2 or {}
zgo2.Cargo = zgo2.Cargo or {}
zgo2.Cargo.List = zgo2.Cargo.List or {}

/*

	To make the marketplace more usable im gonna add a config for what kind of stuff can be added as cargo.
	By default its just the weed but we maybe wonna smuggle / sell something else.

*/

function zgo2.Cargo.Add(class,data)
	zgo2.Cargo.List[class] = data
end

function zgo2.Cargo.Get(class)
	return zgo2.Cargo.List[class]
end

// Returns if the player can sell this cargo
function zgo2.Cargo.CanSell(data,ply)
	local Config = zgo2.Cargo.Get(data[1])
	return Config.CanSell(data,ply)
end

// Returns a list of all the cargo ids the player is allowed to sell
function zgo2.Cargo.GetAllowed(ply)

	local AllowedList = {}

	// Go through all the diffrent cargo types
	for cargo_type,cargo_config in pairs(zgo2.Cargo.List) do

		// Go through all the different cargo type variations
		for _,cargo_data in pairs(cargo_config.GetAll()) do

			// Is the player allowed to sell this cargo type?
			if cargo_config.CanSell(cargo_data,ply) then
				table.insert(AllowedList,cargo_data)
			end
		end
	end

	return AllowedList
end

/*
zgo2.Cargo.Add("prop_vehicle_jeep",{
	HasSpillage = false,
	GetData = function(ent) return {"prop_vehicle_jeep",1} end,
	CanMerge = function(data01,data02) return data01[1] == data02[1] end,
	Merge = function(data01,data02) return {"prop_vehicle_jeep",data01[2] + data02[2]} end,
	GetThumbnailData = function(cargo_data) return { class = "prop_vehicle_jeep", model = "models/buggy.mdl"} end,
	GetName = function(cargo_data) return "Jeep" end,
	SetAmount = function(cargo_data,val) cargo_data[2] = val end,
	GetAmount = function(cargo_data) return cargo_data[2] end,
	DisplayAmount = function(val) return val .. "x" end,
	GetSellValue = function(cargo_data) return 2000 end,
	GetShippingCost = function(cargo_data) return 400 end,
	GetRandom = function() return {"prop_vehicle_jeep",math.random(10)} end,
})
*/
