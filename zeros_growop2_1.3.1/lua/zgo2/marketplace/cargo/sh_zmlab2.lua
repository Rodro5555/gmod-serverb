
/*
	Adds support for selling meth
*/
if not zmlab2 then return end

zgo2.Cargo.Add("zmlab2_item_crate", {

	// Does this cargo get reduced when transported
	HasSpillage = true,

	// Get the data we will use for the export from the entity
	// NOTE Once valid data got returned the entity will be removed
	GetData = function(ent)
		local id = ent:GetMethType()
		if id <= 0 then return end

		return { "zmlab2_item_crate", id, ent:GetMethAmount(), ent:GetMethQuality() }
	end,

	// Returns all possible variations of this cargo type
	GetAll = function()
		local list = {}
		for k,v in pairs(zmlab2.config.MethTypes) do table.insert(list,{"zmlab2_item_crate",k,1000,100}) end
		return list
	end,

	// Can we merge this cargo with another cargo
	CanMerge = function(data01, data02)
		return data01[ 1 ] == data02[ 1 ] and data01[ 2 ] == data02[ 2 ]
	end,

	// Merge the cargo
	Merge = function(data01, data02)
		local NewAmount = data01[ 3 ] + data02[ 3 ]
		local NewQuality = (data01[ 4 ] + data02[ 4 ]) / 2
		return { "zmlab2_item_crate", data01[ 2 ], NewAmount, NewQuality }
	end,

	// Get the display data which will be used for the Snapshoter system to generate a Thumbnail
	GetThumbnailData = function(cargo_data)
		if not cargo_data then return end

		return {
			class = "zmlab2_item_crate",
			model = "models/zerochain/props_methlab/zmlab2_crate.mdl",
			extraData = {
				meth_type = cargo_data[ 2 ],
				meth_amount = cargo_data[ 3 ],
				meth_qual = cargo_data[ 4 ],
			}
		}
	end,

	// Whats the name of the cargo
	GetName = function(cargo_data)
		return zmlab2.Meth.GetName(cargo_data[ 2 ])
	end,

	// Returns the name and any other info we want to display about the cargo
	GetFullName = function(cargo_data)
		return zmlab2.Meth.GetName(cargo_data[ 2 ]) .. " " .. cargo_data[ 4 ] .. "%"
	end,

	// Sets the amount of the cargo
	SetAmount = function(cargo_data, val)
		cargo_data[ 3 ] = val
	end,

	// How much cargo amount do we have
	GetAmount = function(cargo_data)
		return cargo_data[ 3 ]
	end,

	// Display the cargo amount nice
	DisplayAmount = function(val)
		return val .. zmlab2.config.UoM
	end,

	// Whats the default sell value of this cargo
	GetSellValue = function(cargo_data)
		return zmlab2.Meth.GetValue(cargo_data[ 2 ], 1, cargo_data[ 4 ])
	end,

	// How much does it cost to ship 1 unit of this cargo
	GetShippingCost = function(cargo_data)
		return 0.7
	end,

	// Gets called before the cargo is saved on the server and lets you modify it
	PreSave = function(cargo_data)
		return { "zmlab2_item_crate", cargo_data[ 2 ], cargo_data[ 3 ], cargo_data[ 4 ] }
	end,

	// Called after the cargo_data has been loaded from the savefile
	PostLoad = function(cargo_data)
		return cargo_data
	end,

	// Mostly used by the contract system to get a random data set of this cargo for a contract
	GetRandom = function()
		return { "zmlab2_item_crate", math.random(#zmlab2.config.MethTypes), math.random(10) * 1000 }
	end,

	// Can be used to restrict who is allowed to sell this cargo type
	CanSell = function(cargo_data,ply)
		return zmlab2.config.Jobs[ zclib.Player.GetJob(ply) ] == true
	end,

	// Can be used to restrict who is allowed todo this type of cargo contract
	// NOTE If the player cant sell the cargo then this check wont even be called.
	ContractCheck = function(contract_id, contract_data, cargo_data, ply)
		return zmlab2.config.Jobs[ zclib.Player.GetJob(ply) ] == true
	end
})

hook.Add("zgo2_CargoPickUp_Overwrite","zgo2_CargoPickUp_Overwrite_zmlab2",function(ent,ply,ExportCargo)

	if ent:GetClass() == "zmlab2_item_palette" then

		local CargoConfig = zgo2.Cargo.Get("zmlab2_item_crate")

		local AddedCargo = false

		for _,data in pairs(ent.MethList) do

			local CargoData = {"zmlab2_item_crate",data.t,data.a,data.q}

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

/*
	Bellow we setup some things up to make the meth crate render correct
*/

zclib.CacheModel("models/zerochain/props_methlab/zmlab2_crate.mdl")

zclib.Snapshoter.SetPath("zmlab2_item_crate", function(ItemData)
	if ItemData.extraData.meth_amount > 0 then
		return "zmlab2/crate/crate_" .. math.Round(ItemData.extraData.meth_type) .. "_" .. math.Clamp(5 - math.Round((5 / zmlab2.config.Crate.Capacity) * ItemData.extraData.meth_amount), 1, 5) .. "_" .. math.Round((3 / 100) * ItemData.extraData.meth_qual)
	end
end)

hook.Add("zclib_RenderProductImage", "zclib_RenderProductImage_ZerosMethlab2", function(cEnt, ItemData)
	if zmlab2 and ItemData.class == "zmlab2_item_crate" and ItemData.extraData and ItemData.extraData.meth_amount > 0 then
		local MethMat = zmlab2.Meth.GetMaterial(ItemData.extraData.meth_type, ItemData.extraData.meth_qual)

		if MethMat then
			cEnt:SetSubMaterial(0, "!" .. MethMat)
		end

		local cur_amount = ItemData.extraData.meth_amount
		local bg = math.Clamp(5 - math.Round((5 / zmlab2.config.Crate.Capacity) * cur_amount), 1, 5)
		cEnt:SetBodygroup(0, bg)
	end
end)
