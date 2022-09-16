--[[  
    Addon: Hitman
    By: SlownLS
]]

local PANEL = {}

function PANEL:Init()
    self.tblHeader = {}
    self:SetTitle('')
end

function PANEL:setHeader(tbl)
    for k,v in pairs(tbl or {}) do
        self.tblHeader[k] = v
    end

    if tbl['hideClose'] then
        self:createClose(false)
    else
        self:createClose(true)
    end
end

function PANEL:createClose(bool,intH)
    if IsValid(self.btnClose_) then self.btnClose_:Remove() end

    local tblHeader = self.tblHeader

    if !bool then   
        self:ShowCloseButton(true)
        return
    end 

    self:ShowCloseButton(false)

	local btnClose = vgui.Create("DButton",self)
        btnClose:SetSize(32,32)
        btnClose:SetPos(self:GetWide() - btnClose:GetWide() - 10, intH / 2 - btnClose:GetTall() / 2)
	    btnClose:SetText('✕')
	    btnClose:SetTextColor(color_white)
	    btnClose:SetFont("SlownLS:Hitman:24")
	    btnClose.Paint = nil
	    btnClose.DoClick = function()
            self:fadeOut()
        end

    self.btnClose_ = btnClose
end

function PANEL:fadeIn(int)
    int = int or 0.2
    
    self:SetAlpha(0)
    self:AlphaTo(255,int)
end 

function PANEL:fadeOut(int, intDelay)
    int = int or 0.2

    self:SetMouseInputEnabled(false)
    self:SetKeyBoardInputEnabled(false)

    self:SetAlpha(255)
    self:AlphaTo(0, int, intDelay,function()
        self:Remove()
    end)
end

--[[ Utils ]]
function PANEL:getColor(str)
    return SlownLS.Hitman:getColor(str)
end

function PANEL:drawRect(x, y, w, h, color)
    return SlownLS.Hitman:drawRect(x, y, w, h, color)
end 

function PANEL:drawOutline(x, y, w, h, color)
    return SlownLS.Hitman:drawOutline(x, y, w, h, color)
end 

function PANEL:drawOutlineRoundedboxEx(r, x, y, w, h, color, topL, topR, bottomL, bottomR)
    draw.RoundedBoxEx(r, x - 1, y - 1, w + 2, h + 2, color, topL, topR, bottomL, bottomR)
end

function PANEL:getTextSize(strText,strFont)
    surface.SetFont(strFont)
    return surface.GetTextSize(strText)
end

function PANEL:getLanguage(str)
    return SlownLS.Hitman:getLanguage(str)
end

derma.DefineControl("SlownLS:Hitman:DFrame","",PANEL,"DFrame")