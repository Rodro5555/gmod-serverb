--[[

 _____           _ _     _   _          _    _                 _            _   _            
| ___ \         | (_)   | | (_)        | |  | |               | |          | | | |           
| |_/ /___  __ _| |_ ___| |_ _  ___    | |  | | ___   ___   __| | ___ _   _| |_| |_ ___ _ __ 
|    // _ \/ _` | | / __| __| |/ __|   | |/\| |/ _ \ / _ \ / _` |/ __| | | | __| __/ _ \ '__|
| |\ \  __/ (_| | | \__ \ |_| | (__    \  /\  / (_) | (_) | (_| | (__| |_| | |_| ||  __/ |   
\_| \_\___|\__,_|_|_|___/\__|_|\___|    \/  \/ \___/ \___/ \__,_|\___|\__,_|\__|\__\___|_|   


--]]

function Realistic_Woodcutter.Info(ply)
	if IsValid(RWCInfoMenu) then return end
	local rwc_id_info = 1
	local RWCInfoMenu = vgui.Create( "DFrame" )
	RWCInfoMenu:SetSize( ScrW()*0.3, ScrH()*0.54 )
	RWCInfoMenu:SetTitle( "" )
	RWCInfoMenu:SetDraggable(false)
	RWCInfoMenu:ShowCloseButton(false)
	RWCInfoMenu:Center()
	RWCInfoMenu:SlideDown(0.7)
	RWCInfoMenu:MakePopup()
	RWCInfoMenu.Paint = function(self,w,h)
		draw.RoundedBox(0, ScrW()*0, ScrH()*0, w, h, Realistic_Woodcutter.Colors["lightblue"])
		draw.RoundedBox(0,ScrW()*0,ScrH()*0,w,ScrH()*0.08,Realistic_Woodcutter.Colors["darkblue"])
		draw.DrawText("WOODCUTTER-MENU", "rwc_font_1", RWCInfoMenu:GetWide()/2, ScrH()*0.015, Realistic_Woodcutter.Colors["white"], TEXT_ALIGN_CENTER)	
		draw.RoundedBox(0,ScrW()*0,ScrH()*0.08,w,ScrH()*0.0023,Realistic_Woodcutter.Colors["gray"])
	end

	local RWCInfoFrameImage = vgui.Create("DPanel", RWCInfoMenu)
	RWCInfoFrameImage:SetSize( ScrW()*0.28, ScrH()*0.3 )
	RWCInfoFrameImage:SetPos(ScrW()*0.011, ScrH()*0.1)
	RWCInfoFrameImage.Paint = function(self,w,h)
		draw.RoundedBox(0,ScrW()*0,ScrH()*0,w,h,Realistic_Woodcutter.Colors["darkblue"])
		surface.SetDrawColor(Realistic_Woodcutter.Colors["lightblue"])
		surface.DrawOutlinedRect( 0, 0, w,h )
	end 	
	local RWCInfoImage = vgui.Create("DImage", RWCInfoFrameImage)
	RWCInfoImage:SetSize( ScrW()*0.27, ScrH()*0.28 )
	RWCInfoImage:SetPos(ScrW()*0.005, ScrH()*0.010)
	RWCInfoImage.Paint = function(self,w,h)
		surface.SetDrawColor( Realistic_Woodcutter.Colors["white"] ) 
		surface.SetMaterial( Material(Realistic_Woodcutter.InfosMenu[rwc_id_info]["model"]) )
		surface.DrawTexturedRect( ScrW()*0, ScrH()*0, w, h )
	end 
	local RWCInfoFrameText = vgui.Create("DPanel", RWCInfoMenu)
	RWCInfoFrameText:SetSize( ScrW()*0.28, ScrH()*0.05 )
	RWCInfoFrameText:SetPos(ScrW()*0.011, ScrH()*0.41)
	RWCInfoFrameText.Paint = function(self,w,h)
		draw.RoundedBox(0,ScrW()*0,ScrH()*0,w,h,Realistic_Woodcutter.Colors["darkblue"])
		draw.DrawText(Realistic_Woodcutter.InfosMenu[rwc_id_info]["text"], "rwc_font_4", ScrW()*0.14, RWCInfoFrameText:GetTall()*0.03, Realistic_Woodcutter.Colors["white"], TEXT_ALIGN_CENTER)	
		surface.SetDrawColor(Realistic_Woodcutter.Colors["lightblue"])
		surface.DrawOutlinedRect( 0, 0, w,h )
	end 
	local RWCInfoFrameButton = vgui.Create("DButton", RWCInfoMenu)
	RWCInfoFrameButton:SetSize((ScrW()*0.275)/2, ScrH()*0.05)
	RWCInfoFrameButton:SetPos(ScrW()*0.014 + (ScrW()*0.282)/2, ScrH()*0.468)
	RWCInfoFrameButton:SetFont("rwc_font_3")
	RWCInfoFrameButton:SetText(Realistic_Woodcutter.GetSentence("nextStep"))
	RWCInfoFrameButton:SetTextColor( Realistic_Woodcutter.Colors["white"] )

	local RWCInfoFrameBefore = vgui.Create("DButton", RWCInfoMenu)
	RWCInfoFrameBefore:SetSize((ScrW()*0.275)/2, ScrH()*0.05)
	RWCInfoFrameBefore:SetPos(ScrW()*0.011, ScrH()*0.468)
	RWCInfoFrameBefore:SetFont("rwc_font_3")
	RWCInfoFrameBefore:SetText(Realistic_Woodcutter.GetSentence("lastStep"))
	RWCInfoFrameBefore:SetTextColor( Realistic_Woodcutter.Colors["white"] )
	RWCInfoFrameBefore.Paint = function(self,w,h)
		if self:IsHovered() then		
			draw.RoundedBox(0,2,2,w-4,h-4,Realistic_Woodcutter.Colors["darkblueopac"])
			surface.SetDrawColor(Realistic_Woodcutter.Colors["darkblue"])
			surface.DrawOutlinedRect( 0, 0, w,h )
		else
			draw.RoundedBox(0,2,2,w-4,h-4,Realistic_Woodcutter.Colors["darkblue"])
			surface.SetDrawColor(Realistic_Woodcutter.Colors["darkblue"])
			surface.DrawOutlinedRect( 0, 0, w,h )
		end 
	end 

	local RWCInfoMenuChoice = vgui.Create("DPanel", RWCInfoMenu)
	RWCInfoMenuChoice:SetSize( ScrW()*0.3, ScrH()*0.08 )
	RWCInfoMenuChoice:SetPos(0, ScrH()*0.54)
	RWCInfoMenuChoice.Paint = function(self,w,h) end

	RWCInfoFrameBefore.DoClick = function(self,w,h)
		surface.PlaySound( "UI/buttonclick.wav" )
		RWCInfoFrameButton:SetText(Realistic_Woodcutter.GetSentence("nextStep"))
		if rwc_id_info != 1 then 
			rwc_id_info = rwc_id_info - 1
		end 
		if rwc_id_info == 10 then 
			rwc_id_info = rwc_id_info - 4
		end 
		if rwc_id_info == 6 then 
			RWCInfoMenuChoice:MoveTo(0, ScrH()*0.465, 0, 0.1)
		end 
	end 

	local RWCInfoFrameButtonChoice1 = vgui.Create("DButton", RWCInfoMenuChoice)
	RWCInfoFrameButtonChoice1:SetSize((ScrW()*0.275)/2, ScrH()*0.05)
	RWCInfoFrameButtonChoice1:SetPos(ScrW()*0.013, ScrH()*0.002)
	RWCInfoFrameButtonChoice1:SetFont("rwc_font_3")
	RWCInfoFrameButtonChoice1:SetText(Realistic_Woodcutter.GetSentence("plank"))
	RWCInfoFrameButtonChoice1:SetTextColor( Realistic_Woodcutter.Colors["white"] )
	RWCInfoFrameButtonChoice1.Paint = function(self,w,h)
		draw.RoundedBox(0,2,2,w-4,h-4,Realistic_Woodcutter.Colors["darkblue"])
		surface.SetDrawColor(Realistic_Woodcutter.Colors["darkblue"])
		surface.DrawOutlinedRect( 0, 0, w,h )
	end
	RWCInfoFrameButtonChoice1.DoClick = function(self,w,h)
		surface.PlaySound( "UI/buttonclick.wav" )
		rwc_id_info = rwc_id_info + 1
		RWCInfoMenuChoice:SetPos(0, ScrH()*0.54)
	end 

	local RWCInfoFrameButtonChoice2 = vgui.Create("DButton", RWCInfoMenuChoice)
	RWCInfoFrameButtonChoice2:SetSize( (ScrW()*0.282)/2, ScrH()*0.05 )
	RWCInfoFrameButtonChoice2:SetPos(ScrW()*0.013 + (ScrW()*0.282)/2, ScrH()*0.002)
	RWCInfoFrameButtonChoice2:SetFont("rwc_font_3")
	RWCInfoFrameButtonChoice2:SetText(Realistic_Woodcutter.GetSentence("cutLog"))
	RWCInfoFrameButtonChoice2:SetTextColor( Realistic_Woodcutter.Colors["white"] )
	RWCInfoFrameButtonChoice2.Paint = function(self,w,h)
		draw.RoundedBox(0,2,2,w-4,h-4,Realistic_Woodcutter.Colors["darkblue"])
		surface.SetDrawColor(Realistic_Woodcutter.Colors["darkblue"])
		surface.DrawOutlinedRect( 0, 0, w,h )
	end 
	RWCInfoFrameButtonChoice2.DoClick = function(self,w,h)
		surface.PlaySound( "UI/buttonclick.wav" )
		rwc_id_info = rwc_id_info + 5
		RWCInfoMenuChoice:SetPos(0, ScrH()*0.54)
	end 
	RWCInfoFrameButton.DoClick = function() 
		surface.PlaySound( "UI/buttonclick.wav" )
		if rwc_id_info == 10 then 
			RWCInfoMenu:SlideUp(0.7) 
		elseif rwc_id_info == 14 then 
			RWCInfoMenu:SlideUp(0.7)
		else 
			rwc_id_info = rwc_id_info + 1
			if rwc_id_info == 6 then 
				RWCInfoMenuChoice:MoveTo(0, ScrH()*0.465, 0, 0.1)
			elseif rwc_id_info == 10 then 
				RWCInfoFrameButton:SetText(Realistic_Woodcutter.GetSentence("finishTutorial"))
			elseif rwc_id_info != 10 and rwc_id_info != 14 then 
				RWCInfoFrameButton:SetText(Realistic_Woodcutter.GetSentence("nextStep"))
			elseif rwc_id_info == 14 then 
				RWCInfoFrameButton:SetText(Realistic_Woodcutter.GetSentence("finishTutorial"))
			end 
		end 
	end 
	RWCInfoFrameButton.Paint = function(self,w,h)
		if self:IsHovered() then		
			draw.RoundedBox(0,2,2,w-4,h-4,Realistic_Woodcutter.Colors["darkblueopac"])
			surface.SetDrawColor(Realistic_Woodcutter.Colors["darkblue"])
			surface.DrawOutlinedRect( 0, 0, w,h )
		else
			draw.RoundedBox(0,2,2,w-4,h-4,Realistic_Woodcutter.Colors["darkblue"])
			surface.SetDrawColor(Realistic_Woodcutter.Colors["darkblue"])
			surface.DrawOutlinedRect( 0, 0, w,h )
		end 
	end  
end
net.Receive("RealisticWoodCutter:MenuInfoOpen", Realistic_Woodcutter.Info)