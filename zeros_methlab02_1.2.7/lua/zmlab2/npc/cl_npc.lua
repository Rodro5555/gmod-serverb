if not CLIENT then return end
zmlab2 = zmlab2 or {}
zmlab2.NPC = zmlab2.NPC or {}

function zmlab2.NPC.Initialize(NPC)

end

function zmlab2.NPC.Draw(NPC)
    NPC:DrawModel()

    if zmlab2 and zclib and zclib.util and zclib.util.InDistance(NPC:GetPos(), LocalPlayer():GetPos(), 500) and zclib.Convar.Get("zmlab2_cl_drawui") == 1 then
        cam.Start3D2D(NPC:LocalToWorld(Vector(0, 0, 80)), Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.1)
            draw.RoundedBox(0, -150, -30, 300, 60, zclib.colors["black_a100"])
            draw.SimpleText(zmlab2.config.NPC.Name, zclib.GetFont("zmlab2_font02"), 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            zclib.util.DrawOutlinedBox(-150, -30, 300, 60, 4, color_white)
        cam.End3D2D()
    end
end
