--[[
 _____            _ _     _   _        _____      _ _             _____           _                 
|  __ \          | (_)   | | (_)      |  __ \    | (_)           / ____|         | |                
| |__) |___  __ _| |_ ___| |_ _  ___  | |__) |__ | |_  ___ ___  | (___  _   _ ___| |_ ___ _ __ ___  
|  _  // _ \/ _` | | / __| __| |/ __| |  ___/ _ \| | |/ __/ _ \  \___ \| | | / __| __/ _ \ '_ ` _ \ 
| | \ \  __/ (_| | | \__ \ |_| | (__  | |  | (_) | | | (_|  __/  ____) | |_| \__ \ ||  __/ | | | | |
|_|  \_\___|\__,_|_|_|___/\__|_|\___| |_|   \___/|_|_|\___\___| |_____/ \__, |___/\__\___|_| |_| |_|
                                                                                                                                         
--]]


function Realistic_Police.GetVehicleLicense(String)
    local TableVehicle = {}
    for k,v in pairs(ents.GetAll()) do 
        if string.StartWith(string.Replace(string.upper(v:GetNWString("rpt_plate")), " ", ""), string.Replace(string.upper(String), " ", "")) or string.Replace(v:GetNWString("rpt_plate"), " ", "") == string.Replace(string.upper(String), " ", "") then 
            local t = list.Get( "Vehicles" )[ v:GetVehicleClass() ]
            if istable(RPTInformationVehicle[v:GetModel()]) then 
                TableVehicle[#TableVehicle + 1] = {
                    ModelVehc = v:GetModel(),
                    NameVehc = t.Name,
                    Plate = v:GetNWString("rpt_plate"),
                    VOwner = v:CPPIGetOwner():Name(), 
                }
            end 
        end 
    end 
    return TableVehicle
end 

function Realistic_Police.License()
    local RpRespX, RpRespY = ScrW(), ScrH()

    local RPTValue = 0
    local RPTTarget = 300
    local speed = 10

    local RPTLFrame = vgui.Create("DFrame", RPTFrame)
	RPTLFrame:SetSize(RpRespX*0.18285, RpRespY*0.1397)
    RPTLFrame:Center()
	RPTLFrame:ShowCloseButton(false)
	RPTLFrame:SetDraggable(true)
	RPTLFrame:SetTitle("")
    RPTLFrame.Paint = function(self,w,h)
        RPTValue = Lerp( speed * FrameTime( ), RPTValue, RPTTarget )
        surface.SetDrawColor( Color(Realistic_Police.Colors["black25"].r, Realistic_Police.Colors["black25"].g, Realistic_Police.Colors["black25"].b, RPTValue) )
        surface.DrawRect( 0, 0, w, h )
        
        surface.SetDrawColor( Color(Realistic_Police.Colors["black15200"].r, Realistic_Police.Colors["black15200"].g, Realistic_Police.Colors["black15200"].b, RPTValue) )
        surface.DrawRect( 0, 0, w + 10, h*0.2 )

        surface.SetDrawColor( Realistic_Police.Colors["black15200"] )
        surface.DrawOutlinedRect( 0, 0, w, h )
        draw.DrawText(Realistic_Police.GetSentence("licenseplate"), "rpt_font_7", RpRespX*0.003, RpRespY*0.002, Color(220, 220, 220, RPTValue), TEXT_ALIGN_LEFT)
    end 
    function RPTLFrame:OnMousePressed()
        RPTLFrame:RequestFocus()
        local screenX, screenY = self:LocalToScreen( 0, 0 )
        if ( self.m_bSizable && gui.MouseX() > ( screenX + self:GetWide() - 20 ) && gui.MouseY() > ( screenY + self:GetTall() - 20 ) ) then
            self.Sizing = { gui.MouseX() - self:GetWide(), gui.MouseY() - self:GetTall() }
            self:MouseCapture( true )
            return
        end
        if ( self:GetDraggable() && gui.MouseY() < ( screenY + 24 ) ) then
            self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
            self:MouseCapture( true )
            return
        end
    end 

    local RPTEntry = vgui.Create("DTextEntry", RPTLFrame)
    RPTEntry:SetSize(RpRespX*0.18, RpRespY*0.05)
    RPTEntry:SetPos(RpRespX*0.002, RpRespY*0.033)
    RPTEntry:SetText(Realistic_Police.GetSentence("licenseplate"))
    RPTEntry:SetFont("rpt_font_7")
    RPTEntry:SetDrawLanguageID(false)
    RPTEntry.OnGetFocus = function(self) RPTEntry:SetText("") end 
    RPTEntry.OnLoseFocus = function(self)
        if RPTEntry:GetText() == "" then  
            RPTEntry:SetText(Realistic_Police.GetSentence("licenseplate"))
        end
    end 
    RPTEntry.AllowInput = function( self, stringValue )
        if string.len(RPTEntry:GetValue()) > 10 then 
            return true 
        end 
    end

    local RPTAccept = vgui.Create("DButton", RPTLFrame)
    RPTAccept:SetSize(RpRespX*0.1795, RpRespY*0.05)
    RPTAccept:SetPos(RpRespX*0.00207, RpRespY*0.086)
    RPTAccept:SetText(Realistic_Police.GetSentence("search"))
    RPTAccept:SetFont("rpt_font_7")
    RPTAccept:SetTextColor(Realistic_Police.Colors["white"])
    RPTAccept.Paint = function(self,w,h)
        if RPTAccept:IsHovered() then 
            surface.SetDrawColor( Realistic_Police.Colors["black15200"] )
            surface.DrawRect( 0, 0, w, h )
        else 
            surface.SetDrawColor( Realistic_Police.Colors["black15"] )
            surface.DrawRect( 0, 0, w, h )
        end 
    end 
    RPTAccept.DoClick = function()
        Realistic_Police.Clic()
        if istable(Realistic_Police.GetVehicleLicense(RPTEntry:GetValue())) && #Realistic_Police.GetVehicleLicense(RPTEntry:GetValue()) > 0 then 
            RPTLFrame:Remove()
            local RPTLFrame = vgui.Create("DFrame", RPTFrame)
            RPTLFrame:SetSize(RpRespX*0.3, RpRespY*0.188)
            RPTLFrame:Center()
            RPTLFrame:ShowCloseButton(false)
            RPTLFrame:SetDraggable(true)
            RPTLFrame:SetTitle("")
            RPTLFrame.Paint = function(self,w,h)
                RPTValue = Lerp( speed * FrameTime( ), RPTValue, RPTTarget )
                surface.SetDrawColor( Color(Realistic_Police.Colors["black25"].r, Realistic_Police.Colors["black25"].g, Realistic_Police.Colors["black25"].b, RPTValue) )
                surface.DrawRect( 0, 0, w, h )
                
                surface.SetDrawColor( Color(Realistic_Police.Colors["black15200"].r, Realistic_Police.Colors["black15200"].g, Realistic_Police.Colors["black15200"].b, RPTValue) )
                surface.DrawRect( 0, 0, w + 10, h*0.15 )

                surface.SetDrawColor( Realistic_Police.Colors["black15200"] )
                surface.DrawOutlinedRect( 0, 0, w, h )

                draw.DrawText(Realistic_Police.GetSentence("licenseplate"), "rpt_font_7", RpRespX*0.005, RpRespY*0.002, Color(Realistic_Police.Colors["gray220"].r, Realistic_Police.Colors["gray220"].g, Realistic_Police.Colors["gray220"].b, RPTValue), TEXT_ALIGN_LEFT)
            end 

            local DScroll = vgui.Create("DScrollPanel", RPTLFrame)
            DScroll:SetSize(RpRespX*0.295, RpRespY*0.15)
            DScroll:SetPos(RpRespX*0.003, RpRespY*0.033)
            DScroll.Paint = function() end 
            local sbar = DScroll:GetVBar()
            sbar:SetSize(10,0)
            function sbar.btnUp:Paint() end
            function sbar.btnDown:Paint() end
            function sbar:Paint(w, h)
                surface.SetDrawColor( Realistic_Police.Colors["black100"] )
                surface.DrawRect( 0, 0, w, h )
            end
            function sbar.btnGrip:Paint(w, h)
                surface.SetDrawColor( Realistic_Police.Colors["gray50"] )
                surface.DrawRect( 0, 0, w, h )
            end
            for k,v in pairs(Realistic_Police.GetVehicleLicense(RPTEntry:GetValue())) do 
                local DPanel = vgui.Create("DPanel", DScroll)
                DPanel:SetSize(0, RpRespY*0.15)
                DPanel:Dock(TOP)
                DPanel:DockMargin(0, 0, 0, 5)
                DPanel.Paint = function(self,w,h)
                    surface.SetDrawColor( Realistic_Police.Colors["black15"] )
                    surface.DrawRect( 0, 0, w, h )

                    surface.SetDrawColor( Realistic_Police.Colors["gray60"])
                    surface.DrawOutlinedRect( 0, 0, w, h )
                    draw.DrawText("☑ "..v.VOwner, "rpt_font_11", RpRespX*0.18, RpRespY*0.04, Realistic_Police.Colors["white"], TEXT_ALIGN_LEFT)
                    draw.DrawText("☑ "..v.Plate, "rpt_font_11", RpRespX*0.18, RpRespY*0.07, Realistic_Police.Colors["white"], TEXT_ALIGN_LEFT)
                    draw.DrawText("☑ "..v.NameVehc, "rpt_font_11", RpRespX*0.18, RpRespY*0.1, Realistic_Police.Colors["white"], TEXT_ALIGN_LEFT)
                end 

                local RPTCarModel = vgui.Create( "DModelPanel", DPanel )
                RPTCarModel:SetPos( ScrW()*0.01, ScrH()*0.0298 )
                RPTCarModel:SetSize( ScrW()*0.15, ScrH()*0.13 )
                RPTCarModel:SetFOV(70)
                RPTCarModel:SetCamPos(Vector(200, 0, 20))
                RPTCarModel:SetModel( v.ModelVehc )
                function RPTCarModel:LayoutEntity( ent ) end 

                local RPTClose = vgui.Create("DButton", RPTLFrame)
                RPTClose:SetSize(RpRespX*0.03, RpRespY*0.0245)
                RPTClose:SetPos(RPTLFrame:GetWide()*0.897, RPTLFrame:GetTall()*0.013)
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
        else    
            RPTEntry:SetText(Realistic_Police.GetSentence("noVehiclesFound"))
            timer.Simple(1, function()
                if IsValid(RPTEntry) then 
                    RPTEntry:SetText(Realistic_Police.GetSentence("licenseplate"))
                end 
            end ) 
        end 
    end 

    local RPTClose = vgui.Create("DButton", RPTLFrame)
    RPTClose:SetSize(RpRespX*0.03, RpRespY*0.0245)
    RPTClose:SetPos(RPTLFrame:GetWide()*0.83, RPTLFrame:GetTall()*0.0175)
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



