--[[  
    Addon: Hitman
    By: SlownLS
]]

local PANEL = {}

function PANEL:Init()
    self:SetTextColor(color_white)
    self:SetFont("SlownLS:Hitman:16")
    self:SetSortItems(false)
end

function PANEL:Paint(w, h)
    self:drawRect(0,0,w,h,self:getColor("secondary"))
    self:drawOutline(0,0,w,h,self:getColor("outline"))
end

function PANEL:DoClick()
	if( self:IsMenuOpen() ) then
		return self:CloseMenu()
	end

    self:OpenMenu()

    if( not IsValid(self.Menu) ) then return end
    
    for k, v in pairs(self.Menu:GetCanvas():GetChildren()) do
        v:SetTextColor(color_white)
        v:SetFont("SlownLS:Hitman:16")
        v.Paint = function(pnl,w,h)
            local col = self:getColor("secondary")

            if( pnl:IsHovered() ) then
                col = self:getColor("blue")
            end

            self:drawRect(0,0,w,h,col)
            self:drawOutline(0,0,w,h,self:getColor("outline"))
        end
    end

    self.Menu.Paint = function(pnl,w,h)
        self:drawRect(0,0,w,h,self:getColor("primary"))
        self:drawOutline(0,0,w,h,self:getColor("outline"))
    end
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

derma.DefineControl("SlownLS:Hitman:DComboBox", "", PANEL, "DComboBox") 