local PANEL = {}

function PANEL:Init()
    self.Incline = 0
    self.RCDPoly = {}
    self.RCDColor = RCD.Colors["white"]
    self.RCDIcon = RCD.Materials["icon_car"]
    self.RCDIconColor = RCD.Colors["white"]
    self.RCDIconPosX = nil
    self.RCDValue = nil
    self.ColorLerp = 5
    self.MinMaxLerp = {0, 0}
    self:SetText("")
    self:SetSize(RCD.ScrH*0.1, RCD.ScrH*0.1)
end

function PANEL:InclineButton(number)
    self.Incline = (number or 0)
    self:ReloadPoly()
end

function PANEL:SetButtonColor(color)
    self.RCDColor = (color or RCD.Colors["white"])
end

function PANEL:SetIconColor(color)
    self.RCDIconColor = (color or RCD.Colors["white"])
end

function PANEL:SetCustomIconPos(value)
    self.RCDIconPosX = value
end

function PANEL:SetValue(value)
    self.RCDValue = value
end

function PANEL:SetIconMaterial(mat)
    self.RCDIcon = mat
end

function PANEL:ReloadPoly()
    local w, h = self:GetSize()

    self.RCDPoly = {
        {x = self.Incline, y = 0},
        {x = w, y = 0},
        {x = w-self.Incline, y = h},
        {x = 0, y = h},
    }
end

function PANEL:OnSizeChanged(newWidth, newHeight)
    self:ReloadPoly()
end

function PANEL:Paint(w,h)
    self.ColorLerp = Lerp(FrameTime()*2, self.ColorLerp, (self:IsHovered() and self.MinMaxLerp[1] or self.MinMaxLerp[2]))

	surface.SetDrawColor(ColorAlpha(self.RCDColor, self.ColorLerp))
	draw.NoTexture()
	surface.DrawPoly(self.RCDPoly)
    
    local iconSizeX, iconSizeY, iconPosX, iconPosY
    if self.RCDIcon != nil then
        iconSizeX, iconSizeY = RCD.ScrH*0.02, RCD.ScrH*0.02
        iconPosX, iconPosY = (self.RCDIconPosX != nil and self.RCDIconPosX or (w/1.9-iconSizeX/2)), (h/2-iconSizeY/2)

        surface.SetDrawColor(self.RCDIconColor)
        surface.SetMaterial(self.RCDIcon)
        surface.DrawTexturedRect(iconPosX, iconPosY, iconSizeX, iconSizeY)
    end

    if self.RCDValue != nil then
        draw.SimpleText(self.RCDValue, "RCD:Font:04", (iconPosX or 0)+(iconSizeX or 0)+w*0.055, h/2, RCD.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end

derma.DefineControl("RCD:SlideButton", "RCD SlideButton", PANEL, "DButton")