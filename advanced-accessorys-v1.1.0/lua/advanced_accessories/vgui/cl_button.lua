local PANEL = {}

function PANEL:Init()
    self:SetText("")
    self:SetFont("AAS:Font:01")
    self:SetSize(AAS.ScrW*0.075, AAS.ScrH*0.029)
    self:SetTextColor(AAS.Colors["white"])
    self.AASTheme = true
    self.activateButton = true 
    self.lerpCircle = self:GetWide()*0.63
    self.lerpColor = self.AASTheme and AAS.Colors["yellow"] or AAS.Colors["darkBlue"]
end

function PANEL:SetTheme(bool)
    self.AASTheme = bool
end 

function PANEL:ChangeStatut(bool)
    self.activateButton = !self.activateButton
    if bool then self:ChangeFilter() end
end 

function PANEL:ChangeFilter()
    AAS.ClientTable["filters"][self.AASTheme and "vip" or "new"] = self.activateButton
end

function PANEL:GetStatut()
    return (self.activateButton or false)
end 

function PANEL:Paint(w, h)
    self.lerpCircle = Lerp(FrameTime()*10, self.lerpCircle, self.activateButton and w*0.63 or w*0.45 )

    local textColor = self.activateButton and (self.AASTheme and AAS.Colors["yellow"] or AAS.Colors["darkBlue"]) or AAS.Colors["grey"]
    draw.SimpleText(self.AASTheme and "VIP" or "NEW", "AAS:Font:04", self.AASTheme and w*0.09 or 0, h/2, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    surface.SetDrawColor(AAS.Colors["white"])
	surface.SetMaterial(AAS.Materials[self.activateButton and (self.AASTheme and "vipButton" or "newButton") or "inactive"])
	surface.DrawTexturedRect(w*0.41, 0, w*0.4, h*0.9)

    surface.SetDrawColor(AAS.Colors["white"])
	surface.SetMaterial(AAS.Materials["circle"])

    local height = AAS.Materials["circle"]:Height()*AAS.ScrH/1080
	surface.DrawTexturedRect(self.lerpCircle, h*0.09, AAS.Materials["circle"]:Width()*AAS.ScrW/1920, height)
end

derma.DefineControl("AAS:Button", "AAS Button", PANEL, "DButton")