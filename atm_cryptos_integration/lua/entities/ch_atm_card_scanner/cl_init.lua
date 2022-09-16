include( "shared.lua" )
local imgui = include( "ch_atm/client/ch_atm_imgui.lua" )

--[[
	Cache some variables for the keypad
--]]
local kp_sw, kp_sh = 240, 230
local kp_pos = Vector( 1.95, -3, 1 )
local kp_ang = Angle( 0, 90, 95 )
local kp_scale = 0.025

--[[
	Initialize the entity
--]]
function ENT:Initialize()
end

--[[
	DrawTranslucent function to draw 3d2d UI on credit card terminal
--]]
function ENT:DrawTranslucent()
	self:DrawModel()
	
	if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) >= CH_ATM.Config.DistanceToScreen3D2D then
		return
	end
	
	-- Draw the static UI
	if imgui.Entity3D2D( self, kp_pos, kp_ang, kp_scale ) then
		local pressing = imgui.IsPressing()
		
		-- SCREEN
		draw.SimpleText( CH_ATM.FormatMoney( tonumber( self:GetTerminalPrice() ) ), "CH_ATM_Font_CardScanner_Size25", 120, -100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		if self:GetIsReadyToScan() then
			draw.SimpleText( CH_ATM.LangString( "Scan credit card" ), "CH_ATM_Font_CardScanner_Size20", 120, -75, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( CH_ATM.LangString( "Enter and confirm" ), "CH_ATM_Font_CardScanner_Size20", 120, -75, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
		-- KEYPAD
		local owner = self:CPPIGetOwner()
		if owner and owner == LocalPlayer() then
			-- Button 1
			local hovering = imgui.IsHovering( 27.5, 11, 47, 47 )
			
			if hovering and pressing then
				self:KEYPAD_AcceptInput( "1" )
			end
			
			-- Button 2
			local hovering = imgui.IsHovering( 96.5, 11, 47, 47 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "2" )
			end
			
			-- Button 3
			local hovering = imgui.IsHovering( 165.5, 11, 47, 47 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "3" )
			end

			-- Button 4
			local hovering = imgui.IsHovering( 27.5, 64, 47, 47 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "4" )
			end
			
			-- Button 5
			local hovering = imgui.IsHovering( 96.5, 64, 47, 47 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "5" )
			end
			
			-- Button 6
			local hovering = imgui.IsHovering( 165.5, 64, 47, 47 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "6" )
			end

			-- Button 7
			local hovering = imgui.IsHovering( 27.5, 118, 47, 47 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "7" )
			end
			
			-- Button 8
			local hovering = imgui.IsHovering( 96.5, 118, 47, 47 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "8" )
			end
			
			-- Button 9
			local hovering = imgui.IsHovering( 165.5, 118, 47, 47 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "9" )
			end

			-- Button clear
			local hovering = imgui.IsHovering( 27.5, 171, 47, 47 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "CLEAR" )
			end

			-- Button 0
			local hovering = imgui.IsHovering( 96.5, 171, 47, 47 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "0" )
			end

			-- Button enter
			local hovering = imgui.IsHovering( 165.5, 171, 47, 47 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "ENTER" )
			end

			-- Draw curser
			imgui.xCursor( 0, 0, kp_sw, kp_sh )
		end
		
		imgui.End3D2D()
	end
end

--[[
	Function to take keypad input and perform an action
--]]
function ENT:KEYPAD_AcceptInput( input )	
	if input == "CLEAR" then
		-- Reset the keypad input
		self:KEYPAD_ResetInput()
		
		self:SetIsReadyToScan( false )
		
		net.Start( "CH_ATM_Net_CardScanner_IsReadyToScan" )
			net.WriteEntity( self )
			net.WriteBool( false )
		net.SendToServer()
		
		surface.PlaySound( "UI/buttonclick.wav" )
	elseif input == "ENTER" and not self:GetIsReadyToScan() then
		-- Set the machine to be ready to scan card
		self:SetIsReadyToScan( true )
		
		net.Start( "CH_ATM_Net_CardScanner_IsReadyToScan" )
			net.WriteEntity( self )
			net.WriteBool( true )
		net.SendToServer()
		
		surface.PlaySound( "UI/buttonclick.wav" )
	elseif not self:GetIsReadyToScan() then
		-- We're entering numbers now, so update the price
		net.Start( "CH_ATM_Net_CardScanner_UpdatePrice" )
			net.WriteEntity( self )
			net.WriteString( input )
			net.WriteBool( false )
		net.SendToServer()
		
		surface.PlaySound( "UI/buttonclick.wav" )
	end
end

--[[
	Reset the keypad input entirely
--]]
function ENT:KEYPAD_ResetInput()
	net.Start( "CH_ATM_Net_CardScanner_UpdatePrice" )
		net.WriteEntity( self )
		net.WriteString( "" )
		net.WriteBool( true )
	net.SendToServer()
end