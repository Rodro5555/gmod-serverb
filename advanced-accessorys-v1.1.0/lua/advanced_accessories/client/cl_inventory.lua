local function countTable(cat)
    local Count = 1
    local tblInventory = AAS.GetInventory()
    for k,v in pairs(tblInventory) do
        local itemTable = AAS.GetTableById(v.uniqueId)
        if itemTable.category != cat then continue end

        if not istable(itemTable) or #itemTable < 0 then continue end
        if not isstring(itemTable.model) then continue end

        Count = Count + 1
    end

    return Count
end

function AAS.InventoryMenu(itemMenuAccess)
    AAS.ClientTable["filters"] = {["vip"] = true, ["new"] = true, ["search"] = ""}

    local tblInventory = AAS.GetInventory()
    if not istable(tblInventory) or #tblInventory == 0 then AAS.Notification(5, AAS.GetSentence("emptyInventory")) return end

    AAS.BaseMenu(AAS.GetSentence("yourInventory"), true, AAS.ScrW*0.1595, "house")
    AAS.ClientTable["Id"] = (AAS.ScrH*0.038)*(AAS.ClientTable["Id"] - 1)
    
    playerModel = vgui.Create("AAS:DModel", accessoriesFrame)
    playerModel:SetFOV(25)
    
    local categoryList = vgui.Create("DScrollPanel", accessoriesFrame)
    categoryList:SetSize(AAS.ScrW*0.038, AAS.ScrH*0.5)
    categoryList:SetPos(0, AAS.ScrH*0.1)
    categoryList.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, 0, AAS.ScrW*0.038, AAS.ScrH*0.038, AAS.Colors["selectedBlue"])
        draw.RoundedBox(0, AAS.ScrW*0.038 - AAS.ScrW*0.0017, 0, AAS.ScrW*0.002, AAS.ScrH*0.038, AAS.Colors["white200"])
    end

    if AAS.WeightActivate then
        local DProgress = vgui.Create("DPanel", accessoriesFrame)
        DProgress:SetSize(AAS.ScrW*0.385, AAS.ScrH*0.02)
        DProgress:SetPos(accessoriesFrame:GetWide()*0.08, accessoriesFrame:GetTall()*0.95)
        DProgress.Paint = function(self,w,h)
            local count = AAS.CountInventory()
            local max = (not isnumber(AAS.WeightInventory[AAS.LocalPlayer:GetUserGroup()]) and AAS.WeightInventory["all"] or AAS.WeightInventory[AAS.LocalPlayer:GetUserGroup()])

            draw.RoundedBox(0, 0, 0, w, h, AAS.Colors["black18230"])
            draw.RoundedBox(0, 0, 0, w*((count*100/max)/100), h, AAS.Colors["selectedBlue"])

            surface.SetDrawColor(AAS.Colors["white200"])
            surface.DrawOutlinedRect(0, 0, w, h, 1)

            draw.SimpleText(AAS.GetSentence("backpack").." "..count.." / "..max, "AAS:Font:04", w/2, h/2.3, AAS.Colors["white200"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local categoryButton = vgui.Create("DButton", categoryList)
    categoryButton:SetSize(0, AAS.ScrH*0.038)
    categoryButton:Dock(TOP)
    categoryButton:SetText("")
    categoryButton:DockMargin(0,0,0,AAS.ScrH*0.006)
    categoryButton.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, 0, w, h, AAS.Colors["selectedBlue"])
        draw.RoundedBox(0, w*0.955, 0, w*0.1, h, AAS.Colors["white200"])

        surface.SetDrawColor(AAS.Colors["white"])
        surface.SetMaterial(AAS.Materials["avatar"])
        surface.DrawTexturedRect(w/2 - AAS.ScrW*0.015/2, h/2 - AAS.ScrH*0.0268/2, AAS.ScrW*0.015, AAS.ScrH*0.0268)
    end
    categoryButton.DoClick = function()
        AAS.ClientTable["Id"] = k 
    end

    local searchBar = vgui.Create("AAS:SearchBar", accessoriesFrame)
    searchBar:SetPos(accessoriesFrame:GetWide()*0.15, AAS.ScrH*0.055)

    local newButton = vgui.Create("AAS:Button", accessoriesFrame)
    newButton:SetPos(accessoriesFrame:GetWide()*0.47, AAS.ScrH*0.055)
    newButton:SetTheme(false)
    
    local vipButton = vgui.Create("AAS:Button", accessoriesFrame)
    vipButton:SetPos(accessoriesFrame:GetWide()*0.59, AAS.ScrH*0.055)
    vipButton:SetTheme(true)
    vipButton.DoClick = function()
        vipButton:ChangeStatut(true)
    end 
    
    newButton.DoClick = function()
        newButton:ChangeStatut(true)
    end 
    
    local containerScroll = vgui.Create("DScrollPanel", accessoriesFrame)
    containerScroll:SetSize(AAS.ScrW*0.38, AAS.WeightActivate and AAS.ScrH*0.52 or AAS.ScrH*0.56)
    containerScroll:SetPos(AAS.ScrW*0.05, AAS.ScrH*0.085)
    containerScroll:GetVBar():SetWide(0)
    
    local firstOpen = true
    local AASTimerId = 0
    for k,v in ipairs(AAS.Category["mainMenu"]) do
        if v.all then continue end

        local itemsInventory = AAS.GetInventoryByCategory(v.uniqueName)

        local Deployed, LerpPos = false, 0
        local count = istable(itemsInventory[v.uniqueName]) and countTable(v.uniqueName) or 0

        local size = (math.ceil(count/6)-1)*AAS.ScrH*0.1 + AAS.ScrH*0.22
        
        local mainPanel = vgui.Create("DPanel", containerScroll)
        mainPanel:SetSize(0, AAS.ScrH*0.125)
        mainPanel:Dock(TOP)

        local catList = vgui.Create("DScrollPanel", mainPanel)
        catList:SetSize(AAS.ScrW*0.31, 0)
        catList:SetPos(AAS.ScrW*0.02, AAS.ScrH*0.115)
        catList:GetVBar():SetWide(0)

        local itemContainer = vgui.Create("DIconLayout", catList)
        itemContainer:SetSize(AAS.ScrW*0.3, AAS.ScrH*0.25)
        itemContainer:SetSpaceX(AAS.ScrW*0.005)
        itemContainer:SetSpaceY(AAS.ScrW*0.005)
        
        local LerpDeploy = 255
        mainPanel.Paint = function(self,w,h)
            LerpPos = Lerp(FrameTime()*20, LerpPos, Deployed and 255 or 0)
            
            draw.RoundedBox(4, 0, AAS.ScrH*0.05, w, AAS.ScrH*0.05, AAS.Colors["white"])
            draw.RoundedBox(4, AAS.ScrW*0.0008, AAS.ScrH*0.052, w-(AAS.ScrW*0.002), AAS.ScrH*0.045, ColorAlpha(AAS.Colors["dark34"], LerpDeploy))

            draw.RoundedBox(4, AAS.ScrW*0.003, AAS.ScrH*0.0175, AAS.ScrW*0.0424, AAS.ScrH*0.075, AAS.Colors["white"])
            draw.RoundedBox(4, AAS.ScrW*0.004, AAS.ScrH*0.0175 + AAS.ScrH*0.002, AAS.ScrW*0.0424-AAS.ScrW*0.0025, AAS.ScrH*0.071, ColorAlpha(AAS.Colors["dark34"], LerpDeploy))

            draw.RoundedBoxEx(14, AAS.ScrW*0.32, AAS.ScrH*0.05, AAS.ScrW*0.0424, AAS.ScrH*0.075, AAS.Colors["white"], true, false, false, true)
            draw.RoundedBoxEx(12, AAS.ScrW*0.32 + AAS.ScrH*0.0017, AAS.ScrH*0.05 + AAS.ScrH*0.002, AAS.ScrW*0.0424-AAS.ScrW*0.0025, AAS.ScrH*0.071, AAS.Colors["grey53"], true, false, false, true)

            draw.SimpleText(string.upper((v.uniqueName or "")), "AAS:Font:12", w*0.14, AAS.ScrH*0.03, AAS.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            draw.SimpleText(not Deployed and (AAS.GetSentence("changeInv").." "..(v.uniqueName or "").." "..AAS.GetSentence("clickingHere")) or AAS.GetSentence("upHere"), "AAS:Font:10", w*0.48, AAS.ScrH*0.073, ColorAlpha(AAS.Colors["white"], LerpDeploy), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            surface.SetDrawColor(AAS.Colors["white"])
            surface.SetMaterial(v.material)
            surface.DrawTexturedRect( -AAS.ScrW*0.0045, AAS.ScrH*0.03, (v.material:Width()*AAS.ScrW/1920)*1.5, (v.material:Height()*AAS.ScrH/1080)*1.5 )

            local ent = istable(AAS.ClientTable["ItemsEquiped"]) and istable(AAS.ClientTable["ItemsEquiped"][AAS.LocalPlayer:SteamID64()]) and AAS.ClientTable["ItemsEquiped"][AAS.LocalPlayer:SteamID64()][v.uniqueName] or nil
            if not IsValid(ent) then
                surface.SetDrawColor(AAS.Colors["white"])
                surface.SetMaterial(AAS.Materials["add"])
                surface.DrawTexturedRect( AAS.ScrW*0.3285, AAS.ScrH*0.065, (AAS.Materials["add"]:Width()*AAS.ScrW/1920)*0.8, (AAS.Materials["add"]:Height()*AAS.ScrH/1080)*0.8 )
            end

            draw.RoundedBox(0, w*0.02, AAS.ScrH*0.108, 1, itemContainer:GetTall(), ColorAlpha(AAS.Colors["white"], LerpPos))
            draw.RoundedBox(0, w*0.05, h*0.93, w*0.79, 1, ColorAlpha(AAS.Colors["white"], LerpPos))
        end
        
        local antiSpam
        local rightModel = vgui.Create("DModelPanel", mainPanel)
        rightModel:SetSize(AAS.ScrW*0.04, AAS.ScrW*0.04)
        rightModel:SetPos(AAS.ScrW*0.3215, AAS.ScrH*0.05)
        rightModel.LayoutEntity = function() end
        rightModel.DoClick = function()
            antiSpam = antiSpam or 0
            if antiSpam > CurTime() then return end
            antiSpam = CurTime() + 0.5

            catList:SizeTo(catList:GetWide(), Deployed and 0 or size, 0.28, 0, -1, function()
                Deployed = !Deployed
            end)
            mainPanel:SizeTo(mainPanel:GetWide(), Deployed and AAS.ScrH*0.125 or size, 0.3)
        end
 
        rightModel.Think = function(self)
            local inventoryTbl = AAS.ClientTable["ItemsEquiped"][AAS.LocalPlayer:SteamID64()] or {}
            local uniqueId = IsValid(inventoryTbl[v.uniqueName]) and inventoryTbl[v.uniqueName].uniqueId or 0
            local itemTable = AAS.GetTableById(uniqueId)

            self:SetModel(itemTable.model or "")

            if not IsValid(self.Entity) then return end

            if not isnumber(self.mn) or not isnumber(self.mx) then
                self.mn, self.mx = self.Entity:GetRenderBounds()
                
                local size = 0
                size = math.max(size, math.abs(self.mn.x) + math.abs(self.mx.x))
                size = math.max(size, math.abs(self.mn.y) + math.abs(self.mx.y))
                size = math.max(size, math.abs(self.mn.z) + math.abs(self.mx.z))
        
                self:SetCamPos(Vector(size, size, size))
            end
            
            if istable(itemTable["options"]) then
                if isnumber(itemTable["options"]["iconFov"]) then
                    self:SetFOV(45 + itemTable["options"]["iconFov"])
                end
    
                local vector = itemTable["options"]["iconPos"]
                if isvector(vector) then
                    self:SetLookAt((self.mn + self.mx) * 0.5 + vector)
                end
            end

            AAS.SetPanelSettings(rightModel, itemTable)
        end
        
        local DeployButton = vgui.Create("DButton", mainPanel)
        DeployButton:SetSize(AAS.ScrW*0.38, AAS.ScrH*0.05)
        DeployButton:SetPos(0,AAS.ScrH*0.045)
        DeployButton:SetText("")
        DeployButton.Paint = function() end
        DeployButton.DoClick = function()
            antiSpam = antiSpam or 0
            if antiSpam > CurTime() then return end
            antiSpam = CurTime() + 0.5
            
            catList:SizeTo(catList:GetWide(), Deployed and 0 or size, 0.28, 0, -1, function()
                Deployed = !Deployed
            end)
            mainPanel:SizeTo(mainPanel:GetWide(), Deployed and AAS.ScrH*0.125 or size, 0.3)
        end
        DeployButton.Think = function()
            LerpDeploy = Lerp(FrameTime()*10, LerpDeploy, DeployButton:IsHovered() and 253 or 255)
        end
        
        local lerpUnequip = 255
        local backModel = vgui.Create("DPanel", itemContainer)
        backModel:SetSize(AAS.ScrH*0.079,AAS.ScrH*0.079)
        backModel.Paint = function(self,w,h)
            draw.RoundedBoxEx(16, 0, 0, w, h, AAS.Colors["white"], false, true, true, false)
            draw.RoundedBoxEx(14, AAS.ScrW*0.0015, AAS.ScrH*0.003, w - AAS.ScrW*0.003, h-AAS.ScrH*0.0065, ColorAlpha(AAS.Colors["grey165"], lerpUnequip), false, true, true, false)
        end

        local buttonUnEquip = vgui.Create("DButton", backModel)
        buttonUnEquip:Dock(FILL)
        buttonUnEquip:SetText("")
        buttonUnEquip.Paint = function(self,w,h)
            lerpUnequip = Lerp(FrameTime()*3, lerpUnequip, buttonUnEquip:IsHovered() and 180 or 255)

            local width, height = (AAS.Materials["unEquip"]:Width()*AAS.ScrW/1920), (AAS.Materials["unEquip"]:Height()*AAS.ScrH/1080)
            
            surface.SetDrawColor(AAS.Colors["white"])
            surface.SetMaterial(AAS.Materials["unEquip"])
            surface.DrawTexturedRect( width/1.8, height/1.7, width, height )
        end
        buttonUnEquip.DoClick = function()
            net.Start("AAS:Inventory")
                net.WriteUInt(4, 5)
                net.WriteString(itemContainer.AASTable.category)
            net.SendToServer()
        end

        if istable(itemsInventory[v.uniqueName]) then
            for _, item in ipairs(itemsInventory[v.uniqueName]) do
                local itemTable = AAS.GetTableById(item.uniqueId)
                AASTimerId = AASTimerId + 1

                if not istable(itemTable) or #itemTable < 0 or not isstring(itemTable.model) then continue end

                if firstOpen then
                    catList:SetSize(catList:GetWide(), size)
                    mainPanel:SetSize(mainPanel:GetWide(), size)
                    Deployed = true
                    firstOpen = false
                end

                local lerpBackmodel, itemModel = 255
                local backModel = vgui.Create("DPanel", itemContainer)
                backModel:SetSize(AAS.ScrH*0.079,AAS.ScrH*0.079)
                backModel.Paint = function(self,w,h)
                    lerpBackmodel = Lerp(FrameTime()*10, lerpBackmodel, itemModel:IsHovered() and 180 or 255)
                    draw.RoundedBoxEx(16, 0, 0, w, h, AAS.Colors["white"], false, true, true, false)
                    draw.RoundedBoxEx(14, AAS.ScrW*0.0015, AAS.ScrH*0.003, w - AAS.ScrW*0.003, h-AAS.ScrH*0.0065, ColorAlpha(AAS.Colors["grey165"], lerpBackmodel), false, true, true, false)
                end

                local timerName = ("AAS:Timer:...:%s"):format(AASTimerId)
                timer.Create(timerName, 0, 0, function()
                    if IsValid(itemContainer) then itemContainer:Layout() end
                    if not IsValid(backModel) then timer.Remove(timerName) return end 

                    if (itemTable.options["vip"] and itemTable.options["new"]) and not AAS.ClientTable["filters"]["vip"] and not AAS.ClientTable["filters"]["new"] then backModel:SetVisible(false) return end
                    if (itemTable.options["vip"] and not itemTable.options["new"]) and not AAS.ClientTable["filters"]["vip"] then backModel:SetVisible(false) return end
                    if (itemTable.options["new"] and not itemTable.options["vip"]) and not AAS.ClientTable["filters"]["new"] then backModel:SetVisible(false) return end
                    if not string.find(itemTable.name:lower(), AAS.ClientTable["filters"]["search"]:lower()) then backModel:SetVisible(false) return end

                    backModel:SetVisible(true)
                end)

                itemContainer.AASTable = itemTable
                
                itemModel = vgui.Create("DModelPanel", backModel)
                itemModel:SetSize(backModel:GetWide(), backModel:GetWide())
                itemModel:SetModel((itemTable.model or ""))
                itemModel.LayoutEntity = function() end
                itemModel.DoClick = function()
                    net.Start("AAS:Inventory")
                        net.WriteUInt(3, 5)
                        net.WriteUInt(item.uniqueId, 32)
                    net.SendToServer()

                    catList:SizeTo(catList:GetWide(), Deployed and 0 or size, 0.28, 0, -1, function()
                        Deployed = !Deployed
                    end)
                    mainPanel:SizeTo(mainPanel:GetWide(), Deployed and AAS.ScrH*0.125 or size, 0.3)
                end

                itemModel.Think = function(self)              
                    self.mn, self.mx = self.Entity:GetRenderBounds()
                    
                    local size = 0
                    size = math.max(size, math.abs(self.mn.x) + math.abs(self.mx.x))
                    size = math.max(size, math.abs(self.mn.y) + math.abs(self.mx.y))
                    size = math.max(size, math.abs(self.mn.z) + math.abs(self.mx.z))
                
                    self:SetCamPos(Vector(size, size, size))
                    
                    if istable(itemTable["options"]) then
                        if isnumber(itemTable["options"]["iconFov"]) then
                            self:SetFOV(45 + itemTable["options"]["iconFov"])
                        end
            
                        local vector = itemTable["options"]["iconPos"]
                        if isvector(vector) then
                            self:SetLookAt((self.mn + self.mx) * 0.5 + vector)
                        end
                    end

                    AAS.SetPanelSettings(itemModel, itemTable)
                end    
            end
        else
            mainPanel:Remove()
        end

        local upButton = vgui.Create("DButton", mainPanel)
        upButton:SetSize(AAS.ScrH*0.03,AAS.ScrH*0.03)
        upButton:SetPos(0, mainPanel:GetTall()*0.88)
        upButton:SetText("")
        upButton.Paint = function(self,w,h)
            upButton:SetPos(0, mainPanel:GetTall()*0.88)

            if not Deployed then return end
            surface.SetDrawColor(AAS.Colors["white"])
            surface.SetMaterial(AAS.Materials["upButton"])
            surface.DrawTexturedRect( 0, 0, (AAS.Materials["upButton"]:Width()*AAS.ScrW/1920), (AAS.Materials["upButton"]:Height()*AAS.ScrH/1080) )
        end
        upButton.DoClick = function()
            catList:SizeTo(catList:GetWide(), 0, 0.28, 0, -1, function()
                Deployed = false
            end)
            mainPanel:SizeTo(mainPanel:GetWide(), AAS.ScrH*0.125, 0.3)
        end
    end

    local itemsButton = vgui.Create("DButton", accessoriesFrame)
    itemsButton:SetSize(AAS.ScrH*0.0277, AAS.ScrH*0.0277)
    itemsButton:SetPos(AAS.ScrW*0.0384/2 - AAS.ScrH*0.0277/2, accessoriesFrame:GetTall()*0.92)
    itemsButton:SetText("")
    itemsButton.Paint = function(self,w,h)
        surface.SetDrawColor(AAS.Colors["white"])
        surface.SetMaterial(AAS.Materials["market"])
        surface.DrawTexturedRect( 0, 0, w, h )
    end  
    itemsButton.DoClick = function()
        if itemMenuAccess then AAS.Notification(3, AAS.GetSentence("swepcantgo")) return end
        AAS.ItemMenu()
    end
end

function AAS.SettingsPopupMenu(itemTable)
    local linearGradient = {
        {offset = 0, color = AAS.Gradient["upColor"]},
        {offset = 0.4, color = AAS.Gradient["midleColor"]},
        {offset = 1, color = AAS.Gradient["downColor"]},
    }

    if IsValid(popupFrame) then return end
    popupFrame = vgui.Create("DPanel", accessoriesFrame)
    popupFrame:SetSize(AAS.ScrW*0.19, AAS.ScrH*0.16)
    popupFrame:Center()
    popupFrame.startTime = SysTime()
    popupFrame:SetAlpha(0)
    popupFrame:AlphaTo( 255, 0.3, 0 )
    popupFrame.Paint = function(self,w,h)
        Derma_DrawBackgroundBlur(self, self.startTime)
        local x, y = popupFrame:GetPos()

        draw.RoundedBoxEx(8, 0, AAS.ScrH*0.047, w, h-AAS.ScrH*0.047, AAS.Colors["black18"], false, false, true, true)
        
        draw.RoundedBoxEx(8, 0, 0, w, AAS.ScrH*0.047, AAS.Colors["background"], true, true, false, false)
        draw.RoundedBox(6, 0, AAS.ScrH*0.045, w, AAS.ScrH*0.005, AAS.Colors["black150"])

        draw.SimpleText(AAS.GetSentence("adjustAccessory"), "AAS:Font:06", w*0.174, AAS.ScrH*0.021, AAS.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(AAS.GetSentence("adjustText"), "AAS:Font:07", w/2, h*0.465, AAS.Colors["white"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(AAS.Colors["white"])
        surface.SetMaterial(AAS.Materials["market"])
        surface.DrawTexturedRect(w*0.05, AAS.ScrH*0.0105, (AAS.Materials["market"]:Width()*AAS.ScrW/1920)*0.85, (AAS.Materials["market"]:Height()*AAS.ScrH/1080)*0.85)
    end

    local lerpFirstButton = 255
    local equipButton = vgui.Create("DButton", popupFrame)
    equipButton:SetSize(AAS.ScrW*0.09, AAS.ScrH*0.042)
    equipButton:SetPos(AAS.ScrW*0.005, AAS.ScrH*0.105)
    equipButton:SetFont("AAS:Font:02")
    equipButton:SetText(string.upper(AAS.GetSentence("adjust")))
    equipButton:SetTextColor(AAS.Colors["white"])
    equipButton.Paint = function(self,w,h)
        lerpFirstButton = Lerp(FrameTime()*10, lerpFirstButton, self:IsHovered() and 255 or 100)

        draw.RoundedBox(8, 0, 0, w, h,  ColorAlpha(AAS.Colors["blue75"], lerpFirstButton))
    end
    equipButton.DoClick = function()
        AAS.PlayerSettings(itemTable)
    end

    local lerpSecondButton = 255
    local cancelButton = vgui.Create("DButton", popupFrame)
    cancelButton:SetSize(AAS.ScrW*0.09, AAS.ScrH*0.042)
    cancelButton:SetPos(AAS.ScrW*0.097, AAS.ScrH*0.105)
    cancelButton:SetFont("AAS:Font:02")
    cancelButton:SetText(string.upper(AAS.GetSentence("cancel")))
    cancelButton:SetTextColor(AAS.Colors["white"])
    cancelButton.Paint = function(self,w,h)
        lerpSecondButton = Lerp(FrameTime()*10, lerpSecondButton, self:IsHovered() and 255 or 100)

        draw.RoundedBox(8, 0, 0, w, h,  ColorAlpha(AAS.Colors["red49"], lerpSecondButton))
    end
    cancelButton.DoClick = function()
        popupFrame:AlphaTo( 0, 0.3, 0, function()
            popupFrame:Remove()
        end)
    end 
end
--a4ee6702bd4714cea07af458ecd9c98f744f19fdc427694f9321db8bf1818be1