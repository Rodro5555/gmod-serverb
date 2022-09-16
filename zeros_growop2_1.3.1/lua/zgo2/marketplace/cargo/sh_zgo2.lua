
/*
	Adds the weedblock entity as cargo
*/

zgo2.Cargo.Add("zgo2_weedblock",{

	// Does this cargo get reduced when transported
	HasSpillage = true,

	// Get the data we will use for the export from the entity
	// NOTE Once valid data got returned the entity will be removed
	GetData = function(ent)
		local id = ent:GetWeedID()
		if id <= 0 then return end
		return {"zgo2_weedblock",ent:GetWeedID(),zgo2.config.Packer.Capacity}
	end,

	// Returns all possible variations of this cargo type
	GetAll = function()
		local list = {}
		for k,v in pairs(zgo2.Plant.GetAll()) do table.insert(list,{"zgo2_weedblock",k,1000}) end
		return list
	end,

	// Can we merge this cargo with another cargo
	CanMerge = function(data01,data02)
		return data01[1] == data02[1] and data01[2] == data02[2]
	end,

	// Merge the cargo
	Merge = function(data01,data02)
		return {"zgo2_weedblock",data01[2],data01[3] + data02[3]}
	end,

	// Get the display data which will be used for the Snapshoter system to generate a Thumbnail
	GetThumbnailData = function(cargo_data)
		if not cargo_data then return end
		local WeedData = zgo2.Plant.GetData(cargo_data[2])
		if not WeedData then return end
		return {
			class = "zgo2_weedblock",
			model = "models/zerochain/props_growop2/zgo2_weedblock.mdl",
			PlantID = WeedData.uniqueid,
		}
	end,

	// Can be used instead of the model image
	//GetIcon = Material("path/to/file.png","smooth"),

	// Whats the name of the cargo
	GetName = function(cargo_data)
		return zgo2.Plant.GetName(cargo_data[2])
	end,

	// Returns the name and any other info we want to display about the cargo
	GetFullName = function(cargo_data)
		return zgo2.Plant.GetName(cargo_data[2])
	end,

	// Sets the amount of the cargo
	SetAmount = function(cargo_data,val)
		cargo_data[3] = val
	end,

	// How much cargo amount do we have
	GetAmount = function(cargo_data)
		return cargo_data[3]
	end,

	// Display the cargo amount nice
	DisplayAmount = function(val)
		return val .. zgo2.config.UoM
	end,

	// Whats the default sell value of this cargo
	GetSellValue = function(cargo_data)
		return zgo2.Plant.GetSellValue(cargo_data[2])
	end,

	// How much does it cost to ship 1 unit of this cargo
	GetShippingCost = function(cargo_data)
		return 0.5
	end,

	// Gets called before the cargo is saved on the server and lets you modify it
	PreSave = function(cargo_data)
		// Convert the weed id to its uniqueid before saving
		return { "zgo2_weedblock",zgo2.Plant.GetID(cargo_data[2]),cargo_data[3] }
	end,

	// Called after the cargo_data has been loaded from the savefile
	PostLoad = function(cargo_data)
		local listid = zgo2.Plant.GetListID(cargo_data[2])

		// If the list id does not exist anymore then lets remove the cargo be returnings nothing
		if not listid then return nil end

		// Convert the weed id back to its list id
		return { "zgo2_weedblock", listid ,cargo_data[3] }
	end,

	// Mostly used by the contract system to get a random data set of this cargo for a contract
	GetRandom = function()
		return {"zgo2_weedblock",zgo2.Plant.GetRandomID(),math.random(10) * 1000}
	end,

	// Can be used to restrict who is allowed to sell this cargo type
	CanSell = function(cargo_data,ply)
		return zgo2.Player.IsWeedGrower(ply)
	end,

	// Can be used to restrict who is allowed todo this type of cargo contract
	// NOTE If the player cant sell the cargo then this check wont even be called.
	ContractCheck = function(contract_id,contract_data,cargo_data,ply)

		// Quick examble on how any weed contract worth more then 50000 can only be done by superadmins
		/*
			local Earnings = zgo2.Contracts.GetEarnings(contract_id,ply)
			if Earnings > 50000 and not ply:IsSuperAdmin() then return false end
		*/

		// In this examble only the ranks who can grow the weed can also accept contracts for it
		/*
			local WeedData = zgo2.Plant.GetData(cargo_data[2])
			if WeedData and WeedData.ranks and table.Count(WeedData.ranks) > 0 and not zclib.Player.RankCheck(ply, WeedData.ranks) then return false end
		*/

		return true
	end,
})

/*
zgo2.Cargo.Add("zgo2_jar", {
	HasSpillage = true,
	GetAll = function()
		local list = {}
		for k,v in pairs(zgo2.Plant.GetAll()) do table.insert(list,{"zgo2_jar",k,1000}) end
		return list
	end,
	GetData = function(ent)
		local id = ent:GetWeedID()
		if id <= 0 then return end

		return { "zgo2_jar", ent:GetWeedID(), ent:GetWeedAmount() }
	end,
	CanMerge = function(data01, data02) return data01[ 1 ] == data02[ 1 ] and data01[ 2 ] == data02[ 2 ] end,
	Merge = function(data01, data02)
		return { "zgo2_jar", data01[ 2 ], data01[ 3 ] + data02[ 3 ] }
	end,
	GetThumbnailData = function(cargo_data)
		if not cargo_data then return end
		local WeedData = zgo2.Plant.GetData(cargo_data[ 2 ])
		if not WeedData then return end

		return {
			class = "zgo2_jar",
			model = "models/zerochain/props_growop2/zgo2_jar.mdl",
			PlantID = WeedData.uniqueid,
		}
	end,
	GetName = function(cargo_data) return zgo2.Plant.GetName(cargo_data[ 2 ]) end,
	SetAmount = function(cargo_data, val)
		cargo_data[ 3 ] = val
	end,
	GetAmount = function(cargo_data) return cargo_data[ 3 ] end,
	DisplayAmount = function(val) return val .. zgo2.config.UoM end,
	GetSellValue = function(cargo_data) return zgo2.Plant.GetSellValue(cargo_data[ 2 ]) end,
	GetShippingCost = function(cargo_data) return 0.1 end,
	PreSave = function(cargo_data)return { "zgo2_jar", zgo2.Plant.GetID(cargo_data[ 2 ]), cargo_data[ 3 ] }
	end,
	PostLoad = function(cargo_data)
		local listid = zgo2.Plant.GetListID(cargo_data[ 2 ])
		if not listid then return nil end
		return { "zgo2_jar", listid, cargo_data[ 3 ] }
	end,
	GetRandom = function()
		return { "zgo2_jar", zgo2.Plant.GetRandomID(), math.random(10) * 1000 }
	end,
	CanSell = function(cargo_data,ply)
		return true
	end,
	ContractCheck = function(contract_id, contract_data, cargo_data, ply) return true end,
})
*/

hook.Add("zgo2_CargoPickUp_Overwrite","zgo2_CargoPickUp_Overwrite_zgo2",function(ent,ply,ExportCargo)

	if ent:GetClass() == "zgo2_palette" then

		local CargoConfig = zgo2.Cargo.Get("zgo2_weedblock")

		local AddedCargo = false

		for _,weed_id in pairs(ent.WeedList) do

			local CargoData = {"zgo2_weedblock",weed_id,zgo2.config.Packer.Capacity}

			if not zgo2.Cargo.CanSell(CargoData,ply) then continue end

			// Lets try to merge the data in to a existing cargo that matches according to the can merge function
			for id,dat in pairs(ExportCargo) do
				if CargoConfig.CanMerge(dat,CargoData) then
					ExportCargo[id] = CargoConfig.Merge(dat,CargoData)
					CargoData = nil
					AddedCargo = true
					break
				end
			end
			// Stop if we could successfully find and merge the data
			if not CargoData then continue end

			// Create new cargo data
			table.insert(ExportCargo,CargoData)
			AddedCargo = true
		end

		// Remove the palette
		if AddedCargo then ent:Remove() end

		return ExportCargo
	end
end)
