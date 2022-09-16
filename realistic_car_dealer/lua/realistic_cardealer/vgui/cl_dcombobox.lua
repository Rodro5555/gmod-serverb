local PANEL = {}

function PANEL:Init()
    self:SetText("")
    self:SetSize(RCD.ScrW*0.1949, RCD.ScrH*0.05)
    self:SetFont("RCD:Font:13")
    self:SetTextColor(RCD.Colors["white100"])
    self.RCDRounded = 0
end

function PANEL:SetRounded(number)
    self.RCDRounded = (number or 0)
end

function PANEL:Paint(w,h)
    draw.RoundedBox(self.RCDRounded, 0, 0, w, h, RCD.Colors["white5"])
    self:DrawTextEntryText(RCD.Colors["white100"], RCD.Colors["white100"], RCD.Colors["white100"])
end

derma.DefineControl("RCD:DComboBox", "RCD DComboBox", PANEL, "DComboBox")