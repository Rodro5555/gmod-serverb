if not CLIENT then return end
zmlab2 = zmlab2 or {}
zmlab2.Storage = zmlab2.Storage or {}

function zmlab2.Storage.DrawUI(Storage)
    if zclib.util.InDistance(LocalPlayer():GetPos(),Storage:GetPos(), 1000) and zclib.Convar.Get("zmlab2_cl_drawui") == 1 then
        cam.Start3D2D(Storage:LocalToWorld(Vector(0, 13.5, 40)), Storage:LocalToWorldAngles(Angle(0, 180, 90)), 0.1)
            local txtSize = zclib.util.GetTextSize(zmlab2.language["Storage"], zclib.GetFont("zmlab2_font02"))
            local barSize = txtSize * 1.1
            draw.RoundedBox(0, -barSize / 2, -48, barSize, 48, zclib.colors["black_a200"])
            local nextTime = math.Clamp(Storage:GetNextPurchase() - CurTime(), 0, zmlab2.config.Storage.BuyInterval)

            if nextTime > 0 then
                draw.RoundedBox(0, -barSize / 2, -48, (barSize / zmlab2.config.Storage.BuyInterval) * nextTime, 48, zmlab2.colors["orange01"])
            end

            zclib.util.DrawOutlinedBox(-barSize / 2, -48, barSize, 48, 2, color_white)
            draw.SimpleText(zmlab2.language["Storage"], zclib.GetFont("zmlab2_font02"), 0, -23, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end

function zmlab2.Storage.Initialize(Storage) end
function zmlab2.Storage.OnRemove(Storage) end
