--[[
 _____            _ _     _   _        _____      _ _             _____           _                 
|  __ \          | (_)   | | (_)      |  __ \    | (_)           / ____|         | |                
| |__) |___  __ _| |_ ___| |_ _  ___  | |__) |__ | |_  ___ ___  | (___  _   _ ___| |_ ___ _ __ ___  
|  _  // _ \/ _` | | / __| __| |/ __| |  ___/ _ \| | |/ __/ _ \  \___ \| | | / __| __/ _ \ '_ ` _ \ 
| | \ \  __/ (_| | | \__ \ |_| | (__  | |  | (_) | | | (_|  __/  ____) | |_| \__ \ ||  __/ | | | | |
|_|  \_\___|\__,_|_|_|___/\__|_|\___| |_|   \___/|_|_|\___\___| |_____/ \__, |___/\__\___|_| |_| |_|
                                                                                                                                         
--]]

-- Information of the License Plate Position 
net.Receive("RealisticPolice:SendInformation", function()
    RPTInformationVehicle = {}
    local Number = net.ReadInt(32)
    local RPTInformationDecompress = util.Decompress(net.ReadData(Number)) or ""
    local RPTTable = util.JSONToTable(RPTInformationDecompress) 

    RPTInformationVehicle = Realistic_Police.BaseVehicles

    if istable(util.JSONToTable(RPTInformationDecompress)) then 
        table.Merge(RPTInformationVehicle, util.JSONToTable(RPTInformationDecompress))
    end 
end ) 

local FontTable = {}
function Realistic_Police.Fonts(SizeId, fontName)
    if table.HasValue(FontTable, "rpt_generate"..math.Round( SizeId, 0 )) then 
        return "rpt_generate"..math.Round( SizeId, 0 )
    end 
    local succ, err = pcall(function() 
        local font = "License Plate"
        if isstring(fontName) then
            font = fontName
        end

        surface.CreateFont("rpt_generate"..math.Round( SizeId, 0 ), {
            font = font, 
            size = math.Round( SizeId, 0 ), 
            weight = 800,
            antialias = true,
            extended = true, 
        })
        table.insert(FontTable, "rpt_generate"..math.Round( SizeId, 0 ))
    end)
    return succ and "rpt_generate"..math.Round( SizeId, 0 ) or "rpt_notify_24"
end 

function Realistic_Police.Circle( x, y, radius, seg )
	local cir = {}
	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end
	local a = math.rad( 0 )
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	surface.DrawPoly( cir )
end

local function CreateNumSlider(id, x, y, panel, min, max)
    local TableSlider = {
        [1] = Realistic_Police.GetSentence("moveX"),
        [2] = Realistic_Police.GetSentence("moveY"),
        [3] = Realistic_Police.GetSentence("moveZ"),
        [4] = Realistic_Police.GetSentence("rotateX"),
        [5] = Realistic_Police.GetSentence("rotateY"),
        [6] = Realistic_Police.GetSentence("rotateZ"),
        [7] = Realistic_Police.GetSentence("width"),
        [8] = Realistic_Police.GetSentence("height"),
    }

    local W,H = ScrW(), ScrH()
    DermaNumSlider = vgui.Create( "DNumSlider", panel )
    DermaNumSlider:SetPos( W*x, H*y  )
    DermaNumSlider:SetSize( W*0.25, H*0.01 )
    DermaNumSlider:SetText( "" )
    DermaNumSlider:SetMin( min )
    DermaNumSlider:SetMax( max )	
    DermaNumSlider:SetDecimals( 0 )
    DermaNumSlider:SetDefaultValue ( 1 )
    function DermaNumSlider.Slider:Paint(w, h)
        surface.SetDrawColor( Realistic_Police.Colors["black13"] )
        surface.DrawRect( 0, 0, w, h )
    end 
    function DermaNumSlider.Slider.Knob:Paint(w, h)
        surface.SetDrawColor( Realistic_Police.Colors["black"] )
	    draw.NoTexture()
	    Realistic_Police.Circle( 0, H*0.007, 8, 1000 )
    end 
    DermaNumSlider.OnValueChanged = function( panel, value )
        if RPTStepID == 2 then 
            RPTPosition[id] = value
        elseif RPTStepID == 3 then 
            RPTPosition2[id] = value
        end 
    end  

    local PosX, PosY = DermaNumSlider:GetPos()
    if id > 0 && id < 4 or id == 7 then 
        local DLabel = vgui.Create( "DLabel", panel )
        DLabel:SetSize(W*0.3, H*0.02)
        DLabel:SetPos( DermaNumSlider:GetWide()*0.052, PosY - H *0.03)
        DLabel:SetText( TableSlider[id] )
        DLabel:SetFont("rpt_font_18")
    elseif id != 7 then 
        local DLabel = vgui.Create( "DLabel", panel )
        DLabel:SetSize(W*0.3, H*0.02)
        DLabel:SetPos( DermaNumSlider:GetWide()*0.66, PosY - H *0.03)
        DLabel:SetText( TableSlider[id] )
        DLabel:SetFont("rpt_font_18")
    end 
end 

function Realistic_Police.Clic()
    surface.PlaySound("rptsound2.mp3")
end 

local function RPTComputerView(ply, pos, angles, fov)
    local view = {}
    view.origin = pos
    view.angles = angles
    view.fov = fov
    view.drawviewer = true
    return view
end

function Realistic_Police.OpenMenu(RPTEntComputer, BoolTablet)
    if IsValid(RPTBaseFrame) then RPTBaseFrame:Remove() end 
    local RpRespX, RpRespY = ScrW(), ScrH()
    
	local RPTAngle = RPTEntComputer:GetAngles() + Angle(-RPTEntComputer:GetAngles().pitch * 2, 180,-RPTEntComputer:GetAngles().roll *2)
	local RPTAng = RPTEntComputer:GetAngles()
	local RPTPos = RPTEntComputer:GetPos() + RPTAng:Up() * 19.5 + RPTAng:Right() * -1 + RPTAng:Forward() * 8
	local RPTStartTime = CurTime()
    
    local RPTValue = 300
    local RPTTarget = 200
    local speed = 40
    local Timer = 1.1 

    local Hours = os.date("%H:%M", os.time())
    hook.Add("CalcView", "RPTCalcView", function(ply, pos, angles, fov) 
        local FOV = 90 
        if not BoolTablet then 
            if RPTInt != 0 then 
                RPTAngleOrigin = LerpVector( math.Clamp(CurTime()-RPTStartTime,0,1), LocalPlayer():EyePos(), RPTPos)
                RPTAngleAngles = LerpAngle( math.Clamp(CurTime()-RPTStartTime,0,1), LocalPlayer():GetAngles(), RPTAngle)
                FOV = 90 
            else 
                RPTAngleOrigin = pos
                RPTAngleAngles = angles
                FOV = fov
            end 
            return RPTComputerView(LocalPlayer(), RPTAngleOrigin, RPTAngleAngles, FOV)
        end 
    end )
    
    RPTBaseFrame = vgui.Create("DFrame")
	RPTBaseFrame:SetSize(RpRespX, RpRespY)
	RPTBaseFrame:MakePopup()
	RPTBaseFrame:ShowCloseButton(false)
	RPTBaseFrame:SetDraggable(false)
	RPTBaseFrame:SetTitle("")
    LocalPlayer():SetNoDraw(true)
    RPTBaseFrame.Paint = function(self,w,h) 
        if BoolTablet then 
            surface.SetDrawColor( Realistic_Police.Colors["white"] )
            surface.SetMaterial( Realistic_Police.Colors["Material10"] )
            surface.DrawTexturedRect( RpRespX*0.0625, RpRespY*0.025, w*0.865, h*0.89 )
        end 
    end 
    if BoolTablet then 
        Timer = 0 
    end  
    timer.Simple(Timer, function()
        RPTFrame = vgui.Create("DPanel", RPTBaseFrame) 
        RPTFrame:SetSize(RpRespX*0.794, RpRespY*0.793)
        RPTFrame:SetPos(RpRespX*0.1, RpRespY*0.06)
        RPTFrame.Paint = function(self,w,h)
            if not BoolTablet then 
                surface.SetDrawColor( Realistic_Police.Colors["white"] )
                surface.SetMaterial( Realistic_Police.Colors["Material2"] )
                surface.DrawTexturedRect( 0, 0, w, h )
            end 

            surface.SetDrawColor( Realistic_Police.Colors["white200"] )
            surface.SetMaterial( Realistic_Police.Colors["Material3"] )
            surface.DrawTexturedRect( RpRespX*0.015, RpRespY*0.73, w*0.9713, h*0.0555 )
            draw.SimpleText(Hours, "rpt_font_15", RpRespX*0.764, RpRespY*0.738, Realistic_Police.Colors["white"], 1, 0)
        end 

        for k,v in pairs(Realistic_Police.Application) do 
            if k >= 99 then break end 
            local row = math.floor((k - 1)/7)
            local rowmarge = row * RpRespY
            local colum = k - (row * RpRespY*0.02)
            local colmarge = (colum  * 464) - 464

            local Buttons = vgui.Create("DButton", RPTFrame)
            Buttons:SetSize(RpRespX*0.047,RpRespX*0.047)
            Buttons:SetPos(RpRespX*0.013 + rowmarge, RpRespY*0.092 * colum - RpRespY*0.08)
            Buttons:SetText("")
            Buttons.Paint = function(self,w,h)
                if self:IsHovered() then 
                    RPTValue = Lerp( speed * FrameTime( ), RPTValue, RPTTarget )
                    surface.SetDrawColor( Realistic_Police.Colors["white"].r, Realistic_Police.Colors["white"].g, Realistic_Police.Colors["white"].b, RPTValue )
                    surface.SetMaterial( v.Materials )
                    surface.DrawTexturedRect( 5, 5, w - 15, h - 15  )
                else 
                    surface.SetDrawColor( Realistic_Police.Colors["white"] )
                    surface.SetMaterial( v.Materials )
                    surface.DrawTexturedRect( 5, 5, w - 15, h - 15  )
                end 
            end 
            Buttons.DoClick = function()
                Realistic_Police.Clic()
                if LocalPlayer():isCP() then 
                    v.Function(RPTFrame, RPTEntComputer)
                end 
                if Realistic_Police.HackerJob[team.GetName(LocalPlayer():Team())] && RPTEntComputer:GetNWBool("rpt_hack") or v.Type == "hacker" then 
                    v.Function(RPTFrame, RPTEntComputer)
                elseif not LocalPlayer():isCP() then 
                    RealisticPoliceNotify(Realistic_Police.GetSentence("computerMustBeHacked"))
                end 
            end 

            local DLabel = vgui.Create( "DLabel", RPTFrame )
            DLabel:SetSize(RpRespX*0.08, RpRespY*0.01)
            DLabel:SetPos(-7 + rowmarge, RpRespY*0.092 * colum)
            DLabel:SetText( v.Name )
            DLabel:SetFont("rpt_font_14")
            DLabel:SetContentAlignment(5)
            DLabel:SetTextColor(Realistic_Police.Colors["gray"])
        end 

        local RPTClose = vgui.Create("DButton", RPTFrame)
        RPTClose:SetSize(RpRespX*0.021,RpRespX*0.0199)
        RPTClose:SetPos(RpRespX*0.018, RPTFrame:GetTall()*0.928)
        RPTClose:SetText("")
        RPTClose.DoClick = function()
            RPTBaseFrame:Remove()
            LocalPlayer():SetNoDraw(false)
            Realistic_Police.Clic()
            hook.Remove("CalcView", "RPTCalcView")
            net.Start("RealisticPolice:SecurityCamera")
                net.WriteString("DontShowCamera")
            net.SendToServer()
        end 
        RPTClose.Paint = function(self,w,h)
            surface.SetDrawColor( Realistic_Police.Colors["white150"] )
            surface.SetMaterial( Realistic_Police.Colors["Material6"] )
            surface.DrawTexturedRect( 0, 0, w, h )
        end 
    end ) 
end

net.Receive("RealisticPolice:SetupVehicle", function()
    if not Realistic_Police.AdminRank[LocalPlayer():GetUserGroup()] then return end 
    local W,H = ScrW(), ScrH()
    local Ent = net.ReadEntity()
    local TableToSave = {}
    
    if IsValid(RPTMain) then RPTMain:Remove() end 
    RPTMain = vgui.Create("DFrame")
    RPTMain:SetSize(W*0.3, H*0.36)
    RPTMain:SetPos(W*0.35, H*0.65)
    RPTMain:SetTitle("")
    RPTMain:ShowCloseButton(false)
    RPTMain.Paint = function(self,w,h) 
        surface.SetDrawColor( Realistic_Police.Colors["black49"] )
        surface.DrawRect( 0, 0, w, h/1.95 )

        surface.SetDrawColor( Realistic_Police.Colors["black49"] )
        surface.DrawRect( 0, h/1.90, w, h/5 )
    end 
    -- Right Sliders
    CreateNumSlider(4, 0.06,0.05, RPTMain,-200, 200)
    CreateNumSlider(5, 0.06, 0.10, RPTMain,-200, 200)
    CreateNumSlider(6, 0.06, 0.15, RPTMain,-200, 200)
    -- Left Sliders 
    CreateNumSlider(1,-0.09,0.05, RPTMain,-100, 100)
    CreateNumSlider(2, -0.09, 0.10, RPTMain,-100, 100)
    CreateNumSlider(3, -0.09, 0.15, RPTMain,-100, 100)
    -- Back Sliders 
    CreateNumSlider(8, 0.06, 0.235, RPTMain, -200, 1000)
    CreateNumSlider(7, -0.09, 0.235, RPTMain, -1200, 1200)

    local Save = vgui.Create("DButton", RPTMain)
    Save:SetSize(W*0.3, H*0.07)
    Save:SetPos(0,RPTMain:GetTall()*0.74)
    Save:SetText(string.upper(Realistic_Police.GetSentence("save")))
    Save:SetFont("rpt_font_18")
    Save:SetTextColor(Realistic_Police.Colors["white200"])
    Save.Paint = function(self,w,h)
        surface.SetDrawColor( Realistic_Police.Colors["green"] )
        surface.DrawRect( 0, 0, w, h )
    end 
    Save.DoClick = function()
        if not isvector(PosPlate) && not isangle(AngleEnt) then return end 
        local VectorEnt = PosPlate + Vector(RPTPosition[1],RPTPosition[2],RPTPosition[3]) 
        local AngleEnt = AngPlate + Angle(RPTPosition[4],RPTPosition[5],RPTPosition[6])
        local pos = Ent:WorldToLocal(VectorEnt)

        local VectorEnt2 = nil 
        local AngleEnt2 = nil   
        local pos2 = nil
        if isvector(PosPlate2) && isangle(AngPlate2) then 
            VectorEnt2 = PosPlate2 + Vector(RPTPosition2[1],RPTPosition2[2],RPTPosition2[3]) 
            AngleEnt2 = AngPlate2 + Angle(RPTPosition2[4],RPTPosition2[5],RPTPosition2[6])
            pos2 = Ent:WorldToLocal(VectorEnt2)      
        end 

        TableToSave[Ent:GetModel()] = {
            Plate1 = {
                PlateVector = pos, 
                PlateAngle = AngleEnt, 
                PlateSizeW = 1400 + RPTPosition[7],
                PlateSizeH = 400 + RPTPosition[8], 
            },
            Plate2 = {
                PlateVector = pos2, 
                PlateAngle = AngleEnt2, 
                PlateSizeW = 1400 + RPTPosition2[7],
                PlateSizeH = 400 + RPTPosition2[8], 
            },
        }
        if PosPlate2 == nil or AngPlate2 == nil then
            TableToSave[Ent:GetModel()]["Plate2"] = nil 
        end 
    
        net.Start("RealisticPolice:SetupVehicle")
            net.WriteTable(TableToSave)
            net.WriteEntity(Ent)
        net.SendToServer()

        RPTMain:Remove()
        PosPlate = nil 
        RPTToolSetup = false 
        RPTStepID = 1
        VectorEnt2 = nil 
        AngleEnt2 = nil   
        pos2 = nil

        RPTPosition = {}
        RPTPosition2 = {}
        Realistic_Police.Clic()
    end  
end ) 

function Realistic_Police.PoliceTrunk()
    local RespX, RespY = ScrW(), ScrH()
    if IsValid(Frame) then Frame:Remove() end 
    if IsValid(RPTEGhostent) then RPTEGhostent:Remove() end 
    RealisticPoliceGhost = false 
    RealisticPoliceModel = nil 
    Frame = vgui.Create("DFrame")
    Frame:SetSize(RespX*0.289, RespX*0.08)
    Frame:MakePopup()
    Frame:SetDraggable(false)
    Frame:ShowCloseButton(false)
    Frame:SetTitle("")
    Frame:Center()
    Frame.Paint = function(self,w,h)
        surface.SetDrawColor( Realistic_Police.Colors["black25"] )
        surface.DrawRect( 0, 0, w, h )
        surface.SetDrawColor( Realistic_Police.Colors["gray60200"] )
        surface.DrawOutlinedRect( 0, 0, w, h )
        surface.SetDrawColor( Realistic_Police.Colors["black15"] )
        surface.DrawRect( 0, 0, w, h )
        draw.DrawText(Realistic_Police.GetSentence("policeCartrunk"), "rpt_font_7", RespX*0.003, RespY*0.002, Realistic_Police.Colors["gray220"], TEXT_ALIGN_LEFT)
    end 

    local DScroll = vgui.Create("DScrollPanel", Frame) 
    DScroll:SetSize(RespX*0.2788, RespY*0.096)
    DScroll:SetPos(RespX*0.005, RespY*0.035)
    DScroll.Paint = function() end 
    DScroll:GetVBar():SetSize(0,0)

    local List = vgui.Create( "DIconLayout", DScroll )
    List:Dock( FILL )
    List:SetSpaceY( 5 )
    List:SetSpaceX( 5 ) 

    for k,v in pairs(Realistic_Police.Trunk) do
        local ListItem = List:Add( "SpawnIcon" ) 
        ListItem:SetSize( RespX*0.0541, RespX*0.0541 )
        ListItem:SetModel(k)
        ListItem:SetTooltip( false )
        ListItem.DoClick = function()
            RealisticPoliceGhost = true 
            RealisticPoliceModel = k
            Frame:Remove()
            RealisticPoliceNotify(Realistic_Police.GetSentence("spawnPropText"))
        end 
    end

    local RPTClose = vgui.Create("DButton", Frame)
    RPTClose:SetSize(RespX*0.03, RespY*0.025)
    RPTClose:SetPos(Frame:GetWide()*0.89, Frame:GetTall()*0.008)
    RPTClose:SetText("")
    RPTClose.Paint = function(self,w,h) 
        surface.SetDrawColor( Realistic_Police.Colors["red"] )
        surface.DrawRect( 0, 0, w, h )
    end 
    RPTClose.DoClick = function()
        LocalPlayer():SetNoDraw(false)
        Frame:Remove()
        Realistic_Police.Clic()
    end   
end 

local function RealisticPolicePlate(ent, pos, ang, String)
    cam.Start3D2D( ent:LocalToWorld(pos), ent:LocalToWorldAngles(ang), 0.02 )
        if not IsValid(ent) then return end 
        if isstring(Realistic_Police.PlateVehicle[ent:GetVehicleClass()]) then 
            ent.Plate = Realistic_Police.PlateVehicle[ent:GetVehicleClass()]
        else 
            ent.Plate = Realistic_Police.LangagePlate
        end 
        if Realistic_Police.PlateConfig[ent.Plate]["Image"] != nil then 
            surface.SetDrawColor( Realistic_Police.Colors["gray240"] )
            surface.SetMaterial( Realistic_Police.PlateConfig[ent.Plate]["Image"] )
            surface.DrawTexturedRect( 0, 0, RPTInformationVehicle[ent:GetModel()][String]["PlateSizeW"], RPTInformationVehicle[ent:GetModel()][String]["PlateSizeH"] )
        end
        local plateName = ent:GetNWString("rpt_plate")
        if not Realistic_Police.PlateConfig[ent.Plate]["PlateText"] then             
            if plateName != "" then 
                local StringExplode = string.Explode(" ", plateName) or ""
                if istable(StringExplode) && isstring(StringExplode[1]) && isstring(StringExplode[2]) && isstring(StringExplode[3]) then
                    plateName = StringExplode[1]..StringExplode[2]..StringExplode[3]
                end 
                draw.SimpleText(plateName, Realistic_Police.Fonts(RPTInformationVehicle[ent:GetModel()][String]["PlateSizeW"]/6, (Realistic_Police.Lang == "ru" and "DermaDefault" or nil)),RPTInformationVehicle[ent:GetModel()][String]["PlateSizeW"]/Realistic_Police.PlateConfig[ent.Plate]["PlatePos"][1] - 5, RPTInformationVehicle[ent:GetModel()][String]["PlateSizeH"]/ Realistic_Police.PlateConfig[ent.Plate]["PlatePos"][2]+5, Realistic_Police.Colors["white"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
                draw.SimpleText(plateName, Realistic_Police.Fonts(RPTInformationVehicle[ent:GetModel()][String]["PlateSizeW"]/6, (Realistic_Police.Lang == "ru" and "DermaDefault" or nil)),RPTInformationVehicle[ent:GetModel()][String]["PlateSizeW"]/Realistic_Police.PlateConfig[ent.Plate]["PlatePos"][1], RPTInformationVehicle[ent:GetModel()][String]["PlateSizeH"]/ Realistic_Police.PlateConfig[ent.Plate]["PlatePos"][2], Realistic_Police.PlateConfig[ent.Plate]["TextColor"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
            end 
        else
            if plateName != "" then
                local StringExplode = string.Explode(" ", plateName) or ""
                if istable(StringExplode) && isstring(StringExplode[1]) && isstring(StringExplode[2]) && isstring(StringExplode[3]) then
                    plateName = StringExplode[1].."-"..StringExplode[2].."-"..StringExplode[3]
                end 
                draw.SimpleText(plateName, Realistic_Police.Fonts(RPTInformationVehicle[ent:GetModel()][String]["PlateSizeW"]/6, (Realistic_Police.Lang == "ru" and "DermaDefault" or nil)),RPTInformationVehicle[ent:GetModel()][String]["PlateSizeW"]/Realistic_Police.PlateConfig[ent.Plate]["PlatePos"][1] - 5, RPTInformationVehicle[ent:GetModel()][String]["PlateSizeH"]/ Realistic_Police.PlateConfig[ent.Plate]["PlatePos"][2]+5, Realistic_Police.Colors["white"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
                draw.SimpleText(plateName, Realistic_Police.Fonts(RPTInformationVehicle[ent:GetModel()][String]["PlateSizeW"]/6, (Realistic_Police.Lang == "ru" and "DermaDefault" or nil)),RPTInformationVehicle[ent:GetModel()][String]["PlateSizeW"]/Realistic_Police.PlateConfig[ent.Plate]["PlatePos"][1], RPTInformationVehicle[ent:GetModel()][String]["PlateSizeH"]/ Realistic_Police.PlateConfig[ent.Plate]["PlatePos"][2], Realistic_Police.PlateConfig[ent.Plate]["TextColor"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
            end 
        end 
        if Realistic_Police.PlateConfig[ent.Plate]["Country"] != nil then 
            draw.SimpleText(Realistic_Police.PlateConfig[ent.Plate]["Country"], Realistic_Police.Fonts(RPTInformationVehicle[ent:GetModel()][String]["PlateSizeW"]/12), RPTInformationVehicle[ent:GetModel()][String]["PlateSizeW"] - RPTInformationVehicle[ent:GetModel()][String]["PlateSizeW"]/Realistic_Police.PlateConfig[ent.Plate]["CountryPos"][1], RPTInformationVehicle[ent:GetModel()][String]["PlateSizeH"]/Realistic_Police.PlateConfig[ent.Plate]["CountryPos"][2], Realistic_Police.PlateConfig[ent.Plate]["CountryColor"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
        end 
        if Realistic_Police.PlateConfig[ent.Plate]["Department"] != nil then 
            draw.SimpleText(Realistic_Police.PlateConfig[ent.Plate]["Department"], Realistic_Police.Fonts(RPTInformationVehicle[ent:GetModel()][String]["PlateSizeW"]/13), RPTInformationVehicle[ent:GetModel()][String]["PlateSizeW"]/1.06, RPTInformationVehicle[ent:GetModel()][String]["PlateSizeH"]/1.4, Realistic_Police.Colors["gray"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
        end 
        if Realistic_Police.PlateConfig[ent.Plate]["ImageServer"] != nil then 
            surface.SetDrawColor( Realistic_Police.Colors["gray"] )
            surface.SetMaterial( Realistic_Police.PlateConfig[ent.Plate]["ImageServer"] )
            surface.DrawTexturedRect( RPTInformationVehicle[ent:GetModel()][String]["PlateSizeW"]/1.104, RPTInformationVehicle[ent:GetModel()][String]["PlateSizeH"]/6, RPTInformationVehicle[ent:GetModel()][String]["PlateSizeW"]/14, RPTInformationVehicle[ent:GetModel()][String]["PlateSizeH"]/3 )
        end 
    cam.End3D2D()
end 

local VehicleTable = {}
hook.Add( "OnEntityCreated", "RPT:OnEntityCreated", function( ent )
    if IsValid(ent) && ent:IsVehicle() or ent:GetClass() == "gmod_sent_vehicle_fphysics_base" then 
        VehicleTable[#VehicleTable + 1] = ent
    end 
end )

hook.Add("PostDrawTranslucentRenderables", "RPT:LicensePlateD", function(bDepth, bSkybox) -- Draw Plate  
    if ( bSkybox ) then return end
    for k, ent in pairs( VehicleTable ) do
        if Realistic_Police.TrunkSystem && Realistic_Police.KeyTrunkHUD then 
            if IsValid(ent) && ent:IsVehicle() then 
                if ent:GetClass() == "prop_vehicle_jeep" or ent:GetClass() == "gmod_sent_vehicle_fphysics_base" then 
                    if LocalPlayer():GetPos():DistToSqr(ent:LocalToWorld(Vector(0, - ent:OBBMaxs().y))) < 60000 && Realistic_Police.VehiclePoliceTrunk[ent:GetVehicleClass()] then
                        
                        cam.Start3D2D( istable(Realistic_Police.TrunkPosition[ent:GetVehicleClass()]) and ent:LocalToWorld(Vector(0 + Realistic_Police.TrunkPosition[ent:GetVehicleClass()]["Pos"].x, - ent:OBBMaxs().y + Realistic_Police.TrunkPosition[ent:GetVehicleClass()]["Pos"].y, ent:OBBMaxs().z*0.5 + Realistic_Police.TrunkPosition[ent:GetVehicleClass()]["Pos"].z)) or ent:LocalToWorld(Vector(0, - ent:OBBMaxs().y, ent:OBBMaxs().z*0.5)), ent:GetAngles() + Angle(0,0,90), 0.1 )
                            surface.SetDrawColor( Realistic_Police.Colors["gray60200"] )
                            draw.NoTexture()
                            Realistic_Police.Circle( 0, 0, 50, 1000 )
                            surface.SetDrawColor( Realistic_Police.Colors["black20"] )
                            draw.NoTexture()
                            Realistic_Police.Circle( 0, 0, 45, 1000 )
                            draw.SimpleText("E", "rpt_font_23",0, 0, Color(240,240,240, LocalPlayer():GetPos():DistToSqr(ent:GetPos()) * 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) 
                        cam.End3D2D()
                    end
                end
            end 
        end 
        if Realistic_Police.PlateActivate then 
            if IsValid(ent) && ent:IsVehicle() then 
                if ent:GetPos():DistToSqr(LocalPlayer():GetPos()) < 3000000 then 
                    if istable(RPTInformationVehicle) && istable(RPTInformationVehicle[ent:GetModel()]) then 
                        if istable(RPTInformationVehicle[ent:GetModel()]["Plate1"]) && isvector(RPTInformationVehicle[ent:GetModel()]["Plate1"]["PlateVector"]) && isangle(RPTInformationVehicle[ent:GetModel()]["Plate1"]["PlateAngle"]) then 
                            RealisticPolicePlate(ent, RPTInformationVehicle[ent:GetModel()]["Plate1"]["PlateVector"], RPTInformationVehicle[ent:GetModel()]["Plate1"]["PlateAngle"], "Plate1")
                        end 
                        if istable(RPTInformationVehicle[ent:GetModel()]["Plate2"]) && isangle(RPTInformationVehicle[ent:GetModel()]["Plate2"]["PlateAngle"]) && isvector(RPTInformationVehicle[ent:GetModel()]["Plate2"]["PlateVector"]) then 
                            RealisticPolicePlate(ent, RPTInformationVehicle[ent:GetModel()]["Plate2"]["PlateVector"], RPTInformationVehicle[ent:GetModel()]["Plate2"]["PlateAngle"], "Plate2")
                        end 
                    end 
                end 
            else 
                VehicleTable[k] = nil 
            end 
        end	
    end 
end )

hook.Add("Think", "RPT:Think", function()
    -- Ghost entity for the trunk 
    if RealisticPoliceGhost then 
        if IsValid(RPTEGhostent) then RPTEGhostent:Remove() end 
        RPTEGhostent = ClientsideModel(RealisticPoliceModel, RENDERGROUP_OPAQUE)
        RPTEGhostent:SetModel("")
        RPTEGhostent:SetMaterial("models/wireframe")
        RPTEGhostent:SetPos(LocalPlayer():GetEyeTrace().HitPos + Realistic_Police.Trunk[RealisticPoliceModel]["GhostPos"])
        RPTEGhostent:SetAngles(Angle(0,LocalPlayer():GetAngles().y + 90,0))
        RPTEGhostent:Spawn()
        RPTEGhostent:Activate()	
        RPTEGhostent:SetRenderMode(RENDERMODE_TRANSALPHA)
    end 
end ) 

hook.Add("HUDPaint", "RealisticPolicesd:HUDPaint", function()
    if Realistic_Police.CameraBrokeHud then 
        if Realistic_Police.CameraWorker[team.GetName(LocalPlayer():Team())] then 
            for k,v in pairs(ents.FindByClass("realistic_police_camera")) do 
                if v:GetRptCam() then 
                    if not isvector(v:GetPos()) then return end 
                    local tscreen = v:GetPos():ToScreen()			
                    local sx, sy = surface.GetTextSize( "Crime Scene" )
                    local dist = math.Round(v:GetPos():DistToSqr(LocalPlayer():GetPos())/(25600))
                    if dist > 0.25 then 		
                        draw.SimpleText( dist.."m" , "rpt_font_2", tscreen.x, tscreen.y, Realistic_Police.Colors["white"], 1)
                        surface.SetDrawColor( Realistic_Police.Colors["white"].r, Realistic_Police.Colors["white"].g, Realistic_Police.Colors["white"].b, RPTValue )
                        surface.SetMaterial( Realistic_Police.Colors["Material5"] )
                        surface.DrawTexturedRect( tscreen.x - 12.5, tscreen.y - 23, 25, 25  )
                    end 
                end  
            end 
        end 
    end 
    if IsValid(LocalPlayer():GetEyeTrace().Entity) then 
        if LocalPlayer():GetEyeTrace().Entity:GetClass() == "realistic_police_screen" or LocalPlayer():GetEyeTrace().Entity:GetClass() == "realistic_police_policescreen" then 
            if LocalPlayer():GetEyeTrace().Entity:GetPos():DistToSqr((LocalPlayer():GetPos())) < 10000 then 
                surface.SetDrawColor(Realistic_Police.Colors["white"])
                surface.SetMaterial( Realistic_Police.Colors["Material4"] )
                surface.DrawTexturedRect(ScrW()/2-25, ScrH()*0.9,50,50)
            end 
        end 
    end 
end)

net.Receive("RealisticPolice:StunGun", function()
    local Players = net.ReadEntity()
    Players.TimerTazerStart = CurTime() + 5
    timer.Simple(0, function()
        if IsValid(Players) && IsValid(Players:GetRagdollEntity()) then 
            Phys = Players:GetRagdollEntity():GetPhysicsObject()
            
            hook.Add("Think", "RPT:StunGunThink"..Players:EntIndex(), function()
                if IsValid(Players) && Players:IsPlayer() then 
                    if Players.TimerTazerStart > CurTime() then 
                        if IsValid(Phys) then 
                            Phys:ApplyForceOffset( Vector(math.random(-40,40),math.random(-40,40),0), Phys:GetPos() + Vector(0,0,50))
                        end 
                    else 
                        hook.Remove("Think", "RPT:StunGunThink"..Players:EntIndex())
                    end 
                end 
            end )
        end 
    end ) 
end ) 

hook.Add( "PlayerButtonDown", "RPT:PlayerButtonDownTrunk", function( ply, button )
	if button == (Realistic_Police.KeyForOpenTrunk or KEY_E) then 
        if IsValid(RPTEGhostent) then 
            if isstring(RealisticPoliceModel) then 
                net.Start("RealisticPolice:PlaceProp")
                    net.WriteString(RealisticPoliceModel)
                net.SendToServer()
            end 
            RealisticPoliceGhost = false
            RPTEGhostent:Remove()
        end 

        local ent = ply:GetEyeTrace().Entity

        if not IsValid(ent) or not ent:IsVehicle() or not Realistic_Police.TrunkSystem then return end
        if not ent:GetClass() == "prop_vehicle_jeep" && not ent:GetClass() == "gmod_sent_vehicle_fphysics_base" then return end
        if not Realistic_Police.VehiclePoliceTrunk[ent:GetVehicleClass()] or not ply:isCP() then return end 
        
        if ply:GetPos():DistToSqr(Realistic_Police.TrunkPosition[ent:GetVehicleClass()] and Realistic_Police.TrunkPosition[ent:GetVehicleClass()]["Pos"] + ent:LocalToWorld(Vector(0, - ent:OBBMaxs().y, ent:OBBMaxs().z*0.5)) or ent:LocalToWorld(Vector(0, - ent:OBBMaxs().y, ent:OBBMaxs().z*0.5))) > 7500 then return end
        Realistic_Police.PoliceTrunk()
    end 
end)

net.Receive("RealisticPolice:Open", function()
    local String = net.ReadString() 
    if String == "OpenFiningMenu" then 
        local Bool = net.ReadBool()
        Realistic_Police.OpenFiningMenu(Bool)
    elseif String == "OpenMainMenu" then 
        local Ent = net.ReadEntity()
        local Bool = net.ReadBool()
        Realistic_Police.OpenMenu(Ent, Bool)
    elseif String == "OpenTrunk" then 
       -- Realistic_Police.PoliceTrunk()
    elseif String == "Notify" then 
        local msg = net.ReadString()
        RealisticPoliceNotify(msg)
    end 
end )

hook.Add("SetupMove", "RPT:SetupMove", function(ply, data)
    if IsValid(ply:GetActiveWeapon()) then 
        if ply:GetActiveWeapon():GetClass() == "weapon_rpt_surrender" or ply:GetActiveWeapon():GetClass() == "weapon_rpt_cuffed" then 
            data:SetMaxSpeed( 80 )
            data:SetMaxClientSpeed( 80 )
        end 
    end 
end ) 

hook.Add("PlayerSwitchWeapon", "RPT:PlayerSwitchWeapon", function(ply, wp, wep)
    if timer.Exists("rpt_animation"..ply:EntIndex()) then 
        return true 
    end 
end)

function Realistic_Police.NameCamera(CEntity)
    local RpRespX, RpRespY = ScrW(), ScrH()

    local RPTValue = 0
    local RPTTarget = 300
    local speed = 20

    local RPTLFrame = vgui.Create("DFrame")
	RPTLFrame:SetSize(RpRespX*0.272, RpRespY*0.2)
    RPTLFrame:Center()
	RPTLFrame:ShowCloseButton(false)
    RPTLFrame:MakePopup()
	RPTLFrame:SetDraggable(false)
	RPTLFrame:SetTitle("")
    RPTLFrame.Paint = function(self,w,h)
        RPTValue = Lerp( speed * FrameTime(), RPTValue, RPTTarget )
        surface.SetDrawColor( Color(Realistic_Police.Colors["black25"].r, Realistic_Police.Colors["black25"].g, Realistic_Police.Colors["black25"].b, RPTValue) )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( Realistic_Police.Colors["gray60200"] )
        surface.DrawOutlinedRect( 0, 0, w, h )

        surface.SetDrawColor( Color(Realistic_Police.Colors["black15"].r, Realistic_Police.Colors["black15"].g, Realistic_Police.Colors["black15"].b, RPTValue) )
        surface.DrawRect( w*0.003, 0, w*0.995, h*0.15 )

        draw.DrawText(Realistic_Police.GetSentence("cameraConfiguration"), "rpt_font_7", RpRespX*0.004, RpRespY*0.005, Color(Realistic_Police.Colors["gray220"].r, Realistic_Police.Colors["gray220"].g, Realistic_Police.Colors["gray220"].b, RPTValue), TEXT_ALIGN_LEFT)
    end 

    local PanelCT = vgui.Create("DTextEntry", RPTLFrame)
    PanelCT:SetSize(RpRespX*0.251, RpRespY*0.05)
    PanelCT:SetPos(RpRespX*0.01, RpRespY*0.05)
    PanelCT:SetText(" "..Realistic_Police.GetSentence("cameraName"))
    PanelCT:SetFont("rpt_font_7")
    PanelCT:SetDrawLanguageID(false)
    PanelCT.OnGetFocus = function(self) 
        if PanelCT:GetText() == " "..Realistic_Police.GetSentence("cameraName") then  
            PanelCT:SetText("") 
        end
    end 
    PanelCT.Paint = function(self,w,h)
		surface.SetDrawColor(Realistic_Police.Colors["black"])
		surface.DrawOutlinedRect( 0, 0, w, h )

        surface.SetDrawColor( Realistic_Police.Colors["black180"] )
        surface.DrawRect( 0, 0, w, h )

		self:DrawTextEntryText(Realistic_Police.Colors["white"], Realistic_Police.Colors["white"], Realistic_Police.Colors["white"])
        surface.SetDrawColor( Realistic_Police.Colors["darkblue"] )
        surface.DrawOutlinedRect( 0, 0, w, h )
	end
	PanelCT.OnLoseFocus = function(self)
		if PanelCT:GetText() == "" then  
			PanelCT:SetText(" "..Realistic_Police.GetSentence("infractionReason"))
		end
	end 
    PanelCT.AllowInput = function( self, stringValue )
        if string.len(PanelCT:GetValue()) > 18 then 
            return true 
        end 
    end

    DButtonAccept = vgui.Create("DButton", RPTLFrame)
    DButtonAccept:SetSize(RpRespX*0.257, RpRespY*0.05)
    DButtonAccept:SetPos(RpRespX*0.007, RpRespY*0.11)
    DButtonAccept:SetText(Realistic_Police.GetSentence("confirm"))
    DButtonAccept:SetFont("rpt_font_9")
    DButtonAccept:SetTextColor(Realistic_Police.Colors["white"])
    DButtonAccept.Paint = function(self,w,h)
        surface.SetDrawColor( Realistic_Police.Colors["green"] )
        surface.DrawRect( 5, 0, w-10, h )
    end 
    DButtonAccept.DoClick = function()
        net.Start("RealisticPolice:NameCamera")
            net.WriteEntity(CEntity)
            net.WriteString(PanelCT:GetText())
        net.SendToServer()
        RPTLFrame:Remove()
    end 

    local RPTClose = vgui.Create("DButton", RPTLFrame)
    RPTClose:SetSize(RpRespX*0.03, RpRespY*0.028)
    RPTClose:SetPos(RPTLFrame:GetWide()*0.885, RPTLFrame:GetTall()*0.008)
    RPTClose:SetText("")
    RPTClose.Paint = function(self,w,h) 
        surface.SetDrawColor( Realistic_Police.Colors["red"] )
        surface.DrawRect( 0, 0, w, h )
    end 
    RPTClose.DoClick = function()
        RPTLFrame:Remove()
        Realistic_Police.Clic()
    end   
end 

net.Receive("RealisticPolice:NameCamera", function()
    local CEntity = net.ReadEntity()
    Realistic_Police.NameCamera(CEntity)
end )