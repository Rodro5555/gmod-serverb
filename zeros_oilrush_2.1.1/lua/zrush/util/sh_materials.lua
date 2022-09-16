AddCSLuaFile()
zrush = zrush or {}

zrush.default_materials = zrush.default_materials or {}
zrush.default_materials["barrel_scalar"] = Material("materials/zerochain/zrush/ui/ui_barrel_scalar.png", "smooth")
zrush.default_materials["barrel_icon"] = Material("materials/zerochain/zrush/ui/ui_barrel_icon.png")
zrush.default_materials["shadow_circle"] = Material("materials/zerochain/zrush/ui/zrush_shadow_circle.png", "smooth")
zrush.default_materials["glam_circle"] = Material("materials/zerochain/zrush/ui/zrush_glam_circle.png", "smooth")
zrush.default_materials["ui_circle_selection"] = Material("materials/zerochain/zrush/ui/ui_circle_selection.png", "smooth")
zrush.default_materials["circle_refining"] = Material("materials/zerochain/zrush/ui/zrush_refining_icon.png", "smooth")
zrush.default_materials["ui_action_button"] = Material("materials/zerochain/zrush/ui/ui_action_button.png", "smooth")
zrush.default_materials["zrush_cooldown_icon"] = Material("materials/zerochain/zrush/ui/zrush_cooldown_icon.png", "smooth")
zrush.default_materials["zrush_start_icon"] = Material("materials/zerochain/zrush/ui/zrush_start_icon.png", "smooth")
zrush.default_materials["zrush_stop_icon"] = Material("materials/zerochain/zrush/ui/zrush_stop_icon.png", "smooth")
zrush.default_materials["zrush_dissamble_icon"] = Material("materials/zerochain/zrush/ui/zrush_dissamble_icon.png", "smooth")
zrush.default_materials["ui_action_button_hover"] = Material("materials/zerochain/zrush/ui/ui_action_button_hover.png", "smooth")
zrush.default_materials["ui_action_button_shine"] = Material("materials/zerochain/zrush/ui/ui_action_button_shine.png", "smooth")
zrush.default_materials["module_speed"] = Material("materials/zerochain/zrush/ui/zrush_module_speed.png", "smooth")
zrush.default_materials["module_production"] = Material("materials/zerochain/zrush/ui/zrush_module_production.png", "smooth")
zrush.default_materials["module_antijam"] = Material("materials/zerochain/zrush/ui/zrush_module_antijam.png", "smooth")
zrush.default_materials["module_cooling"] = Material("materials/zerochain/zrush/ui/zrush_module_cooling.png", "smooth")
zrush.default_materials["module_morepipes"] = Material("materials/zerochain/zrush/ui/zrush_module_morepipes.png", "smooth")
zrush.default_materials["module_refining"] = Material("materials/zerochain/zrush/ui/zrush_module_refining.png", "smooth")

zrush.default_colors = zrush.default_colors or {}
zrush.default_colors["grey01"] = Color(125, 125, 125)
zrush.default_colors["grey02"] = Color(75, 75, 75)
zrush.default_colors["black02"] = Color(0, 0, 0, 200)
zrush.default_colors["black03"] = Color(0, 0, 0, 25)
zrush.default_colors["black04"] = Color(0, 0, 0, 125)
zrush.default_colors["white02"] = Color(255, 255, 255, 200)
zrush.default_colors["white03"] = Color(255, 255, 255, 35)
zrush.default_colors["red04"] = Color(255, 30, 30)
zrush.default_colors["green04"] = Color(30, 255, 30)
zrush.default_colors["green05"] = Color(75, 255, 75, 255)


zrush.default_colors["green01"] = Color(0, 255, 0, 100)
zrush.default_colors["white01"] = Color(255, 255, 255, 100)
zrush.default_colors["red01"] = Color(255, 0, 0, 100)


if zrush.FuelTypes then
    // A darken version of the fuel color used on the barrel
    zrush.darken_fuelcolors = zrush.darken_fuelcolors or {}
    for k, v in pairs(zrush.FuelTypes) do
        local lColor = zrush.FuelTypes[k].color
        zrush.darken_fuelcolors[k] = Color(lColor.r * 0.5, lColor.g * 0.5, lColor.b * 0.5, lColor.a)
    end

    // A translucent version of the fuel colors used in the refinery
    zrush.trans_fuelcolors = zrush.trans_fuelcolors or {}
    for k, v in pairs(zrush.FuelTypes) do
        local lColor = zrush.FuelTypes[k].color
        zrush.trans_fuelcolors[k] = Color(lColor.r * 0.25, lColor.g * 0.25, lColor.b * 0.25, lColor.a * 0.95)
    end
end
