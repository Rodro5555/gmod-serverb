local PANEL = {}

function PANEL:Init()
    self.VBar:SetHideButtons(true)
    self.VBar:SetWide(AAS.ScrW*0.0048)
    self:SetSize(AAS.ScrW*0.19, AAS.ScrH*0.4)

    self:DrawBars()
end

function PANEL:DrawBars()
    function self.VBar.btnUp:Paint() end
    function self.VBar.btnDown:Paint() end

    function self.VBar:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, AAS.Colors["white50"])
    end
    function self.VBar.btnGrip:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, AAS.Colors["white"])
    end
end

function PANEL:OnChildAdded(child)
    self:AddItem(child)
    child:Dock(TOP)    
end

derma.DefineControl("AAS:ScrollPanel", "AAS Scroll Panel", PANEL, "DScrollPanel")