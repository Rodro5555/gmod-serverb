local PANEL = {}

function PANEL:Init()
    self:SetText("Edit Text")
    self:SetFont("AAS:Font:03")
    self:SetSize(AAS.ScrW*0.175, AAS.ScrH*0.03)
    self:SetTextColor(AAS.Colors["white"])
    self:SetDrawLanguageID(false)

    self.Icon = nil 
end

function PANEL:SetIcon(mat)
    self.Icon = mat
end 

function PANEL:SetHoldText(text)
    self.AASBaseText = text
    self:SetText(self.AASBaseText)
end 

function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, AAS.Colors["black18"])

    self:DrawTextEntryText(AAS.Colors["white"], AAS.Colors["selectedBlue"], AAS.Colors["white"])

    if self.Icon != nil then
        local sizeY = self.Icon:Height()*AAS.ScrH/1080
        
        surface.SetDrawColor(AAS.Colors["white"])
        surface.SetMaterial(self.Icon, "smooth")
        surface.DrawTexturedRect(w*0.78, h/2 - sizeY/2, self.Icon:Width()*AAS.ScrW/1920, sizeY)
    end 
end

function PANEL:OnGetFocus()
    if self:GetValue() == self.AASBaseText then
        self:SetText("") 
    end 
end 

function PANEL:OnLoseFocus()
    if self:GetValue() == "" then
        self:SetText(self.AASBaseText)
    end
end 

derma.DefineControl("AAS:TextEntry", "AAS TextEntry", PANEL, "DTextEntry")
