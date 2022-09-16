zgo2 = zgo2 or {}
zgo2.Plant = zgo2.Plant or {}
zgo2.config.Plants = zgo2.config.Plants or {}
zgo2.config.Plants_ListID = zgo2.config.Plants_ListID or {}

/*

	The Weed plant is the core element of the game and it can have a lot of diffrent stats

*/

/*
	Creates a new spliced plant config
*/
function zgo2.Plant.CreateSplice(data)
	data = zgo2.util.ConvertJobCommandToJobID(data)

	data.uniqueid = zclib.util.GenerateUniqueID("xxxxxxxxxx")

	// Mark the weed config as being created through splicing
	// NOTE Those type of weed configs wont show up in the Editor and will be cleaned up if not used for long duration
	data.SplicedConfig = true

	zgo2.config.Plants_ListID[data.uniqueid] = table.insert(zgo2.config.Plants,zgo2.Plant.VerifyData(data))

	// Save the new config
	zclib.Data.Save(nil,"zgo2_plant_config",zgo2.config.Plants)

	return data.uniqueid
end

/*
	Removes a spliced plant config from the SERVER
*/
function zgo2.Plant.RemoveSplice(UniqueID)
	local dat = zgo2.Plant.GetData(UniqueID)
	if not dat then return end

	if not dat.SplicedConfig then return end

	local ListID = zgo2.config.Plants_ListID[UniqueID]
	if not ListID then return end

	zgo2.config.Plants[ListID] = nil

	zclib.Data.Save(nil,"zgo2_plant_config",zgo2.config.Plants)
end

/*
	Return all the plant configs that currently exist
*/
function zgo2.Plant.GetAll()
	return zgo2.config.Plants
end

/*
	Get the UniqueID
*/
function zgo2.Plant.GetID(ListID)
	local dat = zgo2.Plant.GetData(ListID)
	if not dat then return "nil" end
    return dat.uniqueid
end

/*
	Get the list id
*/
function zgo2.Plant.GetListID(UniqueID)
    return zgo2.config.Plants_ListID[UniqueID] or 0
end

/*
	Get the plant config data
*/
function zgo2.Plant.GetData(UniqueID)
    if UniqueID == nil then return end

    // If its a list id then lets return its data
    if zgo2.config.Plants[UniqueID] then return zgo2.config.Plants[UniqueID] end

    // If its a uniqueid then lets get its list id and return the data
    local id = zgo2.Plant.GetListID(UniqueID)
    if UniqueID and id and zgo2.config.Plants[id] then
        return zgo2.config.Plants[id]
    end
end

/*
	Returns if the provided id odes even exist
*/
function zgo2.Plant.IsValid(UniqueID)
    return zgo2.Plant.GetData(UniqueID) ~= nil
end

/*
	Returns if the provided PlantID is created via splicing
*/
function zgo2.Plant.IsSplice(UniqueID)
	local dat = zgo2.Plant.GetData(UniqueID)
	if not dat then return false end
    return dat.SplicedConfig == true
end

/*
	Get random plant id
*/
function zgo2.Plant.GetRandomID()
	return math.random(#zgo2.config.Plants)
end

/*
	Modify the provided plant data so its not missing any config value
*/
function zgo2.Plant.VerifyData(Data)
	local PlantData = table.Copy(Data)

	if PlantData.uniqueid then PlantData.uniqueid = tostring(PlantData.uniqueid) end

	PlantData.name = PlantData.name or "Plant"

	PlantData.ranks = PlantData.ranks or {}
	PlantData.jobs = PlantData.jobs or {}

	PlantData.style = PlantData.style or {}

	PlantData.style.mesh = PlantData.style.mesh or 1
	PlantData.style.scale = PlantData.style.scale or 1
	PlantData.style.width = PlantData.style.width or 1
	PlantData.style.height = PlantData.style.height or 1

	PlantData.style.stem = PlantData.style.stem or {}
	PlantData.style.stem.pattern_id = PlantData.style.stem.pattern_id or 1
	PlantData.style.stem.texture = PlantData.style.stem.texture or zgo2.Plant.Stems[1]
	PlantData.style.stem.color01 = PlantData.style.stem.color01 or Color(136,238,35)
	PlantData.style.stem.color02 = PlantData.style.stem.color02 or Color(238,35,64)

	PlantData.style.leaf01 = PlantData.style.leaf01 or {}
	PlantData.style.leaf01.pattern_id = PlantData.style.leaf01.pattern_id or 1
	PlantData.style.leaf01.texture = PlantData.style.leaf01.texture or zgo2.Plant.Leafs[7]
	PlantData.style.leaf01.color01 = PlantData.style.leaf01.color01 or Color(136,238,35)
	PlantData.style.leaf01.color02 = PlantData.style.leaf01.color02 or Color(238,35,64)

	PlantData.style.leaf02 = PlantData.style.leaf02 or {}
	PlantData.style.leaf02.pattern_id = PlantData.style.leaf02.pattern_id or 1
	PlantData.style.leaf02.texture = PlantData.style.leaf02.texture or zgo2.Plant.Leafs[7]
	PlantData.style.leaf02.color01 = PlantData.style.leaf02.color01 or Color(136,238,35)
	PlantData.style.leaf02.color02 = PlantData.style.leaf02.color02 or Color(238,35,64)


	PlantData.style.bud = PlantData.style.bud or {}
	PlantData.style.bud.pattern_id = PlantData.style.bud.pattern_id or 1
	PlantData.style.bud.texture = PlantData.style.bud.texture or zgo2.Plant.Buds[1]
	PlantData.style.bud.color01 = PlantData.style.bud.color01 or Color(136,238,35)
	PlantData.style.bud.color02 = PlantData.style.bud.color02 or Color(238,35,64)

	PlantData.style.hair = PlantData.style.hair or {}
	PlantData.style.hair.pattern_id = PlantData.style.hair.pattern_id or 1
	PlantData.style.hair.texture = PlantData.style.hair.texture or zgo2.Plant.BudHair[1]
	PlantData.style.hair.color01 = PlantData.style.hair.color01 or Color(136,238,35)
	PlantData.style.hair.color02 = PlantData.style.hair.color02 or Color(238,35,64)

	PlantData.style.seedbox = PlantData.style.seedbox or {}
	PlantData.style.seedbox.main_color = PlantData.style.seedbox.main_color or Color(255,255,255)
	PlantData.style.seedbox.imgur_blendmode = PlantData.style.seedbox.imgur_blendmode or "Multiply"
	PlantData.style.seedbox.imgur_color = PlantData.style.seedbox.imgur_color or Color(0,255,0)
	PlantData.style.seedbox.imgur_url = PlantData.style.seedbox.imgur_url or "Voh7Apg"
	PlantData.style.seedbox.imgur_pos_x = PlantData.style.seedbox.imgur_pos_x or 0
	PlantData.style.seedbox.imgur_pos_y = PlantData.style.seedbox.imgur_pos_y or 0
	PlantData.style.seedbox.imgur_scale = PlantData.style.seedbox.imgur_scale or 1

	PlantData.style.seedbox.title_enabled = PlantData.style.seedbox.title_enabled or false
	PlantData.style.seedbox.title_font = PlantData.style.seedbox.title_font or "zclib_world_font_small"
	PlantData.style.seedbox.title_pos_x = PlantData.style.seedbox.title_pos_x or 0.31
	PlantData.style.seedbox.title_pos_y = PlantData.style.seedbox.title_pos_y or 0.26
	PlantData.style.seedbox.title_color = PlantData.style.seedbox.title_color or color_white

	PlantData.style.seedbox.phongexponent = PlantData.style.seedbox.phongexponent or 15
	PlantData.style.seedbox.phongboost = PlantData.style.seedbox.phongboost or 0.5
	PlantData.style.seedbox.phongtint = PlantData.style.seedbox.phongtint or color_white
	PlantData.style.seedbox.fresnel = PlantData.style.seedbox.fresnel or 1


	PlantData.grow = PlantData.grow or {}
	PlantData.grow.time = PlantData.grow.time or 600
	PlantData.grow.water = PlantData.grow.water or 1000
	PlantData.grow.pref_lightcolor_req = PlantData.grow.pref_lightcolor_req or false
	PlantData.grow.pref_lightcolor_color = PlantData.grow.pref_lightcolor_color or color_white

	PlantData.weed = PlantData.weed or {}
	PlantData.weed.thc = PlantData.weed.thc or 50
	PlantData.weed.amount = PlantData.weed.amount or 500

	PlantData.sell = PlantData.sell or {}
	PlantData.sell.value = PlantData.sell.value or 10

	PlantData.screeneffect = PlantData.screeneffect or {}
	PlantData.screeneffect.basetexture_url = PlantData.screeneffect.basetexture_url or "vF0SWVr"
	PlantData.screeneffect.basetexture_scale = PlantData.screeneffect.basetexture_scale or 0.75
	PlantData.screeneffect.basetexture_color = PlantData.screeneffect.basetexture_color or color_white
	PlantData.screeneffect.basetexture_alpha = PlantData.screeneffect.basetexture_alpha or 1

	PlantData.screeneffect.basetexture_spin_speed = PlantData.screeneffect.basetexture_spin_speed or 45
	PlantData.screeneffect.basetexture_spin_snap = PlantData.screeneffect.basetexture_spin_snap or 0

	PlantData.screeneffect.basetexture_blink_interval = PlantData.screeneffect.basetexture_blink_interval or 0.25
	PlantData.screeneffect.basetexture_blink_min = PlantData.screeneffect.basetexture_blink_min or 0.1
	PlantData.screeneffect.basetexture_blink_max = PlantData.screeneffect.basetexture_blink_max or 0.2

	PlantData.screeneffect.basetexture_bounce_interval = PlantData.screeneffect.basetexture_bounce_interval or 0
	PlantData.screeneffect.basetexture_bounce_min = PlantData.screeneffect.basetexture_bounce_min or 1
	PlantData.screeneffect.basetexture_bounce_max = PlantData.screeneffect.basetexture_bounce_max or 1


	PlantData.screeneffect.refract_url = PlantData.screeneffect.refract_url or "7vud8Uc"
	PlantData.screeneffect.refract_scale = PlantData.screeneffect.refract_scale or 0.75
	PlantData.screeneffect.refract_blur = PlantData.screeneffect.refract_blur or 0
	PlantData.screeneffect.refract_ref = PlantData.screeneffect.refract_ref or 0.01
	PlantData.screeneffect.refract_alpha = PlantData.screeneffect.refract_alpha or 1
	PlantData.screeneffect.refract_color = PlantData.screeneffect.refract_color or color_white
	PlantData.screeneffect.refract_tint = PlantData.screeneffect.refract_tint or color_white

	PlantData.screeneffect.refract_spin_speed = PlantData.screeneffect.refract_spin_speed or 45
	PlantData.screeneffect.refract_spin_snap = PlantData.screeneffect.refract_spin_snap or 0

	PlantData.screeneffect.refract_blink_interval = PlantData.screeneffect.refract_blink_interval or 0.25
	PlantData.screeneffect.refract_blink_min = PlantData.screeneffect.refract_blink_min or 0.1
	PlantData.screeneffect.refract_blink_max = PlantData.screeneffect.refract_blink_max or 0.2

	PlantData.screeneffect.refract_bounce_interval = PlantData.screeneffect.refract_bounce_interval or 0
	PlantData.screeneffect.refract_bounce_min = PlantData.screeneffect.refract_bounce_min or 1
	PlantData.screeneffect.refract_bounce_max = PlantData.screeneffect.refract_bounce_max or 1

	PlantData.screeneffect.bloom_darken = PlantData.screeneffect.bloom_darken or 0.1
	PlantData.screeneffect.bloom_multiply = PlantData.screeneffect.bloom_multiply or 0.5
	PlantData.screeneffect.bloom_sizex = PlantData.screeneffect.bloom_sizex or 25
	PlantData.screeneffect.bloom_sizey = PlantData.screeneffect.bloom_sizey or 25
	PlantData.screeneffect.bloom_passes = PlantData.screeneffect.bloom_passes or 2
	PlantData.screeneffect.bloom_colormul = PlantData.screeneffect.bloom_colormul or 2
	PlantData.screeneffect.bloom_color = PlantData.screeneffect.bloom_color or color_white

	PlantData.screeneffect.mblur_addalpha = PlantData.screeneffect.mblur_addalpha or 0.4
	PlantData.screeneffect.mblur_drawalpha = PlantData.screeneffect.mblur_drawalpha or 0.8
	PlantData.screeneffect.mblur_delay = PlantData.screeneffect.mblur_delay or 0.01

	PlantData.screeneffect.audio_dsp = PlantData.screeneffect.audio_dsp or 0
	PlantData.screeneffect.audio_music = PlantData.screeneffect.audio_music or ""


	return PlantData
end

/*
	Randomizes the plant values of the provided data
*/
function zgo2.Plant.RandomizeData(Data)

	Data.style.scale = math.Rand(0.25,1)
	Data.style.width = math.Rand(0.75,1.5)
	Data.style.height = math.Rand(0.75,1.5)

	Data.style.stem.texture = zgo2.Plant.Stems[math.random(#zgo2.Plant.Stems)]
	Data.style.leaf01.texture = zgo2.Plant.Leafs[math.random(#zgo2.Plant.Leafs)]
	Data.style.bud.texture = zgo2.Plant.Buds[math.random(#zgo2.Plant.Buds)]
	Data.style.hair.texture = zgo2.Plant.BudHair[math.random(#zgo2.Plant.BudHair)]

	Data = zgo2.Plant.RandomizeStyleData(Data)

	return Data
end

/*
	Randomizes the plant style values of the provided data
*/
local ColorRange = 360
local SaturateMin = 0.65
local SaturateMax = 0.7
local BrightnessMin = 0.5
local BrightnessMax = 0.7
function zgo2.Plant.RandomizeStyleData(Data)

	local col01 = HSVToColor(math.random(ColorRange),math.Rand(SaturateMin,SaturateMax),math.Rand(BrightnessMin,BrightnessMax))
	local col02 = HSVToColor(math.random(ColorRange),math.Rand(SaturateMin,SaturateMax),math.Rand(BrightnessMin,BrightnessMax))

	local Bud01 = HSVToColor(math.random(ColorRange),math.Rand(SaturateMin,SaturateMax),math.Rand(BrightnessMin,BrightnessMax))
	local Bud02 = HSVToColor(math.random(ColorRange),math.Rand(SaturateMin,SaturateMax),math.Rand(BrightnessMin,BrightnessMax))

	if math.random(10) > 5 then
		Bud01 = col02
	end

	local Hair01 = col01
	local Hair02 = Color(col02.r,col02.g,col02.b,150)

	Data.style.stem.pattern_id = math.random(#zgo2.Plant.Patterns)
	Data.style.stem.color01 = col01
	Data.style.stem.color02 = col02

	Data.style.leaf01.pattern_id = math.random(#zgo2.Plant.Patterns)
	Data.style.leaf01.color01 = col01
	Data.style.leaf01.color02 = col02

	Data.style.leaf02.pattern_id = math.random(#zgo2.Plant.Patterns)
	Data.style.leaf02.color01 = HSVToColor(math.random(ColorRange),math.Rand(SaturateMin,SaturateMax),math.Rand(BrightnessMin,BrightnessMax))
	Data.style.leaf02.color02 = HSVToColor(math.random(ColorRange),math.Rand(SaturateMin,SaturateMax),math.Rand(BrightnessMin,BrightnessMax))

	Data.style.bud.pattern_id = math.random(#zgo2.Plant.Patterns)
	Data.style.bud.color01 = Bud01
	Data.style.bud.color02 = Bud02

	Data.style.hair.pattern_id = math.random(#zgo2.Plant.Patterns)
	Data.style.hair.color01 = Hair01
	Data.style.hair.color02 = Hair02
	Data.style.hair.texture = zgo2.Plant.BudHair[math.random(#zgo2.Plant.BudHair)]

	return Data
end

/*
	Randomizes the plant screeneffect values of the provided data
*/
function zgo2.Plant.RandomizeScreeneffectData(Data)

	local _, imgid = table.Random(zclib.Imgur.CachedMaterials)

	Data.screeneffect = Data.screeneffect or {}
	Data.screeneffect.basetexture_url = imgid
	Data.screeneffect.basetexture_scale = math.Rand(0.1,1.5)
	Data.screeneffect.basetexture_color = ColorRand(false)
	Data.screeneffect.basetexture_alpha = math.Rand(0.1,1)

	Data.screeneffect.basetexture_spin_speed = math.random(-360,360)
	Data.screeneffect.basetexture_spin_snap = math.Rand(0,3)

	Data.screeneffect.basetexture_blink_interval = math.Rand(0,3)
	Data.screeneffect.basetexture_blink_min = math.Rand(0,1)
	Data.screeneffect.basetexture_blink_max = math.Rand(0.1,1)

	Data.screeneffect.basetexture_bounce_interval = math.Rand(0,3)
	Data.screeneffect.basetexture_bounce_min = math.Rand(0,15)
	Data.screeneffect.basetexture_bounce_max = math.Rand(0,15)


	Data.screeneffect.refract_url = imgid
	Data.screeneffect.refract_scale = math.Rand(0.1,1.5)
	Data.screeneffect.refract_blur = math.random(0,3)
	Data.screeneffect.refract_ref = math.Rand(0.001,0.1)
	Data.screeneffect.refract_alpha = math.Rand(0.1,1)
	Data.screeneffect.refract_color = ColorRand(false)
	Data.screeneffect.refract_tint = ColorRand(false)

	Data.screeneffect.refract_spin_speed = math.random(-360,360)
	Data.screeneffect.refract_spin_snap = math.Rand(0,3)

	Data.screeneffect.refract_blink_interval = math.Rand(0,3)
	Data.screeneffect.refract_blink_min = math.Rand(0,1)
	Data.screeneffect.refract_blink_max = math.Rand(0.1,1)

	Data.screeneffect.refract_bounce_interval = math.Rand(0,3)
	Data.screeneffect.refract_bounce_min = math.Rand(0,15)
	Data.screeneffect.refract_bounce_max = math.Rand(0,15)

	Data.screeneffect.bloom_darken = 0//math.Rand(-1,1)
	Data.screeneffect.bloom_multiply = math.Rand(0,1.5)
	Data.screeneffect.bloom_sizex = math.Rand(0,100)
	Data.screeneffect.bloom_sizey = math.Rand(0,100)
	Data.screeneffect.bloom_passes = math.random(1,10)
	Data.screeneffect.bloom_colormul = math.Rand(0,5)
	Data.screeneffect.bloom_color = ColorRand(false)

	Data.screeneffect.mblur_addalpha = math.Rand(0,50)
	Data.screeneffect.mblur_drawalpha = math.Rand(0,1)
	Data.screeneffect.mblur_delay = math.Rand(0,0.03)

	Data.screeneffect.audio_dsp = math.random(1,43)
	//PlantData.screeneffect.audio_music = PlantData.screeneffect.audio_music or ""

	return Data
end

file.CreateDir( "zgo2" )
local function LoadPlantData(data)

	// Convert any job command to job ids before loading
	data = zgo2.util.ConvertJobCommandToJobID(data)

	zgo2.config.Plants = table.Copy(data)

	// Verify the data
	for k,v in pairs(zgo2.config.Plants) do zgo2.config.Plants[k] = zgo2.Plant.VerifyData(v) end

	// Rebuild its materials
	if CLIENT then
		// Cache all the materials
		for k, v in pairs(zgo2.config.Plants) do

			// Build normal plant materials
			zgo2.Plant.RebuildMaterial(v)

			// Build dried plant materials
			zgo2.Plant.RebuildMaterial(v,nil,true)

			// Download ScreenEffect BaseTexture
			zclib.Imgur.GetMaterial(tostring(v.screeneffect.basetexture_url), function()

				// Download ScreenEffect refract texture
				zclib.Imgur.GetMaterial(tostring(v.screeneffect.refract_url), function()

					zgo2.ScreenEffect.RebuildMaterial(v)
				end)
			end)

			if v.screeneffect.audio_music and v.screeneffect.audio_music ~= "" then
				zgo2.ScreenEffect.SetMusic(v,v.screeneffect.audio_music)
			end
		end
	end

	hook.Run("zgo2_OnPlantConfigLoaded")
end

timer.Simple(0, function()
	zclib.Data.Setup("zgo2_plant_config", "[Zero´s GrowOP - 2]", "zgo2/config_plant.txt", function() return zgo2.config.Plants end, function(data)

		// OnLoaded
		LoadPlantData(data)

		// Perform the activity chgeck for spliced plant configs and remove the inactive ones
		if SERVER then zgo2.Plant.InitActivity() end

	end, function()
		// OnSend
	end, function(data)
		// OnReceived
		LoadPlantData(data)
	end, function(list)
		//OnIDListRebuild
		zgo2.config.Plants_ListID = table.Copy(list)
	end,function(data)
		// OnPreSave

		// Convert any job id to its job command before saving
		data = zgo2.util.ConvertJobIDToCommand(data)

		return data
	end)
end)

if SERVER then
	concommand.Add("zgo2_plant_factory_reset", function(ply, cmd, args)
		if zclib.Player.IsAdmin(ply) then

			zgo2.util.ConfirmAction(ply,function()

				// Delete config data
				zclib.Data.Remove(ply,"zgo2_plant_config")

				// Delete the spliced config plant activity
				zgo2.Plant.DeleteActivity()

				// Reload default config file
				include("sh_zgo2_config_plant.lua")

				// Update all clients
				zclib.Data.UpdateConfig("zgo2_plant_config")

				zclib.Notify(ply, "Plant config reset, restart server to have full effect.", 0)

				// Tell all clients to remove their thumbnails
				zclib.Snapshoter.Delete("zgo2")
			end)
		end
	end)
end

/////////////////////////////////////////////////////////////////////////////////////////

/*
	Return true if the plant is inside a grow tent
*/
function zgo2.Plant.InsideTent(Plant)
	local Pot = Plant:GetParent()

	if IsValid(Pot) then
		local tent = Pot:GetParent()
		if IsValid(tent) and tent:GetClass() == "zgo2_tent" then return tent end
	end

	return false
end

/*
	Returns the plant model according to its mesh id
*/
function zgo2.Plant.GetMesh(PlantData)
	if not PlantData then return "models/zerochain/props_growop2/zgo2_plant01.mdl" end
	if not PlantData.style.mesh then PlantData.style.mesh = 1 end
	return zgo2.Plant.Shapes[PlantData.style.mesh]
end

/*
	Returns the Width and Height of a plant config
*/
function zgo2.Plant.GetSize(PlantData)
	if not PlantData then return 1, 1 end
	return PlantData.style.width, PlantData.style.height
end

/*
	Returns the scale of a plant based on size
*/
function zgo2.Plant.GetScale(PlantData)
	local width, height = zgo2.Plant.GetSize(PlantData)
	return ((width + height) / 2) * PlantData.style.scale
end

/*
	Returns the total size a plant can grow according to its config and its current surounding (GrowBox)
*/
function zgo2.Plant.GetFinalSize(Plant,PlantData)
	local width, height = zgo2.Plant.GetSize(PlantData)
	local Tent = zgo2.Plant.InsideTent(Plant)
	if Tent then
		local AllowedHeight = zgo2.Tent.GetHeight(Tent) * 0.45
		height = math.Clamp((1 / (80 * height  * PlantData.style.scale)) * AllowedHeight,0,1)
		width = math.Clamp((1 / (50 * width  * PlantData.style.scale)) * 50,0,1)
	end
	return width , height
end

/*
	Returns if the plant has water
*/
function zgo2.Plant.HasWater(Plant,Amount)
	return Plant:GetParent():GetWater() >= (Amount or 0)
end

/*
	Returns the grow time
*/
function zgo2.Plant.GetGrowTime(UniqueID,Plant)
    local dat = zgo2.Plant.GetData(UniqueID)
	if not dat then return 60 end
	local time = dat.grow.time or 60

	if IsValid(Plant) then
		local Pot = Plant:GetParent()
		if IsValid(Pot) and Pot:GetClass() == "zgo2_pot" then
			local PotData = zgo2.Pot.GetData(Pot:GetPotID())
			if PotData then
				time = time / PotData.boost_time
			end
		end
	end

	return math.Round(time)
end

/*
	Returns the grow time
*/
function zgo2.Plant.GetWeedAmount(UniqueID)
	local PlantData = zgo2.Plant.GetData(UniqueID)

	return PlantData.weed.amount
end

/*
	Returns the requiered water amount
*/
function zgo2.Plant.GetWaterNeed(UniqueID)
    local dat = zgo2.Plant.GetData(UniqueID)
	return dat.grow.water or 60
end

/*
	Returns if the plant is harvest ready
*/
function zgo2.Plant.HarvestReady(Plant)
	return Plant:GetGrowProgress() >= zgo2.Plant.GetGrowTime(Plant:GetPlantID(),Plant)
end

/*
	Returns the plant name
*/
function zgo2.Plant.GetName(UniqueID)
    local dat = zgo2.Plant.GetData(UniqueID)
	if not dat then return "Unknown" end
	return dat.name or "Unknown"
end

/*
	Returns the plants main color
*/
function zgo2.Plant.GetColor(UniqueID)
    local dat = zgo2.Plant.GetData(UniqueID)
	if not dat then return color_white end
	return dat.style.bud.color01 or color_white
end

/*
	Returns the plant weed sell value
*/
function zgo2.Plant.GetSellValue(UniqueID)
    local dat = zgo2.Plant.GetData(UniqueID)

	return (dat.sell.value or 0) * zgo2.config.WeedPriceMultiplicator
end

/*
	Returns the money value of the plant if grown perfectly
*/
function zgo2.Plant.GetTotalMoney(UniqueID)
	local money = 0
    local dat = zgo2.Plant.GetData(UniqueID)

	if dat and dat.weed and dat.weed.amount then
		money = dat.weed.amount * zgo2.Plant.GetSellValue(UniqueID)
	end

	return money
end

/*
	Returns the time a spliced plant config is allowed to be inactive
*/
function zgo2.Plant.GetLifeTime(UniqueID)
	local dat = zgo2.Plant.GetData(UniqueID)
	if not dat then return 0 end
	if not dat.creator_rank then return 0 end
	local lifetime = zgo2.config.Splicer.LifeTime[dat.creator_rank] or zgo2.config.Splicer.LifeTime["default"]
	if not lifetime then lifetime = 86400 end
	return lifetime
end
