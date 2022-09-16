--[[

 _____           _ _     _   _          _    _                 _            _   _            
| ___ \         | (_)   | | (_)        | |  | |               | |          | | | |           
| |_/ /___  __ _| |_ ___| |_ _  ___    | |  | | ___   ___   __| | ___ _   _| |_| |_ ___ _ __ 
|    // _ \/ _` | | / __| __| |/ __|   | |/\| |/ _ \ / _ \ / _` |/ __| | | | __| __/ _ \ '__|
| |\ \  __/ (_| | | \__ \ |_| | (__    \  /\  / (_) | (_) | (_| | (__| |_| | |_| ||  __/ |   
\_| \_\___|\__,_|_|_|___/\__|_|\___|    \/  \/ \___/ \___/ \__,_|\___|\__,_|\__|\__\___|_|   


--]]

function Realistic_Woodcutter.Npc()	
	rwc_id_seller = 1 
	if IsValid(RWCPNJMenu) then return end
	if Realistic_Woodcutter.JobTable[team.GetName(LocalPlayer():Team())] then  
		RWCPNJMenu = vgui.Create( "DFrame" )
		RWCPNJMenu:SetSize( ScrW()*0.25, ScrH()*0.56 )
		RWCPNJMenu:SetTitle( "" )
		RWCPNJMenu:SetDraggable(false)
		RWCPNJMenu:ShowCloseButton(false)
		RWCPNJMenu:Center()
		RWCPNJMenu:SlideDown(0.7)
		RWCPNJMenu:MakePopup()
		function RWCPNJMenu:Paint( w, h )
			draw.RoundedBox(0, ScrW()*0, ScrH()*0, w, h, Realistic_Woodcutter.Colors["lightblue"])
			draw.RoundedBox(0,ScrW()*0,ScrH()*0,w,ScrH()*0.06,Realistic_Woodcutter.Colors["darkblue"])
			draw.DrawText(Realistic_Woodcutter.TextTopAxe, "rwc_font_5", RWCPNJMenu:GetWide()/2, ScrH()*0.006, Realistic_Woodcutter.Colors["white"], TEXT_ALIGN_CENTER)	
			draw.RoundedBox(0,ScrW()*0,ScrH()*0.06,w,ScrH()*0.0023,Realistic_Woodcutter.Colors["gray"])
			surface.SetDrawColor(Realistic_Woodcutter.Colors["darkblue"])
			surface.DrawOutlinedRect( 0, 0, w,h )
		end	
		local ButtonCLose = vgui.Create("DButton", RWCPNJMenu)
		ButtonCLose:SetSize(ScrW()*0.020, ScrH()*0.026)
		ButtonCLose:SetPos(RWCPNJMenu:GetWide()*0.89, ScrH()*0.0139)
		ButtonCLose:SetText(" X") 
		ButtonCLose:SetFont("rwc_font_6")
		ButtonCLose:SetTextColor( Realistic_Woodcutter.Colors["white"] )
		ButtonCLose.DoClick = function()
		RWCPNJMenu:SlideUp(0.7)
			timer.Simple(0.7, function()
			RWCPNJMenu:Remove()
			end)
		end 

		ButtonCLose.Paint = function() end 
		local RWCAxeModel = vgui.Create( "DModelPanel", RWCPNJMenu  )
		RWCAxeModel:SetPos(  ScrW() * 0.075, ScrH() * 0.06 )
		RWCAxeModel:SetSize( ScrW() * 0.120, ScrH() * 0.400 )
		RWCAxeModel:SetFOV( 1.4 )
		RWCAxeModel:SetCamPos( Vector( 250, 700, 45 ) )
    	RWCAxeModel:SetLookAt( Vector( 2, 0, 15 ) )
    	RWCAxeModel:SetModel( "models/wasted/wasted_uniserv_axe_w.mdl" ) 
		function RWCAxeModel:LayoutEntity( ent ) end
		local RWCPnjButtonAccept = vgui.Create( "DButton", RWCPNJMenu)
		RWCPnjButtonAccept:SetPos(ScrW()*0.04, ScrH()*0.46)
		RWCPnjButtonAccept:SetSize( ScrW()*0.18, ScrH()*0.08 )
		RWCPnjButtonAccept:SetText("")
		RWCPnjButtonAccept.Paint = function(self,w,h)
			if self:IsHovered() then		
				draw.RoundedBox(0,2,2,w-4,h-4,Realistic_Woodcutter.Colors["darkblueopac"])
				surface.SetDrawColor(Realistic_Woodcutter.Colors["darkblue"])
				surface.DrawOutlinedRect( 0, 0, w,h )
			else
				draw.RoundedBox(0,2,2,w-4,h-4,Realistic_Woodcutter.Colors["darkblue"])
				surface.SetDrawColor(Realistic_Woodcutter.Colors["darkblue"])
				surface.DrawOutlinedRect( 0, 0, w,h )
			end 
				draw.SimpleText(Realistic_Woodcutter.GetSentence("buy").." "..Realistic_Woodcutter.GetSentence("for").." "..DarkRP.formatMoney(Realistic_Woodcutter.PnjSeller[rwc_id_seller]["price"]),"rwc_font_6",RWCPnjButtonAccept:GetWide()/2,h/2,Realistic_Woodcutter.Colors["white"],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			end
			RWCPnjButtonAccept.DoClick = function()
				surface.PlaySound( "UI/buttonclick.wav" )
				net.Start("RealisticWoodCutter:NPC")
				net.WriteInt(rwc_id_seller, 8)
				net.SendToServer()
			RWCPNJMenu:SlideUp(0.7)
			timer.Simple(0.7, function() 
				RWCPNJMenu:Remove()
			end )	
		end
		if Realistic_Woodcutter.ActivateChainSaw then 
		    local RwcButtonBefore = vgui.Create("DButton", RWCPNJMenu) 
			RwcButtonBefore:SetSize(ScrW()*0.020, ScrH()*0.026)
			RwcButtonBefore:SetPos(RWCPNJMenu:GetWide()*0.05, ScrH()*0.25)
			RwcButtonBefore:SetText("◄")
			RwcButtonBefore:SetFont("rwc_font_6")
			RwcButtonBefore:SetTextColor( Realistic_Woodcutter.Colors["white"] )
			RwcButtonBefore.Paint = function() end 
			RwcButtonBefore.DoClick = function()
				if rwc_id_seller == 1 then 
					rwc_id_seller = 2
					RWCAxeModel:SetModel( Realistic_Woodcutter.PnjSeller[rwc_id_seller]["model"] ) 
					RWCAxeModel:SetCamPos( Vector( 1200, 800, 200 ) )
	    			RWCAxeModel:SetLookAt( Vector( 10, 0, 0 ) )
				elseif rwc_id_seller == 2 then 
					rwc_id_seller = 1 
					RWCAxeModel:SetModel( "models/wasted/wasted_uniserv_axe_w.mdl" )
					RWCAxeModel:SetCamPos( Vector( 310, 700, 45 ) )
	    			RWCAxeModel:SetLookAt( Vector( 0, 0, 15 ) )
				end  
			end 

			local RwcButtonNext = vgui.Create("DButton", RWCPNJMenu) 
			RwcButtonNext:SetSize(ScrW()*0.020, ScrH()*0.026)
			RwcButtonNext:SetPos(RWCPNJMenu:GetWide()*0.89, ScrH()*0.25)
			RwcButtonNext:SetText(" ►")
			RwcButtonNext:SetFont("rwc_font_6")
			RwcButtonNext:SetTextColor( Realistic_Woodcutter.Colors["white"] )
			RwcButtonNext.Paint = function() end 
			RwcButtonNext.DoClick = function()
				if rwc_id_seller == 1 then 
					rwc_id_seller = 2
					RWCAxeModel:SetModel( Realistic_Woodcutter.PnjSeller[rwc_id_seller]["model"] ) 
					RWCAxeModel:SetCamPos( Vector( 1200, 800, 200 ) )
	    			RWCAxeModel:SetLookAt( Vector( 10, 0, 0 ) )
				elseif rwc_id_seller == 2 then 
					rwc_id_seller = 1 
					RWCAxeModel:SetModel( "models/wasted/wasted_uniserv_axe_w.mdl" )
					RWCAxeModel:SetCamPos( Vector( 310, 700, 45 ) )
	    			RWCAxeModel:SetLookAt( Vector( 0, 0, 15 ) )
				end  
			end 
		end 
	end  
end
net.Receive("RealisticWoodCutter:NPC", Realistic_Woodcutter.Npc) 