if SERVER then return end
zpiz = zpiz or {}
zpiz.vgui = zpiz.vgui or {}

function zpiz.vgui.Page(title,content,desc)
    if IsValid(zpiz_main_panel) then zpiz_main_panel:Remove() end

    local mainframe = vgui.Create("DFrame")
    mainframe:SetSize(600 * zclib.wM, 500 * zclib.hM)
    mainframe:Center()
    mainframe:MakePopup()
    mainframe:ShowCloseButton(false)
    mainframe:SetTitle("")
    mainframe:SetDraggable(true)
    mainframe:SetSizable(false)
    mainframe:DockPadding(0,15 * zclib.hM,0,30 * zclib.hM)
    mainframe.BgColor = zclib.colors["ui02"]
    mainframe.Paint = function(s,w, h)
        //draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui02"])

        surface.SetDrawColor(s.BgColor)
    	surface.SetMaterial(zpiz.materials["zpiz_ui_panel"])
    	surface.DrawTexturedRect(0, 0, w, h)

        surface.SetMaterial(zclib.Materials.Get("grib_horizontal"))
        surface.SetDrawColor(zclib.colors["white_a15"])
        surface.DrawTexturedRectUV(0, 0, w, 20 * zclib.hM, 0, 0, w / (30 * zclib.hM), (20 * zclib.hM) / (20 * zclib.hM))

        if input.IsKeyDown(KEY_ESCAPE) and IsValid(mainframe) then
            mainframe:Remove()
        end
    end
    zpiz_main_panel = mainframe
    zpiz_main_panel.Title = title

    local top_pnl = vgui.Create("DPanel", mainframe)
    top_pnl:SetSize(600 * zclib.wM, 80 * zclib.hM)
    top_pnl:Dock( TOP )
    top_pnl:DockPadding(10 * zclib.wM,10 * zclib.hM,10 * zclib.wM,20 * zclib.hM)
    top_pnl:DockMargin(0 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
    top_pnl.Title_font = zclib.GetFont("zclib_font_bigger")
    top_pnl.Paint = function(s, w, h)
        draw.RoundedBox(5, 50 * zclib.wM, h - 8 * zclib.hM, w, 5 * zclib.hM, zclib.colors["white_a15"])
        if desc then
            draw.SimpleText(title, s.Title_font, 50 * zclib.wM,30 * zclib.hM,color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(desc, zclib.GetFont("zclib_font_mediumsmall_thin"), 50 * zclib.wM,60 * zclib.hM,zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(title, s.Title_font, 50 * zclib.wM,h - 10 * zclib.hM,color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        end
    end

    pcall(content,mainframe,top_pnl)


    mainframe:InvalidateLayout(true)
    mainframe:SizeToChildren(false,true)
    mainframe:Center()
end

function zpiz.vgui.AddSeperator(parent)
    local seperator = vgui.Create("DPanel", parent)
    seperator:SetSize(600 * zclib.wM, 5 * zclib.hM)
    seperator:Dock(TOP)
    seperator:DockMargin(50 * zclib.wM, 10 * zclib.hM, 50 * zclib.wM, 0 * zclib.hM)
    seperator.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["white_a15"])
    end
    return seperator
end

function zpiz.vgui.List(parent)
    local scroll = vgui.Create( "DScrollPanel", parent )
    scroll:Dock( FILL )
    scroll:DockMargin(10 * zclib.wM,10 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
    scroll.Paint = function(s, w, h)
        // 229407176
    end
    local sbar = scroll:GetVBar()
    sbar:SetHideButtons( true )
    function sbar:Paint(w, h) draw.RoundedBox(5, w * 0.1, 0, w * 0.8, h, zclib.colors["black_a50"]) end
    function sbar.btnUp:Paint(w, h) end
    function sbar.btnDown:Paint(w, h) end
    function sbar.btnGrip:Paint(w, h) draw.RoundedBox(5, w * 0.1, 0, w * 0.8, h, zclib.colors["text01"]) end

    function scroll:JumpToChild( panel )

    	self:InvalidateLayout( true )

    	local _, y = self.pnlCanvas:GetChildPosition( panel )
    	local _, h = panel:GetSize()

    	y = y + h * 0.5
    	y = y - self:GetTall() * 0.5

    	self.VBar:AnimateTo( y, 0.01, 0, 0.5 )
    end

    local list = vgui.Create( "DIconLayout", scroll )
    list:Dock( FILL )
    list:SetSpaceY( 10 * zclib.hM)
    list:SetSpaceX( 10 * zclib.wM)
    list:DockMargin(10 * zclib.wM,10 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
    list.Paint = function(s, w, h)
        //draw.RoundedBox(0, 0, 0, w, h, zclib.colors["red01"])
    end
    list:Layout()

    return list , scroll
end

function zpiz.vgui.TitledList(parent,title)
    local main = vgui.Create("DPanel", parent)
    main:SetSize(600 * zclib.wM, 600 * zclib.hM)
    main:Dock(LEFT)
    main:DockMargin(50 * zclib.wM, 10 * zclib.hM, 50 * zclib.wM, 0 * zclib.hM)
    main:DockPadding(0, 50 * zclib.hM,0,0)
    main.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
        draw.SimpleText(title, zclib.GetFont("zclib_font_medium"), 10 * zclib.wM,5 * zclib.hM, zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
    local list,scroll = zpiz.vgui.List(main)
    scroll:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,10 * zclib.hM)
    list:DockMargin(0 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)

    return main,list,scroll
end

function zpiz.vgui.Button(parent,text,color,OnClick)
    local btn = vgui.Create("DButton", parent)
    btn:SetTall(50 * zclib.hM)
    btn:Dock(TOP)
    btn:DockMargin(50 * zclib.wM, 10 * zclib.hM, 50 * zclib.wM, 0 * zclib.hM)
    btn:SetText("")
    btn.Paint = function(s, w, h)
        zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2,color)
        draw.SimpleText(text, zclib.GetFont("zclib_font_mediumsmall"), w / 2, h / 2,color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if s:IsHovered() then draw.RoundedBox(5, 0, 0, w, h, zclib.colors["white_a15"]) end
    end
    btn.DoClick = function(s)
        zclib.vgui.PlaySound("UI/buttonclick.wav")
        pcall(OnClick)
    end
    return btn
end
