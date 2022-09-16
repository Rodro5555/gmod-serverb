if SERVER then return end
zmc = zmc or {}
zmc.Inventory = zmc.Inventory or {}

/*

    This inventory system does not get saved and is only used to temporarly store items

*/

zmc.Inventory.SelectedItem = nil

function zmc.Inventory.VGUI(parent,invdata,CanSelect,OnSelect,PreDraw,PostDraw,ExtraData)
    zclib.Debug("zmc.Inventory.VGUI")

    if IsValid(parent.Inventory) then parent.Inventory:Remove() end

    local list,scroll = zmc.vgui.List(parent)
    list:DockMargin(10 * zclib.wM,5 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
    scroll:DockMargin(50 * zclib.wM,0 * zclib.hM,50 * zclib.wM,10 * zclib.hM)
    scroll.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
    end
    parent.Inventory = scroll
    scroll:InvalidateParent(true)


    local title = zmc.language["Inventory:"]
    if ExtraData and ExtraData.title then title = ExtraData.title end

    local top_pnl = vgui.Create("DPanel",scroll)
    top_pnl:SetSize(500 * zclib.wM, 50 * zclib.hM)
    top_pnl:Dock(TOP)
    top_pnl.Paint = function(s,w, h)
        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
        draw.SimpleText(title, zclib.GetFont("zclib_font_medium"), 10 * zclib.wM,20 * zclib.hM,zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    top_pnl:DockPadding(10 * zclib.wM,10 * zclib.hM,15 * zclib.wM,5 * zclib.hM)
    scroll.top_pnl = top_pnl

    if ExtraData and ExtraData.ShowDropButton then
        local drop_button = zclib.vgui.TextButton(0,0,150,50,top_pnl,{Text01 = zmc.language["Drop"]},function()
            local slot_data = zmc.Inventory.GetSlotData(zmc.vgui.ActiveEntity,zmc.Inventory.SelectedItem)
            if slot_data == nil then return end

            zmc.Inventory.Drop(zmc.vgui.ActiveEntity,zmc.Inventory.SelectedItem)
        end,function()
            return zmc.Inventory.SelectedItem == nil
        end)
        drop_button:Dock(RIGHT)
        drop_button:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        drop_button:SetTooltip(zmc.language["tooltip_drop"])
        drop_button.txt_font = zclib.GetFont("zclib_font_medium")
        drop_button.color = zclib.colors["ui_highlight"]
        drop_button.txt_color = zclib.colors["text01"]

        local throw_button = zclib.vgui.TextButton(0,0,150,50,top_pnl,{Text01 = zmc.language["Throw"]},function()
            local slot_data = zmc.Inventory.GetSlotData(zmc.vgui.ActiveEntity,zmc.Inventory.SelectedItem)
            if slot_data == nil then return end

            zmc.Inventory.ThrowItem(zmc.vgui.ActiveEntity, zmc.Inventory.SelectedItem)
        end,function()
            return zmc.Inventory.SelectedItem == nil
        end)
        throw_button:Dock(RIGHT)
        throw_button:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        throw_button:SetTooltip(zmc.language["Throw_tooltip"])
        throw_button.txt_font = zclib.GetFont("zclib_font_medium")
        throw_button.color = zclib.colors["ui_highlight"]
        throw_button.txt_color = zclib.colors["text01"]
    end

    local itmW,itmH = 100, 100
    local ItemSize
    if ExtraData then
        if ExtraData.ItemSize then ItemSize = ExtraData.ItemSize end
        if ExtraData.SizeW then itmW = ExtraData.SizeW end
        if ExtraData.SizeH then itmH = ExtraData.SizeH end
    end

    zmc.Inventory.SelectedItem = nil

    scroll.Items = {}

    scroll.UpdateItem = function(selfi,slot_id,slot_data)
        if slot_data == nil then return end

        local ItemData = zmc.Item.GetData(slot_data.itm)
        //if ItemData == nil then return end

        local item_pnl = scroll.Items[slot_id]

        if not IsValid(item_pnl) then

            item_pnl = zmc.vgui.Slot(ItemData,function()
                //IsSelected
                return zmc.Inventory.SelectedItem == slot_id
            end,function(itmDat)
                // CanSelect
                if zmc.Inventory.SlotIsEmpty(zmc.vgui.ActiveEntity,slot_id) == true then
                    return false
                else
                    local _,canselect = xpcall( CanSelect, function() end, itmDat ,slot_data)
                    return canselect
                end
            end,function()

                // OnSelect
                zmc.Inventory.SelectedItem = slot_id
                pcall(OnSelect,slot_id)
            end,function(w,h,s,itmDat)

                // PreDraw
                if PreDraw then
                    pcall(PreDraw,w,h,s,itmDat)
                end
            end,function(w,h,s,itmDat)

                // PostDraw
                if PostDraw then
                    pcall(PostDraw,w,h,s,itmDat)
                end
            end)

            item_pnl.slot_id = slot_id
            item_pnl.slot_data = slot_data

            item_pnl:SetSize((ItemSize or itmW) * zclib.wM, (ItemSize or itmH) * zclib.hM)

            list:Add(item_pnl)
            if scroll.Items == nil then scroll.Items = {} end
            scroll.Items[slot_id] = item_pnl
        else
            item_pnl:UpdateModel(ItemData)
            item_pnl.slot_id = slot_id
            item_pnl.slot_data = slot_data
        end

        // If the Item which we are Build / Updated is baking then lets update its color depending on Baking progress
        if slot_data.bake_prog and ItemData.bake then
            local ResultItemData = zmc.Item.GetData(ItemData.bake.item)
            if ResultItemData == nil then return end

            local col = zclib.util.LerpColor((1 / ItemData.bake.time) * (slot_data.bake_prog or 0), ItemData.color or color_white, ResultItemData.color or color_white)
            item_pnl:SetColor(col)
        end

        // If the Item which we are Build / Updated is grilling then lets update its color depending on Baking progress
        if slot_data.grill_prog and ItemData.grill then
            local ResultItemData = zmc.Item.GetData(ItemData.grill.item)
            if ResultItemData == nil then return end

            local col = zclib.util.LerpColor((1 / ItemData.grill.time) * (slot_data.grill_prog or 0), ItemData.color or color_white, ResultItemData.color or color_white)
            item_pnl:SetColor(col)
        end
    end

    scroll.Update = function(s,inv)
        for slot_id, slot_data in pairs(inv) do
            scroll:UpdateItem(slot_id,slot_data)
            if zmc.Inventory.SelectedItem == nil and slot_data and zmc.Inventory.SlotIsEmpty(zmc.vgui.ActiveEntity,slot_id) == false then
                zmc.Inventory.SelectedItem = slot_id
            end
        end

        if zmc.Inventory.SelectedItem then
            pcall(OnSelect,zmc.Inventory.SelectedItem)
        end
    end
    scroll:Update(invdata)

    return scroll , list
end
