--[[  
    Addon: Hitman
    By: SlownLS
]]

local PANEL = {}

AccessorFunc(PANEL,"colBackground","BackgroundColor")
AccessorFunc(PANEL,"colBackgroundHover","BackgroundColorHover")
AccessorFunc(PANEL,"intLerp","Lerp",FORCE_NUMBER)

function PANEL:Init()
    self:SetFont("SlownLS:Hitman:18")
    self:SetTextColor(color_white)
    self:SetText('')

    self:SetLerp(0)
    self:SetBackgroundColor(self:getColor("secondary"))
    self:SetBackgroundColorHover(self:getColor("blue"))

    function self:SetText(str) self.strText = str end
    function self:GetText() return self.strText end
end

function PANEL:OnMousePressed()
    self:DoClick()

    surface.PlaySound( "buttons/button15.wav" )
end

function PANEL:IsHovered()
    return self.Hovered
end

function PANEL:Paint(w, h)
    self:drawRect(0,0,w,h,self:GetBackgroundColor())

    self:SetLerp(Lerp(RealFrameTime() * 8,self:GetLerp(),self:IsHovered() && w + 40 || 0))

    surface.SetDrawColor(self:GetBackgroundColorHover())
    draw.NoTexture()
    surface.DrawPoly({
        { x = 0, y = 0 },
        { x = self:GetLerp() - 40, y = 0 },
        { x = self:GetLerp(), y = h },
        { x = 0, y = h }
    })

    draw.SimpleText(self:GetText(),self:GetFont(),w/2,h/2,self:GetTextColor(),1,1)

    self:drawOutline(0,0,w,h,self:getColor("outline"))
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

vgui.Register("SlownLS:Hitman:DButton",PANEL,"DButton")