local PANEL = {}

function PANEL:Init()
    self.entry = vgui.Create("DTextEntry", self)
    self.entry:Dock(FILL)
    self.entry:DockMargin(RCD.ScrW*0.0035, 0, 0, 0)
    self.entry:SetText("")
    self.entry:SetDrawLanguageID(false)
    self.entry:SetFont("RCD:Font:13")
    
    self.entry.RCDPlaceHolder = ""
    self.entry.RCDBackgroundColor = RCD.Colors["white5"]
    self.entry.RCDRounded = 0

    self.entry.Paint = function(pnl,w,h)
        pnl:DrawTextEntryText(RCD.Colors["white100"], RCD.Colors["white100"], RCD.Colors["white100"])
    end

    self.entry.OnGetFocus = function()
        if string.Trim(self.entry:GetValue()) == "" or tostring(self.entry:GetValue()) == tostring(self.entry.RCDPlaceHolder) then
            self.entry:SetValue("")
        end
    end
    
    self.entry.OnLoseFocus = function()
        if string.Trim(self.entry:GetValue()) == "" then
            self.entry:SetText(self.entry.RCDPlaceHolder)
        end
    end
end

function PANEL:BackGroundColor(color)
    self.entry.RCDBackgroundColor = color
end

function PANEL:SetPlaceHolder(text)
    self.entry.RCDPlaceHolder = text
    self.entry:SetText(self.entry.RCDPlaceHolder)
end

function PANEL:SetNumeric()
    self.entry:SetNumeric(true)
end

function PANEL:SetRounded(number)
    self.entry.RCDRounded = (number or 0)
end

function PANEL:GetText()
    return self.entry:GetText()
end

function PANEL:SetText(text)
    return self.entry:SetText(text)
end

function PANEL:Paint(w,h) 
    draw.RoundedBox(self.entry.RCDRounded, 0, 0, w, h, self.entry.RCDBackgroundColor)
end

derma.DefineControl("RCD:TextEntry", "RCD TextEntry", PANEL, "DPanel")