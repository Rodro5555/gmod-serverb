RCD = RCD or {}
RCD.BaseButton = RCD.BaseButton or {}
RCD.SettingsButton = RCD.SettingsButton or {}

--[[ Vehicle blacklisted ]]
RCD.VehicleBlacklisted = {
    ["Seat_Airboat"] = true,
    ["Chair_Office2"] = true,
    ["Chair_Plastic"] = true,
    ["Seat_Jeep"] = true,
    ["Chair_Office1"] = true,
    ["Chair_Wood"] = true,
    ["prop_vehicle_prisoner_pod"] = true,
}

--[[ All buttons on the main menu]]
RCD.BaseButton = {
    {
        ["name"] = "close",
        ["mat"] = RCD.Materials["icon_close"],
        ["func"] = function(panel)
            if not IsValid(panel) then return end
            
            panel:Remove()
        end,
    },
    {
        ["name"] = "paint",
        ["mat"] = RCD.Materials["icon_paint"],
        ["func"] = function(panel)
            if RCD.CountVehicleBought() <= 0 then RCD.Notification(5, RCD.GetSentence("noVehicles")) return end
            RCD.ReloadVehiclesList(true)
        end,
    },
    {
        ["name"] = "returnButton",
        ["mat"] = RCD.Materials["icon_leave"],
        ["func"] = function(panel)            
            net.Start("RCD:Main:Client")
                net.WriteUInt(6, 4)
            net.SendToServer()
        end,
    },
    {
        ["name"] = "car",
        ["mat"] = RCD.Materials["icon_car"],
        ["func"] = function(panel)
            RCD.ReloadVehiclesList(false)
        end,
    },
}

--[[ All sliders on the main menu ]]
RCD.SettingsSlider = {
    ["default"] = {
        {
            ["name"] = "maxSpeed",
            ["max"] = 300,
            ["func"] = function(tbl)
                return tbl["engine"] and tbl["engine"]["maxspeed"] or 0
            end,
        },
        {
            ["name"] = "horsePower",
            ["max"] = 800,
            ["func"] = function(tbl)
    
                return tbl["engine"] and tbl["engine"]["horsepower"] or 0
            end,
        },
        {
            ["name"] = "wheelsPerAxles",
            ["max"] = 8,
            ["func"] = function(tbl)
    
                return tbl["wheelsperaxle"] or 0
            end,
        },
    },
    ["simfphys"] = {
        {
            ["name"] = "brakePower",
            ["max"] = 300,
            ["func"] = function(tbl)
                tbl["Members"] = tbl["Members"] or {}

                return tbl["Members"]["PeakTorque"] or 0
            end,
        },
        {
            ["name"] = "turnSpeed",
            ["max"] = 80,
            ["func"] = function(tbl)
                tbl["Members"] = tbl["Members"] or {}

                return tbl["Members"]["TurnSpeed"] or 0
            end,
        },
        {
            ["name"] = "mass",
            ["max"] = 5000,
            ["func"] = function(tbl)
                tbl["Members"] = tbl["Members"] or {}

                return tbl["Members"]["Mass"] or 0
            end,
        },
    }
}

--[[ All compatibilities options ]]
RCD.CompatibilitiesOptions = {
    ["saveHealth"] = {
        ["type"] = "number",
        ["get"] = function(ent)
            local health = 100
            if not IsValid(ent) then return health end

            if not ent.IsSimfphyscar then
                if SVMOD && SVMOD:GetAddonState() then
                    health = ent:SV_GetHealth()
                elseif VC then
                    health = ent:VC_getHealth(true)
                end
            else
                health = ent:GetCurHealth()
            end

            return health
        end,
        ["set"] = function(ent, value)
            local health = (tonumber(value) or 100)
            if not IsValid(ent) then return health end
            
            if not isnumber(health) or health <= 10 then health = 100 end
            
            if not ent.IsSimfphyscar then
                if SVMOD && SVMOD:GetAddonState() then
                    ent:SV_SetHealth(ent:SV_GetMaxHealth())
                elseif VC then
                    local maxHealth = (ent:VC_getHealthMax() or 100)
                    ent:VC_setHealth(maxHealth*((health or 100)/100))
                end
            else
                ent:SetCurHealth(health)
            end
        end,
    },
}

-- [[ A list of all list.Get(...) for vehicles ]]
RCD.VehiclesListNames = {
    "Vehicles",
    "simfphys_vehicles",
}

--[[ This is the default configuration ]]
RCD.DefaultSettings = RCD.DefaultSettings or {
    ["lang"] = "es",
    ["maxVehicles"] = 3,
    ["testTime"] = 60,
    ["distToReturn"] = 50000,
    ["activateNotification"] = true,
    ["adminCommand"] = "/rcd",
    ["engineKey"] = KEY_M,
    ["nitroKey"] = KEY_LSHIFT,
    ["nitroSpeed"] = 1,
    ["minSpeedNitro"] = 30,
    ["engineActivate"] = true,
    ["engineTime"] = 2,
    ["beltActivate"] = true,
    ["beltKey"] = KEY_G,
    ["underglowKey"] = KEY_F,
    ["beltWarningSound"] = true,
    ["unitChoose"] = "kmh",
    ["cantExitModule"] = true,
    ["exitKMH"] = 20,
    ["smallAccidentActivate"] = true,
    ["smallAccidentMinDamage"] = 20,
    ["ejectActivate"] = true,
    ["ejectMinDamage"] = 40,
    ["speedometerActivate"] = true,
    ["speedometerPosX"] = 0.89,
    ["speedometerPosY"] = 0.95,
    ["speedometerCount"] = 8,
    ["speedometerSpace"] = 2.5,
    ["useSimfphysSpeedometer"] = false,
    ["speedometerSize"] = 140,
    ["currency"] = "$",
    ["enterVehicle"] = true,
    ["generalPourcentSell"] = 50,
    ["carDealerJob"] = "Mecanico",
    ["nitroDuration"] = 2,
    ["nitroCooldowns"] = 30,
}

--[[ All things used on accordion, and other stuff ]] 
RCD.ParametersConfig = {
    ["vehiclePosition"] = {
        { --Line on the accordion
            { -- Number of params on the line
                ["class"] = "RCD:Slider", -- Panel to create on the right
                ["text"] = "posX", -- Text on the left
                ["sizeX"] = 0.14, -- Size X of the right panel
                ["sizeY"] = 0.05, -- Size Y of the right panel
                ["posX"] = 0.115, -- Pos X of the right panel
                ["posY"] = 0, -- Pos Y of the right panel
                ["func"] = function(pnl, panelLink, editVehicle) -- Function when the accordion is initialize
                    if IsValid(panelLink) then
                        local ent = panelLink.Entity
                        if not IsValid(ent) then return end

                        pnl:SetMinMax(-200, 200)

                        RCD.vehicleConfig = RCD.vehicleConfig or {}
                        RCD.vehicleConfig["vector"] = panelLink:GetLookAt()

                        pnl.OnValueChanged = function(pnl, number)
                            RCD.vehicleConfig["vector"][1] = number
                            local pos = Vector(RCD.vehicleConfig["vector"])

                            panelLink:SetLookAt(pos)
                        end

                        pnl.RCDLerp = RCD.vehicleConfig["vector"]
                        pnl.Think = function()
                            pnl.RCDLerp = LerpVector(FrameTime()*5, pnl.RCDLerp, RCD.vehicleConfig["vector"])

                            panelLink:SetLookAt(pnl.RCDLerp)
                        end
                        
                        if editVehicle && editVehicle["options"] && isvector(editVehicle["options"]["vector"]) then
                            RCD.vehicleConfig["vector"] = editVehicle["options"]["vector"]

                            pnl:SetValue(editVehicle["options"]["vector"][1])
                        end
                    end 
                end, 
            },
            {
                ["class"] = "RCD:Slider",
                ["text"] = "angleX",
                ["sizeX"] = 0.14,
                ["sizeY"] = 0.05,
                ["posX"] = 0.115,
                ["posY"] = 0,
                ["func"] = function(pnl, panelLink, editVehicle)
                    if IsValid(panelLink) then
                        local ent = panelLink.Entity
                        if not IsValid(ent) then return end

                        pnl:SetMinMax(-180, 180)

                        RCD.vehicleConfig = RCD.vehicleConfig or {}
                        RCD.vehicleConfig["angle"] = ent:GetAngles()

                        pnl.OnValueChanged = function(pnl, number)
                            RCD.vehicleConfig["angle"][1] = number

                            ent:SetAngles(RCD.vehicleConfig["angle"])
                        end

                        pnl.RCDLerp = ent:GetAngles()
                        pnl.Think = function()
                            pnl.RCDLerp = LerpAngle(FrameTime()*5, pnl.RCDLerp, RCD.vehicleConfig["angle"])

                            ent:SetAngles(pnl.RCDLerp)
                        end

                        if editVehicle && editVehicle["options"] && isangle(editVehicle["options"]["angle"]) then
                            RCD.vehicleConfig["angle"] = editVehicle["options"]["angle"]

                            pnl:SetValue(editVehicle["options"]["angle"][1])
                        end
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:Slider",
                ["text"] = "posY",
                ["sizeX"] = 0.14,
                ["sizeY"] = 0.05,
                ["posX"] = 0.115,
                ["posY"] = 0,
                ["func"] = function(pnl, panelLink, editVehicle)
                    if IsValid(panelLink) then
                        pnl:SetMinMax(-200, 200)

                        pnl.OnValueChanged = function(pnl, number)
                            RCD.vehicleConfig["vector"][2] = number
                            local pos = Vector(RCD.vehicleConfig["vector"])

                            panelLink:SetLookAt(pos)
                        end

                        if editVehicle && editVehicle["options"] && isvector(editVehicle["options"]["vector"]) then
                            pnl:SetValue(editVehicle["options"]["vector"][2])
                        end
                    end
                end,
            },
            {
                ["class"] = "RCD:Slider",
                ["text"] = "AngleY",
                ["sizeX"] = 0.14,
                ["sizeY"] = 0.05,
                ["posX"] = 0.115,
                ["posY"] = 0,
                ["func"] = function(pnl, panelLink, editVehicle)
                    if IsValid(panelLink) then
                        local ent = panelLink.Entity
                        if not IsValid(ent) then return end

                        pnl:SetMinMax(-180, 180)

                        pnl.OnValueChanged = function(pnl, number)
                            RCD.vehicleConfig["angle"][2] = number
                            local ang = Angle(RCD.vehicleConfig["angle"])

                            ent:SetAngles(ang)
                        end

                        if editVehicle && editVehicle["options"] && isangle(editVehicle["options"]["angle"]) then
                            pnl:SetValue(editVehicle["options"]["angle"][2])
                        end
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:Slider",
                ["text"] = "posZ",
                ["sizeX"] = 0.14,
                ["sizeY"] = 0.05,
                ["posX"] = 0.115,
                ["posY"] = 0,
                ["func"] = function(pnl, panelLink, editVehicle)
                    if IsValid(panelLink) then
                        pnl:SetMinMax(-200, 200)

                        local oldPos = panelLink:GetLookAt()

                        pnl.OnValueChanged = function(pnl, number)
                            RCD.vehicleConfig["vector"][3] = number
                            local pos = Vector(RCD.vehicleConfig["vector"])

                            panelLink:SetLookAt(pos)
                        end

                        if editVehicle && editVehicle["options"] && isvector(editVehicle["options"]["vector"]) then
                            pnl:SetValue(editVehicle["options"]["vector"][3])
                        end
                    end
                end,
            },
            {
                ["class"] = "RCD:Slider",
                ["text"] = "angleZ",
                ["sizeX"] = 0.14,
                ["sizeY"] = 0.05,
                ["posX"] = 0.115,
                ["posY"] = 0,
                ["func"] = function(pnl, panelLink, editVehicle)
                    if IsValid(panelLink) then
                        local ent = panelLink.Entity
                        if not IsValid(ent) then return end

                        pnl:SetMinMax(-180, 180)

                        pnl.OnValueChanged = function(pnl, number)
                            RCD.vehicleConfig["angle"][3] = number
                            local ang = Angle(RCD.vehicleConfig["angle"])

                            ent:SetAngles(ang)
                        end

                        if editVehicle && editVehicle["options"] && isangle(editVehicle["options"]["angle"]) then
                            pnl:SetValue(editVehicle["options"]["angle"][3])
                        end
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:Slider",
                ["text"] = "fov",
                ["sizeX"] = 0.14,
                ["sizeY"] = 0.05,
                ["posX"] = 0.382,
                ["posY"] = 0,
                ["func"] = function(pnl, panelLink, editVehicle)
                    if IsValid(panelLink) then
                        local ent = panelLink.Entity
                        if not IsValid(ent) then return end

                        pnl:SetMinMax(-30, 30)
                        pnl:SetValue(0)

                        RCD.vehicleConfig["fov"] = 0
                        local oldFov = panelLink:GetFOV()

                        pnl.OnValueChanged = function(pnl, number)
                            RCD.vehicleConfig["fov"] = number
                            
                            panelLink:SetFOV(oldFov + RCD.vehicleConfig["fov"])
                        end

                        pnl.RCDLerp = RCD.vehicleConfig["fov"]
                        pnl.Think = function()
                            pnl.RCDLerp = Lerp(FrameTime()*5, pnl.RCDLerp, RCD.vehicleConfig["fov"])

                            panelLink:SetFOV(oldFov + pnl.RCDLerp)
                        end

                        if editVehicle && editVehicle["options"] && isnumber(editVehicle["options"]["fov"]) then
                            pnl:SetValue(editVehicle["options"]["fov"])
                        end
                    end
                end,
            },
        },
    },
    ["generalSettings"] = {
        {
            {
                ["class"] = "RCD:CheckBox",
                ["text"] = "useCustomNotification",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink, editVehicle)
                    RCD.AdvancedConfiguration["settings"] = {}

                    pnl:SetActive(tobool(RCD.DefaultSettings["activateNotification"]))

                    pnl.OnChange = function(self, bChecked)
                        RCD.AdvancedConfiguration["settings"]["activateNotification"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:CheckBox",
                ["text"] = "enterIntoVehicle",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetActive(tobool(RCD.DefaultSettings["enterVehicle"]))

                    pnl.OnChange = function(self, bChecked)
                        RCD.AdvancedConfiguration["settings"]["enterVehicle"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "DButton",
                ["text"] = "playersManagement",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetTextColor(RCD.Colors["white100"])
                    pnl:SetFont("RCD:Font:13")
                    
                    pnl.Paint = function(self, w, h)
                        pnl:SetText(RCD.GetSentence("open"))
                        draw.RoundedBox(6, 0, 0, w, h, RCD.Colors["white5"])
                    end

                    pnl.DoClick = function()
                        if IsValid(settingsMenu) then settingsMenu:Remove() end
                        RCD.ManagePlayers()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:DComboBox",
                ["text"] = "language",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetRounded(6)

                    for k,v in pairs(RCD.Language) do
                        pnl:AddChoice(k)
                    end

                    pnl:ChooseOption(RCD.DefaultSettings["lang"])

                    pnl.OnSelect = function(self, index, text, data)
                        RCD.AdvancedConfiguration["settings"]["lang"] = text
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:DComboBox",
                ["text"] = "speedUnit",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetRounded(6)

                    for k,v in pairs(RCD.UnitConvertion) do
                        pnl:AddChoice(k)
                    end

                    pnl:ChooseOption(RCD.DefaultSettings["unitChoose"])

                    pnl.OnSelect = function(self, index, text, data)
                        RCD.AdvancedConfiguration["settings"]["unitChoose"] = text
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:DComboBox",
                ["text"] = "carDealerJobConfig",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetRounded(6)
                    pnl:SetText("Ciudadano")

                    for k,v in pairs(team.GetAllTeams()) do
                        pnl:AddChoice(v.Name)
                    end

                    pnl:ChooseOption(RCD.DefaultSettings["carDealerJob"])

                    pnl.OnSelect = function(self, index, text, data)
                        RCD.AdvancedConfiguration["settings"]["carDealerJob"] = text
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:DComboBox",
                ["text"] = "currency",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetRounded(6)

                    for k,v in pairs(RCD.Currencies) do
                        pnl:AddChoice(k)
                    end

                    pnl:ChooseOption(RCD.DefaultSettings["currency"])

                    pnl.OnSelect = function(self, index, text, data)
                        RCD.AdvancedConfiguration["settings"]["currency"] = text
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "adminCommand",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetRounded(6)

                    pnl:SetPlaceHolder(RCD.DefaultSettings["adminCommand"])

                    pnl.entry.OnChange = function(self)
                        RCD.AdvancedConfiguration["settings"]["adminCommand"] = self:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "maxVehicle",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetPlaceHolder(RCD.DefaultSettings["maxVehicles"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)

                    pnl.entry.OnChange = function(self)
                        RCD.AdvancedConfiguration["settings"]["maxVehicles"] = self:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "testTime",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetPlaceHolder(RCD.DefaultSettings["testTime"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)

                    pnl.entry.OnChange = function(self)
                        RCD.AdvancedConfiguration["settings"]["testTime"] = self:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "distanceToReturn",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetPlaceHolder(RCD.DefaultSettings["distToReturn"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)

                    pnl.entry.OnChange = function(self)
                        RCD.AdvancedConfiguration["settings"]["distToReturn"] = self:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "pourcentSell",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetPlaceHolder(RCD.DefaultSettings["generalPourcentSell"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)

                    pnl.entry.OnChange = function(self)
                        RCD.AdvancedConfiguration["settings"]["generalPourcentSell"] = self:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "DBinder",
                ["text"] = "underglowKey",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetText("KEY_"..input.GetKeyName(RCD.DefaultSettings["underglowKey"]):upper())
                    pnl:SetFont("RCD:Font:13")

                    pnl.OnChange = function(self, key)
                        self:SetText("KEY_"..input.GetKeyName(key):upper())
                        RCD.AdvancedConfiguration["settings"]["underglowKey"] = key
                    end

                    pnl.Paint = function(self, w, h)
                        draw.RoundedBox(6, 0, 0, w, h, RCD.Colors["white5"])
                    end
                    pnl:SetTextColor(RCD.Colors["white100"])
                end,
            },
        },
    },
    ["nitroConfig"] = {
        {
            {
                ["class"] = "DBinder",
                ["text"] = "nitroKey",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetText("KEY_"..input.GetKeyName(RCD.DefaultSettings["nitroKey"]):upper())
                    pnl:SetFont("RCD:Font:13")
    
                    pnl.OnChange = function(self, key)
                        self:SetText("KEY_"..input.GetKeyName(key):upper())
                        RCD.AdvancedConfiguration["settings"]["nitroKey"] = key
                    end
    
                    pnl.Paint = function(self, w, h)
                        draw.RoundedBox(6, 0, 0, w, h, RCD.Colors["white5"])
                    end
                    pnl:SetTextColor(RCD.Colors["white100"])
                end,
            },
        },
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "nitroSpeed",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetPlaceHolder(RCD.DefaultSettings["nitroSpeed"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)
    
                    pnl.entry.OnChange = function(self)
                        RCD.AdvancedConfiguration["settings"]["nitroSpeed"] = self:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "minSpeedNitro",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetPlaceHolder(RCD.DefaultSettings["minSpeedNitro"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)
    
                    pnl.entry.OnChange = function(self)
                        RCD.AdvancedConfiguration["settings"]["minSpeedNitro"] = self:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "nitroDuration",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetPlaceHolder(RCD.DefaultSettings["nitroDuration"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)
    
                    pnl.entry.OnChange = function(self)
                        RCD.AdvancedConfiguration["settings"]["nitroDuration"] = self:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "nitroCooldowns",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetPlaceHolder(RCD.DefaultSettings["nitroCooldowns"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)
    
                    pnl.entry.OnChange = function(self)
                        RCD.AdvancedConfiguration["settings"]["nitroCooldowns"] = self:GetText()
                    end
                end,
            },
        },
    },
    ["beltConfig"] = {
        {
            {
                ["class"] = "RCD:CheckBox",
                ["text"] = "activateBelt",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetActive(tobool(RCD.DefaultSettings["beltActivate"]))

                    pnl.OnChange = function(self, bChecked)
                        RCD.AdvancedConfiguration["settings"]["beltActivate"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:CheckBox",
                ["text"] = "warningSound",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetActive(tobool(RCD.DefaultSettings["beltWarningSound"]))

                    pnl.OnChange = function(self, bChecked)
                        RCD.AdvancedConfiguration["settings"]["beltWarningSound"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "DBinder",
                ["text"] = "beltKey",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetText("KEY_"..input.GetKeyName(RCD.DefaultSettings["beltKey"]):upper())
                    pnl:SetFont("RCD:Font:13")

                    pnl.OnChange = function(self, key)
                        self:SetText("KEY_"..input.GetKeyName(key):upper())
                        RCD.AdvancedConfiguration["settings"]["beltKey"] = key
                    end

                    pnl.Paint = function(self, w, h)
                        draw.RoundedBox(6, 0, 0, w, h, RCD.Colors["white5"])
                    end
                    pnl:SetTextColor(RCD.Colors["white100"])
                end,
            },
        },
    },
    ["engineModule"] = {
        {
            {
                ["class"] = "RCD:CheckBox",
                ["text"] = "activateEngine",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetActive(tobool(RCD.DefaultSettings["engineActivate"]))

                    pnl.OnChange = function(self, bChecked)
                        RCD.AdvancedConfiguration["settings"]["engineActivate"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "DBinder",
                ["text"] = "engineKey",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetText("KEY_"..input.GetKeyName(RCD.DefaultSettings["engineKey"]):upper())
                    pnl:SetFont("RCD:Font:13")

                    pnl.OnChange = function(self, key)
                        self:SetText("KEY_"..input.GetKeyName(key):upper())
                        RCD.AdvancedConfiguration["settings"]["engineKey"] = key
                    end

                    pnl.Paint = function(self, w, h)
                        draw.RoundedBox(6, 0, 0, w, h, RCD.Colors["white5"])
                    end
                    pnl:SetTextColor(RCD.Colors["white100"])
                end,
            },
        },
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "timeToLunchVehicle",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetPlaceHolder(RCD.DefaultSettings["engineTime"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)

                    pnl.entry.OnChange = function(self)
                        RCD.AdvancedConfiguration["settings"]["engineTime"] = self:GetText()
                    end
                end,
            },
        },
    },
    ["driveModule"] = {
        {
            {
                ["class"] = "RCD:CheckBox",
                ["text"] = "cantLeaveVehicleInMotion",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetActive(tobool(RCD.DefaultSettings["cantExitModule"]))

                    pnl.OnChange = function(self, bChecked)
                        RCD.AdvancedConfiguration["settings"]["cantExitModule"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:CheckBox",
                ["text"] = "activateSmallAccident",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetActive(tobool(RCD.DefaultSettings["smallAccidentActivate"]))

                    pnl.OnChange = function(self, bChecked)
                        RCD.AdvancedConfiguration["settings"]["smallAccidentActivate"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:CheckBox",
                ["text"] = "activateEjectionAccident",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetActive(tobool(RCD.DefaultSettings["ejectActivate"]))

                    pnl.OnChange = function(self, bChecked)
                        RCD.AdvancedConfiguration["settings"]["ejectActivate"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "lowerSpeedToExit",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetPlaceHolder(RCD.DefaultSettings["exitKMH"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)

                    pnl.entry.OnChange = function(self)
                        RCD.AdvancedConfiguration["settings"]["exitKMH"] = self:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "minDamageSmallAccident",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetPlaceHolder(RCD.DefaultSettings["smallAccidentMinDamage"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)

                    pnl.entry.OnChange = function(self)
                        RCD.AdvancedConfiguration["settings"]["smallAccidentMinDamage"] = self:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "minDamageEjectionAccident",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetPlaceHolder(RCD.DefaultSettings["ejectMinDamage"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)

                    pnl.entry.OnChange = function(self)
                        RCD.AdvancedConfiguration["settings"]["ejectMinDamage"] = self:GetText()
                    end
                end,
            },
        },
    },
    ["speedometerModule"] = {
        {
            {
                ["class"] = "RCD:CheckBox",
                ["text"] = "activateSpeedometer",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetActive(tobool(RCD.DefaultSettings["speedometerActivate"]))

                    pnl.OnChange = function(self, bChecked)
                        RCD.AdvancedConfiguration["settings"]["speedometerActivate"] = bChecked
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "speedometerSize",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetPlaceHolder(RCD.DefaultSettings["speedometerSize"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)

                    pnl.entry.OnChange = function(self)
                        RCD.AdvancedConfiguration["settings"]["speedometerSize"] = self:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "posX",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.199,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetPlaceHolder(math.Round(RCD.DefaultSettings["speedometerPosX"], 2))
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)

                    pnl.entry.OnChange = function(self)
                        RCD.AdvancedConfiguration["settings"]["speedometerPosX"] = self:GetText()
                    end
                end,
            },
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "posY",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.199,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetPlaceHolder(math.Round(RCD.DefaultSettings["speedometerPosY"], 2))
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)

                    pnl.entry.OnChange = function(self)
                        RCD.AdvancedConfiguration["settings"]["speedometerPosY"] = self:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "count",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.199,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetPlaceHolder(RCD.DefaultSettings["speedometerCount"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)

                    pnl.entry.OnChange = function(self)
                        RCD.AdvancedConfiguration["settings"]["speedometerCount"] = self:GetText()
                    end
                end,
            },
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "space",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.199,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetPlaceHolder(RCD.DefaultSettings["speedometerSpace"])
                    pnl:SetRounded(6)
                    pnl:SetNumeric(true)

                    pnl.entry.OnChange = function(self)
                        RCD.AdvancedConfiguration["settings"]["speedometerSpace"] = self:GetText()
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:CheckBox",
                ["text"] = "activateSimfphysSpeedometer",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetActive(tobool(RCD.DefaultSettings["activateSimfphysSpeedometer"]))

                    pnl.OnChange = function(self, bChecked)
                        RCD.AdvancedConfiguration["settings"]["activateSimfphysSpeedometer"] = bChecked
                    end
                end,
            },
        },
    },
    ["vehicleSettings"] = {
        {
            {
                ["class"] = "RCD:DComboBox",
                ["text"] = "defaultSkin",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:Clear()
                    pnl:SetText(RCD.GetSentence("choose"))
                    pnl:SetRounded(6)

                    if IsValid(panelLink) then

                        local ent = panelLink.Entity
                        if not IsValid(ent) then return end

                        pnl:SetSortItems(false)
                        
                        for i=0, ent:SkinCount()-1 do
                            pnl:AddChoice(RCD.GetSentence("skin").." "..i, i)
                        end

                        pnl.OnSelect = function(panel, index, data)
                            local optionData = panel:GetOptionData(index)

                            RCD.vehicleConfig["skin"] = optionData
                            ent:SetSkin(optionData)
                        end

                        if editVehicle && editVehicle["options"] && isnumber(editVehicle["options"]["skin"]) then
                            RCD.vehicleConfig["skin"] = editVehicle["options"]["skin"]
                            ent:SetSkin(RCD.vehicleConfig["skin"])
                            pnl:SetText(RCD.GetSentence("skin").." "..RCD.vehicleConfig["skin"])
                        end
                    end
                end,
            },
        },
        {
            {
                ["class"] = "DButton",
                ["text"] = "defaultColor",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink, editVehicle)
                    RCD.vehicleConfig["defaultColor"] = RCD.Colors["white"]

                    if editVehicle && editVehicle["options"] && istable(editVehicle["options"]["defaultColor"]) then
                        RCD.vehicleConfig["defaultColor"] = editVehicle["options"]["defaultColor"]
                        panelLink:SetColor(RCD.vehicleConfig["defaultColor"])
                    end

                    pnl:SetText("")
                    pnl.Paint = function(self,w,h)
                        RCD.DrawCircle(w/2, h/2, h/2, 0, 360, RCD.vehicleConfig["defaultColor"])
                    end
                    pnl.DoClick = function()
                        local chooseColor = vgui.Create("DFrame")
                        chooseColor:SetSize(RCD.ScrW*0.2, RCD.ScrH*0.43)
                        chooseColor:SetDraggable(true)
                        chooseColor:MakePopup()
                        chooseColor:SetTitle("")
                        chooseColor:ShowCloseButton(false)
                        chooseColor:Center()
                        chooseColor.Paint = function(self,w,h)
                            RCD.DrawBlur(self, 4) 
                    
                            draw.RoundedBox(0,0,0,w,h,RCD.Colors["blackpurple"])
                            draw.RoundedBox(0,w/2-RCD.ScrW*0.192/2,h*0.02,RCD.ScrW*0.192, RCD.ScrH*0.062,RCD.Colors["white20"])
                            
                            draw.DrawText(RCD.GetSentence("chooseColor"), "RCD:Font:10", w*0.05, h*0.02, RCD.Colors["white"], TEXT_ALIGN_LEFT)
                            draw.DrawText(RCD.GetSentence("configureDefaultColor"), "RCD:Font:11", w*0.05, h*0.09, RCD.Colors["white100"], TEXT_ALIGN_LEFT)
                        end

                        local defaultColor = vgui.Create("RCD:ColorPicker", chooseColor)
                        defaultColor:SetSize(RCD.ScrW*0.192, RCD.ScrH*0.33)
                        defaultColor:Dock(TOP)
                        defaultColor:DockMargin(RCD.ScrW*0.003, RCD.ScrH*0.04, RCD.ScrW*0.003, 0)

                        defaultColor.colorCube.OnUserChanged = function(pnl)
                            local color = pnl:GetRGB()
                            panelLink:SetColor(color)

                            RCD.vehicleConfig["defaultColor"] = Color(color.r, color.g, color.b, color.a)
                        end

                        local choose = vgui.Create("RCD:SlideButton", chooseColor)
                        choose:SetSize(RCD.ScrW*0.192, RCD.ScrH*0.041)
                        choose:SetPos(RCD.ScrW*0.005, RCD.ScrH*0.38)
                        choose:SetText(RCD.GetSentence("setDefaultColor"))
                        choose:SetFont("RCD:Font:12")
                        choose:SetTextColor(RCD.Colors["white"])
                        choose:InclineButton(0)
                        choose.MinMaxLerp = {100, 200}
                        choose:SetIconMaterial(nil)
                        choose:SetButtonColor(RCD.Colors["purple"])
                        choose.DoClick = function()
                            RCD.vehicleConfig["defaultColor"] = defaultColor:GetColor()

                            panelLink:SetColor(RCD.vehicleConfig["defaultColor"])
                            chooseColor:Remove()
                        end

                        local closeLerp = 50
                        local close = vgui.Create("DButton", chooseColor)
                        close:SetSize(RCD.ScrH*0.026, RCD.ScrH*0.026)
                        close:SetPos(RCD.ScrW*0.175, RCD.ScrH*0.028)
                        close:SetText("")
                        close.Paint = function(self,w,h)
                            closeLerp = Lerp(FrameTime()*5, closeLerp, (close:IsHovered() and 50 or 100))
                    
                            surface.SetDrawColor(ColorAlpha(RCD.Colors["white100"], closeLerp))
                            surface.SetMaterial(RCD.Materials["icon_close"])
                            surface.DrawTexturedRect(0, 0, w, h)
                        end
                        close.DoClick = function()
                            chooseColor:Remove()
                        end
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:CheckBox",
                ["text"] = "canModifyBodygroup",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetActive(true)
                    RCD.vehicleConfig["canChangeBodygroup"] = true

                    pnl.OnChange = function()
                        RCD.vehicleConfig["canChangeBodygroup"] = pnl:GetActive()
                    end

                    if editVehicle && editVehicle["options"] && isbool(editVehicle["options"]["canChangeBodygroup"]) then
                        RCD.vehicleConfig["canChangeBodygroup"] = editVehicle["options"]["canChangeBodygroup"]

                        pnl:SetActive(RCD.vehicleConfig["canChangeBodygroup"])
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:CheckBox",
                ["text"] = "canModifySkin",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetActive(true)
                    RCD.vehicleConfig["canChangeSkin"] = true

                    pnl.OnChange = function()
                        RCD.vehicleConfig["canChangeSkin"] = pnl:GetActive()
                    end

                    if editVehicle && editVehicle["options"] && isbool(editVehicle["options"]["canChangeSkin"]) then
                        RCD.vehicleConfig["canChangeSkin"] = editVehicle["options"]["canChangeSkin"]

                        pnl:SetActive(RCD.vehicleConfig["canChangeSkin"])
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:CheckBox",
                ["text"] = "canModifyColor",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetActive(true)
                    RCD.vehicleConfig["canChangeColor"] = true

                    pnl.OnChange = function()
                        RCD.vehicleConfig["canChangeColor"] = pnl:GetActive()
                    end

                    if editVehicle && editVehicle["options"] && isbool(editVehicle["options"]["canChangeColor"]) then
                        RCD.vehicleConfig["canChangeColor"] = editVehicle["options"]["canChangeColor"]

                        pnl:SetActive(RCD.vehicleConfig["canChangeColor"])
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:CheckBox",
                ["text"] = "canModifyUngerglow",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetActive(true)
                    RCD.vehicleConfig["canChangeUngerglow"] = true

                    pnl.OnChange = function()
                        RCD.vehicleConfig["canChangeUngerglow"] = pnl:GetActive()
                    end

                    if editVehicle && editVehicle["options"] && isbool(editVehicle["options"]["canChangeUngerglow"]) then
                        RCD.vehicleConfig["canChangeUngerglow"] = editVehicle["options"]["canChangeUngerglow"]

                        pnl:SetActive(RCD.vehicleConfig["canChangeUngerglow"])
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:CheckBox",
                ["text"] = "canTestVehicle",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetActive(true)
                    RCD.vehicleConfig["canTestVehicle"] = true

                    pnl.OnChange = function()
                        RCD.vehicleConfig["canTestVehicle"] = pnl:GetActive()
                    end

                    if editVehicle && editVehicle["options"] && isbool(editVehicle["options"]["canTestVehicle"]) then
                        RCD.vehicleConfig["canTestVehicle"] = editVehicle["options"]["canTestVehicle"]

                        pnl:SetActive(RCD.vehicleConfig["canTestVehicle"])
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:CheckBox",
                ["text"] = "canBuyNitro",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl.OnChange = function()
                        RCD.vehicleConfig["canBuyNitro"] = pnl:GetActive()
                    end

                    if editVehicle && editVehicle["options"] && isbool(editVehicle["options"]["canBuyNitro"]) then
                        RCD.vehicleConfig["canBuyNitro"] = editVehicle["options"]["canBuyNitro"]

                        pnl:SetActive(RCD.vehicleConfig["canBuyNitro"])
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:CheckBox",
                ["text"] = "cantSellSetting",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl.OnChange = function()
                        RCD.vehicleConfig["cantSell"] = pnl:GetActive()
                    end

                    if editVehicle && editVehicle["options"] && isbool(editVehicle["options"]["cantSell"]) then
                        RCD.vehicleConfig["cantSell"] = editVehicle["options"]["cantSell"]

                        pnl:SetActive(RCD.vehicleConfig["cantSell"])
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:CheckBox",
                ["text"] = "boatSettingText",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl.OnChange = function()
                        RCD.vehicleConfig["isBoat"] = pnl:GetActive()
                    end

                    if editVehicle && editVehicle["options"] && isbool(editVehicle["options"]["isBoat"]) then
                        RCD.vehicleConfig["isBoat"] = editVehicle["options"]["isBoat"]

                        pnl:SetActive(RCD.vehicleConfig["isBoat"])
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:CheckBox",
                ["text"] = "disableBeltVehicle",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl.OnChange = function()
                        RCD.vehicleConfig["disableBeltVehicle"] = pnl:GetActive()
                    end

                    if editVehicle && editVehicle["options"] && isbool(editVehicle["options"]["disableBeltVehicle"]) then
                        RCD.vehicleConfig["disableBeltVehicle"] = editVehicle["options"]["disableBeltVehicle"]

                        pnl:SetActive(RCD.vehicleConfig["disableBeltVehicle"])
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:CheckBox",
                ["text"] = "disableEngineVehicle",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl.OnChange = function()
                        RCD.vehicleConfig["disableEngineVehicle"] = pnl:GetActive()
                    end

                    if editVehicle && editVehicle["options"] && isbool(editVehicle["options"]["disableEngineVehicle"]) then
                        RCD.vehicleConfig["disableEngineVehicle"] = editVehicle["options"]["disableEngineVehicle"]

                        pnl:SetActive(RCD.vehicleConfig["disableEngineVehicle"])
                    end
                end,
            },
        },
    },
    ["cardealerVehicles"] = {
        {
            {
                ["class"] = "RCD:CheckBox",
                ["text"] = "canSellWithJob",
                ["sizeX"] = 0.02,
                ["sizeY"] = 0.02,
                ["posX"] = 0.51,
                ["posY"] = 0.015,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetActive(false)
                    RCD.vehicleConfig["canSellWithJob"] = false
    
                    pnl.OnChange = function()
                        RCD.vehicleConfig["canSellWithJob"] = pnl:GetActive()
                    end
    
                    if editVehicle && editVehicle["options"] && isbool(editVehicle["options"]["canSellWithJob"]) then
                        RCD.vehicleConfig["canSellWithJob"] = editVehicle["options"]["canSellWithJob"]
    
                        pnl:SetActive(RCD.vehicleConfig["canSellWithJob"])
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "cardealerJobDiscount",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.468,
                ["posY"] = 0.012,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetRounded(6)
                    pnl:SetPlaceHolder("80")
                    pnl:SetNumeric(true)

                    RCD.vehicleConfig["cardealerJobDiscount"] = 80

                    pnl.entry.OnChange = function()
                        RCD.vehicleConfig["cardealerJobDiscount"] = pnl:GetText()
                    end

                    if editVehicle && editVehicle["options"] then
                        local price = tonumber(editVehicle["options"]["cardealerJobDiscount"])

                        if isnumber(price) then
                            RCD.vehicleConfig["cardealerJobDiscount"] = price

                            pnl:SetText(RCD.vehicleConfig["cardealerJobDiscount"])
                        end
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "rentPrice",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.468,
                ["posY"] = 0.012,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetRounded(6)
                    pnl:SetPlaceHolder("10000")
                    pnl:SetNumeric(true)

                    RCD.vehicleConfig["rentPrice"] = 10000

                    pnl.entry.OnChange = function()
                        RCD.vehicleConfig["rentPrice"] = pnl:GetText()
                    end

                    if editVehicle && editVehicle["options"] then
                        local price = tonumber(editVehicle["options"]["rentPrice"])

                        if isnumber(price) then
                            RCD.vehicleConfig["rentPrice"] = price

                            pnl:SetText(RCD.vehicleConfig["rentPrice"])
                        end
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "minCommissionPrice",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.2,
                ["posY"] = 0.012,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetRounded(6)
                    pnl:SetPlaceHolder("0")
                    pnl:SetNumeric(true)

                    RCD.vehicleConfig["minCommissionPrice"] = 0

                    pnl.entry.OnChange = function()
                        RCD.vehicleConfig["minCommissionPrice"] = pnl:GetText()
                    end

                    if editVehicle && editVehicle["options"] then
                        local price = tonumber(editVehicle["options"]["minCommissionPrice"])

                        if isnumber(price) then
                            RCD.vehicleConfig["minCommissionPrice"] = price

                            pnl:SetText(RCD.vehicleConfig["minCommissionPrice"])
                        end
                    end
                end,
            },
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "maxCommissionPrice",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.2,
                ["posY"] = 0.012,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetRounded(6)
                    pnl:SetPlaceHolder("1000")
                    pnl:SetNumeric(true)

                    RCD.vehicleConfig["maxCommissionPrice"] = 1000

                    pnl.entry.OnChange = function()
                        RCD.vehicleConfig["maxCommissionPrice"] = pnl:GetText()
                    end

                    if editVehicle && editVehicle["options"] then
                        local price = tonumber(editVehicle["options"]["maxCommissionPrice"])

                        if isnumber(price) then
                            RCD.vehicleConfig["maxCommissionPrice"] = price

                            pnl:SetText(RCD.vehicleConfig["maxCommissionPrice"])
                        end
                    end
                end,
            },
        },
    },
    ["customizationColors"] = {
        {
            {
                ["class"] = "RCD:ColorPicker",
                ["text"] = "",
                ["sizeX"] = 0.14,
                ["sizeY"] = 0.3,
                ["posX"] = 0,
                ["posY"] = 0.005,
                ["sizeYPanel"] = 0.328,
                ["disableBackgroundColor"] = true,
                ["func"] = function(pnl, vehicleModel, editVehicle, self)
                    RCD.customization = {}
                    RCD.ClientTable["priceCustomization"] = 0

                    pnl.colorCube.OnUserChanged = function(pnl)
                        local color = pnl:GetRGB()

                        vehicleModel.Vehicles[RCD.ClientTable["vehicleId"]].RCDColor = color
                        RCD.customization["vehicleColor"] = color

                        local oldCustomization = RCD.ClientTable["vehiclesBought"][RCD.ClientTable["vehicleId"]]
                        oldCustomization = oldCustomization["customization"] or {}
                        
                        local price = RCD.GetPriceCustomization(RCD.ClientTable["vehicleSelected"]["options"], oldCustomization, RCD.customization)
                        RCD.ClientTable["priceCustomization"] = price
                    end

                    local reset = vgui.Create("RCD:Button", self)
                    reset:SetSize(RCD.ScrW*0.142, RCD.ScrW*0.016)
                    reset:SetPos(RCD.ScrW*0.003, RCD.ScrH*0.335)
                    reset:SetIconMaterial(nil)
                    reset:SetValue(RCD.GetSentence("reset"))
                    reset:SetHoveredColor(RCD.Colors["white80"])
                    reset:SetBackgroundColor(RCD.Colors["purple"])
                    reset:SetTextAlignement(TEXT_ALIGN_CENTER)
                    reset.RCDMinMaxLerp = {60, 120}
                    reset.DoClick = function()
                        local oldCustomization = RCD.ClientTable["vehiclesBought"][RCD.ClientTable["vehicleId"]]
                        oldCustomization = oldCustomization["customization"] or {}

                        pnl:SetColor(oldCustomization["vehicleColor"])
                        RCD.customization["vehicleColor"] = oldCustomization["vehicleColor"]

                        local price = RCD.GetPriceCustomization(RCD.ClientTable["vehicleSelected"]["options"], oldCustomization, RCD.customization)
                        RCD.ClientTable["priceCustomization"] = price
                    end

                    if istable(RCD.ClientTable["vehiclesBought"]) && istable(RCD.ClientTable["vehiclesBought"][RCD.ClientTable["vehicleId"]]) then
                        local customization = RCD.ClientTable["vehiclesBought"][RCD.ClientTable["vehicleId"]]["customization"] or {}
                        if not istable(customization["vehicleColor"]) then return end

                        pnl:SetColor(customization["vehicleColor"])
                        RCD.customization["vehicleColor"] = customization["vehicleColor"]
                    end
                end,
            },
        }, 
    },
    ["customizationNitro"] = {
        {
            {
                ["class"] = "DPanel",
                ["text"] = "",
                ["sizeX"] = 0.145,
                ["sizeY"] = 0.3,
                ["posX"] = 0,
                ["posY"] = 0.0015,
                ["sizeYPanel"] = 0.3,
                ["disableBackgroundColor"] = true,
                ["func"] = function(pnl, vehicleModel, editVehicle, accordion)
                    local scrollPanel = vgui.Create("RCD:DScroll", pnl)
                    scrollPanel:SetSize(RCD.ScrH*0.0195, RCD.ScrH*0.2)
                    scrollPanel:SetPos(0, RCD.ScrH*0.003)
                    scrollPanel:GetVBar():SetWide(0)
                    
                    local sizeY = 0

                    local options = RCD.ClientTable["vehicleSelected"]["options"] or {}

                    for i=1, 3 do
                        local nitroButton = vgui.Create("RCD:SlideButton", scrollPanel)
                        nitroButton:SetSize(RCD.ScrH*0.0195, RCD.ScrH*0.025)
                        nitroButton:SetText("")
                        nitroButton.MinMaxLerp = {100, 255}
                        nitroButton:SetIconMaterial(nil)
                        nitroButton:Dock(TOP)
                        nitroButton:DockMargin(0,0,0,2)
                        nitroButton:SetButtonColor(RCD.Colors["purple"])
                        nitroButton.PaintOver = function(self,w,h)
                            nitroButton.MinMaxLerp[2] = (RCD.customization["vehicleNitro"] == i) and 100 or 255

                            draw.SimpleText("Level "..i, "RCD:Font:21", w*0.05, h/2, RCD.Colors["white"], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                            draw.SimpleText(RCD.formatMoney((options["priceNitro"] or 0)*i), "RCD:Font:21", w*0.95, h/2, RCD.Colors["white100"], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                        end
                        nitroButton.DoClick = function()
                            local oldCustomization = RCD.ClientTable["vehiclesBought"][RCD.ClientTable["vehicleId"]]
                            oldCustomization = oldCustomization["customization"] or {}

                            if (RCD.customization["vehicleNitro"] == i) then
                                RCD.customization["vehicleNitro"] = nil
                            else
                                RCD.customization["vehicleNitro"] = i
                            end
                            
                            local price = RCD.GetPriceCustomization(RCD.ClientTable["vehicleSelected"]["options"], oldCustomization, RCD.customization)
                            RCD.ClientTable["priceCustomization"] = price
                        end

                        sizeY = sizeY + nitroButton:GetTall() + RCD.ScrH*0.005
                    end

                    scrollPanel:SetSize(RCD.ScrW*0.142, sizeY)
                    accordion:SetSizeY(sizeY+RCD.ScrH*0.005, true, true)
                    
                    pnl.Paint = function() end

                    if istable(RCD.ClientTable["vehiclesBought"]) && istable(RCD.ClientTable["vehiclesBought"][RCD.ClientTable["vehicleId"]]) then
                        local customization = RCD.ClientTable["vehiclesBought"][RCD.ClientTable["vehicleId"]]["customization"] or {}
                        if not istable(customization["vehicleColor"]) then return end

                        RCD.customization["vehicleNitro"] = customization["vehicleNitro"]
                    end
                end,
            },
        },
    },
    ["customizationNeon"] = {
        {
            {
                ["class"] = "RCD:ColorPicker",
                ["text"] = "",
                ["sizeX"] = 0.14,
                ["sizeY"] = 0.3,
                ["posX"] = 0,
                ["posY"] = 0.005,
                ["sizeYPanel"] = 0.328,
                ["disableBackgroundColor"] = true,
                ["func"] = function(pnl, panelLink, editVehicle, self)
                    RCD.customization = RCD.customization or {}

                    pnl.colorCube.OnUserChanged = function(pnl)
                        local color = pnl:GetRGB()

                        RCD.customization["vehicleUnderglow"] = color

                        local oldCustomization = RCD.ClientTable["vehiclesBought"][RCD.ClientTable["vehicleId"]]
                        oldCustomization = oldCustomization["customization"] or {}
                        
                        local price = RCD.GetPriceCustomization(RCD.ClientTable["vehicleSelected"]["options"], oldCustomization, RCD.customization)
                        RCD.ClientTable["priceCustomization"] = price
                    end

                    local reset = vgui.Create("RCD:Button", self)
                    reset:SetSize(RCD.ScrW*0.142, RCD.ScrW*0.016)
                    reset:SetPos(RCD.ScrW*0.003, RCD.ScrH*0.335)
                    reset:SetIconMaterial(nil)
                    reset:SetValue(RCD.GetSentence("reset"))
                    reset:SetHoveredColor(RCD.Colors["white80"])
                    reset:SetBackgroundColor(RCD.Colors["purple"])
                    reset:SetTextAlignement(TEXT_ALIGN_CENTER)
                    reset.RCDMinMaxLerp = {60, 120}
                    reset.DoClick = function()
                        local oldCustomization = RCD.ClientTable["vehiclesBought"][RCD.ClientTable["vehicleId"]]
                        oldCustomization = oldCustomization["customization"] or {}

                        pnl:SetColor(oldCustomization["vehicleUnderglow"])
                        RCD.customization["vehicleUnderglow"] = oldCustomization["vehicleUnderglow"]

                        local price = RCD.GetPriceCustomization(RCD.ClientTable["vehicleSelected"]["options"], oldCustomization, RCD.customization)
                        RCD.ClientTable["priceCustomization"] = price
                    end

                    if istable(RCD.ClientTable["vehiclesBought"]) && istable(RCD.ClientTable["vehiclesBought"][RCD.ClientTable["vehicleId"]]) then
                        local customization = RCD.ClientTable["vehiclesBought"][RCD.ClientTable["vehicleId"]]["customization"] or {}
                        if not istable(customization["vehicleUnderglow"]) then return end
                        
                        pnl:SetColor(customization["vehicleUnderglow"])
                        RCD.customization["vehicleUnderglow"] = customization["vehicleUnderglow"]
                    end
                end,
            },
        },
    },
    ["customizationSkin"] = {
        {
            {
                ["class"] = "DPanel",
                ["text"] = "",
                ["sizeX"] = 0.145,
                ["sizeY"] = 0.3,
                ["posX"] = 0,
                ["posY"] = 0.0015,
                ["sizeYPanel"] = 0,
                ["disableBackgroundColor"] = true,
                ["func"] = function(pnl, vehicleModel, editVehicle, accordion)
                    local ent = vehicleModel.Vehicles[RCD.ClientTable["vehicleId"]]
                    if not IsValid(ent) then accordion:Remove() end

                    local skinCount = ent:SkinCount()-1
                    if skinCount <= 0 then accordion:Remove() end

                    local dIconLayout = vgui.Create("DIconLayout", pnl)
                    dIconLayout:SetSpaceX(RCD.ScrW*0.002)
                    dIconLayout:SetSpaceY(RCD.ScrH*0.005)
                
                    local sizeY, y = 0, 0                    
                    for i=0, skinCount do
                        local skinButton = vgui.Create("RCD:SlideButton", dIconLayout)
                        skinButton:SetSize(RCD.ScrH*0.0195, RCD.ScrH*0.0195)
                        skinButton:SetText("")
                        skinButton.MinMaxLerp = {100, 255}
                        skinButton:SetIconMaterial(nil)
                        skinButton:SetButtonColor(RCD.Colors["purple"])
                        skinButton.PaintOver = function(self,w,h)
                            skinButton.MinMaxLerp[2] = (RCD.customization["vehicleSkin"] == i) and 100 or 255

                            draw.SimpleText(i, "RCD:Font:21", w/2, h/2, RCD.Colors["white100"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        end
                        skinButton.DoClick = function()
                            ent:SetSkin(i)

                            RCD.customization["vehicleSkin"] = i

                            local oldCustomization = RCD.ClientTable["vehiclesBought"][RCD.ClientTable["vehicleId"]]
                            oldCustomization = oldCustomization["customization"] or {}
                            
                            local price = RCD.GetPriceCustomization(RCD.ClientTable["vehicleSelected"]["options"], oldCustomization, RCD.customization)
                            RCD.ClientTable["priceCustomization"] = price
                        end

                        if (i)%11 == 1 then
                            sizeY = sizeY + skinButton:GetTall() + RCD.ScrH*0.005
                        end
                    end

                    dIconLayout:SetSize(RCD.ScrW*0.142, sizeY)
                    accordion:SetSizeY(sizeY+RCD.ScrH*0.005, true, true)

                    pnl.Paint = function() end

                    local options = RCD.ClientTable["vehicleSelected"]["options"]

                    local customization = RCD.ClientTable["vehiclesBought"][RCD.ClientTable["vehicleId"]]["customization"] or {}
                    if istable(RCD.ClientTable["vehiclesBought"]) && istable(RCD.ClientTable["vehiclesBought"][RCD.ClientTable["vehicleId"]]) && isnumber(customization["vehicleSkin"]) then

                        RCD.customization["vehicleSkin"] = customization["vehicleSkin"] or 0
                    else
                        RCD.customization["vehicleSkin"] = (options["skin"] or 0)
                    end
                end,
            },
        }, 
    },
    ["customizationBodygroups"] = {
        {
            {
                ["class"] = "DPanel",
                ["text"] = "",
                ["sizeX"] = 0.145,
                ["sizeY"] = 0.8,
                ["posX"] = 0,
                ["posY"] = 0.0015,
                ["sizeYPanel"] = 0,
                ["disableBackgroundColor"] = true,
                ["func"] = function(pnl, vehicleModel, editVehicle, accordion)
                    local ent = vehicleModel.Vehicles[RCD.ClientTable["vehicleId"]]
                    if not IsValid(ent) then accordion:Remove() end

                    local bodygroups = ent:GetBodyGroups()
                    if #bodygroups <= 1 then accordion:Remove() end

                    local scrollPanel = vgui.Create("RCD:DScroll", pnl)

                    local sizeY, count = 0, 0
                    for k,v in ipairs(bodygroups) do
                        if v.num <= 1 then continue end
                        if v.name == "" then continue end

                        local dLabel = vgui.Create("DLabel", scrollPanel)
                        dLabel:SetText(v.name:gsub("^%l", string.upper))
                        dLabel:SetFont("RCD:Font:21")
                        dLabel:Dock(TOP)

                        local dIconLayout = vgui.Create("DIconLayout", scrollPanel)
                        dIconLayout:SetSpaceX(RCD.ScrW*0.002)
                        dIconLayout:SetSpaceY(RCD.ScrH*0.005)
                        dIconLayout:Dock(TOP)
                        
                        for i=0, v.num-1 do
                            local bodygroupButton = vgui.Create("RCD:SlideButton", dIconLayout)
                            bodygroupButton:SetSize(RCD.ScrH*0.0195, RCD.ScrH*0.0195)
                            bodygroupButton:SetText("")
                            bodygroupButton.MinMaxLerp = {100, 255}
                            bodygroupButton:SetIconMaterial(nil)
                            bodygroupButton:SetButtonColor(RCD.Colors["purple"])
                            bodygroupButton.DoClick = function()
                                ent:SetBodygroup(v.id, i)
                                
                                RCD.customization["vehicleBodygroups"] = RCD.customization["vehicleBodygroups"] or {}
                                RCD.customization["vehicleBodygroups"][v.id] = i
                                
                                local oldCustomization = RCD.ClientTable["vehiclesBought"][RCD.ClientTable["vehicleId"]]
                                oldCustomization = oldCustomization["customization"] or {}
                                
                                local price = RCD.GetPriceCustomization(RCD.ClientTable["vehicleSelected"]["options"], oldCustomization, RCD.customization)
                                RCD.ClientTable["priceCustomization"] = price
                            end
                            bodygroupButton.PaintOver = function(self,w,h)
                                RCD.customization["vehicleBodygroups"] = RCD.customization["vehicleBodygroups"] or {}
                                draw.SimpleText(i, "RCD:Font:21", w/2, h/2, RCD.Colors["white100"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                                
                                bodygroupButton.MinMaxLerp[2] = (RCD.customization["vehicleBodygroups"][v.id] == i) and 100 or 255
                            end
                        end

                        local y = math.ceil(v.num/11)
                        sizeY = sizeY + y*RCD.ScrH*0.0195 + (y-1)*dIconLayout:GetSpaceY() + dLabel:GetTall()

                        count = count + 1
                    end

                    if istable(RCD.ClientTable["vehiclesBought"]) && istable(RCD.ClientTable["vehiclesBought"][RCD.ClientTable["vehicleId"]]) then
                        local customization = RCD.ClientTable["vehiclesBought"][RCD.ClientTable["vehicleId"]]["customization"] or {}

                        RCD.customization["vehicleBodygroups"] = customization["vehicleBodygroups"]
                    end

                    if count <= 0 then accordion:Remove() end
                    scrollPanel:SetSize(RCD.ScrW*0.142, sizeY)
                    accordion:SetSizeY(sizeY, true)

                    pnl.Paint = function() end
                end,
            },
        }, 
    },
    ["priceSettings"] = {
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "priceToChangeBodygroups",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.468,
                ["posY"] = 0.012,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetRounded(6)
                    pnl:SetPlaceHolder("500")
                    pnl:SetNumeric(true)

                    RCD.vehicleConfig["priceBodygroup"] = 500

                    pnl.entry.OnChange = function()
                        RCD.vehicleConfig["priceBodygroup"] = pnl:GetText()
                    end

                    if editVehicle && editVehicle["options"] then
                        local price = tonumber(editVehicle["options"]["priceBodygroup"])

                        if isnumber(price) then
                            RCD.vehicleConfig["priceBodygroup"] = price

                            pnl:SetText(RCD.vehicleConfig["priceBodygroup"])
                        end
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "priceToChangeSkins",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.468,
                ["posY"] = 0.012,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetRounded(6)
                    pnl:SetPlaceHolder("1000")
                    pnl:SetNumeric(true)

                    RCD.vehicleConfig["priceSkin"] = 1000

                    pnl.entry.OnChange = function()
                        RCD.vehicleConfig["priceSkin"] = pnl:GetText()
                    end

                    if editVehicle && editVehicle["options"] then
                        local price = tonumber(editVehicle["options"]["priceSkin"])

                        if isnumber(price) then
                            RCD.vehicleConfig["priceSkin"] = price

                            pnl:SetText(RCD.vehicleConfig["priceSkin"])
                        end
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "priceToChangeColors",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.468,
                ["posY"] = 0.012,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetRounded(6)
                    pnl:SetPlaceHolder("500")
                    pnl:SetNumeric(true)

                    RCD.vehicleConfig["priceColor"] = 500

                    pnl.entry.OnChange = function()
                        RCD.vehicleConfig["priceColor"] = pnl:GetText()
                    end

                    if editVehicle && editVehicle["options"] then
                        local price = tonumber(editVehicle["options"]["priceColor"])

                        if isnumber(price) then
                            RCD.vehicleConfig["priceColor"] = price

                            pnl:SetText(RCD.vehicleConfig["priceColor"])
                        end
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "priceToChangeUnderglow",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.468,
                ["posY"] = 0.012,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetRounded(6)
                    pnl:SetPlaceHolder("2000")
                    pnl:SetNumeric(true)

                    RCD.vehicleConfig["priceUnderglow"] = 2000

                    pnl.entry.OnChange = function()
                        RCD.vehicleConfig["priceUnderglow"] = pnl:GetText()
                    end

                    if editVehicle && editVehicle["options"] then
                        local price = tonumber(editVehicle["options"]["priceUnderglow"])

                        if isnumber(price) then
                            RCD.vehicleConfig["priceUnderglow"] = price

                            pnl:SetText(RCD.vehicleConfig["priceUnderglow"])
                        end
                    end
                end,
            },
        },
        {
            {
                ["class"] = "RCD:TextEntry",
                ["text"] = "priceToBuyNitro",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.468,
                ["posY"] = 0.012,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetRounded(6)
                    pnl:SetPlaceHolder("2000")
                    pnl:SetNumeric(true)

                    RCD.vehicleConfig["priceNitro"] = 2000

                    pnl.entry.OnChange = function()
                        RCD.vehicleConfig["priceNitro"] = pnl:GetText()
                    end

                    if editVehicle && editVehicle["options"] then
                        local price = tonumber(editVehicle["options"]["priceNitro"])

                        if isnumber(price) then
                            RCD.vehicleConfig["priceNitro"] = price

                            pnl:SetText(RCD.vehicleConfig["priceNitro"])
                        end
                    end
                end,
            },
        },
    }
}

function RCD.AddToConfigCompatibilities()
    local compatibilitesTable = {}
    
    if WCD then
        compatibilitesTable[#compatibilitesTable + 1] = {
            {
                ["class"] = "DButton",
                ["text"] = "wcdTransfert",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetTextColor(RCD.Colors["white100"])
                    pnl:SetFont("RCD:Font:13")
                    
                    pnl.Paint = function(self, w, h)
                        pnl:SetText(RCD.GetSentence("import"))
                        draw.RoundedBox(6, 0, 0, w, h, RCD.Colors["white5"])
                    end
                    
                    pnl.DoClick = function()
                        RunConsoleCommand("rcd_transfert_wcd")
                    end
                end,
            },
        }
    end

    if VC then
        compatibilitesTable[#compatibilitesTable + 1] = {
            {
                ["class"] = "DButton",
                ["text"] = "vcmodTransfert",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetTextColor(RCD.Colors["white100"])
                    pnl:SetFont("RCD:Font:13")
                    
                    pnl.Paint = function(self, w, h)
                        pnl:SetText(RCD.GetSentence("import"))
                        draw.RoundedBox(6, 0, 0, w, h, RCD.Colors["white5"])
                    end

                    pnl.DoClick = function()
                        RunConsoleCommand("rcd_transfert_vcmod")
                    end
                end,
            },
        }
    end

    if AdvCarDealer then
        compatibilitesTable[#compatibilitesTable + 1] = {
            {
                ["class"] = "DButton",
                ["text"] = "advancedTransfert",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetTextColor(RCD.Colors["white100"])
                    pnl:SetFont("RCD:Font:13")
                    
                    pnl.Paint = function(self, w, h)
                        pnl:SetText(RCD.GetSentence("import"))
                        draw.RoundedBox(6, 0, 0, w, h, RCD.Colors["white5"])
                    end

                    pnl.DoClick = function()
                        RunConsoleCommand("rcd_transfert_advanced")
                    end
                end,
            },
        }
    end

    if ModernCarDealer then
        compatibilitesTable[#compatibilitesTable + 1] = {
            {
                ["class"] = "DButton",
                ["text"] = "modernTransfert",
                ["sizeX"] = 0.06,
                ["sizeY"] = 0.03,
                ["posX"] = 0.466,
                ["posY"] = 0.01,
                ["func"] = function(pnl, panelLink, editVehicle)
                    pnl:SetTextColor(RCD.Colors["white100"])
                    pnl:SetFont("RCD:Font:13")
                    
                    pnl.Paint = function(self, w, h)
                        pnl:SetText(RCD.GetSentence("import"))
                        draw.RoundedBox(6, 0, 0, w, h, RCD.Colors["white5"])
                    end

                    pnl.DoClick = function()
                        RunConsoleCommand("rcd_transfert_modern")
                    end
                end,
            },
        }
    end

    RCD.ParametersConfig["compatibilities"] = compatibilitesTable
end

timer.Simple(1, function()
    RCD.AddToConfigCompatibilities()
end)

--[[ All tables used on the admin menu ]]
RCD.AdvancedConfiguration = RCD.AdvancedConfiguration or {
    ["groupsList"] = {},
    ["vehiclesList"] = {},
    ["plateforms"] = {},
    ["vehicleSpawned"] = {},
    ["settings"] = {},
}

--[[ List all type of value for the NW functions ]]
RCD.TypeNet = RCD.TypeNet or {
    ["Player"] = "Entity",
    ["Vector"] = "Vector",
    ["Angle"] = "Angle",
    ["Entity"] = "Entity",
    ["number"] = "Float",
    ["string"] = "String",
    ["table"] = "Table",
    ["boolean"] = "Bool",
}

--[[ List all constants values ]]
RCD.Constants = {
    ["vectorNPC"] = Vector(0, 0, 25),
    ["vectorSimfphys"] = Vector(0, 0, 20),
    ["vectorOrigin"] = Vector(0, 0, 0),
    ["angleOrigin"] = Angle(0, 0, 0),
    ["vectorShowcase"] = Vector(0, -100, 15),
    ["vectorCompatibilities"] = Vector(0,0,25),
    ["angleParams"] = Angle(0, -30, 0),
    ["vectorInvoice"] = Vector(0, 7, 0.4),
    ["angleWheel"] = Angle(0, 180, 0),
    ["angle90"] = Angle(0, 90, 0),
    ["vectorJob"] = Vector(0, -100, 0),
}

--[[ All colors of the colorpicker ]]
RCD.ColorPaletteColors = {
    [1] = Color(255, 0, 0, 255),
    [2] = Color(255, 0, 97, 255),
    [3] = Color(255, 0, 192, 255),
    [4] = Color(128, 0, 255, 255),
    [5] = Color(23, 0, 255, 255),
    [6] = Color(0, 61, 255, 255),
    [7] = Color(0, 255, 255, 255),
    [8] = Color(0, 255, 158, 255),
    [9] = Color(0, 255, 61, 255),
    [10] = Color(27, 255, 0, 255),
    [11] = Color(0, 162, 255, 255),
    [12] = Color(128, 255, 0, 255),
    [13] = Color(226, 255, 0, 255),
    [14] = Color(255, 192, 0, 255),
    [15] = Color(255, 93, 0, 255),
    [16] = Color(128, 0, 0, 255),
    [17] = Color(128, 0, 95, 255),
    [18] = Color(61, 0, 128, 255),
    [19] = Color(0, 25, 128, 255),
    [20] = Color(0, 128, 128, 255),
    [21] = Color(0, 128, 25, 255),
    [22] = Color(61, 128, 0, 255),
    [23] = Color(128, 95, 0, 255),
    [24] = Color(128, 61, 61, 255),
    [25] = Color(128, 61, 111, 255),
    [26] = Color(95, 61, 128, 255),
    [27] = Color(61, 78, 128, 255),
    [28] = Color(61, 78, 128, 255),
    [29] = Color(61, 128,78, 255),
    [30] = Color(95, 128, 61, 255),
    [31] = Color(128, 111, 61, 255),
    [32] = Color(255, 128, 128, 255),
    [33] = Color(255, 128, 224, 255),
    [34] = Color(192, 128, 255, 255),
    [35] = Color(128, 160, 255, 255),
    [36] = Color(128, 255, 255, 255),
    [37] = Color(128, 255, 160, 255),
    [38] = Color(192, 255, 128, 255),
    [39] = Color(255, 224, 128, 255),
    [40] = Color(255, 255, 255, 255),
    [41] = Color(219, 219, 219, 255),
    [42] = Color(183, 183, 183, 255),
    [43] = Color(146, 146, 146, 255),
    [44] = Color(146, 146, 146, 255),
    [45] = Color(70, 70, 70, 255),
    [46] = Color(31, 31, 31, 255),
    [47] = Color(0, 0, 0, 255)
}
