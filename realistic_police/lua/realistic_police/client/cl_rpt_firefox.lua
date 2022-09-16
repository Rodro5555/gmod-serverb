function Realistic_Police.FireFox(RPTFrame)
    local RpRespX, RpRespY = ScrW(), ScrH()

    local RPTValue = 100
    local RPTTarget = 300
    local speed = 4

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
        surface.DrawRect( 0, 0, w + 10, h*0.05 )
    end 

    local html = vgui.Create("DHTML", RPTMenu)
    html:Dock(FILL)
    html:OpenURL("https://www.google.com/")

    local RPTClose = vgui.Create("DButton", RPTMenu)
    RPTClose:SetSize(RpRespX*0.0295, RpRespY*0.025)
    RPTClose:SetPos(RPTMenu:GetWide()*0.96, RPTMenu:GetTall()*0.005)
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