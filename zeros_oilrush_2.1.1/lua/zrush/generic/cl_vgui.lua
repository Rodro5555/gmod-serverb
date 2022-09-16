if SERVER then return end
zrush = zrush or {}
zrush.vgui = zrush.vgui or {}

function zrush.vgui.Close()
    if IsValid(zrush_main_panel) then
        zrush_main_panel:Remove()
    end
end

function zrush.vgui.Page(title,content,desc)
    zrush.vgui.Close()

    local mainframe = vgui.Create("DFrame")
    mainframe:SetSize(1000 * zclib.wM, 800 * zclib.hM)
    mainframe:Center()
    mainframe:MakePopup()
    mainframe:ShowCloseButton(false)
    mainframe:SetTitle("")
    mainframe:SetDraggable(true)
    mainframe:SetSizable(false)
    mainframe:DockPadding(0,15 * zclib.hM,0,30 * zclib.hM)
    mainframe.Paint = function(s,w, h)
        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui02"])

        surface.SetMaterial(zclib.Materials.Get("grib_horizontal"))
        surface.SetDrawColor(zclib.colors["white_a5"])
        surface.DrawTexturedRectUV(0, 0, w, 20 * zclib.hM, 0, 0, w / (30 * zclib.hM), (20 * zclib.hM) / (20 * zclib.hM))

        if input.IsKeyDown(KEY_ESCAPE) and IsValid(mainframe) then
            mainframe:Remove()
        end
    end
    mainframe.Close = function()
        zrush.vgui.Close()
        zrush.vgui.ActiveEntity = nil
    end
    zrush_main_panel = mainframe


    title = tostring(title)

    local top_pnl = vgui.Create("DPanel", mainframe)
    top_pnl:SetSize(600 * zclib.wM, 80 * zclib.hM)
    top_pnl:Dock( TOP )
    top_pnl:DockPadding(10 * zclib.wM,10 * zclib.hM,10 * zclib.wM,20 * zclib.hM)
    top_pnl:DockMargin(0 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
    top_pnl.Title_font = zclib.GetFont("zclib_font_big")
    top_pnl.Title_color = zclib.colors["text01"]
    top_pnl.Paint = function(s, w, h)
        draw.RoundedBox(5, 50 * zclib.wM, h - 8 * zclib.hM, w, 5 * zclib.hM, zclib.colors["ui01"])
        if desc then
            draw.SimpleText(title, s.Title_font, 50 * zclib.wM,30 * zclib.hM,s.Title_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(desc, zclib.GetFont("zclib_font_mediumsmall_thin"), 50 * zclib.wM,60 * zclib.hM,zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(title, s.Title_font, 50 * zclib.wM,35 * zclib.hM,s.Title_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end

    pcall(content,mainframe,top_pnl)


    mainframe:InvalidateLayout(true)
    mainframe:SizeToChildren(false,true)
    mainframe:Center()
end

function zrush.vgui.AddSeperator(parent)
    local seperator = vgui.Create("DPanel", parent)
    seperator:SetSize(600 * zclib.wM, 5 * zclib.hM)
    seperator:Dock(TOP)
    seperator:DockMargin(50 * zclib.wM, 10 * zclib.hM, 50 * zclib.wM, 0 * zclib.hM)
    seperator.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
    end
    return seperator
end

function zrush.vgui.List(parent)
    local scroll = vgui.Create( "DScrollPanel", parent )
    scroll:Dock( FILL )
    scroll:DockMargin(10 * zclib.wM,10 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
    scroll.Paint = function(s, w, h)
        //draw.RoundedBox(0, 0, 0, w, h, zclib.colors["blue01"])
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

function zrush.vgui.Button(parent,text,color,OnClick)
    local btn = vgui.Create("DButton", parent)
    btn:SetTall(50 * zclib.hM)
    btn:Dock(TOP)
    btn:DockMargin(50 * zclib.wM, 10 * zclib.hM, 50 * zclib.wM, 0 * zclib.hM)
    btn:SetText("")
    btn.Text = text
    btn.Text_font = zclib.GetFont("zclib_font_mediumsmall")
    btn.Paint = function(s, w, h)
        zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2,color)
        draw.SimpleText(s.Text, s.Text_font, w / 2, h / 2,color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if s.IsLocked then
            draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a50"])
        else
            if s:IsHovered() then draw.RoundedBox(5, 0, 0, w, h, zclib.colors["white_a15"]) end
        end
    end
    btn.DoClick = function(s)
        if s.IsLocked then return end
        zclib.vgui.PlaySound("UI/buttonclick.wav")
        pcall(OnClick)
    end
    return btn
end
