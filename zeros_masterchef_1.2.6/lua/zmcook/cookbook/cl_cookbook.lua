if SERVER then return end
zmc = zmc or {}
zmc.Cookbook = zmc.Cookbook or {}
-- Is used by both the Cookbook and the Dish Entity
local ui_offset = Vector(0, 0, 20)

function zmc.Cookbook.Initialize(Cookbook)
end

function zmc.Cookbook.Draw(Cookbook)
    if zclib.Convar.Get("zclib_cl_drawui") ~= 1 then return end
    /*
    cam.Start3D2D(Cookbook:GetPos() + ui_offset, Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.05)
        draw.RoundedBox(16, -200, -40, 400, 80, zclib.colors["ui01"])
        draw.SimpleText(zmc.language["Cookbook"], zclib.GetFont("zclib_font_huge"), 0, 0, zclib.colors["text01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    cam.End3D2D()
    */

    // Dont render the item name if we are in third person
    if GetViewEntity() ~= LocalPlayer() then return end

    if zclib.util.InDistance(Cookbook:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_item_ui) then
        if Cookbook.UIData == nil then
            local size = zclib.util.GetTextSize(zmc.language["Cookbook"], zclib.GetFont("zclib_font_huge"))
            size = size + 50

            Cookbook.UIData = {
                BoxSize = size,
                Name = zmc.language["Cookbook"],
            }
        else
            cam.Start3D2D(Cookbook:GetPos() + ui_offset, Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.05)
                draw.RoundedBox(16, -Cookbook.UIData.BoxSize / 2, -40, Cookbook.UIData.BoxSize, 80, zclib.colors["ui01"])
                draw.SimpleText(Cookbook.UIData.Name, zclib.GetFont("zclib_font_huge"), 0, 0, zclib.colors["text01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            cam.End3D2D()
        end
    end
end
