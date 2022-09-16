zvm = zvm or {}
zvm.Machine = zvm.Machine or {}

// Needs to be precached on both server and client to make it work for the snapshoter system
zclib.CacheModel("models/zerochain/props_vendingmachine/zvm_machine.mdl")



zvm.Machine.Skins = {
	[0] = {
		name = "Default",
		diff = "zerochain/props_vendingmachine/vendingmachine/zvm_vendingmachine_skin01_diff",
		nrm = "zerochain/props_vendingmachine/vendingmachine/zvm_vendingmachine_skin01_nrm",
		color = Color(63,124,190,255),
		fresnel = 3.2,
		reflection = 1.5,
		spec_color = Color(58,105,175,255),
	},
	[1] = {
		name = "Retro",
		diff = "zerochain/props_vendingmachine/vendingmachine/zvm_vendingmachine_skin02_diff",
		nrm = "zerochain/props_vendingmachine/vendingmachine/zvm_vendingmachine_skin02_nrm",
		color = Color(172,72,72,255),
		fresnel = 2,
		reflection = 0.38,
		spec_color = Color(196,96,96,255),
	},
	[2] = {
		name = "Military",
		diff = "zerochain/props_vendingmachine/vendingmachine/zvm_vendingmachine_skin03_diff",
		nrm = "zerochain/props_vendingmachine/vendingmachine/zvm_vendingmachine_skin03_nrm",
		color = Color(221,195,156,255),
		fresnel = 1.5,
		reflection = 0.38,
		spec_color = Color(255,255,255,255),
	},
	[3] = {
		name = "Scifi",
		mask = "zerochain/props_vendingmachine/vendingmachine/zvm_vendingmachine_skin04_colormask.png",
		diff = "zerochain/props_vendingmachine/vendingmachine/zvm_vendingmachine_skin04_diff",
		nrm = "zerochain/props_vendingmachine/vendingmachine/zvm_vendingmachine_skin04_nrm",
		color = Color(255,173,50,255),
		fresnel = 1,
		reflection = 1,
		spec_color = Color(255,255,255,255),
	},
	[4] = {
		name = "Rusty",
		diff = "zerochain/props_vendingmachine/vendingmachine/zvm_vendingmachine_skin05_diff",
		nrm = "zerochain/props_vendingmachine/vendingmachine/zvm_vendingmachine_skin05_nrm",
		color = Color(172,184,95,255),
		fresnel = 0,
		reflection = 4.4,
		spec_color = Color(181,152,152,255),
	},
	[5] = {
		name = "Urban",
		diff = "zerochain/props_vendingmachine/vendingmachine/zvm_vendingmachine_skin06_diff",
		nrm = "zerochain/props_vendingmachine/vendingmachine/zvm_vendingmachine_skin06_nrm",
		color = Color(160,221,220,255),
		fresnel = 1.1,
		reflection = 0.7,
		spec_color = Color(50,189,199,255),
	},
	[6] = {
		name = "Fancy",
		diff = "zerochain/props_vendingmachine/vendingmachine/zvm_vendingmachine_skin07_diff",
		nrm = "zerochain/props_vendingmachine/vendingmachine/zvm_vendingmachine_skin07_nrm",
		color = Color(255,0,97,255),
		fresnel = 0,
		reflection = 2.6,
		spec_color = Color(255,148,179,255),
	},
	[7] = {
		name = "Space",
		diff = "zerochain/props_vendingmachine/vendingmachine/zvm_vendingmachine_skin08_diff",
		nrm = "zerochain/props_vendingmachine/vendingmachine/zvm_vendingmachine_skin08_nrm",
		color = Color(0,2,86,255),
		fresnel = 1,
		reflection = 2.7,
		spec_color = Color(27,99,255,255),
	},
}

// A quick fix to figure out which diffuse map is linked to which skin id, just so people dont have to redefine their vendignmachines
local DiffToSkinID = {}
for k,v in pairs(zvm.Machine.Skins) do DiffToSkinID[v.diff] = k end

function zvm.Machine.GetSkinData(id)
	return zvm.Machine.Skins[id]
end



/*
	Sets up the saving / loading / synch from style data from the server to the clients
*/
file.CreateDir( "zvm" )
timer.Simple(0,function()
    zclib.Data.Setup("zvm_machine_styles", "[Zero´s Vendingmachines]", "zvm/machine_styles.txt",function()
        return zvm.Machine.Styles
    end, function(data)
        // OnLoaded
        zvm.Machine.Styles = table.Copy(data)
    end, function()
        // OnSend
    end, function(data)
        // OnReceived
        zvm.Machine.Styles = table.Copy(data)

        if CLIENT then
            // Download the used imgur images and cache them in materials
            zvm.Print("Loading used Imgur images for machine styles!")
			local delay = 0
			for k, v in pairs(zvm.Machine.Styles) do
				if v == nil then continue end
				timer.Simple(delay,function()
					if v.imgur_url then
						zclib.Imgur.GetMaterial(tostring(v.imgur_url), function(result) end)
					end

					if v.logo_url then
						zclib.Imgur.GetMaterial(tostring(v.logo_url), function(result) end)
					end

					if v.em_url then
						zclib.Imgur.GetMaterial(tostring(v.em_url), function(result) end)
					end
				end)
				delay = delay + 0.1
			end

			timer.Simple(delay + 1,function()
				zvm.Print("Building Style materials!")
				for k, v in pairs(zvm.Machine.Styles) do
					if v == nil then continue end
					zvm.Machine.GetMaterial("zvm_machine_style_mat_" .. v.uniqueid, v)
				end
			end)
        end
    end, function(list)
        //OnIDListRebuild
        zvm.Machine.Styles_ListID = table.Copy(list)
    end)
end)

/*
	Takes in a numerical list id and outputs its unique string id
*/
function zvm.Machine.GetUniqueStyleID(ListID)
	if ListID == nil then return end

	if zvm.Machine.Styles[ListID] then
		return zvm.Machine.Styles[ListID].uniqueid
	else
		return ListID
	end
end

/*
	Takes in a unique string id and outputs its numerical list id
*/
function zvm.Machine.GetStyleListID(UniqueID)
	return zvm.Machine.Styles_ListID[UniqueID]
end

/*
	Takes either a list or unique-id and outputs the corresponding style config data
*/
function zvm.Machine.GetStyleData(UniqueID)
	if UniqueID == nil then return end

	// If its a list id then lets return its data
	if zvm.Machine.Styles[UniqueID] then return zvm.Machine.Styles[UniqueID] end

	// If its a uniqueid then lets get its list id and return the data
	local id = zvm.Machine.GetStyleListID(UniqueID)
	if UniqueID and id and zvm.Machine.Styles[id] then return zvm.Machine.Styles[id] end
end

/*
	Takes in a set of style data and adds any value thats missing from it
*/
function zvm.Machine.VerifyStyleData(Data)
	local StyleData = table.Copy(Data)

	StyleData.color = StyleData.color or color_white
	StyleData.spec_color = StyleData.spec_color or color_black
	StyleData.reflection = StyleData.reflection or 0
	StyleData.fresnel = StyleData.fresnel or 0

	// This defines which base texture and normal map we are using, skins are defined up here zvm.Machine.Skins
	if StyleData.skin == nil then
		if StyleData.diff and DiffToSkinID[StyleData.diff] then
			StyleData.skin = DiffToSkinID[StyleData.diff]
		else
			StyleData.skin = 0
		end
	end

	StyleData.imgur_color = StyleData.imgur_color or color_white
	StyleData.imgur_blendmode = StyleData.imgur_blendmode or 0
	StyleData.imgur_url = StyleData.imgur_url or ""
	StyleData.imgur_x = StyleData.imgur_x or 0
	StyleData.imgur_y = StyleData.imgur_y or 0
	StyleData.imgur_scale = StyleData.imgur_scale or 1

	StyleData.logo_color = StyleData.logo_color or color_white
	StyleData.logo_blendmode = StyleData.logo_blendmode or 0
	StyleData.logo_url = StyleData.logo_url or ""
	StyleData.logo_x = StyleData.logo_x or 0.77
	StyleData.logo_y = StyleData.logo_y or 0.59
	StyleData.logo_scale = StyleData.logo_scale or 0.11
	StyleData.logo_rotation = StyleData.logo_rotation or 90

	StyleData.em_strength = StyleData.em_strength or 0
	StyleData.em_color = StyleData.em_color or color_black
	StyleData.em_url = StyleData.em_url or ""
	StyleData.em_x = StyleData.em_x or 0
	StyleData.em_y = StyleData.em_y or 0
	StyleData.em_scale = StyleData.em_scale or 1

	return StyleData
end

zvm.Machine.Styles = {}
zvm.Machine.Styles_ListID = {}

local function AddStyle(data)
	// Verify Data integrity
	data = zvm.Machine.VerifyStyleData(data)

	// Insert data in to style config
	zvm.Machine.Styles_ListID[data.uniqueid] = table.insert(zvm.Machine.Styles,data)
end

// Lets add some standard styles
for k, v in pairs(zvm.Machine.Skins) do
	AddStyle({
		uniqueid = "40496042" .. k,
		color = v.color,
		skin = k,
		fresnel = v.fresnel,
		reflection = v.reflection,
		spec_color = v.spec_color,
	})
end

// Imgur example
AddStyle({
	uniqueid = "4049604299",
	skin = 0,
	fresnel = 2,
	reflection = 15,
	imgur_url = "Egii0ey",
	imgur_scale = 1.71,
	imgur_x = 1,
	imgur_y = 0.52,
})
