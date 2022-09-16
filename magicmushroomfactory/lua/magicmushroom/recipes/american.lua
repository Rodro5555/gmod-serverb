local recipe = {
    Name = "Sueño Americano",
    Description = [[
        Si es más noble para la mente sufrir las hondas y las flechas de la fortuna escandalosa,
        ¿O tomar las armas contra un mar de angustias, y al oponerse a ellas, acabar con ellas? Morir, dormir,
        No más.
    ]],
    Ingredients = {
        ["bluesky"] = 2,
        ["amanita"] = 2
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

                local color = HSLToColor(pf * 360, 1, .5)
                local tab = {}
                tab["$pp_colour_addr"] = color.r / 255 / 2
                tab["$pp_colour_addg"] = color.g / 255 / 2
                tab["$pp_colour_addb"] = color.b / 255 / 2
                tab["$pp_colour_brightness"] = 0
                tab["$pp_colour_contrast"] = 1
                tab["$pp_colour_colour"] = pf
                tab["$pp_colour_mulg"] = 0
                tab["$pp_colour_mulb"] = 0
                tab["$pp_colour_mulr"] = 0
                DrawMaterialOverlay("highs/shader3", pf * 0.05)
                DrawColorModify(tab)
            else
                hook.Remove("RenderScreenspaceEffects", "MMF_GetHigh_" .. recipe.Name)
            end
        end)
    end
end

return recipe