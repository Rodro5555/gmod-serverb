local recipe = {
    Name = "Las Almas Antiguas",
    Description = [[
        Descubierto en una tumba ubicada en algún lugar de una floristería secreta,
        esta receta trae el poder de ver a las almas viejas habitando este lugar pero ojo,
        puede que te sigan.
    ]],
    Ingredients = {
        ["amanita"] = 3,
        ["candy"] = 3
    },
    Bottles = 2,
    Price = 1000
}

function recipe:Effect(ply)
    local duration = 20

    ply:SetFOV(120, 10)
    timer.Simple(duration - 10, function()
        if not IsValid(ply) then return end
        ply:SetFOV(0, 10)
    end)

    if CLIENT then
        local starttime = CurTime()

        hook.Add("RenderScreenspaceEffects", "MMF_GetHigh_" .. recipe.Name, function()
            if starttime + duration > CurTime() then
                local pf = (CurTime() - starttime) / duration * 2

                if pf >= 1 then
                    pf = 2 - pf
                end

                ply:SetDSP(12)
                DrawMotionBlur(0.1, 1 * pf, 0.01)
                DrawMaterialOverlay("effects/water_warp01", -0.1 * pf)
                DrawBloom(0, 0.4 * pf, 0, 0, 10, 20, 1, 1, 1)
                DrawSobel(1 - pf)
            else
                hook.Remove("RenderScreenspaceEffects", "MMF_GetHigh_" .. recipe.Name)
            end
        end)
    end
end

return recipe