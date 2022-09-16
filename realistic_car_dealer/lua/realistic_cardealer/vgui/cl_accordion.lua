local PANEL = {}

function PANEL:Init()
    self:SetButtonTall(RCD.ScrH*0.05)
    self:SetTextFont("RCD:Font:18")
    self:SetRightTextFont("RCD:Font:18")
    self:SetArrowFont("RCD:Font:17")
    self.RCDText = RCD.GetSentence("noText")
    self.RCDDeploy = false
    self.RCDSizeY = RCD.ScrH*0.15
    self.RCDParams = {}
    self.RCDSizeYPanel = 0
    self.RCDHoveredAlpha = 0
    self.RCDHoveredAlpha2 = 0
    self.RCDCanInteract = true

    timer.Simple(0.1, function()
        if not IsValid(self) then return end
    
        self.Button = vgui.Create("DButton", self)
        self.Button:SetSize(self:GetWide(), self.RCDButtonSizeY)
        self.Button:SetText("")
        self.Button.Paint = function() end
        self.Button.DoClick = function()
            if not self.RCDCanInteract then return end

            self:Deploy(self.RCDSizeY)
        end
    end)
end

function PANEL:SetSizeY(number, notDeploy, bool)
    self.RCDBase = bool
    self.RCDSizeY = self.RCDSizeY - self.RCDSizeYPanel + number
    self.RCDSizeYPanel = number

    if not notDeploy then
        self:Deploy(self.RCDSizeY)
    end
end

function PANEL:Paint(w,h)
    self.RCDHoveredAlpha = Lerp(FrameTime()*3, self.RCDHoveredAlpha, 20)
    self.RCDHoveredAlpha2 = Lerp(FrameTime()*3, self.RCDHoveredAlpha2, 245)

    draw.RoundedBox(0, 0, 0, w, self.RCDButtonSizeY, ColorAlpha(RCD.Colors["white20"], self.RCDHoveredAlpha))
    draw.RoundedBox(0, 0, self.RCDButtonSizeY, w, h, RCD.Colors["white2"])
    
    if IsValid(self.Button) then
        local white = ColorAlpha(RCD.Colors["white"], self.RCDHoveredAlpha2)
        draw.DrawText(RCD.GetSentence(self.RCDText), self.RCDTextFont, RCD.ScrW*0.007, (self.RCDButtonSizeY - self.RCDTextFontSizeY)/2, white, TEXT_ALIGN_LEFT)
    
        draw.DrawText("▼", self.RCDArrowFont, w-RCD.ScrW*0.016, (self.RCDButtonSizeY - self.SetArrowFontSizeY)/2, RCD.Colors["grey30"], TEXT_ALIGN_LEFT)
    
        if isstring(self.RCDRightText) then
            draw.DrawText(self.RCDRightText, self.RCDRightTextFont, w-RCD.ScrW*0.017-self.RCDRightTextSizeX, (self.RCDButtonSizeY - self.SetRightTextFontSizeY)/2, white, TEXT_ALIGN_LEFT)
        end
    end
end

function PANEL:SetText(text)
    self.RCDText = text
end

function PANEL:SetInteract(bool)
    self.RCDCanInteract = bool
end

function PANEL:SetRightText(text)
    surface.SetFont("RCD:Font:17")
    self.RCDRightText, self.RCDRightTextSizeX, self.RCDRightTextSizeY = text, surface.GetTextSize(text)
end

function PANEL:SetTextFont(fontName)
    self.RCDTextFont = fontName

    surface.SetFont(fontName)
    self.RCDTextFontSizeY = select(2, surface.GetTextSize("AAA"))
end

function PANEL:SetRightTextFont(fontName)
    self.RCDRightTextFont = fontName

    surface.SetFont(fontName)
    self.SetRightTextFontSizeY = select(2, surface.GetTextSize("AAA"))
end

function PANEL:SetArrowFont(fontName)
    self.RCDArrowFont = fontName

    surface.SetFont(fontName)
    self.SetArrowFontSizeY = select(2, surface.GetTextSize("▼"))
end

function PANEL:SetButtonTall(y)

    if IsValid(self.Button) then
        self.Button:SetTall(y)
    end
    self.RCDButtonSizeY = y
end

function PANEL:InitializeCategory(name, panelLink, letOpen, editVehicle)
    if not istable(RCD.ParametersConfig[name]) then return end

    local borderX, borderY = RCD.ScrW*0.0034, RCD.ScrH*0.005
    local sizeToSet = 0

    if istable(self.RCDParams) && #self.RCDParams != 0 then
        for k,v in ipairs(self.RCDParams) do
            if not IsValid(v) then continue end

            v:Remove()
        end
    end
    
    for line, elements in ipairs(RCD.ParametersConfig[name]) do
        local numberElements = #elements

        local sizeYUp = 0
        for k,v in ipairs(elements) do
            local sizeX = math.Round(self:GetWide()/numberElements - borderX - borderX/numberElements)
            local sizeY = self.RCDButtonSizeY+borderY*(line==1 and 1 or line)+((line-1)*self.RCDButtonSizeY)

            local posX = math.Round(sizeX*(k-1) + (borderX*k))

            local dPanel = vgui.Create("DPanel", self)
            dPanel:SetPos(posX-RCD.ScrW*0.00001, sizeY)
            dPanel.Paint = function(_,w,h)
                dPanel:SetSize(sizeX, v.sizeYPanel and RCD.ScrH*v.sizeYPanel + self.RCDSizeYPanel or self.RCDButtonSizeY)
            
                local text = RCD.GetSentence(v.text)
                if text != "Lang Problem" then
                    draw.DrawText(text, "RCD:Font:13", RCD.ScrW*0.01, h*0.25, RCD.Colors["white100"], TEXT_ALIGN_LEFT)
                end

                if not v.disableBackgroundColor then
                    draw.RoundedBox(4,0,0,w,h,RCD.Colors["white2"])
                end
            end

            local params = vgui.Create(v.class, dPanel)
            params:SetSize(RCD.ScrW*v.sizeX, RCD.ScrH*v.sizeY)
            params:SetPos(RCD.ScrW*v.posX, RCD.ScrH*v.posY)
            if isfunction(v.func) then
                v.func(params, panelLink, editVehicle, self)
            end

            sizeYUp = sizeYUp + (v.sizeYPanel and RCD.ScrH*v.sizeYPanel + self.RCDSizeYPanel or self.RCDSizeYPanel )

            self.RCDParams[#self.RCDParams + 1] = dPanel
        end

        sizeToSet = sizeToSet + (sizeYUp == 0 and self.RCDButtonSizeY or sizeYUp) + borderY
    end
    
    self.RCDSizeY = sizeToSet + borderY

    if not letOpen then
        self:Deploy(sizeToSet + borderY)
    end
end

function PANEL:Deploy(size, force, noAnim)
    self.RCDDeploy = (force and force or !self.RCDDeploy)
    
    self:SizeTo(-1, self.RCDButtonSizeY + (self.RCDDeploy and (self.RCDBase and self.RCDSizeYPanel or size) or 0), (noAnim and 0 or 0.5))
end

derma.DefineControl("RCD:Accordion", "RCD Accordion", PANEL)