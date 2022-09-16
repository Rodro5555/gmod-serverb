zgo2 = zgo2 or {}
zgo2.config = zgo2.config or {}
zgo2.config.Bongs = {}
zgo2.config.Bongs_ListID = zgo2.config.Bongs_ListID or {}

local function AddBong(data)
	// Convert the Job commands to job ids
	data = zgo2.util.ConvertJobCommandToJobID(data)

	local BongID = table.insert(zgo2.config.Bongs,data)

	zgo2.config.Bongs_ListID[data.uniqueid] = BongID
	return BongID
end

/*

	This bong config can be edited using the ingame editor

*/

AddBong({
	capacity = 25,
	price = 1000,
	jobs = {},
	name = "Bacid",
	type = 1,
	uniqueid = "4904jhfjhffjs",
	style = {
		blendmode = 0,
		scale = 0.6,
		phongtint = Color(88, 190, 112, 255),
		color = Color(255, 255, 255, 255),
		phongexponent = 15,
		pos_y = 0.1,
		fresnel = 1,
		url = "SJNDvNB",
		img_color = Color(109, 255, 101, 255),
		pos_x = 0.09,
		phongboost = 0.5,
	},
	ranks = {},
})


AddBong({
	capacity = 25,
	price = 1000,
	jobs = {},
	style = {
		blendmode = "Additive",
		scale = 0.32,
		phongtint = Color(167, 141, 96, 255),
		color = Color(96, 89, 67, 255),
		phongexponent = 3,
		pos_y = 0.94,
		fresnel = 1,
		url = "DxMO4se",
		img_color = Color(255, 255, 255, 255),
		pos_x = 0.67,
		phongboost = 0.5,
	},
	type = 2,
	uniqueid = "d456d3873f",
	name = "Industria",
	ranks = {},
})

AddBong({
	capacity = 25,
	price = 1000,
	jobs = {
		[ "mayor" ] = true,
		[ "zgo2_pro" ] = true,
	},
	style = {
		blendmode = 0,
		scale = 0.63,
		phongtint = Color(255, 255, 255, 255),
		color = Color(119, 119, 119, 255),
		phongexponent = 15,
		pos_y = 0.11,
		fresnel = 1,
		url = "DwUoAia",
		img_color = Color(255, 255, 255, 255),
		pos_x = 0.25,
		phongboost = 0.34,
	},
	type = 3,
	uniqueid = "04b7eb08b8",
	name = "James Bong",
	ranks = {},
})

AddBong({
	uniqueid = "95392fc12c",
	price = 1000,
	jobs = {},
	style = {
		blendmode = "Additive",
		scale = 0.6,
		phongtint = Color(190, 88, 105, 255),
		color = Color(201, 97, 130, 255),
		phongexponent = 15,
		pos_y = 0.1,
		fresnel = 1,
		url = "xizvhL7",
		img_color = Color(204, 132, 144, 255),
		pos_x = 0.09,
		phongboost = 0.5,
	},
	type = 1,
	capacity = 25,
	name = "Cherry",
	ranks = {},
})
