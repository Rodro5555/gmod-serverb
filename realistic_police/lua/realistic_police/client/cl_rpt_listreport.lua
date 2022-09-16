--[[
 _____            _ _     _   _        _____      _ _             _____           _                 
|  __ \          | (_)   | | (_)      |  __ \    | (_)           / ____|         | |                
| |__) |___  __ _| |_ ___| |_ _  ___  | |__) |__ | |_  ___ ___  | (___  _   _ ___| |_ ___ _ __ ___  
|  _  // _ \/ _` | | / __| __| |/ __| |  ___/ _ \| | |/ __/ _ \  \___ \| | | / __| __/ _ \ '_ ` _ \ 
| | \ \  __/ (_| | | \__ \ |_| | (__  | |  | (_) | | | (_|  __/  ____) | |_| \__ \ ||  __/ | | | | |
|_|  \_\___|\__,_|_|_|___/\__|_|\___| |_|   \___/|_|_|\___\___| |_____/ \__, |___/\__\___|_| |_| |_|
                                                                                                                                         
--]]

net.Receive("RealisticPolice:Report", function()
    local RPTNumber = net.ReadInt(32)
    local RPTInformationDecompress = util.Decompress(net.ReadData(RPTNumber))
    RPTTableListReport = util.JSONToTable(RPTInformationDecompress) or {}
end ) 

function Realistic_Police.ListReport(RPTFrame)
    local RpRespX, RpRespY = ScrW(), ScrH()

    local RPTValue = 0
    local RPTTarget = 300
    local speed = 20

    local RPTLFrame = vgui.Create("DFrame", RPTFrame)
	RPTLFrame:SetSize(RpRespX*0.2746, RpRespY*0.41)
    RPTLFrame:Center()
	RPTLFrame:ShowCloseButton(false)
	RPTLFrame:SetDraggable(true)
	RPTLFrame:SetTitle("")
    RPTLFrame.Paint = function(self,w,h)
        RPTValue = Lerp( speed * FrameTime( ), RPTValue, RPTTarget )
        surface.SetDrawColor( Color(Realistic_Police.Colors["black25"].r, Realistic_Police.Colors["black25"].g, Realistic_Police.Colors["black25"].b, RPTValue) )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( Realistic_Police.Colors["gray60200"] )
        surface.DrawOutlinedRect( 0, 0, w, h )

        surface.SetDrawColor( Color(Realistic_Police.Colors["black15"].r, Realistic_Police.Colors["black15"].g, Realistic_Police.Colors["black15"].b, RPTValue) )
        surface.DrawRect( w*0.003, 0, w*0.995, h*0.085 )
        
        draw.DrawText(Realistic_Police.GetSentence("username2"), "rpt_font_7", RpRespX*0.003, RpRespY*0.005, Color(Realistic_Police.Colors["gray220"].r, Realistic_Police.Colors["gray220"].g, Realistic_Police.Colors["gray220"].b, RPTValue), TEXT_ALIGN_LEFT)
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

    local RPTScroll = vgui.Create("DScrollPanel", RPTLFrame)
    RPTScroll:SetSize(RpRespX*0.2695, RpRespY*0.31)
    RPTScroll:SetPos(RpRespX*0.0029, RpRespY*0.095)
    RPTScroll.Paint = function() end 
    local sbar = RPTScroll:GetVBar()
    sbar:SetSize(5,0)
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

    local RPTComboBox = vgui.Create("DComboBox", RPTLFrame)
    RPTComboBox:SetSize(RpRespX*0.269, RpRespY*0.05)
    RPTComboBox:SetText(Realistic_Police.GetSentence("username2"))
    RPTComboBox:SetFont("rpt_font_9")
    RPTComboBox:SetTextColor(Realistic_Police.Colors["black"])
    RPTComboBox:SetPos(RpRespX*0.003, RpRespY*0.04)
    RPTComboBox:AddChoice( Realistic_Police.GetSentence("unknown") )
    for k,v in pairs(player.GetAll()) do 
        RPTComboBox:AddChoice( v:Name(), v )
    end 
    RPTComboBox.Paint = function(self,w,h) 
        surface.SetDrawColor( Realistic_Police.Colors["gray240"] )
        surface.DrawRect( 0, 0, w, h )
    end 
    function RPTComboBox:OnSelect( index, text, data )  

        if IsValid(RPTScroll) then 
            RPTScroll:Clear()
        end 

        local SendPlayer = nil
        if IsValid(data) then 
            SendPlayer = data
        end 

        net.Start("RealisticPolice:Report")
            net.WriteUInt(1, 10)
            net.WriteString("SendInformation")
            net.WriteEntity(SendPlayer)
        net.SendToServer()

        timer.Create("rptactualize", 0.2, 0, function()
            if IsValid(RPTScroll) then 
                RPTScroll:Clear()
            end 
            if IsValid(RPTScroll) then 
                if istable(RPTTableListReport) then 
                    for k,v in pairs(RPTTableListReport) do 
                        local RPTDPanel2 = vgui.Create("DPanel", RPTScroll)
                        RPTDPanel2:SetSize(0, RpRespY*0.1)
                        RPTDPanel2:Dock(TOP)
                        RPTDPanel2:DockMargin(0, 0, 0, 5)
                        RPTDPanel2.Paint = function(self,w,h)
                            surface.SetDrawColor( Realistic_Police.Colors["black15"] )
                            surface.DrawRect( 0, 0, w, h )
                            draw.SimpleText(Realistic_Police.GetSentence("prosecutor").." : "..v.RPTPolice, "rpt_font_9", RpRespX*0.06, RpRespY * 0.012, Realistic_Police.Colors["gray220"], TEXT_ALIGN_LEFT)
                            draw.SimpleText(Realistic_Police.GetSentence("accused").." : "..v.RPTCriminal, "rpt_font_9", RpRespX*0.06, RpRespY * 0.039, Realistic_Police.Colors["gray220"], TEXT_ALIGN_LEFT)
                            draw.SimpleText(Realistic_Police.GetSentence("date").." : "..v.RPTDate, "rpt_font_9", RpRespX*0.06, RpRespY * 0.066, Realistic_Police.Colors["gray220"], TEXT_ALIGN_LEFT)
                        end 

                        local RPTPanelB = vgui.Create("DModelPanel", RPTDPanel2)
                        RPTPanelB:SetSize(RpRespX*0.05, RpRespX*0.05)
                        RPTPanelB:SetPos(RpRespX*0.003,RpRespY*0.007)
                        RPTPanelB.Paint = function(self,w,h)
                            surface.SetDrawColor( Realistic_Police.Colors["black25"] )
                            surface.DrawRect( 0, 0, w, h )
                            if v.Model == "" then 
                                draw.SimpleText("?", "rpt_font_13", RPTPanelB:GetWide()/2, RPTPanelB:GetTall()/2,  Realistic_Police.Colors["white240"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                            end 
                        end 

                        if v.Model != "" then 
                            local RPTModel = vgui.Create("DModelPanel", RPTDPanel2)
                            RPTModel:SetSize(RpRespX*0.05, RpRespX*0.05)
                            RPTModel:SetPos(RpRespX*0.003,RpRespY*0.007)
                            RPTModel:SetModel(v.Model)
                            function RPTModel:LayoutEntity( Entity ) return end	
                            if RPTModel.Entity:LookupBone("ValveBiped.Bip01_Head1") != nil then
                                local headpos = RPTModel.Entity:GetBonePosition(RPTModel.Entity:LookupBone("ValveBiped.Bip01_Head1"))
                                RPTModel:SetLookAt(headpos)
                                RPTModel:SetCamPos(headpos-Vector(-15, 0, 0))
                            end 
                        end 

                        local RPTButtonRead = vgui.Create("DButton", RPTDPanel2)
                        RPTButtonRead:SetSize(RpRespX*0.05, RpRespX*0.04)
                        RPTButtonRead:SetPos(RpRespX*0.215, RpRespY * 0.015)
                        RPTButtonRead:SetText(Realistic_Police.GetSentence("see"))
                        RPTButtonRead:SetTextColor(Realistic_Police.Colors["gray"])
                        RPTButtonRead:SetFont("rpt_font_10")
                        RPTButtonRead.Paint = function(self,w,h) 
                            surface.SetDrawColor( Realistic_Police.Colors["black25"] )
                            surface.DrawRect( 0, 0, w, h )
                        end 
                        RPTButtonRead.DoClick = function()
                            Realistic_Police.ReportMenu(RPTFrame, RPTTableListReport[k], SendPlayer, k)
                            Realistic_Police.Clic()
                        end 
                    end 
                end 
            end 
        end )   
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
