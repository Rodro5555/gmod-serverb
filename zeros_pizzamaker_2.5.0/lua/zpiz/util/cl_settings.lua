if not CLIENT then return end

hook.Add("AddToolMenuCategories", "zpiz_CreateCategories", function()
	spawnmenu.AddToolCategory("Options", "zpiz_options", "PizzaMaker")
end)

hook.Add("PopulateToolMenu", "zpiz_PopulateMenus", function()
	spawnmenu.AddToolMenuOption("Options", "zpiz_options", "zpiz_Admin_Settings", "Admin Settings", "", "", function(CPanel)
		zclib.Settings.OptionPanel("Public Setup", nil, Color(179, 135, 84, 255), zclib.colors["ui02"], CPanel, {
			[1] = {
				name = "Save",
				class = "DButton",
				cmd = "zpiz_save"
			},
			[2] = {
				name = "Remove",
				class = "DButton",
				cmd = "zpiz_remove"
			}
		})

		zclib.Settings.OptionPanel("Pizza", nil, Color(179, 135, 84, 255), zclib.colors["ui02"], CPanel, {
			[1] = {
				name = "Spawn All",
				class = "DButton",
				cmd = "zpiz_pizza_all"
			},
		})
	end)


end)
