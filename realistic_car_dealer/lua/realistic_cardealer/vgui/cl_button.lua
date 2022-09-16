local PANEL = {}

function PANEL:Init()
    self:SetSize(RCD.ScrH*0.03, RCD.ScrH*0.03)
    self:SetText("")
    self.RCDBackgroundColor = RCD.Colors["white100"]
    self.RCDHoveredAlpha = 0
    self.RCDIcon = nil
    self.RCDAlignement = TEXT_ALIGN_LEFT
    self.RCDTextPos = 0
    self.RCDMinMaxLerp = {60, 0}
    self.RCDValue = RCD.GetSentence("invalidText")
end

function PANEL:SetValue(value)
    self.RCDValue = value
end

function PANEL:GetValue()
    return self.RCDValue or ""
end

function PANEL:SetBackgroundColor(color)
    self.RCDBackgroundColor = color
end

function PANEL:SetHoveredColor(color)
    self.RCDHoveredColor = color
end

function PANEL:SetIconMaterial(mat)
    self.RCDIcon = mat
end

function PANEL:SetTextAlignement(align) 
    self.RCDAlignement = align
end

function PANEL:Paint(w, h)
    self.RCDHoveredAlpha = Lerp(FrameTime()*3, self.RCDHoveredAlpha, (self:IsHovered() and self.RCDMinMaxLerp[1] or self.RCDMinMaxLerp[2]))

    surface.SetDrawColor(ColorAlpha(self.RCDBackgroundColor, self.RCDHoveredAlpha))
    surface.DrawRect(0, 0, w, h)

    if self.RCDIcon then
        self.RCDTextPos = RCD.ScrW*0.025

        RCD.DrawCircle(RCD.ScrW*0.012, h/2, h*0.4, 0, 360, RCD.Colors["white30"])
        
        surface.SetMaterial(self.RCDIcon)
        surface.SetDrawColor(RCD.Colors["white100"])
        surface.DrawTexturedRect(RCD.ScrW*0.012 - h*0.18, h/2-h*0.4/2, h*0.4, h*0.4)
    else
        self.RCDTextPos = self.RCDAlignement == TEXT_ALIGN_CENTER and w/2 or RCD.ScrW*0.005
    end

    draw.SimpleText(self.RCDValue, "RCD:Font:09", self.RCDTextPos, h/2, RCD.Colors["white"], self.RCDAlignement, TEXT_ALIGN_CENTER)
end

derma.DefineControl("RCD:Button", "RCD Button", PANEL, "DButton")