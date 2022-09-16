if SERVER then return end
zmc = zmc or {}
zmc.Item = zmc.Item or {}

zmc.Item.Component = zmc.Item.Component or {}
zmc.Item.Component.Definition = {
    ["temp_req"] = {name = zmc.language["temp_req_title"],min = 5,max = 90,tooltip = zmc.language["temp_req_tooltip"]},
    ["time"] = {name = zmc.language["time_title"],min = 10,max = 600,tooltip = zmc.language["time_tooltip"]},
    ["item"] = {tooltip = zmc.language["item_tooltip"]},
    ["cycle"] = {name = zmc.language["cycle_title"],min = 1,max = 60,tooltip = zmc.language["cycle_tooltip"]},
    ["speed"] = {name = zmc.language["speed_title"],min = 1,max = 10,tooltip = zmc.language["speed_tooltip"]},
    ["amount"] = {name = zmc.language["amount_title"],min = 1,max = 60,tooltip = zmc.language["amount_tooltip"]},
    ["price"] = {name = zmc.language["price_title"],tooltip = zmc.language["price_tooltip"]},
    ["items"] = {tooltip = zmc.language["items_generic_tooltip"]},
    ["health"] = {name = zmc.language["health_title"],tooltip = zmc.language["health_tooltip"]},
    ["health_cap"] = {name = zmc.language["health_cap_title"],tooltip = zmc.language["health_cap_tooltip"]},
    ["range"] = {name = zmc.language["range_title"],min = 0.1,max = 0.5,tooltip = zmc.language["range_tooltip"]},
}

// Returns a tooltip for the specified component / parameter
function zmc.Item.GetTooltip(component,parameter)
    // Overwrites the tooltip in this situation
    if component == "cut" and parameter == "items" then return zmc.language["items_cut_tooltip"] end

    return zmc.Item.Component.Definition[parameter] and zmc.Item.Component.Definition[parameter].tooltip or ""
end
