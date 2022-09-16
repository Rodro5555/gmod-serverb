local recipe = {
    Name = "Metamorfosis",
    Description = [[
        En medio de una expedición en 1853, unos científicos vieron
        una botella púrpura brillante pegada en las rocas, después de examinar
        se dieron cuenta de que tenía más que efectos esclarecedores.
    ]],
    Ingredients = {
        ["witcher"] = 5
    },
    Bottles = 2,
    Price = 1000
}

if CLIENT then
    function recipe:Effect(ply)
        local starttime = CurTime()
        local duration = 20

        hook.Add("RenderScreenspaceEffects", "MMF_GetHigh_" .. recipe.Name, function()
            if starttime + duration > CurTime() then
                local pf = (CurTime() - starttime) / duration * 2

                if pf >= 1 then
                    pf = 2 - pf
                end

                local tab = {}
                tab["$pp_colour_addr"] = 0
                tab["$pp_colour_addg"] = 0
                tab["$pp_colour_addb"] = 0
                tab["$pp_colour_brightness"] = 0
                tab["$pp_colour_contrast"] = pf * 5
                tab["$pp_colour_colour"] = pf * -5
                tab["$pp_colour_mulr"] = 1
                tab["$pp_colour_mulg"] = 1
                tab["$pp_colour_mulb"] = 1
                DrawColorModify(tab)
                DrawMaterialOverlay("effects/water_warp01", 0.2 * pf)
            else
                hook.Remove("RenderScreenspaceEffects", "MMF_GetHigh_" .. recipe.Name)
            end
        end)
    end
end

return recipe