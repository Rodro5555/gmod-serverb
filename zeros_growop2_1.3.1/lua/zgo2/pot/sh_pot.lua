zgo2 = zgo2 or {}
zgo2.Pot = zgo2.Pot or {}

/*

	Pots are the base to grow the plants in

*/

zgo2.Pot.Types = {}
local function AddPotType(data) table.insert(zgo2.Pot.Types,data) end
AddPotType({
	mdl = "models/zerochain/props_growop2/zgo2_pot01.mdl",
	uv = Material("materials/zerochain/zgo2/pot/pot01_uv.png", "noclamp smooth"),
	diff = Material("zerochain/props_growop2/pots/zgo2_pot01_diff.png", "ignorez smooth"),
	nrm = "zerochain/props_growop2/pots/zgo2_pot01_nrm"
})

AddPotType({
	mdl = "models/zerochain/props_growop2/zgo2_pot02.mdl",
	uv = Material("materials/zerochain/zgo2/pot/pot02_uv.png", "noclamp smooth"),
	diff = Material("zerochain/props_growop2/pots/zgo2_pot02_diff.png", "ignorez smooth"),
	nrm = "zerochain/props_growop2/pots/zgo2_pot02_nrm"
})

AddPotType({
	mdl = "models/zerochain/props_growop2/zgo2_pot03.mdl",
	uv = Material("materials/zerochain/zgo2/pot/pot03_uv.png", "noclamp smooth"),
	diff = Material("zerochain/props_growop2/pots/zgo2_pot03_diff.png", "ignorez smooth"),
	nrm = "zerochain/props_growop2/pots/zgo2_pot03_nrm"
})

AddPotType({
	mdl = "models/zerochain/props_growop2/zgo2_pot04.mdl",
	uv = Material("materials/zerochain/zgo2/pot/pot04_uv.png", "noclamp smooth"),
	diff = Material("zerochain/props_growop2/pots/zgo2_pot04_diff.png", "ignorez smooth"),
	nrm = "zerochain/props_growop2/pots/zgo2_pot04_nrm"
})

AddPotType({
	mdl = "models/zerochain/props_growop2/zgo2_pot05.mdl",
	uv = Material("materials/zerochain/zgo2/pot/pot05_uv.png", "noclamp smooth"),
	diff = Material("zerochain/props_growop2/pots/zgo2_pot05_diff.png", "ignorez smooth"),
	nrm = "zerochain/props_growop2/pots/zgo2_pot05_nrm"
})

AddPotType({
	mdl = "models/zerochain/props_growop2/zgo2_pot06.mdl",
	uv = Material("materials/zerochain/zgo2/pot/pot06_uv.png", "noclamp smooth"),
	diff = Material("zerochain/props_growop2/pots/zgo2_pot06_diff.png", "ignorez smooth"),
	nrm = "zerochain/props_growop2/pots/zgo2_pot06_nrm"
})
/*
	Get the UniqueID
*/
function zgo2.Pot.GetID(ListID)
    return zgo2.Pot.GetData(ListID).uniqueid
end

/*
	Get the list id
*/
function zgo2.Pot.GetListID(UniqueID)
    return zgo2.config.Pots_ListID[UniqueID] or 0
end

/*
	Get the Pot config data
*/
function zgo2.Pot.GetData(UniqueID)
    if UniqueID == nil then return end

    // If its a list id then lets return its data
    if zgo2.config.Pots[UniqueID] then return zgo2.config.Pots[UniqueID] end

    // If its a uniqueid then lets get its list id and return the data
    local id = zgo2.Pot.GetListID(UniqueID)
    if UniqueID and id and zgo2.config.Pots[id] then
        return zgo2.config.Pots[id]
    end
end

/*
	Gets the pots model
*/
function zgo2.Pot.GetModel(UniqueID)
	local dat = zgo2.Pot.GetData(UniqueID)
	return zgo2.Pot.Types[dat.type].mdl
end

/*
	How much water can this pot hold
*/
function zgo2.Pot.GetWaterLimit(Pot)
	local dat = zgo2.Pot.GetData(Pot:GetPotID())
	if not dat then return 1000 end
	return dat.water_capacity
end

/*
	Returns the scale of the pot
*/
function zgo2.Pot.GetScale(Pot)
	local dat = zgo2.Pot.GetData(Pot:GetPotID())
	return dat.scale or 1
end

/*
	Returns the name
*/
function zgo2.Pot.GetName(UniqueID)
	local dat = zgo2.Pot.GetData(UniqueID)
	if not dat then return "Unkown" end
	return dat.name
end

/*
	Returns the scale of the pot
*/
function zgo2.Pot.HasHoseConnection(Pot)
	local dat = zgo2.Pot.GetData(Pot:GetPotID())
	return dat.hose == true
end

/*
	Returns if the pot got placed
*/
function zgo2.Pot.GotPlaced(Pot)
	if not zgo2.config.Pot.RequiereRack then return true end
	if not IsValid(Pot) then return false end
	local par = Pot:GetParent()
	if not IsValid(par) then return false end
	if par:GetClass() ~= "zgo2_tent" and par:GetClass() ~= "zgo2_rack" then return false end
	return true
end

/*
	Modify the provided Pot data so its not missing any config value
*/
function zgo2.Pot.VerifyData(Data)
	local PotData = table.Copy(Data)

	PotData.class = "zgo2_pot"

	PotData.type = PotData.type or 1
	PotData.name = PotData.name or "Pot"
	PotData.price = PotData.price or 1000

	PotData.water_capacity = PotData.water_capacity or 500

	PotData.scale = PotData.scale or 1

	PotData.boost_time = PotData.boost_time or 1
	PotData.boost_amount = PotData.boost_amount or 1

	PotData.ranks = PotData.ranks or {}
	PotData.jobs = PotData.jobs or {}

	PotData.style = PotData.style or {}
	PotData.style.color = PotData.style.color or color_white
	PotData.style.blendmode = PotData.style.blendmode or 0
	PotData.style.url = PotData.style.url or ""
	PotData.style.scale = PotData.style.scale or 1
	PotData.style.img_color = PotData.style.img_color or color_white
	PotData.style.pos_x = PotData.style.pos_x or 0
	PotData.style.pos_y = PotData.style.pos_y or 0

	PotData.style.phongexponent = PotData.style.phongexponent or 15
	PotData.style.phongboost = PotData.style.phongboost or 0.5
	PotData.style.phongtint = PotData.style.phongtint or color_white
	PotData.style.fresnel = PotData.style.fresnel or 1

	return PotData
end

function zgo2.Pot.GetNiceAmountBoost(UniqueID)
	local dat = zgo2.Pot.GetData(UniqueID)
	local val = dat.boost_amount or 1
	local txt = (100 * val) - 100

	if val < 1 then
		txt = "-" .. txt .. "%"
	elseif val > 1 then
		txt = "+" .. txt .. "%"
	elseif val == 1 then
		txt = "--%"
	end

	return txt
end

function zgo2.Pot.GetNiceTimeBoost(UniqueID)
	local dat = zgo2.Pot.GetData(UniqueID)
	local val = dat.boost_time or 1
	local txt = (100 * val) - 100

	if val < 1 then
		txt = "-" .. txt .. "%"
	elseif val > 1 then
		txt = "+" .. txt .. "%"
	elseif val == 1 then
		txt = "--%"
	end

	return txt
end

/*
	Randomizes the Pot values of the provided data
*/
function zgo2.Pot.RandomizeData(PotData)

	PotData.style.url = imgid
	PotData.style.scale = math.Rand(0.1,1.5)
	PotData.style.color = ColorRand(false)

	return PotData
end


//////////////////////////////////////////

file.CreateDir( "zgo2" )
local function LoadPotData(data)

	// Convert any job command to job ids before loading
	data = zgo2.util.ConvertJobCommandToJobID(data)

	zgo2.config.Pots = table.Copy(data)

	// Verify the data
	for k,v in pairs(zgo2.config.Pots) do zgo2.config.Pots[k] = zgo2.Pot.VerifyData(v) end

	// Rebuild its materials
	if CLIENT then
		zgo2.Print("Loading Imgur images!")

		// NOTE This is so important, we need to delay the rebuild action
		timer.Simple(1,function()
			for k, v in pairs(zgo2.config.Pots) do
				// Predownload the imgur images
				zclib.Imgur.GetMaterial(tostring(v.style.url), function(result)
					zgo2.Pot.RebuildMaterial(v)
				end)
			end
		end)
	end
	hook.Run("zgo2_OnPotConfigLoaded")
end

timer.Simple(0, function()
	zclib.Data.Setup("zgo2_pot_config", "[Zero´s GrowOP - 2]", "zgo2/config_pot.txt", function() return zgo2.config.Pots end, function(data)
		// OnLoaded
		LoadPotData(data)
	end, function()
		// OnSend
	end, function(data)
		// OnReceived
		LoadPotData(data)
	end, function(list)
		//OnIDListRebuild
		zgo2.config.Pots_ListID = table.Copy(list)
	end,function(data)
		// OnPreSave

		// Convert any job id to its job command before saving
		data = zgo2.util.ConvertJobIDToCommand(data)

		return data
	end)
end)

if SERVER then
	concommand.Add("zgo2_pot_factory_reset", function(ply, cmd, args)
		if zclib.Player.IsAdmin(ply) then

			zgo2.util.ConfirmAction(ply,function()
				zclib.Data.Remove(ply,"zgo2_pot_config")

				include("sh_zgo2_config_pot.lua")

				zclib.Data.UpdateConfig("zgo2_pot_config")

				zclib.Notify(ply, "Pot config reset, restart server to have full effect.", 0)

				// Tell all clients to remove their thumbnails
				zclib.Snapshoter.Delete("zgo2")
			end)
		end
	end)
end
