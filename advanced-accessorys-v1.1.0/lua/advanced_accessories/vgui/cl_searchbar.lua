local PANEL = {}

function PANEL:Init()
    self:SetSize(AAS.ScrW*0.175, AAS.ScrH*0.03)
    
    local dtexEntry = vgui.Create("DTextEntry", self)
    dtexEntry:SetTextColor(AAS.Colors["white"])
    dtexEntry:SetSize(AAS.ScrW*0.17, AAS.ScrH*0.03)
    dtexEntry:SetPos(AAS.ScrW*0.005, 0)
    dtexEntry:SetDrawLanguageID(false)
    dtexEntry:SetText(AAS.GetSentence("search"))
    dtexEntry:SetFont("AAS:Font:03")
    dtexEntry.AASBaseText = AAS.GetSentence("search")
    dtexEntry.Paint = function(self,w,h) 
        self:DrawTextEntryText(AAS.Colors["black18200"], AAS.Colors["black18200"], AAS.Colors["black18200"])
    end 
    dtexEntry.AllowInput = function(self, stringValue)    
        if #self:GetValue() > 20 then
            return true 
        end 
    end 
    dtexEntry.OnGetFocus = function(self)
        if self:GetValue() == self.AASBaseText then
            self:SetText("") 
        end 
    end 
    dtexEntry.OnLoseFocus = function(self)
        if self:GetValue() == "" then
            self:SetText(self.AASBaseText)
        end
    end 
    
    dtexEntry.GetAutoComplete = function(self, text)
        AAS.ClientTable["filters"]["search"] = text
        
        AAS.UpdateList(AAS.ClientTable["ItemsVisible"], istable(AAS.ClientTable["ItemSelected"]))
    end
    
    self.AASTextEntry = dtexEntry
    self.AASBaseText = self:GetValue()
end

function PANEL:Paint(w,h) 
    surface.SetDrawColor(AAS.Colors["white"])
    surface.SetMaterial(AAS.Materials["searchbar"])
    surface.DrawTexturedRect(0, 0, w, h)
end

derma.DefineControl("AAS:SearchBar", "AAS SearchBar", PANEL, "DPanel")
