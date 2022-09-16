local PANEL = {}

function PANEL:Init()
    self:SetSize(RCD.ScrW*0.1949, RCD.ScrH*0.5)
    self:SetMinMax(0, 1)

    function self.Slider.Knob:Paint(w, h)
	    draw.NoTexture()
        RCD.DrawCircle(w/2, h/2, h/3.5, 0, 360, RCD.Colors["white"])
    end

    function self.Slider:Paint() end
    
    function self:Paint(w,h)
        local coef = math.Remap(self:GetValue(), self:GetMin(), self:GetMax(), 0, 1)

        draw.RoundedBox(0, 0, h*0.5-RCD.ScrH*0.005/2, w*0.99, RCD.ScrH*0.005, RCD.Colors["grey"])
        draw.RoundedBox(0, 0, h*0.5-RCD.ScrH*0.005/2, w*coef*0.99, RCD.ScrH*0.005, RCD.Colors["purple"])
    end

    self.TextArea:SetVisible(false)
    self.Label:SetVisible(false)
end

derma.DefineControl("RCD:Slider", "RCD Slider", PANEL, "DNumSlider")