if not CLIENT then return end

hook.Add("AddToolMenuCategories", "ztm_CreateCategories", function()
	spawnmenu.AddToolCategory("Options", "ztm_options", "Trashman")
end)

local mainColor = Color(201, 143, 67)
hook.Add("PopulateToolMenu", "ztm_PopulateMenus", function()
	spawnmenu.AddToolMenuOption("Options", "ztm_options", "ztm_Admin_Settings", "Admin Settings", "", "", function(CPanel)
		zclib.Settings.OptionPanel("All", nil, mainColor, zclib.colors["ui02"], CPanel, {
			[1] = {
				name = "Save",
				class = "DButton",
				cmd = "ztm_save_all"
			},
			[2] = {
				name = "Remove",
				class = "DButton",
				cmd = "ztm_remove_all"
			}
		})

		zclib.Settings.OptionPanel("Trashburners", nil, mainColor, zclib.colors["ui02"], CPanel, {
			[1] = {
				name = "Save",
				class = "DButton",
				cmd = "ztm_trashburner_save"
			},
			[2] = {
				name = "Remove",
				class = "DButton",
				cmd = "ztm_trashburner_remove"
			}
		})

		zclib.Settings.OptionPanel("Recyclers", nil, mainColor, zclib.colors["ui02"], CPanel, {
			[1] = {
				name = "Save",
				class = "DButton",
				cmd = "ztm_recycler_save"
			},
			[2] = {
				name = "Remove",
				class = "DButton",
				cmd = "ztm_recycler_remove"
			}
		})

		zclib.Settings.OptionPanel("Buyermachines", nil, mainColor, zclib.colors["ui02"], CPanel, {
			[1] = {
				name = "Save",
				class = "DButton",
				cmd = "ztm_buyermachine_save"
			},
			[2] = {
				name = "Remove",
				class = "DButton",
				cmd = "ztm_buyermachine_remove"
			}
		})

		zclib.Settings.OptionPanel("Leafpiles", nil, mainColor, zclib.colors["ui02"], CPanel, {
			[1] = {
				name = "Save",
				class = "DButton",
				cmd = "ztm_leafpile_save"
			},
			[2] = {
				name = "Refresh",
				class = "DButton",
				cmd = "ztm_leafpile_refresh"
			},
			[3] = {
				name = "Remove",
				class = "DButton",
				cmd = "ztm_leafpile_remove"
			}
		})

		zclib.Settings.OptionPanel("Manholes", nil, mainColor, zclib.colors["ui02"], CPanel, {
			[1] = {
				name = "Save",
				class = "DButton",
				cmd = "ztm_manhole_save"
			},
			[2] = {
				name = "Remove",
				class = "DButton",
				cmd = "ztm_manhole_remove"
			}
		})

		zclib.Settings.OptionPanel("Trash Spawns", nil, mainColor, zclib.colors["ui02"], CPanel, {
			[1] = {
				name = "Save",
				class = "DButton",
				cmd = "ztm_trash_save"
			},
			[2] = {
				name = "Remove",
				class = "DButton",
				cmd = "ztm_trash_remove"
			}
		})
	end)
end)
