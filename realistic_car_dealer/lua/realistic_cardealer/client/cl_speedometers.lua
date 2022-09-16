local lerpEngine, lerpBelt, redEngine, lerpEngineRed = 0, 0, false, 0
local lerpColorNitro = table.Copy(RCD.Colors["purple"])

hook.Add("HUDPaint", "RCD:HUDPaint:Speedometers", function()
    if not IsValid(RCD.LocalPlayer) then return end
    if not RCD.GetSetting("speedometerActivate", "boolean") then return end
    
    local plyVehc = RCD.LocalPlayer:GetVehicle()
    if not IsValid(plyVehc) then return end
    
    local vehc = RCD.GetVehicle(plyVehc)
    if not IsValid(vehc) then return end
    
    if istable(simfphys) && isfunction(RCD.LocalPlayer.IsDrivingSimfphys) && RCD.LocalPlayer:IsDrivingSimfphys() && RCD.DefaultSettings["activateSimfphysSpeedometer"] then return end

    local unitChoose = RCD.GetSetting("unitChoose", "string")
    local speed = RCD.GetSpeedVehicle(vehc, unitChoose)
    local partSpeed = speed*0.01

    local speedoCount = RCD.GetSetting("speedometerCount", "number")
    local speedoSpace = RCD.GetSetting("speedometerSpace", "number")
    local speedoSize = RCD.GetSetting("speedometerSize", "number")

    local posx, posy = RCD.ScrW*RCD.GetSetting("speedometerPosX", "number"), RCD.ScrH*RCD.GetSetting("speedometerPosY", "number")
    local size = RCD.ScrW*0.0005*speedoSize

    RCD.MaskStencil(function()
        RCD.DrawComplexCircle(posx, posy, size*0.73, 0, 180, RCD.Colors["white"])
        for i=1, speedoCount do
            
            local radius = 180/speedoCount
            local space = i*radius

            RCD.DrawComplexCircle(posx, posy, size, space, space + speedoSpace, RCD.Colors["white"])
        end
    end, function()
        RCD.DrawComplexCircle(posx, posy, size, 1, 180, RCD.Colors["white120"])
    end, true)
    
    local nitro = RCD.GetNWVariables("RCDNitro", vehc)

    RCD.MaskStencil(function()
        RCD.DrawComplexCircle(posx, posy, size*0.73, 0, 180, RCD.Colors["white"])
        for i=1, speedoCount do
            
            local radius = 180/speedoCount
            local space = i*radius
            
            RCD.DrawComplexCircle(posx, posy, size, space, space + speedoSpace, RCD.Colors["white"])
        end
    end, function()
        lerpColorNitro = RCD.LerpColor(FrameTime()*2, lerpColorNitro, (nitro and RCD.Colors["speedoRed"] or RCD.Colors["purple"]))

        RCD.DrawComplexCircle(posx, posy, size, 0, math.Clamp(180*partSpeed, 0, 180), lerpColorNitro)
    end, true)
    
    surface.SetDrawColor(RCD.Colors["white"])
    surface.SetMaterial(RCD.Materials["needle"])

    RCD.DrawTexturedRectRotatedPoint(posx, posy, RCD.ScrW*0.08, size*1.1, 90-math.Clamp(180*partSpeed, 0, 180), 0, -(size*1.1)/2)
    
    surface.SetDrawColor(RCD.Colors["white220"])
	surface.SetMaterial(RCD.Materials["gradient"])
	surface.DrawTexturedRect(posx-RCD.ScrH*0.3, posy-RCD.ScrH*0.45, RCD.ScrH*0.6, RCD.ScrH*0.6)

    local speedRound = math.Round(speed)

    surface.SetFont(RCD.CreateFonts(RCD.ScrH*0.005*(size*0.09), "Georama Light", 0, true))
    local fontSizeX, fontSizeY = surface.GetTextSize(unitChoose)

    
    draw.SimpleText(speedRound, RCD.CreateFonts(RCD.ScrH*0.005*(size*0.16), "Georama Black", 1000), posx, posy*0.975 - fontSizeY, RCD.Colors["white"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    draw.SimpleText(unitChoose, RCD.CreateFonts(RCD.ScrH*0.005*(size*0.075), "Georama Light", 0, true), posx, posy*0.99, RCD.Colors["white120"], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    
    local vehicleId = RCD.GetNWVariables("RCDVehicleId", vehc)
    local beltActivate = RCD.GetSetting("beltActivate", "boolean") && not RCD.GetVehicleParams(vehicleId, "disableBeltVehicle")

    --[[ Engine Module ]]
    if RCD.GetSetting("engineActivate", "boolean") && isfunction(vehc.GetDriver) && (vehc:GetDriver() == RCD.LocalPlayer) && not RCD.GetVehicleParams(vehicleId, "disableEngineVehicle") then
        local engineOn = hook.Run("RCD:CanChangeEngine", vehc)

        local posEngineX = (posx - size) - (beltActivate and RCD.ScrW*0.0001 or RCD.ScrW*0.0002)*size
        local sizeEngine = RCD.ScrW*0.00011*size
        local posEngineY = posy - (sizeEngine*(beltActivate and 3.5 or 1))
        
        local engineStatut = RCD.GetNWVariables("RCDEngine", vehc) && (engineOn != false)

        lerpEngine = Lerp(FrameTime()*5, lerpEngine, (engineStatut and sizeEngine or 0))
        
        RCD.DrawComplexCircle(posEngineX, posEngineY, sizeEngine, 0, 360, RCD.Colors["white80248"])
        RCD.DrawComplexCircle(posEngineX, posEngineY, lerpEngine, 0, 361, RCD.Colors["purple"])

        lerpEngineRed = Lerp(FrameTime()*5, lerpEngineRed, (redEngine and sizeEngine or 0))

        RCD.DrawComplexCircle(posEngineX, posEngineY, lerpEngineRed, 0, 361, RCD.Colors["speedoRed"])
        
        local iconSize = sizeEngine*0.9

        draw.SimpleText(string.upper(input.GetKeyName(RCD.GetSetting("engineKey", "number"))), RCD.CreateFonts(RCD.ScrH*0.005*(size*0.05), "Georama Bold", 1000), posEngineX-(iconSize*1.5), posEngineY-(sizeEngine*0.4), RCD.Colors["white120"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

        surface.SetDrawColor(RCD.Colors["white"])
        surface.SetMaterial(RCD.Materials["engine"])
        surface.DrawTexturedRect(posEngineX-iconSize/2, posEngineY-iconSize/2, iconSize, iconSize)
    end
    
    --[[ Belt Module ]]
    if beltActivate then
        local posBeltX = (posx - size) - RCD.ScrW*0.0002*size
        local sizeBelt = RCD.ScrW*0.00011*size
        local posBeltY = posy - sizeBelt

        local securityBelt = RCD.GetNWVariables("RCDSecurityBelt", RCD.LocalPlayer)

        lerpBelt = Lerp(FrameTime()*5, lerpBelt, (securityBelt and sizeBelt or 0))
        
        RCD.DrawComplexCircle(posBeltX, posBeltY, sizeBelt, 0, 360, RCD.Colors["white80248"])
        RCD.DrawComplexCircle(posBeltX, posBeltY, lerpBelt, 0, 361, RCD.Colors["purple"])
        
        local iconSize = sizeBelt*0.9
        draw.SimpleText(string.upper(input.GetKeyName(RCD.GetSetting("beltKey", "number"))), RCD.CreateFonts(RCD.ScrH*0.005*(size*0.05), "Georama Bold", 1000), posBeltX-(iconSize*1.5), posBeltY-(sizeBelt*0.4), RCD.Colors["white120"], TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        
        surface.SetDrawColor(RCD.Colors["white"])
        surface.SetMaterial(RCD.Materials["belt"])
        surface.DrawTexturedRect((posBeltX-iconSize/2), posBeltY-iconSize/2, iconSize, iconSize)
    end
end)

hook.Add("RCD:CanChangeEngine", "RCD:CanChangeEngine:Compatibilities", function(vehc)
    if not IsValid(vehc) then return end

    if vehc:WaterLevel() >= 2 then 
        local vehicleId = RCD.GetNWVariables("RCDVehicleId", vehc)
        local vehicleTable = RCD.GetVehicleInfo(vehicleId) or {}

        local options = vehicleTable["options"] or {}
        if options["isBoat"] then return end

        return false
    end

    local health, fuel = 100, 100
    if not vehc.IsSimfphyscar then
        if VC && isfunction(vehc.VC_getHealth) && isfunction(vehc.VC_fuelGet) then
            health = vehc:VC_getHealth(true)        
            fuel = vehc:VC_fuelGet(true)
        elseif SVMOD && SVMOD:GetAddonState() && isfunction(vehc.SV_GetHealth) && isfunction(vehc.SV_GetFuel) then
            health = vehc:SV_GetHealth()
            fuel = vehc:SV_GetFuel()
        end
    elseif vehc.IsSimfphyscar && isfunction(vehc.GetCurHealth) && isfunction(vehc.GetFuel) then
        health = vehc:GetCurHealth()
        fuel = vehc:GetFuel()
    end
    
    if fuel <= 0 then return false end
    if health <= 0 then return false end
end)

hook.Add("KeyPress", "RCD:KeyPress:CheckEngine", function(ply, key)
    if not IsValid(RCD.LocalPlayer) then return end

    local plyVehc = RCD.LocalPlayer:GetVehicle()
    if not IsValid(plyVehc) then return end

    local vehc = RCD.GetVehicle(plyVehc)
    if not IsValid(vehc) then return end

    local engineOn = hook.Run("RCD:CanChangeEngine", vehc)
    local engineStatut = RCD.GetNWVariables("RCDEngine", vehc) && (engineOn != false)

    if key == IN_FORWARD && not redEngine && not engineStatut && not RCD.GetVehicleParams(vehicleId, "disableEngineVehicle") then
        redEngine = true

        timer.Simple(0.7, function()
            redEngine = false
        end)
    end
end)