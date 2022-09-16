local PANEL = {}

function PANEL:Init()
    self:SetSize(AAS.ScrH*0.03, AAS.ScrH*0.03)
    self.AASValue = false
    self:SetText("")
    self.Lerp = 0
end

function PANEL:SetValue(bool)
    self.AASValue = bool
end

function PANEL:GetValue()
    return self.AASValue
end

function PANEL:DoClick()
    self.AASValue = !self.AASValue
end

function PANEL:Paint(w,h)
    draw.RoundedBox(2, 0, 0, w, h, AAS.Colors["white"])

    self.Lerp = Lerp(FrameTime()*10, self.Lerp, self.AASValue and 255 or 0)
    draw.RoundedBox(2, self:GetWide()*0.1, self:GetTall()*0.1, w-self:GetWide()*0.2, h-self:GetWide()*0.2, ColorAlpha(AAS.Colors["dark34"], self.Lerp))
end

derma.DefineControl("AAS:CheckBox", "AAS CheckBox", PANEL, "DButton")