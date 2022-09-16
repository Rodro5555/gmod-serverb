local recipe = {
    Name = "Dama de Palmdale",
    Description = [[
        Después de numerosas ceremonias y sacrificios, los historiadores encontraron algunos restos de
        los cadáveres, y en medio de eso, una poción, creen que la dejaron los demonios.
    ]],
    Ingredients = {
        ["witcher"] = 1,
        ["bluesky"] = 2,
        ["amanita"] = 1,
        ["cubensis"] = 1
    },
    Bottles = 2,
    Price = 1000
}

if CLIENT then
    function recipe:Effect(ply)
        local starttime = CurTime()
        local duration = 20
        local cdw, cdw2, cdw3 = nil, -1, nil

        hook.Add("RenderScreenspaceEffects", "MMF_GetHigh_" .. recipe.Name, function()
            if starttime + duration > CurTime() then
                local pf = (CurTime() - starttime) / duration * 2

                if pf >= 1 then
                    pf = 2 - pf
                end

                if not cdw or cdw < CurTime() then
                    cdw = CurTime() + 0.5
                    cdw2 = cdw2 * -1
                end

                if cdw2 == -1 then
                    cdw3 = 2
                else
                    cdw3 = 0
                end

                local ich = (cdw2 * ((cdw - CurTime()) * (2 / 0.5))) + cdw3 - 1
                local gah = pf * (ich + 1)
                local tab = {}
                tab["$pp_colour_addg"] = 0
                tab["$pp_colour_addb"] = 0
                tab["$pp_colour_brightness"] = 0
                tab["$pp_colour_contrast"] = 1
                tab["$pp_colour_colour"] = 1
                tab["$pp_colour_mulg"] = 0
                tab["$pp_colour_mulb"] = 0
                tab["$pp_colour_mulr"] = 0
                tab["$pp_colour_addr"] = gah
                DrawMaterialOverlay("highs/shader3", pf * ich * 0.05)
                DrawColorModify(tab)
            else
                hook.Remove("RenderScreenspaceEffects", "MMF_GetHigh_" .. recipe.Name)
            end
        end)
    end
end

return recipe