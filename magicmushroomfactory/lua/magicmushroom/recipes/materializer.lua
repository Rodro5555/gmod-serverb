local recipe = {
    Name = "Anti Materializador",
    Description = [[
        Esta receta la descubrió un adicto al crack en Río de Janeiro,
        probablemente llegarás tan alto que no verás nada.
    ]],
    Ingredients = {
        ["cubensis"] = 2,
        ["candy"] = 1,
        ["amanita"] = 4
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
                shroom_tab["$pp_colour_colour"] = 5
                shroom_tab["$pp_colour_brightness"] = -0.7
                shroom_tab["$pp_colour_contrast"] = 0.5
                DrawColorModify(shroom_tab)
                LocalPlayer():SetDSP(1)
                DrawBloom(0, 0.4 * pf, 0, 50, 10, 50, 1, 1, 1)
                DrawSobel((1 - pf) * 0.3)
                DrawMotionBlur(0.1, 1 * pf, 0.01)
                DrawMaterialOverlay("effects/water_warp01", -0.1 * pf)
            else
                hook.Remove("RenderScreenspaceEffects", "MMF_GetHigh_" .. recipe.Name)
            end
        end)
    end
end

return recipe