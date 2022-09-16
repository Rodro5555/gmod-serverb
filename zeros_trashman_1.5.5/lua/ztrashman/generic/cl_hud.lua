if SERVER then return end
ztm = ztm or {}
ztm.HUD = ztm.HUD or {}

function ztm.HUD.DrawTrash(amount,pos)
    cam.Start3D2D(pos, zclib.HUD.GetLookAngles(), 0.1)
        draw.RoundedBox(5, -5, 80, 5, 250, ztm.default_colors["white01"])

        surface.SetDrawColor(ztm.default_colors["grey01"])
        surface.SetMaterial(ztm.default_materials["ztm_trash_icon"])
        surface.DrawTexturedRect(-100, -100, 200, 200)

        draw.DrawText(amount .. ztm.config.UoW, zclib.GetFont("ztm_trash_font02"), 0, -20, ztm.default_colors["black02"], TEXT_ALIGN_CENTER)
        draw.DrawText(amount .. ztm.config.UoW, zclib.GetFont("ztm_trash_font01"), 0, -20, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)
    cam.End3D2D()
end
