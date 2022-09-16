--[[
 _____            _ _     _   _        _____      _ _             _____           _                 
|  __ \          | (_)   | | (_)      |  __ \    | (_)           / ____|         | |                
| |__) |___  __ _| |_ ___| |_ _  ___  | |__) |__ | |_  ___ ___  | (___  _   _ ___| |_ ___ _ __ ___  
|  _  // _ \/ _` | | / __| __| |/ __| |  ___/ _ \| | |/ __/ _ \  \___ \| | | / __| __/ _ \ '_ ` _ \ 
| | \ \  __/ (_| | | \__ \ |_| | (__  | |  | (_) | | | (_|  __/  ____) | |_| \__ \ ||  __/ | | | | |
|_|  \_\___|\__,_|_|_|___/\__|_|\___| |_|   \___/|_|_|\___\___| |_____/ \__, |___/\__\___|_| |_| |_|
                                                                                                                                         
--]]

net.Receive("RealisticPolice:HandCuff", function()
    local String = net.ReadString() 
    if String == "Jailer" then 
        -- Name of the Player to Jail 
        local NamePlayer = net.ReadString()
        Realistic_Police.Jailer(NamePlayer)
    elseif String == "Bailer" then 
        -- Open the menu of the bailer 
        local RPTTable = net.ReadTable()
        Realistic_Police.Bailer(RPTTable)
    elseif String == "Inspect" then 
        local Ent = net.ReadEntity() 
        local Table = net.ReadTable()
        Realistic_Police.CheckPlayer(Ent, Table)
    end 
end)

function Realistic_Police.Jailer(NamePlayer)
    local RpRespX, RpRespY = ScrW(), ScrH()

    local RPTValue = 0
    local RPTTarget = 300
    local speed = 20

    local RPTLFrame = vgui.Create("DFrame")
	RPTLFrame:SetSize(RpRespX*0.272, RpRespY*0.28)
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
        surface.DrawRect( w*0.003, 0, w*0.995, h*0.12 )

        draw.DrawText(Realistic_Police.GetSentence("arrestMenu"), "rpt_font_7", RpRespX*0.004, RpRespY*0.005, Color(Realistic_Police.Colors["gray220"].r, Realistic_Police.Colors["gray220"].g, Realistic_Police.Colors["gray220"].b, RPTValue), TEXT_ALIGN_LEFT)
    end 

    local DermaNumSlider = vgui.Create( "DNumSlider", RPTLFrame )
    DermaNumSlider:SetPos( RpRespX*-0.16, RpRespY * 0.18 )
    DermaNumSlider:SetSize( RpRespX*0.42, RpRespY*0.01 )
    DermaNumSlider:SetText( "" )
    DermaNumSlider:SetMax( Realistic_Police.MaxDay )	
    DermaNumSlider:SetDecimals( 1 )
    DermaNumSlider:SetDefaultValue ( 0 )
    DermaNumSlider:SetMin(1)
    DermaNumSlider:SetValue(1)
    DermaNumSlider.TextArea:SetVisible(false)
    function DermaNumSlider.Slider:Paint(w, h)
        surface.SetDrawColor( Realistic_Police.Colors["gray60"] )
        surface.DrawRect( 0, 0, w, h )
    end 
    function DermaNumSlider.Slider.Knob:Paint(w, h)
        surface.SetDrawColor( Realistic_Police.Colors["darkblue"] )
	    draw.NoTexture()
	    Realistic_Police.Circle( 0, RpRespY*0.007, 8, 1000 )
    end 
    DermaNumSlider.OnValueChanged = function( panel, value )
        DButtonAccept:SetText(Realistic_Police.GetSentence("confirm").." "..math.Round(value, 0).." "..Realistic_Police.GetSentence("years"))
    end   

    local RPTDPanel = vgui.Create("DPanel", RPTLFrame)
    RPTDPanel:SetSize(RpRespX*0.251, RpRespY*0.05)
    RPTDPanel:SetPos(RpRespX*0.01, RpRespY*0.05)
    RPTDPanel:SetText(Realistic_Police.GetSentence("username2"))
    RPTDPanel.Paint = function(self,w,h)
        surface.SetDrawColor(Realistic_Police.Colors["black180"])
        surface.DrawOutlinedRect( 0, 0, w, h )

        surface.SetDrawColor( Realistic_Police.Colors["black180"] )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( Realistic_Police.Colors["darkblue"] )
        surface.DrawOutlinedRect( 0, 0, w, h )
        draw.DrawText(Realistic_Police.GetSentence("name").." : "..NamePlayer, "rpt_font_7", RpRespX*0.005, RpRespY*0.014, Realistic_Police.Colors["white"], TEXT_ALIGN_LEFT)
    end

    local PanelCT = vgui.Create("DTextEntry", RPTLFrame)
    PanelCT:SetSize(RpRespX*0.251, RpRespY*0.05)
    PanelCT:SetPos(RpRespX*0.01, RpRespY*0.11)
    PanelCT:SetText(" "..Realistic_Police.GetSentence("infractionReason"))
    PanelCT:SetFont("rpt_font_7")
    PanelCT:SetDrawLanguageID(false)
    PanelCT.OnGetFocus = function(self) 
        if PanelCT:GetText() == " "..Realistic_Police.GetSentence("infractionReason") then  
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
        if string.len(PanelCT:GetValue()) >= 1000 then 
            return true 
        end 
    end

    DButtonAccept = vgui.Create("DButton", RPTLFrame)
    DButtonAccept:SetSize(RpRespX*0.253, RpRespY*0.05)
    DButtonAccept:SetPos(RpRespX*0.01, RpRespY*0.21)
    DButtonAccept:SetText(Realistic_Police.GetSentence("confirm"))
    DButtonAccept:SetFont("rpt_font_9")
    DButtonAccept:SetTextColor(Realistic_Police.Colors["white"])
    DButtonAccept.Paint = function(self,w,h)
        surface.SetDrawColor( Realistic_Police.Colors["green"] )
        surface.DrawRect( 5, 0, w-10, h )
    end 
    DButtonAccept.DoClick = function()
        if PanelCT:GetText() != " "..Realistic_Police.GetSentence("infractionReason") then 
            net.Start("RealisticPolice:HandCuff")
                net.WriteString("ArrestPlayer")
                net.WriteUInt(DermaNumSlider:GetValue(), 10)
                net.WriteString(PanelCT:GetText())
            net.SendToServer()
            RPTLFrame:Remove()
        end 
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

function Realistic_Police.Bailer(RPTTable)
    local RpRespX, RpRespY = ScrW(), ScrH()

    local RPTValue = 0
    local RPTTarget = 300
    local speed = 20

    if IsValid(RPTLFrame) then RPTLFrame:Remove() end 
    RPTLFrame = vgui.Create("DFrame")
	RPTLFrame:SetSize(RpRespX*0.2746, RpRespY*0.355)
    RPTLFrame:Center()
	RPTLFrame:ShowCloseButton(false)
	RPTLFrame:SetDraggable(false)
	RPTLFrame:SetTitle("")
    RPTLFrame:MakePopup()
    RPTLFrame.Paint = function(self,w,h)
        RPTValue = Lerp( speed * FrameTime( ), RPTValue, RPTTarget )

        surface.SetDrawColor( Color(Realistic_Police.Colors["black25"].r, Realistic_Police.Colors["black25"].g, Realistic_Police.Colors["black25"].b, RPTValue) )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( Realistic_Police.Colors["gray60200"] )
        surface.DrawOutlinedRect( 0, 0, w, h )

        surface.SetDrawColor( Color(Realistic_Police.Colors["black15"].r, Realistic_Police.Colors["black15"].g, Realistic_Police.Colors["black15"].b, RPTValue) )
        surface.DrawRect( w*0.003, 0, w*0.995, h*0.10 )
        
        draw.DrawText(Realistic_Police.GetSentence("arrestedPlayersList"), "rpt_font_7", RpRespX*0.003, RpRespY*0.005, Color(Realistic_Police.Colors["gray220"].r, Realistic_Police.Colors["gray220"].g, Realistic_Police.Colors["gray220"].b, RPTValue), TEXT_ALIGN_LEFT)
    end 

    local RPTScroll = vgui.Create("DScrollPanel", RPTLFrame)
    RPTScroll:SetSize(RpRespX*0.2695, RpRespY*0.31)
    RPTScroll:SetPos(RpRespX*0.0029, RpRespY*0.04)
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

    for k,v in pairs(RPTTable) do 
        RPTDPanel2 = vgui.Create("DPanel", RPTScroll)
        RPTDPanel2:SetSize(0, RpRespY*0.1)
        RPTDPanel2:Dock(TOP)
        RPTDPanel2:DockMargin(0, 0, 0, 5)
        RPTDPanel2.Paint = function(self,w,h)
            surface.SetDrawColor( Realistic_Police.Colors["black15"] )
            surface.DrawRect( 0, 0, w, h )
            draw.SimpleText(Realistic_Police.GetSentence("name").." : "..v.vName, "rpt_font_9", RpRespX*0.06, RpRespY * 0.012, Realistic_Police.Colors["gray220"], TEXT_ALIGN_LEFT)
            draw.SimpleText(Realistic_Police.GetSentence("reason").." : "..v.vMotif, "rpt_font_9", RpRespX*0.06, RpRespY * 0.039, Realistic_Police.Colors["gray220"], TEXT_ALIGN_LEFT)
            draw.SimpleText(Realistic_Police.GetSentence("price").." : "..DarkRP.formatMoney(v.vPrice), "rpt_font_9", RpRespX*0.06, RpRespY * 0.066, Realistic_Police.Colors["gray220"], TEXT_ALIGN_LEFT)
        end 

        local RPTPanelB = vgui.Create("DModelPanel", RPTDPanel2)
        RPTPanelB:SetSize(RpRespX*0.05, RpRespX*0.05)
        RPTPanelB:SetPos(RpRespX*0.003,RpRespY*0.007)
        RPTPanelB.Paint = function(self,w,h)
            surface.SetDrawColor( Realistic_Police.Colors["black25"] )
            surface.DrawRect( 0, 0, w, h )
        end 

        local RPTModel = vgui.Create("DModelPanel", RPTDPanel2)
        RPTModel:SetSize(RpRespX*0.05, RpRespX*0.05)
        RPTModel:SetPos(RpRespX*0.003,RpRespY*0.007)
        RPTModel:SetModel(v.vModel)
        function RPTModel:LayoutEntity( Entity ) return end	
        local headpos = RPTModel.Entity:GetBonePosition(RPTModel.Entity:LookupBone("ValveBiped.Bip01_Head1"))
        RPTModel:SetLookAt(headpos)
        RPTModel:SetCamPos(headpos-Vector(-15, 0, 0))

        local RPTButtonPay = vgui.Create("DButton", RPTDPanel2)
        RPTButtonPay:SetSize(RpRespX*0.05, RpRespX*0.04)
        RPTButtonPay:SetPos(RpRespX*0.215, RpRespY * 0.015)
        RPTButtonPay:SetText(Realistic_Police.GetSentence("pay"))
        RPTButtonPay:SetTextColor(Realistic_Police.Colors["white"])
        RPTButtonPay:SetFont("rpt_font_10")
        RPTButtonPay.Paint = function(self,w,h) 
            surface.SetDrawColor( Realistic_Police.Colors["black25"] )
            surface.DrawRect( 0, 0, w, h )
        end 
        RPTButtonPay.DoClick = function()
            net.Start("RealisticPolice:HandCuff")
                net.WriteString("Bailer")
                net.WriteEntity(v.vEnt)
                net.WriteUInt(k, 10)
            net.SendToServer()
            RPTLFrame:Remove()
        end 
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

function Realistic_Police.CheckPlayer(Player, Table)
    if not Realistic_Police.CanConfiscateWeapon then return end
    local RpRespX, RpRespY = ScrW(), ScrH()

    local RPTValue = 0
    local RPTTarget = 300
    local speed = 20

    if IsValid(RPTLFrame) then RPTLFrame:Remove() end 
    RPTLFrame = vgui.Create("DFrame")
	RPTLFrame:SetSize(RpRespX*0.2746, RpRespY*0.355)
    RPTLFrame:Center()
	RPTLFrame:ShowCloseButton(false)
	RPTLFrame:SetDraggable(false)
	RPTLFrame:SetTitle("")
    RPTLFrame:MakePopup()
    RPTLFrame.Paint = function(self,w,h)
        RPTValue = Lerp( speed * FrameTime( ), RPTValue, RPTTarget )

        surface.SetDrawColor( Color(Realistic_Police.Colors["black25"].r, Realistic_Police.Colors["black25"].g, Realistic_Police.Colors["black25"].b, RPTValue) )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( Realistic_Police.Colors["gray60200"] )
        surface.DrawOutlinedRect( 0, 0, w, h )

        surface.SetDrawColor( Color(Realistic_Police.Colors["black15"].r, Realistic_Police.Colors["black15"].g, Realistic_Police.Colors["black15"].b, RPTValue) )
        surface.DrawRect( w*0.003, 0, w*0.995, h*0.1 )

        draw.DrawText(Realistic_Police.GetSentence("weaponsList"), "rpt_font_7", RpRespX*0.003, RpRespY*0.005, Color(Realistic_Police.Colors["gray220"].r, Realistic_Police.Colors["gray220"].g, Realistic_Police.Colors["gray220"].b, RPTValue), TEXT_ALIGN_LEFT)
    end 

    local RPTScroll = vgui.Create("DScrollPanel", RPTLFrame)
    RPTScroll:SetSize(RpRespX*0.2695, RpRespY*0.31)
    RPTScroll:SetPos(RpRespX*0.0029, RpRespY*0.04)
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

    local List = vgui.Create( "DIconLayout", RPTScroll )
    List:Dock( FILL )
    List:SetSpaceY( 5 )
    List:SetSpaceX( 5 )

    local ListItem = {}
    for k,v in pairs(Table) do
        if v["ModelW"] != "" then 
            if not Realistic_Police.CantConfiscate[v["ClassW"]] then 
                ListItem[k] = List:Add( "SpawnIcon" )
                ListItem[k]:SetSize( RpRespX*0.087, RpRespX*0.087 ) 
                ListItem[k]:SetModel( v["ModelW"] )
                ListItem[k]:SetTooltip( false )
                ListItem[k].PaintOver = function(self, w,h)
                    surface.SetDrawColor( Realistic_Police.Colors["black100"] )
                    surface.DrawRect( 0, 0, w, h )
                end 

                local DButton1  = vgui.Create("DButton", ListItem[k])
                DButton1:SetSize(RpRespX*0.087, RpRespY*0.025)
                DButton1:SetPos(0,RpRespY*0.129)
                DButton1.PaintOver = function(self, w, h)
                    surface.SetDrawColor( Realistic_Police.Colors["black15"] )
                    surface.DrawRect( 0, 0, w, h )
                    draw.DrawText(Realistic_Police.GetSentence("confiscate"), "rpt_font_7", w/2, h/8, Realistic_Police.Colors["white"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end 
                DButton1.DoClick = function()
                    ListItem[k]:Remove()
                    net.Start("RealisticPolice:HandCuff")
                        net.WriteString("StripWeapon")
                        net.WriteEntity(Player)
                        net.WriteUInt(k, 10)
                    net.SendToServer()
                    surface.PlaySound( "UI/buttonclick.wav" )
                end          
            end 
        end 
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
