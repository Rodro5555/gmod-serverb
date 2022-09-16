local bookMat = Material("guide/book.png", "noclamp")
local frame = {}

function frame:Init()
    self.Start = CurTime()
    self:SetSize(ScrW() * 0.7, ScrH() * 0.7)
    self:Center()
    self:SetTitle("")
    self:ShowCloseButton(false)
    self:MakePopup()

    self.OrderedRecipes = {}
    for id, recipe in pairs(MMF.Recipes) do
        if not recipe.Special then
            local cloned = table.Copy(recipe)
            cloned.Id = id
            table.insert(self.OrderedRecipes, cloned)
        end
    end

    self.Page = 0
    self:AdvancePage(true)
end

function frame:Paint(w, h)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(bookMat)
    surface.DrawTexturedRect(0, 0, w, h)
end

function frame:Close()
    if self.Start + 0.5 < CurTime() then
        self:Remove()
    end
end

function frame:AdvancePage(next)
    self.Page = self.Page + (next and 1 or -1)

    self:DrawButtons()
    self:DrawPages()
end

function frame:DrawPages()
    if IsValid(self.LeftPage) then
        self.LeftPage:Remove()
    end

    local w, h = self:GetSize()

    local left = self.Page * 2 - 1
    self.LeftPage = self:DrawPage(w * 0.0586, h * 0.0391, w * 0.41, h * 0.7, self.OrderedRecipes[left])

    if IsValid(self.RightPage) then
        self.RightPage:Remove()
    end

    local right = left + 1
    if self.OrderedRecipes[right] then
        self.RightPage = self:DrawPage(w * 0.52, h * 0.0391, w * 0.41, h * 0.7, self.OrderedRecipes[right])
    end
end

function frame:DrawPage(x, y, w, h, recipe)
    local page = vgui.Create("EditablePanel", self)
    page:SetPos(x, y)
    page:SetSize(w, h)

    local title = vgui.Create("DLabel", page)
    title:SetText(recipe.Name)
    title:SetFont("MMF_GuideTitle")
    title:SetSize(w, h)
    title:SetContentAlignment(8)
    title:SetTextColor(Color(71, 71, 71))

    local panelw, panelh = self:GetSize()

    local i = 1
    for id, quant in pairs(recipe.Ingredients) do
        local ingredient = vgui.Create("ModelImage", page)
        ingredient:SetSize(panelh * 0.078, panelh * 0.078) -- it is okay to use panelh on width here
        ingredient:SetPos(panelw * 0.029, panelh * 0.039 + panelh * 0.078 * i)
        ingredient:SetModel(MMF.Mushrooms[id].Model)

        local quantity = vgui.Create("DLabel", page)
        quantity:SetSize(panelw * 0.058, panelh * 0.078)
        quantity:SetPos(panelw * 0.068, panelh * 0.039 + panelh * 0.078 * i + panelh * 0.026)
        quantity:SetFont("MMF_GuideDescription")
        quantity:SetTextColor(Color(71, 71, 71))
        quantity:SetText("x" .. quant)

        local name = vgui.Create("DLabel", page)
        name:SetPos(panelw * 0.107, panelh * 0.039 + panelh * 0.078 * i + panelh * 0.026)
        name:SetFont("MMF_GuideDescription")
        name:SetTextColor(Color(71, 71, 71))
        name:SetText(MMF.Mushrooms[id].Name)
        name:SizeToContents()

        i = i + 1
    end

    local description = vgui.Create("DLabel", page)
    description:SetText(table.concat(string.Explode("[%c%s]+", recipe.Description or "", true), " "))
    description:SetFont("MMF_GuideDescription")
    description:SetSize(w - panelw * 0.026, h)
    description:SetPos(panelw * 0.019, panelh * 0.455)
    description:SetContentAlignment(8)
    description:SetTextColor(Color(71, 71, 71))
    description:SetWrap(true)

    return page
end

function frame:DrawButtons()
    if IsValid(self.PreviousButton) then
        self.PreviousButton:Remove()
    end

    local w, h = self:GetSize()

    if self.Page > 1 then
        self.PreviousButton = vgui.Create("DButton", self)
        self.PreviousButton:SetSize(w * 0.048, w * 0.048)
        self.PreviousButton:SetPos(w * 0.048, h * 0.78)
        self.PreviousButton:SetText("")
        self.PreviousButton.DoClick = function()
            self:AdvancePage(false)
        end
        function self.PreviousButton:Paint()
            if self:IsHovered() then
                surface.SetDrawColor(80, 80, 80)
            else
                surface.SetDrawColor(50, 50, 50)
            end

            draw.NoTexture()
            surface.DrawPoly({
                { x = 0, y = w * 0.048 * 0.5 },
                { x = w * 0.048 * 0.5, y = 0 },
                { x = w * 0.048 * 0.5, y = w * 0.048 }
            })
        end
    end

    if IsValid(self.NextButton) then
        self.NextButton:Remove()
    end

    if table.Count(MMF.Recipes) > (self.Page + 1) * 2 then
        self.NextButton = vgui.Create("DButton", self)
        self.NextButton:SetSize(w * 0.048, w * 0.048)
        self.NextButton:SetPos(w * 0.92, h * 0.78)
        self.NextButton:SetText("")
        self.NextButton.DoClick = function()
            self:AdvancePage(true)
        end
        function self.NextButton:Paint()
            if self:IsHovered() then
                surface.SetDrawColor(80, 80, 80)
            else
                surface.SetDrawColor(50, 50, 50)
            end

            draw.NoTexture()
            surface.DrawPoly({
                { x = 0, y = 0 },
                { x = w * 0.048 * 0.5, y = w * 0.048 * 0.5 },
                { x = 0, y = w * 0.048 }
            })
        end
    end
end

function frame:Think()
    if input.IsButtonDown(KEY_E) then
        self:Close()
    elseif input.IsButtonDown(MOUSE_LEFT) then
        local hovering = vgui.GetHoveredPanel()
        if not IsValid(hovering) or (hovering ~= self and not hovering:HasParent(self)) then
            self:Close()
        end
    end
end

vgui.Register("MMF_Guide", frame, "DFrame")