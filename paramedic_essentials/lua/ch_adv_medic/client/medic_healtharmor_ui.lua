local mat_healtharmor_npc = Material( "craphead_scripts/medic_ui/healtharmor_ui.png" )
local mat_close_btn = Material( "craphead_scripts/medic_ui/close.png" )

net.Receive( "ADV_MEDIC_HealthMenu", function()
	local GUI_Health_Frame = vgui.Create("DFrame")
	GUI_Health_Frame:SetTitle("")
	GUI_Health_Frame:SetSize( ScrW() * 0.49325, ScrH() * 0.27875 )
	GUI_Health_Frame:Center()
	GUI_Health_Frame.Paint = function( self )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( mat_healtharmor_npc )
		surface.DrawTexturedRect( 0, 0, ScrW() * 0.49325, ScrH() * 0.27875 )
		-- Draw the top title.
		draw.SimpleText( CH_AdvMedic.Config.Lang["Hospital"][CH_AdvMedic.Config.Language], "MEDIC_UIFontTitle", ScrW() * 0.04, ScrH() * 0.013, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
		
		draw.SimpleText( CH_AdvMedic.Config.Lang["Hey there,"][CH_AdvMedic.Config.Language], "MEDIC_UIText", ScrW() * 0.018, ScrH() * 0.075, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
		draw.SimpleText( CH_AdvMedic.Config.Lang["If you are hurt I can help patch you up."][CH_AdvMedic.Config.Language], "MEDIC_UIText", ScrW() * 0.018, ScrH() * 0.105, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
		draw.SimpleText( CH_AdvMedic.Config.Lang["Just let me know which type of healing you need."][CH_AdvMedic.Config.Language], "MEDIC_UIText", ScrW() * 0.018, ScrH() * 0.135, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
	end
	GUI_Health_Frame:MakePopup()
	GUI_Health_Frame:ShowCloseButton( false )
	
	local GUI_Main_Exit = vgui.Create( "DButton", GUI_Health_Frame )
	GUI_Main_Exit:SetSize( 16, 16 )
	GUI_Main_Exit:SetPos( GUI_Health_Frame:GetWide() - 27.5, 10 )
	GUI_Main_Exit:SetText( "" )
	GUI_Main_Exit.Paint = function()
		surface.SetMaterial( mat_close_btn )
		surface.SetDrawColor( color_white )
		surface.DrawTexturedRect( 0, 0, GUI_Main_Exit:GetWide(), GUI_Main_Exit:GetTall() )
	end
	GUI_Main_Exit.DoClick = function()
		GUI_Health_Frame:Remove()
	end	

	local GUI_PurchaseHealth = vgui.Create("DButton", GUI_Health_Frame)	
	GUI_PurchaseHealth:SetSize( ScreenScale( 51 ), ScreenScale( 18 ) )
	GUI_PurchaseHealth:SetPos( ScreenScale( 199.5 ), ScreenScale( 72 ) )
	GUI_PurchaseHealth:SetText("")
	GUI_PurchaseHealth.Paint = function()
		draw.SimpleText( CH_AdvMedic.Config.Lang["Purchase Health"][CH_AdvMedic.Config.Language], "MEDIC_UIText", ScreenScale( 25.5 ), ScreenScale( 7 ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( CH_AdvMedic.Config.Lang["Price:"][CH_AdvMedic.Config.Language] .." ".. DarkRP.formatMoney( CH_AdvMedic.Config.HealthPrice ), "MEDIC_UITextSmall", ScreenScale( 25.5 ), ScreenScale( 13 ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	GUI_PurchaseHealth.DoClick = function()
		net.Start("ADV_MEDIC_PurchaseHealth")
		net.SendToServer()
		
		GUI_Health_Frame:Remove()
	end
	
	local GUI_PurchaseArmor = vgui.Create("DButton", GUI_Health_Frame)	
	GUI_PurchaseArmor:SetSize( ScreenScale( 51.5 ), ScreenScale( 18 ) )
	GUI_PurchaseArmor:SetPos( ScreenScale( 254.5 ), ScreenScale( 72 ) )
	GUI_PurchaseArmor:SetText("")
	GUI_PurchaseArmor.Paint = function()
		draw.SimpleText( CH_AdvMedic.Config.Lang["Purchase Armor"][CH_AdvMedic.Config.Language], "MEDIC_UIText", ScreenScale( 26 ), ScreenScale( 7 ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( CH_AdvMedic.Config.Lang["Price:"][CH_AdvMedic.Config.Language] .." ".. DarkRP.formatMoney( CH_AdvMedic.Config.ArmorPrice ), "MEDIC_UITextSmall", ScreenScale( 26 ), ScreenScale( 13 ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	GUI_PurchaseArmor.DoClick = function()
		net.Start("ADV_MEDIC_PurchaseArmor")
		net.SendToServer()
		
		GUI_Health_Frame:Remove()
	end
end)