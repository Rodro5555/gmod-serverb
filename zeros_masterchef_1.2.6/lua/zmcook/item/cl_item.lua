if SERVER then return end
zmc = zmc or {}
zmc.Item = zmc.Item or {}

// Is used by both the Item and the Dish Entity
local ui_offset = Vector(0, 0, 20)
function zmc.Item.DrawName(Item,name)
    if zclib.Convar.Get("zclib_cl_drawui") ~= 1 then return end
    if zclib.Convar.Get("zmc_vfx_itemhud") ~= 1 then return end
    if zmc.config.HideItemHUD == true then return end

    // Dont render the item name if we are in third person
    if GetViewEntity() ~= LocalPlayer() then return end

    if Item.UIData and Item.UIData.Rotten == nil and Item.GetIsRotten and Item:GetIsRotten() == true then
        Item.UIData = nil
    end

    if zclib.util.InDistance(Item:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_item_ui) then
        if Item.UIData == nil then

            local IsRotten = nil
            if Item.GetIsRotten and Item:GetIsRotten() == true then
                name = name .. " " .. zmc.language["Spoiled"]
                IsRotten = true
            end

            local size = zclib.util.GetTextSize(name, zclib.GetFont("zclib_font_huge"))
            size = size + 50

            Item.UIData = {
                BoxSize = size,
                Name = name,
                Rotten = IsRotten
            }
        else
            cam.Start3D2D(Item:GetPos() + ui_offset, Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.05)
                draw.RoundedBox(16, -Item.UIData.BoxSize / 2, -40, Item.UIData.BoxSize, 80, zclib.colors["ui01"])
                draw.SimpleText(Item.UIData.Name, zclib.GetFont("zclib_font_huge"), 0, 0, zclib.colors["text01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            cam.End3D2D()
        end
    end
end


function zmc.Item.Initialize(Item)

end

function zmc.Item.Draw(Item)
    zmc.Item.DrawName(Item,zmc.Item.GetName(Item:GetItemID()))
end
