local PANEL = {}
  
local function slider()
    local slider = vgui.Create("Panel")
    slider.BarX = 0
    slider.Material = RCD.Materials["colorsBar"]

    function slider:PrePaint(w, h)
        RCD.RoundedTextureRect(4, 0, 0, w, h, self.Material, RCD.Colors["white"])
    end

    function slider:Paint(w, h)
        self:PrePaint(w, h)
        
        RCD.MaskStencil(function()
            RCD.DrawCircle(self.BarX-h/2, h/2, h*0.3, h*0.3, 360, RCD.Colors["white"])
        end, function()
            RCD.DrawCircle(self.BarX-h/2, h/2, h*0.4, h*0.4, 360, RCD.Colors["white"])
        end, true)
    end

    function slider:OnCursorMoved(x, y)
        if not input.IsMouseDown(MOUSE_LEFT) then return end

        local color = self:GetPosColor(x, y)
        if color then
            self.Color = color
            self:OnChange(color)
        end

        self.BarX = math.Clamp(x, 0, self:GetWide()-2)
    end

    function slider:GetBarX()
        return self.BarX/self:GetWide()
    end

    function slider:SetBarX(x)
        self.BarX = math.Clamp(self:GetWide()*x, 0, self:GetWide()-2)
    end

    function slider:OnMousePressed(code)
        self:MouseCapture(true)
        self:OnCursorMoved(self:CursorPos())
    end

    function slider:OnMouseReleased(code)
        self:MouseCapture(false)
        self:OnCursorMoved(self:CursorPos())
    end

    function slider:GetPosColor(x, y)
        local w = x/self:GetWide()*self.Material:Width()
        local h = y/self:GetTall()*self.Material:Height()

        w = math.Clamp(w, 0, self.Material:Width()-1)
        h = math.Clamp(h, 0, self.Material:Height()-1)

        return self.Material:GetColor(w, h), w, h
    end

    return slider
end

function PANEL:Init()
    self:SetSize(RCD.ScrW*0.2, RCD.ScrH*0.35)

    self.colorCube = vgui.Create("DColorCube", self)
    self.colorCube:Dock(FILL)
    self.colorCube.PaintOver = nil
    self.colorCube.Knob:SetSize(10, 10)
    self.colorCube.Knob.Paint = function(panel, w, h)
        RCD.MaskStencil(function()
            RCD.DrawCircle(w/2, h/2, w/2.5, 0, 360, RCD.Colors["white"])
        end, function()
            RCD.DrawCircle(w/2, h/2, w/2, 0, 360, RCD.Colors["white"])
        end, true)
    end

    local colorCube = self.colorCube
    
    function colorCube.BGValue:Paint(w, h)
        RCD.MaskStencil(function()
            RCD.DrawRoundedRect(4, 0, 0, w, h)
        end, function()
            self:PaintAt(0, 0, w, h)
        end)
    end

    function colorCube.BGSaturation:Paint(w, h)
        RCD.MaskStencil(function()
            RCD.DrawRoundedRect(4, 0, 0, w, h)
        end, function()
            self:PaintAt(0, 0, w, h)
        end)
    end
    
    function colorCube:Paint(w, h)
        RCD.MaskStencil(function()
            RCD.DrawRoundedRect(4, 0, 0, w, h)
        end, function()
            surface.SetDrawColor(self.m_BaseRGB.r, self.m_BaseRGB.g, self.m_BaseRGB.b, 255)
            self:DrawFilledRect()
        end)
    end
    
    local barsContainer = vgui.Create("Panel", self)
    barsContainer:Dock(BOTTOM)
    barsContainer:DockMargin(0, 0, 0, -RCD.ScrH*0.004)
    barsContainer:SetZPos(1)
    barsContainer:InvalidateParent(true)
    barsContainer:SetTall(RCD.ScrH*0.026)

    local colorBar = slider()
    colorBar:SetParent(barsContainer)
    colorBar:Dock(TOP)
    colorBar:InvalidateParent(true)
    colorBar:DockMargin(0, RCD.ScrH*0.004, 0, -RCD.ScrH*0.004)
    colorBar:SetTall(barsContainer:GetTall()*0.4)

    function colorBar:OnChange(color)
        local sX, sY = colorCube:GetSlideX(), colorCube:GetSlideY()
        colorCube:SetColor(color)

        colorCube:SetSlideX(sX)
        colorCube:SetSlideY(sY)
    end

    local saturationBar = slider()
    saturationBar:SetParent(barsContainer)
    saturationBar:Dock(BOTTOM)
    saturationBar:InvalidateParent(true)
    saturationBar:SetTall(barsContainer:GetTall()*0.3)
    saturationBar.Material = RCD.Materials["gratientBar"]
    
    function colorCube:GetColorAt(x, y)
        x = x or self:GetSlideX()
        y = y or self:GetSlideY()
        return HSVToColor(ColorToHSV(self.m_BaseRGB), 1-x, 1-y)
    end

    function saturationBar:PrePaint(w, h)
        RCD.DrawRoundedRect(4, 0, 0, w, h, RCD.Colors["white"])
        RCD.RoundedTextureRect(4, 0, 0, w, h, self.Material, colorCube:GetColorAt(0))
    end
    
    function saturationBar:OnChange(color)
        colorCube:SetSlideX(1-saturationBar:GetBarX())
    end

    function colorCube:OnUserChanged(color)
        saturationBar:SetBarX(1-self:GetSlideX())
    end
    
    function colorCube:SetColorG(color)
        self:SetColor(color)
        saturationBar:SetBarX(1-self:GetSlideX())
    end
    
    local colorsContainer = vgui.Create("Panel", self)
    colorsContainer:Dock(BOTTOM)
    colorsContainer:DockMargin(0, RCD.ScrW*0.007, 0, RCD.ScrW*0.004)
    colorsContainer:SetTall(RCD.ScrH*0.1225)
    colorsContainer:InvalidateParent(true)  

    local layout = vgui.Create("DIconLayout", colorsContainer)
    layout:Dock(FILL)
    layout:InvalidateParent(true)
    layout:SetSpaceX(RCD.ScrW*0.0024)
    layout:SetSpaceY(RCD.ScrH*0.004)
    layout.Items = {}

    local cols = 10
    local rows = math.ceil(#RCD.ColorPaletteColors/cols)

    for i, v in ipairs(RCD.ColorPaletteColors) do
        local item = vgui.Create("DButton", layout)
        item:SetSize(RCD.ScrH*0.021, RCD.ScrH*0.021)
        item:SetText("")
        function item:DoClick()
            colorCube:SetColorG(v)
            colorCube.OnUserChanged(colorCube)
        end

        function item:Paint(w, h)
            RCD.DrawCircle(w/2, h/2, h*0.5, 0, 360, v)
        end
        layout.Items[#layout.Items + 1] = item
    end

    self:SetColor(RCD.Colors["white"])

    return frame
end

function PANEL:GetColor()
    return (self.colorCube:GetRGB() or RCD.Colors["white"])
end

function PANEL:SetColor(color)
    self.colorCube:SetRGB(color or RCD.Colors["white"])
    self.colorCube:SetColor(color or RCD.Colors["white"])
    self.colorCube.OnUserChanged(self.colorCube)
end

function PANEL:Paint() end

derma.DefineControl("RCD:ColorPicker", "RCD ColorPicker", PANEL, "DPanel")
