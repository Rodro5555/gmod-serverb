local PANEL = {}

local function AASCircle(x, y, radius, seg)
	local cir = {}

	table.insert(cir, { x = x, y = y, u = 0.5, v = 0.5 })
	for i = 0, seg do
		local a = math.rad((i / seg) * -360)
		table.insert(cir, {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5})
	end

	local a = math.rad(0)
	table.insert(cir, {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5})

	surface.DrawPoly(cir)
end

function PANEL:Init()
    self:SetSize(AAS.ScrW*0.19, AAS.ScrH*0.055)
    self.DrawBackground = true
    self.AccurateNumber = 0.02

    local dSlider = vgui.Create("DNumSlider", self)
    dSlider:SetSize(AAS.ScrW*0.15, AAS.ScrH*0.01)
    dSlider:SetPos(AAS.ScrW*0.19/2 - AAS.ScrW*0.15/2, AAS.ScrH*0.033)
    dSlider:SetDefaultValue(0)
    dSlider:SetMin(0)
    dSlider:SetMax(10)
    dSlider:SetDecimals(1)
    self.Slider = dSlider

    dSlider.Slider.Knob.Paint = function(self,w,h)
        local Num = math.Round(dSlider:GetValue())

        surface.SetFont("AAS:Font:03")
        local Text = surface.GetTextSize(tostring(Num)) + AAS.ScrW*0.01

        draw.RoundedBox(0, -Text/2 + w/2, -AAS.ScrH*0.02, Text, AAS.ScrH*0.019, AAS.Colors["white"])
        draw.RoundedBox(0, -Text*0.95/2 + w/2, -AAS.ScrH*0.0193, Text*0.915, AAS.ScrH*0.017, AAS.Colors["black18"])
        draw.DrawText(Num, "AAS:Font:03", w/2, -AAS.ScrH*0.022, AAS.Colors["white"], TEXT_ALIGN_CENTER)

        surface.SetDrawColor(AAS.Colors["white"])
        draw.NoTexture()

        AASCircle(w/2, h*0.5, AAS.ScrW*0.004, 25)
    end 
    dSlider.Slider.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, h*0.6, w, AAS.ScrH*0.002, AAS.Colors["white"])
    end 
    dSlider.TextArea:SetVisible(false)
    dSlider.Label:SetVisible(false)
    
    local leftButton = vgui.Create("DButton", self)
    leftButton:SetSize(AAS.ScrH*0.018, AAS.ScrH*0.018)
    leftButton:SetPos(AAS.ScrW*0.005, AAS.ScrH*0.058/2)
    leftButton:SetText("")
    leftButton.Paint = function(panel,w,h)
        surface.SetDrawColor(AAS.Colors["white"])
        surface.SetMaterial(AAS.Materials["sliderarrowleft"])
        surface.DrawTexturedRect(0, 0, w, h)
        if input.IsMouseDown(MOUSE_LEFT) and leftButton:IsHovered() then
            dSlider:SetValue(dSlider:GetValue() - self.AccurateNumber)
        end
    end
    self.leftButton = leftButton

    local rightButton = vgui.Create("DButton", self)
    rightButton:SetSize(AAS.ScrH*0.018, AAS.ScrH*0.018)
    rightButton:SetPos(AAS.ScrW*0.174, AAS.ScrH*0.058/2)
    rightButton:SetText("")
    rightButton.Paint = function(panel,w,h)
        surface.SetDrawColor(AAS.Colors["white"])
        surface.SetMaterial(AAS.Materials["sliderarrowright"])
        surface.DrawTexturedRect(0, 0, w, h)
        if input.IsMouseDown(MOUSE_LEFT) and rightButton:IsHovered() then
            dSlider:SetValue(dSlider:GetValue() + self.AccurateNumber)
        end
    end
    self.rightButton = rightButton
end

function PANEL:AccurateSlider()
    self.Slider.Slider:Dock(NODOCK)
    self.Slider.Slider:SetSize(AAS.ScrW*0.15,AAS.ScrW*0.005)
    self.Slider.Scratch:SetParent(self)
    self.Slider.Scratch:Dock(FILL)
end

function PANEL:SetAccurateNumber(number)
    self.AccurateNumber = number
end

function PANEL:ChangeBackground(bool)
    self.DrawBackground = bool
end 

function PANEL:Paint(w,h)
    if not self.DrawBackground then return end 
    draw.RoundedBox(8, 0, 0, w, h, AAS.Colors["black18"])
end 

derma.DefineControl("AAS:Slider", "AAS Slider", PANEL, "DPanel")
