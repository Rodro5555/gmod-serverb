AAS.LocalPlayer = LocalPlayer()
AAS.ClientTable = AAS.ClientTable or {
    ["Id"] = 1,
    ["ItemsTable"] = {},
    ["ItemSelected"] = nil,
    ["AdminPos"] = {},
    ["ItemsInventory"] = {},
    ["ItemsEquiped"] = {},
    ["ResizeIcon"] = {},
    ["offsetItems"] = {},
    ["filters"] = {["vip"] = true, ["new"] = true, ["search"] = ""}
}

local function resizeFontByLanguage()
    local fontScale = nil
    if AAS.Lang == "es" then
        fontScale = AAS.ScrH*0.022
    elseif AAS.Lang == "ru" then
        fontScale = AAS.ScrH*0.018
    end 

    return fontScale
end

AAS.ScrW, AAS.ScrH = ScrW(), ScrH()
hook.Add("OnScreenSizeChanged", "AAS:OnScreenSizeChanged", function()
    AAS.ScrW = ScrW()
    AAS.ScrH = ScrH()

    AAS.LoadFonts(resizeFontByLanguage())
end)

--[[ Update admin and client list ]]
function AAS.UpdateList(table, bool)
    if IsValid(accessoriesFrame) and IsValid(itemContainer) and IsValid(itemScroll) then
        itemContainer:Clear()

        if #table == 0 and IsValid(sliderList) then AAS.ItemMenu() end
        for k,v in ipairs(table) do
            local newTime = istable(v.options) and tonumber(v.options["date"]) or 0
            local isNew = (((newTime + (AAS.NewTime*60*60*24)) > os.time()) and v.options["new"])

            if (v.options["vip"] and not isNew) and not AAS.ClientTable["filters"]["vip"] and not AAS.ClientTable["filters"]["new"] then continue end
            if (v.options["vip"] and isNew) and not AAS.ClientTable["filters"]["vip"] then continue end
            if (not isNew and not v.options["vip"]) and not AAS.ClientTable["filters"]["new"] then continue end
            if not string.find(v.name:lower(), AAS.ClientTable["filters"]["search"]:lower()) then continue end

            if not IsValid(sliderList) and not v.options.activate then continue end
            
            local itemBackground = vgui.Create("AAS:Cards", itemContainer)
            itemBackground:AddItemView(itemScroll, accessoriesFrame, itemContainer, v)
            
            if IsValid(sliderList) then
                -- [[ Set the first item selected when one was deleted ]]
                local oldItem = AAS.GetTableById((AAS.ClientTable["ItemSelected"].uniqueId or 0))
                if not istable(oldItem) or #oldItem == 0 and k == 1 then
                    AAS.ClientTable["ItemSelected"] = v
                    AAS.settingsScroll(accessoriesFrame, AAS.ScrH*0.11, AAS.ScrH*0.525, true, AAS.GetSentence("edititem"), true, true)
                end
            end

            if not bool then 
                itemBackground:RemoveButton()
            else 
                itemBackground:SetSize(AAS.ScrW*0.11, AAS.ScrH*0.26)
            end
            itemBackground.buttonHover.Think = function(self)
                if not IsValid(playerModel) then return end
                if self:IsHovered() then
                    playerModel:SetDrawAccessories(v.uniqueId)
                else
                    playerModel:RemoveDrawAccessories(v.uniqueId)
                end
            end
        end
    end
end

--[[ Create clientside accessory ]]
function AAS.CreateAccessory(uniqueId, steamId, offsetTable)
    local itemTable = AAS.GetTableById(uniqueId)
        
    AAS.ClientTable["ItemsEquiped"][steamId] = AAS.ClientTable["ItemsEquiped"][steamId] or {}
    local viewModel = AAS.ClientTable["ItemsEquiped"][steamId][itemTable.category]

    if IsValid(viewModel) then viewModel:Remove() end
    if not isstring(itemTable.model) then return end

    local createAccessory = ClientsideModel(itemTable.model)
    createAccessory:SetNoDraw( true )
    createAccessory.uniqueId = uniqueId
    createAccessory.model = itemTable.model
    createAccessory.offset = offsetTable
    
    AAS.ClientTable["ItemsEquiped"][steamId][itemTable.category] = createAccessory
    
    if IsValid(playerModel) then
        playerModel:DrawAccessories()
    end
end

net.Receive("AAS:Main", function()
    local UInt = net.ReadUInt(5)

    if UInt == 1 then
        --[[ Syncrhonise all items created on the server ]]
        local length = net.ReadUInt(32)
        local data = net.ReadData(length)
        local bool = net.ReadBool()
        
        AAS.ClientTable["ItemsTable"] = AAS.UnCompressTable(data) or {}
        AAS.ClientTable["ItemsVisible"] = AAS.ClientTable["ItemsTable"]
        
        if IsValid(accessoriesFrame) then
            for k,v in pairs(AAS.ClientTable["ItemsTable"]) do
                util.PrecacheModel(v.model)
            end
        end
        
        AAS.UpdateList(AAS.ClientTable["ItemsTable"], !IsValid(playerModel))

        if bool then AAS.ItemMenu() end
    elseif UInt == 2 then
        --[[ Open the items menu ]]
        AAS.ItemMenu()

    elseif UInt == 3 then 
        --[[ Create a custom notification ]]
        local time = net.ReadUInt(5)
        local message = net.ReadString()
        
        AAS.Notification(time, message)
        
    elseif UInt == 4 then 
        --[[ Open the bodygroup menu ]]
        AAS.BodyGroup()
    elseif UInt == 5 then
        --[[ Open the model change menu ]]
        AAS.ChangeModels()
    elseif UInt == 6 then
        --[[ Open the adminsettings menu ]]
        AAS.AdminSetting()
    elseif UInt == 7 then
        --[[ Resize fonts ]]
        AAS.LoadFonts(resizeFontByLanguage())
    end 
end)

net.Receive("AAS:Inventory", function()
    local UInt = net.ReadUInt(5)

    if UInt == 1 then 
        --[[ Synchronise your inventory ]]
        local length = net.ReadUInt(32)
        local data = net.ReadData(length)
        
        AAS.ClientTable["ItemsInventory"] = AAS.UnCompressTable(data) or {}

        if IsValid(popupFrame) then
            popupFrame:AlphaTo( 0, 0.3, 0, function()
                popupFrame:Remove()
            end)
        end

        hook.Run("AAS:InventoryChange", AAS.ClientTable["ItemsInventory"])
    elseif UInt == 2 then
        --[[ Equip an accessory ]]
        local uniqueId = net.ReadUInt(32)
        local steamId = net.ReadString()
        local offsetTable = net.ReadTable()
        local category = net.ReadString()

        if not istable(AAS.ClientTable["ItemsEquiped"][steamId]) then AAS.ClientTable["ItemsEquiped"][steamId] = {} end
        local ent = AAS.ClientTable["ItemsEquiped"][steamId][category]
        if IsValid(ent) then ent:Remove() end
        
        AAS.CreateAccessory(uniqueId, steamId, offsetTable)

        local itemTable = AAS.GetTableById(uniqueId)
        
        if AAS.ModifyOffset and IsValid(accessoriesFrame) then
            AAS.SettingsPopupMenu(itemTable)
        end

        hook.Run("AAS:EquipAccessory", uniqueId)
    elseif UInt == 3 then
        --[[ Remove an equiped accessory ]]
        local category = net.ReadString()
        local steamId = net.ReadString()

        if not istable(AAS.ClientTable["ItemsEquiped"][steamId]) then AAS.ClientTable["ItemsEquiped"][steamId] = {} end
        local ent = AAS.ClientTable["ItemsEquiped"][steamId][category]
        if IsValid(ent) then ent:Remove() end

        AAS.ClientTable["ItemsEquiped"][steamId][category] = nil

        if IsValid(playerModel) then
            playerModel:DrawAccessories(category)
        end
        
        hook.Run("AAS:UnEquipAccessory", uniqueId)
        
    elseif UInt == 4 then
        --[[ Just reset the table when the player disconnect ]]
        local steamId = net.ReadString()

        AAS.ClientTable["ItemsEquiped"][steamId] = nil
    elseif UInt == 5 then
        --[[ This is the part for get all accessory of all player in the server]]
        local length = net.ReadUInt(32)
        local data = net.ReadData(length)
        local tbl = AAS.UnCompressTable(data) or {}

        for k,v in ipairs(player.GetAll()) do
            local steamId = v:SteamID()

            if not istable(tbl[v:SteamID()]) then continue end
            for category, uniqueId in pairs(tbl[v:SteamID()]) do
                if istable(uniqueId) then continue end

                local tbl = tbl[v:SteamID()]["offsets"][uniqueId]
                if not istable(tbl) then tbl = {} end

                AAS.CreateAccessory(uniqueId, v:SteamID64(), tbl)
            end
        end
    elseif UInt == 6 then
        --[[ Get all personal offset ]]
        local offsetTable = net.ReadTable()

        AAS.ClientTable["offsetItems"] = offsetTable

        hook.Run("AAS:ChangeOffsetItems")

    elseif UInt == 7 then
        hook.Run("AAS:ClosePlayerSettingsPanel")
    end
end)

local calcPos, calcAng, calcPosE, calcAngE
function AAS.BaseMenu(title, info, sizeX, icon, text)
    AAS.ClientTable["filters"] = {["vip"] = true, ["new"] = true, ["search"] = ""}

    if IsValid(accessoriesFrame) then accessoriesFrame:Remove() end 
    
    local linearGradient = {
        {offset = 0, color = AAS.Gradient["upColor"]},
        {offset = 0.4, color = AAS.Gradient["midleColor"]},
        {offset = 1, color = AAS.Gradient["downColor"]},
    }

    accessoriesFrame = vgui.Create("DFrame")
    accessoriesFrame:SetSize(AAS.ScrW*0.5994, AAS.ScrH*0.65)
    accessoriesFrame:Center()
    accessoriesFrame:SetDraggable(false) 
    accessoriesFrame:SetTitle("")
    accessoriesFrame:ShowCloseButton(false) 
    accessoriesFrame:MakePopup()
    accessoriesFrame.startTime = SysTime()
    accessoriesFrame:SetAlpha(200)
    accessoriesFrame:AlphaTo( 255, 0.3, 0 )
    accessoriesFrame.Paint = function(self,w,h)
        local x, y = accessoriesFrame:GetPos()

        draw.RoundedBoxEx(8, 0, 0, w, AAS.ScrH*0.047, AAS.Colors["background"], true, true, false, false)
        draw.RoundedBox(0, 0, AAS.ScrH*0.04, w, AAS.ScrH*0.009, AAS.Colors["black150"])
        draw.RoundedBoxEx(8, 0, AAS.ScrH*0.047, w, h-AAS.ScrH*0.047, AAS.Colors["black18"], false, false, true, true)

        AAS.LinearGradient(x, y + AAS.ScrH*0.047, AAS.ScrW*0.038, h-AAS.ScrH*0.065, linearGradient, false)
        AAS.LinearGradient(x + w-sizeX, y + AAS.ScrH*0.047, sizeX, h-AAS.ScrH*0.065, linearGradient, false)

        draw.RoundedBoxEx(8, 0, AAS.ScrH*0.63, AAS.ScrW*0.038, AAS.ScrH*0.02, AAS.Gradient["downColor"], false, false, true, false)
        draw.RoundedBoxEx(8, w-sizeX, AAS.ScrH*0.63, sizeX, AAS.ScrH*0.02, AAS.Gradient["downColor"], false, false, false, true)

        draw.SimpleText(title, "AAS:Font:01", AAS.ScrW*0.039, AAS.ScrH*0.019, AAS.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(AAS.Colors["white"])
        surface.SetMaterial(AAS.Materials[icon])

        local sizeY = AAS.Materials[icon]:Height()*AAS.ScrH/1080
        surface.DrawTexturedRect(AAS.ScrW*0.0125, sizeY/2-AAS.ScrH*0.003, AAS.Materials[icon]:Width()*AAS.ScrW/1920, sizeY)

        if #AAS.ClientTable["ItemsTable"] == 0 and text then
            draw.DrawText(AAS.GetSentence("noItems"), "AAS:Font:02", w*0.39, h*0.4, AAS.Colors["white"], TEXT_ALIGN_CENTER)
        end

        if not info then return end 

        surface.SetDrawColor(AAS.Colors["white"])
        surface.SetMaterial(AAS.Materials["informations"])
        surface.DrawTexturedRect(AAS.ScrW*0.478, AAS.ScrH*0.585, AAS.ScrW*0.0866, AAS.ScrH*0.0225)

        draw.DrawText(AAS.LocalPlayer:Health(), "AAS:Font:02", AAS.ScrW*0.4831, AAS.ScrH*0.612, AAS.Colors["white"], TEXT_ALIGN_CENTER)
        draw.DrawText(AAS.LocalPlayer:Armor(), "AAS:Font:02", AAS.ScrW*0.521, AAS.ScrH*0.612, AAS.Colors["white"], TEXT_ALIGN_CENTER)
        draw.DrawText(AAS.LocalPlayer:GetMaxSpeed(), "AAS:Font:02", AAS.ScrW*0.559, AAS.ScrH*0.612, AAS.Colors["white"], TEXT_ALIGN_CENTER)
    end

    local closeButton = vgui.Create("DButton", accessoriesFrame)
    closeButton:SetSize(AAS.ScrW*0.011, AAS.ScrW*0.011)
    closeButton:SetPos(accessoriesFrame:GetWide()*0.97, AAS.ScrH*0.04/2-closeButton:GetTall()/2) 
    closeButton:SetText("")
    closeButton.Paint = function(self,w,h)
        surface.SetDrawColor(AAS.Colors["white"])
        surface.SetMaterial(AAS.Materials["close"])
        surface.DrawTexturedRect( 0, 0, w, h )
    end  
    closeButton.DoClick = function()
        accessoriesFrame:Remove()
    end
end

function AAS.ItemMenu()
    AAS.ClientTable["filters"] = {["vip"] = true, ["new"] = true, ["search"] = ""}

    AAS.ClientTable["ItemSelected"] = nil

    AAS.BaseMenu(isstring(AAS.TitleMenu) and AAS.TitleMenu != "" and AAS.TitleMenu or AAS.GetSentence("welcomeText"), true, AAS.ScrW*0.1595, "house", true)
    AAS.ClientTable["Id"], LerpPos, AAS.ClientTable["ItemsVisible"] = 1, 0, AAS.ClientTable["ItemsTable"]
    
    playerModel = vgui.Create("AAS:DModel", accessoriesFrame)
    playerModel:SetFOV(25)
    
    local categoryList = vgui.Create("DScrollPanel", accessoriesFrame)
    categoryList:SetSize(AAS.ScrW*0.038, AAS.ScrH*0.5)
    categoryList:SetPos(0, AAS.ScrH*0.1)
    categoryList.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, LerpPos, AAS.ScrW*0.038, AAS.ScrH*0.038, AAS.Colors["selectedBlue"])
        draw.RoundedBox(0, AAS.ScrW*0.038 - AAS.ScrW*0.0017, LerpPos, AAS.ScrW*0.002, AAS.ScrH*0.038, AAS.Colors["white200"])
    end

    local LerpTo = 0
    for k,v in ipairs(AAS.Category["mainMenu"]) do
        local categoryButton = vgui.Create("DButton", categoryList)
        categoryButton:SetSize(0, AAS.ScrH*0.038)
        categoryButton:Dock(TOP)
        categoryButton:SetText("")
        categoryButton:DockMargin(0,AAS.ScrH*v.margin,0,0)
        categoryButton.Paint = function(self,w,h)
            surface.SetDrawColor(AAS.Colors["white"])
            surface.SetMaterial(v.material, "smooth")
            surface.DrawTexturedRect(0, 0, w, h)
            
            LerpPos = Lerp(FrameTime()*5, LerpPos, LerpTo)
        end 
        categoryButton.DoClick = function()
            AAS.ClientTable["Id"] = k

            local x,y = categoryButton:GetPos()
            LerpTo = y

            local categoryTable = AAS.Category["mainMenu"][AAS.ClientTable["Id"]]
            
            local itemsTable = {}
            for k,v in ipairs(AAS.ClientTable["ItemsTable"]) do
                if v.category != categoryTable["uniqueName"] then continue end
                itemsTable[#itemsTable + 1] = v
            end

            AAS.ClientTable["ItemsVisible"] = categoryTable["all"] and AAS.ClientTable["ItemsTable"] or itemsTable

            AAS.UpdateList(AAS.ClientTable["ItemsVisible"])
        end 
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

        AAS.UpdateList(AAS.ClientTable["ItemsVisible"])
    end 

    newButton.DoClick = function()
        newButton:ChangeStatut(true)

        AAS.UpdateList(AAS.ClientTable["ItemsVisible"])
    end 
    
    itemScroll = vgui.Create( "AAS:ScrollPanel", accessoriesFrame)
    itemScroll:SetSize(AAS.ScrW*0.384, AAS.ScrH*0.542)
    itemScroll:SetPos(AAS.ScrW*0.052, AAS.ScrH*0.1)

    itemContainer = vgui.Create("DIconLayout", itemScroll)
    itemContainer:SetSize(AAS.ScrW*0.384, AAS.ScrH*0.542)
    itemContainer:SetSpaceX(AAS.ScrW*0.016) 
    itemContainer:SetSpaceY(AAS.ScrW*0.016)
    
    for k,v in ipairs(AAS.ClientTable["ItemsTable"]) do
        if not v.options.activate then continue end

        local itemBackground = vgui.Create("AAS:Cards", itemContainer)
        itemBackground:DockMargin(AAS.ScrW*0.016,0,0,0)  
        itemBackground:AddItemView(itemScroll, accessoriesFrame, itemContainer, v)
        itemBackground:RemoveButton()
        itemBackground.buttonHover.Think = function(self)
            if self:IsHovered() then
                playerModel:SetDrawAccessories(v.uniqueId)
            else
                playerModel:RemoveDrawAccessories(v.uniqueId)
            end
        end
    end

    local admin = AAS.AdminRank[AAS.LocalPlayer:GetUserGroup()]

    local inventoryButton = vgui.Create("DButton", accessoriesFrame)
    inventoryButton:SetSize(AAS.ScrH*0.0277, AAS.ScrH*0.0277)
    inventoryButton:SetPos(AAS.ScrW*0.0384/2 - AAS.ScrH*0.0277/2, accessoriesFrame:GetTall()*(admin and 0.85 or 0.92))
    inventoryButton:SetText("")
    inventoryButton.Paint = function(self,w,h)
        surface.SetDrawColor(AAS.Colors["white"])
        surface.SetMaterial(AAS.Materials["avatar"])
        surface.DrawTexturedRect( 0, 0, w, h )
    end  
    inventoryButton.DoClick = function()
        AAS.InventoryMenu()
    end 

    if admin then
        local settingsButton = vgui.Create("DButton", accessoriesFrame)
        settingsButton:SetSize(AAS.ScrH*0.0277, AAS.ScrH*0.0277)
        settingsButton:SetPos(AAS.ScrW*0.0384/2 - AAS.ScrH*0.0277/2, accessoriesFrame:GetTall()*0.92)
        settingsButton:SetText("")
        settingsButton.Paint = function(self,w,h)
            surface.SetDrawColor(AAS.Colors["white"])
            surface.SetMaterial(AAS.Materials["settings"])
            surface.DrawTexturedRect( 0, 0, w, h )
        end  
        settingsButton.DoClick = function()
            AAS.AdminSetting()
        end
    end
end

function AAS.PopupMenu(uniqueId, sell, price)
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

        draw.SimpleText(sell and AAS.GetSentence("sellaccessory") or AAS.GetSentence("buyaccessory"), "AAS:Font:06", w*0.174, AAS.ScrH*0.021, AAS.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(AAS.GetSentence("sure"), "AAS:Font:07", w/2, h*0.465, AAS.Colors["white"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(AAS.Colors["white"])
        surface.SetMaterial(AAS.Materials["market"])
        surface.DrawTexturedRect(w*0.05, AAS.ScrH*0.0105, (AAS.Materials["market"]:Width()*AAS.ScrW/1920)*0.85, (AAS.Materials["market"]:Height()*AAS.ScrH/1080)*0.85)
    end

    local lerpFirstButton = 255
    local payButton = vgui.Create("DButton", popupFrame)
    payButton:SetSize(AAS.ScrW*0.09, AAS.ScrH*0.042)
    payButton:SetPos(AAS.ScrW*0.005, AAS.ScrH*0.105)
    payButton:SetFont("AAS:Font:02")
    payButton:SetText((sell and string.upper(AAS.GetSentence("sell")) or string.upper(AAS.GetSentence("buy"))).." "..AAS.formatMoney(sell and (price*AAS.SellValue/100) or price))
    payButton:SetTextColor(AAS.Colors["white"])
    payButton.Paint = function(self,w,h)
        lerpFirstButton = Lerp(FrameTime()*10, lerpFirstButton, self:IsHovered() and 255 or 100)

        draw.RoundedBox(8, 0, 0, w, h,  ColorAlpha(AAS.Colors["blue75"], lerpFirstButton))
    end
    payButton.DoClick = function()
        net.Start("AAS:Inventory")
            net.WriteUInt((sell and 2 or 1), 5)
            net.WriteUInt(uniqueId, 32)
        net.SendToServer()
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

hook.Add("HUDPaint", "AAS:HUDPaint:Initialize", function()
    AAS.LoadFonts(resizeFontByLanguage())
    AAS.LocalPlayer = LocalPlayer()
    hook.Remove("HUDPaint", "AAS:HUDPaint:Initialize")
end)

hook.Add("HUDShouldDraw", "AAS:HUDShouldDraw:Settings", function()
    if IsValid(mainPanel) then return false end 
end)

hook.Add( "PostPlayerDraw" , "AAS:PostPlayerDraw", function(ply)
    if IsValid(mainPanel) or IsValid(playerSettingsPanel) and AAS.LocalPlayer == ply then return end
    if not istable(AAS.ClientTable["ItemsEquiped"]) or not istable(AAS.ClientTable["ItemsEquiped"][ply:SteamID64()]) then return end
    if AAS.BlackListJobAccessory[team.GetName(ply:Team())] then return end

    for k,v in pairs(AAS.ClientTable["ItemsEquiped"][ply:SteamID64()]) do
        if not IsValid(v) or not isnumber(v.uniqueId) then continue end

        local itemTable = AAS.GetTableById(v.uniqueId)
        if not istable(itemTable) or table.Count(itemTable) == 0 then continue end

        if istable(itemTable.job) and table.Count(itemTable.job) > 0 and not itemTable.job[team.GetName(ply:Team())] then continue end
        if not istable(itemTable.options) or not isstring(itemTable.options.bone) then continue end
    
        local boneid = ply:LookupBone(itemTable.options.bone)
        if not boneid then
            continue
        end
        
        local matrix = ply:GetBoneMatrix(boneid)
        if not matrix then 
            continue
        end
        
        if not isvector(itemTable.pos) or not isangle(itemTable.ang) then continue end
        if not isstring(itemTable.model) or not isvector(itemTable.scale) or not istable(itemTable.options) then continue end
        
        local offsetPos = (istable(v.offset) and isvector(v.offset["pos"]) and AAS.ModifyOffset) and v.offset["pos"] or Vector(0,0,0)
        local offsetAng = (istable(v.offset) and isangle(v.offset["ang"]) and AAS.ModifyOffset) and v.offset["ang"] or Angle(0,0,0)
        local offsetScale = (istable(v.offset) and isvector(v.offset["scale"]) and AAS.ModifyOffset) and v.offset["scale"] or Vector(0,0,0)
        
        local newpos = AAS.ConvertVector(matrix:GetTranslation(), itemTable.pos + offsetPos, matrix:GetAngles())
        local newang = AAS.ConvertAngle(matrix:GetAngles(), itemTable.ang + offsetAng)
        
        v:SetPos(newpos)
        v:SetAngles(newang)
        v:SetModel(itemTable.model)
        v.model = itemTable.model

        local mat = Matrix()
        mat:Scale(itemTable.scale + (offsetScale / 50))
        v:EnableMatrix("RenderMultiply", mat)

        local skin = tonumber(itemTable.options.skin)
        if isnumber(skin) then
            v:SetSkin(skin)
        end

        local color = itemTable.options.color
        render.SetColorModulation(color.r/255, color.g/255, color.b/255, color.a/255)
        v:SetupBones()
        v:DrawModel()
    end
end)

local shCategoryToAAS = {
    ["head"] = AAS.Category["mainMenu"][2]["uniqueName"],
    ["eyes"] = AAS.Category["mainMenu"][3]["uniqueName"],
    ["mouth"] = AAS.Category["mainMenu"][5]["uniqueName"],
    ["neck"] = AAS.Category["mainMenu"][4]["uniqueName"],
    ["back"] = AAS.Category["mainMenu"][6]["uniqueName"],
}

local function getCategory(slot)
    if not SH_ACC then return end

    local category = "Hat"
    for k,v in ipairs(SH_ACC.ShopCategories) do
        if v.slot != slot or not isstring(shCategoryToAAS[v.text]) then continue end

        category = shCategoryToAAS[v.text]
    end

    return category
end

function AAS.SHToAAS()
    if not SH_ACC then return end

    local SendTable = {}
    for k,v in pairs(SH_ACC.List) do
        local offset = SH_ACC.Offsets[v.mdl]
        if not istable(offset) then continue end

        local AASTable = {
            ["name"] = v.name,
            ["price"] = v.price,
            ["model"] = v.mdl,
            ["price"] = v.price,
            ["pos"] = offset["default"]["pos"],
            ["ang"] = Angle(offset["default"]["ang"][2], offset["default"]["ang"][1], offset["default"]["ang"][3]),
            ["scale"] = Vector(v.scale, v.scale, v.scale),
            ["job"] = v.jobs,
            ["category"] = getCategory(v.slots),
            ["options"] = {
                ["iconPos"] = Vector(0,0,0),
                ["new"] = true,
                ["bone"] = offset["default"]["bone"],
                ["skin"] = v.skin,
                ["color"] = v.color,
                ["vip"] = false,
                ["iconFov"] = 0,
                ["usergroups"] = v.usergroups,
                ["activate"] = 1,
            }
        }
        SendTable[#SendTable + 1] = AASTable
    end

    local CompressTbl = AAS.CompressTable(SendTable)
    net.Start("AAS:Main")
        net.WriteUInt(4, 5)
        net.WriteUInt(#CompressTbl, 32)
        net.WriteData(CompressTbl, #CompressTbl)
    net.SendToServer()
end

concommand.Add("aas_sh_item_to_aas", function(ply, cmd, args)
    if not AAS.AdminRank[LocalPlayer():GetUserGroup()] then return end
    AAS.SHToAAS()
end)