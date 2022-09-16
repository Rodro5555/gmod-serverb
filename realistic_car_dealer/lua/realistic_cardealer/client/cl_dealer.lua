--[[
    Just some information about the table RCD.ClientTable

    RCD.ClientTable["vehicleSelected"] = The vehicle actually selected on the menu with all data
    RCD.ClientTable["carrouselId"] = The id of the vehicle not the unique id but the id on the carousel
    RCD.ClientTable["vehicleId"] = The real unique id on the database of the vehicle 
    RCD.ClientTable["vehiclesBought"] = The table of all vehicle bought into the car dealer curently opened
    RCD.ClientTable["vehiclesTable"] = All vehicle on the cardealer curently opened
    RCD.ClientTable["canCustomize"] = If the vehicle selected have customization settings
    RCD.ClientTable["customize"] = If the player is actually on the customize page
    RCD.ClientTable["NWToSynchronize"] = All NW to synchronise
]]

local checkBoxInfo, vehicleScroll, rightScroll, vehicleModel, rightScrollDown, rightPanel, buyButton

RCD.ClientTable = RCD.ClientTable or {}

RCD.ScrW, RCD.ScrH = ScrW(), ScrH()
hook.Add("OnScreenSizeChanged", "RCD:OnScreenSizeChanged", function()
    RCD.ScrW, RCD.ScrH = ScrW(), ScrH()

    RCD.LoadFonts()
end)

local function reloadInteractionButton(pnl)
    if not IsValid(pnl) then return end

    if not RCD.ClientTable["customize"] then
        local bought = RCD.ClientTable["vehiclesBought"][RCD.ClientTable["vehicleId"]]

        local vehcTable = RCD.ClientTable["vehiclesTable"][RCD.ClientTable["vehicleId"]]
        local price = tonumber(vehcTable["price"])

        if bought then
            local sellPrice = RCD.LocalPlayer:RCDCalculateSellPrice(RCD.ClientTable["vehiclesTable"], RCD.ClientTable["vehicleId"])
            pnl:SetValue(RCD.GetSentence("sell").." ("..RCD.formatMoney(sellPrice)..")")
        else
            pnl:SetValue((price <= 0 and RCD.GetSentence("buyForFree") or (string.upper(RCD.GetSentence("buyVehicle"))).." ("..RCD.formatMoney(price)..")"))
        end
    end
end

function RCD.SetVehicleParams(vehc, options, customization)
    if not IsValid(vehc) then return end
    if not istable(options) then return end

    if options["canChangeColor"] && istable(customization["vehicleColor"]) then
        
        vehc:SetColor(customization["vehicleColor"])
        vehc.RCDColor = customization["vehicleColor"]
    elseif istable(options["defaultColor"]) then

        vehc:SetColor(options["defaultColor"])
        vehc.RCDColor = options["defaultColor"]
    end

    if options["canChangeSkin"] && isnumber(customization["vehicleSkin"]) then

        vehc:SetSkin(customization["vehicleSkin"])
        if IsValid(vehc.Entity) then vehc.Entity:SetSkin(customization["vehicleSkin"]) end
    elseif isnumber(options["skin"]) then
        
        vehc:SetSkin(options["skin"])
        if IsValid(vehc.Entity) then vehc.Entity:SetSkin(options["skin"]) end
    end

    if options["canChangeBodygroup"] && istable(customization["vehicleBodygroups"]) then
        for k,v in pairs(customization["vehicleBodygroups"]) do
            if IsValid(vehc.Entity) then
                vehc.Entity:SetBodygroup(k, v)
            else
                vehc:SetBodygroup(k, v)
            end
        end
    end
end

function RCD.CountVehicleBought()
    local count = 0
    for k,v in pairs(RCD.ClientTable["vehiclesTable"]) do
        if not RCD.ClientTable["vehiclesBought"][k] then continue end

        count = count + 1
    end
    return count
end

function RCD.ReloadInformations()
    rightScroll:Clear()

    if not RCD.ClientTable["customize"] then
        local vehicleClass = RCD.ClientTable["vehicleSelected"]["class"]

        local vehcPath = RCD.VehiclesList[vehicleClass] or {}
        
        if istable(vehcPath["KeyValues"]) and isstring(vehcPath["KeyValues"]["vehiclescript"]) and file.Exists(vehcPath["KeyValues"]["vehiclescript"], "GAME") then
            local keyValues = file.Read(vehcPath["KeyValues"]["vehiclescript"], "GAME") or ""
    
            local explode = string.Explode("\n", keyValues) or {}
            local realExplode = {}
    
            for k,v in ipairs(explode) do
                local str = v:Trim()
                if str:StartWith('"') or str:StartWith("{") or str:StartWith("}") then
                    table.insert(realExplode, v:TrimRight())
                end
            end
    
            local str = table.concat(realExplode, "\n")
            vehcPath = util.KeyValuesToTable(str)
        end

        local options = RCD.ClientTable["vehicleSelected"]["options"] or {}
        local addonVehc = options["addon"] or "default"

        for k,v in ipairs(RCD.SettingsSlider[addonVehc] or {}) do
            local vehicleSettings = vgui.Create("RCD:SlideVehicle", rightScroll)
            vehicleSettings:Dock(TOP)
            vehicleSettings:DockMargin(RCD.ScrW*0.004, 0, RCD.ScrW*0.004, RCD.ScrH*0.01)
            vehicleSettings:SetText(RCD.GetSentence(v.name))
            vehicleSettings:SetMaxValue(v.max)
            vehicleSettings:SetActualValue(v.func(vehcPath))
        end
    else
        local options = RCD.ClientTable["vehicleSelected"]["options"] or {}
        RCD.ClientTable["canCustomize"] = false

        if options["canChangeColor"] then
            local priceColor = RCD.formatMoney(options["priceColor"] or 0)

            local vehicleColor = vgui.Create("RCD:Accordion", rightScroll)
            vehicleColor:SetSize(RCD.ScrW*0.1949, RCD.ScrH*0.03)
            vehicleColor:Dock(TOP)
            vehicleColor:DockMargin(RCD.ScrW*0.004, 0, RCD.ScrW*0.004, RCD.ScrH*0.005)
            vehicleColor:SetText("colors")
            vehicleColor:SetTextFont("RCD:Font:21")
            vehicleColor:SetRightTextFont("RCD:Font:21")
            vehicleColor:SetRightText(priceColor)
            vehicleColor:SetButtonTall(RCD.ScrH*0.03)
            timer.Simple(0, function()
                if not IsValid(vehicleColor) then return end
                vehicleColor:InitializeCategory("customizationColors", vehicleModel, true)
            end)

            RCD.ClientTable["canCustomize"] = true
        end 

        if options["canChangeUngerglow"] then
            local priceNeon = RCD.formatMoney(options["priceUnderglow"] or 0)

            local vehicleNeon = vgui.Create("RCD:Accordion", rightScroll)
            vehicleNeon:SetSize(RCD.ScrW*0.1949, RCD.ScrH*0.03)
            vehicleNeon:Dock(TOP)
            vehicleNeon:DockMargin(RCD.ScrW*0.004, 0, RCD.ScrW*0.004, RCD.ScrH*0.005)
            vehicleNeon:SetText("underglow")
            vehicleNeon:SetTextFont("RCD:Font:21")
            vehicleNeon:SetRightTextFont("RCD:Font:21")
            vehicleNeon:SetRightText(priceNeon)
            vehicleNeon:SetButtonTall(RCD.ScrH*0.03)
            timer.Simple(0, function()
                if not IsValid(vehicleNeon) then return end
                vehicleNeon:InitializeCategory("customizationNeon", vehicleModel, true)
            end)

            RCD.ClientTable["canCustomize"] = true
        end

        if options["canChangeSkin"] then
            local priceSkin = RCD.formatMoney(options["priceSkin"] or 0)

            local vehicleSkin = vgui.Create("RCD:Accordion", rightScroll)
            vehicleSkin:SetSize(RCD.ScrW*0.1949, RCD.ScrH*0.03)
            vehicleSkin:Dock(TOP)
            vehicleSkin:DockMargin(RCD.ScrW*0.004, 0, RCD.ScrW*0.004, RCD.ScrH*0.005)
            vehicleSkin:SetText("skins")
            vehicleSkin:SetTextFont("RCD:Font:21")
            vehicleSkin:SetRightTextFont("RCD:Font:21")
            vehicleSkin:SetRightText(priceSkin)
            vehicleSkin:SetButtonTall(RCD.ScrH*0.03)
            timer.Simple(0, function()
                if not IsValid(vehicleSkin) then return end
                vehicleSkin:InitializeCategory("customizationSkin", vehicleModel, true)
            end)

            RCD.ClientTable["canCustomize"] = true
        end

        if options["canChangeBodygroup"] then
            local priceBody = RCD.formatMoney(options["priceBodygroup"] or 0)

            local vehicleBodygroup = vgui.Create("RCD:Accordion", rightScroll)
            vehicleBodygroup:SetSize(RCD.ScrW*0.1949, RCD.ScrH*0.03)
            vehicleBodygroup:Dock(TOP)
            vehicleBodygroup:DockMargin(RCD.ScrW*0.004, 0, RCD.ScrW*0.004, RCD.ScrH*0.005)
            vehicleBodygroup:SetText("bodygroups")
            vehicleBodygroup:SetTextFont("RCD:Font:21")
            vehicleBodygroup:SetRightTextFont("RCD:Font:21")
            vehicleBodygroup:SetRightText(priceBody)
            vehicleBodygroup:SetButtonTall(RCD.ScrH*0.03)
            timer.Simple(0, function()
                if not IsValid(vehicleBodygroup) then return end
                vehicleBodygroup:InitializeCategory("customizationBodygroups", vehicleModel, true)
            end)

            RCD.ClientTable["canCustomize"] = true
        end

        if options["canBuyNitro"] then
            local priceNitro = RCD.formatMoney(options["priceNitro"]) or 0

            local vehicleNitro = vgui.Create("RCD:Accordion", rightScroll)
            vehicleNitro:SetSize(RCD.ScrW*0.1949, RCD.ScrH*0.03)
            vehicleNitro:Dock(TOP)
            vehicleNitro:DockMargin(RCD.ScrW*0.004, 0, RCD.ScrW*0.004, RCD.ScrH*0.005)
            vehicleNitro:SetText("nitro")
            vehicleNitro:SetTextFont("RCD:Font:21")
            vehicleNitro:SetRightTextFont("RCD:Font:21")
            vehicleNitro:SetRightText(priceNitro)
            vehicleNitro:SetButtonTall(RCD.ScrH*0.03)
            timer.Simple(0, function()
                if not IsValid(vehicleNitro) then return end
                vehicleNitro:InitializeCategory("customizationNitro", vehicleModel, true)
            end)

            RCD.ClientTable["canCustomize"] = true
        end
    end
end

local function setVehicleSelected(id, withoutAnimations)
    if not IsValid(vehicleModel) then return end

    for k,v in pairs(vehicleModel.Vehicles or {}) do
        if vehicleModel.Vehicles[k].RCDId != id then continue end

        if not istable(RCD.ClientTable["vehiclesTable"]) then return end
        if not istable(RCD.ClientTable["vehiclesTable"][k]) then continue end

        if RCD.ClientTable["customize"] && not istable(RCD.ClientTable["vehiclesBought"][k]) then continue end

        RCD.ClientTable["vehicleId"] = v.RCDInfo["id"]
        RCD.ClientTable["vehicleSelected"] = RCD.ClientTable["vehiclesTable"][k]
        RCD.ClientTable["carrouselId"] = id
        RCD.ClientTable["disableModelAnimations"] = withoutAnimations or false

        local vehButton = RCD.ClientTable["vehicleButtons"][id]
        if withoutAnimations then
            vehicleScroll:ScrollToChild(vehButton)
            vehicleScroll.RCDScrollPos, vehicleScroll.RCDLerpScrollPos = vehicleScroll.OffsetX, vehicleScroll.OffsetX
        else
            vehicleScroll.RCDScrollPos, vehicleScroll.RCDLerpScrollPos = (select(1, vehicleScroll.pnlCanvas:GetChildPosition(vehButton)) + vehButton:GetWide()*0.875) - vehicleScroll:GetWide()*0.5, vehicleScroll.OffsetX
        end

        local params = RCD.ClientTable["vehicleSelected"]["options"]
        vehicleModel:SetParams(params, vehicleModel.Vehicles[k])
        vehicleModel:SetFocusEntity(vehicleModel.Vehicles[k], withoutAnimations)
        RCD.ReloadInformations()
        
        if RCD.ClientTable["vehiclesBought"] and RCD.ClientTable["vehiclesBought"][k] then
            RCD.SetVehicleParams(vehicleModel.Vehicles[k], params, RCD.ClientTable["vehiclesBought"][k]["customization"])
        end

        break
    end
end

--[[ Create all wheels on all dmodel for some models ]]--
function RCD.GenerateWheels(ent, class)
    if not IsValid(ent) then return end

    local tbl = list.Get("simfphys_vehicles")
    if not tbl[class] then return end

    if ent["wheels"] then
        for k, wheel in ipairs(ent["wheels"]) do
            if not IsValid(wheel) then continue end

            wheel:Remove()
            ent["wheels"] = {}
        end
    end

    if tbl[class]["Members"] && tbl[class]["Members"].CustomWheels then
        local wheelsPos = {
            tbl[class]["Members"].CustomWheelPosFL,
            tbl[class]["Members"].CustomWheelPosFR,
            tbl[class]["Members"].CustomWheelPosRL,
            tbl[class]["Members"].CustomWheelPosRR
        }

        local wheelsAngle = tbl[class]["Members"].CustomWheelAngleOffset or RCD.Constants["angleOrigin"]
        local CustomWheelModel = tbl[class]["Members"].CustomWheelModel or "models/props_phx/wheels/magnetic_small.mdl"

        ent["wheels"] = {}
        for i=1, 4 do
            if not isvector(wheelsPos[i]) then continue end
            
            ent["wheels"][i] = ClientsideModel(CustomWheelModel, RENDERGROUP_OPAQUE)
            ent["wheels"][i]:SetNoDraw(true)
            ent["wheels"][i]:SetPos(ent:LocalToWorld(wheelsPos[i]))
            ent["wheels"][i]:SetAngles(ent:LocalToWorldAngles(wheelsAngle) + (i%2 == 0 and RCD.Constants["angleWheel"] or RCD.Constants["angleOrigin"]))
            
            if tbl[class].SpawnAngleOffset then
                ent["wheels"][i]:SetAngles(ent["wheels"][i]:GetAngles() + Angle(0, tbl[class].SpawnAngleOffset, 0))
            end

            ent["wheels"][i]:SetParent(ent)
        end
    else
        local wheelsPos = {
            ent:GetAttachment(ent:LookupAttachment("wheel_fl")),
            ent:GetAttachment(ent:LookupAttachment("wheel_fr")),
            ent:GetAttachment(ent:LookupAttachment("wheel_rl")),
            ent:GetAttachment(ent:LookupAttachment("wheel_rr")),
        }

        local CustomWheelModel = (tbl[class].CustomWheelModel_R and (index == 3 or index == 4 or index == 5 or index == 6)) and tbl[class].CustomWheelModel_R or tbl[class].CustomWheelModel

        for i=1, 4 do
            if not isvector(wheelsPos[i]) then continue end
            
            ent["wheels"][i] = ClientsideModel(CustomWheelModel, RENDERGROUP_OPAQUE)
            ent["wheels"][i]:SetNoDraw(true)
            ent["wheels"][i]:SetPos(ent:LocalToWorld(wheelsPos[i]["Pos"]))
            ent["wheels"][i]:SetAngles(ent:LocalToWorldAngles(wheelsPos[i]["Ang"]))
            ent["wheels"][i]:SetParent(ent)
        end
    end
end

--[[ Reload the right scroll on the customization and the buyer menu ]]
function RCD.ReloadVehiclesList(customize)
    if not IsValid(vehicleScroll) then return end
    
    RCD.ClientTable["customize"] = customize
    
    vehicleScroll:Clear()
    
    local carrouselIds, carrouselId = {}, 0

    RCD.ClientTable["vehicleButtons"] = {}
    for k,v in SortedPairsByMemberValue(RCD.ClientTable["vehiclesTable"], "price", false) do
        vehicleModel.Vehicles = vehicleModel.Vehicles or {}
        
        if IsValid(vehicleModel.Vehicles[v.id]) then 
            vehicleModel.Vehicles[v.id]:Remove() 
            vehicleModel.Vehicles[v.id] = nil
        end
        
        if RCD.ClientTable["vehicleId"] != v.id or customize then
            if RCD.ClientTable["vehiclesBought"][k] && not checkBoxInfo["owned"] then continue end
            if not RCD.ClientTable["vehiclesBought"][k] && not checkBoxInfo["forSale"] then continue end
            if not checkBoxInfo["allowed"] && not RCD.LocalPlayer:RCDCanAccessVehicle(v.id) then continue end
            if RCD.ClientTable["customize"] && not RCD.ClientTable["vehiclesBought"][k] then continue end
        end

        carrouselId = carrouselId + 1
        carrouselIds[v.id] = carrouselId

        local vehc = RCD.VehiclesList[v.class] or {}
        local model = vehc["Model"] or ""

        local vehicleButton = vgui.Create("RCD:VehicleButton", vehicleScroll)
        vehicleButton:SetSize(RCD.ScrW*0.1949, RCD.ScrH*0.05)
        vehicleButton:InclineButton(RCD.ScrW*0.055)
        vehicleButton:Dock(LEFT)
        vehicleButton:DockMargin(0, 0, -RCD.ScrW*0.048, 0)
        vehicleButton:SetButtonColor(RCD.Colors["white30"])
        vehicleButton:SetModel(model)
        vehicleButton:SetPrice(v.price)
        vehicleButton:SetName(v.name)
        vehicleButton:SetUniqueId(v.id)
        vehicleButton.vehicleModel:RCDSetFOVBase(55)
        vehicleButton.DoClick = function()
            setVehicleSelected(vehicleModel.Vehicles[v.id].RCDId)
            reloadInteractionButton(buyButton)

            RCD.ClientTable["carouselId"] = carouselId
        end
        vehicleButton.vehicleModel.DoClick = function()
            setVehicleSelected(vehicleModel.Vehicles[v.id].RCDId)
            reloadInteractionButton(buyButton)
            
            RCD.ClientTable["carouselId"] = carouselId
        end
        vehicleButton.Think = function()
            vehicleButton:SetSelectedButton(v.id == RCD.ClientTable["vehicleId"])
        end
        
        vehicleScroll:AddPanel(vehicleButton)
        RCD.ClientTable["vehicleButtons"][carrouselId] = vehicleButton
        
        vehicleModel.Vehicles[v.id] = ClientsideModel(model, RENDER_GROUP_OPAQUE)
        
        if not IsValid(vehicleModel.Vehicles[v.id]) then continue end
        vehicleModel.Vehicles[v.id]:SetNoDraw(true)
        vehicleModel.Vehicles[v.id]:SetPos(Vector(0, 500*carrouselId-500, 0))
        vehicleModel.Vehicles[v.id]:AddEffects(EF_BONEMERGE)
        vehicleModel.Vehicles[v.id].RCDColor = RCD.Colors["white"]
        vehicleModel.Vehicles[v.id].RCDUnderglow = nil
        vehicleModel.Vehicles[v.id].RCDId = carrouselId
        vehicleModel.Vehicles[v.id].RCDInfo = v
        if isangle(v.options["angle"]) then
            vehicleModel.Vehicles[v.id]:SetAngles(v.options["angle"] + RCD.Constants["angleParams"])
        end

        if v.options["addon"] == "simfphys" then
            RCD.GenerateWheels(vehicleModel.Vehicles[v.id], v.class)
            RCD.GenerateWheels(vehicleButton.vehicleModel.Entity, v.class)
        end
        
        vehicleButton.vehicleModel:SetParams(v.options, vehicleButton.vehicleModel.Entity, true, true)
        RCD.SetVehicleParams(vehicleModel.Vehicles[v.id], v.options or {}, (RCD.ClientTable["vehiclesBought"][v.id] and RCD.ClientTable["vehiclesBought"][v.id]["customization"] or {}))
        RCD.SetVehicleParams(vehicleButton.vehicleModel, v.options or {}, (RCD.ClientTable["vehiclesBought"][v.id] and RCD.ClientTable["vehiclesBought"][v.id]["customization"] or {}))
    end
    if isnumber(RCD.ClientTable["vehicleId"]) && carrouselIds[RCD.ClientTable["vehicleId"]] then
        setVehicleSelected(carrouselIds[RCD.ClientTable["vehicleId"]], true)
    else
        setVehicleSelected(1, true)
    end

    if carrouselId < 6 then
        for i=1, 6-carrouselId do
            local fakeButton = vgui.Create("RCD:VehicleButton", vehicleScroll)
            fakeButton:SetSize(RCD.ScrW*0.1949, RCD.ScrH*0.05)
            fakeButton:InclineButton(RCD.ScrW*0.055)
            fakeButton:Dock(LEFT)
            fakeButton:DockMargin(0, 0, -RCD.ScrW*0.048, 0)
            fakeButton:SetButtonColor(RCD.Colors["white30"])
            fakeButton:SetFake(true)

            vehicleScroll:AddPanel(fakeButton)
        end
    end

    RCD.ReloadButtons()
end

--[[ Reload buy/sell/customize buttons ]]
function RCD.ReloadButtons()
    rightScroll:DockMargin(0, RCD.ScrH*0.008, 0, RCD.ScrH*0.11)
    rightScrollDown:DockMargin(0, RCD.ScrH*0.496, 0, 0)
    rightScrollDown:Clear()

    local spawnButton = vgui.Create("RCD:Button", rightScrollDown)
    spawnButton:SetSize(rightPanel:GetWide()-RCD.ScrW*0.01, RCD.ScrW*0.026)
    spawnButton:Dock(TOP)
    spawnButton:DockMargin(RCD.ScrW*0.004, 0, RCD.ScrW*0.004, RCD.ScrH*0.007)
    spawnButton:SetIconMaterial(RCD.Materials["icon_leave"])
    spawnButton:SetHoveredColor(RCD.Colors["grey30"])
    spawnButton:SetBackgroundColor(RCD.Colors["grey30"])
    spawnButton.RCDMinMaxLerp = {20, 40}
    spawnButton:SetValue(RCD.GetSentence("spawnVehicle"))
    spawnButton.Think = function()
        if RCD.LocalPlayer:RCDIsVehicleSpawned(RCD.ClientTable["vehicleId"]) then
            spawnButton:SetValue(RCD.GetSentence("bringBack"))
        else
            local bought = RCD.ClientTable["vehiclesBought"][RCD.ClientTable["vehicleId"]]
    
            spawnButton:SetValue((bought and RCD.GetSentence("spawnVehicle") or RCD.GetSentence("testVehicle")))
        end
    end
    spawnButton.DoClick = function()
        if RCD.LocalPlayer:RCDIsVehicleSpawned(RCD.ClientTable["vehicleId"]) then
            net.Start("RCD:Main:Client")
                net.WriteUInt(4, 4)
                net.WriteUInt(RCD.ClientTable["vehicleId"], 32)
            net.SendToServer()
        else
            local bought = RCD.ClientTable["vehiclesBought"][RCD.ClientTable["vehicleId"]]
    
            net.Start("RCD:Main:Client")
                net.WriteUInt((bought and 2 or 3), 4)
                net.WriteUInt(RCD.ClientTable["vehicleId"], 32)
            net.SendToServer()
        end
    end

    buyButton = vgui.Create("RCD:Button", rightScrollDown)
    buyButton:SetSize(rightPanel:GetWide()-RCD.ScrW*0.01, RCD.ScrW*0.026)
    buyButton:Dock(TOP)
    buyButton:DockMargin(RCD.ScrW*0.004, 0, RCD.ScrW*0.004, RCD.ScrH*0.007)
    buyButton:SetIconMaterial(RCD.Materials["icon_money"])
    buyButton:SetHoveredColor(RCD.Colors["white80"])
    buyButton:SetBackgroundColor(RCD.Colors["purple120"])
    buyButton.RCDMinMaxLerp = {60, 120}
    buyButton.DoClick = function(self)
        if RCD.ClientTable["customize"] then
            local hasColor = istable(RCD.customization["vehicleColor"])
            local hasUnderglow = istable(RCD.customization["vehicleUnderglow"])

            local vehicleColor = RCD.Colors["white"] 
            if hasColor then
                vehicleColor = Color(RCD.customization["vehicleColor"].r, RCD.customization["vehicleColor"].g, RCD.customization["vehicleColor"].b)
            end

            local vehicleUnderglow = RCD.Colors["white"] 
            if hasUnderglow then
                vehicleUnderglow = Color(RCD.customization["vehicleUnderglow"].r, RCD.customization["vehicleUnderglow"].g, RCD.customization["vehicleUnderglow"].b)
            end

            net.Start("RCD:Main:Client")
                net.WriteUInt(5, 4)
                net.WriteUInt(RCD.ClientTable["vehicleId"], 32)
                net.WriteUInt((RCD.customization["vehicleSkin"] or 0), 8)
                net.WriteUInt((RCD.customization["vehicleNitro"] or 0), 2)
                net.WriteBool(hasColor)
                net.WriteColor(vehicleColor)
                net.WriteBool(hasUnderglow)
                net.WriteColor(vehicleUnderglow)
                local vehicleBodygroups = RCD.customization["vehicleBodygroups"] or {}
                net.WriteUInt(table.Count(vehicleBodygroups), 8)
                for k,v in pairs(vehicleBodygroups) do
                    net.WriteUInt(k, 8)
                    net.WriteUInt(v, 8)
                end 
            net.SendToServer()
        else
            local check = RCD.LocalPlayer:RCDCanAccessVehicle(RCD.ClientTable["vehicleId"])

            if self:GetValue() == RCD.GetSentence("areYouSure") or not check then
                local bought = RCD.ClientTable["vehiclesBought"][RCD.ClientTable["vehicleId"]]
                
                net.Start("RCD:Main:Client")
                    net.WriteUInt(1, 4)
                    net.WriteBool(bought)
                    net.WriteUInt(RCD.ClientTable["vehicleId"], 32)
                net.SendToServer()

                return
            end

            if check then
                self:SetValue(RCD.GetSentence("areYouSure"))
            end

            timer.Simple(1, function()
                reloadInteractionButton(buyButton)
            end)
        end
    end
    buyButton.Think = function(self)
        if RCD.ClientTable["customize"] then
            local price = tonumber(RCD.ClientTable["priceCustomization"]) or 0

            self:SetValue(RCD.GetSentence("customize"):format(RCD.formatMoney(price)))
        end
    end
    reloadInteractionButton(buyButton)
end

hook.Add("RCD:VehicleSold", "RCD:VehicleSold:ReloadButton", function(vehicleId)
    reloadInteractionButton(buyButton)
    RCD.ReloadVehiclesList()
end)

hook.Add("RCD:VehicleBought", "RCD:VehicleBought:ReloadButton", function(vehicleId)
    reloadInteractionButton(buyButton)
end)

function RCD.BaseFrame(base, noAnim)
    if IsValid(RCDMainFrame) then RCDMainFrame:Remove() end
    
    RCDMainFrame = vgui.Create("DFrame")
    RCDMainFrame:SetSize(RCD.ScrW, RCD.ScrH)
    RCDMainFrame:SetDraggable(false)
    RCDMainFrame:ShowCloseButton(false)
    RCDMainFrame:MakePopup()
    RCDMainFrame:SetTitle("")
    RCDMainFrame.startTime = SysTime()
    RCDMainFrame.Paint = function(self,w,h)
        RCD.DrawBlur(self, 15)
        Derma_DrawBackgroundBlur(self, (!noAnim and self.startTime or 0))

        surface.SetDrawColor(RCD.Colors["white220"])
        surface.SetMaterial(RCD.Materials["background"])
        surface.DrawTexturedRect(0, 0, w, h)

        surface.SetFont("RCD:Font:01")
        local textSize = surface.GetTextSize(base)
        
        draw.DrawText(base, "RCD:Font:01", w*0.04, h*0.04, RCD.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText(" - "..(RCD.ClientTable["customize"] and RCD.GetSentence("customizationTitle") or RCD.GetSentence("mainMenuTitle")), "RCD:Font:02", w*0.043 + textSize, h*0.04, RCD.Colors["white"], TEXT_ALIGN_LEFT)
        draw.DrawText((RCD.ClientTable["customize"] and RCD.GetSentence("modifyVehicle") or RCD.GetSentence("buySaleVehicles")), "RCD:Font:03", w*0.04, h*0.09, RCD.Colors["white100"], TEXT_ALIGN_LEFT)
        
        surface.SetFont("RCD:Font:05")
        local textSize = surface.GetTextSize(RCD.ClientTable["vehicleSelected"]["name"])
        
        local check = !RCD.LocalPlayer:RCDCanAccessVehicle(RCD.ClientTable["vehicleId"])
        RCD.DrawCircle(w*0.408 - textSize/2, h*0.681, h*0.011, 0, 360, RCD.Colors[(check and "yellow" or "purple")])

        surface.SetDrawColor(RCD.Colors["white"])
        surface.SetMaterial(RCD.Materials[(check and "icon_star" or "icon_check")])
        surface.DrawTexturedRect(w*0.408 - textSize/2 - h*0.015/2, h*0.681-h*0.015/2, h*0.015, h*0.015)

        draw.SimpleText(RCD.ClientTable["vehicleSelected"]["name"], "RCD:Font:05", w*0.42, h*0.68, RCD.Colors["white"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        RCD.DrawNotification()
    end
end

function RCD.MainMenu(customize, noAnim)
    RCD.ClientTable["customize"] = customize

    if not noAnim then
        RCD.ClientTable["vehicleId"] = nil
        RCD.ClientTable["disableModelAnimations"] = false
    end

    RCD.BaseFrame(string.upper(RCD.GetSentence("carDealer")), noAnim)
    if RCD.ClientTable["customize"] then RCD.ClientTable["priceCustomization"] = 0 end

    --[[ This scroll permit to add all button on the top right of the screen ]]
    local buttonScroll = vgui.Create("DHorizontalScroller", RCDMainFrame)
    buttonScroll:SetSize(RCD.ScrW*0.3, RCD.ScrH*0.046)
    buttonScroll:SetPos(RCD.ScrW*0.68, RCD.ScrH*0.05)

    for k,v in ipairs(RCD.BaseButton) do
        local mainButton = vgui.Create("RCD:SlideButton", buttonScroll)
        mainButton:SetSize(RCD.ScrH*0.062, RCD.ScrH*0.05)
        mainButton:InclineButton(RCD.ScrW*0.01)
        mainButton:Dock(RIGHT)
        mainButton:DockMargin(-RCD.ScrW*0.007, 0, 0, 0)
        mainButton:SetButtonColor(RCD.Colors["purple120"])
        mainButton:SetIconColor(RCD.Colors["white80"])
        mainButton:SetIconMaterial(v.mat)
        mainButton.DoClick = function()
            v.func(RCDMainFrame)
        end
        mainButton.MinMaxLerp = {60, 120}
    end
    
    local className = RCD.ClientTable["vehicleSelected"]["class"]

    --[[ Create the money button on the top right of the screen ]]
    local moneyButton = vgui.Create("RCD:SlideButton", buttonScroll)
    moneyButton:SetSize(RCD.ScrH*0.17, RCD.ScrH*0.05)
    moneyButton:InclineButton(RCD.ScrW*0.01)
    moneyButton:Dock(RIGHT)
    moneyButton:DockMargin(-RCD.ScrW*0.007, 0, 0, 0)
    moneyButton:SetButtonColor(RCD.Colors["purple120"])
    moneyButton:SetIconColor(RCD.Colors["white80"])
    moneyButton:SetCustomIconPos(moneyButton:GetWide()*0.14)
    moneyButton:SetIconMaterial(RCD.Materials["icon_money"])
    moneyButton.PaintOver = function(self,w,h)
        local money = RCD.formatMoney(RCD.LocalPlayer:RCDGetMoney())
        moneyButton:SetValue(money)

        surface.SetFont("RCD:Font:04")
        local size = surface.GetTextSize(money)
        
        moneyButton:SetSize(RCD.ScrW*0.05 + size, RCD.ScrH*0.05)
    end
    moneyButton.MinMaxLerp = {60, 120}

    local vehc = RCD.VehiclesList[className] or {}
    local model = vehc["Model"] or ""

    vehicleModel = vgui.Create("RCD:DModel", RCDMainFrame)
    vehicleModel:SetModel(model)
    vehicleModel:SetSize(RCD.ScrW*0.81, RCD.ScrH*0.6)
    vehicleModel:SetPos(0, RCD.ScrH*0.1)
    vehicleModel:SetFOV(45)

    vehicleModel.PaintOver = function(self,w,h)
        if not RCD.LocalPlayer:RCDCanAccessVehicle(RCD.ClientTable["vehicleId"]) then
            surface.SetDrawColor(RCD.Colors["white100"])
            surface.SetMaterial(RCD.Materials["lock"])
            surface.DrawTexturedRect(w/2-h*0.14, h/2-h*0.15, h*0.29, h*0.3)
        end
    end

    local lerpVehicle = RCD.ClientTable["carrouselId"]
    function vehicleModel:DrawModel()
        local curparent = self
        local leftx, topy = self:LocalToScreen(0, 0)
        local rightx, bottomy = self:LocalToScreen(self:GetWide(), self:GetTall())
        while (curparent:GetParent() != nil) do
            curparent = curparent:GetParent()
    
            local x1, y1 = curparent:LocalToScreen(0, 0)
            local x2, y2 = curparent:LocalToScreen(curparent:GetWide(), curparent:GetTall())
    
            leftx = math.max(leftx, x1)
            topy = math.max(topy, y1)
            rightx = math.min(rightx, x2)
            bottomy = math.min(bottomy, y2)
            previous = curparent
        end
    
        render.SetScissorRect(leftx, topy, rightx, bottomy, true)
        
        for k,v in pairs(self.Vehicles or {}) do
            local color = v.RCDColor or color_white

            render.SetColorModulation(color.r/255, color.g/255, color.b/255)
            v:DrawModel()

            if istable(v.wheels) then
                for k, wheel in ipairs(v.wheels) do
                    wheel:DrawModel()  
                end
            end       
        end
        
        local mn, mx = self.Entity:GetRenderBounds()
        local size = 0
        size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
        size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
        size = math.max(size, math.abs(mn.z) + math.abs(mx.z))

        lerpVehicle = RCD.ClientTable["disableModelAnimations"] and RCD.ClientTable["carrouselId"] or Lerp(FrameTime()*3, lerpVehicle, RCD.ClientTable["carrouselId"])
        
        vehicleModel:SetCamPos(Vector(200+size, 500*lerpVehicle-500, 110))
        vehicleModel:SetLookAt(Vector(0, 500*lerpVehicle-500, 0) + self.RCDLerpVector)

        render.SetScissorRect(0, 0, 0, 0, false)
    end

    local downPanel = vgui.Create("DPanel", RCDMainFrame)
    downPanel:SetSize(RCD.ScrW*0.968, RCD.ScrH*0.035)
    downPanel:SetPos(0, RCD.ScrH*0.741)
    downPanel.Paint = function(self,w,h)
        self.RCDPoly = {
            {x = 0, y = 0},
            {x = w, y = 0},
            {x = w-RCD.ScrW*0.012, y = h},
            {x = 0, y = h},
        }

        surface.SetDrawColor(RCD.Colors["white30"])
        draw.NoTexture()
        surface.DrawPoly(self.RCDPoly)
        
        draw.SimpleText(RCD.GetSentence("vehicleOwned"), "RCD:Font:06", w*0.066, h/2, RCD.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(RCD.GetSentence("vehicleForSale"), "RCD:Font:06", w*0.186, h/2, RCD.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(RCD.GetSentence("allowed"), "RCD:Font:06", w*0.306, h/2, RCD.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    
    rightPanel = vgui.Create("DPanel", RCDMainFrame)
    rightPanel:SetSize(RCD.ScrW*0.156, RCD.ScrH*0.6)
    rightPanel:SetPos(downPanel:GetWide()-rightPanel:GetWide(), RCD.ScrH*0.128)
    rightPanel.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, 0, w, h, RCD.Colors["white30"])

        surface.SetDrawColor(RCD.Colors["white30"])
        surface.SetMaterial(RCD.Materials["logo"])
        surface.DrawTexturedRect(w/2-h*0.15, h/2-h*0.15, h*0.3, h*0.3)
    end

    local lerpText = 0
    --[[ This scroll permit to draw all settings of the vehicle ]]
    rightScroll = vgui.Create("RCD:DScroll", rightPanel)
    rightScroll:Dock(FILL)
    rightScroll:DockMargin(0, RCD.ScrH*0.008, 0, (RCD.ClientTable["customize"] and RCD.ScrH*0.06 or RCD.ScrH*0.1))
    rightScroll.PaintOver = function(self,w,h)
        local drawText = (not RCD.ClientTable["canCustomize"] && RCD.ClientTable["customize"])
        
        if drawText then
            lerpText = Lerp(FrameTime()*3, lerpText, drawText and 255 or 0)
            draw.DrawText(RCD.GetSentence("cantCustomizeVehicle"), "RCD:Font:04", w*0.5, h*0.06, ColorAlpha(RCD.Colors["white"], lerpText), TEXT_ALIGN_CENTER)
        else
            lerpText = 0
        end
    end

    --[[ This scroll permit to draw buy/spawn/sell buttons ]]
    rightScrollDown = vgui.Create("DScrollPanel", rightPanel)
    rightScrollDown:Dock(FILL)
    rightScrollDown:GetVBar():SetWide(0)

    RCD.ReloadInformations()

    --[[ This is the fake button just for the design we don't need to touch it ]]
    local fakeButton = vgui.Create("RCD:SlideButton", RCDMainFrame)
    fakeButton:SetSize(RCD.ScrW*0.195, RCD.ScrH*0.15)
    fakeButton:SetPos(-RCD.ScrW*0.1225, RCD.ScrH*0.787)
    fakeButton:InclineButton(RCD.ScrW*0.055)
    fakeButton:SetButtonColor(RCD.Colors["white30"])
    fakeButton:SetIconMaterial(nil)
    fakeButton.MinMaxLerp = {5, 5}

    local leftArrow = vgui.Create("DButton", RCDMainFrame)
    leftArrow:SetSize(RCD.ScrW*0.021, RCD.ScrH*0.037)
    leftArrow:SetPos(RCD.ScrW*0.035, RCD.ScrH*0.4)
    leftArrow:SetText("")
    leftArrow.Paint = function(self,w,h)
        surface.SetDrawColor(RCD.Colors["white100"])
        surface.SetMaterial(RCD.Materials["left_vehicle"])
        surface.DrawTexturedRect(0, 0, w, h)    
    end
    leftArrow.DoClick = function()
        setVehicleSelected(RCD.ClientTable["carrouselId"] - 1)
    end

    local rightArrow = vgui.Create("DButton", RCDMainFrame)
    rightArrow:SetSize(RCD.ScrW*0.021, RCD.ScrH*0.037)
    rightArrow:SetPos(RCD.ScrW*0.75, RCD.ScrH*0.4)
    rightArrow:SetText("")
    rightArrow.Paint = function(self,w,h)
        surface.SetDrawColor(RCD.Colors["white100"])
        surface.SetMaterial(RCD.Materials["right_vehicle"])
        surface.DrawTexturedRect(0, 0, w, h)  
    end
    rightArrow.DoClick = function()
        setVehicleSelected(RCD.ClientTable["carrouselId"] + 1)
    end
    
    --[[ This is the scroll where all vehicle are draw ]]
    vehicleScroll = vgui.Create("DHorizontalScroller", RCDMainFrame)
    vehicleScroll:SetSize(RCD.ScrW*0.968-RCD.ScrW*0.04, RCD.ScrH*0.15)
    vehicleScroll:SetPos(RCD.ScrW*0.025, RCD.ScrH*0.787)
    vehicleScroll:SetOverlap(-1)
    vehicleScroll:SetOverlap(RCD.ScrW*0.048)
    vehicleScroll.btnLeft.Paint = function() end
    vehicleScroll.btnRight.Paint = function() end
    vehicleScroll.OnMouseWheeled = function(self, dlta)
        self.RCDScrollPos = (self.OffsetX + dlta * -125)
    end
    
    local StencilPoly = {
        {x = RCD.ScrW*0.055, y = 0},
        {x = vehicleScroll:GetWide(), y = 0},
        {x = vehicleScroll:GetWide()-RCD.ScrW*0.055, y = vehicleScroll:GetTall()},
        {x = 0, y = vehicleScroll:GetTall()},
    }
    vehicleScroll.Paint = function(self,w,h)
        -- Set the scroll X 
        if isnumber(vehicleScroll.RCDScrollPos) then
            vehicleScroll.RCDLerpScrollPos = Lerp(FrameTime()*3, vehicleScroll.RCDLerpScrollPos or vehicleScroll.OffsetX, vehicleScroll.RCDScrollPos)
            vehicleScroll:SetScroll(vehicleScroll.RCDLerpScrollPos)
        end

        render.SetStencilWriteMask(0xFF)
        render.SetStencilTestMask(0xFF)
        render.SetStencilReferenceValue(0)
        render.SetStencilPassOperation(STENCIL_KEEP)
        render.SetStencilZFailOperation(STENCIL_KEEP)
        render.ClearStencil()

        render.SetStencilEnable(true)
        render.SetStencilReferenceValue(1)
        render.SetStencilCompareFunction(STENCIL_NEVER)
        render.SetStencilFailOperation(STENCIL_REPLACE)

        draw.NoTexture()
        surface.SetDrawColor(RCD.Colors["white"])
        surface.DrawPoly(StencilPoly)

        render.SetStencilCompareFunction(STENCIL_EQUAL)
        render.SetStencilFailOperation(STENCIL_KEEP)
        
        if not IsFirstTimePredicted() then return end
        vehicleScroll.pnlCanvas:PaintManuel()

        render.SetStencilEnable(false)
    end
    vehicleScroll.oldMouseWheeled = vehicleScroll.OnMouseWheeled
    vehicleScroll.OnMouseWheeled = function(self, dlta)

        if isnumber(vehicleScroll.RCDScrollPos) then
            vehicleScroll.RCDScrollPos = nil
        end

        self.oldMouseWheeled(self, dlta)
    end

    checkBoxInfo = {
        ["owned"] = true,
        ["forSale"] = true,
        ["allowed"] = true,
    }

    RCD.ReloadVehiclesList(RCD.ClientTable["customize"])
    
    --[[ Here you can find all checkBox ]]
    local vehicleOwned = vgui.Create("RCD:Toggle", downPanel)
    vehicleOwned:SetPos(RCD.ScrW*0.035, downPanel:GetTall()/2 - vehicleOwned:GetTall()/2)
    function vehicleOwned:OnChange()
        checkBoxInfo["owned"] = vehicleOwned:GetStatut()

        RCD.ReloadVehiclesList(RCD.ClientTable["customize"])
    end

    local vehicleforSale = vgui.Create("RCD:Toggle", downPanel)
    vehicleforSale:SetPos(RCD.ScrW*0.15, downPanel:GetTall()/2 - vehicleforSale:GetTall()/2)
    function vehicleforSale:OnChange()
        checkBoxInfo["forSale"] = vehicleforSale:GetStatut()

        RCD.ReloadVehiclesList(RCD.ClientTable["customize"])
    end

    local vehicleAllowed = vgui.Create("RCD:Toggle", downPanel)
    vehicleAllowed:SetPos(RCD.ScrW*0.268, downPanel:GetTall()/2 - vehicleforSale:GetTall()/2)
    function vehicleAllowed:OnChange()
        checkBoxInfo["allowed"] = vehicleAllowed:GetStatut()

        RCD.ReloadVehiclesList(RCD.ClientTable["customize"])
    end   
end

local timeTest = 0
hook.Add("HUDPaint", "RCD:HUDPaint:TestVehicle", function()
    local curTime = CurTime()
    if timeTest < curTime then return end

    surface.SetDrawColor(RCD.Colors["white"])
	surface.SetMaterial(RCD.Materials["test_drive"])
	surface.DrawTexturedRect(RCD.ScrW*0.005, RCD.ScrH*0.1, RCD.ScrW*0.23, RCD.ScrH*0.09)

    draw.DrawText(RCD.GetSentence("testDrive"), "RCD:Font:10", RCD.ScrW*0.055, RCD.ScrH*0.112, RCD.Colors["white"], TEXT_ALIGN_LEFT)
    draw.DrawText(RCD.GetSentence("testDriveEnd"):format(math.Round(timeTest - curTime)), "RCD:Font:11", RCD.ScrW*0.055, RCD.ScrH*0.145, RCD.Colors["white"], TEXT_ALIGN_LEFT)

    draw.RoundedBox(0, RCD.ScrW*0.003, RCD.ScrH*0.1, RCD.ScrW*0.004, RCD.ScrH*0.09, RCD.Colors["purple"])
end)

hook.Add("HUDPaint", "RCD:HUDPaint:LoadVehicleList", function()
    RCD.VehiclesList = RCD.GetAllVehicles() or {}
    RCD.LocalPlayer = LocalPlayer()

    hook.Remove("HUDPaint", "RCD:HUDPaint:LoadVehicleList")
end)

local syncNWCooldown = 0
hook.Add("Think", "RCD:Client:Think", function()
    if not IsValid(RCD.LocalPlayer) then return end
    RCD["vehiclesSpawned"] = RCD["vehiclesSpawned"] or {}

    local curTime = CurTime()
    for k,v in pairs(RCD["vehiclesSpawned"]) do
        if not IsValid(k) then continue end
        
        local activate = RCD.GetNWVariables("RCDUnderGlowActivate", k)
        if not activate then 
            continue 
        end

        local underglow = RCD.GetNWVariables("RCDUnderGlowColor", k)
        if not istable(underglow) then 
            continue 
        end
        
        if k:GetPos():DistToSqr(RCD.LocalPlayer:GetPos()) > 900000 then 
            continue
        end
 
        local dynamicLight = DynamicLight(k:EntIndex())
        if dynamicLight then
			dynamicLight.pos = k:GetPos()
            dynamicLight.brightness = 6
            dynamicLight.Decay = 1000
            dynamicLight.Size = 100
			dynamicLight.r = underglow.r
			dynamicLight.g = underglow.g
			dynamicLight.b = underglow.b
            dynamicLight.DieTime = curTime + FrameTime() * 4
		end
    end

    if syncNWCooldown < curTime then

        for entIndex, values in pairs(RCD.ClientTable["NWToSynchronize"] or {}) do

            local ent = Entity(entIndex)
            if not IsValid(ent) then continue end
            
            ent.RCDNWVariables = values
            RCD.ClientTable["NWToSynchronize"][entIndex] = nil       
        end
        
        syncNWCooldown = curTime + 5
    end
end)

hook.Add("OnEntityCreated", "RCD:UnderGlow:OnEntityCreated", function(ent)
    if not IsValid(ent) or not RCD.IsVehicle(ent) then return end

    RCD["vehiclesSpawned"] = RCD["vehiclesSpawned"] or {}
    RCD["vehiclesSpawned"][ent] = true

    ent:CallOnRemove("rcd_reset_variables:"..ent:EntIndex(), function(ent) 
        RCD["vehiclesSpawned"][ent] = nil
    end) 
end)

net.Receive("RCD:Main:Client", function()
    local uInt = net.ReadUInt(4)

    --[[ Sync NW variables ]]
    if uInt == 1 then
        RCD.ClientTable["NWToSynchronize"] = RCD.ClientTable["NWToSynchronize"] or {}
            
        local entAmountToSynchronize = net.ReadUInt(12)
        for i=1, entAmountToSynchronize do
            
            local entIndex = net.ReadUInt(32)
            local ent = Entity(entIndex)

            local needToSync = {}
            local varAmountToSynchronize = net.ReadUInt(4)
            
            for i=1, varAmountToSynchronize do
                local valueType = net.ReadString()
                
                if IsValid(ent) then
                    ent.RCDNWVariables = ent.RCDNWVariables or {}

                    local valueName, value = net.ReadString(), net["Read"..RCD.TypeNet[valueType]](((RCD.TypeNet[valueType] == "Int") and 32))
                    ent.RCDNWVariables[valueName] = value
                else
                    
                    needToSync[net.ReadString()] = net["Read"..RCD.TypeNet[valueType]](((RCD.TypeNet[valueType] == "Int") and 32))
                end
            end

            if not IsValid(ent) then
                RCD.ClientTable["NWToSynchronize"][entIndex] = RCD.ClientTable["NWToSynchronize"][entIndex] or {}
                
                for k,v in pairs(needToSync) do
                    RCD.ClientTable["NWToSynchronize"][entIndex][k] = v
                end
            end
        end
        
    --[[ Open the menu, set the first vehicle selected and the vehicle id ]]
    elseif uInt == 2 then
        local groupsList = {}
        
        local groupsListCount = net.ReadUInt(12)
        for i=1, groupsListCount do
            local groupsId = net.ReadUInt(32)

            groupsList[groupsId] = true
        end

        RCD.ClientTable["vehiclesTable"] = {}

        local canOpen = false
        for k,v in pairs(RCD.AdvancedConfiguration["vehiclesList"]) do
            if not groupsList[v.groupId] then continue end

            v.price = tonumber(v.price) or 0

            RCD.ClientTable["vehiclesTable"][k] = v
            canOpen = true
        end

        if not canOpen then RCD.Notification(5, RCD.GetSentence("carDealerNotConfigured")) return end 

        for k,v in pairs(RCD.ClientTable["vehiclesTable"]) do
            RCD.ClientTable["vehicleSelected"] = v
            RCD.ClientTable["carrouselId"] = 1
            
            RCD.MainMenu()
            return
        end

    --[[ Add a new vehicle to the table when the player buy it ]]
    elseif uInt == 3 then
        local vehicleId = net.ReadUInt(32)
        local groupId = net.ReadUInt(32)
        local discount = net.ReadUInt(32)
        local playerId = net.ReadString()

        local vehicleSkin = net.ReadUInt(8)
        local vehicleNitro = net.ReadUInt(2)
        local hasColor = net.ReadBool()
        local vehicleColor = net.ReadColor()
        local hasUnderglow = net.ReadBool()
        local vehicleUnderglow = net.ReadColor()
        local bodygroupCount = net.ReadUInt(8)

        local vehicleBodygroups = {}
        for i=1, bodygroupCount do
            local k = net.ReadUInt(8)
            local v = net.ReadUInt(8)

            vehicleBodygroups[k] = v
        end

        local customization = {
            ["vehicleSkin"] = vehicleSkin,
            ["vehicleNitro"] = vehicleNitro,
            ["vehicleColor"] = (hasColor and vehicleColor or nil),
            ["vehicleUnderglow"] = (hasUnderglow and vehicleUnderglow or nil),
            ["vehicleBodygroups"] = vehicleBodygroups,
        }

        local tableToAdd = {
            ["customization"] = customization,
            ["groupId"] = groupId,
            ["discount"] = discount,
            ["vehicleId"] = vehicleId,
            ["playerId"] = playerId,
        }
        
        RCD.ClientTable["vehiclesBought"][vehicleId] = tableToAdd

        hook.Run("RCD:VehicleBought", vehicleId)

    --[[ Remove vehicle to the table when the player sell it ]]
    elseif uInt == 4 then
        local vehicleId = net.ReadUInt(32)
        if not isnumber(vehicleId) then return end

        RCD.ClientTable["vehiclesBought"][vehicleId] = nil

        hook.Run("RCD:VehicleSold", vehicleId)

    --[[ Just close the menu ]]
    elseif uInt == 5 then
        if IsValid(RCDMainFrame) then RCDMainFrame:Remove() end

    --[[ Set the time you have when you do a test of a vehicle ]]
    elseif uInt == 7 then
        local testTime = RCD.GetSetting("testTime", "number")
        timeTest = CurTime() + testTime

        if IsValid(RCDMainFrame) then RCDMainFrame:Remove() end

    --[[ Get the table of vehicles spawned ]]
    elseif uInt == 8 then
        local vehicleSpawned = {}

        local vehicleSpawnedCount = net.ReadUInt(8)
        for i=1, vehicleSpawnedCount do
            local vehicleId = net.ReadUInt(32)
            if not isnumber(vehicleId) then return end

            vehicleSpawned[vehicleId] = true
        end

        RCD.ClientTable["vehicleSpawned"] = vehicleSpawned

    --[[ Sync customization table ]]
    elseif uInt == 9 then
        local vehicleId = net.ReadUInt(32)
        if not isnumber(vehicleId) then return end

        local vehicleSkin = net.ReadUInt(8)
        local vehicleNitro = net.ReadUInt(2)
        local vehicleColor = net.ReadColor()
        local hasUnderglow = net.ReadBool()
        local vehicleUnderglow = net.ReadColor()
        local bodygroupCount = net.ReadUInt(8)

        local vehicleBodygroups = {}
        for i=1, bodygroupCount do
            local k = net.ReadUInt(8)
            local v = net.ReadUInt(8)

            vehicleBodygroups[k] = v
        end

        local customization = {
            ["vehicleSkin"] = vehicleSkin,
            ["vehicleNitro"] = vehicleNitro,
            ["vehicleColor"] = vehicleColor,
            ["vehicleUnderglow"] = (hasUnderglow and vehicleUnderglow or nil),
            ["vehicleBodygroups"] = vehicleBodygroups,
        }
        
        RCD.ClientTable["vehiclesBought"][vehicleId] = RCD.ClientTable["vehiclesBought"][vehicleId] or {}
        RCD.ClientTable["vehiclesBought"][vehicleId]["customization"] = customization

        RCD.ReloadVehiclesList(true)
    
    --[[ Sync the table of vehicles bought ]]
    elseif uInt == 10 then
        local bytesAmount = net.ReadUInt(32)
        local unCompressTable = util.Decompress(net.ReadData(bytesAmount)) or ""
        local vehiclesTable = util.JSONToTable(unCompressTable)
        
        RCD.ClientTable["vehiclesBought"] = vehiclesTable
    --[[ Reset vehicle test ]]
    elseif uInt == 11 then
        timeTest = 0
    end
end)