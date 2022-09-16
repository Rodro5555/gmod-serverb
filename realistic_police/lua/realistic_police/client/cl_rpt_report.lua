--[[
 _____            _ _     _   _        _____      _ _             _____           _                 
|  __ \          | (_)   | | (_)      |  __ \    | (_)           / ____|         | |                
| |__) |___  __ _| |_ ___| |_ _  ___  | |__) |__ | |_  ___ ___  | (___  _   _ ___| |_ ___ _ __ ___  
|  _  // _ \/ _` | | / __| __| |/ __| |  ___/ _ \| | |/ __/ _ \  \___ \| | | / __| __/ _ \ '_ ` _ \ 
| | \ \  __/ (_| | | \__ \ |_| | (__  | |  | (_) | | | (_|  __/  ____) | |_| \__ \ ||  __/ | | | | |
|_|  \_\___|\__,_|_|_|___/\__|_|\___| |_|   \___/|_|_|\___\___| |_____/ \__, |___/\__\___|_| |_| |_|
                                                                                                                                         
--]]

function Realistic_Police.ReportMenu(RPTFrame, RPTable, RPTSendEntity, RPTIndex)
    local RpRespX, RpRespY = ScrW(), ScrH()
    local TimesDay = os.date("%d/%m/%Y", os.time())
    local RPTActivate = false 
    local RPTEntity = nil 

    local RPTValue = 150
    local RPTTarget = 300
    local speed = 5

    local RPTMenu = vgui.Create("DFrame", RPTFrame)
	RPTMenu:SetSize(RpRespX*0.794, RpRespY*0.8)
    RPTMenu:SetPos(0, 0)
	RPTMenu:ShowCloseButton(false)
	RPTMenu:SetDraggable(false)
	RPTMenu:SetTitle("")
    RPTMenu.Paint = function(self,w,h)
        RPTValue = Lerp( speed * FrameTime(), RPTValue, RPTTarget )
        surface.SetDrawColor( Color(Realistic_Police.Colors["black25"].r, Realistic_Police.Colors["black25"].g, Realistic_Police.Colors["black25"].b, RPTValue) )
		surface.DrawRect( 0, 0, w, h )	

        surface.SetDrawColor( Color(Realistic_Police.Colors["black15"].r, Realistic_Police.Colors["black15"].g, Realistic_Police.Colors["black15"].b, RPTValue) )
        surface.DrawRect( 0, 0, w + 10, h*0.045 )	
    end 

    local RPTScroll = vgui.Create("DScrollPanel", RPTMenu)
	RPTScroll:SetSize(RpRespX*0.794, RpRespY*0.7)
    RPTScroll:SetPos(0,  RpRespY*0.1)
    RPTScroll.Paint = function() end 
    local sbar = RPTScroll:GetVBar()
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

    local RPTDPanel = vgui.Create("DFrame", RPTScroll)
	RPTDPanel:SetSize(RpRespX*0.4, RpRespY*0.85)
    RPTDPanel:SetPos(RpRespX*0.2, 0)
    RPTDPanel:SetDraggable(false)
    RPTDPanel:ShowCloseButton(false)
    RPTDPanel.Paint = function(self,w,h) 
        surface.SetDrawColor( Realistic_Police.Colors["gray240"] )
        surface.DrawRect( 0, 0, w, h )
    end 

    local DLabel = vgui.Create("DLabel", RPTDPanel)
    DLabel:SetSize(RpRespX*0.1,RpRespY*0.1)
    DLabel:SetPos(RpRespX*0.03, 0)
    DLabel:SetText(LocalPlayer():Name())
    DLabel:SetTextColor(Realistic_Police.Colors["black"])
    DLabel:SetFont("rpt_font_21")

    local DLabel2 = vgui.Create("DLabel", RPTDPanel)
    DLabel2:SetSize(RpRespX*0.1,RpRespY*0.1)
    DLabel2:SetPos(RpRespX*0.29, 0)
    DLabel2:SetText(Realistic_Police.GetSentence("at").." "..TimesDay)
    DLabel2:SetTextColor(Realistic_Police.Colors["black"])
    DLabel2:SetFont("rpt_font_21")

    local RPTText = vgui.Create("DTextEntry", RPTDPanel)
    RPTText:SetSize(RpRespX*0.3, RpRespY*0.72)
    RPTText:SetPos(RpRespX*0.05, RpRespY*0.1)
    RPTText:SetMultiline(true) 
    RPTText:SetFont("rpt_font_20")
    if not istable(RPTable) then 
        RPTText:SetValue(Realistic_Police.GetSentence("reportText"))
    else 
        RPTText:SetValue(RPTable["RPTText"]) 
    end
    RPTText:SetDrawLanguageID(false)
    RPTText.Paint = function(self,w,h) 
        self:DrawTextEntryText(Realistic_Police.Colors["black"], Realistic_Police.Colors["black"], Realistic_Police.Colors["black"])
    end 
    RPTText.AllowInput = function( self, stringValue )
        if string.len(RPTText:GetValue()) > 1183 then 
            return true 
        end 
    end
    RPTText.OnChange = function()
        Realistic_Police.HackKey()
    end 
    
    local RPTSteamId = nil 
    local RPTIndexSave = 1
    local RPTDCombobox = vgui.Create("DComboBox", RPTMenu)
    RPTDCombobox:SetSize(RpRespX*0.08, RpRespY*0.03)
    RPTDCombobox:SetPos(RPTMenu:GetWide()*0.9, RpRespY*0.04)
    RPTDCombobox:SetText(Realistic_Police.GetSentence("accusedName"))
    RPTDCombobox:SetTextColor(Realistic_Police.Colors["black"])
    RPTDCombobox:SetFont("rpt_font_8")
    RPTDCombobox.Paint = function(self,w,h) 
        surface.SetDrawColor( Realistic_Police.Colors["gray240"] )
        surface.DrawRect( 0, 0, w, h )
    end 
    RPTDCombobox:AddChoice( Realistic_Police.GetSentence("unknown") )
    for k,v in pairs(player.GetAll()) do 
        if v != LocalPlayer() then 
            RPTDCombobox:AddChoice( v:Name(), v )
        end 
    end 
    function RPTDCombobox:OnSelect( index, text, data )
        RPTActivate = true 
        RPTIndexSave = index 
        Realistic_Police.Clic()
        if text == Realistic_Police.GetSentence("unknown") then 
            RPTEntity = nil
        else 
            RPTEntity = data
        end 
    end
    if istable(RPTable) then 
        RPTDCombobox:Clear()
        RPTActivate = true
        if IsValid(RPTSendEntity) then 
            RPTDCombobox:SetValue(RPTSendEntity:GetName())
        else 
            RPTDCombobox:SetValue(Realistic_Police.GetSentence("unknown")) 
        end 
        RPTSteamId = RPTable["RPTSteamID64"]
        RPTIndexSave = RPTIndex 
        if text == Realistic_Police.GetSentence("unknown") then 
            RPTSteamId = "unknown"
        end 
    end 

    local RPTButtonSave = vgui.Create("DButton", RPTMenu)
    RPTButtonSave:SetSize(RpRespX*0.04, RpRespY*0.03)
    RPTButtonSave:SetPos(RpRespX*0.004,RpRespY*0.04)
    RPTButtonSave:SetText(Realistic_Police.GetSentence("save"))
    RPTButtonSave:SetTextColor(Realistic_Police.Colors["gray200"])
    RPTButtonSave:SetFont("rpt_font_7")
    RPTButtonSave.Paint = function() 
        if RPTButtonSave:IsHovered() then 
            RPTButtonSave:SetTextColor(Realistic_Police.Colors["gray150"]) 
        else 
            RPTButtonSave:SetTextColor(Realistic_Police.Colors["gray200"]) 
        end 
    end 
    RPTButtonSave.DoClick = function()
        if LocalPlayer():isCP() then 
            if IsValid(RPTEntity) then 
                if RPTEntity == LocalPlayer() then RealisticPoliceNotify(Realistic_Police.GetSentence("cantEditSelfSanctions")) return end 
            end 
            if RPTDCombobox:GetValue() == Realistic_Police.GetSentence("unknown") then 
                RPTEntity = nil
            end 
            if RPTActivate then 
                if not istable(RPTable) then 
                    net.Start("RealisticPolice:Report")
                        net.WriteUInt(1, 10)
                        net.WriteString("SaveReport")
                        net.WriteEntity(RPTEntity)
                        net.WriteString(RPTText:GetValue())
                    net.SendToServer()
                else   
                    net.Start("RealisticPolice:Report")
                        net.WriteUInt(RPTIndexSave, 10)
                        net.WriteString("EditReport")
                        net.WriteEntity(RPTSendEntity)
                        net.WriteString(RPTText:GetValue())
                        net.WriteString(RPTDCombobox:GetValue())
                    net.SendToServer()
                end 
                RPTMenu:Remove()
            end 
            timer.Simple(0.4, function()
                if IsValid(RPTScrollLReport) then 
                    Realistic_Police.ActualizeReport(RPTScrollLReport)
                end 
            end ) 
            Realistic_Police.Clic()
        else 
            RealisticPoliceNotify(Realistic_Police.GetSentence("cantDoThat"))
        end 
    end

    local RPTButtonDelete = vgui.Create("DButton", RPTMenu)
    RPTButtonDelete:SetSize(RpRespX*0.04, RpRespY*0.03)
    RPTButtonDelete:SetPos(RpRespX*0.04,RpRespY*0.04)
    RPTButtonDelete:SetText(Realistic_Police.GetSentence("delete"))
    RPTButtonDelete:SetTextColor(Realistic_Police.Colors["gray200"])
    RPTButtonDelete:SetFont("rpt_font_7")
    RPTButtonDelete.Paint = function() 
        if RPTButtonDelete:IsHovered() then 
            RPTButtonDelete:SetTextColor(Realistic_Police.Colors["gray150"]) 
        else 
            RPTButtonDelete:SetTextColor(Realistic_Police.Colors["gray200"]) 
        end 
    end 
    RPTButtonDelete.DoClick = function()
        if LocalPlayer():isCP() then 
            if IsValid(RPTEntity) then 
                if RPTEntity == LocalPlayer() then RealisticPoliceNotify(Realistic_Police.GetSentence("cantDeleteSelfSanctions")) return end 
            end 
            if istable(RPTable) then 
                if RPTDCombobox:GetValue() == Realistic_Police.GetSentence("unknown") then 
                    RPTEntity = nil
                end 
                net.Start("RealisticPolice:Report")
                    net.WriteUInt(RPTIndex, 10)
                    net.WriteString("RemoveReport")
                    net.WriteEntity(RPTSendEntity)
                net.SendToServer()
            end 
            timer.Simple(0.2, function()
                if IsValid(RPTScrollLReport) then 
                    Realistic_Police.ActualizeReport(RPTScrollLReport)
                end 
            end ) 
            RPTMenu:Remove()
            Realistic_Police.Clic()
        else    
            RealisticPoliceNotify(Realistic_Police.GetSentence("cantDelete"))
        end 
    end     

    local RPTClose = vgui.Create("DButton", RPTMenu)
    RPTClose:SetSize(RpRespX*0.03, RpRespY*0.028)
    RPTClose:SetPos(RPTMenu:GetWide()*0.9605, RpRespY*0.00448)
    RPTClose:SetText("")
    RPTClose.Paint = function(self,w,h) 
        surface.SetDrawColor( Realistic_Police.Colors["red"] )
        surface.DrawRect( 0, 0, w, h )
    end 
    RPTClose.DoClick = function()
        RPTMenu:Remove()
        Realistic_Police.Clic()
    end     
end 