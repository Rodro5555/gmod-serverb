if (not CLIENT) then return end

hook.Add("AddToolMenuCategories", "zrush_CreateCategories", function()
	spawnmenu.AddToolCategory("Options", "zrush_options", "OilRush")
end)

hook.Add("PopulateToolMenu", "zrush_PopulateMenus", function()
	spawnmenu.AddToolMenuOption("Options", "zrush_options", "zrush_Admin_Settings", "Admin Settings", "", "", function(CPanel)

		zclib.Settings.OptionPanel("OilSpot Zones", nil, Color(215, 47, 29), zclib.colors["ui02"], CPanel, {
			[1] = {
				name = "Remove All",
				class = "DButton",
				cmd = "zrush_OilSpotZone_remove"
			}
		})

		zclib.Settings.OptionPanel("NPC", nil, Color(215, 47, 29), zclib.colors["ui02"], CPanel, {
			[1] = {
				name = "Save",
				class = "DButton",
				cmd = "zrush_npc_save"
			},
			[2] = {
				name = "Remove",
				class = "DButton",
				cmd = "zrush_npc_remove"
			}
		})

		zclib.Settings.OptionPanel("Commands", nil, Color(215, 47, 29), zclib.colors["ui02"], CPanel, {
			[1] = {
				name = "Random Fuel Barrel",
				class = "DButton",
				cmd = "zrush_debug_spawn_fuel"
			},
			[2] = {
				name = "Oil Barrel",
				class = "DButton",
				cmd = "zrush_debug_spawn_oil"
			}
		})
	end)
end)
