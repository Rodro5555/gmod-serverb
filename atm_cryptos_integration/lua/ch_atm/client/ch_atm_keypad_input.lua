--[[
	Allow the player to use keyboard for input when keypad is active
--]]

function CH_ATM.EnableKeyboardInputForKeypad()
	if not CH_ATM.Config.AllowKeyboardInputForKeypad then
		return
	end
	
	local ply = LocalPlayer()
	local cur_time = CurTime()
	local delay = 0.2
	local atm = ply.CH_ATM_IsActivelyUsingATM
	
	-- Check if the localplayer is on an ATM
	if not IsValid( atm ) then
		return
	end
	
	-- Check that the keypad is active on ATM
	if not atm.KEYPAD_CurrentScreen or atm.KEYPAD_CurrentScreen == "none" then
		return
	end
	
	-- Check if the cooldown is active
	if ( ply.CH_ATM_LastKeypadInput or cur_time ) > cur_time then
		return
	end
	
	-- All checks out lets see which buttons they press!
	if input.IsKeyDown( KEY_0 ) or input.IsKeyDown( KEY_PAD_0 ) then
		ply.CH_ATM_LastKeypadInput = cur_time + delay

		atm:KEYPAD_AcceptInput( "0" )
	elseif input.IsKeyDown( KEY_1 ) or input.IsKeyDown( KEY_PAD_1 ) then
		ply.CH_ATM_LastKeypadInput = cur_time + delay
		
		atm:KEYPAD_AcceptInput( "1" )
	elseif input.IsKeyDown( KEY_2 ) or input.IsKeyDown( KEY_PAD_2 ) then
		ply.CH_ATM_LastKeypadInput = cur_time + delay
		
		atm:KEYPAD_AcceptInput( "2" )
	elseif input.IsKeyDown( KEY_3 ) or input.IsKeyDown( KEY_PAD_3 ) then
		ply.CH_ATM_LastKeypadInput = cur_time + delay
		
		atm:KEYPAD_AcceptInput( "3" )
	elseif input.IsKeyDown( KEY_4 ) or input.IsKeyDown( KEY_PAD_4 ) then
		ply.CH_ATM_LastKeypadInput = cur_time + delay
		
		atm:KEYPAD_AcceptInput( "4" )
	elseif input.IsKeyDown( KEY_5 ) or input.IsKeyDown( KEY_PAD_5 ) then
		ply.CH_ATM_LastKeypadInput = cur_time + delay
		
		atm:KEYPAD_AcceptInput( "5" )
	elseif input.IsKeyDown( KEY_6 ) or input.IsKeyDown( KEY_PAD_6 ) then
		ply.CH_ATM_LastKeypadInput = cur_time + delay
		
		atm:KEYPAD_AcceptInput( "6" )
	elseif input.IsKeyDown( KEY_7 ) or input.IsKeyDown( KEY_PAD_7 ) then
		ply.CH_ATM_LastKeypadInput = cur_time + delay
		
		atm:KEYPAD_AcceptInput( "7" )
	elseif input.IsKeyDown( KEY_8 ) or input.IsKeyDown( KEY_PAD_8 ) then
		ply.CH_ATM_LastKeypadInput = cur_time + delay
		
		atm:KEYPAD_AcceptInput( "8" )
	elseif input.IsKeyDown( KEY_9 ) or input.IsKeyDown( KEY_PAD_9 ) then
		ply.CH_ATM_LastKeypadInput = cur_time + delay
		
		atm:KEYPAD_AcceptInput( "9" )
	elseif input.IsKeyDown( KEY_PERIOD ) or input.IsKeyDown( KEY_PAD_DECIMAL ) then
		ply.CH_ATM_LastKeypadInput = cur_time + delay
		
		atm:KEYPAD_AcceptInput( "." )
	elseif input.IsKeyDown( KEY_BACKSPACE ) or input.IsKeyDown( KEY_DELETE ) then
		ply.CH_ATM_LastKeypadInput = cur_time + delay
		
		atm:KEYPAD_AcceptInput( "CANCEL" )
	elseif input.IsKeyDown( KEY_ENTER ) or input.IsKeyDown( KEY_PAD_ENTER ) then
		ply.CH_ATM_LastKeypadInput = cur_time + delay
		
		atm:KEYPAD_AcceptInput( "ENTER" )
	end
end
hook.Add( "Think", "CH_ATM.EnableKeyboardInputForKeypad", CH_ATM.EnableKeyboardInputForKeypad )