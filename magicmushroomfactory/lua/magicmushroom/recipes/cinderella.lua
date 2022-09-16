local recipe = {
    Name = "Cenicienta",
    Description = [[
        También descubierto por ceifador en la selva amazónica,
        Aparentemente, este hongo te hará sentir lo suficientemente alto como para permanecer despierto durante 4 noches.
    ]],
    Ingredients = {
        ["witcher"] = 4,
        ["bluesky"] = 2
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
                shroom_tab["$pp_colour_brightness"] = -pf * 0.21
                shroom_tab["$pp_colour_contrast"] = pf * 0.5
                DrawColorModify(shroom_tab)
                LocalPlayer():SetDSP(1)
                DrawBloom(0, 0.4 * pf, 0, 0, 10, 20, 1, 1, 1)
                DrawSharpen(5 * pf, 20)
                DrawSobel((1 - pf) * 0.15)
                DrawMotionBlur(0.1, 1 * pf, 0.01)
                DrawMaterialOverlay("effects/water_warp01", -0.1 * pf)
            else
                hook.Remove("RenderScreenspaceEffects", "MMF_GetHigh_" .. recipe.Name)
            end
        end)
    end
end

return recipe