local mat_ambulance_npc = Material( "craphead_scripts/medic_ui/ambulance_ui.png" )
local mat_close_btn = Material( "craphead_scripts/medic_ui/close.png" )

net.Receive( "ADV_MEDIC_AmbulanceMenu", function()
	local GUI_AmbulanceNPC_Frame = vgui.Create( "DFrame" )
	GUI_AmbulanceNPC_Frame:SetTitle("")
	GUI_AmbulanceNPC_Frame:SetSize( ScrW() * 0.49325, ScrH() * 0.27875 )
	GUI_AmbulanceNPC_Frame:Center()
	GUI_AmbulanceNPC_Frame.Paint = function( self, w, h )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( mat_ambulance_npc )
		surface.DrawTexturedRect( 0, 0, ScrW() * 0.49325, ScrH() * 0.27875 )
		-- Draw the top title.
		draw.SimpleText( CH_AdvMedic.Config.Lang["Ambulance Station"][CH_AdvMedic.Config.Language], "MEDIC_UIFontTitle", ScrW() * 0.04, ScrH() * 0.013, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
		
		draw.SimpleText( CH_AdvMedic.Config.Lang["As a paramedic you can retrieve an ambulance from this NPC."][CH_AdvMedic.Config.Language], "MEDIC_UIText", ScrW() * 0.018, ScrH() * 0.075, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
		draw.SimpleText( CH_AdvMedic.Config.Lang["Use it to quickly get to people who need to be healed."][CH_AdvMedic.Config.Language], "MEDIC_UIText", ScrW() * 0.018, ScrH() * 0.105, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
		draw.SimpleText( CH_AdvMedic.Config.Lang["You are equipped with a medkit."][CH_AdvMedic.Config.Language], "MEDIC_UIText", ScrW() * 0.018, ScrH() * 0.135, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
	end
	GUI_AmbulanceNPC_Frame:MakePopup()
	GUI_AmbulanceNPC_Frame:ShowCloseButton( false )
	
	local GUI_Main_Exit = vgui.Create("DButton", GUI_AmbulanceNPC_Frame)
	GUI_Main_Exit:SetSize( 16, 16 )
	GUI_Main_Exit:SetPos( GUI_AmbulanceNPC_Frame:GetWide() - 27.5, 10 )
	GUI_Main_Exit:SetText( "" )
	GUI_Main_Exit.Paint = function( self, w, h )
		surface.SetMaterial( mat_close_btn )
		surface.SetDrawColor( color_white )
		surface.DrawTexturedRect( 0, 0, w, h )
	end
	GUI_Main_Exit.DoClick = function()
		GUI_AmbulanceNPC_Frame:Remove()
	end
	
	local VehIcon = vgui.Create( "DModelPanel", GUI_AmbulanceNPC_Frame )
	VehIcon:SetPos( -30, ScreenScale( 2.5 ) )
	VehIcon:SetSize( ScreenScale( 110 ), ScreenScale( 150 ) )
	VehIcon:SetModel( CH_AdvMedic.Config.VehicleModel )
	VehIcon:GetEntity():SetAngles( Angle( -15, 30, 5 ) )
	
	local mn, mx = VehIcon.Entity:GetRenderBounds()
	local size = 0
	
	size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
	size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
	size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )
	
	VehIcon:SetFOV( 55 )
	VehIcon:SetCamPos( Vector( size, size, size ) )
	VehIcon:SetLookAt( (mn + mx) * 0.5 )
	function VehIcon:LayoutEntity( Entity ) return end
	
	local VehRetrieveTruck = vgui.Create( "DButton", GUI_AmbulanceNPC_Frame )
	VehRetrieveTruck:SetPos( ScreenScale( 216 ), ScreenScale( 72 ) )
	VehRetrieveTruck:SetSize( ScreenScale( 43 ), ScreenScale( 18 ) )
	VehRetrieveTruck:SetToolTip( CH_AdvMedic.Config.Lang["Click here to retrieve an ambulance."][CH_AdvMedic.Config.Language] )
	VehRetrieveTruck:SetText( "" )
	VehRetrieveTruck.Paint = function( self, w, h )
		draw.SimpleText( CH_AdvMedic.Config.Lang["Retrieve"][CH_AdvMedic.Config.Language], "MEDIC_UIText", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	VehRetrieveTruck.DoClick = function()
		net.Start("ADV_MEDIC_CreateAmbulance")
		net.SendToServer()
		
		GUI_AmbulanceNPC_Frame:Remove()
	end

	local VehRemoveTruck = vgui.Create( "DButton", GUI_AmbulanceNPC_Frame )
	VehRemoveTruck:SetPos( ScreenScale( 262 ), ScreenScale( 72 ) )
	VehRemoveTruck:SetSize( ScreenScale( 43 ), ScreenScale( 18 ) )
	VehRemoveTruck:SetToolTip( CH_AdvMedic.Config.Lang["Click here to remove your current ambulance."][CH_AdvMedic.Config.Language] )
	VehRemoveTruck:SetText("")
	VehRemoveTruck.Paint = function( self, w, h )
		draw.SimpleText( CH_AdvMedic.Config.Lang["Remove"][CH_AdvMedic.Config.Language], "MEDIC_UIText", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	VehRemoveTruck.DoClick = function()
		net.Start("ADV_MEDIC_RemoveAmbulance")
		net.SendToServer()
		
		GUI_AmbulanceNPC_Frame:Remove()
	end
end )