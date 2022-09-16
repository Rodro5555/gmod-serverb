if SERVER then return end
zmc = zmc or {}
zmc.Oven = zmc.Oven or {}

function zmc.Oven.Initialize(Oven) end

local heat_pos = Vector(0, 0, 55)
function zmc.Oven.Draw(Oven)
    zmc.Machine.DrawTemperatur(Oven)

    zmc.Machine.DrawHeat(Oven, Oven:GetTemperatur(), "zmc_oven_light_mat_" .. Oven:EntIndex(), "zerochain/props_kitchen/oven/zmc_oven", 3, heat_pos)
end

function zmc.Oven.Think(Oven)

    zmc.Machine.DrawHeatedItems(Oven,function(ent,ItemData,slot_data)
        if ItemData.bake == nil then return end
        local ResultItemData = zmc.Item.GetData(ItemData.bake.item)
        local fract = (1 / ItemData.bake.time) * (slot_data.bake_prog or 0)

        // Change color depending on progress
        local col = zclib.util.LerpColor(fract, ItemData.color or color_white, ResultItemData.color or color_white)
        ent:SetColor(col)
    end,function(ent,x,y)

        local bound_min = ent:GetRenderBounds()
        local height = math.abs(bound_min.z) * ent:GetModelScale()
        ent:SetPos(Oven:LocalToWorld(Vector(x, y, 41.5 + height)))
        ent:SetAngles(Oven:LocalToWorldAngles(angle_zero))
    end)
end

function zmc.Oven.OnRemove(Oven)
    zmc.Machine.OnRemove(Oven)
end
