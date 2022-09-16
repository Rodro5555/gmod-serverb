if SERVER then return end

zmlab2 = zmlab2 or {}
zmlab2.Interface = zmlab2.Interface or {}


local VGUIItem = {}

local MainPanel

local Tooltip_pnl

function zmlab2.Interface.Create(w,h,title,AppendContent)
    if IsValid(MainPanel) then MainPanel:Remove() end

    local LastHovered
    zclib.Hook.Remove("Think", "zmlab2_Interface_Hover")
    zclib.Hook.Add("Think", "zmlab2_Interface_Hover", function()
        local pnl = vgui.GetHoveredPanel()

        if pnl ~= LastHovered then
            LastHovered = pnl

            // Delete old tooltip
            if IsValid(Tooltip_pnl) then Tooltip_pnl:Remove() end

            // If the new hovered panel has tooltip data then lets rebuild the tooltip
            if IsValid(pnl) and pnl.ToolTipData and (pnl.IsLocked == nil or pnl.IsLocked == false) then
                zmlab2.Interface.CreateTooltip(pnl.ToolTipData.t_mdldata,pnl.ToolTipData.s_name,pnl.ToolTipData.s_money,pnl.ToolTipData.data)
            end
        end
    end)

    MainPanel = vgui.Create("zmlab2_vgui_main")
    MainPanel:SetSize(w * zclib.wM, h * zclib.hM)
    MainPanel:Center()

    local font = zclib.GetFont("zclib_font_big")
    local txtSize = zclib.util.GetTextSize(title,font)
    if txtSize >= 200 * zclib.wM then font = zclib.GetFont("zclib_font_medium") end


    MainPanel.Title:SetFont(font)
    MainPanel.Title:SetText(title)
    MainPanel.Title:SizeToContentsX(15)

    pcall(AppendContent,MainPanel)
end

function VGUIItem:Init()
    self:SetSize(15 * zclib.wM, 15 * zclib.hM)
    self:Center()
    self:MakePopup()
    self:ShowCloseButton(false)
    self:SetTitle("")
    self:SetDraggable(true)
    self:SetSizable(false)

    self:DockMargin(0, 0, 0, 0)
    self:DockPadding( 10 * zclib.wM,10 * zclib.wM,10 * zclib.wM,10 * zclib.wM)

    local TopContainer = vgui.Create("DPanel", self)
    TopContainer:SetAutoDelete(true)
    TopContainer:SetSize(self:GetWide(), 50 * zclib.hM)
    TopContainer.Paint = function(s, w, h)
        zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w - 55 * zclib.wM, h, 2, color_white)
    end
    TopContainer:Dock(TOP)


    local close_btn = vgui.Create("DButton", TopContainer)
    close_btn:SetPos(self:GetWide() - 49 * zclib.wM, 0)
    close_btn:SetSize(50 * zclib.wM, 50 * zclib.hM)
    close_btn:SetText("")
    close_btn.Paint = function(s, w, h)
        zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2, color_white)
        surface.SetDrawColor(color_white)
        surface.SetMaterial(zclib.Materials.Get("close"))
        surface.DrawTexturedRect(0, 0, w, h)

        if s:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, zclib.colors["white_a100"])
        end
    end
    close_btn.DoClick = function(s)
        zclib.vgui.PlaySound("UI/buttonclick.wav")
        s:SetEnabled(false)

        timer.Simple(0.25, function()
            if IsValid(s) then
                s:SetEnabled(true)
            end
        end)

        self:Close()
    end
    close_btn:Dock(RIGHT)

    local TitleBox = vgui.Create("DLabel", TopContainer)
    TitleBox:SetAutoDelete(true)
    TitleBox:SetSize(200 * zclib.wM, 50 * zclib.hM)
    TitleBox:SetPos(0 * zclib.wM, 0 * zclib.hM)
    TitleBox:Dock(LEFT)
    TitleBox:SetText("Test")
    TitleBox:SetTextColor(color_white)
    TitleBox:SetFont(zclib.GetFont("zclib_font_big"))
    TitleBox:SetContentAlignment(5)
    self.Title = TitleBox
end

function VGUIItem:Paint(w, h)
    surface.SetDrawColor(zmlab2.colors["blue02"])
    surface.SetMaterial(zclib.Materials.Get("item_bg"))
    surface.DrawTexturedRect(0 * zclib.wM, 0 * zclib.hM, w,h)

    zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2, color_white)
end

function VGUIItem:Close()
    if IsValid(Tooltip_pnl) then
        Tooltip_pnl:Remove()
    end

    if IsValid(MainPanel) then
        MainPanel:Remove()
    end

    zclib.Hook.Remove("Think", "zmlab2_Interface_Hover")
end

vgui.Register("zmlab2_vgui_main", VGUIItem, "DFrame")

function zmlab2.Interface.CreateTooltip(t_mdldata, s_name, s_money, data)
    if IsValid(Tooltip_pnl) then
        Tooltip_pnl:Remove()
    end

    if not IsValid(MainPanel) then return end

    local ToolTipSize = MainPanel:GetTall()
    local x, y = MainPanel:GetPos()

    local main_pnl = vgui.Create("DPanel")
    main_pnl:ParentToHUD()
    main_pnl:SetSize(ToolTipSize, ToolTipSize)
    main_pnl:SetPos(x - ToolTipSize - 5 * zclib.wM, y)
    main_pnl.Paint = function(s, w, h)
        surface.SetDrawColor(zmlab2.colors["blue02"])
        surface.SetMaterial(zclib.Materials.Get("item_bg"))
        surface.DrawTexturedRect(0 * zclib.wM, 0 * zclib.hM, w, h)
    end
    Tooltip_pnl = main_pnl

    local tt_img = zclib.vgui.ModelPanel(t_mdldata)
    tt_img:SetSize(ToolTipSize, ToolTipSize)
    tt_img:SetParent(main_pnl)
    tt_img:DockPadding(10 * zclib.hM, 5 * zclib.hM, 10 * zclib.hM, 10 * zclib.hM)
    tt_img.PostDrawModel = function(s,ent)
        cam.Start2D()
            local desc_height = 1 * zclib.hM
            if tt_img.desc then desc_height = tt_img.desc:GetTall() + 10 * zclib.hM end

            local bg_h = desc_height + 50 * zclib.hM
            surface.SetDrawColor(zmlab2.colors["black04"])
            surface.SetMaterial(zclib.Materials.Get("linear_gradient"))
            surface.DrawTexturedRectRotated(ToolTipSize / 2, bg_h / 2, ToolTipSize,bg_h, 180)

            zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, ToolTipSize, ToolTipSize, 2, color_white)
        cam.End2D()
    end
    tt_img.LayoutEntity = function(s,ent)
        ent:SetAngles(Angle(0,CurTime() * 7,0))
    end


    local function AddItem(txt01, font, _dock, align)
        local pnl = vgui.Create("DLabel", tt_img)
        pnl:SetAutoDelete(true)
        pnl:SetAutoStretchVertical(true)
        pnl:SetSize(ToolTipSize, ToolTipSize)
        pnl:Dock(_dock)
        pnl:SetText(txt01)
        pnl:SetTextColor(color_white)
        pnl:SetFont(font)
        pnl:SetContentAlignment(align or 4)
        pnl:SetWrap(true)
        pnl.Paint = function(s, w, h)

        end
        return pnl
    end

    if s_name then
        local font = zclib.GetFont("zclib_font_big")
        local txtSize = zclib.util.GetTextSize(s_name,font)
        if txtSize >  350 * zclib.hM then font = zclib.GetFont("zclib_font_medium") end
        AddItem(s_name, font, TOP, 7)
    end

    if data.desc then
        local pnl = AddItem(data.desc, zclib.GetFont("zclib_font_small_thin"), TOP)
        pnl:DockMargin(0 * zclib.hM, 5 * zclib.hM, 0 * zclib.hM, 5 * zclib.hM)
        tt_img.desc = pnl
    end

    local BoxSize = 40 * zclib.hM
    local function AddItemBox(txt01,txt02,txt02_color)

        local font = zclib.GetFont("zmlab2_vgui_font02")

        local pnl = vgui.Create("DPanel", tt_img)
        pnl:SetAutoDelete(true)
        pnl:SetSize(BoxSize, BoxSize)
        pnl:Dock(BOTTOM)
        pnl:DockMargin(0,5 * zclib.hM,0,0)
        pnl.Paint = function(s, w, h)
            draw.RoundedBox(0, 0 * zclib.wM, 0 * zclib.hM,w,h, zclib.colors["black_a200"])

            draw.SimpleText(txt01,font, 10 * zclib.wM, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            draw.SimpleText(txt02,font, w - 10 * zclib.wM, h / 2, txt02_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end
        return pnl
    end

    if data.filter_time and data.mix_time and data.vent_time then
        local time = data.filter_time + (data.mix_time * 2) + data.vent_time
        AddItemBox(zmlab2.language["Duration"], zclib.util.FormatTime(time), color_white)
    end

    if data.batch_size then
        AddItemBox(zmlab2.language["Amount"], data.batch_size .. zmlab2.config.UoM, zmlab2.colors["orange01"])
    end

    if data.difficulty then

        local function GetDiffColor(a, b, c, t)
            if (t < 0.5) then
                return zclib.util.LerpColor(t / 0.5, a, b)
            else
                return zclib.util.LerpColor((t - 0.5) / 0.5, b, c)
            end
        end

        local fract = (1 / 10) * data.difficulty
        local diff_col = GetDiffColor(zmlab2.colors["green03"],zmlab2.colors["orange01"],zmlab2.colors["red02"],fract)

        local diff_str = ""
        if data.difficulty <= 3 then
            diff_str = zmlab2.language["Difficulty_Easy"]
        elseif data.difficulty <= 6 then
            diff_str = zmlab2.language["Difficulty_Medium"]
        elseif data.difficulty <= 9 then
            diff_str = zmlab2.language["Difficulty_Hard"]
        else
            diff_str = zmlab2.language["Difficulty_Expert"]
        end

        AddItemBox(zmlab2.language["Difficulty"], diff_str, diff_col)
    end

    if s_money then
        AddItemBox(zmlab2.language["Money"], s_money, zmlab2.colors["green03"])
    end
end

function zmlab2.Interface.AddColorList(pnl, list, isLocked, isSelected, onClick, prePopulate)
    local MainContainer = vgui.Create("DIconLayout", pnl)
    MainContainer:Dock(FILL)
    MainContainer:DockMargin(0 * zclib.wM, 10 * zclib.hM, 0 * zclib.wM, 0)
    MainContainer:SetSpaceX(10 * zclib.wM)
    MainContainer:SetSpaceY(10 * zclib.wM)
    MainContainer.Paint = function(s, w, h) end

    MainContainer:InvalidateParent(true)

    local item_size = MainContainer:GetWide() / 5
    item_size = item_size - (8 * zclib.wM)
    pcall(prePopulate, MainContainer, item_size)

    for k, v in ipairs(list) do
        local _, b_isLocked = pcall(isLocked, k)
        local itm = MainContainer:Add("DButton")
        itm:SetAutoDelete(true)
        itm:SetSize(item_size, item_size)
        itm:SetText("")

        itm.Paint = function(s, w, h)
            if b_isLocked == false then
                draw.RoundedBox(0, 0, 0, w, h, v)

                if IsValid(LocalPlayer().zmlab2_Tent) and LocalPlayer().zmlab2_Tent:GetColorID() == k then
                    zclib.util.DrawOutlinedBox(0, 0, w, h, 2, color_white)
                end

                if s:IsHovered() then
                    draw.RoundedBox(0, 0, 0, w, h, zmlab2.colors["white02"])
                end
            else
                surface.SetDrawColor(zmlab2.colors["grey02"])
                surface.SetMaterial(zclib.Materials.Get("icon_locked"))
                surface.DrawTexturedRect(0 * zclib.wM, 0 * zclib.hM, w, h)
            end
        end

        itm.DoClick = function(s)
            zclib.vgui.PlaySound("UI/buttonclick.wav")
            if b_isLocked == true then return end
            pcall(onClick, k)
        end
    end

    MainContainer:Center()
end

function zmlab2.Interface.AddModelList(pnl,list,isLocked,isSelected,onClick,getData,prePopulate)

    // Add scrollbar if we got more items
    local MainContainer,SubSize
    if table.Count(list) > 8 then
        local MainScroll = vgui.Create( "DScrollPanel", pnl )
        MainScroll:Dock( FILL )
        MainScroll:DockMargin(0 * zclib.wM,10 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        MainScroll.Paint = function(s, w, h)
            draw.RoundedBox(0, 0, 0, w, h, zclib.colors["black_a100"])
        end
        local sbar = MainScroll:GetVBar()
        SubSize = sbar:GetWide()
        sbar:SetHideButtons( true )
        function sbar:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, zclib.colors["black_a100"])
        end
        function sbar.btnUp:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, zmlab2.colors["blue02"])
        end
        function sbar.btnDown:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, zmlab2.colors["blue02"])
        end
        function sbar.btnGrip:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, zmlab2.colors["blue02"])
        end

        MainContainer = vgui.Create("DIconLayout", MainScroll)
        MainContainer:Dock(FILL)
        MainContainer:SetSpaceX(10 * zclib.wM)
        MainContainer:SetSpaceY(10 * zclib.wM)
        MainContainer.Paint = function(s, w, h)
            //draw.RoundedBox(0, 0, 0, w, h, color_white)
        end
    else
        MainContainer = vgui.Create("DIconLayout", pnl)
        MainContainer:Dock(FILL)
        MainContainer:DockMargin(0 * zclib.wM, 10 * zclib.hM, 0 * zclib.wM, 0)
        MainContainer:SetSpaceX(10 * zclib.wM)
        MainContainer:SetSpaceY(10 * zclib.wM)
        MainContainer.Paint = function(s, w, h)
            //draw.RoundedBox(0, 0, 0, w, h, color_white)
        end

        SubSize = 13 * zclib.wM
    end


    pnl:InvalidateParent(true)
    local item_size = pnl:GetWide() / 4
    item_size = item_size - SubSize

    pcall(prePopulate,MainContainer,item_size)

    for k, v in ipairs(list) do

        local _,b_isLocked = pcall(isLocked,k)

        local itm =  MainContainer:Add("DPanel")
        itm:SetAutoDelete(true)
        itm:SetSize(item_size, item_size)
        itm.Paint = function(s, w, h)
            surface.SetDrawColor(zmlab2.colors["blue02"])
            surface.SetMaterial(zclib.Materials.Get("item_bg"))
            surface.DrawTexturedRect(0 * zclib.wM, 0 * zclib.hM, w,h)

            draw.RoundedBox(0, 0, 0, w, h, zclib.colors["black_a100"])
        end

        //if b_isLocked == true then continue end

        local _,t_mdldata,s_name,s_money = pcall(getData,v)

        local mdl = zclib.vgui.ModelPanel(t_mdldata)
        mdl:SetParent(itm)
        mdl:SetAutoDelete(true)
        mdl:Dock(FILL)
        mdl:DockMargin(5 * zclib.wM,5 * zclib.hM,5 * zclib.wM,5 * zclib.hM)

        local Button = vgui.Create("DButton", itm)
        Button:Dock(FILL)
        Button:SetText("")
        Button.IsLocked = b_isLocked

        local font = zclib.GetFont("zmlab2_vgui_font02")
        local txtSize = zclib.util.GetTextSize(s_name,font)
        if txtSize >= item_size then font = zclib.GetFont("zmlab2_vgui_font05") end

        Button.Paint = function(s, w, h)
            if s.IsLocked then
                zclib.util.DrawBlur(s, 1, 5)

                surface.SetDrawColor(color_white)
                surface.SetMaterial(zclib.Materials.Get("icon_locked"))
                surface.DrawTexturedRectRotated(w / 2, h / 2, w * 0.7, h * 0.7, 0)
            else
                surface.SetDrawColor(color_black)
                surface.SetMaterial(zclib.Materials.Get("linear_gradient"))
                surface.DrawTexturedRectRotated(w / 2, 15 * zclib.hM, w, 30 * zclib.hM, 180)

                draw.SimpleText(s_name, font, 7 * zclib.wM,4 * zclib.hM, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            end

            local _,b_isSelected = pcall(isSelected,k)
            if b_isSelected == true then
                zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2, zmlab2.colors["orange01"])
            else
                zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2, color_white)
            end

            if s:IsHovered() then draw.RoundedBox(0, 0, 0, w, h, zmlab2.colors["white03"]) end
        end
        Button.DoClick = function(s)
            zclib.vgui.PlaySound("UI/buttonclick.wav")
            if s.IsLocked then

                return
            end
            pcall(onClick,k)
        end

        Button.ToolTipData = {
            t_mdldata = t_mdldata,
            s_name = s_name,
            s_money = s_money,
            data = v
        }
    end

    MainContainer:Center()
end
