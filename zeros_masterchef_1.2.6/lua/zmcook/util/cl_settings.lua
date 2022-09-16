if SERVER then return end

hook.Add("AddToolMenuCategories", "zmc_CreateCategories", function()
    spawnmenu.AddToolCategory("Options", "zmc_options", "MasterCook")
end)

hook.Add("PopulateToolMenu", "zmc_PopulateMenus", function()
    spawnmenu.AddToolMenuOption("Options", "zmc_options", "zmc_Admin_Settings", "Admin Settings", "", "", function(CPanel)
        zclib.Settings.OptionPanel("Public Setup", "Saves machines as a public utility.", Color(151, 184, 79), zclib.colors["ui02"], CPanel, {
            [1] = {
                name = "Save",
                class = "DButton",
                cmd = "zmc_save"
            },
            [2] = {
                name = "Delete",
                class = "DButton",
                cmd = "zmc_remove"
            }
        })
        zclib.Settings.OptionPanel("Utility", "A bunch of usefull commands.", Color(151, 184, 79), zclib.colors["ui02"], CPanel, {
            [1] = {
                name = "Open Item Config",
                class = "DButton",
                cmd = "zmc_config_open"
            },
            [2] = {
                name = "Copy Item Config to Clipboard",
                class = "DButton",
                cmd = "zmc_GetItemConfig"
            },
            [3] = {
                name = "Copy Dish Config to Clipboard",
                class = "DButton",
                cmd = "zmc_GetDishConfig"
            },
            [4] = {
                name = "Spawn All Items",
                class = "DButton",
                cmd = "zmc_spawn_item_all"
            },
            [5] = {
                name = "Spawn All Dishes",
                class = "DButton",
                cmd = "zmc_spawn_dish_all"
            },
        })
    end)

    spawnmenu.AddToolMenuOption("Options", "zmc_options", "zmc_Client_Settings", "Client Settings", "", "", function(CPanel)
        zclib.Settings.OptionPanel("VFX", "", Color(151, 184, 79), zclib.colors["ui02"], CPanel, {
            [1] = {
                name = "Dynamiclight",
                class = "DCheckBoxLabel",
                cmd = "zmc_vfx_dynamiclight"
            },
            [2] = {
                name = "Dish Model Clipping",
                class = "DCheckBoxLabel",
                cmd = "zmc_vfx_dishclipping",
            },
            [3] = {
                name = "Dish HUD",
                class = "DCheckBoxLabel",
                cmd = "zmc_vfx_dishhud",
            },
            [4] = {
                name = "Item HUD",
                class = "DCheckBoxLabel",
                cmd = "zmc_vfx_itemhud",
            }
        })
    end)
end)
