if SERVER then return end
zmc = zmc or {}
zmc.Grill = zmc.Grill or {}

function zmc.Grill.Initialize(Grill) end

local heat_pos = Vector(0, 0, 33)
local ui_pos = Vector(-19.7,0, 35)
local ui_ang = Angle(0, -90, 90)
function zmc.Grill.Draw(Grill)
    if zclib.util.InDistance(Grill:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_ui) then

        local QuickTimeEvent = Grill:GetQuickTimeEvent()
        if QuickTimeEvent > 0 then
            cam.Start3D2D(Grill:LocalToWorld(ui_pos), Grill:LocalToWorldAngles(ui_ang), 0.05)
                draw.RoundedBox(16, -350, -50,700, 100, zclib.colors["ui01"])
                local wBar = (700 / zmc.config.Grill.qte_respone_time) * math.Clamp(QuickTimeEvent - CurTime(), 0, zmc.config.Grill.qte_respone_time)
                draw.RoundedBox(16, -wBar / 2, -50, wBar, 100, Color(255, 0, 0, 255 - (200 * math.sin(CurTime() * 10))))
                draw.SimpleText(zmc.language["FLIP!"], zclib.GetFont("zclib_font_giant"), 0, 0, zclib.colors["text01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            cam.End3D2D()
        else
            zmc.Machine.DrawTemperatur(Grill)
        end
    end

    zmc.Machine.DrawHeat(Grill, Grill:GetTemperatur(),"zmc_grill_light_mat_" .. Grill:EntIndex(), "zerochain/props_kitchen/grill/zmc_grill", 2, heat_pos)
end

function zmc.Grill.Think(Grill)

    local temp = Grill:GetTemperatur()
    zclib.util.LoopedSound(Grill, "zmc_grill_small_loop", temp > 0 and temp < 50)
    zclib.util.LoopedSound(Grill, "zmc_grill_big_loop", temp > 50)

    zmc.Machine.DrawHeatedItems(Grill,function(ent,ItemData,slot_data)
        if ItemData.grill == nil then return end

        local ResultItemData = zmc.Item.GetData(ItemData.grill.item)

        local fract = (1 / ItemData.grill.time) * (slot_data.grill_prog or 0)

        // Change color depending on progress
        local col = zclib.util.LerpColor(fract, ItemData.color or color_white, ResultItemData.color or color_white)
        ent:SetColor(col)
    end,function(ent,x,y)
        local bound_min = ent:GetModelBounds()
        local height = math.abs(bound_min.z) * ent:GetModelScale()
        ent:SetPos(Grill:LocalToWorld(Vector(x, y, 39 + height)))

        if ent.TargetRot == nil then ent.TargetRot = 0 end
        if ent.Rot == nil then ent.Rot = 0 end
        ent.Rot = Lerp(5 * FrameTime(),ent.Rot,ent.TargetRot )
        if ent.rnd_rot == nil then ent.rnd_rot = math.random(0,360) end
        ent:SetAngles(Grill:LocalToWorldAngles(Angle(0, ent.rnd_rot, ent.Rot)))
    end)
end

function zmc.Grill.OnRemove(Grill)
    Grill:StopSound("zmc_grill_small_loop")
    Grill:StopSound("zmc_grill_big_loop")
    zmc.Machine.OnRemove(Grill)
end

function zmc.Grill.FlipItems(Grill)
    Grill:EmitSound("zmc_frying_hit")
    local delay = 0
    for k, v in pairs(Grill.OnTableDummys) do
        timer.Simple(delay,function() if IsValid(v) then v.TargetRot = (v.TargetRot or 0) + 180 end end)
        delay = delay + 0.05
    end
end
