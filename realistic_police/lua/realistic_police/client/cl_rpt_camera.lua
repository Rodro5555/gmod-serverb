

net.Receive("RealisticPolice:SecurityCamera", function()
    local RPTListCamera = net.ReadTable() or {}
    if not IsValid(RPTCFrame) then Realistic_Police.OpenCamera(RPTListCamera) end 
end ) 

function Realistic_Police.Camera()
    net.Start("RealisticPolice:SecurityCamera")
    net.SendToServer()
end 

function Realistic_Police.OpenCamera(RPTListCamera)
    local RpRespX, RpRespY = ScrW(), ScrH()

    local RPTValue = 0
    local RPTTarget = 300
    local speed = 10
    local RPTId = 1 

    if IsValid(RPTCFrame) then RPTCFrame:Remove() end 
    
    RPTCFrame = vgui.Create("DFrame", RPTFrame)
	RPTCFrame:SetSize(RpRespX*0.682, RpRespY*0.675)
    RPTCFrame:SetPos(RpRespX*0.1569, RpRespY*0.153)
	RPTCFrame:ShowCloseButton(false)
	RPTCFrame:SetDraggable(true)
	RPTCFrame:SetTitle("")
    RPTCFrame:SetScreenLock( true )
    RPTCFrame.Paint = function(self,w,h)
        RPTValue = Lerp( speed * FrameTime( ), RPTValue, RPTTarget )
        surface.SetDrawColor( Color(Realistic_Police.Colors["black25"].r, Realistic_Police.Colors["black25"].g, Realistic_Police.Colors["black25"].b, RPTValue) )
        surface.DrawRect( 0, 0, w*0.708, h*0.72 )

        surface.SetDrawColor( Color(Realistic_Police.Colors["black15"].r, Realistic_Police.Colors["black15"].g, Realistic_Police.Colors["black15"].b, RPTValue) )
        surface.DrawRect( 0, 0, w*0.708, h*0.053 )

        surface.SetDrawColor( Realistic_Police.Colors["black15200"] )
        surface.DrawOutlinedRect( 0, 0, w*0.708, h*0.72 )

        draw.DrawText(Realistic_Police.GetSentence("cameraCenter"), "rpt_font_7", RpRespX*0.003, RpRespY*0.0038, Color(Realistic_Police.Colors["gray220"].r, Realistic_Police.Colors["gray220"].g, Realistic_Police.Colors["gray220"].b, RPTValue), TEXT_ALIGN_LEFT)
    end 
    function RPTCFrame:OnMousePressed()
        RPTCFrame:RequestFocus()
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

    local RPTScroll = vgui.Create("DScrollPanel", RPTCFrame)
    RPTScroll:SetSize(RpRespX*0.12, RpRespY*0.44)
    RPTScroll:SetPos(RpRespX*0.003, RpRespY*0.04)
    RPTScroll.Paint = function(self,w,h) 
        surface.SetDrawColor( Realistic_Police.Colors["black15"] )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( Realistic_Police.Colors["gray60"] )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end 
    local sbar = RPTScroll:GetVBar()
    sbar:SetSize(0,0)

    local DPanel = vgui.Create("DPanel", RPTCFrame)
    DPanel:SetSize(RpRespX*0.355, RpRespY*0.44)
    DPanel:SetPos(RpRespX*0.125, RpRespY*0.04)
    DPanel.Paint = function(self,w,h)
        surface.SetDrawColor( Realistic_Police.Colors["black15"] )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( Realistic_Police.Colors["gray60"] )
        surface.DrawOutlinedRect( 0, 0, w, h )
        draw.DrawText(Realistic_Police.GetSentence("cameraSecurityOfCity"), "rpt_font_7", RpRespX*0.01, RpRespY*0.014, Color(Realistic_Police.Colors["gray220"].r, Realistic_Police.Colors["gray220"].g, Realistic_Police.Colors["gray220"].b, RPTValue), TEXT_ALIGN_LEFT)
    end 

    timer.Simple(0.2, function()
        local DScroll2 = vgui.Create("DScrollPanel", DPanel)
        DScroll2:SetSize(RpRespX*0.335, RpRespY*0.37)
        DScroll2:SetPos(RpRespX*0.01, RpRespY*0.055)
        DScroll2.Paint = function(self,w,h)  
            surface.SetDrawColor( Realistic_Police.Colors["black49"] )
            surface.DrawRect( 0, 0, w, h )

            local x,y = self:LocalToScreen(0, 0)
            if #RPTListCamera != 0 then 
                local pos, ang = RPTListCamera[RPTId]:GetBonePosition(2)
                if pos == RPTListCamera[RPTId]:GetPos() then
                    pos = RPTListCamera[RPTId]:GetBoneMatrix(2):GetTranslation()
                end
                local VectorBone = pos
                local Angles = ang  

                if isangle(ang) then 
                    Angles:RotateAroundAxis(Angles:Up(), -90)
                    Angles:RotateAroundAxis(Angles:Forward(), -270)
                    Angles:RotateAroundAxis(Angles:Right(), 90)
                else 
                    Angles = RPTListCamera[RPTId]:GetAngles()
                    Angles:RotateAroundAxis(Angles:Up(), -90)
                end 

                local Pos = RPTListCamera[RPTId]:GetPos() 
                Pos = Pos + Angles:Forward() * 25 + Angles:Up() * 10

                if not RPTListCamera[RPTId]:GetRptCam() then 
                    render.RenderView( {
                        origin = Pos,
                        angles = Angles,
                        x = x + 7.5, y = y + 7.5,
                        w = w - 15, h = h - 15
                    } )
                    if IsValid(DPanelBroke) then 
                        DPanelBroke:Remove()
                    end 
                else 
                    if not IsValid(DPanelBroke) then 
                        DPanelBroke = vgui.Create("DPanel", DScroll2)
                        DPanelBroke:SetSize(RpRespX*0.335, RpRespY*0.37)
                        DPanelBroke:SetPos(0, 0)
                        DPanelBroke.Paint = function(self,w,h)
                            surface.SetDrawColor( Realistic_Police.Colors["black20"] )
                            surface.DrawRect( 0, 0, w, h )

                            draw.SimpleText(Realistic_Police.GetSentence("noSignal"), "rpt_font_12", DPanelBroke:GetWide()/2, DPanelBroke:GetTall()/2.5, Realistic_Police.Colors["white"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                            draw.SimpleText(Realistic_Police.GetSentence("connectionProblem"), "rpt_font_13", DPanelBroke:GetWide()/2, DPanelBroke:GetTall()/1.8, Realistic_Police.Colors["red"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        end 
                    end 
                end 
            end 
        end 
        
        local sbar = DScroll2:GetVBar()
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
        if istable(RPTListCamera) then 
            for k,v in pairs(RPTListCamera) do 
                local DButton1 = vgui.Create("DButton", RPTScroll)
                DButton1:SetSize(0,RpRespY*0.05)
                if isstring(v:GetNWString("rpt_name_camera")) && #v:GetNWString("rpt_name_camera") > 1 then 
                    DButton1:SetText(v:GetNWString("rpt_name_camera"))
                else 
                    DButton1:SetText("Camera "..k)
                end 
                DButton1:SetFont("rpt_font_7")
                DButton1:SetTextColor(Realistic_Police.Colors["white"])
                DButton1:Dock(TOP)
                DButton1:DockMargin(0,5,0,0)
                DButton1.Paint = function(self,w,h) 
                    if self:IsHovered() then 
                        surface.SetDrawColor( Realistic_Police.Colors["black25200"] )
                        surface.DrawRect( 5, 0, w-10, h )
                    else 
                        surface.SetDrawColor( Realistic_Police.Colors["black25"] )
                        surface.DrawRect( 5, 0, w-10, h )
                    end 
                end 
                DButton1.DoClick = function()
                    RPTId = k
                    net.Start("RealisticPolice:SecurityCamera")
                        net.WriteString("ShowCamera")
                        net.WriteEntity(RPTListCamera[RPTId])
                    net.SendToServer()
                    Realistic_Police.Clic()
                end  
            end 
        end

        local DButtonLeft = vgui.Create("DButton", DScroll2)
        DButtonLeft:SetSize(RpRespX*0.03, DScroll2:GetTall()*0.96)
        DButtonLeft:SetPos(RpRespX*0.001, RpRespY*0.008)
        DButtonLeft:SetText("〈")
        DButtonLeft:SetFont("rpt_font_13")
        DButtonLeft:SetTextColor(Realistic_Police.Colors["white200"])
        DButtonLeft.Paint = function(self,w,h)
            surface.SetDrawColor( Realistic_Police.Colors["black2510"] )
            surface.DrawRect( 5, 0, w-10, h )
            
            if IsValid(RPTListCamera[RPTId]) then 
                if not self:IsHovered() then 
                    if #RPTListCamera != 0 then 
                        if IsValid(RPTListCamera[RPTId]) then 
                            if RPTListCamera[RPTId]:GetRptRotate() != "nil" && RPTListCamera[RPTId]:GetRptRotate()  != "Right" then 
                                if input.IsMouseDown( MOUSE_LEFT ) then 
                                    net.Start("RealisticPolice:SecurityCamera")
                                        net.WriteString("RotateCamera")
                                        net.WriteEntity(RPTListCamera[RPTId])
                                        net.WriteString("nil")
                                    net.SendToServer()
                                end 
                            end 
                        end 
                    end 
                end 
            end 
        end
        DButtonLeft.OnMousePressed = function()
            if IsValid(RPTListCamera[RPTId]) then 
                local BoneLookUp = RPTListCamera[RPTId]:LookupBone(RPTListCamera[RPTId]:GetBoneName(2))
                net.Start("RealisticPolice:SecurityCamera")
                    net.WriteString("RotateCamera")
                    net.WriteEntity(RPTListCamera[RPTId])
                    net.WriteString("Left")
                net.SendToServer()
            end 
        end 
        DButtonLeft.OnMouseReleased = function()
            if IsValid(RPTListCamera[RPTId]) then 
                net.Start("RealisticPolice:SecurityCamera")
                    net.WriteString("RotateCamera")
                    net.WriteEntity(RPTListCamera[RPTId])
                    net.WriteString("nil")
                net.SendToServer()
            end 
        end

        local DButtonRight = vgui.Create("DButton", DScroll2)
        DButtonRight:SetSize(RpRespX*0.03, DScroll2:GetTall()*0.96)
        DButtonRight:SetPos(RpRespX*0.304, RpRespY*0.008)
        DButtonRight:SetText("〉")
        DButtonRight:SetFont("rpt_font_13")
        DButtonRight:SetTextColor(Realistic_Police.Colors["white200"])
        DButtonRight.Paint = function(self,w,h)
            surface.SetDrawColor( Realistic_Police.Colors["black2510"] )
            surface.DrawRect( 5, 0, w-10, h )

            if not self:IsHovered() then 
                if IsValid(RPTListCamera[RPTId]) then 
                    if #RPTListCamera != 0 then
                        if RPTListCamera[RPTId]:GetRptRotate() != "nil" && RPTListCamera[RPTId]:GetRptRotate() != "Left" then 
                            if input.IsMouseDown( MOUSE_LEFT ) then 
                                net.Start("RealisticPolice:SecurityCamera")
                                    net.WriteString("RotateCamera")
                                    net.WriteEntity(RPTListCamera[RPTId])
                                    net.WriteString("nil")
                                net.SendToServer()
                            end 
                        end 
                    end 
                end 
            end 
        end
        DButtonRight.OnMousePressed = function()
            if IsValid(RPTListCamera[RPTId]) then 
                net.Start("RealisticPolice:SecurityCamera")
                    net.WriteString("RotateCamera")
                    net.WriteEntity(RPTListCamera[RPTId])
                    net.WriteString("Right")
                net.SendToServer()
            end 
        end 
        DButtonRight.OnMouseReleased = function()
            if RPTListCamera[RPTId] then 
                net.Start("RealisticPolice:SecurityCamera")
                    net.WriteString("RotateCamera")
                    net.WriteEntity(RPTListCamera[RPTId])
                    net.WriteString("nil")
                net.SendToServer()
            end 
        end
    end ) 
    
    local RPTResize = vgui.Create("DButton", RPTCFrame)
    RPTResize:SetSize(RpRespX*0.016, RpRespY*0.026)
    RPTResize:SetPos(RPTCFrame:GetWide()*0.667, RPTCFrame:GetTall()*0.075)
    RPTResize:SetText("")
    RPTResize.Paint = function(self,w,h) 
        surface.SetDrawColor( Realistic_Police.Colors["white200"] )
        surface.SetMaterial( Realistic_Police.Colors["Material8"] )
        surface.DrawTexturedRect( 0, 0, w, h )
    end 
    RPTResize.DoClick = function()
        Realistic_Police.Clic()
        Realistic_Police.FulLScreenCamera(RPTListCamera)
        --RPTCFrame:Remove()
    end  

    local RPTClose = vgui.Create("DButton", RPTCFrame)
    RPTClose:SetSize(RpRespX*0.03, RpRespY*0.028)
    RPTClose:SetPos(RPTCFrame:GetWide()*0.663, RPTCFrame:GetTall()*0.005)
    RPTClose:SetText("")
    RPTClose.Paint = function(self,w,h) 
        surface.SetDrawColor( Realistic_Police.Colors["red"] )
        surface.DrawRect( 0, 0, w, h )
    end 
    RPTClose.DoClick = function()
        RPTCFrame:Remove()
        Realistic_Police.Clic()
    end  
end 

function Realistic_Police.FulLScreenCamera(RPTListCamera)
    local RpRespX, RpRespY = ScrW(), ScrH()

    local RPTValue = 0
    local RPTTarget = 300
    local speed = 10
    local RPTId = 1 
    if IsValid(RPTCFrame) then RPTCFrame:Remove() end 

    RPTCFrame = vgui.Create("DFrame", RPTFrame)
	RPTCFrame:SetSize(RpRespX*1, RpRespY*1)
	RPTCFrame:ShowCloseButton(false)
	RPTCFrame:SetDraggable(false)
	RPTCFrame:SetTitle("")
    RPTCFrame:SetScreenLock( true )
    RPTCFrame.Paint = function(self,w,h)
        RPTValue = Lerp( speed * FrameTime( ), RPTValue, RPTTarget )
        surface.SetDrawColor( Color(Realistic_Police.Colors["black25"].r, Realistic_Police.Colors["black25"].g, Realistic_Police.Colors["black25"].b, RPTValue) )
        surface.DrawRect( 0, 0, w, h )
        surface.SetDrawColor( Color(Realistic_Police.Colors["black15200"].r, Realistic_Police.Colors["black15200"].g, Realistic_Police.Colors["black15200"].b, RPTValue) )
        surface.DrawRect( 0, 0, w, h )
        surface.SetDrawColor( Realistic_Police.Colors["black15200"] )
        surface.DrawOutlinedRect( 0, 0, w, h )
        draw.DrawText(Realistic_Police.GetSentence("cameraCenter"), "rpt_font_7", RpRespX*0.008, RpRespY*0.01, Color(Realistic_Police.Colors["gray220"].r, Realistic_Police.Colors["gray220"].g, Realistic_Police.Colors["gray220"].b, RPTValue), TEXT_ALIGN_LEFT)
    end 

    local RPTScroll = vgui.Create("DScrollPanel", RPTCFrame)
    RPTScroll:SetSize(RpRespX*0.12, RpRespY*0.72)
    RPTScroll:SetPos(RpRespX*0.01, RpRespY*0.04)
    RPTScroll.Paint = function(self,w,h) 
        surface.SetDrawColor( Realistic_Police.Colors["black15"] )
        surface.DrawRect( 0, 0, w, h )
        surface.SetDrawColor( Realistic_Police.Colors["gray60"] )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end 
    local sbar = RPTScroll:GetVBar()
    sbar:SetSize(0,0)

    local DPanel = vgui.Create("DPanel", RPTCFrame)
    DPanel:SetSize(RpRespX*0.648, RpRespY*0.72)
    DPanel:SetPos(RpRespX*0.137, RpRespY*0.04)
    DPanel.Paint = function(self,w,h)
        surface.SetDrawColor( Realistic_Police.Colors["black15"] )
        surface.DrawRect( 0, 0, w, h )
        surface.SetDrawColor( Realistic_Police.Colors["gray60"] )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end 
    net.Start("RealisticPolice:SecurityCamera")
    net.SendToServer()

    timer.Simple(0.2, function()
        local DScroll2 = vgui.Create("DScrollPanel", DPanel)
        DScroll2:SetSize(RpRespX*0.639, RpRespY*0.703)
        DScroll2:SetPos(RpRespX*0.005, RpRespY*0.008)
        DScroll2.Paint = function(self,w,h)  
            surface.SetDrawColor( Realistic_Police.Colors["black49"] )
            surface.DrawRect( 0, 0, w, h )

            local x,y = self:LocalToScreen(0, 0)
            if #RPTListCamera != 0 then 
                local pos, ang = RPTListCamera[RPTId]:GetBonePosition(2)
                if pos == RPTListCamera[RPTId]:GetPos() then
                    pos = RPTListCamera[RPTId]:GetBoneMatrix(2):GetTranslation()
                end
                local VectorBone = pos
                local Angles = ang  

                if isangle(ang) then 
                    Angles:RotateAroundAxis(Angles:Up(), -90)
                    Angles:RotateAroundAxis(Angles:Forward(), -270)
                    Angles:RotateAroundAxis(Angles:Right(), 90)
                else 
                    Angles = RPTListCamera[RPTId]:GetAngles()
                    Angles:RotateAroundAxis(Angles:Up(), -90)
                end 

                local Pos = RPTListCamera[RPTId]:GetPos() 
                Pos = Pos + Angles:Forward() * 25 + Angles:Up() * 10

                if not RPTListCamera[RPTId]:GetRptCam() then 
                    render.RenderView( {
                        origin = Pos,
                        angles = Angles,
                        x = x + 7.5, y = y + 7.5,
                        w = w - 15, h = h - 15
                    } )
                    if IsValid(DPanelBroke) then 
                        DPanelBroke:Remove()
                    end 
                else 
                    if not IsValid(DPanelBroke) then 
                        DPanelBroke = vgui.Create("DPanel", DScroll2)
                        DPanelBroke:SetSize(RpRespX*0.639, RpRespY*0.703)
                        DPanelBroke:SetPos(0, 0)
                        DPanelBroke.Paint = function(self,w,h)
                            surface.SetDrawColor( Realistic_Police.Colors["black20"] )
                            surface.DrawRect( 0, 0, w, h )

                            draw.SimpleText(Realistic_Police.GetSentence("noSignal"), "rpt_font_12", DPanelBroke:GetWide()/2, DPanelBroke:GetTall()/2.5, Realistic_Police.Colors["white"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                            draw.SimpleText(Realistic_Police.GetSentence("connectionProblem"), "rpt_font_13", DPanelBroke:GetWide()/2, DPanelBroke:GetTall()/1.8, Realistic_Police.Colors["red"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        end 
                    end 
                end 
            end
        end 
        
        local sbar = DScroll2:GetVBar()
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
        if istable(RPTListCamera) then 
            for k,v in pairs(RPTListCamera) do 
                local DButton1 = vgui.Create("DButton", RPTScroll)
                DButton1:SetSize(0,RpRespY*0.05)
                if isstring(v:GetNWString("rpt_name_camera")) && #v:GetNWString("rpt_name_camera") > 1 then 
                    DButton1:SetText(v:GetNWString("rpt_name_camera"))
                else 
                    DButton1:SetText("Camera "..k)
                end 
                DButton1:SetFont("rpt_font_7")
                DButton1:SetTextColor(Realistic_Police.Colors["white"])
                DButton1:Dock(TOP)
                DButton1:DockMargin(0,5,0,0)
                DButton1.Paint = function(self,w,h) 
                    if self:IsHovered() then 
                        surface.SetDrawColor( Realistic_Police.Colors["black25200"] )
                        surface.DrawRect( 5, 0, w-10, h )
                    else 
                        surface.SetDrawColor( Realistic_Police.Colors["black25"] )
                        surface.DrawRect( 5, 0, w-10, h )
                    end 
                end 
                DButton1.DoClick = function()
                    RPTId = k
                    net.Start("RealisticPolice:SecurityCamera")
                        net.WriteString("ShowCamera")
                        net.WriteEntity(RPTListCamera[RPTId])
                    net.SendToServer()
                    Realistic_Police.Clic()
                end 
            end 
        end

        local DButtonLeft = vgui.Create("DButton", DScroll2)
        DButtonLeft:SetSize(RpRespX*0.03, DScroll2:GetTall()*0.96)
        DButtonLeft:SetPos(RpRespX*0.001, RpRespY*0.008)
        DButtonLeft:SetText("〈")
        DButtonLeft:SetFont("rpt_font_13")
        DButtonLeft:SetTextColor(Realistic_Police.Colors["white"])
        DButtonLeft.Paint = function(self,w,h)
            surface.SetDrawColor( Realistic_Police.Colors["black2510"] )
            surface.DrawRect( 5, 0, w-10, h )
            if not self:IsHovered() then 
                if #RPTListCamera != 0 && IsValid(RPTListCamera[RPTId]) then 
                    if RPTListCamera[RPTId]:GetRptRotate() != "nil" && RPTListCamera[RPTId]:GetRptRotate() != "Right" then 
                        if input.IsMouseDown( MOUSE_LEFT ) then 
                            net.Start("RealisticPolice:SecurityCamera")
                                net.WriteString("RotateCamera")
                                net.WriteEntity(RPTListCamera[RPTId])
                                net.WriteString("nil")
                            net.SendToServer()
                        end 
                    end 
                end 
            end 
        end
        DButtonLeft.OnMousePressed = function()
            net.Start("RealisticPolice:SecurityCamera")
                net.WriteString("RotateCamera")
                net.WriteEntity(RPTListCamera[RPTId])
                net.WriteString("Left")
            net.SendToServer()
        end 
        DButtonLeft.OnMouseReleased = function()
            net.Start("RealisticPolice:SecurityCamera")
                net.WriteString("RotateCamera")
                net.WriteEntity(RPTListCamera[RPTId])
                net.WriteString("nil")
            net.SendToServer()
        end

        local DButtonRight = vgui.Create("DButton", DScroll2)
        DButtonRight:SetSize(RpRespX*0.03, DScroll2:GetTall()*0.96)
        DButtonRight:SetPos(RpRespX*0.605, RpRespY*0.008)
        DButtonRight:SetText("〉")
        DButtonRight:SetFont("rpt_font_13")
        DButtonRight:SetTextColor(Realistic_Police.Colors["white"])
        DButtonRight.Paint = function(self,w,h)
            surface.SetDrawColor( Realistic_Police.Colors["black2510"] )
            surface.DrawRect( 5, 0, w-10, h )
            if not self:IsHovered() then 
                if #RPTListCamera != 0 && IsValid(RPTListCamera[RPTId]) then 
                    if RPTListCamera[RPTId]:GetRptRotate()  != "nil" && RPTListCamera[RPTId]:GetRptRotate()  != "Left" then 
                        if input.IsMouseDown( MOUSE_LEFT ) then 
                            net.Start("RealisticPolice:SecurityCamera")
                                net.WriteString("RotateCamera")
                                net.WriteEntity(RPTListCamera[RPTId])
                                net.WriteString("nil")
                            net.SendToServer()
                        end 
                    end 
                end 
            end 
        end
        DButtonRight.OnMousePressed = function()
            net.Start("RealisticPolice:SecurityCamera")
                net.WriteString("RotateCamera")
                    net.WriteEntity(RPTListCamera[RPTId])
                net.WriteString("Right")
            net.SendToServer()
        end 
        DButtonRight.OnMouseReleased = function()
            net.Start("RealisticPolice:SecurityCamera")
                net.WriteString("RotateCamera")
                    net.WriteEntity(RPTListCamera[RPTId])
                net.WriteString("nil")
            net.SendToServer()
        end
    end ) 
    local RPTClose = vgui.Create("DButton", RPTCFrame)
    RPTClose:SetSize(RpRespX*0.03, RpRespY*0.028)
    RPTClose:SetPos(RPTCFrame:GetWide()*0.763, RPTCFrame:GetTall()*0.0052)
    RPTClose:SetText("")
    RPTClose.Paint = function(self,w,h) 
        surface.SetDrawColor( Realistic_Police.Colors["red"] )
        surface.DrawRect( 0, 0, w, h )
    end 
    RPTClose.DoClick = function()
        RPTCFrame:Remove()
        Realistic_Police.Clic()
    end  
end 
