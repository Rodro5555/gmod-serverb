local recipe = {
    Name = "Buenos Días",
    Description = [[
        Descubierto en una mañana de 1938 por Dom Hofmann en el laboratorio de Suiza,
        después de la manipulación continua del producto de una de las sustancias aisladas,
        se vio obligado a interrumpir el trabajo que estaba haciendo en ese momento
        momento debido a los síntomas alucinatorios por los que estaba pasando.
    ]],
    Ingredients = {
        ["candy"] = 2,
        ["amanita"] = 1,
        ["cubensis"] = 2
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

                local shroom_tab = {}
                shroom_tab["$pp_colour_addr"] = 0
                shroom_tab["$pp_colour_addg"] = 0
                shroom_tab["$pp_colour_addb"] = 0
                shroom_tab["$pp_colour_mulr"] = 0
                shroom_tab["$pp_colour_mulg"] = 0
                shroom_tab["$pp_colour_mulb"] = 0
                shroom_tab["$pp_colour_colour"] = pf * 5
                shroom_tab["$pp_colour_brightness"] = 0
                shroom_tab["$pp_colour_contrast"] = pf * 0.5
                DrawColorModify(shroom_tab)
                LocalPlayer():SetDSP(1)
                DrawMotionBlur(0.1, 1 * pf, 0.01)
                DrawMaterialOverlay("effects/water_warp01", -0.1 * pf)
                DrawSharpen(20 * pf, 1)
            else
                hook.Remove("RenderScreenspaceEffects", "MMF_GetHigh_" .. recipe.Name)
            end
        end)
    end
end

return recipe