local PANEL = {}

function PANEL:Init()
    self:SetSize(RCD.ScrH*0.3, RCD.ScrH*0.027)
    self.RCDText = RCD.GetSentence("invalidText")
    self.RCDMax = 170
    self.RCDValue = 165
    self.RCDLerp = 0
end

function PANEL:SetMaxValue(value)
    self.RCDMax = value
end

function PANEL:SetActualValue(value)
    self.RCDValue = value
end

function PANEL:Paint(w,h)
    draw.DrawText(self.RCDText, "RCD:Font:06", 0, 0, RCD.Colors["white"], TEXT_ALIGN_LEFT)
    draw.SimpleText(self.RCDValue, "RCD:Font:07", w-(h/2), h/2, RCD.Colors["white80"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    local pourcent = math.Clamp(self.RCDValue*100/self.RCDMax/100, 0, 1)
    
    self.RCDLerp = Lerp(FrameTime()*5, self.RCDLerp, (pourcent*(w-h*1.2)))

    draw.RoundedBox(0, 0, h-RCD.ScrH*0.0055, w-h*1.2, RCD.ScrH*0.0055, RCD.Colors["white30"])
    draw.RoundedBox(0, 0, h-RCD.ScrH*0.0055, self.RCDLerp, RCD.ScrH*0.0055, RCD.Colors["purple"])
    draw.RoundedBox(0, w-h, 0, h, h, RCD.Colors["white30"])
end

function PANEL:SetText(text)
    self.RCDText = text
end

derma.DefineControl("RCD:SlideVehicle", "RCD SlideVehicle", PANEL, "DPanel")