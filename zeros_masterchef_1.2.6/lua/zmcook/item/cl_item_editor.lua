if SERVER then return end
zmc = zmc or {}
zmc.Item = zmc.Item or {}
zmc.Item.Interface = zmc.Item.Interface or {}

net.Receive("zmc_config_open", function(len)
    zclib.Debug_Net("zmc_config_open", len)
    zmc.Item.Interface.ItemConfig()
end)

local SelectedItem
local ItemData = {}
local SelectedComponent
function zmc.Item.Interface.ItemConfig()
    SelectedComponent = nil
    zmc.vgui.Page(zmc.language["Items"],function(main,top)

        local close_btn = zclib.vgui.ImageButton(940 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("close"),function()
            zmc_main_panel:Close()
        end,false)
        close_btn:Dock(RIGHT)
        close_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        close_btn.IconColor = zclib.colors["red01"]

        // Clipboard
        local clip_btn = zclib.vgui.ImageButton(480 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("clipboard"),function()
            if zmc.Item.GetData(SelectedItem) == nil then return end
            zmc.Item.Interface.Copytoclipboard(SelectedItem)
        end,function()
            return zmc.Item.GetData(SelectedItem) == nil
        end)
        clip_btn:Dock(RIGHT)
        clip_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        clip_btn.IconColor = zclib.colors["green01"]
        clip_btn:SetTooltip(zmc.language["tooltip_clipboard"])

        // Edit
        local edit_btn = zclib.vgui.ImageButton(480 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("edit"),function()
            if zmc.Item.GetData(SelectedItem) == nil then return end
            ItemData = nil
            zmc.Item.Interface.ItemEditor()
        end,function()
            return zmc.Item.GetData(SelectedItem) == nil
        end)
        edit_btn:Dock(RIGHT)
        edit_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        edit_btn.IconColor = zclib.colors["orange01"]

        // Remove
        local remove_btn = zclib.vgui.ImageButton(420 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("delete"),function()
            if zmc.Item.GetData(SelectedItem) == nil then return end
            zmc.Item.Interface.RemoveItem(SelectedItem)
        end,function()
            return zmc.Item.GetData(SelectedItem) == nil
        end)
        remove_btn:Dock(RIGHT)
        remove_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        remove_btn.IconColor = zclib.colors["red01"]

        // Duplicate
        local dupl_btn = zclib.vgui.ImageButton(360 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("duplicate"),function()
            if zmc.Item.GetData(SelectedItem) == nil then return end
            zmc.Item.Interface.DuplicateItem(SelectedItem)
        end,function()
            return zmc.Item.GetData(SelectedItem) == nil
        end)
        dupl_btn:Dock(RIGHT)
        dupl_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        dupl_btn.IconColor = zclib.colors["blue01"]

        // Add
        local add_btn = zclib.vgui.ImageButton(300 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("plus"),function()
            ItemData = nil
            SelectedItem = -1
            zmc.Item.Interface.ItemEditor()
        end,false)
        add_btn:Dock(RIGHT)
        add_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        add_btn.IconColor = zclib.colors["green01"]

        local seperator = zmc.vgui.AddSeperator(top)
        seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
        seperator:Dock(RIGHT)
        seperator:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)

        local SelectedFilter = zmc.language["All"]
        local function RebuildList(search_input)
            if not IsValid(main) then return end
            if IsValid(main.ItemList) then main.ItemList:Remove() end

            local list,scroll = zmc.vgui.List(main)
            scroll:DockMargin(50 * zclib.wM,10 * zclib.hM,50 * zclib.wM,10 * zclib.hM)
            scroll.Paint = function(s, w, h) draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"]) end
            main.ItemList = scroll

            for id, data in pairs(zmc.config.Items) do
                if data == nil or data.mdl == nil then continue end

                if search_input ~= nil and search_input ~= "" and search_input ~= " " then
                    if string.find( data.name:lower(), search_input ) == nil then continue end
                else
                    if zmc.Item.Components[SelectedFilter] and data[SelectedFilter] == nil then continue end
                end

                local item_pnl = zmc.vgui.Slot(data,function()

                    //IsSelected
                    return SelectedItem == id
                end,function()

                    // CanSelect
                    return true
                end,function()

                    // OnSelect
                    SelectedItem = id
                end,function()

                    // PreDraw
                end,function(w,h)

                    // PostDraw
                end)
                list:Add(item_pnl)
                item_pnl:SetSize(99 * zclib.wM, 99 * zclib.hM)
            end

            timer.Simple(0.01,function()
                if IsValid(list) and SelectedItem then
                    local children = list:GetChildren()
                    if children and children[SelectedItem] then
                        scroll:JumpToChild( children[SelectedItem] )
                    end
                end
            end)
        end

        zmc.vgui.ComponentSelection(top,SelectedFilter,function(data_val)
            SelectedFilter = data_val
            RebuildList()
        end)

        seperator = zmc.vgui.AddSeperator(top)
        seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
        seperator:Dock(RIGHT)
        seperator:DockMargin(0 * zclib.wM,0 * zclib.hM,10 * zclib.wM,0 * zclib.hM)

        zmc.vgui.SearchBox(top,function(val)
            RebuildList(val)
        end)

        RebuildList()
    end)
end

function zmc.Item.Interface.ItemEditor()
    if ItemData == nil then
        if zmc.Item.GetData(SelectedItem) then
            ItemData = table.Copy(zmc.Item.GetData(SelectedItem))
        else
            ItemData = {
                name = "ItemName",
                mdl = "models/props_borealis/bluebarrel001.mdl",
                scale = 1,
            }
        end
    end

    zmc.vgui.Page(zmc.language["Item Editor"],function(main,top)

        local close_btn = zclib.vgui.ImageButton(540 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("back"),function()
            zmc.Item.Interface.ItemConfig()
        end,false)
        close_btn:Dock(RIGHT)
        close_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        close_btn.IconColor = zclib.colors["red01"]

        // Save Button
        local save_btn = zclib.vgui.ImageButton(480 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("save"),function()
            if SelectedItem == -1 then
                zmc.Item.Interface.CreateItem()
            else
                zmc.Item.Interface.UpdateItem(SelectedItem)
            end
        end,false)
        save_btn:Dock(RIGHT)
        save_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        save_btn.IconColor = zclib.colors["green01"]

        ///////////////////////////////////////////////////
        ///////////////////////////////////////////////////
        ///////////////////////////////////////////////////
        local detail_pnl = vgui.Create("DPanel", main)
        detail_pnl:SetSize(600 * zclib.wM, 200 * zclib.hM)
        detail_pnl:Dock( TOP )
        detail_pnl:DockMargin(50 * zclib.wM,10 * zclib.hM,50 * zclib.wM,0 * zclib.hM)
        detail_pnl.Paint = function(s, w, h)
        end

        local mdl_pnl = zmc.vgui.Slot(ItemData,function()

            //IsSelected
            return false
        end,function()

            // CanSelect
            return false
        end,function()

            // OnSelect
        end,function()

            // PreDraw
        end,function(w,h,s)
        end)
        mdl_pnl:SetParent(detail_pnl)
        mdl_pnl:SetSize(200 * zclib.wM, 200 * zclib.hM)
        mdl_pnl:Dock(RIGHT)
        mdl_pnl:SetFOV(25)
        mdl_pnl:SetCamPos(Vector(0,50,20))
        mdl_pnl.Entity:SetAngles(Angle(0,50,0))
        mdl_pnl.Entity:SetModelScale(ItemData.scale)
        mdl_pnl.PlatePos = vector_origin
        mdl_pnl.LayoutEntity = function()
            local mn,mx = mdl_pnl.Entity:GetModelBounds()

            local size = 0
            size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
            size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
            size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
            size = size * ItemData.scale

            local plate_h = 0
            if main.client_mdl then
                local _,px = main.client_mdl:GetModelBounds()
                //plate_h = (pn + px)
                plate_h = px.z
            end

            mdl_pnl.PlatePos = Vector(0,0,(mn.z * ItemData.scale) - plate_h)

            mdl_pnl:SetCamPos(Vector(size, size + 30, size))
            mdl_pnl:SetLookAt((mn + mx) * 0.5 * ItemData.scale)
        end
        mdl_pnl.PostDrawModel = function(s,ent)
            if IsValid(main.client_mdl) and main.client_mdl.DrawModel then
                main.client_mdl:SetNoDraw(true)
                main.client_mdl:SetColor(color_white)
                main.client_mdl:SetPos(mdl_pnl.PlatePos)
                main.client_mdl:DrawModel()
            end
        end

        //zmc.Item.UpdateVisual(mdl_pnl.Entity,ItemData,false)

        main.client_mdl = zclib.ClientModel.Add( "models/zerochain/props_kitchen/zmc_plate01.mdl", RENDERGROUP_OPAQUE)
        main.client_mdl:SetAngles(angle_zero)
        //main.client_mdl:SetMaterial("models/wireframe")

        local scale = 0.5
        if ItemData.scale then scale = (1 / 2) * ItemData.scale end
        local scale_pnl = zmc.vgui.SimpleSlider(mdl_pnl,scale,function(val,s)
            ItemData.scale = math.Clamp(val * 2,0.05,2)
            mdl_pnl.Entity:SetModelScale(ItemData.scale or 1)
        end,30,function(val)
        end)
        scale_pnl:DockMargin(0 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        scale_pnl:Dock(BOTTOM)


        local center_pnl = vgui.Create("DPanel", detail_pnl)
        center_pnl:SetSize(200 * zclib.wM, 200 * zclib.hM)
        center_pnl:DockMargin(0 * zclib.wM,0 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
        //center_pnl:DockPadding(10 * zclib.wM,10 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
        center_pnl:Dock(RIGHT)
        center_pnl.Paint = function(s, w, h)
        end

        local bg_btn_font = zclib.util.FontSwitch(zmc.language["Update Bodygroups"],200 * zclib.wM,zclib.GetFont("zclib_font_mediumsmall"),zclib.GetFont("zclib_font_small"))
        local bodygroup_button = zclib.vgui.TextButton(0,0,260 ,50,center_pnl,{Text01 = zmc.language["Update Bodygroups"],txt_font = bg_btn_font},function()
            zmc.vgui.BodygroupEditor(ItemData,function(new_data)
                zmc.Item.Interface.ItemEditor()
            end)
        end,function()
            return false
        end,function()
            return false
        end)
        bodygroup_button:DockMargin(0 * zclib.wM,10 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        bodygroup_button:Dock(BOTTOM)

        local color_pnl = vgui.Create("DColorMixer", center_pnl)
        color_pnl:SetSize(200 * zclib.wM, 200 * zclib.hM)
        //color_pnl:DockMargin(0 * zclib.wM,0 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
        color_pnl:DockPadding(10 * zclib.wM,10 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
        color_pnl:Dock(FILL)
        color_pnl:SetPalette(false)
        color_pnl:SetAlphaBar(false)
        color_pnl:SetWangs(true)
        color_pnl:SetColor(ItemData.color or color_white)
        color_pnl.ValueChanged = function(s,col)
            mdl_pnl:SetColor(col)

            zclib.Timer.Remove("zmc_colormixer_delay")
            zclib.Timer.Create("zmc_colormixer_delay",0.1,1,function()
                ItemData.color = col
            end)
        end
        color_pnl.Paint = function(s, w, h)
            draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
        end

        local name_pnl = zmc.vgui.TitledTextEntry(detail_pnl,45,zclib.GetFont("zclib_font_medium"),zmc.language["Name"],ItemData.name , zmc.language["ItemName"],false,function(val)
            ItemData.name = val
        end)
        name_pnl:DockMargin(0 * zclib.wM,0 * zclib.hM,10 * zclib.wM,0 * zclib.hM)

        local function RebuildSkin()
            detail_pnl.skin_pnl:Clear()
            for i = 0, mdl_pnl.Entity:SkinCount() - 1 do detail_pnl.skin_pnl:AddChoice(zmc.language["Skin"] .. " " .. i, i) end
            detail_pnl.skin_pnl:SetValue(0)
        end

        local mdlpath_pnl = zmc.vgui.TitledTextEntry(detail_pnl,40,zclib.GetFont("zclib_font_medium"),zmc.language["Model"],ItemData.mdl , "folder/folder/model.mdl",true,function(val) end,function(val)
            ItemData.mdl = val
            mdl_pnl.Entity:SetModel(val)
            RebuildSkin()
        end)
        mdlpath_pnl:DockMargin(0 * zclib.wM,10 * zclib.hM,10 * zclib.wM,0 * zclib.hM)

        local skin_pnl = zmc.vgui.TitledComboBox(detail_pnl,zmc.language["Skin"],ItemData.skin or 0,function(index, value, pnl)
            local data = pnl:GetOptionData(index)
            ItemData.skin = data
            mdl_pnl.Entity:SetSkin(data)
        end)
        skin_pnl:SetSortItems(false)
        skin_pnl.main:SetTall(40 * zclib.hM)
        skin_pnl.main:DockMargin(0 * zclib.wM,10 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
        skin_pnl.main:Dock(TOP)
        skin_pnl:DockMargin(100 * zclib.wM,5 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
        detail_pnl.skin_pnl = skin_pnl

        RebuildSkin()

        local mat_pnl = zmc.vgui.TitledTextEntry(detail_pnl,40,zclib.GetFont("zclib_font_medium"),zmc.language["Material"],ItemData.material , "folder/folder/material",true,function(val) end,function(val)
            ItemData.material = val
            mdl_pnl.Entity:SetMaterial(val)
        end)
        mat_pnl:DockMargin(0 * zclib.wM,10 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
        mat_pnl.textentry:DockMargin(115 * zclib.wM,0 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
        mat_pnl:Dock(FILL)

        ///////////////////////////////////////////////////
        ///////////////////////////////////////////////////
        ///////////////////////////////////////////////////

        zmc.vgui.AddSeperator(main)


        local comp_list = vgui.Create("DPanel", main)
        comp_list:Dock(LEFT)
        comp_list:SetSize(300 * zclib.wM, 230 * zclib.hM)
        comp_list:DockPadding(0 * zclib.wM,30 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        comp_list:DockMargin(50 * zclib.wM,10 * zclib.hM,0 * zclib.wM,10 * zclib.hM)
        comp_list.Paint = function(s, w, h)
            draw.RoundedBox(5,0, 0, w, h, zclib.colors["ui01"])
            draw.RoundedBox(5, 10 * zclib.wM, 50 * zclib.hM, w - 20 * zclib.wM, h - 60 * zclib.hM, zclib.colors["ui02"])
            draw.SimpleText(zmc.language["Components"], zclib.GetFont("zclib_font_medium"), 10 * zclib.wM,20 * zclib.hM,zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        local list = zmc.vgui.List(comp_list)
        list:DockMargin(10 * zclib.wM,20 * zclib.hM,0 * zclib.wM,0 * zclib.hM)

        local comp_detail = vgui.Create("DPanel", main)
        comp_detail:Dock(FILL)
        comp_detail:SetSize(300 * zclib.wM, 230 * zclib.hM)
        comp_detail:DockMargin(10 * zclib.wM,10 * zclib.hM,50 * zclib.wM,10 * zclib.hM)
        comp_detail:DockPadding(0 * zclib.wM,40 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        comp_detail.Title = ""
        comp_detail.Paint = function(s, w, h)
            draw.RoundedBox(5,0, 0, w, h, zclib.colors["ui01"])
            draw.RoundedBox(5, 10 * zclib.wM, 50 * zclib.hM, w - 20 * zclib.wM, h - 60 * zclib.hM, zclib.colors["ui02"])

            draw.SimpleText(s.Title, zclib.GetFont("zclib_font_mediumsmall"), 10 * zclib.wM,20 * zclib.hM,zclib.colors["green01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        for k,v in pairs(ItemData) do
            if zmc.Item.Components[k] == nil then continue end

            local btn = zclib.vgui.TextButton(0,0,260,40,list,{Text01 = zmc.Item.Components[k].name,txt_font = zclib.GetFont("zclib_font_small")},function()
                SelectedComponent = k
                zmc.Item.Interface.ItemEditor_RebuildContent(comp_detail)
            end,function()
                return false
            end,function()
                return k == SelectedComponent
            end)
            list:Add(btn)

            if SelectedComponent == nil then
                SelectedComponent = k
            end
        end

        // Select the first item
        if SelectedComponent then
            zmc.Item.Interface.ItemEditor_RebuildContent(comp_detail,SelectedComponent)
        end

        // Remove
        local remove_btn  = zmc.vgui.SimpleButton(220 * zclib.wM,10 * zclib.hM,30 * zclib.wM, 30 * zclib.hM,comp_list,zclib.Materials.Get("delete"),function()
            if SelectedComponent == nil or ItemData[SelectedComponent] == nil then return end
            ItemData[SelectedComponent] = nil
            SelectedComponent = nil
            zmc.Item.Interface.ItemEditor()
        end,function()
            return SelectedComponent == nil or ItemData[SelectedComponent] == nil
        end)
        remove_btn.IconColor = zclib.colors["red01"]

        // Add
        local add_btn = zmc.vgui.SimpleButton(260 * zclib.wM,10 * zclib.hM,30 * zclib.wM, 30 * zclib.hM,comp_list,zclib.Materials.Get("plus"),function()
            zmc.Item.Interface.AddComponentWindow()
        end,false)
        add_btn.IconColor = zclib.colors["green01"]
    end)
end

function zmc.Item.Interface.ItemEditor_RebuildContent(parent)
    if IsValid(parent.content) then parent.content:Remove() end

    local ctn_pnl = vgui.Create("DPanel", parent)
    ctn_pnl:Dock(FILL)
    ctn_pnl:SetSize(280 * zclib.wM, 230 * zclib.hM)
    ctn_pnl:DockMargin(10 * zclib.wM,10 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
    ctn_pnl:DockPadding(10 * zclib.wM,10 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
    ctn_pnl.Paint = function(s, w, h) end
    parent.content = ctn_pnl

    local compData = zmc.Item.Components[SelectedComponent]
    parent.Title = compData.name .. " - " .. compData.desc

    for k,v in pairs(zmc.Item.Components[SelectedComponent]) do

        if k == "temp" then
            local temp_pnl = vgui.Create("DPanel", ctn_pnl)
            temp_pnl:Dock(TOP)
            temp_pnl:SetSize(280 * zclib.wM, 150 * zclib.hM)
            temp_pnl:DockMargin(0 * zclib.wM,0 * zclib.hM,0 * zclib.wM,5 * zclib.hM)
            temp_pnl.Paint = function(s, w, h)
                draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
                draw.SimpleText(zmc.language["Temperature"] .. ":",zclib.GetFont("zclib_font_medium"),10 * zclib.wM, 5 * zclib.hM, zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                draw.RoundedBox(5, 20 * zclib.wM, 45 * zclib.hM, w - 40 * zclib.wM, 20 * zclib.hM, zclib.colors["white_a5"])
                if ItemData[SelectedComponent][k] and ItemData[SelectedComponent][k].start and ItemData[SelectedComponent][k].range then
                    local size = (w / 100) * ItemData[SelectedComponent][k].range
                    local xPos = (w / 100) * ItemData[SelectedComponent][k].start

                    draw.RoundedBox(5, xPos + 20 * zclib.wM, 45 * zclib.hM, math.Clamp(size,0,w - xPos) - 40 * zclib.wM, 20 * zclib.hM, zclib.colors["green01"])
                end

                draw.SimpleText("0°",zclib.GetFont("zclib_font_small"),25 * zclib.wM, 56 * zclib.hM, zclib.colors["black_a200"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText("100°",zclib.GetFont("zclib_font_small"),w - 25 * zclib.wM, 56 * zclib.hM, zclib.colors["black_a200"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            end
            temp_pnl:SetTooltip(zmc.language["tooltip_temperature"])

            if ItemData[SelectedComponent][k] == nil then
                ItemData[SelectedComponent][k] = {
                    start = 50,
                    range = 25
                }
            end

            local tempData = ItemData[SelectedComponent][k]
            local _start = v.start
            local _range = v.range

            if tempData.start then _start = tempData.start end
            if tempData.range then _range = tempData.range end

            local range_pnl = zmc.vgui.TitledSlider(temp_pnl, zmc.language["range_title"] .. ":", (1 / 100) * _range, function(val,pnl)
                ItemData[SelectedComponent][k].range = math.Round(Lerp(val,10,100))
            end, 35, function(val) end,0.65,0.19)
            range_pnl:DockMargin(0 * zclib.wM,5 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
            range_pnl:Dock(BOTTOM)
            range_pnl.displayValue = function(s) return math.Round(Lerp(s.slideValue,10,100)) .. "%" end
            range_pnl.font =  zclib.GetFont("zclib_font_small")
            range_pnl.title_color =  color_white

            local start_pnl = zmc.vgui.TitledSlider(temp_pnl, zmc.language["Start"] .. ":", (1 / 100) * _start, function(val,pnl)
                ItemData[SelectedComponent][k].start = math.Round(Lerp(val,0,90))
            end, 35, function(val) end,0.65,0.19)
            start_pnl:DockMargin(0 * zclib.wM,10 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
            start_pnl:Dock(BOTTOM)
            start_pnl.displayValue = function(s) return math.Round(Lerp(s.slideValue,0,90)) .. "°" end
            start_pnl.font =  zclib.GetFont("zclib_font_small")
            start_pnl.title_color =  color_white
            //apnl:SetTooltip(zmc.Item.GetTooltip(SelectedComponent,k))
            continue
        end

        if isnumber(v) then

            local def = zmc.Item.Component.Definition[k]

            if def.min and def.max then
                local apnl = zmc.vgui.TitledSlider(ctn_pnl, (def.name or k) .. ":", (1 / def.max) * (ItemData[SelectedComponent][k] or v), function(val,pnl)
                    if SelectedComponent == "wok" and k == "range" then
                        ItemData[SelectedComponent][k] = math.Round(Lerp(val,def.min,def.max),2)
                    else
                        ItemData[SelectedComponent][k] = math.floor(Lerp(val,def.min,def.max))
                    end
                end, 35, function(val) end,0.65,0.19)
                apnl:DockMargin(0 * zclib.wM,0 * zclib.hM,0 * zclib.wM,5 * zclib.hM)
                apnl:Dock(TOP)
                apnl.displayValue = function(s)
                    return math.floor(Lerp(s.slideValue,def.min,def.max))
                end
                if k == "time" then apnl.displayValue = function(s) return string.FormattedTime( Lerp(s.slideValue,def.min,def.max), "%02i:%02i" ) end end
                //if k == "speed" then apnl.displayValue = function(s) return math.Round(Lerp(s.slideValue,def.min,def.max)) end end
                if SelectedComponent == "wok" and k == "range" then apnl.displayValue = function(s) return math.Round(Lerp(s.slideValue,def.min,def.max),2) end end

                apnl:SetTooltip(zmc.Item.GetTooltip(SelectedComponent,k))
                apnl.font =  zclib.GetFont("zclib_font_small")
                continue
            end

            local pnl = zmc.vgui.TitledTextEntry(ctn_pnl,35,zclib.GetFont("zclib_font_small"),(def.name or k) .. ":",ItemData[SelectedComponent][k] or v,"Value",false,function(val)
                ItemData[SelectedComponent][k] = tonumber(val,10)
            end)
            pnl:DockMargin(0 * zclib.wM,0 * zclib.hM,0 * zclib.wM,5 * zclib.hM)
            pnl.textentry:SetNumeric(true)
            pnl:SetTooltip(zmc.Item.GetTooltip(SelectedComponent,k))

            continue
        end

        if k == "appearance" then
            local m = vgui.Create("DPanel", ctn_pnl)
            m:SetSize(600 * zclib.wM, 50 * zclib.hM)
            //m:DockMargin(10 * zclib.wM,10 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
            m:DockMargin(0 * zclib.wM,0 * zclib.hM,0 * zclib.wM,5 * zclib.hM)
            m:Dock(TOP)
            m:SetTooltip(zmc.Item.GetTooltip(SelectedComponent,k))
            m.Paint = function(s, w, h)
                draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
                draw.SimpleText(zmc.language["Appearance"] .. ":", zclib.GetFont("zclib_font_small"), 10 * zclib.wM,h / 2,zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            if ItemData[SelectedComponent]["appearance"] == nil then
                ItemData[SelectedComponent]["appearance"] = table.Copy(zmc.Item.Components[SelectedComponent]["appearance"])
            end

            local ap = ItemData[SelectedComponent]["appearance"]
            local btn = zmc.vgui.Slot(ap,function()

                //IsSelected
                return false
            end,function()

                // CanSelect
                return true
            end,function()

                // OnSelect

                // Open Appearance Editor
                zmc.Item.Interface.AppearanceEditor()
            end,function()
                // PreDraw
            end,function(w,h)
                // PostDraw
            end)
            btn:SetSize(50 * zclib.wM, 50 * zclib.hM)
            btn:SetParent(m)
            btn:Dock(LEFT)
            btn:DockMargin(120 * zclib.wM,10 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
            continue
        end

        if k == "item" then

            local m = vgui.Create("DPanel", ctn_pnl)
            m:SetSize(600 * zclib.wM, 80 * zclib.hM)
            m:DockMargin(0 * zclib.wM,0 * zclib.hM,0 * zclib.wM,5 * zclib.hM)
            m:Dock(TOP)
            m:SetTooltip(zmc.Item.GetTooltip(SelectedComponent,k))
            m.Paint = function(s, w, h)
                draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
                draw.SimpleText(zmc.language["Result"] .. ":", zclib.GetFont("zclib_font_small"), 10 * zclib.wM,h / 2,zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            local btn = zmc.vgui.Slot(zmc.Item.GetData(ItemData[SelectedComponent][k]),function()

                //IsSelected
                return false
            end,function()

                // CanSelect
                return true
            end,function()

                // OnSelect
                zmc.vgui.ItemSelection(zmc.language["Select Item"],function(ItemID)
                    ItemData[SelectedComponent][k] = ItemID
                    zmc.Item.Interface.ItemEditor()
                end,function() return false end,function()
                    zmc.Item.Interface.ItemEditor()
                end,{
                    [ItemData.uniqueid or "66666666"] = true
                },function(id,data)
                    if SelectedItem > 0 and id == SelectedItem then return true end
                end)
            end,function()

                // PreDraw
            end,function(w,h)

                // PostDraw
            end)
            btn:SetSize(100 * zclib.wM, 80 * zclib.hM)
            btn:SetParent(m)
            btn:Dock(LEFT)
            btn:DockMargin(100 * zclib.wM,10 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
            continue
        end

        if k == "items" then
            local SelectedIngredient
            local ing_list = vgui.Create("DPanel", ctn_pnl)
            ing_list:Dock(FILL)
            ing_list:SetSize(300 * zclib.wM, 230 * zclib.hM)
            ing_list:DockPadding(0 * zclib.wM,50 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
            ing_list:DockMargin(0 * zclib.wM,0 * zclib.hM,0 * zclib.wM,5 * zclib.hM)
            ing_list:SetTooltip(zmc.Item.GetTooltip(SelectedComponent,k))
            ing_list.Paint = function(s, w, h)
                draw.RoundedBox(5,0 * zclib.wM, 0 * zclib.hM,w - 5 * zclib.wM,5 * zclib.hM, zclib.colors["ui01"])
                draw.RoundedBox(5,w - 130 * zclib.wM, 0 * zclib.hM,130 * zclib.wM,50 * zclib.hM, zclib.colors["ui01"])
                draw.SimpleText(zmc.language["Ingredients"], zclib.GetFont("zclib_font_medium"), 10 * zclib.wM,20 * zclib.hM,zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
            local alist = zmc.vgui.List(ing_list)
            alist:DockMargin(10 * zclib.wM,20 * zclib.hM,0 * zclib.wM,0 * zclib.hM)

            // Remove
            local remove_btn  = zmc.vgui.SimpleButton(470 * zclib.wM,10 * zclib.hM,30 * zclib.wM, 30 * zclib.hM,ing_list,zclib.Materials.Get("delete"),function()
                if SelectedIngredient == nil then return end
                table.remove(ItemData[SelectedComponent][k],SelectedIngredient)
                zmc.Item.Interface.ItemEditor()
            end,function()
                return SelectedIngredient == nil
            end)
            remove_btn.IconColor = zclib.colors["red01"]

            // Add
            local add_btn = zmc.vgui.SimpleButton(510 * zclib.wM,10 * zclib.hM,30 * zclib.wM, 30 * zclib.hM,ing_list,zclib.Materials.Get("plus"),function()


                if SelectedComponent == "craft" and ItemData[SelectedComponent]["items"] and table.Count(ItemData[SelectedComponent]["items"]) >= 4 then
                    zclib.vgui.Notify(zmc.language["ingredient_count_warning_craft"],NOTIFY_ERROR)
                    return
                end

                if ItemData[SelectedComponent]["items"] and table.Count(ItemData[SelectedComponent]["items"]) >= 12 then
                    zclib.vgui.Notify(zmc.language["ingredient_count_warning_generic"],NOTIFY_ERROR)
                    return
                end

                zmc.vgui.ItemSelection(zmc.language["Add Ingredient"],function(ItemID)
                    table.insert(ItemData[SelectedComponent]["items"],ItemID)
                    zmc.Item.Interface.ItemEditor()
                end,function() return false end,function()
                    zmc.Item.Interface.ItemEditor()
                end,{},function(id,data)
                    if SelectedItem > 0 and id == SelectedItem then return true end
                end)
            end,false)
            add_btn.IconColor = zclib.colors["green01"]

            // Duplicate
            local dup_btn = zmc.vgui.SimpleButton(430 * zclib.wM,10 * zclib.hM,30 * zclib.wM, 30 * zclib.hM,ing_list,zclib.Materials.Get("duplicate"),function()

                if SelectedComponent == "craft" and ItemData[SelectedComponent]["items"] and table.Count(ItemData[SelectedComponent]["items"]) >= 4 then
                    zclib.vgui.Notify(zmc.language["ingredient_count_warning_craft"],NOTIFY_ERROR)
                    return
                end

                if ItemData[SelectedComponent]["items"] and table.Count(ItemData[SelectedComponent]["items"]) >= 12 then
                    zclib.vgui.Notify(zmc.language["ingredient_count_warning_generic"],NOTIFY_ERROR)
                    return
                end
                local data = zmc.Item.GetData(ItemData[SelectedComponent]["items"][SelectedIngredient])

                table.insert(ItemData[SelectedComponent]["items"],data.uniqueid)
                zmc.Item.Interface.ItemEditor()
            end,function()
                return SelectedIngredient == nil
            end)
            dup_btn.IconColor = zclib.colors["blue01"]

            for id,ing_id in pairs(ItemData[SelectedComponent]["items"]) do

                local data = zmc.Item.GetData(ing_id)

                local amdl_pnl = zmc.vgui.Slot(data,function()

                    //IsSelected
                    return id == SelectedIngredient
                end,function()

                    // CanSelect
                    return true
                end,function()

                    // OnSelect
                    SelectedIngredient = id
                end,function()

                    // PreDraw
                end,function(w,h)

                    // PostDraw
                end)
                amdl_pnl:SetSize(76 * zclib.wM, 76 * zclib.hM)
                alist:Add(amdl_pnl)
            end

            continue
        end
    end
end

function zmc.Item.Interface.AppearanceEditor()
    zmc.vgui.Page(zmc.language["Appearance Editor"],function(main,top)

        local close_btn = zclib.vgui.ImageButton(540 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("back"),function()
            zmc.Item.Interface.ItemEditor()
        end,false)
        close_btn:Dock(RIGHT)
        close_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        close_btn.IconColor = zclib.colors["red01"]

        local appearance = ItemData[SelectedComponent]["appearance"]

        if appearance == nil then
            appearance = table.Copy(zmc.Item.Components[SelectedComponent]["appearance"])
        end

        local detail_pnl = vgui.Create("DPanel", main)
        detail_pnl:SetSize(600 * zclib.wM, 400 * zclib.hM)
        detail_pnl:Dock( TOP )
        detail_pnl:DockMargin(50 * zclib.wM,10 * zclib.hM,50 * zclib.wM,0 * zclib.hM)
        detail_pnl.Paint = function(s, w, h)
        end



        // Change the model depending on component
        local p_mdl = "models/zerochain/props_kitchen/zmc_souppot.mdl"
        if SelectedComponent == "soup" then
            p_mdl = "models/zerochain/props_kitchen/zmc_souppot.mdl"
        elseif SelectedComponent == "wok" then
            p_mdl = "models/zerochain/props_kitchen/zmc_wok.mdl"
        end
        main.client_mdl = zclib.ClientModel.Add( p_mdl, RENDERGROUP_OPAQUE)


        local mdl_pnl = zmc.vgui.Slot(appearance,function()

            //IsSelected
            return false
        end,function()

            // CanSelect
            return false
        end,function()

            // OnSelect
        end,function()

            // PreDraw
        end,function(w,h,s)
        end)
        mdl_pnl:SetParent(detail_pnl)
        mdl_pnl:SetSize(400 * zclib.wM, 400 * zclib.hM)
        mdl_pnl:Dock(FILL)

        mdl_pnl.ViewSwitch = false
        mdl_pnl.ViewPos_default = Vector(0,50,40)
        mdl_pnl.DoClick = function()
            mdl_pnl.ViewSwitch = not mdl_pnl.ViewSwitch

            if mdl_pnl.ViewSwitch == false then
                mdl_pnl:SetCamPos(mdl_pnl.ViewPos_default)
            else
                mdl_pnl:SetCamPos(Vector(0,1,80))
            end
        end

        local pmin,pmax = main.client_mdl:GetModelBounds()

        mdl_pnl:SetFOV(50)
        mdl_pnl:SetCamPos(Vector(0,50,40))
        mdl_pnl:SetLookAt((pmin + pmax) / 2)
        mdl_pnl.Entity:SetAngles(angle_zero)
        mdl_pnl.Entity:SetModelScale(appearance.scale)
        mdl_pnl.PostDrawModel = function(s,ent)
            if IsValid(main.client_mdl) then

                render.SetColorModulation(1,1,1)
                render.Model({
                    model = p_mdl,
                    pos = Vector(0,0,-5),
                    angle = angle_zero
                }, main.client_mdl)
                render.SetColorModulation(1, 1, 1)
            end
        end
        mdl_pnl.LayoutEntity = function(s)
            if IsValid(main.client_mdl) and IsValid(mdl_pnl.Entity) then
                local pos = ItemData[SelectedComponent]["appearance"].lpos or vector_origin
                local min,max = main.client_mdl:GetModelBounds()
                local mid = (max - min)
                local nPos = mid * pos

                mdl_pnl.Entity:SetPos(main.client_mdl:LocalToWorld(nPos + Vector(-mid.x / 2,-mid.y / 2,0)))
            end
        end


        local left_pnl = vgui.Create("DPanel", detail_pnl)
        left_pnl:SetSize(400 * zclib.wM, 400 * zclib.hM)
        left_pnl:DockMargin(0 * zclib.wM,0 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
        //left_pnl:DockPadding(10 * zclib.wM,10 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
        left_pnl:Dock(LEFT)
        left_pnl.Paint = function(s, w, h) end

        local bodygroup_button = zclib.vgui.TextButton(0,0,260 ,50,left_pnl,{Text01 = zmc.language["Update Bodygroups"],txt_font = zclib.GetFont("zclib_font_mediumsmall")},function()
            zmc.vgui.BodygroupEditor(appearance,function(new_data)
                zmc.Item.Interface.AppearanceEditor()
            end)
        end,function()
            return false
        end,function()
            return false
        end)
        bodygroup_button:DockMargin(0 * zclib.wM,10 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        bodygroup_button:Dock(BOTTOM)

        local color_pnl = vgui.Create("DColorMixer", left_pnl)
        color_pnl:DockPadding(10 * zclib.wM,10 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
        color_pnl:Dock(FILL)
        color_pnl:SetPalette(false)
        color_pnl:SetAlphaBar(false)
        color_pnl:SetWangs(true)
        color_pnl:SetColor(appearance.color or color_white)
        color_pnl.ValueChanged = function(s,col)
            mdl_pnl:SetColor(col)

            zclib.Timer.Remove("zmc_colormixer_delay")
            zclib.Timer.Create("zmc_colormixer_delay",0.1,1,function()
                ItemData[SelectedComponent]["appearance"].color = col
            end)
        end
        color_pnl.Paint = function(s, w, h)
            draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
        end



        local info_pnl = vgui.Create("DPanel", main)
        info_pnl:Dock(FILL)
        info_pnl:SetSize(300 * zclib.wM, 230 * zclib.hM)
        info_pnl:DockMargin(50 * zclib.wM,0 * zclib.hM,50 * zclib.wM,0 * zclib.hM)
        info_pnl.Paint = function(s, w, h) end

        local pox_pnl = zmc.vgui.PositionSelection(info_pnl)
        pox_pnl.GetPosition = function(s)
            if ItemData[SelectedComponent]["appearance"] and ItemData[SelectedComponent]["appearance"].lpos then
                return ItemData[SelectedComponent]["appearance"].lpos
            else
                return vector_origin
            end
        end
        pox_pnl.OnChanged = function(s,newpos)
            ItemData[SelectedComponent]["appearance"].lpos = newpos
        end

        local function RebuildSkin()
            info_pnl.skin_pnl:Clear()
            for i = 0, mdl_pnl.Entity:SkinCount() - 1 do info_pnl.skin_pnl:AddChoice("Skin " .. i, i) end
            info_pnl.skin_pnl:SetValue(0)
        end

        local mdlpath_pnl = zmc.vgui.TitledTextEntry(info_pnl,45,zclib.GetFont("zclib_font_medium"),zmc.language["Model"],appearance.mdl , "folder/folder/model.mdl",true,function(val) end,function(val)
            ItemData[SelectedComponent]["appearance"].mdl = val
            mdl_pnl.Entity:SetModel(val)
            RebuildSkin()
        end)
        mdlpath_pnl:DockMargin(0 * zclib.wM,10 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
        mdlpath_pnl:Dock(TOP)

        local skin_pnl = zmc.vgui.TitledComboBox(info_pnl,zmc.language["Skin"],appearance.skin or 0,function(index, value, pnl)
            local data = pnl:GetOptionData(index)
            ItemData[SelectedComponent]["appearance"].skin = data
            mdl_pnl.Entity:SetSkin(data)
        end)
        skin_pnl:SetSortItems(false)
        skin_pnl.main:SetTall(45 * zclib.hM)
        skin_pnl.main:DockMargin(0 * zclib.wM,10 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
        skin_pnl.main:Dock(TOP)
        skin_pnl:DockMargin(100 * zclib.wM,5 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
        info_pnl.skin_pnl = skin_pnl

        RebuildSkin()

        local mat_pnl = zmc.vgui.TitledTextEntry(info_pnl,45,zclib.GetFont("zclib_font_medium"),zmc.language["Material"],appearance.material , "folder/folder/material",true,function(val) end,function(val)
            ItemData[SelectedComponent]["appearance"].material = val
            mdl_pnl.Entity:SetMaterial(val)
        end)
        mat_pnl:DockMargin(0 * zclib.wM,10 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
        mat_pnl.textentry:DockMargin(115 * zclib.wM,0 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
        mat_pnl:Dock(TOP)

        local slider_height = zmc.vgui.TitledSlider(info_pnl, zmc.language["Height"], (appearance.lpos and appearance.lpos.z) or 0, function(val,pnl)

            local curPos = appearance.lpos or vector_origin
            ItemData[SelectedComponent]["appearance"].lpos = Vector(curPos.x, curPos.y,val)
        end, 50, function(val) end)
        slider_height:SetWide(300 * zclib.wM)
        slider_height:DockMargin(0 * zclib.wM,10 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
        slider_height:Dock(TOP)
        slider_height.displayValue = function(s) return math.Round(s.slideValue, 2) end

        // Model scale needs to be relative to pot model width
        local slider_scale = zmc.vgui.TitledSlider(info_pnl, zmc.language["Scale"], appearance.scale or 1, function(val,pnl)
            ItemData[SelectedComponent]["appearance"].scale = val
            zclib.Entity.RelativeScale(mdl_pnl.Entity,main.client_mdl,val)
        end, 50, function(val) end)
        slider_scale:SetWide(300 * zclib.wM)
        slider_scale:DockMargin(0 * zclib.wM,10 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
        slider_scale:Dock(FILL)
        slider_scale.displayValue = function(s) return math.Round(s.slideValue, 2) end

        zclib.Entity.RelativeScale(mdl_pnl.Entity,main.client_mdl,appearance.scale or 1)
    end)
end


function zmc.Item.Interface.AddComponentWindow()
    zmc.vgui.Page(zmc.language["Add Component"],function(main,top)

        local close_btn = zclib.vgui.ImageButton(540 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("back"),function()
            zmc.Item.Interface.ItemEditor()
        end,false)
        close_btn:Dock(RIGHT)
        close_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        close_btn.IconColor = zclib.colors["red01"]

        main:InvalidateLayout(true)
        main:InvalidateParent(true)

        local Main_pnl = vgui.Create("DPanel", main)
        Main_pnl:SetSize(400 * zclib.wM, 600 * zclib.hM)
        Main_pnl:Center()
        Main_pnl.Paint = function(s, w, h)
            draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a50"])
        end

        local list = zmc.vgui.List(Main_pnl)

        for k,v in pairs(zmc.Item.Components) do
            if ItemData[k] then continue end

            local btn = vgui.Create("DButton", Main_pnl)
            btn:SetSize(340 * zclib.wM, 40 * zclib.hM)
            btn:SetAutoDelete(true)
            btn:SetText("")
            btn.Paint = function(s, w, h)
                draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
                draw.SimpleText(zmc.Item.Components[k].name, zclib.GetFont("zclib_font_small"), w / 2, h / 2, zclib.colors["orange01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                if s:IsHovered() then draw.RoundedBox(5, 0, 0, w, h, zclib.colors["white_a5"]) end
            end
            btn.DoClick = function(s)
                zclib.vgui.PlaySound("UI/buttonclick.wav")
                ItemData[k] = table.Copy(v)
                ItemData[k].name = nil
                ItemData[k].desc = nil
                ItemData[k].icon = nil
                zmc.Item.Interface.ItemEditor()
            end

            list:Add(btn)
        end
    end)
end

function zmc.Item.Interface.RemoveItem(id)
    if zmc.Item.GetData(id) == nil then return end

    zmc.vgui.ConfirmationWindow(zmc_main_panel,zmc.language["Delete this Item?"],function()
        table.remove(zmc.config.Items,id)
        zmc.Item.Interface.UpdateServer()
        zmc.Item.Interface.ItemConfig()
    end,function()
        // DO nuthin
    end)
end

function zmc.Item.Interface.DuplicateItem(id)
    if zmc.Item.GetData(id) == nil then return end
    zmc.vgui.ConfirmationWindow(zmc_main_panel,zmc.language["Duplicate this Item?"],function()

        local data = table.Copy(zmc.Item.GetData(id))
        data.uniqueid = zclib.util.GenerateUniqueID("xxxxxxxxxx")
        data.name = data.name .. " " .. zmc.language["Copy"]
        table.insert(zmc.config.Items,data)

        zmc.Item.Interface.UpdateServer()
        zmc.Item.Interface.ItemConfig()
    end,function()
        // DO nuthin
    end)
end

function zmc.Item.Interface.UpdateItem(id)
    if zmc.Item.Validate(ItemData) then
        zmc.config.Items[id] = table.Copy(ItemData)
        zmc.Item.Interface.UpdateServer()
    end

    zmc.Item.Interface.ItemConfig()
end

function zmc.Item.Interface.CreateItem()
    if zmc.Item.Validate(ItemData) then
        ItemData.uniqueid = zclib.util.GenerateUniqueID("xxxxxxxxxx")
        table.insert(zmc.config.Items,ItemData)
        zmc.Item.Interface.UpdateServer()
    end
    zmc.Item.Interface.ItemConfig()
end

function zmc.Item.Interface.UpdateServer()
    // Send net msg to server
    zclib.Data.UpdateConfig("zmc_item_config")
    ItemData = nil
end


local function BuildClipboard(id)
    local dat = zmc.Item.GetData(id)

    local text = [[zmc.Item.LoadModule({
    uniqueid = "]] .. dat.uniqueid .. [[",
    name = "]] .. dat.name .. [[",
    skin = ]] .. (dat.skin or 0) .. [[,
    mdl = "]] .. dat.mdl .. [[",
    ]]
    if dat.material then
        text = text .. [[material = "]] .. dat.material .. [[",]]
    end

    if dat.color then
        text = text .. [[color = Color(]] .. math.Round(dat.color.r) .. [[,]] .. math.Round(dat.color.g) .. [[,]] .. math.Round(dat.color.b) .. [[),]]
    end
    text = text .. [[scale = ]] .. dat.scale .. [[,
]]

    // Add Bodygroups
    if dat.bgs then
        text = text .. [[
    bgs = {]]
        for k, v in pairs(dat.bgs) do
            text = text .. "[" .. k .. "]" .. [[ = ]] .. v .. [[,]]
        end
        text = text .. [[},
]]
    end

    // Add Fridge Data
    if dat.fridge then
        text = text .. [[
    fridge = {price = ]] .. dat.fridge.price .. [[,},
]]
    end

    // Add Cutting Data
    if dat.cut then
        text = text .. [[
    cut = {cycle = ]] .. dat.cut.cycle .. [[,items = {]]
        for k, v in pairs(dat.cut.items) do
            text = text .. [["]] .. v .. [[",]]
        end
        text = text .. [[},},
]]
    end

    // Add knead Data
    if dat.knead then
        text = text .. [[
    knead = {cycle = ]] .. dat.knead.cycle .. [[,item = "]] .. dat.knead.item .. [[",amount = ]] .. dat.knead.amount .. [[,},
]]
    end

    // Add bake Data
    if dat.bake then
        text = text .. [[
    bake = {
        time = ]] .. dat.bake.time .. [[,
        item = "]] .. dat.bake.item .. [[",
        temp = {start = ]] .. dat.bake.temp.start .. [[,range = ]] .. dat.bake.temp.range .. [[,}
    },
]]
    end

    // Add mix Data
    if dat.mix then
        text = text .. [[
    mix = {
        time = ]] .. dat.mix.time .. [[,
        speed = ]] .. dat.mix.speed .. [[,
        items = {]]
        for k, v in pairs(dat.mix.items) do
            text = text .. [["]] .. v .. [[",]]
        end
        text = text .. [[},
    },
]]
    end

    // Add sell Data
    if dat.sell then
        text = text .. [[
    sell = {price = ]] .. dat.sell.price .. [[,},
]]
    end

    // Add sell Data
    if dat.edible then
        text = text .. [[
    edible = {health = ]] .. dat.edible.health .. [[,health_cap = ]] .. dat.edible.health_cap .. [[,},
]]
    end

    // Add grill Data
    if dat.grill then
        text = text .. [[
    grill = {time = ]] .. dat.grill.time .. [[,item = "]] .. dat.grill.item .. [[",},
]]
    end

    // Add wok Data
    if dat.wok then
        text = text .. [[
    wok = {
        cycle = ]] .. dat.wok.cycle .. [[,
        range = ]] .. dat.wok.range .. [[,
        amount = ]] .. dat.wok.amount .. [[,
        appearance = {
            mdl = "]] .. dat.wok.appearance.mdl .. [[",
            scale = ]] .. dat.wok.appearance.scale .. [[,
            skin = ]] .. dat.wok.appearance.skin .. [[,
            color = Color(]] .. math.Round(dat.wok.appearance.color.r) .. [[,]] .. math.Round(dat.wok.appearance.color.g) .. [[,]] .. math.Round(dat.wok.appearance.color.b) .. [[),
            material = "]] .. dat.wok.appearance.material .. [[",
            lpos = Vector(]] .. math.Round(dat.wok.appearance.lpos.x,2) .. [[,]] .. math.Round(dat.wok.appearance.lpos.y,2) .. [[,]] .. math.Round(dat.wok.appearance.lpos.z,2) .. [[),
            ]]
            // Add Bodygroups
            if dat.wok.appearance.bgs then
                text = text .. [[bgs = {]]
                for k, v in pairs(dat.wok.appearance.bgs) do
                    text = text .. "[" .. k .. "]" .. [[ = ]] .. v .. [[,]]
                end
                text = text .. [[},
        ]]
            end
        text = text .. [[},
        items = {]]
        for k, v in pairs(dat.wok.items) do
            text = text .. [["]] .. v .. [[",]]
        end
        text = text .. [[},
    },
]]
    end

    // Add soup Data
    if dat.soup then
        text = text .. [[
    soup = {
        time = ]] .. dat.soup.time .. [[,
        amount = ]] .. dat.soup.amount .. [[,
        appearance = {
            mdl = "]] .. dat.soup.appearance.mdl .. [[",
            scale = ]] .. dat.soup.appearance.scale .. [[,
            skin = ]] .. dat.soup.appearance.skin .. [[,
            color = Color(]] .. math.Round(dat.soup.appearance.color.r) .. [[,]] .. math.Round(dat.soup.appearance.color.g) .. [[,]] .. math.Round(dat.soup.appearance.color.b) .. [[),
            material = "]] .. dat.soup.appearance.material .. [[",
            lpos = Vector(]] .. math.Round(dat.soup.appearance.lpos.x,2) .. [[,]] .. math.Round(dat.soup.appearance.lpos.y,2) .. [[,]] .. math.Round(dat.soup.appearance.lpos.z,2) .. [[),
            ]]
            // Add Bodygroups
            if dat.soup.appearance.bgs then
                text = text .. [[bgs = {]]
                for k, v in pairs(dat.soup.appearance.bgs) do
                    text = text .. "[" .. k .. "]" .. [[ = ]] .. v .. [[,]]
                end
                text = text .. [[},
        ]]
            end
        text = text .. [[},
        items = {]]
        for k, v in pairs(dat.soup.items) do
            text = text .. [["]] .. v .. [[",]]
        end
        text = text .. [[},
    },
]]
    end

    // Add boil Data
    if dat.boil then
        text = text .. [[
    boil = {
        time = ]] .. dat.boil.time .. [[,
        item = "]] .. dat.boil.item .. [[",
        temp = {start = ]] .. dat.boil.temp.start .. [[,range = ]] .. dat.boil.temp.range .. [[,}
    },
]]
    end


    // Add craft Data
    if dat.craft then
        text = text .. [[
    craft = {
        amount = ]] .. dat.craft.amount .. [[,
        items = {]]
        for k, v in pairs(dat.craft.items) do
            text = text .. [["]] .. v .. [[",]]
        end
        text = text .. [[},
    },
]]
    end
text = text .. [[
})]]
text = string.Replace(text,[[\]],[[/]])
return text
end

function zmc.Item.Interface.Copytoclipboard(id)
    local dat = zmc.Item.GetData(id)
    if dat == nil then return end

    SetClipboardText( BuildClipboard(id) )
    zclib.vgui.Notify(zmc.language["Config code copied to clipboard!"],NOTIFY_GENERIC)
end


concommand.Add("zmc_GetItemConfig", function(ply, cmd, args)
    if zclib.Player.IsAdmin(ply) then
        local text = ""
        for k,v in pairs(zmc.config.Items) do
            text = text .. BuildClipboard(k)

            text = text .. [[


]]
        end
        SetClipboardText( text )
        zclib.vgui.Notify(zmc.language["Config code copied to clipboard!"],NOTIFY_GENERIC)
    end
end)
