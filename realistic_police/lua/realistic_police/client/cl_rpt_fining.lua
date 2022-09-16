--[[
 _____            _ _     _   _        _____      _ _             _____           _                 
|  __ \          | (_)   | | (_)      |  __ \    | (_)           / ____|         | |                
| |__) |___  __ _| |_ ___| |_ _  ___  | |__) |__ | |_  ___ ___  | (___  _   _ ___| |_ ___ _ __ ___  
|  _  // _ \/ _` | | / __| __| |/ __| |  ___/ _ \| | |/ __/ _ \  \___ \| | | / __| __/ _ \ '_ ` _ \ 
| | \ \  __/ (_| | | \__ \ |_| | (__  | |  | (_) | | | (_|  __/  ____) | |_| \__ \ ||  __/ | | | | |
|_|  \_\___|\__,_|_|_|___/\__|_|\___| |_|   \___/|_|_|\___\___| |_____/ \__, |___/\__\___|_| |_| |_|
                                                                                                                                         
--]]

local function GetAmountByName(String)
    local Amount = 0 
    for k,v in pairs(Realistic_Police.FiningPolice) do 
        if v.Name == String then 
            Amount = v.Price 
        end 
    end 
    return Amount 
end

local function RPTGetCategory(Bool)
    local Table = {}
    for k,v in pairs(Realistic_Police.FiningPolice) do 
        if v.Vehicle == Bool then 
            if not table.HasValue(Table, v.Category) then 
                table.insert(Table, v.Category)
            end 
        end 
    end
    return Table 
end 

local function RPTGetFineByCategory(String, Bool)
    local Table = {}
    for k,v in pairs(Realistic_Police.FiningPolice) do 
        if String == v.Category && Bool == v.Vehicle then 
            Table[#Table + 1] = v 
        end 
    end
    return Table 
end 

function Realistic_Police.OpenFiningMenu(Boolen)
    local RpRespX, RpRespY = ScrW(), ScrH()

    local RPTValue = 0
    local RPTTarget = 300
    local speed = 10
    local RPTActivate = false 

    if IsValid(RPTFFrame) then RPTFFrame:Remove() end 

    RPTFFrame = vgui.Create("DFrame")
	RPTFFrame:SetSize(RpRespX*0.28, RpRespY*0.602)
    RPTFFrame:Center()
	RPTFFrame:ShowCloseButton(false)
	RPTFFrame:SetDraggable(false)
    RPTFFrame:MakePopup()
	RPTFFrame:SetTitle("")
    RPTFFrame.Paint = function(self,w,h)
        RPTValue = Lerp( speed * FrameTime( ), RPTValue, RPTTarget )

        surface.SetDrawColor( Color(Realistic_Police.Colors["black25"].r, Realistic_Police.Colors["black25"].g, Realistic_Police.Colors["black25"].b, RPTValue) )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( Color(Realistic_Police.Colors["black15"].r, Realistic_Police.Colors["black15"].g, Realistic_Police.Colors["black15"].b, RPTValue) )
        surface.DrawRect( 0, 0, w + 10, h*0.074 )

        surface.SetDrawColor( Realistic_Police.Colors["gray60"] )
        surface.DrawRect( RpRespX*0.005,  RpRespY*0.04, w*0.97, h*0.918 )

        surface.SetDrawColor( Realistic_Police.Colors["black15200"] )
        surface.DrawOutlinedRect( 0, 0, w, h )

        draw.DrawText(Realistic_Police.GetSentence("fineBook"), "rpt_font_9", RpRespX*0.005, RpRespY*0.007, Color(Realistic_Police.Colors["gray220"].r, Realistic_Police.Colors["gray220"].g, Realistic_Police.Colors["gray220"].b, RPTValue), TEXT_ALIGN_LEFT)
    end 

    local RPTScroll = vgui.Create("DScrollPanel", RPTFFrame)
    RPTScroll:SetSize(RpRespX*0.27, RpRespY*0.496)
    RPTScroll:SetPos(RpRespX*0.006, RpRespY*0.04)
    RPTScroll.Paint = function(self,w,h)
        surface.SetDrawColor( Realistic_Police.Colors["gray60"] )
        surface.DrawRect( 0, 0, w, h )
    end
    local sbar = RPTScroll:GetVBar()
    sbar:SetSize(0,0)
    
    RPTCheckbox = {}
    local TableFiningSytem = {}
    local DButton1 = {}
    local RPTMoney = 0
    for k,v in pairs(RPTGetCategory(Boolen)) do 
        DButton1[k] = vgui.Create("DButton", RPTScroll)
        DButton1[k]:SetSize(0,RpRespY*0.05)
        DButton1[k]:SetText("")
        DButton1[k]:SetFont("rpt_font_7")
        DButton1[k]:SetTextColor(Realistic_Police.Colors["white"])
        DButton1[k]:Dock(TOP)
        DButton1[k].Extend = false 
        DButton1[k].FineName = v 
        DButton1[k]:DockMargin(0,5,0,0)
        DButton1[k].Paint = function(self,w,h) 
            if self:IsHovered() then 
                surface.SetDrawColor( Realistic_Police.Colors["black25"] )
                surface.DrawRect( 5, 0, w-10, h )
                surface.SetDrawColor(Realistic_Police.Colors["gray100"])
                surface.DrawOutlinedRect( 5, 0, w-10, h )
                surface.SetDrawColor(Realistic_Police.Colors["gray100"])
                surface.DrawOutlinedRect( 5, 0, w-10, RpRespY*0.05 )
            else 
                surface.SetDrawColor( Realistic_Police.Colors["black25"] )
                surface.DrawRect( 5, 0, w-10, h )
                surface.SetDrawColor(Realistic_Police.Colors["gray100"])
                surface.DrawOutlinedRect( 5, 0, w-10, h )
                surface.SetDrawColor(Realistic_Police.Colors["gray100"])
                surface.DrawOutlinedRect( 5, 0, w-10, RpRespY*0.05 )
            end 
            draw.DrawText("Category : "..v, "rpt_font_7", DButton1[k]:GetWide()/2.05, RpRespY*0.013,  Realistic_Police.Colors["white"], TEXT_ALIGN_CENTER)
        end
        local ParentDScrollPanel = {}
        DButton1[k].DoClick = function()
            if not DButton1[k].Extend then 
                DButton1[k]:SetSize(0,#RPTGetFineByCategory(DButton1[k].FineName, Boolen) * RpRespY*0.054 + RpRespY*0.06 )
                DButton1[k]:SlideDown(0.5)
                DButton1[k].Extend = true 

                ParentDScrollPanel[k] = vgui.Create("DScrollPanel", DButton1[k])
                ParentDScrollPanel[k]:SetPos(RpRespX*0.0034, RpRespY*0.051)
                ParentDScrollPanel[k]:SetSize(RpRespX*0.262, #RPTGetFineByCategory(DButton1[k].FineName, Boolen) * RpRespY*0.054 + RpRespY*0.06 )
                ParentDScrollPanel[k]:SlideDown(0.5)
                ParentDScrollPanel[k].Paint = function() end 
                ParentDScrollPanel[k]:GetVBar():SetSize(0,0)

                local DButtonScroll = {}
                for id, v in pairs( RPTGetFineByCategory(DButton1[k].FineName, Boolen) ) do 
                    DButtonScroll[id] = vgui.Create("DButton", ParentDScrollPanel[k])
                    DButtonScroll[id]:SetSize(0,RpRespY*0.05)
                    DButtonScroll[id]:SetText("")
                    DButtonScroll[id]:SetFont("rpt_font_7")
                    DButtonScroll[id]:SetTextColor(Realistic_Police.Colors["white"])
                    DButtonScroll[id]:Dock(TOP)
                    DButtonScroll[id]:DockMargin(3,4,0,0)
                    DButtonScroll[id].Paint = function(self,w,h) 
                        if self:IsHovered() then 
                            surface.SetDrawColor( Realistic_Police.Colors["gray50"] )
                            surface.DrawRect( 0, 0, w, h )
                            surface.SetDrawColor(Realistic_Police.Colors["gray60"])
                            surface.DrawOutlinedRect( 0, 0, w, RpRespY*0.05 )
                        else 
                            surface.SetDrawColor( Realistic_Police.Colors["gray50"] )
                            surface.DrawRect( 0, 0, w, h )
                            surface.SetDrawColor(Realistic_Police.Colors["gray60"])
                            surface.DrawOutlinedRect( 0, 0, w, RpRespY*0.05 )
                        end 
                        draw.DrawText("  "..(v.Name or ""), "rpt_font_7", DButtonScroll[id]:GetWide()/2.05, RpRespY*0.013,  Realistic_Police.Colors["white"], TEXT_ALIGN_CENTER)
                    end
                    DButtonScroll[id].DoClick = function()
                        if not table.HasValue(TableFiningSytem, v.Name) then 
                            if #TableFiningSytem < Realistic_Police.MaxPenalty then
                                table.insert(TableFiningSytem, v.Name)
                                RPTCheckbox[id]:SetChecked(true)
                            else 
                                table.RemoveByValue(TableFiningSytem, v.Name)
                                RPTCheckbox[id]:SetChecked(false)
                                RealisticPoliceNotify(Realistic_Police.GetSentence("richSanctions"))
                            end
                        else 
                            table.RemoveByValue(TableFiningSytem, v.Name)
                            RPTCheckbox[id]:SetChecked(false) 
                        end 
                        RPTMoney = 0 
                        for k,v in pairs(Realistic_Police.FiningPolice) do 
                            if table.HasValue(TableFiningSytem, v.Name) then 
                                RPTMoney = RPTMoney + v.Price
                            end 
                        end    
                    end 
                    
                    RPTCheckbox[id] = vgui.Create( "DCheckBox", DButtonScroll[id] )
                    RPTCheckbox[id]:SetPos( RpRespX*0.01, RpRespY*0.02 ) 
                    RPTCheckbox[id]:SetChecked( false )
                    RPTCheckbox[id].OnChange = function(val)
                        if not table.HasValue(TableFiningSytem, v.Name) then 
                            if #TableFiningSytem < Realistic_Police.MaxPenalty then
                                table.insert(TableFiningSytem, v.Name)
                                RPTCheckbox[id]:SetChecked(true)
                            else 
                                table.RemoveByValue(TableFiningSytem, v.Name)
                                RPTCheckbox[id]:SetChecked(false)
                                RealisticPoliceNotify(Realistic_Police.GetSentence("richSanctions"))
                            end
                        else 
                            table.RemoveByValue(TableFiningSytem, v.Name)
                            RPTCheckbox[id]:SetChecked(false) 
                        end 
                        RPTMoney = 0 
                        for k,v in pairs(Realistic_Police.FiningPolice) do 
                            if table.HasValue(TableFiningSytem, v.Name) then 
                                RPTMoney = RPTMoney + v.Price
                            end 
                        end 
                    end 
                    for _,name in pairs(TableFiningSytem) do 
                        if name == v.Name then 
                            RPTCheckbox[id]:SetChecked(true) 
                        end 
                    end 
                end 
            else 
                DButton1[k].Extend = false 
                DButton1[k]:SizeTo(DButton1[k]:GetWide(), RpRespY*0.05, 0.5, 0, -1, function()
                    ParentDScrollPanel[k]:Remove()
                end )
            end 
        end 
    end 


    local DButtonAccept = vgui.Create("DButton", RPTFFrame)
    DButtonAccept:SetSize(RpRespX*0.271, RpRespY*0.05)
    DButtonAccept:SetPos(RpRespX*0.005, RpRespY*0.5375)
    DButtonAccept:SetText(Realistic_Police.GetSentence("confirm").." ( "..RPTMoney.."  $ )")
    DButtonAccept:SetFont("rpt_font_7")
    DButtonAccept:SetTextColor(Realistic_Police.Colors["white"])
    DButtonAccept.Paint = function(self,w,h)
        surface.SetDrawColor( Realistic_Police.Colors["black25"] )
        surface.DrawRect( 5, 0, w-10, h )
        DButtonAccept:SetText(Realistic_Police.GetSentence("confirm").." ( "..RPTMoney.."  $ )")
    end 
    DButtonAccept.DoClick = function()
        if istable(TableFiningSytem) && #TableFiningSytem != 0 then
            local StringToSend = ""
            for k,v in pairs(TableFiningSytem) do 
                StringToSend = StringToSend.."§"..v 
            end 
            net.Start("RealisticPolice:FiningSystem")
                net.WriteString("SendFine")
                net.WriteString(StringToSend)
            net.SendToServer()
            RPTFFrame:SlideUp(0.7)
        else 
            RealisticPoliceNotify(Realistic_Police.GetSentence("mustSelectPenality"))
        end 
    end 

    local RPTClose = vgui.Create("DButton", RPTFFrame)
    RPTClose:SetSize(RpRespX*0.03, RpRespY*0.028)
    RPTClose:SetPos(RPTFFrame:GetWide()*0.878, RPTFFrame:GetTall()*0.0068)
    RPTClose:SetText("")
    RPTClose.Paint = function(self,w,h) 
        surface.SetDrawColor( Realistic_Police.Colors["red"] )
        surface.DrawRect( 0, 0, w, h )
    end 
    RPTClose.DoClick = function()
        RPTFFrame:Remove()
        Realistic_Police.Clic()
        net.Start("RealisticPolice:FiningSystem")
            net.WriteString("StopFine")
        net.SendToServer()
    end
end

net.Receive("RealisticPolice:FiningSystem", function()
    local Table = net.ReadTable() or {}
    local RpRespX, RpRespY = ScrW(), ScrH()

    local RPTValue = 0
    local RPTTarget = 300
    local speed = 10
    local RPTActivate = false 
    local Amount = 0 

    for k,v in pairs(Realistic_Police.FiningPolice) do 
        if table.HasValue(Table, v.Name) then 
            Amount = Amount + v.Price
        end 
    end     

    if IsValid(RPTFFrame) then RPTFFrame:Remove() end 
    RPTFFrame = vgui.Create("DFrame")
	RPTFFrame:SetSize(RpRespX*0.28, RpRespY*0.602)
    RPTFFrame:Center()
	RPTFFrame:ShowCloseButton(false)
	RPTFFrame:SetDraggable(false)
	RPTFFrame:SetTitle("")
    RPTFFrame:MakePopup()
    RPTFFrame.Paint = function(self,w,h)
        RPTValue = Lerp( speed * FrameTime( ), RPTValue, RPTTarget )
        surface.SetDrawColor( Color(Realistic_Police.Colors["black25"].r, Realistic_Police.Colors["black25"].g, Realistic_Police.Colors["black25"].b, RPTValue) )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( Color(Realistic_Police.Colors["black15"].r, Realistic_Police.Colors["black15"].g, Realistic_Police.Colors["black15"].b, RPTValue) )
        surface.DrawRect( 0, 0, w + 10, h*0.074 )

        surface.SetDrawColor( Realistic_Police.Colors["gray60"] )
        surface.DrawRect( RpRespX*0.005,  RpRespY*0.04, w*0.97, h*0.918 )

        surface.SetDrawColor( Realistic_Police.Colors["black15200"] )
        surface.DrawOutlinedRect( 0, 0, w, h )
        
        draw.DrawText(Realistic_Police.GetSentence("fineBook"), "rpt_font_9", RpRespX*0.005, RpRespY*0.007, Color(Realistic_Police.Colors["gray220"].r, Realistic_Police.Colors["gray220"].g, Realistic_Police.Colors["gray220"].b, RPTValue), TEXT_ALIGN_LEFT)
    end 

    local RPTScroll = vgui.Create("DScrollPanel", RPTFFrame)
    RPTScroll:SetSize(RpRespX*0.27, RpRespY*0.496)
    RPTScroll:SetPos(RpRespX*0.005, RpRespY*0.04)
    RPTScroll.Paint = function(self,w,h)
        surface.SetDrawColor( Realistic_Police.Colors["gray60"] )
        surface.DrawRect( 0, 0, w, h )
    end
    local sbar = RPTScroll:GetVBar()
    sbar:SetSize(0,0)

    for k,v in pairs(Table) do 
        DButton1 = vgui.Create("DButton", RPTScroll)
        DButton1:SetSize(0,RpRespY*0.05)
        DButton1:SetText(v.." ("..DarkRP.formatMoney(GetAmountByName(v))..")")
        DButton1:SetFont("rpt_font_7")
        DButton1:SetTextColor(Realistic_Police.Colors["white"])
        DButton1:Dock(TOP)
        DButton1:DockMargin(0,5,0,0)
        DButton1.Paint = function(self,w,h) 
            surface.SetDrawColor( Realistic_Police.Colors["black25"] )
            surface.DrawRect( 5, 0, w-10, h )
        end
    end 

    local DButtonBuy = vgui.Create("DButton", RPTFFrame)
    DButtonBuy:SetSize(RpRespX*0.27, RpRespY*0.05)
    DButtonBuy:SetPos(RpRespX*0.005, RpRespY*0.5375)
    DButtonBuy:SetText(Realistic_Police.GetSentence("payFine").." : "..DarkRP.formatMoney(Amount))
    DButtonBuy:SetFont("rpt_font_7")
    DButtonBuy:SetTextColor(Realistic_Police.Colors["white"])
    DButtonBuy.Paint = function(self,w,h)
        surface.SetDrawColor( Realistic_Police.Colors["green"] )
        surface.DrawRect( 5, 0, w-10, h )

        surface.SetDrawColor( Realistic_Police.Colors["green"] )
        surface.DrawOutlinedRect( 5, 0, w-10, h )
    end 
    DButtonBuy.DoClick = function() 
        if LocalPlayer():getDarkRPVar("money") >= Amount then 
            net.Start("RealisticPolice:FiningSystem")
                net.WriteString("BuyFine")
            net.SendToServer()
            RPTFFrame:SlideUp(0.7)
        else 
            RealisticPoliceNotify(Realistic_Police.GetSentence("cantAffordFine"))
        end
    end     

    local RPTClose = vgui.Create("DButton", RPTFFrame)
    RPTClose:SetSize(RpRespX*0.03, RpRespY*0.028)
    RPTClose:SetPos(RPTFFrame:GetWide()*0.878, RPTFFrame:GetTall()*0.0068)
    RPTClose:SetText("")
    RPTClose.Paint = function(self,w,h) 
        surface.SetDrawColor( Realistic_Police.Colors["red"] )
        surface.DrawRect( 0, 0, w, h )
    end 
    RPTClose.DoClick = function()
        RPTFFrame:Remove()
        Realistic_Police.Clic()
        net.Start("RealisticPolice:FiningSystem")
            net.WriteString("RefuseFine")
        net.SendToServer()
    end 
end ) 
