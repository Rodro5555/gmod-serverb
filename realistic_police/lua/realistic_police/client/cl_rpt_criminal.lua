

local function CriminalRecord(ply)
    net.Start("RealisticPolice:CriminalRecord")
        net.WriteUInt(0, 10)
        net.WriteString("SendRecord")
        net.WriteEntity(ply)
    net.SendToServer()
end 

local function ScrollCriminalRecord(p, RPTCriminalRecord)
    local RpRespX, RpRespY = ScrW(), ScrH()
    
    if isstring(p:SteamID64()) then 
        DScroll2:Clear()
        timer.Simple(0.5, function() 
            if istable(RPTCriminalRecord) then 
                for k,v in pairs(RPTCriminalRecord) do 
                    local DPanel = vgui.Create("DPanel", DScroll2)
                    DPanel:SetSize(0,RpRespY*0.05 + ( (RpRespX * 0.01) * ( (string.len(v.Motif.." ("..v.Date..")")/44) - 1) ))
                    DPanel:Dock(TOP)
                    DPanel:DockMargin(0,5,0,0)
                    DPanel.Paint = function(self,w,h) 
                        if self:IsHovered() then 
                            surface.SetDrawColor( Realistic_Police.Colors["black240"] )
                            surface.DrawRect( 5, 0, w-10, h )
                        else 
                            surface.SetDrawColor( Realistic_Police.Colors["black25"] )
                            surface.DrawRect( 5, 0, w-10, h )
                        end 
                    end

                    local descriptionLabel = vgui.Create("RichText", DPanel)
                    descriptionLabel:SetSize(RpRespY*0.45, RpRespY*0.05 + ( (RpRespX * 0.011) * ( (string.len(v.Motif.." ("..v.Date..")")/44) - 1) ) )
                    descriptionLabel:SetPos(RpRespY*0.073, RpRespY*0.014)
                    descriptionLabel:SetVerticalScrollbarEnabled(false)
                    descriptionLabel:InsertColorChange(240, 240, 240, 255)
                    descriptionLabel:AppendText(v.Motif.." ("..v.Date..")")
                    function descriptionLabel:PerformLayout(w, h)
                        descriptionLabel:SetContentAlignment(5)
                        self:SetFontInternal("rpt_font_7")
                    end

                    local DButton2 = vgui.Create("DButton", DPanel)
                    DButton2:SetSize(RpRespX*0.018,RpRespX*0.018)
                    DButton2:SetPos(RpRespX*0.3, RpRespY*0.01)
                    DButton2:SetText("")
                    DButton2.Paint = function(self,w,h) 
                        surface.SetDrawColor( Realistic_Police.Colors["white240"] )
                        surface.SetMaterial( Realistic_Police.Colors["Material1"] )
                        surface.DrawTexturedRect( 0, 0, w, h )
                    end
                    DButton2.DoClick = function()
                        if LocalPlayer():isCP() then  
                            if p != LocalPlayer() then 
                                net.Start("RealisticPolice:CriminalRecord")
                                    net.WriteUInt(k, 10)
                                    net.WriteString("RemoveRecord")
                                    net.WriteEntity(p)
                                net.SendToServer()
                                DPanel:Remove()
                                Realistic_Police.Clic()
                            else 
                                RealisticPoliceNotify(Realistic_Police.GetSentence("cantDeleteSelfSanctions"))
                            end 
                        else 
                            RealisticPoliceNotify(Realistic_Police.GetSentence("cantDelete"))
                        end 
                    end 
                end
            end 
        end ) 
    end 
end 

net.Receive("RealisticPolice:CriminalRecord", function()
    local RPTNumber = net.ReadInt(32)
    local RPTInformationDecompress = util.Decompress(net.ReadData(RPTNumber)) or {}
    local RPTCriminalRecord = util.JSONToTable(RPTInformationDecompress)
    local RPTEntity = net.ReadEntity()

    ScrollCriminalRecord(RPTEntity, RPTCriminalRecord)
end ) 


function Realistic_Police.CriminalRecord()
    local RpRespX, RpRespY = ScrW(), ScrH()
    local TablePlayers = player.GetAll()
    local CrimeRecordName = TablePlayers[1]:Name()
    local RPTEntity = TablePlayers[1] 

    local RPTValue = 0
    local RPTTarget = 300
    local speed = 10
    local RPTActivate = false 
    local RPTCriminalP = nil 

    local RPTCFrame = vgui.Create("DFrame", RPTFrame)
	RPTCFrame:SetSize(RpRespX*0.605, RpRespY*0.486)
    RPTCFrame:SetPos(RpRespX*0.115, RpRespY*0.15 )
	RPTCFrame:ShowCloseButton(false)
	RPTCFrame:SetDraggable(true)
	RPTCFrame:SetTitle("")
    RPTCFrame.Paint = function(self,w,h)
        RPTValue = Lerp( speed * FrameTime( ), RPTValue, RPTTarget )
        surface.SetDrawColor( Color(Realistic_Police.Colors["black25"].r, Realistic_Police.Colors["black25"].g, Realistic_Police.Colors["black25"].b, RPTValue) )
        surface.DrawRect( 0, 0, w, h )
        
        surface.SetDrawColor( Color(Realistic_Police.Colors["black15"].r, Realistic_Police.Colors["black15"].g, Realistic_Police.Colors["black15"].b, RPTValue) )
        surface.DrawRect( 0, 0, w + 10, h*0.074 )

        surface.SetDrawColor( Realistic_Police.Colors["black15200"] )
        surface.DrawOutlinedRect( 0, 0, w, h )
        draw.DrawText(Realistic_Police.GetSentence("criminalRecord"), "rpt_font_7", RpRespX*0.003, RpRespY*0.0038, Color(Realistic_Police.Colors["gray220"].r, Realistic_Police.Colors["gray220"].g, Realistic_Police.Colors["gray220"].b, RPTValue), TEXT_ALIGN_LEFT)
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

        surface.SetDrawColor(Realistic_Police.Colors["gray60"])
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

        surface.SetDrawColor(Realistic_Police.Colors["gray60"])
        surface.DrawOutlinedRect( 0, 0, w, h )
        draw.DrawText(Realistic_Police.GetSentence("recordOf").." : "..CrimeRecordName, "rpt_font_7", RpRespX*0.01, RpRespY*0.015, Realistic_Police.Colors["gray"], TEXT_ALIGN_LEFT)
    end 

    DScroll2 = vgui.Create("DScrollPanel", DPanel)
    DScroll2:SetSize(RpRespX*0.335, RpRespY*0.37)
    DScroll2:SetPos(RpRespX*0.01, RpRespY*0.055)
    DScroll2.Paint = function(self,w,h)  
        surface.SetDrawColor( Realistic_Police.Colors["black49"] )
        surface.DrawRect( 0, 0, w, h )
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

    local RPTPanel = vgui.Create("DPanel", RPTCFrame)
    RPTPanel:SetSize(RpRespX*0.12, RpRespY*0.44)
    RPTPanel:SetPos(RpRespX*0.482, RpRespY*0.04)
    RPTPanel.Paint = function(self,w,h) 
        surface.SetDrawColor( Realistic_Police.Colors["black15"] )
        surface.DrawRect( 0, 0, w, h )
        surface.SetDrawColor(Realistic_Police.Colors["gray60"])
        surface.DrawOutlinedRect( 0, 0, w, h )
    end 

    local PanelDModel = vgui.Create("DModelPanel", RPTPanel)
    PanelDModel:SetSize(RpRespX*0.1, RpRespY*0.3)
    PanelDModel:SetPos(RpRespX*0.01, RpRespY*0.04)
    PanelDModel:SetModel(RPTEntity:GetModel())
    PanelDModel.LayoutEntity = function() end 
    PanelDModel:SetCamPos( Vector( 310, 10, 45 ) )
    PanelDModel:SetLookAt( Vector( 0, 0, 36 ) )
    PanelDModel:SetFOV(8)

    local BWanted = vgui.Create("DButton", RPTPanel)
    BWanted:SetSize(RpRespX*0.115, RpRespY*0.03)
    BWanted:SetPos(RpRespX*0.003, RPTPanel:GetTall()*0.82)
    BWanted:SetText(team.GetName(RPTEntity:Team()))
    BWanted:SetFont("rpt_font_7")
    BWanted:SetTextColor(Realistic_Police.Colors["gray"])
    BWanted.Paint = function(self,w,h) 
        surface.SetDrawColor( Realistic_Police.Colors["black25"] )
        surface.DrawRect( 0, 0, w, h )
        surface.SetDrawColor(Realistic_Police.Colors["gray60"])
        surface.DrawOutlinedRect( 0, 0, w, h )
    end 
    BWanted.DoClick = function() end 

    local BWarrant = vgui.Create("DButton", RPTPanel)
    BWarrant:SetSize(RpRespX*0.115, RpRespY*0.03)
    BWarrant:SetPos(RpRespX*0.003, RPTPanel:GetTall()*0.90)
    BWarrant:SetText("Wanted Player")
    BWarrant:SetFont("rpt_font_7")
    BWarrant:SetTextColor(Realistic_Police.Colors["gray"])
    BWarrant.DoClick = function()
        if RPTEntity:isWanted() then 
            RunConsoleCommand("say", "/unwanted "..RPTEntity:Name())
        else 
            RunConsoleCommand("say", "/wanted "..RPTEntity:Name().." "..Realistic_Police.WantedMessage)
        end 
    end 
    BWarrant.Paint = function(self,w,h) 
        if RPTEntity:isWanted() then 
            BWarrant:SetText("UnWanted Player")
        else 
            BWarrant:SetText("Wanted Player")
        end 
        surface.SetDrawColor( Realistic_Police.Colors["black25"] )
        surface.DrawRect( 0, 0, w, h )
        surface.SetDrawColor(Realistic_Police.Colors["gray60"])
        surface.DrawOutlinedRect( 0, 0, w, h )
    end 
    
    CriminalRecord(TablePlayers[1])

    for k,v in pairs(player.GetAll()) do 
        local DButton1 = vgui.Create("DButton", RPTScroll)
        DButton1:SetSize(0,RpRespY*0.05)
        DButton1:SetText(v:Name())
        DButton1:SetFont("rpt_font_7")
        DButton1:Dock(TOP)
        DButton1:DockMargin(0,5,0,0)
        DButton1.Paint = function(self,w,h) 
            surface.SetDrawColor( Realistic_Police.Colors["black25150"] )
            surface.DrawRect( 5, 0, w, h ) 
            if v:isWanted() then
                DButton1:SetTextColor(Realistic_Police.Colors["red"])
            else 
                DButton1:SetTextColor(Realistic_Police.Colors["gray"])
            end 
        end 
        DButton1.DoClick = function()
            DScroll2:Clear()
            CriminalRecord(v)
            Realistic_Police.Clic()
            RPTEntity = v 
            PanelDModel:SetModel(v:GetModel())
            CrimeRecordName = v:Name()
            BWanted:SetText(team.GetName(v:Team()))
        end 
    end

    local BAdd = vgui.Create("DButton", DPanel)
    BAdd:SetSize(RpRespX*0.06, RpRespY*0.03)
    BAdd:SetPos(RpRespX*0.2877, RpRespY*0.0145)
    BAdd:SetText(Realistic_Police.GetSentence("addUpperCase"))
    BAdd:SetFont("rpt_font_7")
    BAdd:SetTextColor(Realistic_Police.Colors["gray"])
    BAdd.Paint = function(self,w,h) 
        surface.SetDrawColor( Realistic_Police.Colors["black25"] )
        surface.DrawRect( 5, 0, w-10, h )
    end 
    BAdd.DoClick = function()
        local PanelCreate = vgui.Create("DFrame", RPTBaseFrame)
        PanelCreate:SetSize(RpRespX*0.2, RpRespY*0.22)
        PanelCreate:Center()
        PanelCreate:SetTitle("")
        PanelCreate:ShowCloseButton(false)
        PanelCreate.Paint = function(self,w,h)
            surface.SetDrawColor( Realistic_Police.Colors["black25"] )
            surface.DrawRect( 0, 0, w, h )  

            surface.SetDrawColor(Realistic_Police.Colors["gray60"])
            surface.DrawOutlinedRect( 0, 0, w, h )
        end 

        local PanelCD = vgui.Create("DComboBox", PanelCreate)
        PanelCD:SetSize(RpRespX*0.18, RpRespY*0.05)
        PanelCD:SetPos(RpRespX*0.01, RpRespY*0.03)
        PanelCD:SetText(Realistic_Police.GetSentence("username"))
        PanelCD:SetFont("rpt_font_7")
        for k,v in pairs(player.GetAll()) do 
            PanelCD:AddChoice(v:Name(), v)
        end 
        function PanelCD:OnSelect( index, text, data )
            RPTActivate = true 
            RPTCriminalP = data
            Realistic_Police.Clic()
        end

        local PanelCT = vgui.Create("DTextEntry", PanelCreate)
        PanelCT:SetSize(RpRespX*0.18, RpRespY*0.05)
        PanelCT:SetPos(RpRespX*0.01, RpRespY*0.085)
        PanelCT:SetText(" "..Realistic_Police.GetSentence("infractionReason"))
        PanelCT:SetFont("rpt_font_7")
        PanelCT:SetDrawLanguageID(false)
        PanelCT.OnGetFocus = function(self) 
            if PanelCT:GetText() == " "..Realistic_Police.GetSentence("infractionReason") then 
                PanelCT:SetText("") 
            end 
        end 
        PanelCT.OnLoseFocus = function(self)
            if PanelCT:GetText() == "" then  
                PanelCT:SetText(" "..Realistic_Police.GetSentence("infractionReason"))
            end
        end 
        PanelCT.AllowInput = function( self, stringValue )
            if string.len(PanelCT:GetValue()) > 1000 then 
                return true 
            end 
        end
        local ButtonAdd = vgui.Create("DButton", PanelCreate)
        ButtonAdd:SetSize(RpRespX*0.088, RpRespY*0.05)
        ButtonAdd:SetPos(RpRespX*0.01, RpRespY*0.145)
        ButtonAdd:SetText(Realistic_Police.GetSentence("create"))
        ButtonAdd:SetFont("rpt_font_7")
        ButtonAdd:SetTextColor(Realistic_Police.Colors["gray"])
        ButtonAdd.Paint = function(self,w,h)
            if ButtonAdd:IsHovered() then 
                surface.SetDrawColor( Realistic_Police.Colors["black15200"] )
                surface.DrawRect( 0, 0, w, h )  
            else 
                surface.SetDrawColor( Realistic_Police.Colors["black15"] )
                surface.DrawRect( 0, 0, w, h )
            end 
        end 
        ButtonAdd.DoClick = function()
            if RPTActivate && IsValid(RPTCriminalP) then 
                if PanelCT:GetText() != " "..Realistic_Police.GetSentence("infractionReason") then 
                    if LocalPlayer():isCP() then 
                        net.Start("RealisticPolice:CriminalRecord")
                            net.WriteUInt(1, 10)
                            net.WriteString("AddRecord")
                            net.WriteEntity(RPTCriminalP)
                            net.WriteString(PanelCT:GetValue())
                        net.SendToServer()
                        PanelCreate:Remove()
                        DScroll2:Clear()
                        CriminalRecord(RPTCriminalP)
                        Realistic_Police.Clic()
                    else 
                        RealisticPoliceNotify(Realistic_Police.GetSentence("cantDoThat"))
                    end 
                else 
                    surface.PlaySound( "buttons/combine_button1.wav" )
                end 
            else    
                surface.PlaySound( "buttons/combine_button1.wav" )
            end 
        end 

        local ButtonDel = vgui.Create("DButton", PanelCreate)
        ButtonDel:SetSize(RpRespX*0.0885, RpRespY*0.05)
        ButtonDel:SetPos(RpRespX*0.101, RpRespY*0.145)
        ButtonDel:SetText(Realistic_Police.GetSentence("cancel"))
        ButtonDel:SetFont("rpt_font_7")
        ButtonDel:SetTextColor(Realistic_Police.Colors["white"])
        ButtonDel.Paint = function(self,w,h)
            if ButtonAdd:IsHovered() then 
                surface.SetDrawColor( Realistic_Police.Colors["black15200"] )
                surface.DrawRect( 0, 0, w, h )
            else 
                surface.SetDrawColor( Realistic_Police.Colors["black15"] )
                surface.DrawRect( 0, 0, w, h )
            end 
        end 
        ButtonDel.DoClick = function()
            PanelCreate:Remove()
            Realistic_Police.Clic()
        end 
        Realistic_Police.Clic()
    end 

    local RPTClose = vgui.Create("DButton", RPTCFrame)
    RPTClose:SetSize(RpRespX*0.03, RpRespY*0.028)
    RPTClose:SetPos(RPTCFrame:GetWide()*0.95, RPTCFrame:GetTall()*0.0068)
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
