local PANEL = {}

function PANEL:Init()
    self:SetSize(RCD.ScrW*0.023, RCD.ScrH*0.019)
    self:SetText("")
    self.RCDLerp = 0
    self.RCDActivate = true
    self.RCDLerpColor = RCD.Colors["purple"]
    self.RCDCanChange = true
end

function PANEL:ChangeStatut(bool)
    self.RCDActivate = bool
end

function PANEL:GetStatut()
    return self.RCDActivate
end

function PANEL:CanChange(bool)
    self.RCDCanChange = bool
end

function PANEL:Paint(w,h)
    self.RCDLerp = Lerp(FrameTime()*5, self.RCDLerp, (self.RCDActivate and w*0.44 or 0))
    self.RCDLerpColor = RCD.LerpColor(FrameTime()*5, self.RCDLerpColor, (self.RCDActivate && self.RCDCanChange and RCD.Colors["purple"] or RCD.Colors["grey"]))

    RCD.DrawElipse(0, 0, w, h, self.RCDLerpColor, false, false)
    RCD.DrawCircle(w*0.28 + self.RCDLerp, h*0.5, h*0.4, 0, 360, RCD.Colors["white"])
end

function PANEL:DoClick()
    if not self.RCDCanChange then return end

    self.RCDActivate = !self.RCDActivate
    self:OnChange()
end

derma.DefineControl("RCD:Toggle", "RCD Toggle", PANEL, "DButton")