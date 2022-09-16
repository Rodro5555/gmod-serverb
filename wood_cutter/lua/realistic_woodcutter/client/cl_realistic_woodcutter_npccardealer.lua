--[[

 _____           _ _     _   _          _    _                 _            _   _            
| ___ \         | (_)   | | (_)        | |  | |               | |          | | | |           
| |_/ /___  __ _| |_ ___| |_ _  ___    | |  | | ___   ___   __| | ___ _   _| |_| |_ ___ _ __ 
|    // _ \/ _` | | / __| __| |/ __|   | |/\| |/ _ \ / _ \ / _` |/ __| | | | __| __/ _ \ '__|
| |\ \  __/ (_| | | \__ \ |_| | (__    \  /\  / (_) | (_) | (_| | (__| |_| | |_| ||  __/ |   
\_| \_\___|\__,_|_|_|___/\__|_|\___|    \/  \/ \___/ \___/ \__,_|\___|\__,_|\__|\__\___|_|   


--]]

function Realistic_Woodcutter.CarDealer(bool, Table)
	if IsValid(RWCFrame) then return end
	if #Table == 0 then return end 
	if Realistic_Woodcutter.JobTable[team.GetName(LocalPlayer():Team())] then  
		local id = 1 
		local ply = LocalPlayer()
		RWCFrame = vgui.Create("DFrame")
		RWCFrame:SetSize(ScrW()*0.40,ScrH()*0.45)
		RWCFrame:Center()
		RWCFrame:ShowCloseButton(false)
		RWCFrame:SetDraggable(false)
		RWCFrame:SetTitle(" ")
		RWCFrame:MakePopup()
		RWCFrame:SlideDown(0.7)
		RWCFrame.Paint = function(s,w,h)
			draw.RoundedBox(0, ScrW()*0, ScrH()*0, w, h, Realistic_Woodcutter.Colors["lightblue"])
			draw.RoundedBox(0,ScrW()*0,ScrH()*0,w,ScrH()*0.06,Realistic_Woodcutter.Colors["darkblueopac"])
			draw.SimpleText(Realistic_Woodcutter.TextTopCarDealer,"rwc_font_5",RWCFrame:GetWide()/2,ScrH()*0.03,Realistic_Woodcutter.Colors["white"],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.RoundedBox(0,ScrW()*0,ScrH()*0.06,w,ScrH()*0.0023,Realistic_Woodcutter.Colors["gray"])
		end	

		local ButtonCLose = vgui.Create("DButton", RWCFrame)
		ButtonCLose:SetSize(ScrW()*0.020, ScrH()*0.03)
		ButtonCLose:SetPos(RWCFrame:GetWide()*0.93, ScrH()*0.0139)
		ButtonCLose:SetText(" X") 
		ButtonCLose:SetFont("rwc_font_6")
		ButtonCLose:SetTextColor( Realistic_Woodcutter.Colors["white"] )
		ButtonCLose.DoClick = function()
			RWCFrame:SlideUp(0.7)
			timer.Simple(0.7, function()
				RWCFrame:Remove()
			end)
		end 
		ButtonCLose.Paint = function() end 

		local ButtonLeft = vgui.Create("DButton", RWCFrame)
		ButtonLeft:SetSize(ScrW()*0.020, ScrH()*0.03)
		ButtonLeft:SetPos(RWCFrame:GetWide()*0.03,ScrH()*0.2) 
		ButtonLeft:SetText("◄") 
		ButtonLeft:SetFont("rwc_font_6")
		ButtonLeft:SetTextColor( Realistic_Woodcutter.Colors["white"] )
		ButtonLeft.Paint = function() end 
		ButtonLeft.DoClick = function()
			if id != 1 then 
				id = id - 1 
				RWCCarModel:SetModel( Table[id]["Models"] )
			else 
				id = #Table
				RWCCarModel:SetModel( Table[id]["Models"] )
			end 
		end 

		local ButtonRight = vgui.Create("DButton", RWCFrame)
		ButtonRight:SetSize(ScrW()*0.020, ScrH()*0.03)
		ButtonRight:SetPos(RWCFrame:GetWide()*0.92,ScrH()*0.2) 
		ButtonRight:SetText("►") 
		ButtonRight:SetFont("rwc_font_6")
		ButtonRight:SetTextColor( Realistic_Woodcutter.Colors["white"] )
		ButtonRight.Paint = function() end 
		ButtonRight.DoClick = function()
			if id != #Table then 
				id = id + 1 
				RWCCarModel:SetModel( Table[id]["Models"] )
			else 
				id = 1
				RWCCarModel:SetModel( Table[id]["Models"] )
			end 
		end 

		RWCCarModel = vgui.Create( "SpawnIcon", RWCFrame )
		RWCCarModel:SetPos( ScrW()*0.01, ScrH()*0.05 )
		RWCCarModel:SetSize( ScrH()*0.7, ScrH()*0.4 )
		RWCCarModel:SetModel( Table[id]["Models"] )
		function RWCCarModel:LayoutEntity( ent ) end
		RWCCarModel:SetMouseInputEnabled( false )
		RWCCarModel:SetKeyboardInputEnabled( false )

		local RWCNpcButton = vgui.Create("DButton", RWCFrame)
		RWCNpcButton:SetSize(ScrW()*0.397,ScrH()*0.065)
		RWCNpcButton:SetPos( ScrW()*0.002, ScrH()*0.38)
		RWCNpcButton:SetText("")
		RWCNpcButton.DoClick = function()
			surface.PlaySound( "UI/buttonclick.wav" )
			net.Start("RealisticWoodCutter:CarDealer")
				net.WriteString(Table[id]["Models"])
			net.SendToServer()
			RWCFrame:SlideUp(0.7)
			timer.Simple(0.7, function()
				RWCFrame:Remove()
			end)
		end
		local rwc_text 
		if bool == true then
			rwc_text = Realistic_Woodcutter.GetSentence("returnVehicle")
		else
			rwc_text = Realistic_Woodcutter.GetSentence("exitVehicle")
		end
		RWCNpcButton.Paint = function(self,w,h)
			if self:IsHovered() then		
				draw.RoundedBox(0,2,2,w-4,h-4,Realistic_Woodcutter.Colors["darkblueopac"])
				surface.SetDrawColor(Realistic_Woodcutter.Colors["darkblue"])
				surface.DrawOutlinedRect( 0, 0, w,h )
			else
				draw.RoundedBox(0,2,2,w-4,h-4,Realistic_Woodcutter.Colors["darkblue"])
				surface.SetDrawColor(Realistic_Woodcutter.Colors["darkblue"])
				surface.DrawOutlinedRect( 0, 0, w,h )
			end 
			draw.SimpleText(rwc_text,"rwc_font_2",RWCNpcButton:GetWide()/2,h/2,Realistic_Woodcutter.Colors["white"],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	end 
end

net.Receive("RealisticWoodCutter:CarDealer",function()
	local bool = net.ReadBool() or nil 
	local Table = net.ReadTable() or {}
	Realistic_Woodcutter.CarDealer(bool,Table)
end)



