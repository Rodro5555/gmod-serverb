zgo2 = zgo2 or {}
zgo2.Bong = zgo2.Bong or {}

/*

	Bongs are used to smoke da weed

*/

zgo2.Bong.Types = {}
local function AddBongType(data)
	zclib.CacheModel(data.vm)
	table.insert(zgo2.Bong.Types,data)
end
AddBongType({
	wm = "models/zerochain/props_growop2/zgo2_bong01_wm.mdl",
	vm = "models/zerochain/props_growop2/zgo2_bong01_vm.mdl",
	uv = Material("materials/zerochain/zgo2/bong/bong01_uv.png", "noclamp smooth"),
	id = 1,
	diff = Material("zerochain/props_growop2/bong01/zgo2_bong01_diff.png","ignorez smooth"),
	nrm = "zerochain/props_growop2/bong01/zgo2_bong01_nrm",
})

AddBongType({
	wm = "models/zerochain/props_growop2/zgo2_bong02_wm.mdl",
	vm = "models/zerochain/props_growop2/zgo2_bong02_vm.mdl",
	uv = Material("materials/zerochain/zgo2/bong/bong02_uv.png", "noclamp smooth"),
	id = 1,
	diff = Material("zerochain/props_growop2/bong02/zgo2_bong02_diff.png","ignorez smooth"),
	nrm = "zerochain/props_growop2/bong02/zgo2_bong02_nrm",
})

AddBongType({
	wm = "models/zerochain/props_growop2/zgo2_bong03_wm.mdl",
	vm = "models/zerochain/props_growop2/zgo2_bong03_vm.mdl",
	uv = Material("materials/zerochain/zgo2/bong/bong03_uv.png", "noclamp smooth"),
	id = 1,
	diff = Material("zerochain/props_growop2/bong03/zgo2_bong03_diff.png","ignorez smooth"),
	nrm = "zerochain/props_growop2/bong03/zgo2_bong03_nrm",
})

/*
	Get the Bong type data
*/
function zgo2.Bong.GetTypeData(UniqueID)
	local dat = zgo2.Bong.GetData(UniqueID)
	return zgo2.Bong.Types[dat.type]
end

/*
	Get the UniqueID
*/
function zgo2.Bong.GetID(ListID)
    return zgo2.Bong.GetData(ListID).uniqueid
end

/*
	Get the list id
*/
function zgo2.Bong.GetListID(UniqueID)
    return zgo2.config.Bongs_ListID[UniqueID] or 0
end

/*
	Get the Bong config data
*/
function zgo2.Bong.GetData(UniqueID)
    if UniqueID == nil then return end

    // If its a list id then lets return its data
    if zgo2.config.Bongs[UniqueID] then return zgo2.config.Bongs[UniqueID] end

    // If its a uniqueid then lets get its list id and return the data
    local id = zgo2.Bong.GetListID(UniqueID)
    if UniqueID and id and zgo2.config.Bongs[id] then
        return zgo2.config.Bongs[id]
    end
end

/*
	Returns the bongs name
*/
function zgo2.Bong.GetName(UniqueID)
    local dat = zgo2.Bong.GetData(UniqueID)
	if not dat then return "Unknown" end
	return dat.name or "Unknown"
end

/*
	Modify the provided Bong data so its not missing any config value
*/
function zgo2.Bong.VerifyData(Data)
	local BongData = table.Copy(Data)

	BongData.type = BongData.type or 1
	BongData.name = BongData.name or "Bong"
	BongData.price = BongData.price or 1000
	BongData.capacity = BongData.capacity or 25

	BongData.ranks = BongData.ranks or {}
	BongData.jobs = BongData.jobs or {}

	BongData.style = BongData.style or {}
	BongData.style.color = BongData.style.color or color_white
	BongData.style.blendmode = BongData.style.blendmode or 0
	BongData.style.url = BongData.style.url or ""
	BongData.style.scale = BongData.style.scale or 1
	BongData.style.img_color = BongData.style.img_color or color_white
	BongData.style.pos_x = BongData.style.pos_x or 0
	BongData.style.pos_y = BongData.style.pos_y or 0

	BongData.style.phongexponent = BongData.style.phongexponent or 15
	BongData.style.phongboost = BongData.style.phongboost or 0.5
	BongData.style.phongtint = BongData.style.phongtint or color_white
	BongData.style.fresnel = BongData.style.fresnel or 1

	return BongData
end

/*
	Randomizes the Bong values of the provided data
*/
function zgo2.Bong.RandomizeData(BongData)

	BongData.style.url = imgid
	BongData.style.scale = math.Rand(0.1,1.5)
	BongData.style.color = ColorRand(false)
	BongData.style.alpha = math.Rand(0.1,1)

	return BongData
end


//////////////////////////////////////////

file.CreateDir( "zgo2" )
local function LoadBongData(data)

	zgo2.Print("Loaded Bong Skins")

	// Convert any job command to job ids before loading
	data = zgo2.util.ConvertJobCommandToJobID(data)

	zgo2.config.Bongs = table.Copy(data)

	// Verify the data
	for k,v in pairs(zgo2.config.Bongs) do zgo2.config.Bongs[k] = zgo2.Bong.VerifyData(v) end

	// Rebuild its materials
	if CLIENT then
		// NOTE This is so important, we need to delay the rebuild action
		timer.Simple(1,function()
			for k, v in pairs(zgo2.config.Bongs) do
				// Predownload the imgur images
				zclib.Imgur.GetMaterial(tostring(v.style.url), function(result)
					zgo2.Bong.RebuildMaterial(v)
				end)
			end
		end)
	end
end

timer.Simple(0, function()
	zclib.Data.Setup("zgo2_bong_config", "[Zero´s GrowOP - 2]", "zgo2/config_bong.txt", function() return zgo2.config.Bongs end, function(data)
		// OnLoaded

		LoadBongData(data)
	end, function()
		// OnSend
	end, function(data)
		// OnReceived
		LoadBongData(data)
	end, function(list)
		//OnIDListRebuild
		zgo2.config.Bongs_ListID = table.Copy(list)
	end,function(data)
		// OnPreSave

		// Convert any job id to its job command before saving
		data = zgo2.util.ConvertJobIDToCommand(data)

		return data
	end)
end)

if SERVER then
	concommand.Add("zgo2_bong_factory_reset", function(ply, cmd, args)
		if zclib.Player.IsAdmin(ply) then

			zgo2.util.ConfirmAction(ply,function()

				// Remove the config data
				zclib.Data.Remove(ply,"zgo2_bong_config")

				// Reload default config
				include("sh_zgo2_config_bong.lua")

				// Send the file to all clients
				zclib.Data.UpdateConfig("zgo2_bong_config")

				zclib.Notify(ply, "Bong config reset, restart server to have full effect.", 0)

				// Tell all clients to remove their thumbnails
				zclib.Snapshoter.Delete("zgo2")
			end)
		end
	end)
end
