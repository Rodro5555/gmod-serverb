--[[  
    Addon: Hitman
    By: SlownLS
]]

local PANEL = {}

function PANEL:Init()
end

function PANEL:load()
    self.pnlLabel = vgui.Create("DLabel", self)
        self.pnlLabel:SetPos(0,0)
        self.pnlLabel:SetFont('SlownLS:Hitman:18')
        self.pnlLabel:SetTextColor(color_white)
        self.pnlLabel:SetText('...')
        self.pnlLabel:SizeToContents()

    self.pnlPadding = vgui.Create("DPanel", self)
        self.pnlPadding:SetSize(self:GetWide(),self:GetTall() - self.pnlLabel:GetTall() - 14)
        self.pnlPadding:SetPos(0,self.pnlLabel:GetTall() + 7)
        self.pnlPadding:DockPadding(5, 5, 5, 5)
        self.pnlPadding.Paint = function(pnl, w, h)
            surface.SetDrawColor(SlownLS.Hitman:getColor('secondary'))
            surface.DrawRect(0, 0, w, h)
            
            surface.SetDrawColor(SlownLS.Hitman:getColor('outline'))
            surface.DrawOutlinedRect(0, 0, w, h)
        end

    self.pnlEntry = vgui.Create("DTextEntry", self.pnlPadding)
        self.pnlEntry:Dock(FILL)
        self.pnlEntry:SetDrawLanguageID(false)
        self.pnlEntry:SetTextColor(color_white)
        self.pnlEntry:SetCursorColor(color_white)
        self.pnlEntry:SetFont("SlownLS:Hitman:16")
        self.pnlEntry.Paint = function(pnl, w, h)
            pnl:DrawTextEntryText(pnl:GetTextColor(),  pnl:GetHighlightColor(), pnl:GetCursorColor())
        end
end
 
function PANEL:Paint(w,h)

end

function PANEL:setLabel(str)
    if( IsValid(self.pnlLabel) ) then
        self.pnlLabel:SetText(str)
        self.pnlLabel:SizeToContents()
    end
end

function PANEL:setNumeric(bool)
    if( IsValid(self.pnlEntry) ) then
        self.pnlEntry:SetNumeric(bool)
    end
end

function PANEL:setMultiline(bool)
    if( IsValid(self.pnlEntry) ) then
        self.pnlEntry:SetMultiline(bool)
    end
end

function PANEL:SetText(str)
    if( IsValid(self.pnlEntry) ) then
        self.pnlEntry:SetText(str)
    end
end

function PANEL:GetValue()
    if( IsValid(self.pnlEntry) ) then
        return self.pnlEntry:GetText()
    end

    return nil
end

derma.DefineControl("SlownLS:Hitman:DTextEntry", "", PANEL, "DPanel") 