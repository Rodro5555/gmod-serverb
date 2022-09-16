if SERVER then return end


hook.Add("AddToolMenuCategories", "zvm_CreateCategories", function()
    spawnmenu.AddToolCategory("Options", "zvm_options", "Vendingmachine")
end)

hook.Add("PopulateToolMenu", "zvm_PopulateMenus", function()

    spawnmenu.AddToolMenuOption("Options", "zvm_options", "zvm_Admin_Settings", "Admin Settings", "", "", function(CPanel)
        zclib.Settings.OptionPanel("Vendingmachine", nil, Color(82, 131, 198, 255), zclib.colors["ui02"], CPanel, {
            [1] = {
                name = "Save",
                desc = "Saves any public vendingmachine on the map.",
                class = "DButton",
                cmd = "zvm_save_vendingmachines"
            },
            [2] = {
                name = "Remove",
                desc = "Removes any public vendingmachine on the map.",
                class = "DButton",
                cmd = "zvm_remove_vendingmachines"
            },
            [3] = {
                name = "Rebuild",
                desc = "Rebuilds any public vendingmachine on the map.",
                class = "DButton",
                cmd = "zvm_load_vendingmachines"
            },
            [4] = {
                name = "Mirror",
                desc = "Copies the vendingmachine data you are looking at and applys it to any other vendingmachine on the map.",
                class = "DButton",
                cmd = "zvm_vendingmachine_mirror"
            },

        })
    end)
end)
