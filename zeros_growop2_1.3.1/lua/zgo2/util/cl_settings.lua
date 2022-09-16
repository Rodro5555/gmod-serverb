if SERVER then return end

hook.Add("AddToolMenuCategories", "zgo2_CreateCategories", function()
	spawnmenu.AddToolCategory("Options", "zgo2_options", "GrowOP 2")
end)

local PrimaryColor = Color(82, 117, 71)
local SecondaryColor = Color(54, 77, 47) // zclib.colors[ "ui02" ]

hook.Add("PopulateToolMenu", "zgo2_PopulateMenus", function()
	spawnmenu.AddToolMenuOption("Options", "zgo2_options", "zgo2_Admin_Settings", "Admin Settings", "", "", function(CPanel)
		zclib.Settings.OptionPanel("Public Grow Setup", nil, PrimaryColor, SecondaryColor, CPanel, {
			[ 1 ] = {
				name = "Save",
				class = "DButton",
				cmd = "zgo2_public_save",
			},
			[ 2 ] = {
				name = "Remove",
				class = "DButton",
				cmd = "zgo2_public_remove",
			},
		})

		zclib.Settings.OptionPanel("Plant", nil, PrimaryColor, SecondaryColor, CPanel, {
			[ 1 ] = {
				name = "Open Editor",
				class = "DButton",
				cmd = "zgo2_plant_editor",
			},
			[ 2 ] = {
				name = "Factory Reset Config",
				class = "DButton",
				cmd = "zgo2_plant_factory_reset",
			},
		})

		zclib.Settings.OptionPanel("Bong", nil, PrimaryColor, SecondaryColor, CPanel, {
			[ 1 ] = {
				name = "Open Editor",
				class = "DButton",
				cmd = "zgo2_bong_editor",
			},
			[ 2 ] = {
				name = "Factory Reset Config",
				class = "DButton",
				cmd = "zgo2_bong_factory_reset",
			},
		})

		zclib.Settings.OptionPanel("Pot", nil, PrimaryColor, SecondaryColor, CPanel, {
			[ 1 ] = {
				name = "Open Editor",
				class = "DButton",
				cmd = "zgo2_pot_editor",
			},
			[ 2 ] = {
				name = "Factory Reset Config",
				class = "DButton",
				cmd = "zgo2_pot_factory_reset",
			},
		})

		zclib.Settings.OptionPanel("NPC", nil, PrimaryColor, SecondaryColor, CPanel, {
			[ 1 ] = {
				name = "Save",
				class = "DButton",
				cmd = "zgo2_npc_save",
			},
			[ 2 ] = {
				name = "Remove",
				class = "DButton",
				cmd = "zgo2_npc_remove",
			},
			[ 3 ] = {
				name = "Remove all DropZones",
				class = "DButton",
				cmd = "zgo2_DropZone_remove",
			},
		})

		zclib.Settings.OptionPanel("Commands", nil, PrimaryColor, SecondaryColor, CPanel, {
			[ 1 ] = {
				name = "Spawn Plants",
				class = "DButton",
				cmd = "zgo2_spawn_plants",
			},
			[ 2 ] = {
				name = "Spawn Weedbranches",
				class = "DButton",
				cmd = "zgo2_spawn_weedbranch",
			},
			[ 3 ] = {
				name = "Spawn Jars",
				class = "DButton",
				cmd = "zgo2_spawn_jars",
			},
			[ 4 ] = {
				name = "Spawn Baggies",
				class = "DButton",
				cmd = "zgo2_spawn_baggies",
			},
			[ 5 ] = {
				name = "Spawn Joints",
				class = "DButton",
				cmd = "zgo2_spawn_joints",
			},
			[ 6 ] = {
				name = "Spawn Weedblocks",
				class = "DButton",
				cmd = "zgo2_spawn_weedblocks",
			},
			[ 7 ] = {
				name = "Spawn Contract",
				class = "DButton",
				cmd = "zgo2_spawn_contract",
			},
			[ 8 ] = {
				name = "Spawn Edibles",
				class = "DButton",
				cmd = "zgo2_spawn_edibles",
			},
		})
	end)

	spawnmenu.AddToolMenuOption("Options", "zgo2_options", "zgo2_Client_Settings", "Client Settings", "", "", function(CPanel)
		zclib.Settings.OptionPanel("Lamp", "", PrimaryColor, SecondaryColor, CPanel, {
			[ 1 ] = {
				name = "DynamicLight",
				class = "DCheckBoxLabel",
				cmd = "zgo2_cl_dynlight",
			},
			[ 2 ] = {
				name = "Light Sprites",
				class = "DCheckBoxLabel",
				cmd = "zgo2_cl_lightsprite",
			},
			[ 3 ] = {
				name = "Light Beams",
				class = "DCheckBoxLabel",
				cmd = "zgo2_cl_lightbeam",
			},
		})

		zclib.Settings.OptionPanel("Plant", "", PrimaryColor, SecondaryColor, CPanel, {
			[ 1 ] = {
				name = "Smooth Grow",
				class = "DCheckBoxLabel",
				cmd = "zgo2_cl_smoothgrow",
				desc = "Makes the plants grow smoothly."
			},
			[ 2 ] = {
				name = "Skank Effect",
				class = "DCheckBoxLabel",
				cmd = "zgo2_cl_drawskank",
				desc = "Draws the Skank Effect when the plant is harvest ready."
			},
		})
	end)
end)
