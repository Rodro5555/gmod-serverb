if SERVER then return end
zmc = zmc or {}
zmc.Fridge = zmc.Fridge or {}

net.Receive("zmc_fridge_open", function(len)
    zclib.Debug_Net("zmc_fridge_open", len)

    zmc.vgui.ActiveEntity = net.ReadEntity()
    if not IsValid(zmc.vgui.ActiveEntity) then return end

    local dataLength = net.ReadUInt(16)
    local dataDecompressed = util.Decompress(net.ReadData(dataLength))
    local list = util.JSONToTable(dataDecompressed)
    zmc.vgui.ActiveEntity.BuyWhitelist = {}
    for k,v in pairs(list) do
        zmc.vgui.ActiveEntity.BuyWhitelist[tostring(k)] = true
    end

    zmc.Fridge.OpenInterface()
end)

local BuyWhitelist = {}
function zmc.Fridge.OpenInterface()
    zmc.vgui.Page(zmc.language["Fridge"],function(main,top)

        local close_btn = zclib.vgui.ImageButton(940 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("close"),function()
            zmc_main_panel:Close()
        end,false)
        close_btn:Dock(RIGHT)
        close_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        close_btn.IconColor = zclib.colors["red01"]


        // Edit
        if zclib.Player.IsAdmin(LocalPlayer()) then
            local seperator = zmc.vgui.AddSeperator(top)
            seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
            seperator:Dock(RIGHT)
            seperator:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)

            // Whitelist
            local whitelist_btn = zclib.vgui.ImageButton(480 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("whitelist"),function()
                BuyWhitelist = zmc.vgui.ActiveEntity.BuyWhitelist or {}
                zmc.Fridge.EditWhitelist()
            end,function()
                return false
            end)
            whitelist_btn:Dock(RIGHT)
            whitelist_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
            whitelist_btn.IconColor = zclib.colors["orange01"]
            whitelist_btn:SetTooltip(zmc.language["Whitelist Editor"])
        end

        local seperator = zmc.vgui.AddSeperator(top)
        seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
        seperator:Dock(RIGHT)
        seperator:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)

        local SelectedFilter = zmc.language["All"]
        local function RebuildList(search_input)
            if not IsValid(main) then return end
            if IsValid(main.ItemList) then main.ItemList:Remove() end

            local list,scroll = zmc.vgui.List(main)
            scroll:DockMargin(50 * zclib.wM,5 * zclib.hM,50 * zclib.wM,10 * zclib.hM)
            scroll.Paint = function(s, w, h)
                draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
            end
            main.ItemList = scroll

            for id, data in pairs(zmc.config.Items) do

                if data.fridge == nil then continue end

                if zmc.vgui.ActiveEntity.BuyWhitelist and table.Count(zmc.vgui.ActiveEntity.BuyWhitelist) > 0 and zmc.vgui.ActiveEntity.BuyWhitelist[tostring(data.uniqueid)] == nil then continue end

                if search_input ~= nil and search_input ~= "" and search_input ~= " " then
                    if string.find( data.name:lower(), search_input ) == nil then continue end
                else
                    if zmc.Item.Components[SelectedFilter] and data[SelectedFilter] == nil then continue end
                end

                local money = zclib.Money.Display(data.fridge.price)

                local item_pnl = zmc.vgui.Slot(data,function()

                    //IsSelected
                    return false
                end,function()

                    // CanSelect
                    return true
                end,function()

                    // OnSelect

                    if zmc.Item.GetData(id) then
                        net.Start("zmc_fridge_buy")
                        net.WriteEntity(zmc.vgui.ActiveEntity)
                        net.WriteUInt(id,16)
                        net.SendToServer()
                    end
                end,function(w,h,s)

                    // PreDraw
                end,function(w,h,s,dat)

                    // PostDraw

                    if s:IsHovered() then

                        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["green01"])
                        draw.RoundedBox(5, w * 0.02, h * 0.02, w * 0.96, h * 0.96, zclib.colors["ui01"])

                        draw.SimpleText(zmc.language["Buy"], zclib.GetFont("zclib_font_big"), w / 2, h / 2,zclib.colors["green01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                        if dat and dat.name then

                            draw.RoundedBox(5, 0, h * 0.8, w, h * 0.2, zclib.colors["black_a100"])

                            local txtW = zclib.util.GetTextSize(dat.name, s.font_name)
                            if txtW > w * 0.9 then
                                if s.font_name == zclib.GetFont("zclib_font_mediumsmall") then
                                    s.font_name = zclib.GetFont("zclib_font_small")
                                elseif s.font_name == zclib.GetFont("zclib_font_small") then
                                    s.font_name = zclib.GetFont("zclib_font_tiny")
                                elseif s.font_name == zclib.GetFont("zclib_font_tiny") then
                                    s.font_name = zclib.GetFont("zclib_font_nano")
                                end
                            end
                            draw.SimpleText(dat.name, s.font_name, w / 2, h * 0.9,color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        end
                    else
                        draw.SimpleText(money, zclib.GetFont("zclib_font_mediumsmall"), w - 10 * zclib.hM, 10 * zclib.hM,zclib.colors["green01"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
                    end
                end)
                list:Add(item_pnl)
                item_pnl:SetSize(165 * zclib.wM, 165 * zclib.hM)
                item_pnl.font_name = zclib.GetFont("zclib_font_small")
            end
        end

        zmc.vgui.ComponentSelection(top,SelectedFilter,function(data_val)
            SelectedFilter = data_val
            RebuildList()
        end)

        zmc.vgui.SearchBox(top,function(val)
            RebuildList(val)
        end)

        RebuildList()
    end)
end

function zmc.Fridge.EditWhitelist()
    zmc.vgui.WhitelistEditor(zmc.language["Restrict_Buy"],BuyWhitelist,function()
        BuyWhitelist = {}
        zmc.Fridge.OpenInterface()
    end,function()
        local e_String = util.TableToJSON(BuyWhitelist)
        local e_Compressed = util.Compress(e_String)
        net.Start("zmc_fridge_setwhitelist")
        net.WriteEntity(zmc.vgui.ActiveEntity)
        net.WriteUInt(#e_Compressed,16)
        net.WriteData(e_Compressed,#e_Compressed)
        net.SendToServer()

        BuyWhitelist = nil

        zmc_main_panel:Close()
    end,function()

        local AddList = {}
        zmc.vgui.ItemSelection(zmc.language["Whitelist_AddItem"],function(ItemID)

            if AddList[ItemID] then
                AddList[ItemID] = nil
            else
                AddList[ItemID] = true
            end

        end,function(ItemData)
            return AddList[ItemData.uniqueid] ~= nil
        end,function()
            zmc.Fridge.EditWhitelist()
        end,{},function(id,data)
            if data.fridge == nil then return true end
            if BuyWhitelist[tostring(data.uniqueid)] then return true end
            if data.fridge and BuyWhitelist[tostring(data.uniqueid)] == nil then return false end
        end,function()
            BuyWhitelist = table.Merge( BuyWhitelist, AddList )
            zmc.Fridge.EditWhitelist()
        end)
    end,function()
        BuyWhitelist = {}
        zmc.Fridge.EditWhitelist()
    end,function(list)
        for uid, _ in pairs(BuyWhitelist) do

            local data = zmc.Item.GetData(uid)

            if data == nil then continue end

            local item_pnl = zmc.vgui.Slot(data,function()
                return false
            end,function()
                return true
            end,function(ItemData)
                // Remove this item from the list and rebuild
                BuyWhitelist[tostring(ItemData.uniqueid)] = nil
                zmc.Fridge.EditWhitelist()
            end,function()
            end,function(w,h)
            end)
            list:Add(item_pnl)
            item_pnl:SetSize(166 * zclib.wM, 166 * zclib.hM)
            item_pnl.font_name = zclib.GetFont("zclib_font_small")
        end
    end)
end
