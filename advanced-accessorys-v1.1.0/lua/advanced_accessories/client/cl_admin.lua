local boneName, clientSideModelColor, lerpBack = "ValveBiped.Bip01_Head1", AAS.Colors["whiteConfig"], false

local function addLabel(scroll, text)
    if not IsValid(scroll) then return end 

    local dLabel = vgui.Create("DLabel", scroll)
    dLabel:SetText(text)
    dLabel:SetFont("AAS:Font:03")
    dLabel:SetTextColor(AAS.Colors["white"])
    dLabel:DockMargin(0,0,0,AAS.ScrH*0.003)
end

local function getItemSettings(typeSet)
    local tbl = AAS.ClientTable["AdminPos"] or {}
    for i=1, 3 do tbl[i] = tbl[i] or {} end 

    if typeSet == "pos" then 
        return Vector((tbl[1][typeSet] or 0), (tbl[2][typeSet] or 0), (tbl[3][typeSet] or 0))
    elseif typeSet == "rotate" then 
        return Angle((tbl[1][typeSet] or 0), (tbl[2][typeSet] or 0), (tbl[3][typeSet] or 0))
    elseif typeSet == "scale" then 
        return Vector((tbl[1][typeSet] or 1), (tbl[2][typeSet] or 1), (tbl[3][typeSet] or 1))
    end
end

local itemModel, skinList, panelBack
function AAS.settingsScroll(panel, posy, sizey, editItem, title, rightPos, modifyPos)
    if IsValid(sliderList) then sliderList:Remove() end
    if IsValid(panelBack) then panelBack:Remove() end

    for i=1, 4 do AAS.ClientTable["ResizeIcon"][i] = 0 end
    
    if istable(AAS.ClientTable["ItemSelected"]) then
        local pos = AAS.ClientTable["ItemSelected"].pos
        local ang = AAS.ClientTable["ItemSelected"].ang
        local scale = AAS.ClientTable["ItemSelected"].scale
        
        for i=1, 3 do
            if not isvector(pos) or not isangle(ang) or not isvector(scale) then return end
            AAS.ClientTable["AdminPos"][i] = {}
            
            AAS.ClientTable["AdminPos"][i]["pos"] = pos[i]
            AAS.ClientTable["AdminPos"][i]["rotate"] = ang[i]
            AAS.ClientTable["AdminPos"][i]["scale"] = scale[i]
        end
    end
    
    clientSideModelColor = AAS.Colors["whiteConfig"]
    
    --[[ Global for know when the menu was open ]]
    sliderList = vgui.Create("AAS:ScrollPanel", panel)
    sliderList:SetSize(AAS.ScrW*0.19, sizey)
    sliderList:SetPos(panel:GetWide() - AAS.ScrW*0.195, posy)
    sliderList:DockMargin(0,AAS.ScrH*0.01,0,-AAS.ScrH*0.01)

    addLabel(sliderList, AAS.GetSentence("name"))

    local itemName = vgui.Create("AAS:TextEntry", sliderList)
    itemName:DockMargin(0,0,AAS.ScrH*0.006,AAS.ScrH*0.006)
    itemName:SetHoldText(AAS.GetSentence("itemName"))
    if editItem and istable(AAS.ClientTable["ItemSelected"]) then itemName:SetText(AAS.ClientTable["ItemSelected"].name) end

    addLabel(sliderList, AAS.GetSentence("desc"))

    local itemDesc = vgui.Create("AAS:TextEntry", sliderList)
    itemDesc:DockMargin(0,0,AAS.ScrH*0.006,AAS.ScrH*0.006)
    itemDesc:SetHoldText(AAS.GetSentence("description"))
    itemDesc:SetSize(0,AAS.ScrH*0.065)
    itemDesc:SetMultiline(true)
    if editItem and istable(AAS.ClientTable["ItemSelected"]) then itemDesc:SetText(AAS.ClientTable["ItemSelected"].description) end

    if editItem then
        addLabel(sliderList, AAS.GetSentence("itemUniqueId"))

        local itemId = vgui.Create("AAS:TextEntry", sliderList)
        itemId:DockMargin(0,0,AAS.ScrH*0.006,AAS.ScrH*0.006)
        itemId:SetEditable(false)
        if editItem and istable(AAS.ClientTable["ItemSelected"]) then itemId:SetText(AAS.ClientTable["ItemSelected"].uniqueId) end
    end

    addLabel(sliderList, AAS.GetSentence("model"))

    itemModel = vgui.Create("AAS:TextEntry", sliderList)
    itemModel:DockMargin(0,0,AAS.ScrH*0.006,AAS.ScrH*0.006)
    itemModel:SetHoldText("models/props_junk/TrafficCone001a.mdl")
    if editItem and istable(AAS.ClientTable["ItemSelected"]) then itemModel:SetText(AAS.ClientTable["ItemSelected"].model) end

    itemModel.OnChange = function()
        if IsValid(skinList) then
            skinList:Clear()

            for i=0, NumModelSkins(itemModel:GetText()) do
                skinList:AddChoice(i)
            end

            skinList:SetValue(0)
        end
    end

    addLabel(sliderList, AAS.GetSentence("itemPrice"))

    local itemPrice = vgui.Create("AAS:TextEntry", sliderList)
    itemPrice:DockMargin(0,0,AAS.ScrH*0.006,AAS.ScrH*0.008)
    itemPrice:SetHoldText("1000")
    itemPrice:SetNumeric(true)
    if editItem and istable(AAS.ClientTable["ItemSelected"]) then itemPrice:SetText(AAS.ClientTable["ItemSelected"].price) end

    local itemColor = vgui.Create( "DColorMixer", sliderList)
    itemColor:DockMargin(0,0,AAS.ScrH*0.006,AAS.ScrH*0.006)
    itemColor:SetSize(0, AAS.ScrH*0.2)
    itemColor:SetWangs(false)
    itemColor:SetColor(AAS.Colors["white"])
    if editItem and istable(AAS.ClientTable["ItemSelected"]) and istable(AAS.ClientTable["ItemSelected"].options.color) then itemColor:SetColor(AAS.ClientTable["ItemSelected"].options.color) end

    itemColor.ValueChanged = function(panel, color)
        clientSideModelColor = color
    end

    if modifyPos then
        addLabel(sliderList, AAS.GetSentence("itemPos"))

        local posSetup = vgui.Create("DButton", sliderList)
        posSetup:DockMargin(0,0,AAS.ScrH*0.006,AAS.ScrH*0.006)
        posSetup:SetText("")
        posSetup.Paint = function(self,w,h)
            draw.RoundedBox(3, 0, 0, w, h, AAS.Colors["black18"])
            draw.SimpleText(AAS.GetSentence("modifypos"), "AAS:Font:03", w*0.02, h/2.1, AAS.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end 
        posSetup.DoClick = function()
            AAS.PositionSettings(true)
        end
    end

    addLabel(sliderList, AAS.GetSentence("choosecategory"))

    local categoryList = vgui.Create("AAS:ComboBox", sliderList)
    categoryList:SetSize(AAS.ScrW*0.061, AAS.ScrH*0.027)
    categoryList:DockMargin(0,0,AAS.ScrH*0.006,AAS.ScrH*0.006)
    categoryList:SetText(AAS.GetSentence("combocategory"))

    for k,v in ipairs(AAS.Category["mainMenu"]) do
        if istable(AAS.ClientTable["ItemSelected"]) and AAS.ClientTable["ItemSelected"].category == v.uniqueName then
            boneName = v.bone
        end

        if v.all then continue end
        categoryList:AddChoice(v.uniqueName, v.bone)
    end

    categoryList.OnSelect = function(self, index, value)
        local data = self:GetOptionData(self:GetSelectedID())
        boneName = data
    end
    if editItem and istable(AAS.ClientTable["ItemSelected"]) and isstring(AAS.ClientTable["ItemSelected"].category) then categoryList:SetValue(AAS.ClientTable["ItemSelected"].category) end
      
    addLabel(sliderList, AAS.GetSentence("chooseskin"))

    skinList = vgui.Create("AAS:ComboBox", sliderList)
    skinList:SetSize(AAS.ScrW*0.061, AAS.ScrH*0.027)
    skinList:DockMargin(0,0,AAS.ScrH*0.006,AAS.ScrH*0.006)
    skinList:SetText(AAS.GetSentence("comboskin"))

    for i=0, NumModelSkins(itemModel:GetText()) do
        skinList:AddChoice(i)
    end

    if editItem and istable(AAS.ClientTable["ItemSelected"]) and isnumber(tonumber(AAS.ClientTable["ItemSelected"].options.skin)) then skinList:SetValue(AAS.ClientTable["ItemSelected"].options.skin) end

    local buttonlist = vgui.Create("AAS:ScrollPanel", sliderList)
    buttonlist:SetSize(0, AAS.ScrH*0.05)
    buttonlist:DockMargin(0,AAS.ScrH*0.01,0,-AAS.ScrH*0.01)

    local vipButton = vgui.Create("AAS:Button", buttonlist)
    vipButton:SetTheme(true)
    vipButton:Dock(LEFT)
    vipButton:ChangeStatut()
    vipButton.DoClick = function()
        vipButton:ChangeStatut()
    end 
    if editItem and istable(AAS.ClientTable["ItemSelected"]) and AAS.ClientTable["ItemSelected"].options.vip then vipButton:ChangeStatut() end
    
    local newButton = vgui.Create("AAS:Button", buttonlist)
    newButton:SetTheme(false)
    newButton:Dock(LEFT)
    newButton:ChangeStatut()
    newButton.DoClick = function()
        newButton:ChangeStatut()
    end 
    if editItem and istable(AAS.ClientTable["ItemSelected"]) and AAS.ClientTable["ItemSelected"].options.new then newButton:ChangeStatut() end

    addLabel(sliderList, AAS.GetSentence("titleactivate"))

    local activateList = vgui.Create("AAS:ComboBox", sliderList)
    activateList:SetSize(AAS.ScrW*0.061, AAS.ScrH*0.025)
    activateList:DockMargin(0,0,AAS.ScrH*0.006,AAS.ScrH*0.006)
    activateList:AddChoice(AAS.GetSentence("activate"), true)
    activateList:AddChoice(AAS.GetSentence("desactivate"), false)
    activateList:ChooseOptionID(1)
    if editItem and istable(AAS.ClientTable["ItemSelected"]) and isbool(AAS.ClientTable["ItemSelected"].options.activate) then activateList:ChooseOptionID(AAS.ClientTable["ItemSelected"].options.activate and 1 or 2) end

    addLabel(sliderList, AAS.GetSentence("itemJob"))

    local jobTable = {}
    for k,v in ipairs(RPExtraTeams) do 
        local jobPanel = vgui.Create("DButton", sliderList)
        jobPanel:DockMargin(0,0,AAS.ScrH*0.006,AAS.ScrH*0.006)
        jobPanel:SetText("")
        jobPanel.Paint = function(self,w,h)
            draw.RoundedBox(3, 0, 0, w, h, AAS.Colors["black18"])
            draw.SimpleText(v.name, "AAS:Font:03", w*0.02, h/2.1, AAS.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end 
        
        local checkBox = vgui.Create("AAS:CheckBox", jobPanel)
        checkBox:SetSize(AAS.ScrH*0.015, AAS.ScrH*0.0155)
        checkBox:SetPos(sliderList:GetWide()*0.9, jobPanel:GetTall()*0.5 - AAS.ScrH*0.015/2)
        checkBox:SetValue(false)

        if istable(AAS.ClientTable["ItemSelected"]) and AAS.ClientTable["ItemSelected"].job[v.name] then 
            jobTable[v.name] = true
            checkBox:SetValue(true)
        end
        checkBox.DoClick = function()
            local bool = !tobool(checkBox:GetValue())

            checkBox:SetValue(bool)
            jobTable[v.name] = (bool and true or nil)
        end 
        
        jobPanel.DoClick = function()
            local bool = !tobool(checkBox:GetValue())

            checkBox:SetValue(bool)
            jobTable[v.name] = (bool and true or nil)
        end 
    end

    addLabel(sliderList, AAS.GetSentence("rankBlackList"))

    local rankTable = {}
    for k,v in pairs(CAMI.GetUsergroups()) do 
        local rankPanel = vgui.Create("DButton", sliderList)
        rankPanel:DockMargin(0,0,AAS.ScrH*0.006,AAS.ScrH*0.006)
        rankPanel:SetText("")
        rankPanel.Paint = function(self,w,h)
            draw.RoundedBox(3, 0, 0, w, h, AAS.Colors["black18"])
            draw.SimpleText(k, "AAS:Font:03", w*0.02, h/2.1, AAS.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end 
        
        local checkBox = vgui.Create("AAS:CheckBox", rankPanel)
        checkBox:SetSize(AAS.ScrH*0.015, AAS.ScrH*0.0155)
        checkBox:SetPos(sliderList:GetWide()*0.9, rankPanel:GetTall()*0.5 - AAS.ScrH*0.015/2)
        checkBox:SetValue(true)

        if istable(AAS.ClientTable["ItemSelected"]) and istable(AAS.ClientTable["ItemSelected"].options.usergroups) then
            if AAS.ClientTable["ItemSelected"].options.usergroups[k] == true then
            
                rankTable[k] = true
                checkBox:SetValue(false)
            end
        end

        checkBox.DoClick = function()
            local bool = !tobool(checkBox:GetValue())

            checkBox:SetValue(bool)
            rankTable[k] = !bool
        end 
        
        rankPanel.DoClick = function()
            local bool = !tobool(checkBox:GetValue())

            checkBox:SetValue(bool)
            rankTable[k] = !bool
        end 
    end

    if not IsValid(mainPanel) then
        addLabel(sliderList, AAS.GetSentence("iconPos"))
        
        for i=1, 4 do
            if i == 4 then 
                addLabel(sliderList, AAS.GetSentence("iconFov"))                
            end

            local slider = vgui.Create("AAS:Slider", sliderList)
            slider:DockMargin(0,0,AAS.ScrW*0.003,AAS.ScrH*0.006)
            slider.Slider:SetMin(-100)
            slider.Slider:SetMax(100)

            slider.rightButton:SetX(slider.rightButton:GetX() - AAS.ScrW*0.005)
            slider.Slider:SetWide(slider.Slider:GetWide() - AAS.ScrW*0.005)

            if istable(AAS.ClientTable["ItemSelected"]) then
                if i == 4 then
                    if isnumber(AAS.ClientTable["ItemSelected"]["options"]["iconFov"]) then
                        slider.Slider:SetValue(AAS.ClientTable["ItemSelected"]["options"]["iconFov"])
                        AAS.ClientTable["ResizeIcon"][i] = AAS.ClientTable["ItemSelected"]["options"]["iconFov"]
                    end
                elseif i < 4 then
                    if isvector(AAS.ClientTable["ItemSelected"]["options"]["iconPos"]) then
                        slider.Slider:SetValue(AAS.ClientTable["ItemSelected"]["options"]["iconPos"][i])
                        AAS.ClientTable["ResizeIcon"][i] = AAS.ClientTable["ItemSelected"]["options"]["iconPos"][i]
                    end
                end
            end

            slider.Slider.OnValueChanged = function(self, value)
                AAS.ClientTable["ResizeIcon"][i] = value
            end
        end
    else
        for i=1, 4 do
            if istable(AAS.ClientTable["ItemSelected"]) then
                if i == 4 then
                    if isnumber(AAS.ClientTable["ItemSelected"]["options"]["iconFov"]) then
                        AAS.ClientTable["ResizeIcon"][i] = AAS.ClientTable["ItemSelected"]["options"]["iconFov"]
                    end
                elseif i < 4 then
                    if isvector(AAS.ClientTable["ItemSelected"]["options"]["iconPos"]) then
                        AAS.ClientTable["ResizeIcon"][i] = AAS.ClientTable["ItemSelected"]["options"]["iconPos"][i]
                    end
                end
            end
        end
    end
    
    panelBack = vgui.Create("DPanel", panel)
    panelBack:SetSize(AAS.ScrW*0.197, AAS.ScrH*0.04)
    panelBack:SetPos(rightPos and accessoriesFrame:GetWide()*0.67 or AAS.ScrW*0.006, rightPos and AAS.ScrH*0.065 or AAS.ScrH*0.01)
    panelBack.Paint = function(self,w,h)
        draw.DrawText((title or ""), "AAS:Font:04", w*0.02, h*0.1, AAS.Colors["white"], TEXT_ALIGN_LEFT)
        draw.RoundedBox(0, w*0.025, h*0.93, w*0.94, AAS.ScrH*0.002, AAS.Colors["white"])
    end
    
    local lerpFirstButton = 255
    local firstButton = vgui.Create("DButton", panelBack)
    firstButton:SetSize(AAS.ScrW*0.055, AAS.ScrH*0.027)
    firstButton:SetPos(panelBack:GetWide()*0.685, AAS.ScrH*0.0)
    firstButton:SetFont("AAS:Font:04")
    firstButton:SetTextColor(AAS.Colors["white"])
    firstButton:SetText(AAS.GetSentence("cancel"))
    firstButton.Paint = function(self,w,h)
        lerpFirstButton = Lerp(FrameTime()*10, lerpFirstButton, self:IsHovered() and 255 or 100)

        draw.RoundedBox(5, 0, 0, w, h, ColorAlpha(AAS.Colors["red49"], lerpFirstButton))
    end 
    firstButton.DoClick = function()
        if IsValid(mainPanel) then
            lerpBack = true
            calcPosE, calcAngE, calcPos, calcAng = AAS.LocalPlayer:EyePos(), AAS.LocalPlayer:GetAngles(), ((AASClientSide:GetPos() - (AASClientSide:GetAngles():Forward() * -100) + AASClientSide:GetAngles():Up() * 100)), (AAS.LocalPlayer:GetAngles() + Angle(0, -180, 0))

            mainPanel:AlphaTo( 100, 1, 0, function() 
                if not IsValid(mainPanel) then return end 
                mainPanel:Remove()

                if #AAS.ClientTable["ItemsTable"] == 0 then
                    AAS.ItemMenu()
                else
                    AAS.AdminSetting()
                end
            end)
        end 
    end 

    local lerpSecondButton = 255
    local secondButton = vgui.Create("DButton", panelBack)
    secondButton:SetSize(AAS.ScrW*0.065, AAS.ScrH*0.027)
    secondButton:SetPos(panelBack:GetWide()*0.33, AAS.ScrH*0.0)
    secondButton:SetFont("AAS:Font:04")
    secondButton:SetTextColor(AAS.Colors["white"])
    secondButton:SetText(AAS.GetSentence("save"))
    secondButton.Paint = function(self,w,h)
        lerpSecondButton = Lerp(FrameTime()*10, lerpSecondButton, self:IsHovered() and 255 or 100)

        draw.RoundedBox(5, 0, 0, w, h, ColorAlpha(AAS.Colors["blue77"], lerpSecondButton))
    end 
    secondButton.DoClick = function()
        if itemName:GetText() == "" or itemName:GetText() == AAS.GetSentence("itemName") then AAS.Notification(5, AAS.GetSentence("adminname")) return end
        if itemDesc:GetText() == "" or itemDesc:GetText() == AAS.GetSentence("description") then AAS.Notification(5, AAS.GetSentence("faildesc")) return end
        if itemModel:GetText() == "" then AAS.Notification(5, AAS.GetSentence("choosemodel")) return end
        if itemPrice:GetText() == "" or tonumber(itemPrice:GetText()) < 0 then AAS.Notification(5, AAS.GetSentence("failprice")) return end
        if not AAS.CheckCategory(categoryList:GetText()) then AAS.Notification(5, AAS.GetSentence("failcategory")) return end  
        
        local activate = activateList:GetOptionData(activateList:GetSelectedID()) or false

        local adminTable = {
            ["name"] = itemName:GetText(),
            ["description"] = itemDesc:GetText(),
            ["model"] = itemModel:GetText(),
            ["price"] = itemPrice:GetText(),
            ["options"] = {
                ["new"] = newButton:GetStatut(),
                ["vip"] = vipButton:GetStatut(),
                ["activate"] = activate,
                ["color"] = itemColor:GetColor(),
                ["bone"] = boneName,
                ["iconFov"] = AAS.ClientTable["ResizeIcon"][4],
                ["iconPos"] = Vector(AAS.ClientTable["ResizeIcon"][1], AAS.ClientTable["ResizeIcon"][2], AAS.ClientTable["ResizeIcon"][3]),
                ["skin"] = skinList:GetValue(),
                ["usergroups"] = rankTable,
            },
            ["category"] = categoryList:GetText(),
            ["pos"] = getItemSettings("pos"),
            ["ang"] = getItemSettings("rotate"),
            ["scale"] = getItemSettings("scale"), 
            ["job"] = jobTable,
            ["uniqueId"] = istable(AAS.ClientTable["ItemSelected"]) and isnumber(AAS.ClientTable["ItemSelected"].uniqueId) and AAS.ClientTable["ItemSelected"].uniqueId or nil,
        }

        net.Start("AAS:Main")
            net.WriteUInt(AAS.ClientTable["ItemSelected"] != nil and 3 or 1, 5)
            net.WriteTable(adminTable)
        net.SendToServer()

        if IsValid(mainPanel) then
            lerpBack = true
            calcPosE, calcAngE, calcPos, calcAng = AAS.LocalPlayer:EyePos(), AAS.LocalPlayer:GetAngles(), ((AASClientSide:GetPos() - (AASClientSide:GetAngles():Forward() * -100) + AASClientSide:GetAngles():Up() * 100)), (AAS.LocalPlayer:GetAngles() + Angle(0, -180, 0))

            mainPanel:AlphaTo( 100, 1, 0, function() 
                if not IsValid(mainPanel) then return end 
                mainPanel:Remove()

                AAS.AdminSetting()
            end)
        end 
    end 
end

function AAS.AdminSetting()
    if not AAS.AdminRank[AAS.LocalPlayer:GetUserGroup()] then return end
    
    AAS.BaseMenu(AAS.GetSentence("adminDashboard"), false, AAS.ScrW*0.2, "customcharacter")
    AAS.ClientTable["Id"] = 1

    local LerpPos = 0
    local categoryList = vgui.Create("DScrollPanel", accessoriesFrame)
    categoryList:SetSize(AAS.ScrW*0.038, AAS.ScrH*0.5)
    categoryList:SetPos(0, AAS.ScrH*0.1)
    categoryList.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, LerpPos, AAS.ScrW*0.038, AAS.ScrH*0.038, AAS.Colors["selectedBlue"])
        draw.RoundedBox(0, AAS.ScrW*0.038 - AAS.ScrW*0.0017, LerpPos, AAS.ScrW*0.002, AAS.ScrH*0.038, AAS.Colors["white200"])
    end

    for k,v in ipairs(AAS.Category["adminMenu"]) do 
        local categoryButton = vgui.Create("DButton", categoryList)
        categoryButton:SetSize(0, AAS.ScrH*0.038)
        categoryButton:Dock(TOP)
        categoryButton:SetText("")
        categoryButton:DockMargin(0,0,0,AAS.ScrH*0.006)
        categoryButton.Paint = function(self,w,h)
            surface.SetDrawColor(AAS.Colors["white"])
            surface.SetMaterial(v.material, "smooth")
            surface.DrawTexturedRect((w/2)-(AAS.ScrW*v.sizeX/2), h/2-(AAS.ScrH*v.sizeY/2), AAS.ScrW*v.sizeX, AAS.ScrH*v.sizeY)

            LerpPos = Lerp(FrameTime()*5, LerpPos, (AAS.ScrH*0.038 + AAS.ScrH*0.006)*(AAS.ClientTable["Id"] - 1))
        end 
        categoryButton.DoClick = function()
            AAS.ClientTable["Id"] = k
            timer.Simple(0.3, function()
                v.callBack()
            end)
        end
    end

    --[[ Global for update player and admin cards ]]
    itemScroll = vgui.Create( "AAS:ScrollPanel", accessoriesFrame)
    itemScroll:SetSize(AAS.ScrW*0.343, AAS.ScrH*0.542)
    itemScroll:SetPos(AAS.ScrW*0.052, AAS.ScrH*0.1)

    itemContainer = vgui.Create("DIconLayout", itemScroll)
    itemContainer:SetSize(AAS.ScrW*0.343, AAS.ScrH*0.542)
    itemContainer:SetSpaceX(AAS.ScrW*0.001) 
    itemContainer:SetSpaceY(AAS.ScrW*0.016) 

    for k,v in ipairs(AAS.ClientTable["ItemsTable"]) do 
        local itemBackground = vgui.Create("AAS:Cards", itemContainer)
        itemBackground:SetSize(AAS.ScrW*0.11, AAS.ScrH*0.26)
        itemBackground:AddItemView(itemScroll, accessoriesFrame, itemContainer, v)

        if k == 1 then 
            AAS.ClientTable["ItemSelected"] = v
        end 
    end 

    local searchBar = vgui.Create("AAS:SearchBar", accessoriesFrame)
    searchBar:SetPos(accessoriesFrame:GetWide()*0.11, AAS.ScrH*0.055)

    local newButton = vgui.Create("AAS:Button", accessoriesFrame)
    newButton:SetPos(accessoriesFrame:GetWide()*0.42, AAS.ScrH*0.055)
    newButton:SetTheme(false)

    local vipButton = vgui.Create("AAS:Button", accessoriesFrame)
    vipButton:SetPos(accessoriesFrame:GetWide()*0.5255, AAS.ScrH*0.055)
    vipButton:SetTheme(true)
    vipButton.DoClick = function()
        vipButton:ChangeStatut(true)

        AAS.UpdateList(AAS.ClientTable["ItemsVisible"], true)
    end

    newButton.DoClick = function()
        newButton:ChangeStatut(true)

        AAS.UpdateList(AAS.ClientTable["ItemsVisible"], true)
    end

    AAS.settingsScroll(accessoriesFrame, AAS.ScrH*0.11, AAS.ScrH*0.525, true, AAS.GetSentence("edititem"), true, true)

    local storeButton = vgui.Create("DButton", accessoriesFrame)
    storeButton:SetSize(AAS.ScrH*0.0277, AAS.ScrH*0.0277)
    storeButton:SetPos(AAS.ScrW*0.0384/2 - AAS.ScrH*0.0277/2, accessoriesFrame:GetTall()*0.92)
    storeButton:SetText("")
    storeButton.Paint = function(self,w,h)
        surface.SetDrawColor(AAS.Colors["white"])
        surface.SetMaterial(AAS.Materials["market"])
        surface.DrawTexturedRect( 0, 0, w, h )
    end  
    storeButton.DoClick = function()
        AAS.ItemMenu()
    end 

    if #AAS.ClientTable["ItemsTable"] == 0 then AAS.PositionSettings() end
end

local function sliderMove(x, y, panel, title, name)
    local sliderPanel = vgui.Create("DPanel", panel)
    sliderPanel:SetSize(AAS.ScrW*0.19, AAS.ScrH*0.175)
    sliderPanel:SetPos(x, y)

    sliderPanel.Paint = function(self,w,h)
        draw.RoundedBoxEx(8, 0, 0, w, h, AAS.Colors["black18230"], false, false, true, true)
        draw.RoundedBox(0, 0, 0, w, h*0.26, AAS.Colors["black18"])
        draw.RoundedBox(0, 0, h*0.26, w, h*0.05, AAS.Colors["black18100"])
        
        draw.DrawText(title, "AAS:Font:05", w/2, h*0.05, AAS.Colors["white"], TEXT_ALIGN_CENTER)
    end 

    for i=1, 3 do 
        local slider = vgui.Create("AAS:Slider", sliderPanel)
        slider:SetPos(0, i*AAS.ScrH*0.04)
        slider:ChangeBackground(false)

        if name == "pos" then
            slider.Slider:SetMin(-100)
            slider.Slider:SetMax(100)
            slider.Slider:SetValue(0)
            
            if istable(AAS.ClientTable["ItemSelected"]) and isvector(AAS.ClientTable["ItemSelected"].pos) then 
                slider.Slider:SetValue(AAS.ClientTable["ItemSelected"].pos[i])
            end 
        elseif name == "rotate" then
            slider.Slider:SetMin(-360)
            slider.Slider:SetMax(360)
            slider.Slider:SetValue(0)

            if istable(AAS.ClientTable["ItemSelected"]) and isangle(AAS.ClientTable["ItemSelected"].ang) then 
                slider.Slider:SetValue(AAS.ClientTable["ItemSelected"].ang[i])
            end
        end 

        if name == "scale" then 
            local scaleVector = AASClientSide:GetManipulateBoneScale(1)
            local scaleTbl = {
                [1] = scaleVector.x,
                [2] = scaleVector.y,
                [3] = scaleVector.z
            }
            
            slider.Slider:SetMin(-5)
            slider.Slider:SetMax(5)
            slider.Slider:SetValue(scaleTbl[i])

            if istable(AAS.ClientTable["ItemSelected"]) and isvector(AAS.ClientTable["ItemSelected"].scale) then 
                slider.Slider:SetValue(AAS.ClientTable["ItemSelected"].scale[i])
            end

            slider:SetAccurateNumber(0.002)
        end
        
        AAS.ClientTable["AdminPos"][i] = AAS.ClientTable["AdminPos"][i] or {}
        AAS.ClientTable["AdminPos"][i][name] = slider.Slider:GetValue()
        
        slider.Slider.OnValueChanged = function()
            AAS.ClientTable["AdminPos"][i][name] = slider.Slider:GetValue()
        end
    end 
end

local curentPosx, curentPosY, curentFov = 0, 0, 0
function AAS.PositionSettings(edit)
    if not AAS.AdminRank[AAS.LocalPlayer:GetUserGroup()] then return end

    lerpBack = false

    AAS.ClientTable["AdminPos"] = {}
    if not edit then AAS.ClientTable["ItemSelected"] = nil end 

    for k,v in ipairs(AAS.Category["mainMenu"]) do
        if v.all then continue end

        if istable(AAS.ClientTable["ItemSelected"]) and v.uniqueName == AAS.ClientTable["ItemSelected"].category then
            boneName = v.bone
        end
    end
    AAS.SettingsModel()

    if IsValid(accessoriesFrame) then 
        accessoriesFrame:AlphaTo( 100, 0.3, 0, function() 
            if not IsValid(accessoriesFrame) then return end 
            accessoriesFrame:Remove()
        end)
    end 

    if IsValid(mainPanel) then mainPanel:Remove() end
    AAS.ClientTable["Id"] = 1 

    local linearGradient = {
        {offset = 0, color = AAS.Gradient["upColor"]},
        {offset = 0.4, color = AAS.Gradient["midleColor"]},
        {offset = 1, color = AAS.Gradient["downColor"]},
    }

    mainPanel = vgui.Create("DFrame")
    mainPanel:SetSize(AAS.ScrW, AAS.ScrH)
    mainPanel:ShowCloseButton(false)
    mainPanel:SetTitle("")
    mainPanel:MakePopup()
    mainPanel:AlphaTo( 255, 0.3, 0 )
    mainPanel.Paint = function() end
    mainPanel:SetCursor("sizeall")
    mainPanel.OnMousePressed = function(self, mouseCode)
        if mouseCode != MOUSE_LEFT then return end

        self.startMouseX = gui.MouseX()
        self.startMouseY = gui.MouseY()
    end
    mainPanel.OnMouseReleased = function(self, mouseCode)
        if mouseCode != MOUSE_LEFT then return end
        
        self.startMouseX = nil       
        self.startMouseY = nil       
    end

    local lastPosX, lastPosY = 0, 50
    local posMouseX, posMouseY = 0,0

    mainPanel.Think = function(self) 
        if input.IsMouseDown(MOUSE_FIRST) and mainPanel:IsHovered() then 
            local currentMouseX, currentMouseY = input.GetCursorPos()
            local differenceMousePosX = currentMouseX - posMouseX
            local differenceMousePosY = currentMouseY - posMouseY

            curentPosx = lastPosX + differenceMousePosX / AAS.ScrW*10
            curentPosY = math.Clamp(lastPosY + differenceMousePosY,-20,200)
        end 
    end
    function mainPanel:OnMousePressed()
        if mainPanel:IsHovered() then
            posMouseX, posMouseY = input.GetCursorPos()
        end
    end
    function mainPanel:OnMouseReleased()
        lastPosX = curentPosx
        lastPosY = curentPosY
    end
    function mainPanel:OnMouseWheeled(keycode)    
        if keycode == 1 and curentFov < 150 then curentFov = curentFov + 6 end
        if keycode == -1 and curentFov > -20 then curentFov = curentFov - 6 end
    end

    local leftPanel = vgui.Create("DPanel", mainPanel)
    leftPanel:SetSize(AAS.ScrW*0.038, AAS.ScrH*0.5)
    leftPanel:SetPos(0, AAS.ScrH/2 - AAS.ScrH*0.25)
    leftPanel.Paint = function(self,w,h)
        local x, y = leftPanel:GetPos()

        draw.RoundedBoxEx(8, 0, 0, w, h*0.95, AAS.Colors["background"], false, true, false, false)
        AAS.LinearGradient(0, y*1.1, w, h*0.91, linearGradient, false)
        
        draw.RoundedBoxEx(8, 0, h*0.95, w, h*0.05, AAS.Gradient["downColor"], false, false, false, true)
        draw.RoundedBoxEx(8, 0, 0, w, h*0.05, AAS.Gradient["upColor"], false, true, false, false)
    end 

    local LerpPos = 0
    local categoryList = vgui.Create("DScrollPanel", leftPanel)
    categoryList:SetSize(AAS.ScrW*0.038, AAS.ScrH*0.5)
    categoryList:SetPos(0, AAS.ScrH*0.06)
    categoryList.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, LerpPos, AAS.ScrW*0.038, AAS.ScrH*0.038, AAS.Colors["selectedBlue"])
        draw.RoundedBox(0, AAS.ScrW*0.038 - AAS.ScrW*0.0017, LerpPos, AAS.ScrW*0.002, AAS.ScrH*0.038, AAS.Colors["white200"])
    end

    for k,v in ipairs(AAS.Category["positionMenu"]) do 
        local categoryButton = vgui.Create("DButton", categoryList)
        categoryButton:SetSize(0, AAS.ScrH*0.038)
        categoryButton:Dock(TOP)
        categoryButton:SetText("")
        categoryButton:DockMargin(0,0,0,AAS.ScrH*0.006)
        categoryButton.Paint = function(self,w,h)
            surface.SetDrawColor(AAS.Colors["white"])
            surface.SetMaterial(v.material, "smooth")
            surface.DrawTexturedRect((w/2)-(AAS.ScrW*v.sizeX/2), h/2-(AAS.ScrH*v.sizeY/2), AAS.ScrW*v.sizeX, AAS.ScrH*v.sizeY)

            LerpPos = Lerp(FrameTime()*5, LerpPos, (AAS.ScrH*0.038 + AAS.ScrH*0.006)*(AAS.ClientTable["Id"] - 1))
        end 
        categoryButton.DoClick = function()
            AAS.ClientTable["Id"] = k 
        end 
    end 

    local settingsButton = vgui.Create("DButton", leftPanel)
    settingsButton:SetSize(AAS.ScrH*0.0277, AAS.ScrH*0.0277)
    settingsButton:SetPos(AAS.ScrW*0.0384/2 - AAS.ScrH*0.0277/2, leftPanel:GetTall()*0.92)
    settingsButton:SetText("")
    settingsButton.Paint = function(self,w,h)
        surface.SetDrawColor(AAS.Colors["white"])
        surface.SetMaterial(AAS.Materials["settings"])
        surface.DrawTexturedRect( 0, 0, w, h )
    end  
    settingsButton.DoClick = function()
        if IsValid(mainPanel) then
            lerpBack = true
            calcPosE, calcAngE, calcPos, calcAng = AAS.LocalPlayer:EyePos(), AAS.LocalPlayer:GetAngles(), ((AAS.LocalPlayer:GetPos() - (AAS.LocalPlayer:GetAngles():Forward() * -100) + AAS.LocalPlayer:GetAngles():Up() * 100)), (AAS.LocalPlayer:GetAngles() + Angle(0, -180, 0))
            
            mainPanel:AlphaTo( 100, 1, 0, function() 
                if not IsValid(mainPanel) then return end 
                mainPanel:Remove()

                if #AAS.ClientTable["ItemsTable"] == 0 then
                    AAS.ItemMenu()
                else
                    AAS.AdminSetting()
                end
            end)
        end 
    end 

    local rightPanel = vgui.Create("DPanel", mainPanel)
    rightPanel:SetSize(AAS.ScrW*0.205, AAS.ScrH*0.5)
    rightPanel:SetPos(AAS.ScrW - rightPanel:GetWide(), AAS.ScrH/2 - AAS.ScrH*0.25)
    rightPanel.Paint = function(self,w,h) 
        local x, y = rightPanel:GetPos()

        draw.RoundedBoxEx(8, 0, 0, w, h*0.95, AAS.Colors["background"], true, false, false, false)
        AAS.LinearGradient(x, y*1.1, w, h*0.91, linearGradient, false)
        
        draw.RoundedBoxEx(8, 0, h*0.95, w, h*0.05, AAS.Gradient["downColor"], false, false, true, true)
        draw.RoundedBoxEx(8, 0, 0, w, h*0.05, AAS.Gradient["upColor"], true, false, true, false)
    end 
    
    AAS.settingsScroll(rightPanel, AAS.ScrH*0.06, AAS.ScrH*0.435, edit, AAS.GetSentence("additem"), false)

    local topPanel = vgui.Create("DPanel", mainPanel)
    topPanel:SetSize(AAS.ScrW, AAS.ScrH*0.04)
    topPanel:SetPos(0,0)
    topPanel.Paint = function(self,w,h)
        draw.RoundedBoxEx(0, 0, 0, w, h, AAS.Colors["black18"])

        surface.SetDrawColor(AAS.Colors["white"])
        surface.SetMaterial(AAS.Materials["scale"])
        surface.DrawTexturedRect( w*0.01, h/2-10, 20, 20 )
    end

    sliderMove(AAS.ScrW*0.13, AAS.ScrH*0.82, mainPanel, AAS.GetSentence("position"), "pos")
    sliderMove(AAS.ScrW*0.34, AAS.ScrH*0.82, mainPanel, AAS.GetSentence("rotation"), "rotate")
    sliderMove(AAS.ScrW*0.55, AAS.ScrH*0.82, mainPanel, AAS.GetSentence("scale"), "scale")

    local closeButton = vgui.Create("DButton", mainPanel)
    closeButton:SetSize(AAS.ScrW*0.011, AAS.ScrW*0.011)
    closeButton:SetPos(mainPanel:GetWide()*0.98, AAS.ScrH*0.04/2-closeButton:GetTall()/2) 
    closeButton:SetText("")
    closeButton.Paint = function(self,w,h)
        surface.SetDrawColor(AAS.Colors["white"])
        surface.SetMaterial(AAS.Materials["close"])
        surface.DrawTexturedRect( 0, 0, w, h )
    end  
    closeButton.DoClick = function()
        lerpBack = true
        calcPosE, calcAngE, calcPos, calcAng = AAS.LocalPlayer:EyePos(), AAS.LocalPlayer:GetAngles(), ((AAS.LocalPlayer:GetPos() - (AAS.LocalPlayer:GetAngles():Forward() * -100) + AAS.LocalPlayer:GetAngles():Up() * 100)), (AAS.LocalPlayer:GetAngles() + Angle(0, -180, 0))

        if IsValid(mainPanel) then
            mainPanel:AlphaTo( 100, 1, 0, function() 
                if not IsValid(mainPanel) then return end 
                mainPanel:Remove()

                if #AAS.ClientTable["ItemsTable"] == 0 then
                    AAS.ItemMenu()
                else
                    AAS.AdminSetting()
                end
            end)
        end 
    end 
end

function AAS.SettingsModel()
    if not AAS.AdminRank[AAS.LocalPlayer:GetUserGroup()] then return end

    if IsValid(AASClientSide) then AASClientSide:Remove() end 

    AASClientSide = ClientsideModel( "models/props_c17/oildrum001_explosive.mdl" )
	AASClientSide:SetPos(AAS.LocalPlayer:LocalToWorld(Vector(0,0,0)))
    if isnumber(tonumber(skinList:GetValue())) then
        AASClientSide:SetSkin(tonumber(skinList:GetValue()))
    end
	AASClientSide:Spawn()

    calcPos, calcAng, calcPosE, calcAngE = AAS.LocalPlayer:EyePos(), AAS.LocalPlayer:GetAngles(), ((AAS.LocalPlayer:GetPos() - (AAS.LocalPlayer:GetAngles():Forward() * -100) + AAS.LocalPlayer:GetAngles():Up() * 100)), (AAS.LocalPlayer:GetAngles() + Angle(0, -180, 0))

    timer.Create("AAS:updateClientSideModel", 0, 0, function()
        if not IsValid(mainPanel) then AASClientSide:Remove() timer.Remove("AAS:updateClientSideModel") return end 
        if not IsValid(AASClientSide) then timer.Remove("AAS:updateClientSideModel") return end

        local BonePos, BoneAngles
        if isnumber(AAS.LocalPlayer:LookupBone(boneName)) then
            BonePos, BoneAngles = AAS.LocalPlayer:GetBonePosition(AAS.LocalPlayer:LookupBone(boneName))
        else
            BonePos, BoneAngles = Vector(0,0,0), Angle(0,0,0)
        end

        local newpos = AAS.ConvertVector(BonePos, getItemSettings("pos"), BoneAngles)
		local newang = AAS.ConvertAngle(BoneAngles, getItemSettings("rotate"))

        if isnumber(tonumber(skinList:GetValue())) then
            AASClientSide:SetSkin(tonumber(skinList:GetValue()))
        end
        AASClientSide:SetPos(newpos)
        AASClientSide:SetRenderOrigin(newpos)
		AASClientSide:SetRenderAngles(newang)
        AASClientSide:SetAngles(newang)
        AASClientSide:FollowBone(AAS.LocalPlayer, 6)
        AASClientSide:SetModel((itemModel:GetText() or "models/props_c17/oildrum001_explosive.mdl"))
        AASClientSide:SetPredictable(true)
        AASClientSide:SetColor(clientSideModelColor)

        local mat = Matrix()
        mat:Scale(getItemSettings("scale"))
        AASClientSide:EnableMatrix("RenderMultiply", mat)
    end)
end

hook.Add( "CalcView", "AAS:CalcView:Settings", function( ply, pos, angles, fov )
    if not IsValid(mainPanel) then return end

    local BonePos, BoneAngles
    if isnumber(AAS.LocalPlayer:LookupBone(boneName)) then
        BonePos, BoneAngles = AAS.LocalPlayer:GetBonePosition(AAS.LocalPlayer:LookupBone(boneName))
    else
        BonePos, BoneAngles = Vector(0,0,0), Angle(0,0,0)
    end

    if not lerpBack then
        calcPos = LerpVector(FrameTime()*5, calcPos, BonePos + Vector(math.cos(curentPosx)*(200 -curentFov),math.sin(curentPosx)*(200 -curentFov),curentPosY))
        calcAng = (pos - calcPos):Angle()
    else
        calcPos = LerpVector(FrameTime()*3, calcPos, calcPosE)
        calcAng = LerpAngle(FrameTime()*3, calcAng, calcAngE)
    end

	local view = {
		origin = calcPos,
		angles = calcAng,
		fov = fov,
		drawviewer = true,
	}

	return view
end)