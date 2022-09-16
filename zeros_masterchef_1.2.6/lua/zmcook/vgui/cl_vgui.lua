if SERVER then return end

zmc = zmc or {}
zmc.vgui = zmc.vgui or {}

function zmc.vgui.Page(title,content,desc)
    if IsValid(zmc_main_panel) then zmc_main_panel:Remove() end

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
    zmc_main_panel = mainframe
    zmc_main_panel.Close = function()
        if IsValid(zmc_main_panel) then
            zmc_main_panel:Remove()
        end

        zmc.vgui.ActiveEntity = nil
    end

    local top_pnl = vgui.Create("DPanel", mainframe)
    top_pnl:SetSize(600 * zclib.wM, 80 * zclib.hM)
    top_pnl:Dock( TOP )
    top_pnl:DockPadding(10 * zclib.wM,10 * zclib.hM,10 * zclib.wM,20 * zclib.hM)
    top_pnl:DockMargin(0 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
    top_pnl.Title_font = zclib.GetFont("zclib_font_big")
    top_pnl.Paint = function(s, w, h)
        draw.RoundedBox(5, 50 * zclib.wM, h - 8 * zclib.hM, w, 5 * zclib.hM, zclib.colors["ui01"])
        if desc then
            draw.SimpleText(title, s.Title_font, 50 * zclib.wM,30 * zclib.hM,zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(desc, zclib.GetFont("zclib_font_mediumsmall_thin"), 50 * zclib.wM,60 * zclib.hM,zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(title, s.Title_font, 50 * zclib.wM,35 * zclib.hM,zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end

    pcall(content,mainframe,top_pnl)
end

function zmc.vgui.TitledTextEntry(parent,height,font,name,default,empty,hasrefreshbutton,OnChange,OnRefresh)
    local m = vgui.Create("DPanel", parent)
    m:SetSize(600 * zclib.wM, height * zclib.hM)
    m:DockMargin(0 * zclib.wM,10 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
    m:Dock(TOP)
    m.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
        draw.SimpleText(name, font, 10 * zclib.wM,h / 2,zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    m:InvalidateLayout(true)
    m:InvalidateParent(true)

    local p = vgui.Create("DTextEntry", m)
    p:SetSize(200 * zclib.wM, height * zclib.hM )
    p:Dock(FILL)
    p:DockMargin(120 * zclib.wM,0 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
    p:SetPaintBackground(false)
    p:SetAutoDelete(true)
    p:SetUpdateOnType(true)
    p.font = zclib.GetFont("zclib_font_small")
    p.Paint = function(s, w, h)
        //draw.RoundedBox(4, 0, 0, w, h, zclib.colors["ui01"])

        if s:GetText() == "" and not s:IsEditing() then
            draw.SimpleText(empty, s.font, 5 * zclib.wM, h / 2, zclib.colors["white_a15"], 0, 1)
        end

        s:DrawTextEntryText(color_white, zclib.colors["textentry"], color_white)
    end
    p:SetDrawLanguageID(false)
    p.OnValueChange = function(s,val)
        pcall(OnChange,val)
    end
    if default then p:SetValue(default) end
    m.textentry = p

    function p:PerformLayout()
        self:SetFontInternal(self.font)
    end

    if hasrefreshbutton then
        local b = vgui.Create("DButton",m)
        b:SetText("")
        b:SetSize(50 * zclib.wM, height * zclib.hM )
        b:Dock(RIGHT)
        b.DoClick = function()
            OnRefresh(p:GetText())
        end
        b.Paint = function(s, w, h)
            surface.SetDrawColor(zclib.colors["textentry"])
            surface.SetMaterial(zclib.Materials.Get("refresh"))
            if b:IsHovered() then
                surface.DrawTexturedRectRotated( w / 2, h / 2, h * 0.9, h * 0.9,CurTime() * -100)
            else
                surface.DrawTexturedRectRotated( w / 2, h / 2, h * 0.9, h * 0.9,0)
            end
        end
    end

    return m
end

function zmc.vgui.TitledSlider(parent,text,start_val,onChange,height,OnValueChangeStop,_AreaW,_AreaX)
    local p = vgui.Create("DButton", parent)
    p.locked = false
    p.slideValue = start_val
    p.displayValue = function(s)
        return math.Round(s.slideValue * 100)
    end
    p.font =  zclib.GetFont("zclib_font_medium")
    p.title_color =  zclib.colors["orange01"]
    p:SetAutoDelete(true)
    p:SetText("")
    p.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])

        draw.SimpleText(text, s.font,10 * zclib.wM, h / 2,s.title_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        draw.SimpleText(s:displayValue(), s.font,w - 5 * zclib.wM, h / 2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

        local AreaW = w * (_AreaW or 0.45)
        local AreaX = w * (_AreaX or 0.38)
        draw.RoundedBox(4, AreaX, h * 0.5, AreaW, 2 * zclib.hM, color_black)

        local boxHeight = h * 0.5
        local boxPosX = AreaW * s.slideValue
        draw.RoundedBox(4, (AreaX - (boxHeight / 2)) + boxPosX, boxHeight / 2, boxHeight, boxHeight, zclib.colors["text01"])

        if p.locked == true then
            draw.RoundedBox(4, 0, 0, w, h, zclib.colors["black_a100"])
        end

        if s:IsDown() then
            s.StartedDrag = true
            local x,_ = s:CursorPos()
            local min = AreaX
            local max = min + AreaW

            x = math.Clamp(x, min, max)

            local val = (1 / AreaW) * (x - min)

            s.slideValue = math.Round(val,2)

            if s.slideValue ~= s.LastValue then
                s.LastValue = s.slideValue

                if s.locked == true then return end
                pcall(onChange,s.slideValue,s)
            end
        else
            if s.StartedDrag == true then
                s.StartedDrag = nil
                pcall(OnValueChangeStop,s.slideValue,s)
            end
        end
    end
    p:SetSize(200 * zclib.wM,(height or 50) * zclib.hM )
    p:DockMargin(50 * zclib.wM,10 * zclib.hM,50 * zclib.wM,0 * zclib.hM)
    p:Dock(TOP)
    return p
end

function zmc.vgui.TitledCheckbox(parent,text,start_val,onclick)
    local p = vgui.Create("DButton", parent)
    p:SetSize(200 * zclib.wM,50 * zclib.hM )
    p.locked = false
    p.state = start_val
    p.slideValue = 0
    p.font = zclib.GetFont("zclib_font_medium")
    p:SetAutoDelete(true)
    p:SetText("")
    p.Paint = function(s, w, h)

        local BoxWidth = w * 0.2
        local BoxHeight = h * 0.5
        local BoxPosY = h * 0.25
        local BoxPosX = w * 0.78

        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
        draw.SimpleText(text, s.font, 10 * zclib.wM, h / 2, zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.RoundedBox(4, BoxPosX, BoxPosY, BoxWidth, BoxHeight, zclib.colors["black_a100"])

        if s.state then
            s.slideValue = Lerp(5 * FrameTime(), s.slideValue, 1)
        else
            s.slideValue = Lerp(5 * FrameTime(), s.slideValue, 0)
        end

        local col = zclib.util.LerpColor(s.slideValue, zclib.colors["red01"], zclib.colors["green01"])
        draw.RoundedBox(4, BoxPosX + (BoxWidth - BoxHeight) * s.slideValue, BoxPosY, BoxHeight, BoxHeight, col)

        if p.locked == true then
            draw.RoundedBox(4, BoxPosX, BoxPosY, BoxWidth, BoxHeight, zclib.colors["black_a100"])
        end
    end
    p:SetSize(600 * zclib.wM, 50 * zclib.hM)
    p:DockMargin(50 * zclib.wM,10 * zclib.hM,50 * zclib.wM,0 * zclib.hM)
    p:Dock(TOP)
    p.DoClick = function(s)
        if p.locked == true then return end
        zclib.vgui.PlaySound("UI/buttonclick.wav")
        s.state = not s.state
        pcall(onclick,s.state)
    end

    /*
    timer.Simple(0,function()
        if not IsValid(p) then return end

        if zclib.util.GetTextSize(text,zclib.GetFont("zclib_font_medium")) >= (p:GetWide() - 100 * zclib.wM) then
            p.font = zclib.GetFont("zclib_font_mediumsmall")
        end

    end)
    */


    return p
end

function zmc.vgui.AddSeperator(parent)
    local seperator = vgui.Create("DPanel", parent)
    seperator:SetSize(600 * zclib.wM, 5 * zclib.hM)
    seperator:Dock(TOP)
    seperator:DockMargin(50 * zclib.wM, 10 * zclib.hM, 50 * zclib.wM, 0 * zclib.hM)
    seperator.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
    end
    return seperator
end


function zmc.vgui.TitledComboBox(parent,data,default,OnSelect)

    local m = vgui.Create("DPanel", parent)
    m:SetSize(600 * zclib.wM, 50 * zclib.hM)
    m:DockMargin(50 * zclib.wM,10 * zclib.hM,50 * zclib.wM,0 * zclib.hM)
    m:Dock(TOP)
    m.t_name = ""
    m.t_col = zclib.colors["orange01"]
    m.t_font = zclib.GetFont("zclib_font_medium")
    m.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
        draw.SimpleText(m.t_name, m.t_font, 10 * zclib.wM,h / 2,m.t_col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    if isstring(data) then
        m.t_name = data
    elseif istable(data) then
        m.t_name = data.name
        m.t_col = data.color
        m.t_font = data.font
    end

    local DComboBox = vgui.Create( "DComboBox", m )
    DComboBox:SetSize(200 * zclib.wM, 50 * zclib.hM)
    DComboBox:DockMargin(240 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
    DComboBox:Dock(FILL)
    if default then
        DComboBox:SetValue(default)
    end
    DComboBox:SetColor(zclib.colors["text01"] )
    DComboBox.Paint = function(s, w, h) draw.RoundedBox(4, 0, 0, w, h, zclib.colors["ui01"]) end
    DComboBox.OnSelect = function( s, index, value ,data_val) pcall(OnSelect,index,value,DComboBox,data_val) end

    DComboBox.main = m

    return DComboBox
end

function zmc.vgui.ConfirmationWindow(parent,question,OnAccept,OnDecline)
    local bg_pnl = vgui.Create("DPanel", parent)
    bg_pnl:SetWide(parent:GetWide())
    bg_pnl:SetTall(parent:GetTall())
    bg_pnl.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, zclib.colors["black_a200"])
    end
    bg_pnl.Think = function()
        if input.IsKeyDown(KEY_ESCAPE) then
            bg_pnl:Remove()
        end
    end
    bg_pnl:InvalidateLayout(true)
    bg_pnl:InvalidateParent(true)

    local Main_pnl = vgui.Create("DPanel", bg_pnl)
    Main_pnl:SetSize(400 * zclib.wM, 200 * zclib.hM)
    Main_pnl:Center()
    Main_pnl.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui02"])
        draw.SimpleText(question, zclib.GetFont("zclib_font_big"), w / 2, h * 0.3, zclib.colors["text01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local close_btn = zclib.vgui.ImageButton(250 * zclib.wM,110 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,Main_pnl,zclib.Materials.Get("close"),function()
        bg_pnl:Remove()
        pcall(OnDecline)
    end,false)
    close_btn.IconColor = zclib.colors["red01"]

    local accept_btn = zclib.vgui.ImageButton(100 * zclib.wM,110 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,Main_pnl,zclib.Materials.Get("accept"),function()
        bg_pnl:Remove()
        pcall(OnAccept)
    end,false)
    accept_btn.IconColor = zclib.colors["green01"]
end

function zmc.vgui.TitledMultiText(parent,font,name,default,OnChange)
    local m = vgui.Create("DPanel", parent)
    m:SetSize(600 * zclib.wM, 330 * zclib.hM)
    m:DockMargin(50 * zclib.wM,10 * zclib.hM,50 * zclib.wM,0 * zclib.hM)
    m:Dock(TOP)
    local txtW = zclib.util.GetTextSize(name,zclib.GetFont("zclib_font_medium"))
    m.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, txtW + 15 * zclib.wM, 40 * zclib.hM, zclib.colors["ui01"])
        draw.SimpleText(name, zclib.GetFont("zclib_font_medium"), 5 * zclib.wM,2 * zclib.hM,zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    local p = vgui.Create("DTextEntry", m)
    p:Dock(FILL)
    p:DockMargin(0 * zclib.wM, 35 * zclib.hM, 0 * zclib.wM, 10 * zclib.hM)
    p:SetPaintBackground(false)
    p:SetUpdateOnType(true)
    p:SetMultiline(true)
    p:SetDrawLanguageID(false)
    p.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, w, h, zclib.colors["ui01"])

        if s:GetText() == "" and not s:IsEditing() then
            draw.SimpleText(default, font, 5 * zclib.wM, 5 * zclib.hM, zclib.colors["white_a15"], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end

        s:DrawTextEntryText(color_white, zclib.colors["textentry"], color_white)
    end

    p.main = m

    p.OnValueChange = function(s, val)
        pcall(OnChange, val)
    end

    function p:PerformLayout()
    end

    function p:PerformLayout(width, height)
        self:SetFontInternal(font)
    end

    return p
end

function zmc.vgui.TitledColormixer(parent,name,default,OnChange,OnValueChangeStop)
    local m = vgui.Create("DPanel", parent)
    m:SetSize(600 * zclib.wM, 125 * zclib.hM)
    m:DockMargin(50 * zclib.wM,10 * zclib.hM,50 * zclib.wM,0 * zclib.hM)
    m:DockPadding(0 * zclib.wM,0 * zclib.hM,0 * zclib.wM,10 * zclib.hM)
    m:Dock(TOP)
    m.font =  zclib.GetFont("zclib_font_medium")
    m.Paint = function(s, w, h)
        draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
        draw.SimpleText(name, s.font, 10 * zclib.wM,20 * zclib.hM,zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    // TODO Its stupid but InvalidateParent doesent want to work
    timer.Simple(0,function()
        if not IsValid(m) then return end
        local txtW = zclib.util.GetTextSize(name,zclib.GetFont("zclib_font_medium"))
        if txtW > m:GetWide() then
            m.font = zclib.GetFont("zclib_font_mediumsmall")
        end
    end)


    local colmix = vgui.Create("DColorMixer", m)
    colmix:SetSize(240 * zclib.wM, 100 * zclib.hM)
    colmix:DockMargin(10 * zclib.wM,40 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
    colmix:Dock(FILL)
    colmix:SetPalette(false)
    colmix:SetAlphaBar(false)
    colmix:SetWangs(true)
    colmix:SetColor(default or color_white)
    colmix.ValueChanged = function(s,col)
        pcall(OnChange,col)

        zclib.Timer.Remove("zmc_colormixer_delay")
        zclib.Timer.Create("zmc_colormixer_delay",0.1,1,function()
            pcall(OnValueChangeStop,col)
        end)
    end
    m.colmix = colmix


    return m
end

function zmc.vgui.List(parent)
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

function zmc.vgui.Slot(ItemData,IsSelected,CanSelect,OnSelect,PreDraw,PostDraw)

    local _,g_canselect = xpcall( CanSelect, function() end, ItemData )

    local mdata = {
        model = "models/props_junk/PopCan01a.mdl",
    }

    if ItemData then
        if ItemData.mdl then mdata.model = ItemData.mdl end
        if ItemData.bodygroup then mdata.bodygroup = ItemData.bodygroup end
        if ItemData.render then mdata.render = ItemData.render end
    end

    local mdl_pnl = zclib.vgui.ModelPanel(mdata)
    mdl_pnl:SetSize(200 * zclib.wM, 200 * zclib.hM)

    mdl_pnl.PreDrawModel = function(s,ent)
        local w,h = s:GetWide(), s:GetTall()
        cam.Start2D()
            draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a100"])

            local _,isselect = xpcall( IsSelected, function() end, s.dat )
            if isselect then draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui_highlight"]) end

            if PreDraw then pcall(PreDraw,w,h,s,s.dat) end

            if s.dat then
                surface.SetDrawColor(zclib.colors["black_a100"])
                surface.SetMaterial(zclib.Materials.Get("radial_shadow"))
                surface.DrawTexturedRect(0, 0,w, h)
            end
        cam.End2D()
    end

    mdl_pnl.font_name = zclib.GetFont("zclib_font_tiny")
    mdl_pnl.PostDrawModel = function(s,ent)
        local w,h = s:GetWide(), s:GetTall()
        cam.Start2D()

            if s.dat and s.dat.name then
                draw.RoundedBox(5, 0, h * 0.8, w, h * 0.2, zclib.colors["black_a100"])
                local txtW = zclib.util.GetTextSize(s.dat.name, s.font_name)
                if txtW > w * 0.9 then
                    if s.font_name == zclib.GetFont("zclib_font_mediumsmall") then
                        s.font_name = zclib.GetFont("zclib_font_small")
                    elseif s.font_name == zclib.GetFont("zclib_font_small") then
                        s.font_name = zclib.GetFont("zclib_font_tiny")
                    elseif s.font_name == zclib.GetFont("zclib_font_tiny") then
                        s.font_name = zclib.GetFont("zclib_font_nano")
                    end
                end
                draw.SimpleText(s.dat.name, s.font_name, w / 2, h * 0.9,color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            if PostDraw then pcall(PostDraw,w,h,s,s.dat) end

            if g_canselect == true and s:IsHovered() then draw.RoundedBox(5, 0, 0, w, h, zclib.colors["white_a5"]) end
        cam.End2D()
    end

    mdl_pnl.DoClick = function()
        local _,m_canselect = xpcall( CanSelect, function() end, ItemData )

        if m_canselect == false then return end
        zclib.vgui.PlaySound("UI/buttonclick.wav")
    	pcall(OnSelect,ItemData)
    end

    mdl_pnl.UpdateModel = function(s,dat)
        s.dat = dat

        if dat then
            zmc.Item.UpdateVisual(s.Entity,dat)
            if dat.color then s:SetColor(dat.color) end
            s.Entity:SetPos(vector_origin)
            s:UpdateView()
            s:SetTooltip(dat.name)
        else
            // TODO Find some better way to prevent the rendering of the model
            s.Entity:SetPos(Vector(0,0,1000))
            s:SetTooltip(false)
        end
    end

    mdl_pnl.UpdateView = function(s)
        local min, max = mdl_pnl.Entity:GetRenderBounds()
        local size = 0
        size = math.max(size, math.abs(min.x) + math.abs(max.x))
        size = math.max(size, math.abs(min.y) + math.abs(max.y))
        size = math.max(size, math.abs(min.z) + math.abs(max.z))
        mdl_pnl:SetFOV(35)
        mdl_pnl:SetCamPos(Vector(size, size + 30, size + 5))
        mdl_pnl:SetLookAt((min + max) * 0.5)
    end

    mdl_pnl:UpdateModel(ItemData)

    return mdl_pnl
end

function zmc.vgui.SimpleButton(_x,_y,_w,_h,parent,image,OnClick,IsLocked)
    local Button = vgui.Create("DButton", parent)
    Button:SetPos(_x , _y )
    Button:SetSize(_w, _h)
    Button:SetText("")
    Button.IconColor = zclib.colors["text01"]
    Button.Sound = "UI/buttonclick.wav"
    Button.Paint = function(s, w, h)

        local _, varg = xpcall(IsLocked, function() end, nil)
        if varg or s:IsEnabled() == false then

            zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2, zclib.colors["black_a50"])

            surface.SetDrawColor(zclib.colors["black_a50"])
            surface.SetMaterial(image)
            surface.DrawTexturedRect(0, 0,w, h)
        else
            if s:IsHovered() then
                zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2, zclib.colors["text01"])

                surface.SetDrawColor(s.IconColor)
                surface.SetMaterial(image)
                surface.DrawTexturedRect(0, 0,w, h)
            else
                zclib.util.DrawOutlinedBox(0 * zclib.wM, 0 * zclib.hM, w, h, 2, zclib.colors["ui02"])

                surface.SetDrawColor(zclib.colors["ui02"])
                surface.SetMaterial(image)
                surface.DrawTexturedRect(0, 0,w, h)
            end
        end
    end
    Button.DoClick = function(s)

        local _, varg = xpcall(IsLocked, function() end, nil)
        if varg == true then return end

        zclib.vgui.PlaySound(s.Sound)

        s:SetEnabled(false)

        timer.Simple(0.25, function() if IsValid(s) then s:SetEnabled(true) end end)

        pcall(OnClick,s)
    end
    return Button
end

function zmc.vgui.SimpleSlider(parent,start_val,onChange,height,OnValueChangeStop,PreDraw)
    local p = vgui.Create("DButton", parent)
    p.locked = false
    p.slideValue = start_val
    p:SetAutoDelete(true)
    p:SetText("")
    p.Paint = function(s, w, h)
        //draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])
        if PreDraw then pcall(PreDraw) end

        local AreaW = w * 0.9
        local AreaX = w * 0.05
        draw.RoundedBox(4, AreaX, h * 0.5, AreaW, 2 * zclib.hM, color_black)

        local boxHeight = h * 0.5
        local boxPosX = AreaW * s.slideValue
        draw.RoundedBox(4, (AreaX - (boxHeight / 2)) + boxPosX, boxHeight / 2, boxHeight, boxHeight, zclib.colors["text01"])

        if p.locked == true then
            draw.RoundedBox(4, 0, 0, w, h, zclib.colors["black_a100"])
        end

        if s:IsDown() then
            s.StartedDrag = true
            local x,_ = s:CursorPos()
            local min = AreaX
            local max = min + AreaW

            x = math.Clamp(x, min, max)

            local val = (1 / AreaW) * (x - min)

            s.slideValue = math.Round(val,2)

            if s.slideValue ~= s.LastValue then
                s.LastValue = s.slideValue

                if s.locked == true then return end
                pcall(onChange,s.slideValue,s)
            end
        else
            if s.StartedDrag == true then
                s.StartedDrag = nil
                pcall(OnValueChangeStop,s.slideValue,s)
            end
        end
    end
    p:SetSize(200 * zclib.wM,(height or 50) * zclib.hM )
    p:DockMargin(50 * zclib.wM,10 * zclib.hM,50 * zclib.wM,0 * zclib.hM)
    p:Dock(TOP)
    return p
end

// Creates a Dish model panel
function zmc.vgui.Dish(parent,DishData,PostDraw,IsSelected)
    local mdl_pnl = zclib.vgui.ModelPanel({model = DishData.mdl or "models/zerochain/props_kitchen/zmc_plate01.mdl"})
    mdl_pnl:SetParent(parent)
    mdl_pnl:SetSize(200 * zclib.wM, 200 * zclib.hM)
    mdl_pnl:Dock(FILL)
    mdl_pnl:DockMargin(10 * zclib.wM,10 * zclib.hM,50 * zclib.wM,0 * zclib.hM)
    mdl_pnl:SetCamPos(Vector(0,50,50))
    mdl_pnl:SetLookAt(vector_origin)
    mdl_pnl.Entity:SetAngles(angle_zero)

    mdl_pnl.font_name = zclib.GetFont("zclib_font_tiny")

    mdl_pnl:SetTooltip(DishData.name)

    mdl_pnl.PreDrawModel = function(s,ent)
        local w,h = s:GetWide(), s:GetTall()
        cam.Start2D()
            draw.RoundedBox(5, 0, 0, w, h, zclib.colors["black_a100"])

            if IsSelected then
                local _,isselect = xpcall( IsSelected, function() end, DishData )
                if isselect then draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui_highlight"]) end
            end

            surface.SetDrawColor(zclib.colors["black_a200"])
            surface.SetMaterial(zclib.Materials.Get("radial_shadow"))
            surface.DrawTexturedRect(0, 0,w, h)
        cam.End2D()
    end

    mdl_pnl.PostDrawModel = function(s,ent)
        // Draw the food items
        s:DrawFoodItems()
        if PostDraw then pcall(PostDraw,s,ent,DishData) end
    end

    mdl_pnl.DrawFoodItems = function()
        zmc.Dish.DrawFoodItems(mdl_pnl.Entity,DishData,mdl_pnl.HighlightID,nil)
    end

    mdl_pnl.OnRemove = function()
        zmc.Dish.RemoveClientModels(mdl_pnl.Entity)
    end
    return mdl_pnl
end

// Creates a page with a Item selection and
function zmc.vgui.ItemSelection(title,OnSelect,IsSelected,OnBack,ExceptionList,DataCheck,OnFinished)
    zmc.vgui.Page(title,function(main,top)

        top.Title_font = zclib.util.FontSwitch(title,400 * zclib.wM,zclib.GetFont("zclib_font_big"),zclib.GetFont("zclib_font_medium"))


        local close_btn = zclib.vgui.ImageButton(540 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("back"),function()
            pcall(OnBack)
        end,false)
        close_btn:Dock(RIGHT)
        close_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        close_btn.IconColor = zclib.colors["red01"]


        // Do we have a finish button?
        if OnFinished then
            local finish_btn = zclib.vgui.ImageButton(300 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("accept"),function()
                pcall(OnFinished)
            end,false)
            finish_btn:Dock(RIGHT)
            finish_btn:DockMargin(0 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
            finish_btn.IconColor = zclib.colors["green01"]
        end

        local function RebuildList(search_input)
            if not IsValid(main) then return end
            if IsValid(main.ItemList) then main.ItemList:Remove() end

            local list,scroll = zmc.vgui.List(main)
            scroll:DockMargin(50 * zclib.wM,10 * zclib.hM,50 * zclib.wM,10 * zclib.hM)
            scroll.Paint = function(s, w, h) draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"]) end
            main.ItemList = scroll

            for id, data in pairs(zmc.config.Items) do
                // Skips any items from the list
                if ExceptionList[id] then continue end

                // Skips any items which doesent pass the check
                if DataCheck then
                    local _,result = xpcall(DataCheck,function() end,id,data)
                    if result == true then continue end
                end

                // Skip any item which is not searched for
                if search_input ~= nil and search_input ~= "" and search_input ~= " " and string.find( data.name:lower(), search_input ) == nil then continue end

                local item_pnl = zmc.vgui.Slot(data,function(ItemData)
                    local _,isselect = xpcall( IsSelected, function() end, ItemData )

                    //IsSelected
                    return isselect
                end,function()

                    // CanSelect
                    return true
                end,function()

                    // OnSelect
                    pcall(OnSelect,data.uniqueid)
                end,function()

                    // PreDraw
                end,function(w,h)

                    // PostDraw
                end)
                list:Add(item_pnl)
                item_pnl:SetSize(135 * zclib.wM, 135 * zclib.hM)
                item_pnl.font_name = zclib.GetFont("zclib_font_small")
            end
        end

        zmc.vgui.SearchBox(top,function(val)
            RebuildList(val)
        end)

        RebuildList()
    end)
end

// Creates a Dish model panel
local CustomerTable_ViewSwitch = 1
local ViewPositions = {
    [1] = Vector(100,0,80),
    [2] = Vector(0,0,150),
    [3] = Vector(150,0,10),
}
function zmc.vgui.CustomerTable(parent,TableData,SeatData)
    local mdl_pnl = zclib.vgui.ModelPanel({model = TableData.mdl or "models/squad/sf_plates/sf_plate1x1.mdl"})
    mdl_pnl:SetParent(parent)
    mdl_pnl:SetSize(200 * zclib.wM, 200 * zclib.hM)
    mdl_pnl:Dock(FILL)
    mdl_pnl:SetLookAt(Vector(0,0,5))
    mdl_pnl:SetFOV(75)
    mdl_pnl.Entity:SetAngles(angle_zero)
    mdl_pnl.DoClick = function()
        CustomerTable_ViewSwitch = CustomerTable_ViewSwitch + 1
        if CustomerTable_ViewSwitch > #ViewPositions then CustomerTable_ViewSwitch = 1 end

        mdl_pnl:SetCamPos(ViewPositions[CustomerTable_ViewSwitch])
    end
    mdl_pnl:SetCamPos(ViewPositions[CustomerTable_ViewSwitch])

    mdl_pnl.ClientModelCache = {}

    mdl_pnl.PreDrawModel = function(s,ent)
        local w,h = s:GetWide(), s:GetTall()
        cam.Start2D()
            draw.RoundedBox(5, 0, 0, w,h, zclib.colors["ui01"])
        cam.End2D()
    end

    mdl_pnl.PostDrawModel = function(s,ent)
        s:DrawClientModels()
    end

    mdl_pnl.BuildClientModels = function(s,tData,sData)
        for k,v in pairs(mdl_pnl.ClientModelCache) do
            if v then
                if v.seat and IsValid(v.seat.ent) then
                    zclib.ClientModel.Remove(v.seat.ent)
                    v.seat.ent = nil
                end
                if v.plate and IsValid(v.plate.ent) then
                    zclib.ClientModel.Remove(v.plate.ent)
                    v.plate.ent = nil
                end
            end
        end
        mdl_pnl.ClientModelCache = {}

        if not IsValid(mdl_pnl.Entity) then return end
        if tData == nil then return end
        for k,v in pairs(tData.positions) do
            if v == nil then continue end

            mdl_pnl.ClientModelCache[k] = {}

            mdl_pnl.ClientModelCache[k].PositionData = v

            if sData then
                local seat_mdl = zclib.ClientModel.Add(sData.mdl, RENDERGROUP_BOTH)
                if IsValid(seat_mdl) then
                    mdl_pnl.ClientModelCache[k].seat =  {ent = seat_mdl,mdlpath = sData.mdl,offset = sData.offset,ang_offset = sData.ang_offset}
                end
            end

            local plate_mdl = zclib.ClientModel.Add("models/zerochain/props_kitchen/zmc_plate01.mdl", RENDERGROUP_BOTH)
            if IsValid(plate_mdl) then
                mdl_pnl.ClientModelCache[k].plate =  {ent = plate_mdl,mdlpath = "models/zerochain/props_kitchen/zmc_plate01.mdl"}
            end
        end
    end
    mdl_pnl:BuildClientModels(TableData,SeatData)

    mdl_pnl.DrawClientModels = function()
        if not IsValid(mdl_pnl.Entity) then return end

        if mdl_pnl.ClientModelCache == nil then return end
        if table.Count(mdl_pnl.ClientModelCache) <= 0 then return end
        for k, v in pairs(mdl_pnl.ClientModelCache) do
            if v == nil then continue end
            local itmData = v.PositionData

            if v.seat and itmData.seat and itmData.seat.pos and itmData.seat.ang and IsValid(v.seat.ent) and v.seat.ent.DrawModel then

                local pos = mdl_pnl.Entity:LocalToWorld(itmData.seat.pos)
                pos = pos + v.seat.ent:GetRight() * v.seat.offset.x
                pos = pos + v.seat.ent:GetForward() * v.seat.offset.y
                pos = pos + v.seat.ent:GetUp() * v.seat.offset.z

                local ang = itmData.seat.ang
                if v.seat.ang_offset then
                    ang = ang + v.seat.ang_offset
                end

                render.Model({
                    model = v.seat.mdlpath,
                    pos = pos,
                    angle = mdl_pnl.Entity:LocalToWorldAngles(ang)
                }, v.seat.ent)
            end

            if v.plate and itmData.plate and itmData.plate.pos and itmData.plate.ang and IsValid(v.plate.ent) and v.plate.ent.DrawModel then
                render.Model({
                    model = v.plate.mdlpath,
                    pos = mdl_pnl.Entity:LocalToWorld(itmData.plate.pos),
                    angle = mdl_pnl.Entity:LocalToWorldAngles(itmData.plate.ang)
                }, v.plate.ent)
            end
        end
    end

    mdl_pnl.OnRemove = function()
        for k,v in pairs(mdl_pnl.ClientModelCache) do
            if v then
                if v.seat and IsValid(v.seat.ent) then
                    zclib.ClientModel.Remove(v.seat.ent)
                    v.seat.ent = nil
                end
                if v.plate and IsValid(v.plate.ent) then
                    zclib.ClientModel.Remove(v.plate.ent)
                    v.plate.ent = nil
                end
            end
        end
    end
    return mdl_pnl
end

// Lets the player choose a position on a 2d plane
function zmc.vgui.PositionSelection(parent)
    local pox_pnl = vgui.Create("DButton", parent)
    pox_pnl:Dock(RIGHT)
    pox_pnl:SetText("")
    pox_pnl:SetSize(300 * zclib.wM, 300 * zclib.hM)
    pox_pnl:DockMargin(0 * zclib.wM,10 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
    pox_pnl.GetPosition = function(s) return Vector(0.5,0.5,0) end
    pox_pnl.OnChanged = function(s,newpos) end
    pox_pnl.Paint = function(s, w, h)
        draw.RoundedBox(5,0, 0, w, h, zclib.colors["ui01"])

        draw.SimpleText(zmc.language["Position"], zclib.GetFont("zclib_font_medium"), 10 * zclib.wM,20 * zclib.hM,zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        local x,y = s:CursorPos()
        //draw.SimpleText(math.Clamp(x,0,w), zclib.GetFont("zclib_font_small"),w / 2,h - 10 * zclib.hM, zclib.colors["text01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        //draw.SimpleText(math.Clamp(y,0,h), zclib.GetFont("zclib_font_small"),10 * zclib.wM,h / 2, zclib.colors["text01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        if s.PreDraw then s.PreDraw(s,w,h) end

        local pos =  s:GetPosition()
        if pos == nil then pos = Vector(0.5,0.5,0) end

        //draw.RoundedBox(5, math.Clamp(-w * pos.x, 0, w - 10 * zclib.wM), math.Clamp(h * pos.y, 0, h - 10 * zclib.hM), 10 * zclib.wM, 10 * zclib.hM, zclib.colors["blue01"])
        draw.RoundedBox(5, math.Clamp(w * pos.x, 5 * zclib.wM, w - 5 * zclib.wM) - 5 * zclib.wM, math.Clamp(h * pos.y, 5 * zclib.hM, h - 5 * zclib.hM) - 5 * zclib.hM, 10 * zclib.wM, 10 * zclib.hM, zclib.colors["blue01"])

        if s.PostDraw then s.PostDraw(s,w,h) end

        if s:IsDown() then
            local newpos
            if input.IsMouseDown( MOUSE_MIDDLE ) then
                // Center the position
                newpos = Vector(0.5, 0.5, pos.z)
            else
                // Go to CursorPos
                //local x,y = s:CursorPos()
                local newX,newY
                newX = math.Clamp((1 / w) * x, 0, 1)
                newY = math.Clamp((1 / h) * y, 0, 1)
                newpos = Vector(newX, newY, pos.z)
            end
            s:OnChanged(newpos)
        end
    end
    return pox_pnl
end

// Creates a page with a Dish selection and
function zmc.vgui.DishSelection(title,OnSelect,IsSelected,OnBack,ExceptionList,DataCheck,OnFinished)
    zmc.vgui.Page(title,function(main,top)

        local close_btn = zclib.vgui.ImageButton(540 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("back"),function()
            pcall(OnBack)
        end,false)
        close_btn:Dock(RIGHT)
        close_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        close_btn.IconColor = zclib.colors["red01"]

        // Do we have a finish button?
        if OnFinished then
            local finish_btn = zclib.vgui.ImageButton(300 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("accept"),function()
                pcall(OnFinished)
            end,false)
            finish_btn:Dock(RIGHT)
            finish_btn:DockMargin(0 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
            finish_btn.IconColor = zclib.colors["green01"]
        end

        local function RebuildList(search_input)
            if not IsValid(main) then return end
            if IsValid(main.ItemList) then main.ItemList:Remove() end

            local list,scroll = zmc.vgui.List(main)
            scroll:DockMargin(50 * zclib.wM,5 * zclib.hM,50 * zclib.wM,10 * zclib.hM)
            scroll.Paint = function(s, w, h) draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"]) end
            main.ItemList = scroll

            for id, data in pairs(zmc.config.Dishs) do
                // Skips any items from the list
                if ExceptionList[id] then continue end

                // Skips any items which doesent pass the check
                if DataCheck then
                    local _,result = xpcall(DataCheck,function() end,id,data)
                    if result == true then continue end
                end

                // Skip any item which is not searched for
                if search_input ~= nil and search_input ~= "" and search_input ~= " " and string.find( data.name:lower(), search_input ) == nil then continue end

                local dish_pnl = zmc.vgui.Dish(main,data,function(s,ent,DishData)
                    if DishData and DishData.name then

                        local w,h = s:GetWide(), s:GetTall()
                        cam.Start2D()
                            draw.RoundedBox(5, 0, h * 0.8, w, h * 0.2, zclib.colors["black_a100"])
                            draw.SimpleText(DishData.name, zclib.GetFont("zclib_font_small"), w / 2,h * 0.9,zclib.colors["text01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        cam.End2D()
                    end
                end,function(DishData)
                    local _,isselect = xpcall( IsSelected, function() end, DishData )

                    //IsSelected
                    return isselect
                end)
                dish_pnl:Dock(NODOCK)
                dish_pnl:SetSize(165 * zclib.wM, 165 * zclib.hM)
                dish_pnl.DoClick = function()
                    zclib.vgui.PlaySound("UI/buttonclick.wav")
                    pcall(OnSelect,data.uniqueid)
                end
                list:Add(dish_pnl)
            end
        end

        zmc.vgui.SearchBox(top,function(val)
            RebuildList(val)
        end)

        RebuildList()
    end)
end

function zmc.vgui.BodygroupEditor(data,OnBack)
    zmc.vgui.Page(zmc.language["Bodygroup Editor"],function(main,top)

        if data.bgs == nil then data.bgs = {} end

        local close_btn = zclib.vgui.ImageButton(540 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("back"),function()
            pcall(OnBack)
        end,false)
        close_btn:Dock(RIGHT)
        close_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        close_btn.IconColor = zclib.colors["orange01"]


        local bg_list = vgui.Create("DPanel", main)
        bg_list:Dock(LEFT)
        bg_list:SetSize(350 * zclib.wM, 230 * zclib.hM)
        bg_list:DockPadding(0 * zclib.wM,30 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        bg_list:DockMargin(50 * zclib.wM,10 * zclib.hM,0 * zclib.wM,10 * zclib.hM)
        bg_list.Paint = function(s, w, h)
            draw.RoundedBox(5,0, 0, w, h, zclib.colors["ui01"])
            draw.RoundedBox(5, 10 * zclib.wM, 40 * zclib.hM, w - 40 * zclib.wM, h - 50 * zclib.hM, zclib.colors["ui02"])
            draw.SimpleText(zmc.language["Bodygroups"], zclib.GetFont("zclib_font_medium"), 10 * zclib.wM,20 * zclib.hM,zclib.colors["orange01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        local list = zmc.vgui.List(bg_list)
        list:DockMargin(10 * zclib.wM,20 * zclib.hM,0 * zclib.wM,0 * zclib.hM)


        local item_pnl = zmc.vgui.Slot(data,function()

            //IsSelected
            return false
        end,function()

            // CanSelect
            return false
        end,function()

            // OnSelect
        end,function()

            // PreDraw
        end,function(w,h)

            // PostDraw
        end)
        item_pnl:SetParent(main)
        item_pnl:Dock(FILL)
        item_pnl:DockMargin(10 * zclib.wM,10 * zclib.hM,50 * zclib.wM,10 * zclib.hM)

        item_pnl.PostDrawModel = function(s,ent) end

        item_pnl.SpinVal_X = 270
        item_pnl.LayoutEntity = function(s,ent)
            s:RunAnimation()

            if s:IsDown() then
                if input.IsMouseDown( MOUSE_MIDDLE ) == true then
                    s.SpinVal_X = 270
                else
                    if s.LastPos_X == nil or s.LastPos_Y == nil then
                        local curX, curY = s:CursorPos()
                        s.LastPos_X = curX
                        s.LastPos_Y = curY
                    end

                    local curPosX,curPosY = s:CursorPos()
                    local diff_x = s.LastPos_X - curPosX
                    local diff_y = s.LastPos_Y - curPosY

                    s.SpinVal_X = s.SpinVal_X + diff_x
                    if s.SpinVal_X < 0 then
                        s.SpinVal_X = 360
                    elseif s.SpinVal_X > 360 then
                        s.SpinVal_X = 0
                    end

                    if diff_y ~= 0 then
                        local newFov = (item_pnl.Zoom or 0.5)
                        if diff_y > 0 then
                            newFov = newFov - 0.005
                        else
                            newFov = newFov + 0.005
                        end
                        newFov = math.Clamp(newFov,0,1)
                        item_pnl.Zoom = newFov
                    end

                    s.LastPos_X = curPosX
                    s.LastPos_Y = curPosY
                end
            else
                s.LastPos_X = nil
                s.LastPos_Y = nil
            end

            local radius = item_pnl.DistPos or 350
            local a = math.rad( (s.SpinVal_X / 360)  * -360 )
            local x = math.sin(a) * radius
            local y = math.cos(a) * radius
            s:SetCamPos(Vector(x,y,(item_pnl.HeightPos or 15) + 50))
            s:SetLookAt(Vector(0,0,item_pnl.HeightPos))
        end


        item_pnl.LerpedZoom = 0.5
        item_pnl.Zoom = 0.5

        local min, max = item_pnl.Entity:GetRenderBounds()
        local ZoomTarget = (min + max) * 0.5
        item_pnl.OnZoomChange = function(s,val)
            s.val = val

            local ypos = Lerp(s.val,ZoomTarget.z,50)
            item_pnl.HeightPos = ypos

            local cpos = Lerp(s.val,50,300)
            item_pnl.DistPos = cpos
        end
        item_pnl:OnZoomChange(item_pnl.Zoom)
        item_pnl.OnMouseWheeled = function(s, scrollDelta )
            local newFov = (item_pnl.Zoom or 0.5) - (0.05 * scrollDelta)
            newFov = math.Clamp(newFov,0,1)
            item_pnl.Zoom = newFov
        end
        item_pnl.Think = function(s)
            if item_pnl.LerpedZoom ~= item_pnl.Zoom then
                item_pnl.LerpedZoom = Lerp(5 * FrameTime(),item_pnl.LerpedZoom,item_pnl.Zoom or 0.5)
                item_pnl:OnZoomChange(item_pnl.LerpedZoom)
            end
        end

        if data.bgs then
            for id, val in pairs(data.bgs) do
                item_pnl.Entity:SetBodygroup(id, val)
            end
        end

        for k,bg_data in pairs(item_pnl.Entity:GetBodyGroups()) do

            local bgval_list = vgui.Create("DPanel", main)
            bgval_list:SetWide(290 * zclib.wM)
            bgval_list:SetTall(260 * zclib.hM)
            bgval_list:DockPadding(0 * zclib.wM,40 * zclib.hM,0 * zclib.wM,10 * zclib.hM)
            bgval_list.Paint = function(s, w, h)
                draw.RoundedBox(5,0, 0, w, h, zclib.colors["black_a100"])
                draw.SimpleText(bg_data.name, zclib.GetFont("zclib_font_medium"), 10 * zclib.wM,20 * zclib.hM,zclib.colors["blue01"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
            list:Add(bgval_list)

            for bg_val,bg_mesh in pairs(bg_data.submodels) do
                local btn = zclib.vgui.TextButton(0,0,250,40,bgval_list,{Text01 = bg_val,txt_font = zclib.GetFont("zclib_font_small")},function()
                    data.bgs[bg_data.id] = bg_val
                    item_pnl.Entity:SetBodygroup(bg_data.id,bg_val)
                end,function()
                    return false
                end,function()
                    return data.bgs[bg_data.id] == bg_val
                end)
                btn.color = zclib.colors["ui02"]
                btn.txt_color = zclib.colors["text01"]
                btn:Dock(TOP)
                btn:DockMargin(10 * zclib.wM,0 * zclib.hM,10 * zclib.wM,10 * zclib.hM)
            end

            bgval_list:InvalidateLayout(true)
            bgval_list:SizeToChildren( false,true)
        end
    end)
end

function zmc.vgui.WhitelistEditor(Desc,Whitelist,OnBack,OnSave,OnAdd,OnClear,OnSetup)
    zmc.vgui.Page(zmc.language["Whitelist Editor"],function(main,top)

        local back_btn = zclib.vgui.ImageButton(940 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("back"),function()
            pcall(OnBack)
        end,false)
        back_btn:Dock(RIGHT)
        back_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        back_btn.IconColor = zclib.colors["red01"]

        local seperator = zmc.vgui.AddSeperator(top)
        seperator:SetSize(5 * zclib.wM, 50 * zclib.hM)
        seperator:Dock(RIGHT)
        seperator:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)

        // Save Button
        local save_btn = zclib.vgui.ImageButton(480 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("save"),function()
            pcall(OnSave)
        end,false)
        save_btn:Dock(RIGHT)
        save_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        save_btn.IconColor = zclib.colors["green01"]


        // Add
        local add_btn = zclib.vgui.ImageButton(300 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("plus"),function()
            pcall(OnAdd)
        end,false)
        add_btn:Dock(RIGHT)
        add_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        add_btn.IconColor = zclib.colors["green01"]

        // Clear
        local clear_btn = zclib.vgui.ImageButton(300 * zclib.wM,10 * zclib.hM,50 * zclib.wM, 50 * zclib.hM,top,zclib.Materials.Get("delete"),function()
            pcall(OnClear)
        end,false)
        clear_btn:Dock(RIGHT)
        clear_btn:DockMargin(10 * zclib.wM,0 * zclib.hM,0 * zclib.wM,0 * zclib.hM)
        clear_btn.IconColor = zclib.colors["blue01"]

        local list,scroll = zmc.vgui.List(main)
        scroll:DockMargin(50 * zclib.wM,5 * zclib.hM,50 * zclib.wM,10 * zclib.hM)
        local scroll_font = zclib.util.FontSwitch(zmc.language["Whitelist Empty"],900 * zclib.wM,zclib.GetFont("zclib_font_huge"),zclib.GetFont("zclib_font_large"))
        scroll.Paint = function(s, w, h)
            draw.RoundedBox(5, 0, 0, w, h, zclib.colors["ui01"])

            if Whitelist == nil or table.Count(Whitelist) <= 0 then
                draw.SimpleText(zmc.language["Whitelist Empty"], scroll_font, w / 2, h / 2,zclib.colors["ui02"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
        main.ItemList = scroll

        pcall(OnSetup,list)
    end,Desc)
end

function zmc.vgui.ComponentSelection(parent,default,OnSelect)
    local DComboBox = vgui.Create( "DComboBox", parent )
    DComboBox:SetSize(100 * zclib.wM, 50 * zclib.hM)
    DComboBox:Dock(RIGHT)
    DComboBox:SetValue(default)
    DComboBox:SetColor(zclib.colors["text01"] )
    DComboBox.Paint = function(s, w, h) draw.RoundedBox(4, 0, 0, w, h, zclib.colors["ui01"]) end
    DComboBox.OnSelect = function( s, index, value ,data_val)
        pcall(OnSelect,data_val)
    end
    DComboBox:AddChoice(zmc.language["All"])
    for k, v in pairs(zmc.Item.Components) do
        DComboBox:AddChoice(v.name, k)
    end
end

function zmc.vgui.SearchBox(parent,OnSearch)
    local font = zclib.util.FontSwitch(zmc.language["Search"],80 * zclib.wM,zclib.GetFont("zclib_font_medium"),zclib.GetFont("zclib_font_mediumsmall"))
    local search_pnl = zmc.vgui.TitledTextEntry(parent,45,font,zmc.language["Search"],nil , zmc.language["ItemName"],false,function(val)
        local timerid = "zmc_itemeditor_search_delay"
        zclib.Timer.Remove(timerid)
        zclib.Timer.Create(timerid,0.1,1,function()
            pcall(OnSearch,val)
            zclib.Timer.Remove(timerid)
        end)
    end)
    search_pnl:SetSize(300 * zclib.wM, 50 * zclib.hM)
    search_pnl:Dock(RIGHT)
    search_pnl:DockMargin(0 * zclib.wM,0 * zclib.hM,10 * zclib.wM,0 * zclib.hM)
end
