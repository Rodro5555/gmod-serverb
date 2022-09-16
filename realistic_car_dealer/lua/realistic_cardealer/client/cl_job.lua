RCD.CarDealerJob = RCD.CarDealerJob or {}

local signed
function RCD.Invoice(vehiclesTable, invoicePrinted, paper)
    if not istable(vehiclesTable) then return end
    if IsValid(invoiceFrame) then invoiceFrame:Remove() end
    
    signed = false

    local osDate = os.date("%d/%m/%Y")
    
    local price, vehicleSelected = 0, {}
    
    if invoicePrinted then
        RCD.CarDealerJob["invoice"] = vehiclesTable["vehicleParams"] or {}
        vehicleSelected = RCD.AdvancedConfiguration["vehiclesList"][vehiclesTable["vehicleId"]] or {}
    else
        RCD.CarDealerJob["invoice"] = {}
    end

    vehiclesTable["vehicleParams"] = vehiclesTable["vehicleParams"] or {}

    local lerpColor = 0
    invoiceFrame = vgui.Create("DFrame")
    invoiceFrame:SetTitle("")
    invoiceFrame:SetSize(RCD.ScrW*0.373, RCD.ScrH*0.93)
    invoiceFrame:SetPos(RCD.ScrW*0.5-RCD.ScrW*0.373/2, RCD.ScrH*1.2)
    invoiceFrame:MakePopup()
    invoiceFrame:SetDraggable(false)
    invoiceFrame:ShowCloseButton(false)
    invoiceFrame:MoveTo(RCD.ScrW*0.5-RCD.ScrW*0.373/2, RCD.ScrH*0.5-RCD.ScrH*0.93/2, 0.5, 0, -1, function() end)
    invoiceFrame.Paint = function(self,w,h)
        vehicleSelected["options"] = vehicleSelected["options"] or {}

        price = 0
        price = price+(vehicleSelected["price"] or 0)*((vehicleSelected["options"]["cardealerJobDiscount"] or 0)/100)+(RCD.CarDealerJob["invoice"]["vehicleCommission"] or 0)

        surface.SetDrawColor(RCD.Colors["white"])
        surface.SetMaterial(RCD.Materials["invoice"])
        surface.DrawTexturedRect(0, 0, w, h)
        
        draw.DrawText(RCD.GetSentence("carDealer"), "RCD:Font:25", w*0.165, h*0.035, RCD.Colors["purple84"], TEXT_ALIGN_LEFT)
        draw.DrawText(RCD.GetSentence("sellVehicle"), "RCD:Font:23", w*0.165, h*0.075, RCD.Colors["purple84"], TEXT_ALIGN_LEFT)
        
        draw.DrawText(osDate, "RCD:Font:24", w*0.9, h*0.045, RCD.Colors["purple84"], TEXT_ALIGN_RIGHT)
        
        draw.DrawText(RCD.GetSentence("invoice"), "RCD:Font:22", w*0.12, h*0.13, RCD.Colors["purple84"], TEXT_ALIGN_LEFT)
        draw.DrawText(RCD.GetSentence("seller"):format(RCD.LocalPlayer:Name()), "RCD:Font:23", w*0.12, h*0.23, RCD.Colors["purple84"], TEXT_ALIGN_LEFT)
        
        if RCD.CarDealerJob["invoice"]["vehicleSkin"] && RCD.CarDealerJob["invoice"]["vehicleSkin"] != 0 then
            price = price+(vehicleSelected["options"]["priceSkin"] or 0)
            draw.DrawText(RCD.formatMoney(vehicleSelected["options"]["priceSkin"]), "RCD:Font:29", w*0.52, h*0.35, RCD.Colors["black"], TEXT_ALIGN_LEFT)
        else
            draw.DrawText(RCD.formatMoney(0), "RCD:Font:29", w*0.52, h*0.35, RCD.Colors["black"], TEXT_ALIGN_LEFT)
        end
        
        if RCD.CarDealerJob["invoice"]["vehicleColor"] && RCD.CarDealerJob["invoice"]["vehicleColor"] != RCD.ColorPaletteColors[40] then
            price = price+(vehicleSelected["options"]["priceColor"] or 0)
            draw.DrawText(RCD.formatMoney(vehicleSelected["options"]["priceColor"]), "RCD:Font:29", w*0.52, h*0.39, RCD.Colors["black"], TEXT_ALIGN_LEFT)
        else
            draw.DrawText(RCD.formatMoney(0), "RCD:Font:29", w*0.52, h*0.39, RCD.Colors["black"], TEXT_ALIGN_LEFT)
        end

        if RCD.CarDealerJob["invoice"]["vehicleUnderglow"] && RCD.CarDealerJob["invoice"]["vehicleUnderglow"] != RCD.ColorPaletteColors[40] then
            price = price+(vehicleSelected["options"]["priceUnderglow"] or 0)
            draw.DrawText(RCD.formatMoney(vehicleSelected["options"]["priceUnderglow"]), "RCD:Font:29", w*0.52, h*0.43, RCD.Colors["black"], TEXT_ALIGN_LEFT)
        else
            draw.DrawText(RCD.formatMoney(0), "RCD:Font:29", w*0.52, h*0.43, RCD.Colors["black"], TEXT_ALIGN_LEFT)
        end

        draw.DrawText(RCD.formatMoney(price), "RCD:Font:29", w*0.75, h*0.46, RCD.Colors["black"], TEXT_ALIGN_LEFT)
        
        draw.DrawText(RCD.GetSentence("invoiceCarName"), "RCD:Font:26", w*0.16, h*0.315, RCD.Colors["black"], TEXT_ALIGN_CENTER)
        draw.DrawText(RCD.GetSentence("invoiceOptions"), "RCD:Font:26", w*0.39, h*0.315, RCD.Colors["black"], TEXT_ALIGN_CENTER)
        draw.DrawText(RCD.GetSentence("invoiceOptionPrice"), "RCD:Font:26", w*0.615, h*0.315, RCD.Colors["black"], TEXT_ALIGN_CENTER)
        draw.DrawText(RCD.GetSentence("invoiceTotalPrice"), "RCD:Font:26", w*0.84, h*0.315, RCD.Colors["black"], TEXT_ALIGN_CENTER)

        draw.DrawText(RCD.GetSentence("sellerSignature"), "RCD:Font:26", w*0.22, h*0.78, RCD.Colors["black"], TEXT_ALIGN_CENTER)
        draw.DrawText(RCD.GetSentence("buyerSignature"), "RCD:Font:26", w*0.78, h*0.78, RCD.Colors["black"], TEXT_ALIGN_CENTER)
        
        draw.DrawText((vehiclesTable["vehicleParams"]["carDealer"] or RCD.LocalPlayer:Name()), "RCD:Font:27", w*0.21, h*0.8, RCD.Colors["black"], TEXT_ALIGN_CENTER)
        
        lerpColor = Lerp(FrameTime()*5, lerpColor, signed and 255 or 0)
        draw.DrawText(RCD.LocalPlayer:Name(), "RCD:Font:27", w*0.775, h*0.8, ColorAlpha(RCD.Colors["black"], lerpColor), TEXT_ALIGN_CENTER)
        
        draw.RoundedBox(0, w*0.05, h*0.92, w*0.6, h*0.04, RCD.Colors["grey187"])
        
        draw.DrawText("Commission : "..RCD.formatMoney(RCD.CarDealerJob["invoice"]["vehicleCommission"]), "RCD:Font:29", w*0.08, h*0.9235, RCD.Colors["black"], TEXT_ALIGN_LEFT)
    end

    local dScrollPanel = vgui.Create("DScrollPanel", invoiceFrame)
    dScrollPanel:SetSize(RCD.ScrW*0.08, RCD.ScrH*0.4)
    dScrollPanel:SetPos(RCD.ScrW*0.105, RCD.ScrH*0.325)
    dScrollPanel:DockMargin(5, 5, 5, 5)
    dScrollPanel:GetVBar():SetWide(0)

    local chooseSkin = vgui.Create("RCD:DComboBox", dScrollPanel)
    chooseSkin:Dock(TOP)
    chooseSkin:DockMargin(5, 0, 5, 5)
    chooseSkin:SetSize(invoiceFrame:GetWide()*0.18, invoiceFrame:GetTall()*0.034)
    chooseSkin:SetSortItems(false)
    chooseSkin:SetFont("RCD:Font:28")
    chooseSkin:SetTextColor(RCD.Colors["white"])
    chooseSkin:SetText(RCD.GetSentence("chooseSkin"))
    chooseSkin.Paint = function(self,w,h)
        draw.RoundedBox(4, 0, 0, w, invoiceFrame:GetTall()*0.033, RCD.Colors["purple84"])
    end
    chooseSkin.OnSelect = function(self, index, text, data)
        RCD.CarDealerJob["invoice"]["vehicleSkin"] = data
    end
    chooseSkin.DropButton.Paint = function(self,w,h) end

    local chooseColor = vgui.Create("RCD:Accordion", dScrollPanel)
    chooseColor:Dock(TOP)
    chooseColor:DockMargin(5, 0, 5, 5)
    chooseColor:SetSize(invoiceFrame:GetWide()*0.18, invoiceFrame:GetTall()*0.2)
    chooseColor:SetButtonTall(invoiceFrame:GetTall()*0.034)
    chooseColor:SetInteract(false)
    chooseColor:Deploy(0, true, true)

    chooseColor.Paint = function(self,w,h)
        draw.RoundedBox(4, 0, 0, w, invoiceFrame:GetTall()*0.033, RCD.Colors["purple84"])

        RCD.DrawCircle(w*0.87, RCD.ScrH*0.015, RCD.ScrH*0.008, 0, 360, (RCD.CarDealerJob["invoice"]["vehicleColor"] or RCD.Colors["white"]))
        draw.DrawText(RCD.GetSentence("colors"), "RCD:Font:28", w*0.08, invoiceFrame:GetTall()*0.006, RCD.Colors["white"], TEXT_ALIGN_LEFT)

        self:DrawTextEntryText(RCD.Colors["white100"], RCD.Colors["white100"], RCD.Colors["white100"])
    end

    local DPanel = vgui.Create("DPanel", chooseColor)
    DPanel:Dock(FILL)
    DPanel:DockPadding(0, RCD.ScrH*0.035, 0, 0)
    DPanel.Paint = function(self,w,h) 
        draw.RoundedBox(4, 0, 0, w, h, RCD.Colors["purple51"])
    end

    local layout = vgui.Create("DIconLayout", DPanel)
    layout:Dock(FILL)
    layout:InvalidateParent(true)
    layout:SetSpaceX(RCD.ScrW*0.0024)
    layout:SetSpaceY(RCD.ScrH*0.004)
    layout:DockMargin(5, 3, 0, 3)
    layout.Items = {}

    local cols = 10
    local rows = math.ceil(#RCD.ColorPaletteColors/cols)

    for i, v in ipairs(RCD.ColorPaletteColors) do
        if i > 40 then break end
        
        local item = vgui.Create("DButton", layout)
        item:SetSize(RCD.ScrH*0.015, RCD.ScrH*0.015)
        item:SetText("")
        function item:DoClick()
            RCD.CarDealerJob["invoice"]["vehicleColor"] = v
        end

        function item:Paint(w, h)
            RCD.DrawCircle(w/2, h/2, h*0.5, 0, 360, v)
        end
        layout.Items[#layout.Items+1] = item
    end
    
    local chooseUnderglow = vgui.Create("RCD:Accordion", dScrollPanel)
    chooseUnderglow:Dock(TOP)
    chooseUnderglow:DockMargin(5, 0, 5, 5)
    chooseUnderglow:SetSize(invoiceFrame:GetWide()*0.18, invoiceFrame:GetTall()*0.2)
    chooseUnderglow:SetButtonTall(invoiceFrame:GetTall()*0.034)
    chooseUnderglow:SetInteract(false)
    chooseUnderglow:Deploy(0, true, true)
    
    chooseUnderglow.Paint = function(self,w,h)
        draw.RoundedBox(4, 0, 0, w, invoiceFrame:GetTall()*0.033, RCD.Colors["purple84"])
        RCD.DrawCircle(w*0.87, RCD.ScrH*0.015, RCD.ScrH*0.008, 0, 360, (RCD.CarDealerJob["invoice"]["vehicleUnderglow"] or RCD.Colors["white"]))
        
        draw.DrawText(RCD.GetSentence("underglow"), "RCD:Font:28", w*0.08, invoiceFrame:GetTall()*0.006, RCD.Colors["white"], TEXT_ALIGN_LEFT)
    end
    
    local DPanel = vgui.Create("DPanel", chooseUnderglow)
    DPanel:Dock(FILL)
    DPanel:DockPadding(0, RCD.ScrH*0.035, 0, 0)
    DPanel.Paint = function(self,w,h) 
        draw.RoundedBox(4, 0, 0, w, h, RCD.Colors["purple51"])
    end
    
    local layout = vgui.Create("DIconLayout", DPanel)
    layout:Dock(FILL)
    layout:InvalidateParent(true)
    layout:SetSpaceX(RCD.ScrW*0.0024)
    layout:SetSpaceY(RCD.ScrH*0.004)
    layout:DockMargin(5, 3, 0, 3)
    layout.Items = {}

    local cols = 10
    local rows = math.ceil(#RCD.ColorPaletteColors/cols)
    
    for i, v in ipairs(RCD.ColorPaletteColors) do
        if i > 40 then continue end

        local item = vgui.Create("DButton", layout)
        item:SetSize(RCD.ScrH*0.015, RCD.ScrH*0.015)
        item:SetText("")
        function item:DoClick()
            RCD.CarDealerJob["invoice"]["vehicleUnderglow"] = v
        end
        
        function item:Paint(w, h)
            RCD.DrawCircle(w/2, h/2, h*0.5, 0, 360, v)
        end
        layout.Items[#layout.Items+1] = item
    end
    
    local choiceCar = vgui.Create("DComboBox", invoiceFrame)
    choiceCar:SetPos(invoiceFrame:GetWide()*0.078, invoiceFrame:GetTall()*0.35)
    choiceCar:SetSize(invoiceFrame:GetWide()*0.18, invoiceFrame:GetTall()*0.033)
    choiceCar:SetText(RCD.GetSentence("chooseVehicle"))
    choiceCar:SetFont("RCD:Font:28")
    choiceCar:SetTextColor(RCD.Colors["white"])
    if not invoicePrinted then
        for k,v in pairs(vehiclesTable) do
            choiceCar:AddChoice(v.name, k)
        end
    else
        chooseSkin:SetText(RCD.GetSentence("skin").." "..(RCD.CarDealerJob["invoice"]["vehicleSkin"]+1))
        choiceCar:SetText(vehicleSelected["name"])
    end
    choiceCar.DropButton.Paint = function(self,w,h) end
        
    choiceCar.OnSelect = function(self, index, text, data)
        vehicleSelected = vehiclesTable[data]
        
        RCD.CarDealerJob["invoice"] = {
            ["vehicleId"] = vehicleSelected["id"],
            ["vehicleCommission"] = (vehicleSelected["vehicleCommission"] or 0),
            ["vehicleColor"] = RCD.ColorPaletteColors[40],
            ["vehicleUnderglow"] = RCD.ColorPaletteColors[40],
            ["vehicleSkin"] = 0,
        }
        
        chooseSkin:Clear()
        chooseSkin:SetText(RCD.GetSentence("skin").." 1")
        
        for i=0, NumModelSkins(RCD.VehiclesList[vehicleSelected["class"]]["Model"])-1 do
            chooseSkin:AddChoice(RCD.GetSentence("skin").." "..(i+1), i)
        end
        
        chooseUnderglow:Deploy(0, true)
        chooseColor:Deploy(0, true)
        
        chooseUnderglow:SetInteract(true)
        chooseColor:SetInteract(true)
    end
    choiceCar.Paint = function(self,w,h)
        draw.RoundedBox(4,0, 0, w, h, RCD.Colors["purple84"])
        self:DrawTextEntryText(RCD.Colors["white100"], RCD.Colors["white100"], RCD.Colors["white100"])
    end
    
    local acceptLerp = 0
    local acceptButton = vgui.Create("DButton", invoiceFrame)
    acceptButton:SetSize(invoiceFrame:GetWide()*0.15, invoiceFrame:GetTall()*0.04)
    acceptButton:SetPos(invoiceFrame:GetWide()*0.655, invoiceFrame:GetTall()*0.92)
    acceptButton:SetText(RCD.GetSentence((invoicePrinted and "sign" or "print")))
    acceptButton:SetFont("RCD:Font:28")
    acceptButton:SetTextColor(RCD.Colors["white"])
    acceptButton.Paint = function(self,w,h)
        acceptLerp = Lerp(FrameTime()*5, acceptLerp, (self:IsHovered() and 230 or 255))
        draw.RoundedBox(0, 0, 0, w, h, ColorAlpha(RCD.Colors["purple84"], acceptLerp))
    end
    acceptButton.DoClick = function()
        if not istable(RCD.CarDealerJob["invoice"]) or not isnumber(RCD.CarDealerJob["invoice"]["vehicleId"]) then RCD.Notification(5, RCD.GetSentence("selectVehicle")) return end

        if not invoicePrinted then
            net.Start("RCD:Main:Job")
                net.WriteUInt(1, 4)
                net.WriteUInt(RCD.CarDealerJob["invoice"]["vehicleId"], 32)
                net.WriteUInt(RCD.CarDealerJob["invoice"]["vehicleCommission"], 32)
                net.WriteColor(RCD.CarDealerJob["invoice"]["vehicleColor"])
                net.WriteUInt(RCD.CarDealerJob["invoice"]["vehicleSkin"], 5)
                net.WriteColor(RCD.CarDealerJob["invoice"]["vehicleUnderglow"])
            net.SendToServer()
        else
            net.Start("RCD:Main:Job")
                net.WriteUInt(4, 4)
                net.WriteEntity(paper)
            net.SendToServer()
        end
    end

    local closeLerp = 0
    local close = vgui.Create("DButton", invoiceFrame)
    close:SetSize(invoiceFrame:GetWide()*0.15, invoiceFrame:GetTall()*0.04)
    close:SetPos(invoiceFrame:GetWide()*0.81, invoiceFrame:GetTall()*0.92)
    close:SetText(RCD.GetSentence("close"))
    close:SetFont("RCD:Font:28")
    close:SetTextColor(RCD.Colors["white"])
    close.Paint = function(self,w,h)
        closeLerp = Lerp(FrameTime()*5, closeLerp, (self:IsHovered() and 230 or 255))
        draw.RoundedBox(0, 0, 0, w, h,ColorAlpha(RCD.Colors["purple84"], closeLerp))
    end
    close.DoClick = function()
        invoiceFrame:MoveTo(RCD.ScrW*0.5-RCD.ScrW*0.373/2, RCD.ScrH*1.2, 0.5, 0, -1, function()
            if not IsValid(invoiceFrame) then return end
            
            invoiceFrame:Remove()
        end)
    end
end

local function rcdReturnView(pos, angles, fov)
    local view = {}
    view.origin = pos
    view.angles = angles
    view.fov = fov
    view.drawviewer = true
    return view
end

function RCD.ShowCaseMenu(ent)
    RCD.CarDealerJob["calcPos"], RCD.CarDealerJob["calcAng"] = RCD.Constants["vectorOrigin"], RCD.Constants["angleOrigin"]
	local startTime = CurTime()

    RCD.LocalPlayer:SetNoDraw(true)

    if not istable(ent.vehicleInfo) or not ent.vehicleInfo["class"] then
        for k,v in pairs(RCD.AdvancedConfiguration["vehiclesList"]) do
            local options = v["options"] or {}
            if not options["canSellWithJob"] then continue end
            
            RCD.loadMenuInformation(ent, k, v.class, v.price)
            RCD.OpenShowcaseMenu(ent, k, v.class)
            break
        end
    else
        RCD.OpenShowcaseMenu(ent, ent.vehicleInfo["vehicleId"], ent.vehicleInfo["class"])
    end

    hook.Add("CalcView", "RCD:Showcase:CalcView", function(ply, pos, angles, fov)
        local entAng = ent:GetAngles()
        local rcdPos = ent:GetPos()+entAng:Up()*50+entAng:Right()*-15
        local curTime = CurTime()

        local rcdAngleModify = ent:GetAngles()
        rcdAngleModify:RotateAroundAxis(entAng:Up(), -90)
        rcdAngleModify:RotateAroundAxis(entAng:Forward(), 31)

        RCD.CarDealerJob["calcPos"] = LerpVector(math.Clamp(curTime-startTime, 0, 1), RCD.LocalPlayer:EyePos(), rcdPos)
        RCD.CarDealerJob["calcAng"] = LerpAngle(math.Clamp(curTime-startTime, 0, 1), RCD.LocalPlayer:GetAngles(), rcdAngleModify)
        local FOV = 99.4

        return rcdReturnView(RCD.CarDealerJob["calcPos"], RCD.CarDealerJob["calcAng"], FOV)
    end)

    local dFrame = vgui.Create("DFrame")
    dFrame:SetSize(5, 5)
    dFrame:MakePopup()
    dFrame:ShowCloseButton(false)
    dFrame:SetTitle("")
    dFrame.OnRemove = function()
        hook.Remove("CalcView", "RCD:Showcase:CalcView")
        RCD.LocalPlayer:SetNoDraw(false)

        if IsValid(RCD.tempFrame) then
            RCD.tempFrame:Remove()
        end
    end
    dFrame.Paint = function()
        if input.IsKeyDown(KEY_ESCAPE) then
            dFrame:Remove()

            RCD.CarDealerJob["calcPos"] = nil
            RCD.CarDealerJob["calcAng"] = nil

            RCD.loadMenuInformation(ent)        
        end
    end
end

net.Receive("RCD:Main:Job", function()
    local uInt = net.ReadUInt(4)

    if uInt == 1 then
        local bytesAmount = net.ReadUInt(32)
        local unCompressTable = util.Decompress(net.ReadData(bytesAmount)) or ""
        local vehiclesTable = util.JSONToTable(unCompressTable)

        RCD.Invoice(vehiclesTable, false)
    elseif uInt == 2 then
        local ent = net.ReadEntity()
        if not IsValid(ent) then return end

        RCD.ShowCaseMenu(ent)
    elseif uInt == 3 then
        local showcase = net.ReadEntity()
        if not IsValid(showcase) then return end

        local hasVehicle = net.ReadBool()

        showcase.vehicle = hasVehicle
        RCD.OpenShowcaseMenu(showcase)
    elseif uInt == 4 then
        local paper = net.ReadEntity()
        if not IsValid(paper) then return end

        local vehicleId = net.ReadUInt(32)
        local vehicleCommission = net.ReadUInt(32)
        local seller = net.WriteEntity()
        local vehicleColor = net.ReadColor()
        local vehicleUnderglow = net.ReadColor()
        local vehicleSkin = net.ReadUInt(8)
        local carDealer = net.ReadString()

        local invoiceTable = {
            ["seller"] = seller,
            ["vehicleId"] = vehicleId,
            ["carDealer"] = carDealer,
            ["vehicleParams"] = {
                ["vehicleColor"] = vehicleColor,
                ["vehicleUnderglow"] = vehicleUnderglow,
                ["vehicleSkin"] = vehicleSkin,
                ["vehicleId"] = vehicleId,
                ["vehicleCommission"] = vehicleCommission,
            },
        }

        RCD.Invoice(invoiceTable, true, paper)
    elseif uInt == 5 then
        local bool = net.ReadBool()
        
        if bool then
            signed = true
            surface.PlaySound("rcd_sounds/signatorsound.wav")
        end

        timer.Simple((bool and 1 or 0), function()
            if not IsValid(invoiceFrame) then return end

            invoiceFrame:MoveTo(RCD.ScrW*0.5-RCD.ScrW*0.373/2, RCD.ScrH*1.2, 0.5, 0, -1, function()
                if not IsValid(invoiceFrame) then return end
                
                invoiceFrame:Remove()
            end)
        end)
    end
end)