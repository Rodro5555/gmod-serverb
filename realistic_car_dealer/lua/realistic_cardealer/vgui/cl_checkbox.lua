local PANEL = {}

function PANEL:Init()
    self:SetText("")
    self:SetSize(RCD.ScrW*0.1949, RCD.ScrH*0.05)
    self.RCDLerp = 0
    self.RCDActivate = false
    self.RCDLerpColor = RCD.Colors["white0"]
end

function PANEL:Paint(w,h)
    self.RCDLerp = Lerp(FrameTime()*12, self.RCDLerp, self.RCDActivate and h/2 or 0)

    RCD.DrawCircle(w/2, h/2, h/2, 0, 360, RCD.Colors["grey84"])
    RCD.DrawCircle(w/2, h/2, self.RCDLerp, 0, 360, RCD.Colors["purple"])

    local scale = math.floor(self.RCDLerp)*1.2
    local divisedScale = math.floor(scale/2)

    self.RCDLerpColor = RCD.LerpColor(FrameTime()*12, self.RCDLerpColor, (self.RCDActivate and RCD.Colors["white200"] or RCD.Colors["white0"]))

    surface.SetDrawColor(self.RCDLerpColor)
	surface.SetMaterial(RCD.Materials["icon_check"])
	surface.DrawTexturedRect(w/2-h*0.3, h/2-h*0.3, h*0.6, h*0.6)
end

function PANEL:DoClick()
    self.RCDActivate = !self.RCDActivate

    self:OnChange(self.RCDActivate)
end

function PANEL:GetActive()
    return self.RCDActivate
end

function PANEL:SetActive(bool)
    self.RCDActivate = bool
end

derma.DefineControl("RCD:CheckBox", "RCD CheckBox", PANEL, "DButton")