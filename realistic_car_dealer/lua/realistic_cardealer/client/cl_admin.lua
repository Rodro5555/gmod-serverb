local scrollVehicles, scrollGroups, groupMenu, vehicleMenu, npcMenu, adminMenu

local function reloadVehicles()
    if not IsValid(scrollVehicles) then return end
    scrollVehicles:Clear()
    
    for k,v in pairs(RCD.GetVehicles()) do
        if not istable(v) then continue end
        
        local vehicleButton = vgui.Create("DButton", scrollVehicles)
        vehicleButton:SetSize(0, RCD.ScrH*0.037)
        vehicleButton:Dock(TOP)
        vehicleButton:DockMargin(0, 0, 0, RCD.ScrH*0.005)
        vehicleButton:SetText("")
        vehicleButton.Paint = function(self,w,h)
            draw.RoundedBox(0, 0, 0, w, h, RCD.Colors["white5"])
        end
        
        local vehicleName = vgui.Create("DLabel", vehicleButton)
        vehicleName:SetSize(RCD.ScrW*0.19, RCD.ScrH*0.037)
        vehicleName:SetPos(RCD.ScrW*0.008, 0)
        vehicleName:SetTextColor(RCD.Colors["white100"])
        vehicleName:SetFont("RCD:Font:13")
        vehicleName.Think = function(self)
            local groupName = RCD.VehicleGroupGetName(v.groupId) or RCD.GetSentence("undefined")
            
            self:SetText("("..v.id..") ".."["..groupName.."] "..(v.name or "nil"))
        end
        
        local editButton = vgui.Create("RCD:SlideButton", vehicleButton)
        editButton:SetSize(RCD.ScrH*0.032, RCD.ScrH*0.032)
        editButton:SetPos(RCD.ScrW*0.2053, RCD.ScrH*0.0033)
        editButton:SetText("")
        editButton.MinMaxLerp = {5, 7}
        editButton:SetIconMaterial(nil)
        editButton:SetButtonColor(RCD.Colors["white5"])
        editButton.PaintOver = function(self,w,h)
            surface.SetDrawColor(RCD.Colors["white100"])
            surface.SetMaterial(RCD.Materials["icon_edit"])
            surface.DrawTexturedRect(w/2-((w/2)/2), h/2-((h/2)/2), w/2, h/2)
        end
        editButton.DoClick = function()
            RCD.CreateVehicle(v)
            if IsValid(adminMenu) then adminMenu:Remove() end
        end
        
        local removeButton = vgui.Create("RCD:SlideButton", vehicleButton)
        removeButton:SetSize(RCD.ScrH*0.032, RCD.ScrH*0.032)
        removeButton:SetPos(RCD.ScrW*0.2253, RCD.ScrH*0.0033)
        removeButton:SetText("")
        removeButton.MinMaxLerp = {60, 120}
        removeButton:SetIconMaterial(nil)
        removeButton:SetButtonColor(RCD.Colors["purple120"])
        removeButton.PaintOver = function(self,w,h)
            surface.SetDrawColor(RCD.Colors["white100"])
            surface.SetMaterial(RCD.Materials["icon_delete"])
            surface.DrawTexturedRect(w/2-((w/2)/2), h/2-((h/2)/2), w/2, h/2)
        end
        removeButton.DoClick = function()
            local vehicleId = tonumber(v.id)
            if not isnumber(vehicleId) then return end
            
            net.Start("RCD:Admin:Configuration")
                net.WriteUInt(4, 4)
                net.WriteUInt(vehicleId, 32)
            net.SendToServer()
            
            removePanel = vehicleButton
        end 
    end
end

local function reloadGroups()
    if not IsValid(scrollGroups) then return end
    scrollGroups:Clear()
    
    for k,v in pairs(RCD.GetAllVehicleGroups()) do
        local groupButton = vgui.Create("DButton", scrollGroups)
        groupButton:SetSize(0, RCD.ScrH*0.037)
        groupButton:Dock(TOP)
        groupButton:DockMargin(0, 0, 0, RCD.ScrH*0.005)
        groupButton:SetText("")
        groupButton.Paint = function(self,w,h)
            draw.RoundedBox(0, 0, 0, w, h, RCD.Colors["white5"])
        end
        
        local groupName = vgui.Create("DLabel", groupButton)
        groupName:SetSize(RCD.ScrW*0.19, RCD.ScrH*0.037)
        groupName:SetPos(RCD.ScrW*0.008, 0)
        groupName:SetText(v.name or "nil")
        groupName:SetTextColor(RCD.Colors["white100"])
        groupName:SetFont("RCD:Font:13")

        local editButton = vgui.Create("RCD:SlideButton", groupButton)
        editButton:SetSize(RCD.ScrH*0.032, RCD.ScrH*0.032)
        editButton:SetPos(RCD.ScrW*0.204, RCD.ScrH*0.0033)
        editButton:SetText("")
        editButton.MinMaxLerp = {5, 7}
        editButton:SetIconMaterial(nil)
        editButton:SetButtonColor(RCD.Colors["white5"])
        editButton.PaintOver = function(self,w,h)
            surface.SetDrawColor(RCD.Colors["white100"])
            surface.SetMaterial(RCD.Materials["icon_edit"])
            surface.DrawTexturedRect(w/2-((w/2)/2), h/2-((h/2)/2), w/2, h/2)
        end
        editButton.DoClick = function()
            RCD.CreateGroup(v)
        end

        local removeButton = vgui.Create("RCD:SlideButton", groupButton)
        removeButton:SetSize(RCD.ScrH*0.032, RCD.ScrH*0.032)
        removeButton:SetPos(RCD.ScrW*0.22375, RCD.ScrH*0.0033)
        removeButton:SetText("")
        removeButton.MinMaxLerp = {60, 120}
        removeButton:SetIconMaterial(nil)
        removeButton:SetButtonColor(RCD.Colors["purple120"])
        removeButton.PaintOver = function(self,w,h)
            surface.SetDrawColor(RCD.Colors["white100"])
            surface.SetMaterial(RCD.Materials["icon_delete"])
            surface.DrawTexturedRect(w/2-((w/2)/2), h/2-((h/2)/2), w/2, h/2)
        end
        removeButton.DoClick = function()
            removePanel = groupButton

            net.Start("RCD:Admin:Configuration")
                net.WriteUInt(2, 4)
                net.WriteUInt(v.id, 32)
            net.SendToServer()
        end
    end
end

function RCD.AdminMenu()
    if IsValid(adminMenu) then adminMenu:Remove() end

    adminMenu = vgui.Create("DFrame")
    adminMenu:SetSize(RCD.ScrW*0.503, RCD.ScrH*0.603)
    adminMenu:SetDraggable(false)
    adminMenu:MakePopup()
    adminMenu:SetTitle("")
    adminMenu:ShowCloseButton(false)
    adminMenu:Center()
    adminMenu.Paint = function(self,w,h)
        RCD.DrawBlur(self, 10) 

        draw.RoundedBox(0, 0, 0, w, h, RCD.Colors["blackpurple"])
        draw.RoundedBox(0, w/2-RCD.ScrW*0.49/2, h*0.02, RCD.ScrW*0.49, RCD.ScrH*0.062, RCD.Colors["white20"])

        draw.RoundedBox(0, w/2-RCD.ScrW*0.49/2, h*0.13, RCD.ScrW*0.243, RCD.ScrH*0.045, RCD.Colors["white20"])
        draw.RoundedBox(0, RCD.ScrW*0.2515, h*0.13, RCD.ScrW*0.245, RCD.ScrH*0.045, RCD.Colors["white20"])
        
        draw.DrawText(RCD.GetSentence("adminMenuConfig"), "RCD:Font:10", w*0.025, h*0.02, RCD.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(RCD.GetSentence("configureGroupsVehicles"), "RCD:Font:11", w*0.025, h*0.07, RCD.Colors["white100"], TEXT_ALIGN_LEFT)

        draw.DrawText(RCD.GetSentence("groups"), "RCD:Font:18", w*0.25, h*0.145, RCD.Colors["white"], TEXT_ALIGN_CENTER)
        draw.DrawText(RCD.GetSentence("vehicles"), "RCD:Font:18", w*0.75, h*0.145, RCD.Colors["white"], TEXT_ALIGN_CENTER)
    end

    scrollGroups = vgui.Create("RCD:DScroll", adminMenu)
    scrollGroups:SetSize(adminMenu:GetWide()/2.07, RCD.ScrH*0.417)
    scrollGroups:SetPos(RCD.ScrW*0.0065, RCD.ScrH*0.1285)

    reloadGroups()

    scrollVehicles = vgui.Create("RCD:DScroll", adminMenu)
    scrollVehicles:SetSize(adminMenu:GetWide()/2.055, RCD.ScrH*0.417)
    scrollVehicles:SetPos(adminMenu:GetWide()/2, RCD.ScrH*0.1285)

    reloadVehicles()

    local createGroup = vgui.Create("RCD:SlideButton", adminMenu)
    createGroup:SetSize(adminMenu:GetWide()/2.072, RCD.ScrH*0.041)
    createGroup:SetPos(RCD.ScrW*0.0065, RCD.ScrH*0.552)
    createGroup:SetText(RCD.GetSentence("createGroup"))
    createGroup:SetFont("RCD:Font:12")
    createGroup:SetTextColor(RCD.Colors["white"])
    createGroup:InclineButton(0)
    createGroup:SetIconMaterial(nil)
    createGroup.MinMaxLerp = {100, 200}
    createGroup:SetIconMaterial(nil)
    createGroup:SetButtonColor(RCD.Colors["purple"])
    createGroup.DoClick = function()
        RCD.CreateGroup()
        if IsValid(adminMenu) then adminMenu:Remove() end
    end

    local createVehicle = vgui.Create("RCD:SlideButton", adminMenu)
    createVehicle:SetSize(adminMenu:GetWide()/2.055, RCD.ScrH*0.041)
    createVehicle:SetPos(adminMenu:GetWide()/2, RCD.ScrH*0.552)
    createVehicle:SetText(RCD.GetSentence("createVehicle"))
    createVehicle:SetFont("RCD:Font:12")
    createVehicle:SetTextColor(RCD.Colors["white"])
    createVehicle:InclineButton(0)
    createVehicle.MinMaxLerp = {100, 200}
    createVehicle:SetIconMaterial(nil)
    createVehicle:SetButtonColor(RCD.Colors["purple"])
    createVehicle.DoClick = function()
        RCD.CreateVehicle()
        if IsValid(adminMenu) then adminMenu:Remove() end
    end

    local closeLerp = 50
    local close = vgui.Create("DButton", adminMenu)
    close:SetSize(RCD.ScrH*0.026, RCD.ScrH*0.026)
    close:SetPos(adminMenu:GetWide()*0.94, RCD.ScrH*0.03)
    close:SetText("")
    close.Paint = function(self,w,h)
        closeLerp = Lerp(FrameTime()*5, closeLerp, (close:IsHovered() and 50 or 100))

        surface.SetDrawColor(ColorAlpha(RCD.Colors["white100"], closeLerp))
        surface.SetMaterial(RCD.Materials["icon_close"])
        surface.DrawTexturedRect(0, 0, w, h)
    end
    close.DoClick = function()
        adminMenu:Remove()
    end
end

function RCD.NPCMenu(npcId, infoTable)
    if IsValid(npcMenu) then npcMenu:Remove() end

    RCD.npcInformation = {
        ["name"] = "",
        ["model"] = "",
        ["class"] = "",
        ["plateforms"] = {},
        ["groups"] = {},
    }

    local plateformsCount = 0
    if infoTable then
        local plateformsTable = infoTable["plateforms"] or {}

        plateformsCount = #plateformsTable
        RCD.npcInformation["plateforms"] = plateformsTable
    end

    npcMenu = vgui.Create("DFrame")
    npcMenu:SetSize(RCD.ScrW*0.27, RCD.ScrH*0.9)
    npcMenu:SetDraggable(false)
    npcMenu:MakePopup()
    npcMenu:SetTitle("")
    npcMenu:ShowCloseButton(false)
    npcMenu:Center()
    npcMenu.Paint = function(self,w,h)
        RCD.DrawBlur(self, 10) 

        draw.RoundedBox(0, 0, 0, w, h, RCD.Colors["blackpurple"])
        draw.RoundedBox(0, w/2-RCD.ScrW*0.258/2, h*0.013, RCD.ScrW*0.2585, RCD.ScrH*0.062, RCD.Colors["white20"])
        
        draw.DrawText(RCD.GetSentence("dealerConfiguration"), "RCD:Font:10", w*0.045, h*0.013, RCD.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(RCD.GetSentence("configureGroupsVehicles"), "RCD:Font:11", w*0.045, h*0.045, RCD.Colors["white100"], TEXT_ALIGN_LEFT)
    end

    local npcSettings = vgui.Create("RCD:DScroll", npcMenu)
    npcSettings:SetPos(RCD.ScrW*0.0055, RCD.ScrH*0.078)
    npcSettings:SetSize(RCD.ScrW*0.259, RCD.ScrH*0.8)

    local entryName = vgui.Create("RCD:TextEntry", npcSettings)
    entryName:SetSize(0, RCD.ScrH*0.048)
    entryName:Dock(TOP)
    entryName:DockMargin(0, 0, 0, RCD.ScrH*0.005)
    entryName:SetPlaceHolder(RCD.GetSentence("enterDealerName"))
    if infoTable && isstring(infoTable["name"]) then
        entryName:SetText(infoTable["name"])
    end

    local entryModel = vgui.Create("RCD:TextEntry", npcSettings)
    entryModel:SetSize(0, RCD.ScrH*0.048)
    entryModel:Dock(TOP)
    entryModel:DockMargin(0, 0, 0, RCD.ScrH*0.005)
    entryModel:SetPlaceHolder("models/breen.mdl")
    if infoTable && isstring(infoTable["model"]) then
        entryModel:SetText(infoTable["model"])
    end

    local tableCount = math.Clamp(table.Count(RCD.AdvancedConfiguration["groupsList"]), 0, 8)

    local sizeY = RCD.ScrH*0.05 + tableCount*RCD.ScrH*0.037 + tableCount*RCD.ScrH*0.0039
    
    local groupsConfig = vgui.Create("DPanel", npcSettings)
    groupsConfig:SetSize(0, sizeY)
    groupsConfig:Dock(TOP)
    groupsConfig.Paint = function(self,w,h) 
        draw.RoundedBox(0, 0, 0, w, h, RCD.Colors["white2"])
    end
    groupsConfig:SizeTo(-1, sizeY, 0.5)
    
    local fakeButton = vgui.Create("DButton", groupsConfig)
    fakeButton:SetSize(RCD.ScrW*0.26, RCD.ScrH*0.05)
    fakeButton:SetText("")
    fakeButton.Deploy = true
    fakeButton.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, 0, w, h, RCD.Colors["white20"])
        draw.DrawText(RCD.GetSentence("groupsConfig"), "RCD:Font:18", w*0.02, RCD.ScrH*0.012, RCD.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText("▼", "RCD:Font:17", w*0.925, RCD.ScrH*0.0145, RCD.Colors["grey30"], TEXT_ALIGN_LEFT)
    end

    fakeButton.DoClick = function()
        fakeButton.Deploy = !fakeButton.Deploy

        groupsConfig:SizeTo(-1, fakeButton.Deploy and sizeY or RCD.ScrH*0.05, 0.5)
    end

    local scrollGroup = vgui.Create("RCD:DScroll", groupsConfig)
    scrollGroup:SetPos(0, RCD.ScrH*0.054)
    scrollGroup:SetSize(RCD.ScrW*0.26, sizeY - RCD.ScrH*0.05)
    
    for k,v in pairs(RCD.GetAllVehicleGroups()) do
        local groupButton = vgui.Create("DButton", scrollGroup)
        groupButton:SetSize(0, RCD.ScrH*0.037)
        groupButton:Dock(TOP)
        groupButton:DockMargin(0, 0, 0, RCD.ScrH*0.005)
        groupButton:SetText("")
        groupButton.Paint = function(self,w,h)
            draw.RoundedBox(0, 0, 0, w, h, RCD.Colors["white2"])
            draw.SimpleText(v.name, "RCD:Font:13", w*0.025, h*0.45, RCD.Colors["white100"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        
        local checkBox = vgui.Create("RCD:CheckBox", groupButton)
        checkBox:SetSize(RCD.ScrH*0.023, RCD.ScrH*0.023)
        checkBox:SetPos(RCD.ScrW*0.24, groupButton:GetTall()/2 - checkBox:GetTall()/2)
        checkBox.OnChange = function()
            local active = checkBox:GetActive()

            RCD.npcInformation["groups"][k] = active
        end
        
        groupButton.DoClick = function()
            local active = checkBox:GetActive()
            
            checkBox:SetActive(!active)
            RCD.npcInformation["groups"][k] = !active
        end

        if infoTable then
            local groupsTable = infoTable["groups"] or {}

            if groupsTable[k] then
                checkBox:SetActive(true)
                RCD.npcInformation["groups"][k] = true
            end
        end
    end

    local newPlateform = vgui.Create("RCD:SlideButton", npcSettings)
    newPlateform:SetSize(0, RCD.ScrH*0.041)
    newPlateform:DockMargin(0, RCD.ScrH*0.005, 0, 0)
    newPlateform:Dock(TOP)
    newPlateform:SetText(RCD.GetSentence("newPlateforms"))
    newPlateform:SetFont("RCD:Font:12")
    newPlateform:SetTextColor(RCD.Colors["white"])
    newPlateform:InclineButton(0)
    newPlateform.MinMaxLerp = {100, 200}
    newPlateform:SetIconMaterial(nil)
    newPlateform:SetButtonColor(RCD.Colors["purple"])
    newPlateform.DoClick = function()
        net.Start("RCD:Admin:Configuration")
            net.WriteUInt(7, 4)
            net.WriteUInt(npcId, 32)
        net.SendToServer()

        npcMenu:Remove()
    end

    local deletePlateform = vgui.Create("RCD:SlideButton", npcSettings)
    deletePlateform:SetSize(0, RCD.ScrH*0.041)
    deletePlateform:DockMargin(0, RCD.ScrH*0.005, 0, 0)
    deletePlateform:Dock(TOP)
    deletePlateform:SetText(RCD.GetSentence("deletePlateforms").."("..plateformsCount..")")
    deletePlateform:SetFont("RCD:Font:12")
    deletePlateform:SetTextColor(RCD.Colors["white"])
    deletePlateform:InclineButton(0)
    deletePlateform.MinMaxLerp = {100, 200}
    deletePlateform:SetIconMaterial(nil)
    deletePlateform:SetButtonColor(RCD.Colors["grey69"])
    deletePlateform.DoClick = function()
        net.Start("RCD:Admin:Configuration")
            net.WriteUInt(9, 4)
            net.WriteUInt(npcId, 32)
        net.SendToServer()

        npcMenu:Remove()
    end

    local bottomScroll = vgui.Create("RCD:DScroll", npcMenu)
    bottomScroll:SetPos(RCD.ScrW*0.0055, RCD.ScrH*0.7999)
    bottomScroll:SetSize(RCD.ScrW*0.259, RCD.ScrH*0.25)

    local deleteNpc = vgui.Create("RCD:SlideButton", bottomScroll)
    deleteNpc:SetSize(0, RCD.ScrH*0.041)
    deleteNpc:DockMargin(0, RCD.ScrH*0.005, 0, 0)
    deleteNpc:Dock(TOP)
    deleteNpc:SetText(RCD.GetSentence("deleteNPC"))
    deleteNpc:SetFont("RCD:Font:12")
    deleteNpc:SetTextColor(RCD.Colors["white"])
    deleteNpc:InclineButton(0)
    deleteNpc.MinMaxLerp = {100, 200}
    deleteNpc:SetIconMaterial(nil)
    deleteNpc:SetButtonColor(RCD.Colors["grey69"])

    deleteNpc.DoClick = function()
        net.Start("RCD:Admin:Configuration")
            net.WriteUInt(6, 4)
            net.WriteUInt(npcId, 32)
        net.SendToServer()

        npcMenu:Remove()
    end

    local saveNpc = vgui.Create("RCD:SlideButton", bottomScroll)
    saveNpc:SetSize(0, RCD.ScrH*0.041)
    saveNpc:DockMargin(0, RCD.ScrH*0.005, 0, 0)
    saveNpc:Dock(TOP)
    saveNpc:SetText(RCD.GetSentence("saveInformations"))
    saveNpc:SetFont("RCD:Font:12")
    saveNpc:SetTextColor(RCD.Colors["white"])
    saveNpc:InclineButton(0)
    saveNpc.MinMaxLerp = {100, 200}
    saveNpc:SetIconMaterial(nil)
    saveNpc:SetButtonColor(RCD.Colors["purple"])
    saveNpc.DoClick = function()
        RCD.npcInformation["name"] = entryName:GetText()
        RCD.npcInformation["model"] = entryModel:GetText()

        net.Start("RCD:Admin:Configuration")
            net.WriteUInt(5, 4)
            net.WriteUInt(npcId, 32)
            net.WriteString(RCD.npcInformation["name"])
            net.WriteString(RCD.npcInformation["model"])
            net.WriteString(RCD.npcInformation["class"])
            net.WriteUInt(#RCD.npcInformation["plateforms"], 12)
            for k, v in pairs(RCD.npcInformation["plateforms"]) do
                net.WriteVector(v.pos)
                net.WriteAngle(v.ang)
            end
            net.WriteUInt(table.Count(RCD.npcInformation["groups"]), 12)
            for k, v in pairs(RCD.npcInformation["groups"]) do
                net.WriteUInt(k, 32)
                net.WriteBool(v)
            end
        net.SendToServer()

        npcMenu:Remove()
    end
    
    local closeLerp = 50
    local close = vgui.Create("DButton", npcMenu)
    close:SetSize(RCD.ScrH*0.026, RCD.ScrH*0.026)
    close:SetPos(RCD.ScrW*0.241, RCD.ScrH*0.03)
    close:SetText("")
    close.Paint = function(self,w,h)
        closeLerp = Lerp(FrameTime()*5, closeLerp, (close:IsHovered() and 50 or 100))

        surface.SetDrawColor(ColorAlpha(RCD.Colors["white100"], closeLerp))
        surface.SetMaterial(RCD.Materials["icon_close"])
        surface.DrawTexturedRect(0, 0, w, h)
    end
    close.DoClick = function()
        npcMenu:Remove()
    end
end

function RCD.CreateGroup(editTable)
    if IsValid(adminMenu) then adminMenu:Remove() end
    if IsValid(groupMenu) then groupMenu:Remove() end

    local editGroup = istable(editTable)
    
    RCD.groupTable = {
        ["name"] = "",
        ["jobAccess"] = {},
        ["rankAccess"] = {},
    }

    groupMenu = vgui.Create("DFrame")
    groupMenu:SetSize(RCD.ScrW*0.503, RCD.ScrH*0.603)
    groupMenu:SetDraggable(false)
    groupMenu:MakePopup()
    groupMenu:SetTitle("")
    groupMenu:ShowCloseButton(false)
    groupMenu:Center()
    groupMenu.Paint = function(self,w,h)
        RCD.DrawBlur(self, 10)

        draw.RoundedBox(0, 0, 0, w, h, RCD.Colors["blackpurple"])
        draw.RoundedBox(0, w/2-RCD.ScrW*0.49/2, h*0.02, self:GetWide()*0.978, RCD.ScrH*0.062, RCD.Colors["white20"])

        draw.RoundedBox(0, w/2-RCD.ScrW*0.49/2, h*0.215, RCD.ScrW*0.243, RCD.ScrH*0.045, RCD.Colors["white20"])
        draw.RoundedBox(0, RCD.ScrW*0.2515, h*0.215, RCD.ScrW*0.245, RCD.ScrH*0.045, RCD.Colors["white20"])
        
        draw.DrawText(RCD.GetSentence("adminMenuConfig"), "RCD:Font:10", w*0.025, h*0.02, RCD.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(RCD.GetSentence("configureGroups"), "RCD:Font:11", w*0.025, h*0.07, RCD.Colors["white100"], TEXT_ALIGN_LEFT)

        draw.DrawText(RCD.GetSentence("rankAccess"), "RCD:Font:18", w*0.25, h*0.23, RCD.Colors["white"], TEXT_ALIGN_CENTER)
        draw.DrawText(RCD.GetSentence("jobAccess"), "RCD:Font:18", w*0.75, h*0.23, RCD.Colors["white"], TEXT_ALIGN_CENTER)
    end

    local entryName = vgui.Create("RCD:TextEntry", groupMenu)
    entryName:SetSize(groupMenu:GetWide()-RCD.ScrW*0.0062*2, RCD.ScrH*0.046)
    entryName:SetPos(RCD.ScrW*0.0065, RCD.ScrH*0.0785)
    entryName:SetPlaceHolder(RCD.GetSentence("enterGroupName"))
    entryName.OnChange = function()
        RCD.groupTable["name"] = entryName:GetText()
    end
    if editGroup then 
        local groupName = editTable["name"]
        entryName:SetText(groupName)

        RCD.groupTable["name"] = groupName
        RCD.groupTable["id"] = editTable["id"]
    end

    local scrollRanks = vgui.Create("RCD:DScroll", groupMenu)
    scrollRanks:SetSize(groupMenu:GetWide()/2.07, RCD.ScrH*0.365)
    scrollRanks:SetPos(RCD.ScrW*0.0065, RCD.ScrH*0.179)

    local userTable = CAMI and CAMI.GetUsergroups() or {}
    for k,v in pairs(userTable) do
        local ranksButton = vgui.Create("DButton", scrollRanks)
        ranksButton:SetSize(0, RCD.ScrH*0.037)
        ranksButton:Dock(TOP)
        ranksButton:DockMargin(0, 0, 0, RCD.ScrH*0.005)
        ranksButton:SetText("")
        ranksButton.Paint = function(self,w,h)
            draw.RoundedBox(0, 0, 0, w, h, RCD.Colors["white5"])
            draw.SimpleText(k, "RCD:Font:13", w*0.035, h*0.45, RCD.Colors["white100"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        
        local checkBox = vgui.Create("RCD:CheckBox", ranksButton)
        checkBox:SetSize(RCD.ScrH*0.023, RCD.ScrH*0.023)
        checkBox:SetPos(RCD.ScrW*0.225, ranksButton:GetTall()/2 - checkBox:GetTall()/2)
        if editGroup && editTable["rankAccess"][k] then
            checkBox:SetActive(true)
            RCD.groupTable["rankAccess"][k] = true
        end

        checkBox.OnChange = function()
            local active = checkBox:GetActive()

            RCD.groupTable["rankAccess"][k] = active and true or nil
        end

        ranksButton.DoClick = function()
            local active = checkBox:GetActive()

            checkBox:SetActive(!active)
            RCD.groupTable["rankAccess"][k] = !active and true or nil
        end
    end

    local scrollJobs = vgui.Create("RCD:DScroll", groupMenu)
    scrollJobs:SetSize(groupMenu:GetWide()/2.055, RCD.ScrH*0.365)
    scrollJobs:SetPos(groupMenu:GetWide()/2, RCD.ScrH*0.179)

    for k,v in pairs(team.GetAllTeams()) do
        if not v.Joinable then continue end

        local jobsButton = vgui.Create("DButton", scrollJobs)
        jobsButton:SetSize(0, RCD.ScrH*0.037)
        jobsButton:Dock(TOP)
        jobsButton:DockMargin(0, 0, 0, RCD.ScrH*0.005)
        jobsButton:SetText("")
        jobsButton.Paint = function(self,w,h)
            draw.RoundedBox(0, 0, 0, w, h, RCD.Colors["white5"])
            draw.SimpleText(v.Name, "RCD:Font:13", w*0.035, h*0.5, RCD.Colors["white100"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        local checkBox = vgui.Create("RCD:CheckBox", jobsButton)
        checkBox:SetSize(RCD.ScrH*0.023, RCD.ScrH*0.023)
        checkBox:SetPos(RCD.ScrW*0.225, jobsButton:GetTall()/2 - checkBox:GetTall()/2)
        if editGroup && editTable["jobAccess"][v.Name] then
            checkBox:SetActive(true)
            RCD.groupTable["jobAccess"][v.Name] = true
        end

        checkBox.OnChange = function()
            local active = checkBox:GetActive()

            RCD.groupTable["jobAccess"][v.Name] = active and true or nil
        end

        jobsButton.DoClick = function()
            local active = checkBox:GetActive()

            checkBox:SetActive(!active)
            RCD.groupTable["jobAccess"][v.Name] = !active and true or nil
        end
    end

    local cancel = vgui.Create("RCD:SlideButton", groupMenu)
    cancel:SetSize(groupMenu:GetWide()/2.072, RCD.ScrH*0.041)
    cancel:SetPos(RCD.ScrW*0.0065, RCD.ScrH*0.552)
    cancel:SetText(RCD.GetSentence("cancel"))
    cancel:SetFont("RCD:Font:12")
    cancel:SetTextColor(RCD.Colors["white"])
    cancel:InclineButton(0)
    cancel:SetIconMaterial(nil)
    cancel.MinMaxLerp = {100, 200}
    cancel:SetIconMaterial(nil)
    cancel:SetButtonColor(RCD.Colors["grey69"])
    cancel.DoClick = function()
        RCD.AdminMenu()
        if IsValid(groupMenu) then groupMenu:Remove() end
    end

    local createGroup = vgui.Create("RCD:SlideButton", groupMenu)
    createGroup:SetSize(groupMenu:GetWide()/2.055, RCD.ScrH*0.041)
    createGroup:SetPos(groupMenu:GetWide()/2, RCD.ScrH*0.552)
    createGroup:SetText(RCD.GetSentence("validateCreateGroup"))
    createGroup:SetFont("RCD:Font:12")
    createGroup:SetTextColor(RCD.Colors["white"])
    createGroup:InclineButton(0)
    createGroup.MinMaxLerp = {100, 200}
    createGroup:SetIconMaterial(nil)
    createGroup:SetButtonColor(RCD.Colors["purple"])
    createGroup.DoClick = function()
        RCD.groupTable["name"] = entryName:GetText()

        net.Start("RCD:Admin:Configuration")
            net.WriteUInt(1, 4)
            net.WriteBool(editGroup)
            net.WriteUInt((RCD.groupTable["id"] or 0), 32)
            net.WriteString(RCD.groupTable["name"])

            net.WriteUInt(table.Count(RCD.groupTable["rankAccess"]), 8)
            for rank, _ in pairs(RCD.groupTable["rankAccess"]) do
                net.WriteString(rank)
            end

            net.WriteUInt(table.Count(RCD.groupTable["jobAccess"]), 8)
            for job, _ in pairs(RCD.groupTable["jobAccess"]) do
                net.WriteString(job)
            end
        net.SendToServer()
    end

    local closeLerp = 50
    local close = vgui.Create("DButton", groupMenu)
    close:SetSize(RCD.ScrH*0.026, RCD.ScrH*0.026)
    close:SetPos(groupMenu:GetWide()*0.94, RCD.ScrH*0.03)
    close:SetText("")
    close.Paint = function(self,w,h)
        closeLerp = Lerp(FrameTime()*5, closeLerp, (close:IsHovered() and 50 or 100))

        surface.SetDrawColor(ColorAlpha(RCD.Colors["white100"], closeLerp))
        surface.SetMaterial(RCD.Materials["icon_close"])
        surface.DrawTexturedRect(0, 0, w, h)
    end
    close.DoClick = function()
        groupMenu:Remove()
    end
end

function RCD.CreateVehicle(editVehicle)    
    if IsValid(adminMenu) then adminMenu:Remove() end
    if IsValid(vehicleMenu) then vehicleMenu:Remove() end

    RCD.vehicleConfig = {}

    vehicleMenu = vgui.Create("DFrame")
    vehicleMenu:SetSize(RCD.ScrW*0.55, RCD.ScrH*0.695)
    vehicleMenu:SetDraggable(false)
    vehicleMenu:MakePopup()
    vehicleMenu:SetTitle("")
    vehicleMenu:ShowCloseButton(false)
    vehicleMenu:Center()
    vehicleMenu.Paint = function(self,w,h)
        RCD.DrawBlur(self, 10)

        draw.RoundedBox(0, 0, 0, w, h, RCD.Colors["blackpurple"])
        draw.RoundedBox(0, w/2-self:GetWide()*0.978/2, h*0.02,self:GetWide()*0.978, RCD.ScrH*0.062,RCD.Colors["white20"])
        
        draw.DrawText(RCD.GetSentence("adminMenuConfig"), "RCD:Font:10", w*0.025, h*0.02, RCD.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(RCD.GetSentence("configureVehicleInformations"), "RCD:Font:11", w*0.025, h*0.06, RCD.Colors["white100"], TEXT_ALIGN_LEFT)
    end

    local scrollInfo = vgui.Create("RCD:DScroll", vehicleMenu)
    scrollInfo:SetSize(vehicleMenu:GetWide()/2.07, RCD.ScrH*0.20)
    scrollInfo:SetPos(RCD.ScrW*0.0065, RCD.ScrH*0.08)
    scrollInfo:GetVBar():SetWide(0)

    local previewVehicle = vgui.Create("DPanel", vehicleMenu)
    previewVehicle:SetSize(vehicleMenu:GetWide()/2.05, RCD.ScrH*0.20)
    previewVehicle:SetPos(vehicleMenu:GetWide()/2, RCD.ScrH*0.08)
    previewVehicle.Paint = function(self,w,h)
        draw.DrawText(RCD.GetSentence("preview"), "RCD:Font:18", w*0.025, h*0.02, RCD.Colors["white"], TEXT_ALIGN_LEFT)
        draw.RoundedBox(0, 0, 0, w, h, RCD.Colors["white5"])
    end

    local vehicleModel = vgui.Create("RCD:DModel", previewVehicle)
    vehicleModel:SetModel("models/airboat.mdl")
    vehicleModel:Dock(FILL)
    vehicleModel:DockMargin(0, 0, RCD.ScrH*0.01, RCD.ScrH*0.01)
    vehicleModel:SetFOV(50)
    vehicleModel.Entity:SetColor(RCD.Colors["white255200"])
    
    if editVehicle && isstring(editVehicle["class"]) && isstring(RCD.VehiclesList[editVehicle["class"]]["Model"]) then
        vehicleModel:SetModel(RCD.VehiclesList[editVehicle["class"]]["Model"])
        
        if editVehicle["options"]["addon"] == "simfphys" then
            RCD.GenerateWheels(vehicleModel.Entity, editVehicle["class"])
        end
    end

    local chooseVehicle = vgui.Create("RCD:DComboBox", scrollInfo)
    chooseVehicle:SetSize(0, RCD.ScrH*0.048)
    chooseVehicle:Dock(TOP)
    chooseVehicle:SetText(RCD.GetSentence("chooseVehicleClass"))
    chooseVehicle:DockMargin(0, 0, 0, RCD.ScrH*0.0045)

    local chooseGroup = vgui.Create("RCD:DComboBox", scrollInfo)
    chooseGroup:SetSize(0, RCD.ScrH*0.048)
    chooseGroup:Dock(TOP)
    chooseGroup:SetText(RCD.GetSentence("chooseVehicleGroup"))
    chooseGroup:DockMargin(0, 0, 0, RCD.ScrH*0.0045)
    for k,v in pairs(RCD.GetAllVehicleGroups()) do 
        chooseGroup:AddChoice(v.name, v.id)
        if editVehicle && isnumber(editVehicle["groupId"]) && editVehicle["groupId"] == v.id then
            chooseGroup:ChooseOption(v.name)

            RCD.vehicleConfig["groupId"] = v.id
        end
    end
    chooseGroup.OnSelect = function(pnl, index, data)
        local optionData = chooseGroup:GetOptionData(index)
       
        RCD.vehicleConfig["groupId"] = optionData
    end

    local entryName = vgui.Create("RCD:TextEntry", scrollInfo)
    entryName:SetSize(0, RCD.ScrH*0.048)
    entryName:Dock(TOP)
    entryName:DockMargin(0, 0, 0, RCD.ScrH*0.0045)
    entryName:SetPlaceHolder(RCD.GetSentence("enterVehicleName"))
    for k,v in pairs(RCD.VehiclesList) do 
        chooseVehicle:AddChoice(v.Name, k)
        
        if editVehicle && isstring(editVehicle["class"]) && editVehicle["class"] == k then
            chooseVehicle:ChooseOption(v.Name)
            entryName:SetText(v.Name)
            RCD.vehicleConfig["class"] = editVehicle["class"]
        end
    end
    
    if editVehicle && isstring(editVehicle["name"]) then
        entryName:SetText(editVehicle["name"])
    end
    
    local entryPrice = vgui.Create("RCD:TextEntry", scrollInfo)
    entryPrice:SetSize(0, RCD.ScrH*0.048)
    entryPrice:Dock(TOP)
    entryPrice:DockMargin(0, 0, 0, RCD.ScrH*0.0045)
    entryPrice:SetPlaceHolder(RCD.GetSentence("enterVehiclePrice"))  
    entryPrice:SetNumeric(true)
    if editVehicle then
        local price = tonumber(editVehicle["price"])
        if isnumber(price) then
            entryPrice:SetText(price)
        end
    end
    
    local scrollConfig = vgui.Create("RCD:DScroll", vehicleMenu)
    scrollConfig:SetSize(vehicleMenu:GetWide()*0.9785, RCD.ScrH*0.3518)
    scrollConfig:SetPos(RCD.ScrW*0.0065, RCD.ScrH*0.285)
    scrollConfig:DockMargin(0, 0, 0, RCD.ScrH*0.006)

    local vehicleView = vgui.Create("RCD:Accordion", scrollConfig)
    vehicleView:SetSize(RCD.ScrW*0.538, RCD.ScrH*0.03)
    vehicleView:Dock(TOP)
    vehicleView:DockMargin(0, 0, 0, RCD.ScrH*0.006)
    vehicleView:SetText("vehicleView")
    vehicleView:InitializeCategory("vehiclePosition", vehicleModel, false, editVehicle)

    local generalSettings = vgui.Create("RCD:Accordion", scrollConfig)
    generalSettings:SetSize(RCD.ScrW*0.538, RCD.ScrH*0.03)
    generalSettings:Dock(TOP)
    generalSettings:DockMargin(0, 0, 0, RCD.ScrH*0.006)
    generalSettings:SetText("generalSettings")
    generalSettings:InitializeCategory("vehicleSettings", vehicleModel, false, editVehicle)

    local priceSettings = vgui.Create("RCD:Accordion", scrollConfig)
    priceSettings:SetSize(RCD.ScrW*0.538, RCD.ScrH*0.03)
    priceSettings:Dock(TOP)
    priceSettings:DockMargin(0, 0, 0, RCD.ScrH*0.006)
    priceSettings:SetText("priceSettings")
    priceSettings:InitializeCategory("priceSettings", vehicleModel, false, editVehicle)

    local cardealerVehc = vgui.Create("RCD:Accordion", scrollConfig)
    cardealerVehc:SetSize(RCD.ScrW*0.538, RCD.ScrH*0.03)
    cardealerVehc:Dock(TOP)
    cardealerVehc:DockMargin(0, 0, 0, RCD.ScrH*0.006)
    cardealerVehc:SetText("cardealerJobSettings")
    cardealerVehc:InitializeCategory("cardealerVehicles", vehicleModel, false, editVehicle)

    chooseVehicle.OnSelect = function(pnl, index, data)
        local optionData = chooseVehicle:GetOptionData(index)
        if not istable(RCD.VehiclesList[optionData]) then return end
        
        local model = RCD.VehiclesList[optionData]["Model"] or "models/airboat.mdl"
        
        vehicleModel:RemoveWheels()
        vehicleModel:SetModel(model)

        if RCD.GetVehicleAddon(optionData) == "simfphys" then
            RCD.GenerateWheels(vehicleModel.Entity, optionData)
        end
        
        entryName:SetText(RCD.VehiclesList[optionData]["Name"])
        RCD.vehicleConfig["class"] = optionData

        vehicleView:InitializeCategory("vehiclePosition", vehicleModel, true)
        generalSettings:InitializeCategory("vehicleSettings", vehicleModel, true)
        priceSettings:InitializeCategory("priceSettings", vehicleModel, true)
    end

    local cancel = vgui.Create("RCD:SlideButton", vehicleMenu)
    cancel:SetSize(vehicleMenu:GetWide()/2.072, RCD.ScrH*0.041)
    cancel:SetPos(RCD.ScrW*0.0065, RCD.ScrH*0.6425)
    cancel:SetText(RCD.GetSentence("cancel"))
    cancel:SetFont("RCD:Font:12")
    cancel:SetTextColor(RCD.Colors["white"])
    cancel.MinMaxLerp = {100, 200}
    cancel:SetIconMaterial(nil)
    cancel:SetButtonColor(RCD.Colors["grey69"])
    cancel.DoClick = function()
        RCD.AdminMenu()
        if IsValid(vehicleMenu) then vehicleMenu:Remove() end
    end

    local createVehc = vgui.Create("RCD:SlideButton", vehicleMenu)
    createVehc:SetSize(vehicleMenu:GetWide()/2.055, RCD.ScrH*0.041)
    createVehc:SetPos(vehicleMenu:GetWide()/1.995, RCD.ScrH*0.6425)
    createVehc:SetText(RCD.GetSentence("validateCreateVehicle"))
    createVehc:SetFont("RCD:Font:12")
    createVehc:SetTextColor(RCD.Colors["white"])
    createVehc:InclineButton(0)
    createVehc.MinMaxLerp = {50, 200}
    createVehc:SetIconMaterial(nil)
    createVehc:SetButtonColor(RCD.Colors["purple"])
    createVehc.DoClick = function()
        local vehicleName = entryName:GetText()
        local vehicleClass = RCD.vehicleConfig["class"]
        local groupId = RCD.vehicleConfig["groupId"]
        local vehiclePrice = tonumber(entryPrice:GetText())

        if not isstring(vehicleClass) or vehicleClass == "" or vehicleClass == "default" then RCD.Notification(5, RCD.GetSentence("invalidVehicleClass")) return end
        if not isnumber(groupId) then RCD.Notification(5, RCD.GetSentence("invalidGroupVehicle")) return end
        if not isstring(vehicleName) or vehicleName == "" or vehicleName == "default" then RCD.Notification(5, RCD.GetSentence("invalidVehicleName")) return end
        if not isnumber(vehiclePrice) or vehiclePrice < 0 then RCD.Notification(5, RCD.GetSentence("invalidVehiclePrice")) return end

        local options = {}
        for k,v in pairs(RCD.vehicleConfig) do    
            options[k] = v
        end

        net.Start("RCD:Admin:Configuration")
            net.WriteUInt(3, 4)
            net.WriteString(vehicleName)
            net.WriteUInt(vehiclePrice, 32)
            net.WriteString(vehicleClass)
            net.WriteUInt(groupId, 32)
            net.WriteUInt(table.Count(options), 12)
            for k,v in pairs(options) do
                local valueType = type(v)

                net.WriteString(valueType)
                net.WriteString(k)
                net["Write"..RCD.TypeNet[valueType]](v, ((RCD.TypeNet[valueType] == "Int") and 32))
            end
            net.WriteBool(editVehicle)
            if editVehicle then
                net.WriteUInt(editVehicle["id"], 32)
            end
        net.SendToServer()
    end

    local closeLerp = 50
    local close = vgui.Create("DButton", vehicleMenu)
    close:SetSize(RCD.ScrH*0.026, RCD.ScrH*0.026)
    close:SetPos(vehicleMenu:GetWide()*0.945, RCD.ScrH*0.03)
    close:SetText("")
    close.Paint = function(self,w,h)
        closeLerp = Lerp(FrameTime()*5, closeLerp, (close:IsHovered() and 50 or 100))

        surface.SetDrawColor(ColorAlpha(RCD.Colors["white100"], closeLerp))
        surface.SetMaterial(RCD.Materials["icon_close"])
        surface.DrawTexturedRect(0, 0, w, h)
    end
    close.DoClick = function()
        vehicleMenu:Remove()
    end
end

function RCD.Settings()    
    if IsValid(settingsMenu) then settingsMenu:Remove() end

    settingsMenu = vgui.Create("DFrame")
    settingsMenu:SetSize(RCD.ScrW*0.55, RCD.ScrH*0.695)
    settingsMenu:SetDraggable(false)
    settingsMenu:MakePopup()
    settingsMenu:SetTitle("")
    settingsMenu:ShowCloseButton(false)
    settingsMenu:Center()
    settingsMenu.Paint = function(self,w,h)
        RCD.DrawBlur(self, 10) 

        draw.RoundedBox(0, 0, 0, w, h, RCD.Colors["blackpurple"])
        draw.RoundedBox(0, w/2-self:GetWide()*0.978/2, h*0.02, self:GetWide()*0.978, RCD.ScrH*0.062, RCD.Colors["white20"])

        draw.DrawText(RCD.GetSentence("adminMenuConfig"), "RCD:Font:10", w*0.025, h*0.02, RCD.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(RCD.GetSentence("configureAddon"), "RCD:Font:11", w*0.025, h*0.06, RCD.Colors["white100"], TEXT_ALIGN_LEFT)
    end

    local scrollConfig = vgui.Create("RCD:DScroll", settingsMenu)
    scrollConfig:SetSize(settingsMenu:GetWide()*0.9785, RCD.ScrH*0.55)
    scrollConfig:SetPos(RCD.ScrW*0.0065, RCD.ScrH*0.083)
    scrollConfig:DockMargin(0, 0, 0, RCD.ScrH*0.006)

    if #RCD.ParametersConfig["compatibilities"] > 0 then
        local compatibilities = vgui.Create("RCD:Accordion", scrollConfig)
        compatibilities:SetSize(RCD.ScrW*0.538, RCD.ScrH*0.03)
        compatibilities:Dock(TOP)
        compatibilities:DockMargin(0, 0, 0, RCD.ScrH*0.006)
        compatibilities:SetText("compatibilities")
        compatibilities:InitializeCategory("compatibilities", nil, false, nil)
    end

    local generalSettings = vgui.Create("RCD:Accordion", scrollConfig)
    generalSettings:SetSize(RCD.ScrW*0.538, RCD.ScrH*0.03)
    generalSettings:Dock(TOP)
    generalSettings:DockMargin(0, 0, 0, RCD.ScrH*0.006)
    generalSettings:SetText("generalSettings")
    generalSettings:InitializeCategory("generalSettings", nil, false, nil)

    local nitroConfig = vgui.Create("RCD:Accordion", scrollConfig)
    nitroConfig:SetSize(RCD.ScrW*0.538, RCD.ScrH*0.03)
    nitroConfig:Dock(TOP)
    nitroConfig:DockMargin(0, 0, 0, RCD.ScrH*0.006)
    nitroConfig:SetText("nitroConfig")
    nitroConfig:InitializeCategory("nitroConfig", nil, false, nil)

    local beltConfig = vgui.Create("RCD:Accordion", scrollConfig)
    beltConfig:SetSize(RCD.ScrW*0.538, RCD.ScrH*0.03)
    beltConfig:Dock(TOP)
    beltConfig:DockMargin(0, 0, 0, RCD.ScrH*0.006)
    beltConfig:SetText("beltConfig")
    beltConfig:InitializeCategory("beltConfig", nil, false, nil)

    local engineConfig = vgui.Create("RCD:Accordion", scrollConfig)
    engineConfig:SetSize(RCD.ScrW*0.538, RCD.ScrH*0.03)
    engineConfig:Dock(TOP)
    engineConfig:DockMargin(0, 0, 0, RCD.ScrH*0.006)
    engineConfig:SetText("engineConfig")
    engineConfig:InitializeCategory("engineModule", nil, false, nil)
    
    local speedometerConfig = vgui.Create("RCD:Accordion", scrollConfig)
    speedometerConfig:SetSize(RCD.ScrW*0.538, RCD.ScrH*0.03)
    speedometerConfig:Dock(TOP)
    speedometerConfig:DockMargin(0, 0, 0, RCD.ScrH*0.006)
    speedometerConfig:SetText("speedometerConfig")
    speedometerConfig:InitializeCategory("speedometerModule", nil, false, nil)
    
    local driveConfig = vgui.Create("RCD:Accordion", scrollConfig)
    driveConfig:SetSize(RCD.ScrW*0.538, RCD.ScrH*0.03)
    driveConfig:Dock(TOP)
    driveConfig:DockMargin(0, 0, 0, RCD.ScrH*0.006)
    driveConfig:SetText("driveConfig")
    driveConfig:InitializeCategory("driveModule", nil, false, nil)

    local configureVehc = vgui.Create("RCD:SlideButton", settingsMenu)
    configureVehc:SetSize(settingsMenu:GetWide()/2.072, RCD.ScrH*0.041)
    configureVehc:SetPos(RCD.ScrW*0.0065, RCD.ScrH*0.6425)
    configureVehc:SetFont("RCD:Font:12")
    configureVehc:SetTextColor(RCD.Colors["white"])
    configureVehc.MinMaxLerp = {100, 200}
    configureVehc:SetIconMaterial(nil)
    configureVehc:SetButtonColor(RCD.Colors["grey69"])
    configureVehc.DoClick = function()
        if IsValid(settingsMenu) then settingsMenu:Remove() end
        RCD.AdminMenu()
    end
    configureVehc.Think = function(self)
        self:SetText(RCD.GetSentence("configureCarDealers"))
    end

    local saveSettings = vgui.Create("RCD:SlideButton", settingsMenu)
    saveSettings:SetSize(settingsMenu:GetWide()/2.055, RCD.ScrH*0.041)
    saveSettings:SetPos(settingsMenu:GetWide()/1.995, RCD.ScrH*0.6425)
    saveSettings:SetFont("RCD:Font:12")
    saveSettings:SetTextColor(RCD.Colors["white"])
    saveSettings:InclineButton(0)
    saveSettings.MinMaxLerp = {50, 200}
    saveSettings:SetIconMaterial(nil)
    saveSettings:SetButtonColor(RCD.Colors["purple"])
    saveSettings.DoClick = function()
        RCD.AdvancedConfiguration["settings"] = RCD.AdvancedConfiguration["settings"] or {}
        
        net.Start("RCD:Admin:Configuration")
            net.WriteUInt(10, 4)
            net.WriteUInt(table.Count(RCD.AdvancedConfiguration["settings"]), 12)
            for k,v in pairs(RCD.AdvancedConfiguration["settings"]) do
                local valueType = type(v)
    
                net.WriteString(valueType)
                net.WriteString(k)
                net["Write"..RCD.TypeNet[valueType]](v, ((RCD.TypeNet[valueType] == "Int") and 32))
            end
        net.SendToServer()
    end
    saveSettings.Think = function(self)
        self:SetText(RCD.GetSentence("validateSaveSettings"))
    end

    local closeLerp = 50
    local close = vgui.Create("DButton", settingsMenu)
    close:SetSize(RCD.ScrH*0.026, RCD.ScrH*0.026)
    close:SetPos(settingsMenu:GetWide()*0.945, RCD.ScrH*0.03)
    close:SetText("")
    close.Paint = function(self,w,h)
        closeLerp = Lerp(FrameTime()*5, closeLerp, (close:IsHovered() and 50 or 100))

        surface.SetDrawColor(ColorAlpha(RCD.Colors["white100"], closeLerp))
        surface.SetMaterial(RCD.Materials["icon_close"])
        surface.DrawTexturedRect(0, 0, w, h)
    end
    close.DoClick = function()
        settingsMenu:Remove()
    end
end

local playerList, searchSteamId
local function addPlayer(steamId)
    if not IsValid(playerList) then return end

    local ply = player.GetBySteamID64(steamId)
    
    local playerButton = vgui.Create("DButton", playerList)
    playerButton:SetSize(0, RCD.ScrH*0.048)
    playerButton:Dock(TOP)
    playerButton:DockMargin(0, 0, 0, RCD.ScrH*0.006)
    playerButton:SetText("")
    playerButton.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, 0, w, h, RCD.Colors["white5"])
    end

    local playerAvatar = vgui.Create("RCD:CircularAvatar", playerButton)
    playerAvatar:SetSize(RCD.ScrH*0.04, RCD.ScrH*0.04)
    playerAvatar:SetPos(RCD.ScrW*0.0025, RCD.ScrH*0.005)
    if IsValid(ply) then
        playerAvatar.RCDAvatar:SetPlayer(ply, 64)
    end
    
    local playerName = vgui.Create("DLabel", playerButton)
    playerName:SetSize(RCD.ScrW*0.19, RCD.ScrH*0.028)
    playerName:SetPos(RCD.ScrW*0.0305, 0)
    playerName:SetText((ply and ply:Name() or "DISCONNECTED"))
    playerName:SetTextColor(RCD.Colors["white100"])
    playerName:SetFont("RCD:Font:12")

    local playerId = vgui.Create("DLabel", playerButton)
    playerId:SetSize(RCD.ScrW*0.19, RCD.ScrH*0.028)
    playerId:SetPos(RCD.ScrW*0.0305, RCD.ScrH*0.018)
    playerId:SetText((steamId or "71111111111111111"))
    playerId:SetTextColor(RCD.Colors["white100"])
    playerId:SetFont("RCD:Font:13")

    local editButton = vgui.Create("RCD:SlideButton", playerButton)
    editButton:SetSize(RCD.ScrH*0.04, RCD.ScrH*0.04)
    editButton:SetPos(RCD.ScrW*0.2185, RCD.ScrH*0.004)
    editButton:SetText("")
    editButton.MinMaxLerp = {5, 7}
    editButton:SetIconMaterial(nil)
    editButton:SetButtonColor(RCD.Colors["white5"])
    editButton.PaintOver = function(self,w,h)
        surface.SetDrawColor(RCD.Colors["white100"])
        surface.SetMaterial(RCD.Materials["icon_edit"])
        surface.DrawTexturedRect(w/2-((w/2)/2), h/2-((h/2)/2), w/2, h/2)
    end
    editButton.DoClick = function()
        net.Start("RCD:Admin:Players")
            net.WriteUInt(1, 4)
            net.WriteString(steamId)
        net.SendToServer()
    end
end

local function reloadPlayers()
    playerList:Clear()

    local playerList = table.Copy(player.GetAll())
    table.sort(playerList, function(a, b) return a:Nick():lower() < b:Nick():lower() end)

    for k,v in ipairs(playerList) do
        if v:IsBot() then continue end

        addPlayer(v:SteamID64())
    end
end

function RCD.ManagePlayers()
    if IsValid(managePlayer) then managePlayer:Remove() end

    managePlayer = vgui.Create("DFrame")
    managePlayer:SetSize(RCD.ScrW*0.503, RCD.ScrH*0.603)
    managePlayer:SetDraggable(false)
    managePlayer:MakePopup()
    managePlayer:SetTitle("")
    managePlayer:ShowCloseButton(false)
    managePlayer:Center()
    managePlayer.Paint = function(self,w,h)
        RCD.DrawBlur(self, 10) 

        draw.RoundedBox(0, 0, 0, w, h, RCD.Colors["blackpurple"])
        draw.RoundedBox(0, w/2-RCD.ScrW*0.49/2, h*0.02, RCD.ScrW*0.49, RCD.ScrH*0.062, RCD.Colors["white20"])

        draw.RoundedBox(0, w/2-RCD.ScrW*0.49/2, h*0.13, RCD.ScrW*0.243, RCD.ScrH*0.045, RCD.Colors["white20"])
        draw.RoundedBox(0, RCD.ScrW*0.2515, h*0.13, RCD.ScrW*0.245, RCD.ScrH*0.045, RCD.Colors["white20"])
        
        draw.DrawText(RCD.GetSentence("adminMenuPlayer"), "RCD:Font:10", w*0.025, h*0.02, RCD.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(RCD.GetSentence("adminMenuPlayerDesc"), "RCD:Font:11", w*0.025, h*0.07, RCD.Colors["white100"], TEXT_ALIGN_LEFT)

        draw.DrawText(RCD.GetSentence("connectedPlayers"), "RCD:Font:18", w*0.25, h*0.145, RCD.Colors["white"], TEXT_ALIGN_CENTER)
        draw.DrawText(RCD.GetSentence("searchDisconnected"), "RCD:Font:18", w*0.75, h*0.145, RCD.Colors["white"], TEXT_ALIGN_CENTER)
    end

    playerList = vgui.Create("RCD:DScroll", managePlayer)
    playerList:SetSize(managePlayer:GetWide()/2.07, RCD.ScrH*0.417)
    playerList:SetPos(RCD.ScrW*0.0065, RCD.ScrH*0.1285)

    reloadPlayers()

    searchSteamId = vgui.Create("RCD:DScroll", managePlayer)
    searchSteamId:SetSize(managePlayer:GetWide()/2.055, RCD.ScrH*0.417)
    searchSteamId:SetPos(managePlayer:GetWide()/2, RCD.ScrH*0.1285)
    
    local entryName = vgui.Create("RCD:TextEntry", searchSteamId)
    entryName:SetSize(0, RCD.ScrH*0.048)
    entryName:Dock(TOP)
    entryName:DockMargin(0, 0, 0, RCD.ScrH*0.006)
    entryName:SetPlaceHolder(RCD.GetSentence("searchSteamId2"))

    local searchAccept = vgui.Create("RCD:SlideButton", searchSteamId)
    searchAccept:SetSize(0, RCD.ScrH*0.042)
    searchAccept:Dock(TOP)
    searchAccept:SetText(RCD.GetSentence("searchPlayer"))
    searchAccept:SetFont("RCD:Font:12")
    searchAccept:SetTextColor(RCD.Colors["white"])
    searchAccept:InclineButton(0)
    searchAccept.MinMaxLerp = {100, 200}
    searchAccept:SetIconMaterial(nil)
    searchAccept:SetButtonColor(RCD.Colors["purple"])
    searchAccept.DoClick = function()
        if entryName:GetText() == RCD.GetSentence("searchSteamId2") then return end

        net.Start("RCD:Admin:Players")
            net.WriteUInt(1, 4)
            net.WriteString(entryName:GetText())
        net.SendToServer()
    end

    local cancel = vgui.Create("RCD:SlideButton", managePlayer)
    cancel:SetSize(managePlayer:GetWide()/2.072, RCD.ScrH*0.041)
    cancel:SetPos(RCD.ScrW*0.0065, RCD.ScrH*0.552)
    cancel:SetText(RCD.GetSentence("cancel"))
    cancel:SetFont("RCD:Font:12")
    cancel:SetTextColor(RCD.Colors["white"])
    cancel:InclineButton(0)
    cancel:SetIconMaterial(nil)
    cancel.MinMaxLerp = {100, 200}
    cancel:SetIconMaterial(nil)
    cancel:SetButtonColor(RCD.Colors["grey69"])
    cancel.DoClick = function()
        if IsValid(managePlayer) then managePlayer:Remove() end
        RCD.Settings()
    end

    local refreshButton = vgui.Create("RCD:SlideButton", managePlayer)
    refreshButton:SetSize(managePlayer:GetWide()/2.055, RCD.ScrH*0.041)
    refreshButton:SetPos(managePlayer:GetWide()/2, RCD.ScrH*0.552)
    refreshButton:SetText(RCD.GetSentence("refreshList"))
    refreshButton:SetFont("RCD:Font:12")
    refreshButton:SetTextColor(RCD.Colors["white"])
    refreshButton:InclineButton(0)
    refreshButton.MinMaxLerp = {100, 200}
    refreshButton:SetIconMaterial(nil)
    refreshButton:SetButtonColor(RCD.Colors["purple"])
    refreshButton.DoClick = function()
        reloadPlayers()
    end

    local closeLerp = 50
    local close = vgui.Create("DButton", managePlayer)
    close:SetSize(RCD.ScrH*0.026, RCD.ScrH*0.026)
    close:SetPos(managePlayer:GetWide()*0.94, RCD.ScrH*0.03)
    close:SetText("")
    close.Paint = function(self,w,h)
        closeLerp = Lerp(FrameTime()*5, closeLerp, (close:IsHovered() and 50 or 100))

        surface.SetDrawColor(ColorAlpha(RCD.Colors["white100"], closeLerp))
        surface.SetMaterial(RCD.Materials["icon_close"])
        surface.DrawTexturedRect(0, 0, w, h)
    end
    close.DoClick = function()
        managePlayer:Remove()
    end
end

function RCD.UpdateOwnedVehicles(steamId, vehiclesOwned)
    vehiclesOwned = vehiclesOwned or {}

    if IsValid(managePlayer) then managePlayer:Remove() end

    local tableToSend = {}
    managePlayer = vgui.Create("DFrame")
    managePlayer:SetSize(RCD.ScrW*0.503, RCD.ScrH*0.603)
    managePlayer:SetDraggable(false)
    managePlayer:MakePopup()
    managePlayer:SetTitle("")
    managePlayer:ShowCloseButton(false)
    managePlayer:Center()
    managePlayer.Paint = function(self,w,h)
        RCD.DrawBlur(self, 10) 

        draw.RoundedBox(0, 0, 0, w, h, RCD.Colors["blackpurple"])
        draw.RoundedBox(0, w/2-RCD.ScrW*0.49/2, h*0.02, RCD.ScrW*0.49, RCD.ScrH*0.062, RCD.Colors["white20"])

        draw.RoundedBox(0, w/2-RCD.ScrW*0.49/2, h*0.13, RCD.ScrW*0.243, RCD.ScrH*0.045, RCD.Colors["white20"])
        draw.RoundedBox(0, RCD.ScrW*0.2515, h*0.13, RCD.ScrW*0.245, RCD.ScrH*0.045, RCD.Colors["white20"])
        
        draw.DrawText(RCD.GetSentence("adminMenuPlayer"), "RCD:Font:10", w*0.025, h*0.02, RCD.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(RCD.GetSentence("adminMenuPlayerDesc"), "RCD:Font:11", w*0.025, h*0.07, RCD.Colors["white100"], TEXT_ALIGN_LEFT)

        draw.DrawText(RCD.GetSentence("selectedPlayer"), "RCD:Font:18", w*0.25, h*0.145, RCD.Colors["white"], TEXT_ALIGN_CENTER)
        draw.DrawText(RCD.GetSentence("allVehicles"), "RCD:Font:18", w*0.75, h*0.145, RCD.Colors["white"], TEXT_ALIGN_CENTER)
    end

    playerList = vgui.Create("RCD:DScroll", managePlayer)
    playerList:SetSize(managePlayer:GetWide()/2.07, RCD.ScrH*0.417)
    playerList:SetPos(RCD.ScrW*0.0065, RCD.ScrH*0.1285)

    addPlayer(steamId)

    scrollVehicles = vgui.Create("RCD:DScroll", managePlayer)
    scrollVehicles:SetSize(managePlayer:GetWide()/2.055, RCD.ScrH*0.417)
    scrollVehicles:SetPos(managePlayer:GetWide()/2, RCD.ScrH*0.1285)

    for k,v in pairs(RCD.GetVehicles()) do
        local vehicleButton = vgui.Create("DButton", scrollVehicles)
        vehicleButton:SetSize(0, RCD.ScrH*0.037)
        vehicleButton:Dock(TOP)
        vehicleButton:DockMargin(0, 0, 0, RCD.ScrH*0.005)
        vehicleButton:SetText("")
        vehicleButton.Paint = function(self,w,h)
            draw.RoundedBox(0, 0, 0, w, h, RCD.Colors["white5"])
        end

        local vehicleName = vgui.Create("DLabel", vehicleButton)
        vehicleName:SetSize(RCD.ScrW*0.19, RCD.ScrH*0.037)
        vehicleName:SetPos(RCD.ScrW*0.008, 0)
        vehicleName:SetTextColor(RCD.Colors["white100"])
        vehicleName:SetFont("RCD:Font:13")
        vehicleName.Think = function(self)
            local groupName = RCD.VehicleGroupGetName(v.groupId) or RCD.GetSentence("undefined")
            
            self:SetText("["..groupName.."] "..(v.name or "nil"))
        end

        local checkBox = vgui.Create("RCD:CheckBox", vehicleButton)
        checkBox:SetSize(RCD.ScrH*0.023, RCD.ScrH*0.023)
        checkBox:SetPos(RCD.ScrW*0.225, vehicleButton:GetTall()/2 - checkBox:GetTall()/2)
        vehicleButton.DoClick = function()
            local active = checkBox:GetActive()
            
            checkBox:SetActive(!active)
            tableToSend[v.id] = !active
        end

        checkBox.OnChange = function()
            local active = checkBox:GetActive()

            tableToSend[v.id] = active
        end

        if vehiclesOwned[v.id] then
            checkBox:SetActive(true)
        end
    end

    local cancel = vgui.Create("RCD:SlideButton", managePlayer)
    cancel:SetSize(managePlayer:GetWide()/2.072, RCD.ScrH*0.041)
    cancel:SetPos(RCD.ScrW*0.0065, RCD.ScrH*0.552)
    cancel:SetText(RCD.GetSentence("cancel"))
    cancel:SetFont("RCD:Font:12")
    cancel:SetTextColor(RCD.Colors["white"])
    cancel:InclineButton(0)
    cancel:SetIconMaterial(nil)
    cancel.MinMaxLerp = {100, 200}
    cancel:SetIconMaterial(nil)
    cancel:SetButtonColor(RCD.Colors["grey69"])    
    cancel.DoClick = function()
        RCD.ManagePlayers()
    end

    local saveInformations = vgui.Create("RCD:SlideButton", managePlayer)
    saveInformations:SetSize(managePlayer:GetWide()/2.055, RCD.ScrH*0.041)
    saveInformations:SetPos(managePlayer:GetWide()/2, RCD.ScrH*0.552)
    saveInformations:SetText(RCD.GetSentence("savePlayerInfo"))
    saveInformations:SetFont("RCD:Font:12")
    saveInformations:SetTextColor(RCD.Colors["white"])
    saveInformations:InclineButton(0)
    saveInformations.MinMaxLerp = {100, 200}
    saveInformations:SetIconMaterial(nil)
    saveInformations:SetButtonColor(RCD.Colors["purple"])
    saveInformations.DoClick = function()
        net.Start("RCD:Admin:Players")
            net.WriteUInt(2, 4)
            net.WriteString(steamId)
            net.WriteUInt(table.Count(tableToSend), 12)
            for k,v in pairs(tableToSend) do
                if v == nil then continue end
                net.WriteUInt(k, 32)
                net.WriteBool(v)
            end
        net.SendToServer()
    end

    local closeLerp = 50
    local close = vgui.Create("DButton", managePlayer)
    close:SetSize(RCD.ScrH*0.026, RCD.ScrH*0.026)
    close:SetPos(managePlayer:GetWide()*0.94, RCD.ScrH*0.03)
    close:SetText("")
    close.Paint = function(self,w,h)
        closeLerp = Lerp(FrameTime()*5, closeLerp, (close:IsHovered() and 50 or 100))

        surface.SetDrawColor(ColorAlpha(RCD.Colors["white100"], closeLerp))
        surface.SetMaterial(RCD.Materials["icon_close"])
        surface.DrawTexturedRect(0, 0, w, h)
    end
    close.DoClick = function()
        managePlayer:Remove()
    end
end

net.Receive("RCD:Admin:Players", function(len, ply)
    local uInt = net.ReadUInt(4)

    if uInt == 1 then
        local steamId64 = net.ReadString()
        local vehiclesOwnedCounts = net.ReadUInt(12)

        local vehiclesOwned = {}
        for i=1, vehiclesOwnedCounts do
            local vehicleId = net.ReadUInt(32)

            vehiclesOwned[vehicleId] = true
        end

        RCD.UpdateOwnedVehicles(steamId64, vehiclesOwned)
    elseif uInt == 2 then
        RCD.ManagePlayers()
    end
end)

net.Receive("RCD:Admin:Configuration", function()
    local uInt = net.ReadUInt(4)

    --[[ Add into the table all vehicle groups ]]
    if uInt == 1 then
        local bytesAmount = net.ReadUInt(32)
        local unCompressTable = util.Decompress(net.ReadData(bytesAmount)) or ""
        local groupsTable = util.JSONToTable(unCompressTable)

        RCD.AdvancedConfiguration["groupsList"] = groupsTable

    --[[ Add/Edit only one vehicle groups ]]
    elseif uInt == 2 then
        local groupId = net.ReadUInt(32)
        local groupName = net.ReadString()
        
        local countRankAccess = net.ReadUInt(8)
        local rankAccess = {}
        for i=1, countRankAccess do
            local rankName = net.ReadString()
            
            rankAccess[rankName] = true
        end
        
        local countJobAccess = net.ReadUInt(8)
        local jobAccess = {}
        for i=1, countJobAccess do
            local jobName = net.ReadString()
            
            jobAccess[jobName] = true
        end
        
        local groupTable = {
            ["id"] =  groupId,
            ["name"] = groupName,
            ["rankAccess"] = rankAccess,
            ["jobAccess"] = jobAccess
        }
        
        RCD.AdvancedConfiguration["groupsList"] = RCD.AdvancedConfiguration["groupsList"] or {}
        RCD.AdvancedConfiguration["groupsList"][groupId] = groupTable

        if IsValid(groupMenu) then groupMenu:Remove() end
        RCD.AdminMenu()

    --[[ Remove and update groups ]]
    elseif uInt == 3 then
        local groupId = net.ReadUInt(32)

        RCD.AdvancedConfiguration["groupsList"][groupId] = nil
        reloadGroups()
    
    --[[ Open the admin menu ]]
    elseif uInt == 4 then
        RCD.Settings()

    --[[ Add into the table all vehicles ]]
    elseif uInt == 5 then
        local bytesAmount = net.ReadUInt(32)
        local unCompressTable = util.Decompress(net.ReadData(bytesAmount)) or ""
        local vehicleTable = util.JSONToTable(unCompressTable)

        RCD.AdvancedConfiguration["vehiclesList"] = vehicleTable

        hook.Run("RCD:VehiclesLoaded")

    --[[ Add into the table one vehicle ]]
    elseif uInt == 6 then
        local name = net.ReadString()
        local price = net.ReadUInt(32)
        local class = net.ReadString()
        local optionsCount = net.ReadUInt(12)

        local options = {}
        for i=1, optionsCount do
            local valueType = net.ReadString()
            local key = net.ReadString()
            local value = net["Read"..RCD.TypeNet[valueType]](32)

            options[key] = value
        end
        
        local groupId = net.ReadUInt(32)
        local vehicleId = net.ReadUInt(32)

        local tableToAdd = {
            ["name"] = name,
            ["price"] = price,
            ["class"] = class,
            ["options"] = options,
            ["groupId"] = groupId,
            ["id"] = vehicleId,
        }

        RCD.AdvancedConfiguration["vehiclesList"] = RCD.AdvancedConfiguration["vehiclesList"] or {}
        RCD.AdvancedConfiguration["vehiclesList"][vehicleId] = tableToAdd
        
        if IsValid(vehicleMenu) then vehicleMenu:Remove() end
        RCD.AdminMenu()

    --[[ Remove one vehicle with his uniqueid ]]
    elseif uInt == 7 then
        local vehicleId = net.ReadUInt(32)

        RCD.AdvancedConfiguration["vehiclesList"][vehicleId] = nil
        reloadVehicles()
        
    --[[ Open the npc menu to edit infos ]]
    elseif uInt == 8 then
        local npcId = net.ReadUInt(32)
        local model = net.ReadString()
        local name = net.ReadString()

        local groupsCount = net.ReadUInt(12)
        local npcGroups = {}
        for i=1, groupsCount do
            local groupsId = net.ReadUInt(32)

            npcGroups[groupsId] = true
        end

        local plateformsCount = net.ReadUInt(12)
        local plateforms = {}
        for i=1, plateformsCount do
            local pos, ang = net.ReadVector(), net.ReadAngle()

            plateforms[#plateforms + 1] = {
                ["pos"] = pos,
                ["ang"] = ang
            }
        end

        local infoTable = {
            ["id"] = npcId,
            ["model"] = model,
            ["name"] = name,
            ["groups"] = npcGroups,
            ["plateforms"] = plateforms
        }

        RCD.NPCMenu(npcId, infoTable)

    --[[ Place all plateforms ]]
    elseif uInt == 9 then
        local plateformTableCount = net.ReadUInt(12)

        for i=1, plateformTableCount do
            local pos, ang = net.ReadVector(), net.ReadAngle()

            RCD.CreateRCDPlateform(pos, ang)
        end

    --[[ Load settings ]]
    elseif uInt == 10 then
        local settingsCount = net.ReadUInt(12)

        for i=1, settingsCount do
            local valueType = net.ReadString()
            local key = net.ReadString()
            local value = net["Read"..RCD.TypeNet[valueType]](((RCD.TypeNet[valueType] == "Int") and 32))

            RCD.DefaultSettings[key] = value
        end

        if istable(simfphys) then
            RunConsoleCommand("cl_simfphys_hud", RCD.DefaultSettings["activateSimfphysSpeedometer"] and 1 or 0)
        end
    end
end)