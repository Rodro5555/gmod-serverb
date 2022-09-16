--[[-------------------------------------------------------------------------
	Icons and Logos Configuration
---------------------------------------------------------------------------]]
EmergencyDispatch.NotificationLogo 		= Material( "materials/emergencyresponse_fleodon/notif_logo.png" ) 		--> Notification icon that appears on your top-left side of your screen.
EmergencyDispatch.CloseMenuIcon         = Material( "materials/emergencyresponse_fleodon/cross.png" )           --> The close button icon used to close the menus.
EmergencyDispatch.MenuSendCallout 		= "materials/emergencyresponse_fleodon/send_callout_phone.png" 		    --> Button icon in the victim menu to send the callout.
EmergencyDispatch.DispatchLogo 			= "materials/emergencyresponse_fleodon/logo_911dispatch.png" 		    --> Icon when the cops/ems/firefighters get an emergency call.

EmergencyDispatch.WalkieTalkieIcon 		= "materials/emergencyresponse_fleodon/walkie-talkie.png" 			    --> WalkieTalkie icon.

EmergencyDispatch.gpsPoliceLogo 		= "materials/emergencyresponse_fleodon/gps_alert.png"                   --> Law Enforcement GPS icon.
EmergencyDispatch.gpsEMSLogo 			= "materials/emergencyresponse_fleodon/gps_points/medical.png"          --> Medical Services GPS icon.
EmergencyDispatch.gpsFirefightersLogo 	= "materials/emergencyresponse_fleodon/gps_points/firefighters.png" 	--> Firefighters Services Icon.

EmergencyDispatch.PhoneMaterial 		= "materials/emergencyresponse_fleodon/fleodon_phone.png"    		    --> Material of the fake phone that appears in the middle bottom of your screen.

EmergencyDispatch.IconPolice            = "materials/emergencyresponse_fleodon/icon_police.png"
EmergencyDispatch.IconEMS               = "materials/emergencyresponse_fleodon/icon_doctor.png"
EmergencyDispatch.IconFire              = "materials/emergencyresponse_fleodon/icon_fireman.png"

EmergencyDispatch.IconSend              = "materials/emergencyresponse_fleodon/send_callout_phone.png"
EmergencyDispatch.IconCancel            = "materials/emergencyresponse_fleodon/frame_cancel.png"

EmergencyDispatch.IconGPSAccept         = "materials/emergencyresponse_fleodon/btn_accept.png"
EmergencyDispatch.IconGPSRemove         = "materials/emergencyresponse_fleodon/btn_takeout.png"

--[[-------------------------------------------------------------------------
    Sounds Configuration
    -> Write "false" below, if you do not want ambiance sounds.
---------------------------------------------------------------------------]]
EmergencyDispatch.SoundConfiguration                = true

EmergencyDispatch.FramesTransitionSound 			= "garrysmod/balloon_pop_cute.wav"
EmergencyDispatch.CalloutRemove 					= "emergencyresponse/callouts/recept/notif_06.wav"
EmergencyDispatch.RadioButtonScroll 				= "emergencyresponse/callouts/buttons/radioscroll.wav"
EmergencyDispatch.ActivatingPanicButton 			= "emergencyresponse/callouts/panic/panic_01.wav"
EmergencyDispatch.OfficersVoicePanic 				= "emergencyresponse/callouts/panic/officerpanic_01.wav"
EmergencyDispatch.OfficerNeedAssistanceCallout 		= "emergencyresponse/callouts/recept/notif_05.wav"
EmergencyDispatch.VehiclePanicButtonBipsSounds      = "emergencyresponse/callouts/panic/panic_02.wav"
EmergencyDispatch.UIButtonSound                     = "emergencyresponse/callouts/buttons/blip.wav"

EmergencyDispatch.Sound.CalloutClaim = {
    "emergencyresponse/callouts/recept/notif_02.wav",
    "emergencyresponse/callouts/recept/notif_06.wav",
    "emergencyresponse/callouts/recept/notif_08.wav"
}

EmergencyDispatch.Sound.CalloutReceptList = {
    "emergencyresponse/callouts/recept/notif_01.wav",
    "emergencyresponse/callouts/recept/notif_03.wav",
    "emergencyresponse/callouts/recept/notif_07.wav",
    "emergencyresponse/callouts/recept/notif_08.wav",
    "emergencyresponse/callouts/recept/notif_09.wav",
    "emergencyresponse/callouts/recept/notif_10.wav"
}


--[[-------------------------------------------------------------------------
    Colors Configuration
---------------------------------------------------------------------------]]
-- Background color of the menu that appears when you call "/911".
EmergencyDispatch.ColorsConfiguration.PlayerMenu = Color( 26, 26, 26 )
EmergencyDispatch.ColorsConfiguration.PlayerMenu_Blur = Color( 0, 0, 0, 248 )

-- Topside-bar color of the menu. 
EmergencyDispatch.ColorsConfiguration.PlayerMenu_TopBar = Color( 155, 26, 26 )

-- Slide buttons color of the menu. (Police/EMS/Firefighters)
EmergencyDispatch.ColorsConfiguration.PlayerMenu_Buttons = Color( 203, 40, 40 )

-- Slide buttons background color of the menu.
EmergencyDispatch.ColorsConfiguration.PlayerMenu_ButtonsBackground = Color( 255, 255, 255, 1 )
EmergencyDispatch.ColorsConfiguration.PlayerMenu_ButtonsBackground_Blur = Color( 185, 185, 185, 5 )
EmergencyDispatch.ColorsConfiguration.PlayerMenu_ButtonsBackground_Blur2 = Color( 185, 185, 185, 3 )

EmergencyDispatch.ColorsConfiguration.CloseButton = Color( 255, 255, 255 )
EmergencyDispatch.ColorsConfiguration.CloseButtonHover = Color( 181, 181, 181 )

EmergencyDispatch.ColorsConfiguration.TextEntryColor = Color( 255, 255, 255, 200 )
EmergencyDispatch.ColorsConfiguration.TextEntryBackroundColor = Color( 71, 73, 78 )

EmergencyDispatch.ColorsConfiguration.TitlesMenusColors = Color( 255, 255, 255 )

EmergencyDispatch.ColorsConfiguration.RespondTicketBarColor = Color( 155, 26, 26 )
EmergencyDispatch.ColorsConfiguration.RespondOfficerTicketBarColor = Color( 0, 110, 255 )
EmergencyDispatch.ColorsConfiguration.RespondTicketBackgroundColor = Color( 40, 36, 36, 230 )

EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBarColor = Color( 0, 110, 255 )
EmergencyDispatch.ColorsConfiguration.TraficPolicerButtonHover = Color( 255, 255, 255, 10 )
EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBackground = Color( 0, 0, 0, 225 )
EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBackground2 = Color( 0, 0, 0, 240 )
EmergencyDispatch.ColorsConfiguration.TraficPolicerMenuBackgroundTransparent = Color( 0, 0, 0, 0 )

EmergencyDispatch.ColorsConfiguration.HoveringButton = Color( 157, 36, 36 )