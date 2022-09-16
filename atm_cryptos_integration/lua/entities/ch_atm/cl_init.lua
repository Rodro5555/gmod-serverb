include( "shared.lua" )
local imgui = include( "ch_atm/client/ch_atm_imgui.lua" )

--[[
	Net message to control who is currently using the ATM
--]]
net.Receive( "CH_ATM_Net_ATMInUseBy", function( len, ply )
	local atm = net.ReadEntity()
	local previous_user = atm.InUseBy
	atm.IsInUse = net.ReadBool()
	atm.InUseBy = net.ReadEntity()
	
	local ply = atm.InUseBy
	
	if IsValid( atm.InUseBy ) then
		ply.CH_ATM_IsActivelyUsingATM = atm
	elseif IsValid( previous_user ) then
		previous_user.CH_ATM_IsActivelyUsingATM = nil
	end
end )

--[[
	Cache some variables for the main screen
--]]
local sw, sh = 1060, 662
local pos = Vector( -0.8, -13.25, 68.7 )
local ang = Angle( 0, 90, 76.9 )
local scale = 0.025

local mat_back = Material( "materials/craphead_scripts/ch_atm/gui/arrowbtn.png", "noclamp smooth" )
local mat_page_next = Material( "materials/craphead_scripts/ch_atm/gui/page_next.png", "noclamp smooth" )
local mat_page_back = Material( "materials/craphead_scripts/ch_atm/gui/page_back.png", "noclamp smooth" )

local mat_action_complete = Material( "materials/craphead_scripts/ch_atm/gui/action_complete.png", "noclamp smooth" )
local mat_action_failed = Material( "materials/craphead_scripts/ch_atm/gui/action_failed.png", "noclamp smooth" )

local mat_hack_icon = Material( "materials/craphead_scripts/ch_atm/gui/hacking_icon.png", "noclamp smooth" )

local buy_icon = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/plus.png" )
local sold_icon = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/minus.png" )

--[[
	Cache some variables for the keypad
--]]
local kp_sw, kp_sh = 340, 230
local kp_pos = Vector( 2, 1.4, 45 )
local kp_ang = Angle( 0, 90, 67 )
local kp_scale = 0.025

--[[
	Initialize the entity
--]]
function ENT:Initialize()
	self:ATM_InitializeScreen()
end

function ENT:ATM_InitializeScreen()
	self:GENERAL_WelcomeScreen()
	
	-- Setup screen input string
	self.CurrentInput = ""
	
	-- Variable for keypad screen recognition
	self.KEYPAD_CurrentScreen = "none"
	
	-- Pagination stuff
	self.PAGES_CurrentPage = 1
	self.PAGES_AmountOfPages = 0
	self.PAGES_SelectedOption = nil
	
	self.PAGES_PageContent = {}
	
	-- Crypto variables
	self.CRYPTO_Index = 0
	self.CRYPTO_AmountToBuy = 0
	self.CRYPTO_AmountToSell = 0
	self.CRYPTO_AmountToSend = 0
end

--[[
	Setup/reset the ATM settings to default
	Happens on initialize or when a player goes far away from the ATM
--]]
net.Receive( "CH_ATM_Net_InitializeScreen", function( len, ply )
	local atm = net.ReadEntity()
	
	if IsValid( atm ) then
		atm:ATM_InitializeScreen()
	end
end )

--[[
	When a player inserts their credit card then change the screen
--]]
net.Receive( "CH_ATM_Net_InsertCreditCard", function( len, ply )
	local atm = net.ReadEntity()
	
	if IsValid( atm ) then
		-- First draw loading screen for a bit
		atm:GENERAL_LoadingScreen()
		
		-- Draw new 3D2D after loading screen
		timer.Simple( 2, function()
			if IsValid( atm ) and atm.IsInUse then
				if CH_CryptoCurrencies then
					atm:GENERAL_HomePortal()
				else
					atm:BANK_HomeScreen()
				end
			end
		end )
	end
end )


--[[
	DrawTranslucent function to draw 3d2d UI on ATM
--]]
function ENT:DrawTranslucent()
	self:DrawModel()
	
	if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) >= CH_ATM.Config.DistanceToScreen3D2D then
		return
	end
	
	-- Draw hack, cooldown or the screen
	if imgui.Entity3D2D( self, pos, ang, scale ) then
		-- BG
		surface.SetDrawColor( CH_ATM.Colors.LightGray )
		surface.DrawRect( 0, 0, sw, sh )
		
		if self:GetIsBeingHacked() then
			-- Top
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
			surface.DrawRect( 0, 0, sw, 50 )
			
			draw.SimpleText( CH_ATM.LangString( "Hacking ATM" ), "CH_ATM_Font_ATMScreen_Size35", sw / 2, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			-- Draw icon
			surface.SetDrawColor( color_white )
			surface.SetMaterial( mat_hack_icon )
			surface.DrawTexturedRect( sw / 2 - 175, 110, 350, 350 )
			
			draw.SimpleText( CH_ATM.LangString( "In progress..." ), "CH_ATM_Font_ATMScreen_Size70", sw / 2, 550, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		elseif self:GetIsHackCooldown() then
			-- Top
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
			surface.DrawRect( 0, 0, sw, 50 )
			
			draw.SimpleText( CH_ATM.LangString( "Out of order" ), "CH_ATM_Font_ATMScreen_Size35", sw / 2, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			-- Draw icon
			surface.SetDrawColor( color_white )
			surface.SetMaterial( mat_action_failed )
			surface.DrawTexturedRect( sw / 2 - 128, 110, 256, 256 )
			
			draw.SimpleText( CH_ATM.LangString( "Rebooting in" ), "CH_ATM_Font_ATMScreen_Size70", sw / 2, 450, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			if self.HackCooldownTimer and self.HackCooldownTimer > CurTime() then
				draw.SimpleText( string.ToMinutesSeconds( math.Round( self.HackCooldownTimer - CurTime() ) ), "CH_ATM_Font_ATMScreen_Size100", sw / 2, 550, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		elseif self:GetIsEmergencyLockdown() then
			-- Top
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
			surface.DrawRect( 0, 0, sw, 50 )
			
			draw.SimpleText( CH_ATM.LangString( "Emergency Lockdown" ), "CH_ATM_Font_ATMScreen_Size35", sw / 2, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			-- Draw icon
			surface.SetDrawColor( color_white )
			surface.SetMaterial( mat_action_failed )
			surface.DrawTexturedRect( sw / 2 - 128, 175, 256, 256 )
		end
		
		imgui.End3D2D()
	end

	-- 3D2D functions
	if not self:GetIsBeingHacked() and not self:GetIsHackCooldown() and not self:GetIsEmergencyLockdown() then
		if not self.IsInUse or ( self.InUseBy and self.InUseBy == LocalPlayer() ) then
			self.Draw3D2DPage()
			self.Draw3D2DKeypad()
		else
			self.Draw3D2DPage()
			self.Draw3D2DKeypad()
			
			self:GENERAL_IsInUseScreen()
		end
	end
end

--[[
	These functions are later used to store only the 3d2d that we're currently rendering for the player
--]]
function ENT.Draw3D2DPage()
end

function ENT.Draw3D2DKeypad()
end

--[[
	Empty the 3d2d function
--]]
function ENT:KEYPAD_Clear3D2D()
	self.KEYPAD_CurrentScreen = "none"
	
	self.Draw3D2DKeypad = function() end
end

--[[
	Function to take keypad input and perform an action
--]]
function ENT:KEYPAD_AcceptInput( input )	
	if input == "CANCEL" then
		surface.PlaySound( "buttons/button10.wav" )
		-- Reset the keypad input (might change cancel to something else in the future)
		self:KEYPAD_ResetInput()
	elseif input == "CLEAR" then
		surface.PlaySound( "buttons/button10.wav" )
		-- Reset the keypad input
		self:KEYPAD_ResetInput()
	elseif input == "ENTER" then
		surface.PlaySound( "buttons/button15.wav" )
		-- Call perform action function to run the proper code
		self:KEYPAD_PerformAction()
	else
		surface.PlaySound( "buttons/button3.wav" )
		self.CurrentInput = self.CurrentInput .. input
	end
end

function ENT:KEYPAD_ResetInput()
	self.CurrentInput = ""
end

--[[
	Function for actions when pressing ENTER with the keypad
	All are based on the current active screen
--]]
function ENT:KEYPAD_PerformAction()
	local ply = LocalPlayer()
	local keypad_input = self.CurrentInput
	
	local ply_money_wallet = CH_ATM.GetMoney( ply )
	local ply_bank_account = CH_ATM.GetMoneyBankAccount( ply )
	local max_money = CH_ATM.GetAccountMaxMoney( ply )

	if self.KEYPAD_CurrentScreen == "deposit" then
		keypad_input = string.Replace( keypad_input, ".", "" )
		
		if #keypad_input > 0 and tonumber( keypad_input ) > ply_money_wallet then
			-- Show action failed screen
			self:GENERAL_ActionUnsuccessful( CH_ATM.LangString( "You don't have this much money!" ) )
		elseif #keypad_input > 0 and max_money != 0 and tonumber( keypad_input + ply_bank_account ) > max_money then
			-- Show action failed screen
			self:GENERAL_ActionUnsuccessful( CH_ATM.LangString( "Your bank account holding has gone above your maximum of" ) .." ".. CH_ATM.FormatMoney( max_money ) )
		elseif #keypad_input > 0 then
			net.Start( "CH_ATM_Net_DepositMoney" )
				net.WriteUInt( keypad_input, 32 )
				net.WriteEntity( self )
			net.SendToServer()
			
			-- Show action completed screen
			self:GENERAL_ActionSuccessful()
		else
			-- Show action failed screen
			self:GENERAL_ActionUnsuccessful( CH_ATM.LangString( "Please enter a valid number" ) )
		end
		
		-- Draw new 3D2D after action completed screen
		timer.Simple( 2, function()
			if IsValid( self ) and self.IsInUse then
				self:BANK_HomeScreen()
			end
		end )
	elseif self.KEYPAD_CurrentScreen == "withdraw" then
		keypad_input = string.Replace( keypad_input, ".", "" )
		
		if #keypad_input > 0 and tonumber( keypad_input ) > ply_bank_account then
			-- Show action failed screen
			self:GENERAL_ActionUnsuccessful( CH_ATM.LangString( "You don't have this much money!" ) )
		elseif #keypad_input > 0 then
			net.Start( "CH_ATM_Net_WithdrawMoney" )
				net.WriteUInt( keypad_input, 32 )
				net.WriteEntity( self )
			net.SendToServer()
			
			-- Show action completed screen
			self:GENERAL_ActionSuccessful()
		else
			-- Show action failed screen
			self:GENERAL_ActionUnsuccessful( CH_ATM.LangString( "Please enter a valid number" ) )
		end
		
		-- Draw new 3D2D after action completed screen
		timer.Simple( 2, function()
			if IsValid( self ) and self.IsInUse then
				self:BANK_HomeScreen()
			end
		end )
	elseif self.KEYPAD_CurrentScreen == "transfer" then
		keypad_input = string.Replace( keypad_input, ".", "" )
		
		if not self.PAGES_SelectedOption then
			-- Show action failed screen
			self:GENERAL_ActionUnsuccessful( CH_ATM.LangString( "You need to select a player" ) )
		elseif #keypad_input > 0 and tonumber( keypad_input ) > ply_bank_account then
			-- Show action failed screen
			self:GENERAL_ActionUnsuccessful( CH_ATM.LangString( "You don't have this much money!" ) )
		elseif #keypad_input > 0 and self.PAGES_SelectedOption then
			net.Start( "CH_ATM_Net_SendMoney" )
				net.WriteUInt( keypad_input, 32 )
				net.WriteEntity( self.PAGES_SelectedOption )
			net.SendToServer()
			
			-- Show action completed screen
			self:GENERAL_ActionSuccessful()
		else
			-- Show action failed screen
			self:GENERAL_ActionUnsuccessful( CH_ATM.LangString( "Please enter a valid number" ) )
		end
		
		-- Draw new 3D2D after action completed screen
		timer.Simple( 2, function()
			if IsValid( self ) and self.IsInUse then
				self:BANK_HomeScreen()
			end
		end )
	elseif self.KEYPAD_CurrentScreen == "buy_crypto" then
		keypad_input = string.Replace( keypad_input, ".", "" )
		
		if #keypad_input > 0 and self.CRYPTO_Index > 0 and self.CRYPTO_AmountToBuy > 0 then
			net.Start( "CH_CryptoCurrencies_Net_BuyCrypto" )
				net.WriteUInt( self.CRYPTO_Index, 6 )
				net.WriteDouble( self.CRYPTO_AmountToBuy )
			net.SendToServer()
			
			-- Show action completed screen
			self:GENERAL_ActionSuccessful()
		else
			-- Show action failed screen
			self:GENERAL_ActionUnsuccessful( CH_ATM.LangString( "Please enter a valid number" ) )
		end
		
		-- Draw new 3D2D after action completed screen
		timer.Simple( 2, function()
			if IsValid( self ) and self.IsInUse then
				self:CRYPTO_BrowseCurrencies()
			end
		end )
	elseif self.KEYPAD_CurrentScreen == "sell_crypto" then
		local crypto_prefix = CH_CryptoCurrencies.CryptosCL[ self.CRYPTO_Index ].Currency
		
		if ply.CH_CryptoCurrencies_Wallet[ crypto_prefix ].Amount < self.CRYPTO_AmountToSell then
			-- Show action failed screen
			self:GENERAL_ActionUnsuccessful( CH_CryptoCurrencies.LangString( "You don't own this many" ) .." ".. CH_CryptoCurrencies.CryptosCL[ self.CRYPTO_Index ].Name )
		elseif #keypad_input > 0 and self.CRYPTO_Index > 0 and self.CRYPTO_AmountToSell > 0 then
			net.Start( "CH_CryptoCurrencies_Net_SellCrypto" )
				net.WriteUInt( self.CRYPTO_Index, 6 )
				net.WriteDouble( self.CRYPTO_AmountToSell )
			net.SendToServer()
			
			-- Show action completed screen
			self:GENERAL_ActionSuccessful()
		else
			-- Show action failed screen
			self:GENERAL_ActionUnsuccessful( CH_ATM.LangString( "Please enter a valid number" ) )
		end
		
		-- Draw new 3D2D after action completed screen
		timer.Simple( 2, function()
			if IsValid( self ) and self.IsInUse then
				self:CRYPTO_BrowseCurrencies()
			end
		end )
	elseif self.KEYPAD_CurrentScreen == "send_crypto" then
		local crypto_prefix = CH_CryptoCurrencies.CryptosCL[ self.CRYPTO_Index ].Currency
		
		if not self.PAGES_SelectedOption then
			-- Show action failed screen
			self:GENERAL_ActionUnsuccessful( CH_ATM.LangString( "You need to select a player" ) )
		elseif ply.CH_CryptoCurrencies_Wallet[ crypto_prefix ].Amount < self.CRYPTO_AmountToSend then
			-- Show action failed screen
			self:GENERAL_ActionUnsuccessful( CH_CryptoCurrencies.LangString( "You don't own this many" ) .." ".. CH_CryptoCurrencies.CryptosCL[ self.CRYPTO_Index ].Name )
		elseif #keypad_input > 0 and self.CRYPTO_Index > 0 and self.CRYPTO_AmountToSend > 0 then
			net.Start( "CH_CryptoCurrencies_Net_SendCrypto" )
				net.WriteUInt( self.CRYPTO_Index, 6 )
				net.WriteDouble( self.CRYPTO_AmountToSend )
				net.WriteEntity( self.PAGES_SelectedOption )
			net.SendToServer()
			
			-- Show action completed screen
			self:GENERAL_ActionSuccessful()
		else
			-- Show action failed screen
			self:GENERAL_ActionUnsuccessful( CH_ATM.LangString( "Please enter a valid number" ) )
		end
		
		-- Draw new 3D2D after action completed screen
		timer.Simple( 2, function()
			if IsValid( self ) and self.IsInUse then
				self:CRYPTO_HomeScreen()
			end
		end )
	else
		ply:ChatPrint( "Unknown keypad action!" )
	end
	
	-- Reset the selected option
	self.PAGES_SelectedOption = nil

	-- Reset the keypad input
	self:KEYPAD_ResetInput()
	
	-- Remove keypad 3d2d
	self:KEYPAD_Clear3D2D()
end

--[[
	Initial screen when an ATM is not in use
--]]
function ENT:GENERAL_WelcomeScreen()
	self.Draw3D2DPage = function()
		if imgui.Entity3D2D( self, pos, ang, scale ) then
			if CH_ATM.Config.ActivateWithCreditCard then
				-- Draw credit card
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_insert_card )
				surface.DrawTexturedRect( sw / 2 - 128, 250 - 128, 256, 256 )
			
				draw.SimpleText( CH_ATM.LangString( "Insert credit card to use the ATM" ), "CH_ATM_Font_ATMScreen_Size40", sw / 2, 500, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER ) -- MISSING TRANSLATION
			else
				-- Draw bank icon
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_bank )
				surface.DrawTexturedRect( sw / 2 - 128, 250 - 128, 256, 256 )
			
				draw.SimpleText( CH_ATM.LangString( "Press 'USE' to use the ATM" ), "CH_ATM_Font_ATMScreen_Size40", sw / 2, 500, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				
				-- Press anywhere to continue
				local pressing = imgui.IsPressing()

				if pressing then
					if CH_CryptoCurrencies then
						self:GENERAL_HomePortal()
					else
						-- First draw loading screen for a bit
						self:GENERAL_LoadingScreen()
						
						-- Draw new 3D2D after loading screen
						timer.Simple( 1, function()
							if IsValid( self ) and self.IsInUse then
								self:BANK_HomeScreen()
							end
						end )
					end
				end
			end
			
			imgui.End3D2D()
		end
	end
end

--[[
	Action completed
--]]
function ENT:GENERAL_ActionSuccessful()
	self.Draw3D2DPage = function()
		if imgui.Entity3D2D( self, pos, ang, scale ) then
			-- Draw action complete icon
			surface.SetDrawColor( color_white )
			surface.SetMaterial( mat_action_complete )
			surface.DrawTexturedRect( sw / 2 - 128, 250 - 128, 256, 256 )
			
			draw.SimpleText( CH_ATM.LangString( "Action Successful" ), "CH_ATM_Font_ATMScreen_Size40", sw / 2, 500, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			imgui.End3D2D()
		end
	end
	
	net.Start( "CH_ATM_Net_ChangeATMColor" )
		net.WriteEntity( self )
		net.WriteColor( CH_ATM.Config.ActionSuccessfulColor )
		net.WriteUInt( 2, 10 )
	net.SendToServer()
end

--[[
	Action failed
--]]
function ENT:GENERAL_ActionUnsuccessful( details )
	-- Play sound
	surface.PlaySound( "common/wpn_denyselect.wav" )
	
	-- Draw 3d2d
	self.Draw3D2DPage = function()
		if imgui.Entity3D2D( self, pos, ang, scale ) then
			-- Draw action failed icon
			surface.SetDrawColor( color_white )
			surface.SetMaterial( mat_action_failed )
			surface.DrawTexturedRect( sw / 2 - 128, 250 - 128, 256, 256 )
			
			draw.SimpleText( CH_ATM.LangString( "Action Unsuccessful" ), "CH_ATM_Font_ATMScreen_Size40", sw / 2, 450, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			if details then
				draw.SimpleText( details, "CH_ATM_Font_ATMScreen_Size35", sw / 2, 500, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			
			imgui.End3D2D()
		end
	end
	
	-- Change ATM color
	net.Start( "CH_ATM_Net_ChangeATMColor" )
		net.WriteEntity( self )
		net.WriteColor( CH_ATM.Config.ActionUnsuccessfulColor )
		net.WriteUInt( 2, 10 )
	net.SendToServer()
end

--[[
	Loading screen
--]]
function ENT:GENERAL_LoadingScreen()
	self.Draw3D2DPage = function()
		if imgui.Entity3D2D( self, pos, ang, scale ) then
			-- Draw spinning loading icon
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_load )
			surface.DrawTexturedRectRotated( sw / 2, 250, 256, 256, CurTime() * -75 )
			
			draw.SimpleText( CH_ATM.LangString( "Loading page" ), "CH_ATM_Font_ATMScreen_Size45", sw / 2, 500, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			imgui.End3D2D()
		end
	end
end

--[[
	Loading screen
--]]
function ENT:GENERAL_IsInUseScreen()
	self.Draw3D2DPage = function()
		if imgui.Entity3D2D( self, pos, ang, scale ) then
			-- Draw spinning loading icon
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_load )
			surface.DrawTexturedRectRotated( sw / 2, 250, 256, 256, CurTime() * -75 )
			
			if IsValid( self.InUseBy ) then
				draw.SimpleText( CH_ATM.LangString( "ATM occupied by" ) .." ".. self.InUseBy:Nick(), "CH_ATM_Font_ATMScreen_Size45", sw / 2, 500, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			
			imgui.End3D2D()
		end
	end
end

--[[
	Keypad
--]]
function ENT:GENERAL_KeyPad( current_screen )
	self.KEYPAD_CurrentScreen = current_screen
	
	self.Draw3D2DKeypad = function()
		if imgui.Entity3D2D( self, kp_pos, kp_ang, kp_scale ) then
			local pressing = imgui.IsPressing()

			-- Button 1
			local hovering = imgui.IsHovering( 30, 25, 55, 40 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "1" )
			end
			
			-- Button 2
			local hovering = imgui.IsHovering( 90, 25, 55, 40 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "2" )
			end
			
			-- Button 2
			local hovering = imgui.IsHovering( 152.5, 25, 55, 40 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "3" )
			end
			
			-- Button 4
			local hovering = imgui.IsHovering( 30, 70, 55, 40 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "4" )
			end
			
			-- Button 5
			local hovering = imgui.IsHovering( 90, 70, 55, 40 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "5" )
			end
			
			-- Button 6
			local hovering = imgui.IsHovering( 152.5, 70, 55, 40 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "6" )
			end
			
			-- Button 7
			local hovering = imgui.IsHovering( 30, 115, 55, 40 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "7" )
			end
			
			-- Button 8
			local hovering = imgui.IsHovering( 90, 115, 55, 40 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "8" )
			end
			
			-- Button 9
			local hovering = imgui.IsHovering( 152.5, 115, 55, 40 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "9" )
			end
			
			-- Button .
			local hovering = imgui.IsHovering( 30, 160, 55, 40 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "." )
			end
			
			-- Button 0
			local hovering = imgui.IsHovering( 90, 160, 55, 40 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "0" )
			end
			
			-- Button /
			--[[
			local hovering = imgui.IsHovering( 152.5, 160, 55, 40 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "/" )
				surface.PlaySound( "UI/buttonclick.wav" )
			end
			--]]
			-- Button CANCEL
			local hovering = imgui.IsHovering( 225, 25, 85, 40 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "CANCEL" )
			end
			
			-- Button CLEAR
			local hovering = imgui.IsHovering( 225, 70, 85, 40 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "CLEAR" )
			end
			
			-- Button ENTER
			local hovering = imgui.IsHovering( 225, 115, 85, 40 )

			if hovering and pressing then
				self:KEYPAD_AcceptInput( "ENTER" )
			end
			
			-- Draw curser
			imgui.xCursor( 0, 0, kp_sw, kp_sh )
			
			imgui.End3D2D()
		end
	end
end

--[[
	Select DarkRP Bank or Cryptocurrencies
--]]
function ENT:GENERAL_HomePortal()
	local ply = LocalPlayer()

	surface.PlaySound( "buttons/button17.wav" )
	
	self.Draw3D2DPage = function()
		if imgui.Entity3D2D( self, pos, ang, scale ) then
			local pressing = imgui.IsPressing()
			
			-- Top
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
			surface.DrawRect( 0, 0, sw, 50 )
			
			draw.SimpleText( CH_ATM.LangString( "Welcome" ) ..", ".. ply:Nick(), "CH_ATM_Font_ATMScreen_Size35", sw / 2, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			-- Exit button
			if CH_ATM.Config.ActivateWithCreditCard then
				local hovering = imgui.IsHovering( 1020, 10, 32, 32 )
				
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme( ply ) ].mat_exit_atm )
				surface.DrawTexturedRect( 1020, 10, 32, 32 )
				
				if hovering and pressing then
					-- Start net to pull out card and reset atm
					net.Start( "CH_ATM_Net_PullOutCreditCard" )
						net.WriteEntity( self )
					net.SendToServer()
				end
			end
			
			-- Bank Account Button
			local hovering = imgui.IsHovering( 125, 120, 300, 400 )
			
			if hovering and pressing then
				draw.RoundedBox( 8, 125, 440, 300, 80, CH_ATM.Colors.Green )
				
				-- First draw loading screen for a bit
				self:GENERAL_LoadingScreen()
				
				-- Draw new 3D2D after loading screen
				timer.Simple( 1, function()
					if IsValid( self ) and self.IsInUse then
						self:BANK_HomeScreen()
					end
				end )
			elseif hovering then
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_bank )
				surface.DrawTexturedRect( 146, 146, 268, 268 )
			
				draw.RoundedBox( 8, 125, 440, 300, 80, CH_ATM.Colors.GMSBlue )
			else
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_bank )
				surface.DrawTexturedRect( 150, 150, 256, 256 )
			
				draw.RoundedBox( 8, 125, 440, 300, 80, CH_ATM.Colors.DarkGray )
			end
			
			draw.SimpleText( CH_ATM.LangString( "Bank Account" ), "CH_ATM_Font_ATMScreen_Size45", 270, 480, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			-- Cryptocurrencies Button
			local hovering = imgui.IsHovering( 625, 120, 300, 400 )
			
			if hovering and pressing then
				draw.RoundedBox( 8, 625, 440, 300, 80, CH_ATM.Colors.Green )
				
				-- First draw loading screen for a bit
				self:GENERAL_LoadingScreen()
				
				-- Draw new 3D2D after loading screen
				timer.Simple( 1, function()
					if IsValid( self ) and self.IsInUse then
						self:CRYPTO_HomeScreen()
					end
				end )
			elseif hovering then
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_crypto_bank )
				surface.DrawTexturedRect( 646, 146, 268, 268 )
			
				draw.RoundedBox( 8, 625, 440, 300, 80, CH_ATM.Colors.GMSBlue )
			else
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_crypto_bank )
				surface.DrawTexturedRect( 650, 150, 256, 256 )
			
				draw.RoundedBox( 8, 625, 440, 300, 80, CH_ATM.Colors.DarkGray )
			end
			
			draw.SimpleText( CH_ATM.LangString( "Cryptocurrencies" ), "CH_ATM_Font_ATMScreen_Size45", 775, 480, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			
			
			
			-- Settings Button
			local hovering = imgui.IsHovering( 970, 570, 64, 64 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme( ply ) ].mat_settings )
			surface.DrawTexturedRect( 970, 570, 64, 64 )
			
			if hovering and pressing then
				self:GENERAL_UserSettings()
			end
			
			-- Draw curser
			imgui.xCursor( 0, 0, sw, sh )
			
			imgui.End3D2D()
		end
	end
end

--[[
	General settings menu
--]]
function ENT:GENERAL_UserSettings()
	local ply = LocalPlayer()

	surface.PlaySound( "buttons/button17.wav" )
	
	self.Draw3D2DPage = function()
		if imgui.Entity3D2D( self, pos, ang, scale ) then
			local pressing = imgui.IsPressing()
			
			-- Top
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
			surface.DrawRect( 0, 0, sw, 50 )
			
			draw.SimpleText( CH_ATM.LangString( "Welcome" ) ..", ".. ply:Nick(), "CH_ATM_Font_ATMScreen_Size35", sw / 2, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			-- Exit button
			if CH_ATM.Config.ActivateWithCreditCard then
				local hovering = imgui.IsHovering( 1020, 10, 32, 32 )
				
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme( ply ) ].mat_exit_atm )
				surface.DrawTexturedRect( 1020, 10, 32, 32 )
				
				if hovering and pressing then
					-- Start net to pull out card and reset atm
					net.Start( "CH_ATM_Net_PullOutCreditCard" )
						net.WriteEntity( self )
					net.SendToServer()
				end
			end
			
			-- User settings (icon theme, cursor icon)
			draw.SimpleText( CH_ATM.LangString( "User Settings" ), "CH_ATM_Font_ATMScreen_Size45", sw / 2, 105, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			-- White Icons
			local hovering = imgui.IsHovering( 50, 150, 300, 95 )
			
			if hovering and pressing then
				draw.RoundedBox( 8, 50, 150, 300, 95, CH_ATM.Colors.Green )
				
				-- Draw new 3D2D
				ply:ConCommand( "ch_atm_theme_setting 1" )
			elseif hovering then
				draw.RoundedBox( 8, 50, 150, 300, 95, CH_ATM.Colors.GMSBlue )
			else
				draw.RoundedBox( 8, 50, 150, 300, 95, CH_ATM.Colors.DarkGray )
			end
			
			draw.SimpleText( CH_ATM.LangString( "White Icons" ), "CH_ATM_Font_ATMScreen_Size35", 200, 175, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ 1 ].mat_deposit )
			surface.DrawTexturedRect( 80, 200, 32, 32 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ 1 ].mat_withdraw )
			surface.DrawTexturedRect( 150, 200, 32, 32 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ 1 ].mat_send_money )
			surface.DrawTexturedRect( 220, 200, 32, 32 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ 1 ].mat_bank_history )
			surface.DrawTexturedRect( 290, 200, 32, 32 )
			
			-- Gradient Icons
			local hovering = imgui.IsHovering( sw / 2 - 150, 150, 300, 95 )
			
			if hovering and pressing then
				draw.RoundedBox( 8, sw / 2 - 150, 150, 300, 95, CH_ATM.Colors.Green )
				
				-- Draw new 3D2D
				ply:ConCommand( "ch_atm_theme_setting 2" )
			elseif hovering then
				draw.RoundedBox( 8, sw / 2 - 150, 150, 300, 95, CH_ATM.Colors.GMSBlue )
			else
				draw.RoundedBox( 8, sw / 2 - 150, 150, 300, 95, CH_ATM.Colors.DarkGray )
			end
			
			draw.SimpleText( CH_ATM.LangString( "Gradient Icons" ), "CH_ATM_Font_ATMScreen_Size35", sw / 2, 175, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ 2 ].mat_deposit )
			surface.DrawTexturedRect( 410, 200, 32, 32 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ 2 ].mat_withdraw )
			surface.DrawTexturedRect( 480, 200, 32, 32 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ 2 ].mat_send_money )
			surface.DrawTexturedRect( 550, 200, 32, 32 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ 2 ].mat_bank_history )
			surface.DrawTexturedRect( 620, 200, 32, 32 )
			
			-- Flat Color Icons
			local hovering = imgui.IsHovering( 710, 150, 300, 95 )
			
			if hovering and pressing then
				draw.RoundedBox( 8, 710, 150, 300, 95, CH_ATM.Colors.Green )
				
				-- Draw new 3D2D
				ply:ConCommand( "ch_atm_theme_setting 3" )
			elseif hovering then
				draw.RoundedBox( 8, 710, 150, 300, 95, CH_ATM.Colors.GMSBlue )
			else
				draw.RoundedBox( 8, 710, 150, 300, 95, CH_ATM.Colors.DarkGray )
			end
			
			draw.SimpleText( CH_ATM.LangString( "Flat Color Icons" ), "CH_ATM_Font_ATMScreen_Size35", 860, 175, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ 3 ].mat_deposit )
			surface.DrawTexturedRect( 735, 200, 32, 32 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ 3 ].mat_withdraw )
			surface.DrawTexturedRect( 805, 200, 32, 32 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ 3 ].mat_send_money )
			surface.DrawTexturedRect( 875, 200, 32, 32 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ 3 ].mat_bank_history )
			surface.DrawTexturedRect( 945, 200, 32, 32 )
			
			-- Use Cursor
			local hovering = imgui.IsHovering( sw / 2 - 265, 270, 250, 50 )
			
			if hovering and pressing then
				draw.RoundedBox( 8, sw / 2 - 265, 270, 250, 50, CH_ATM.Colors.Green )
				
				-- Draw new 3D2D
				ply:ConCommand( "ch_atm_cursor_setting 1" )
			elseif hovering then
				draw.RoundedBox( 8, sw / 2 - 265, 270, 250, 50, CH_ATM.Colors.GMSBlue )
			else
				draw.RoundedBox( 8, sw / 2 - 265, 270, 250, 50, CH_ATM.Colors.DarkGray )
			end
			
			draw.SimpleText( CH_ATM.LangString( "Use Cursor" ), "CH_ATM_Font_ATMScreen_Size35", 390, 295, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.Materials.Cursor )
			surface.DrawTexturedRect( 465, 278, 32, 32 )
			
			-- Use Hand
			local hovering = imgui.IsHovering( sw / 2 + 15, 270, 250, 50 )
			
			if hovering and pressing then
				draw.RoundedBox( 8, sw / 2 + 15, 270, 250, 50, CH_ATM.Colors.Green )
				
				-- Draw new 3D2D
				ply:ConCommand( "ch_atm_cursor_setting 2" )
			elseif hovering then
				draw.RoundedBox( 8, sw / 2 + 15, 270, 250, 50, CH_ATM.Colors.GMSBlue )
			else
				draw.RoundedBox( 8, sw / 2 + 15, 270, 250, 50, CH_ATM.Colors.DarkGray )
			end
			
			draw.SimpleText( CH_ATM.LangString( "Use Hand" ), "CH_ATM_Font_ATMScreen_Size35", 670, 295, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.Materials.HandCursor )
			surface.DrawTexturedRect( 740, 278, 32, 32 )
			
			
			-- Account Information
			draw.SimpleText( CH_ATM.LangString( "Account Information" ), "CH_ATM_Font_ATMScreen_Size45", sw / 2, 370, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			draw.RoundedBox( 8, 50, 420, 300, 50, CH_ATM.Colors.DarkGray )
			draw.SimpleText( CH_ATM.LangString( "Account Level" ) ..": ".. CH_ATM.GetAccountLevel( ply ), "CH_ATM_Font_ATMScreen_Size35", 200, 445, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			draw.RoundedBox( 8, 380, 420, 300, 50, CH_ATM.Colors.DarkGray )
			draw.SimpleText( CH_ATM.LangString( "Interest Rate" ) ..": ".. CH_ATM.GetAccountInterestRate( ply ) .."%", "CH_ATM_Font_ATMScreen_Size35", sw / 2, 445, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			draw.RoundedBox( 8, 50, 500, 300, 50, CH_ATM.Colors.DarkGray )
			if CH_ATM.GetAccountMaxMoney( ply ) == 0 then
				draw.SimpleText( CH_ATM.LangString( "Unlimited" ), "CH_ATM_Font_ATMScreen_Size35", 200, 525, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( CH_ATM.LangString( "Max" ) ..": ".. CH_ATM.FormatMoney( CH_ATM.GetAccountMaxMoney( ply ) ), "CH_ATM_Font_ATMScreen_Size35", 200, 525, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			
			draw.RoundedBox( 8, 380, 500, 300, 50, CH_ATM.Colors.DarkGray )
			draw.SimpleText( CH_ATM.LangString( "Max Interest" ) ..": ".. CH_ATM.FormatMoney( CH_ATM.GetMaxInterestToEarn( ply ) ), "CH_ATM_Font_ATMScreen_Size35", sw / 2, 525, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			-- Upgrade Account
			local hovering = imgui.IsHovering( 710, 420, 300, 130 )
			
			if hovering and pressing then
				draw.RoundedBox( 8, 710, 420, 300, 130, CH_ATM.Colors.Green )
				
				-- Draw new 3D2D
				local next_level = CH_ATM.GetAccountLevel( ply ) + 1
				
				if CH_ATM.Config.AccountLevels[ next_level ] then
					self:GENERAL_UpgradeAccount()
				else
					self:GENERAL_ActionUnsuccessful( CH_ATM.LangString( "Your account cannot be upgraded anymore!" ) )
					
					-- Draw new 3D2D after
					timer.Simple( 2, function()
						if IsValid( self ) and self.IsInUse then
							self:GENERAL_UserSettings()
						end
					end )
				end
			elseif hovering then
				draw.RoundedBox( 8, 710, 420, 300, 130, CH_ATM.Colors.GMSBlue )
			else
				draw.RoundedBox( 8, 710, 420, 300, 130, CH_ATM.Colors.DarkGray )
			end
			
			draw.SimpleText( CH_ATM.LangString( "Upgrade Account" ), "CH_ATM_Font_ATMScreen_Size35", 860, 445, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_upgrade_account )
			surface.DrawTexturedRect( 820, 463, 80, 80 )
			
			-- Back Button
			local hovering = imgui.IsHovering( 20, 605, 32, 32 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( mat_back )
			surface.DrawTexturedRect( 20, 605, 32, 32 )
			
			if hovering and pressing then
				if CH_CryptoCurrencies then
					self:GENERAL_HomePortal()
				else
					self:BANK_HomeScreen()
				end
			end
			
			-- Draw curser
			imgui.xCursor( 0, 0, sw, sh )
			
			imgui.End3D2D()
		end
	end
end

--[[
	Menu to upgrade your account
--]]
function ENT:GENERAL_UpgradeAccount()

	surface.PlaySound( "buttons/button17.wav" )
	
	local ply = LocalPlayer()
	local next_level = CH_ATM.GetAccountLevel( ply ) + 1
	local ply_bank_account = CH_ATM.GetMoneyBankAccount( ply )
	
	self.Draw3D2DPage = function()
		if imgui.Entity3D2D( self, pos, ang, scale ) then
			local pressing = imgui.IsPressing()
			
			-- Top
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
			surface.DrawRect( 0, 0, sw, 50 )
			
			draw.SimpleText( CH_ATM.LangString( "Total Balance" ) ..": ".. CH_ATM.FormatMoney( ply_bank_account ), "CH_ATM_Font_ATMScreen_Size35", sw / 2, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			-- Exit button
			if CH_ATM.Config.ActivateWithCreditCard then
				local hovering = imgui.IsHovering( 1020, 10, 32, 32 )
				
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme( ply ) ].mat_exit_atm )
				surface.DrawTexturedRect( 1020, 10, 32, 32 )
				
				if hovering and pressing then
					-- Start net to pull out card and reset atm
					net.Start( "CH_ATM_Net_PullOutCreditCard" )
						net.WriteEntity( self )
					net.SendToServer()
				end
			end
			
			-- Draw icon
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_upgrade_account )
			surface.DrawTexturedRect( sw / 2 - 128, 250 - 128, 256, 256 )

			-- Browse Cryptocurrencies Button
			local hovering = imgui.IsHovering( sw / 2 - 400, 440, 800, 100 )
			
			if hovering and pressing then
				draw.RoundedBox( 8, sw / 2 - 400, 440, 800, 100, CH_ATM.Colors.Green )
				
				if tonumber( CH_ATM.Config.AccountLevels[ next_level ].UpgradePrice ) > ply_bank_account then
					-- Show action failed screen
					self:GENERAL_ActionUnsuccessful( CH_ATM.LangString( "You don't have this much money!" ) )
				else
					net.Start( "CH_ATM_Net_UpgradeBankAccountLevel" )
					net.SendToServer()
					
					-- Show action completed screen
					self:GENERAL_ActionSuccessful()
				end
				
				-- Draw new 3D2D after action completed screen
				timer.Simple( 2, function()
					if IsValid( self ) and self.IsInUse then
						self:GENERAL_UserSettings()
					end
				end )
			elseif hovering then
				draw.RoundedBox( 8, sw / 2 - 400, 440, 800, 100, CH_ATM.Colors.GMSBlue )
			else
				draw.RoundedBox( 8, sw / 2 - 400, 440, 800, 100, CH_ATM.Colors.DarkGray )
			end
			
			draw.SimpleText( CH_ATM.LangString( "Upgrade Account - Next Level" ) ..": ".. next_level, "CH_ATM_Font_ATMScreen_Size45", sw / 2, 470, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( CH_ATM.LangString( "Costs" ) ..": ".. CH_ATM.FormatMoney( CH_ATM.Config.AccountLevels[ next_level ].UpgradePrice ), "CH_ATM_Font_ATMScreen_Size35", sw / 2, 510, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			-- Back Button
			local hovering = imgui.IsHovering( 20, 605, 32, 32 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( mat_back )
			surface.DrawTexturedRect( 20, 605, 32, 32 )
			
			if hovering and pressing then
				-- Show bank home screen
				self:GENERAL_UserSettings()
				
				-- Reset page
				self.PAGES_CurrentPage = 1
			end
			
			-- Draw curser
			imgui.xCursor( 0, 0, sw, sh )
			
			imgui.End3D2D()
		end
	end
end




--[[
	Home for cryptocurrencies
--]]
function ENT:CRYPTO_HomeScreen()
	local ply = LocalPlayer()

	surface.PlaySound( "buttons/button17.wav" )
	
	self.Draw3D2DPage = function()
		if imgui.Entity3D2D( self, pos, ang, scale ) then
			local pressing = imgui.IsPressing()

			-- Top
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
			surface.DrawRect( 0, 0, sw, 50 )
			
			draw.SimpleText( CH_ATM.LangString( "Welcome" ) ..", ".. ply:Nick(), "CH_ATM_Font_ATMScreen_Size35", sw / 2, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			-- Exit button
			if CH_ATM.Config.ActivateWithCreditCard then
				local hovering = imgui.IsHovering( 1020, 10, 32, 32 )
				
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme( ply ) ].mat_exit_atm )
				surface.DrawTexturedRect( 1020, 10, 32, 32 )
				
				if hovering and pressing then
					-- Start net to pull out card and reset atm
					net.Start( "CH_ATM_Net_PullOutCreditCard" )
						net.WriteEntity( self )
					net.SendToServer()
				end
			end
			
			
			-- Cache some button sizes
			local btn_x = sw / 2 - 400
			local btn_w = 800
			local btn_h = 100
			
			
			
			
			-- Browse Cryptocurrencies Button
			local hovering = imgui.IsHovering( btn_x, 100, btn_w, btn_h )
			
			if hovering and pressing then
				draw.RoundedBox( 8, btn_x, 100, btn_w, btn_h, CH_ATM.Colors.Green )
				
				-- Draw new 3D2D
				self:CRYPTO_BrowseCurrencies()
			elseif hovering then
				draw.RoundedBox( 8, btn_x, 100, btn_w, btn_h, CH_ATM.Colors.GMSBlue )
			else
				draw.RoundedBox( 8, btn_x, 100, btn_w, btn_h, CH_ATM.Colors.DarkGray )
			end
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_cryptos )
			surface.DrawTexturedRect( 150, 110, 80, 80 )
			
			draw.SimpleText( CH_ATM.LangString( "Browse Cryptocurrencies" ), "CH_ATM_Font_ATMScreen_Size55", sw / 2, 150, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			
			
			-- Portfolio Button
			local hovering = imgui.IsHovering( btn_x, 230, btn_w, btn_h )
			
			if hovering and pressing then
				draw.RoundedBox( 8, btn_x, 230, btn_w, btn_h, CH_ATM.Colors.Green )
				
				-- Draw new 3D2D
				self:CRYPTO_Portfolio()
			elseif hovering then
				draw.RoundedBox( 8, btn_x, 230, btn_w, btn_h, CH_ATM.Colors.GMSBlue )
			else
				draw.RoundedBox( 8, btn_x, 230, btn_w, btn_h, CH_ATM.Colors.DarkGray )
			end
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_portfolio )
			surface.DrawTexturedRect( 150, 240, 80, 80 )
			
			draw.SimpleText( CH_ATM.LangString( "Portfolio" ), "CH_ATM_Font_ATMScreen_Size55", sw / 2, 280, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			
			
			-- Send Crypto Button
			local hovering = imgui.IsHovering( btn_x, 350, btn_w, btn_h )
			
			if hovering and pressing then
				draw.RoundedBox( 8, btn_x, 360, btn_w, btn_h, CH_ATM.Colors.Green )
				
				-- Draw new 3D2D
				self:CRYPTO_SelectSendCrypto()
			elseif hovering then
				draw.RoundedBox( 8, btn_x, 360, btn_w, btn_h, CH_ATM.Colors.GMSBlue )
			else
				draw.RoundedBox( 8, btn_x, 360, btn_w, btn_h, CH_ATM.Colors.DarkGray )
			end
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_send_crypto )
			surface.DrawTexturedRect( 150, 370, 80, 80 )
			
			draw.SimpleText( CH_ATM.LangString( "Send Crypto" ), "CH_ATM_Font_ATMScreen_Size55", sw / 2, 410, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			
			
			-- History Button (only if SQL)
			if CH_CryptoCurrencies.Config.EnableSQL then
				local hovering = imgui.IsHovering( btn_x, 490, btn_w, btn_h )
				
				if hovering and pressing then
					draw.RoundedBox( 8, btn_x, 490, btn_w, btn_h, CH_ATM.Colors.Green )
					
					-- Draw new 3D2D
					self:CRYPTO_TransactionHistory()
				elseif hovering then
					draw.RoundedBox( 8, btn_x, 490, btn_w, btn_h, CH_ATM.Colors.GMSBlue )
				else
					draw.RoundedBox( 8, btn_x, 490, btn_w, btn_h, CH_ATM.Colors.DarkGray )
				end
				
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_history )
				surface.DrawTexturedRect( 150, 500, 80, 80 )
				
				draw.SimpleText( CH_ATM.LangString( "Transaction History" ), "CH_ATM_Font_ATMScreen_Size55", sw / 2, 540, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			
			
			-- Settings Button
			local hovering = imgui.IsHovering( 970, 570, 64, 64 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme( ply ) ].mat_settings )
			surface.DrawTexturedRect( 970, 570, 64, 64 )
			
			if hovering and pressing then
				self:GENERAL_UserSettings()
			end
			
			-- Back Button
			local hovering = imgui.IsHovering( 20, 605, 32, 32 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( mat_back )
			surface.DrawTexturedRect( 20, 605, 32, 32 )
			
			if hovering and pressing then
				-- Draw new 3D2D after loading screen
				self:GENERAL_HomePortal()
			end
			
			-- Draw curser
			imgui.xCursor( 0, 0, sw, sh )
			
			imgui.End3D2D()
		end
	end
end

--[[
	Show available cryptocurrencies
	Names, symbol, icon, prices, buy, sell
--]]
function ENT:CRYPTO_BrowseCurrencies()
	local ply = LocalPlayer()

	surface.PlaySound( "buttons/button17.wav" )
	
	-- Setup the amount of pages
	local amount_of_cryptos = #CH_CryptoCurrencies.CryptosCL
	self.PAGES_AmountOfPages = math.ceil( amount_of_cryptos / 8 )
	
	for i = 1, self.PAGES_AmountOfPages do
		-- Create the table for page
		self.PAGES_PageContent[ i ] = {}
	end
	
	-- Insert entries into their respective page
	local count = 0
	for k, crypto in ipairs( CH_CryptoCurrencies.CryptosCL ) do
		count = count + 1
		
		local page = math.ceil( count / 8 )
		
		table.insert( self.PAGES_PageContent[ page ], crypto )
	end
	
	self.Draw3D2DPage = function()
		if imgui.Entity3D2D( self, pos, ang, scale ) then
			local pressing = imgui.IsPressing()

			-- Top
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
			surface.DrawRect( 0, 0, sw, 50 )
			
			if CH_CryptoCurrencies and CH_CryptoCurrencies.Config.UseMoneyFromBankAccount then
				draw.SimpleText( CH_ATM.LangString( "Total Balance" ) ..": ".. CH_ATM.FormatMoney( CH_ATM.GetMoneyBankAccount( ply ) ), "CH_ATM_Font_ATMScreen_Size35", sw / 2, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( CH_ATM.LangString( "Wallet Balance" ) ..": ".. CH_ATM.FormatMoney( CH_ATM.GetMoney( ply ) ), "CH_ATM_Font_ATMScreen_Size35", sw / 2, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			
			draw.SimpleText( CH_ATM.LangString( "Browse Cryptocurrencies" ) .." (".. self.PAGES_CurrentPage .. "/".. self.PAGES_AmountOfPages ..")", "CH_ATM_Font_ATMScreen_Size45", sw / 2, 105, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			-- Exit button
			if CH_ATM.Config.ActivateWithCreditCard then
				local hovering = imgui.IsHovering( 1020, 10, 32, 32 )
				
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme( ply ) ].mat_exit_atm )
				surface.DrawTexturedRect( 1020, 10, 32, 32 )
				
				if hovering and pressing then
					-- Start net to pull out card and reset atm
					net.Start( "CH_ATM_Net_PullOutCreditCard" )
						net.WriteEntity( self )
					net.SendToServer()
				end
			end
			
			-- Pages of crypto
			if self.PAGES_PageContent[ self.PAGES_CurrentPage ] then
				for k, crypto in pairs( self.PAGES_PageContent[ self.PAGES_CurrentPage ] ) do
					local x_pos = -450
						local y_pos = 160

						local x_offset = 0
						if k <= 2 then
							x_offset = k * 500
							x_pos = x_pos + x_offset
						elseif k <= 4 then
							x_offset = ( k - 2 ) * 500
							x_pos = x_pos + x_offset
							
							y_pos = 260
						elseif k <= 6 then
							x_offset = ( k - 4 ) * 500
							x_pos = x_pos + x_offset
							
							y_pos = 360
						elseif k <= 8 then
							x_offset = ( k - 6 ) * 500
							x_pos = x_pos + x_offset
							
							y_pos = 460
						end
					
					-- Crypto BG
					draw.RoundedBox( 8, x_pos, y_pos, 450, 90, CH_ATM.Colors.DarkGray )
					
					-- Crypto Icon
					surface.SetDrawColor( color_white )
					surface.SetMaterial( crypto.Icon )
					surface.DrawTexturedRect( x_pos + 5, y_pos + 5, 80, 80 )
					
					-- Vertical seperator line
					surface.SetDrawColor( CH_CryptoCurrencies.Colors.WhiteAlpha )
					surface.DrawRect( x_pos + 90, y_pos + 10, 2.5, 70 )
					
					-- Vertical seperator line END
					surface.SetDrawColor( CH_CryptoCurrencies.Colors.WhiteAlpha )
					surface.DrawRect( x_pos + 440, y_pos + 10, 2.5, 70 )
					
					-- Horizontal seperator line
					surface.SetDrawColor( CH_CryptoCurrencies.Colors.WhiteAlpha )
					surface.DrawRect( x_pos + 97.5, y_pos + 45, 337.5, 2.5 )
					
					-- Crypto Name and Price
					draw.SimpleText( crypto.Name, "CH_ATM_Font_ATMScreen_Size35", x_pos + 97.5, y_pos + 25, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					
					surface.SetFont( "CH_ATM_Font_ATMScreen_Size35" )
					local x, y = surface.GetTextSize( crypto.Price )
					
					draw.SimpleText( crypto.Price, "CH_ATM_Font_ATMScreen_Size35", x_pos + 97.5, y_pos + 65, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					draw.SimpleText( CH_CryptoCurrencies.CurrencyAbbreviation(), "CH_CryptoCurrency_Font_Size6", x_pos + 97.5 + ( x + 5 ), y_pos + 70, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					
					-- Change in price
					local price_change = crypto.Change
					local price_change_color = CH_CryptoCurrencies.Colors.Green
					if price_change < 0 then
						price_change_color = CH_CryptoCurrencies.Colors.Red
					end
					local no_change = false
			
					surface.SetDrawColor( color_white )
					if price_change == 0 then
						no_change = true
					elseif price_change > 0 then
						surface.SetMaterial( CH_CryptoCurrencies.Materials.ArrowUpIcon )
					else
						surface.SetMaterial( CH_CryptoCurrencies.Materials.ArrowDownIcon )
					end
					if not no_change then
						surface.SetFont( "CH_ATM_Font_ATMScreen_Size35" )
						local x2, y2 = surface.GetTextSize( price_change .."%" )
						
						surface.DrawTexturedRect( x_pos + 410 - ( x2 ), y_pos + 55, 20, 20 )
						
						draw.SimpleText( price_change .."%", "CH_ATM_Font_ATMScreen_Size35", x_pos + 432.5, y_pos + 65, price_change_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
					end
					
					-- Player Owns Amount
					local player_owns = math.Round( ply.CH_CryptoCurrencies_Wallet[ crypto.Currency ].Amount, 7 )
					
					-- Get index of button/crypto
					local crypto_index = table.KeyFromValue( CH_CryptoCurrencies.CryptosCL, crypto )
					
					if player_owns > 0 then
						-- Buy Button
						local hovering = imgui.IsHovering( x_pos + 330, y_pos + 10, 50, 30 )
						
						if hovering and pressing then
							draw.RoundedBox( 8, x_pos + 330, y_pos + 10, 50, 30, CH_ATM.Colors.GMSBlue )
							
							-- Draw new 3D2D
							self:CRYPTO_BuyCryptoScreen( crypto_index )
						elseif hovering then
							draw.RoundedBox( 8, x_pos + 330, y_pos + 10, 50, 30, CH_ATM.Colors.GreenHovered )
						else
							draw.RoundedBox( 8, x_pos + 330, y_pos + 10, 50, 30, CH_ATM.Colors.Green )
						end
						
						draw.SimpleText( CH_CryptoCurrencies.LangString( "Buy" ), "CH_ATM_Font_ATMScreen_Size30", x_pos + 355, y_pos + 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					
						-- Sell Button
						local hovering = imgui.IsHovering( x_pos + 385, y_pos + 10, 50, 30 )
						
						if hovering and pressing then
							draw.RoundedBox( 8, x_pos + 385, y_pos + 10, 50, 30, CH_ATM.Colors.GMSBlue )
							
							-- Draw new 3D2D
							self:CRYPTO_SellCryptoScreen( crypto_index )
						elseif hovering then
							draw.RoundedBox( 8, x_pos + 385, y_pos + 10, 50, 30, CH_ATM.Colors.RedHovered )
						else
							draw.RoundedBox( 8, x_pos + 385, y_pos + 10, 50, 30, CH_ATM.Colors.Red )
						end
						
						draw.SimpleText( CH_CryptoCurrencies.LangString( "Sell" ), "CH_ATM_Font_ATMScreen_Size30", x_pos + 410, y_pos + 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					else
						-- Only Buy Button
						local hovering = imgui.IsHovering( x_pos + 330, y_pos + 10, 105, 30 )
						
						if hovering and pressing then
							draw.RoundedBox( 8, x_pos + 330, y_pos + 10, 105, 30, CH_ATM.Colors.GMSBlue )
							
							-- Draw new 3D2D
							self:CRYPTO_BuyCryptoScreen( crypto_index )
						elseif hovering then
							draw.RoundedBox( 8, x_pos + 330, y_pos + 10, 105, 30, CH_ATM.Colors.GreenHovered )
						else
							draw.RoundedBox( 8, x_pos + 330, y_pos + 10, 105, 30, CH_ATM.Colors.Green )
						end
						
						draw.SimpleText( CH_CryptoCurrencies.LangString( "Buy" ), "CH_ATM_Font_ATMScreen_Size30", x_pos + 385, y_pos + 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end
				end
				
				-- Change pages
				-- Left Page Button
				if self.PAGES_CurrentPage > 1 then
					local hovering = imgui.IsHovering( 40, 550, 50, 50 )
					
					surface.SetDrawColor( color_white )
					surface.SetMaterial( mat_page_back )
					surface.DrawTexturedRect( 40, 550, 50, 50 )
					
					if hovering and pressing then
						self.PAGES_CurrentPage = self.PAGES_CurrentPage - 1
					end
				end
				
				-- Right Page Button
				if self.PAGES_AmountOfPages > self.PAGES_CurrentPage then
					local hovering = imgui.IsHovering( 970, 550, 50, 50 )
					
					surface.SetDrawColor( color_white )
					surface.SetMaterial( mat_page_next )
					surface.DrawTexturedRect( 970, 550, 50, 50 )
					
					if hovering and pressing then
						self.PAGES_CurrentPage = self.PAGES_CurrentPage + 1
					end
				end
			end
			
			-- Back Button
			local hovering = imgui.IsHovering( 20, 605, 32, 32 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( mat_back )
			surface.DrawTexturedRect( 20, 605, 32, 32 )
			
			if hovering and pressing then
				-- Show bank home screen
				self:CRYPTO_HomeScreen()
				
				-- Reset page
				self.PAGES_CurrentPage = 1
			end
			
			-- Draw curser
			imgui.xCursor( 0, 0, sw, sh )
			
			imgui.End3D2D()
		end
	end
end

--[[
	Buy cryptocurrency from ATM
--]]
function ENT:CRYPTO_BuyCryptoScreen( crypto_to_buy )
	local ply = LocalPlayer()

	surface.PlaySound( "buttons/button17.wav" )
	
	self:GENERAL_KeyPad( "buy_crypto" )
	
	self.CRYPTO_Index = crypto_to_buy
	
	-- Setup variables
	local crypto = CH_CryptoCurrencies.CryptosCL[ self.CRYPTO_Index ]
	local player_owns = math.Round( ply.CH_CryptoCurrencies_Wallet[ crypto.Currency ].Amount, 7 )
	local player_money = CH_CryptoCurrencies.GetMoney( ply )
	
	if CH_CryptoCurrencies and CH_CryptoCurrencies.Config.UseMoneyFromBankAccount then
		player_money = CH_ATM.GetMoneyBankAccount( ply )
	end
	
	self.Draw3D2DPage = function()
		if imgui.Entity3D2D( self, pos, ang, scale ) then
			local pressing = imgui.IsPressing()

			-- Top
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
			surface.DrawRect( 0, 0, sw, 50 )
			
			draw.SimpleText( CH_CryptoCurrencies.LangString( "Buy" ) .." ".. crypto.Name, "CH_ATM_Font_ATMScreen_Size35", sw / 2, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			-- Exit button
			if CH_ATM.Config.ActivateWithCreditCard then
				local hovering = imgui.IsHovering( 1020, 10, 32, 32 )
				
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme( ply ) ].mat_exit_atm )
				surface.DrawTexturedRect( 1020, 10, 32, 32 )
				
				if hovering and pressing then
					-- Start net to pull out card and reset atm
					net.Start( "CH_ATM_Net_PullOutCreditCard" )
						net.WriteEntity( self )
					net.SendToServer()
				end
			end
			
			-- Coin Icon
			surface.SetDrawColor( color_white )
			surface.SetMaterial( crypto.Icon )
			surface.DrawTexturedRect( 100, 100, 200, 200 )
			
			--Coin Name & Price
			draw.SimpleText( crypto.Name, "CH_ATM_Font_ATMScreen_Size100", 315, 150, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			
			surface.SetFont( "CH_ATM_Font_ATMScreen_Size100" )
			local x, y = surface.GetTextSize( crypto.Price )
			
			draw.SimpleText( crypto.Price, "CH_ATM_Font_ATMScreen_Size100", 315, 250, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( CH_CryptoCurrencies.CurrencyAbbreviation(), "CH_ATM_Font_ATMScreen_Size60", 315 + ( x + 10 ), 260, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		
			
			-- LEFT ENTRY
			draw.RoundedBox( 8, 100, 400, 380, 80, color_white )
			
			-- Text above entry
			draw.SimpleText( CH_CryptoCurrencies.FormatMoney( player_money ), "CH_ATM_Font_ATMScreen_Size40", 100, 370, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

			-- Entry text from keypad
			draw.SimpleText( CH_CryptoCurrencies.FormatMoney( tonumber( self.CurrentInput ) ), "CH_ATM_Font_ATMScreen_Size50", 105, 440, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			
			-- CurrencyAbbreviation
			draw.SimpleText( CH_CryptoCurrencies.CurrencyAbbreviation(), "CH_ATM_Font_ATMScreen_Size50", 475, 440, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			
			
			
			-- RIGHT ENTRY
			draw.RoundedBox( 8, 580, 400, 380, 80, color_white )
			
			-- Text above entry
			draw.SimpleText( string.format( "%f", player_owns ) .." ".. crypto.Currency, "CH_ATM_Font_ATMScreen_Size40", 955, 370, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			
			-- Entry text from keypad
			self.CRYPTO_AmountToBuy = math.Round( ( tonumber( self.CurrentInput ) or 0 ) / crypto.Price, 7 )
			draw.SimpleText( string.format( "%f", self.CRYPTO_AmountToBuy ), "CH_ATM_Font_ATMScreen_Size50", 585, 440, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			
			-- CurrencyAbbreviation
			draw.SimpleText( crypto.Currency, "CH_ATM_Font_ATMScreen_Size50", 955, 440, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			
			
			
			
			-- Exchange Icon
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_CryptoCurrencies.Materials.ArrowExchangeIcon )
			surface.DrawTexturedRect( sw / 2 - 32, 410, 64, 64 )
			
			-- Back Button
			local hovering = imgui.IsHovering( 20, 605, 32, 32 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( mat_back )
			surface.DrawTexturedRect( 20, 605, 32, 32 )
			
			if hovering and pressing then
				-- Clear the keypad input
				self:KEYPAD_ResetInput()
				
				-- Show bank home screen
				self:CRYPTO_BrowseCurrencies()
				
				-- Remove keypad 3d2d
				self:KEYPAD_Clear3D2D()
			end
			
			-- Draw curser
			imgui.xCursor( 0, 0, sw, sh )
			
			imgui.End3D2D()
		end
	end
end

--[[
	Sell cryptocurrency from ATM
--]]
function ENT:CRYPTO_SellCryptoScreen( crypto_to_sell )
	local ply = LocalPlayer()

	surface.PlaySound( "buttons/button17.wav" )
	
	self:GENERAL_KeyPad( "sell_crypto" )
	
	self.CRYPTO_Index = crypto_to_sell
	
	-- Setup variables
	local crypto = CH_CryptoCurrencies.CryptosCL[ self.CRYPTO_Index ]
	local player_owns = math.Round( ply.CH_CryptoCurrencies_Wallet[ crypto.Currency ].Amount, 7 )
	local player_money = CH_CryptoCurrencies.GetMoney( ply )
	
	if CH_CryptoCurrencies and CH_CryptoCurrencies.Config.UseMoneyFromBankAccount then
		player_money = CH_ATM.GetMoneyBankAccount( ply )
	end
	
	self.Draw3D2DPage = function()
		if imgui.Entity3D2D( self, pos, ang, scale ) then
			local pressing = imgui.IsPressing()

			-- Top
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
			surface.DrawRect( 0, 0, sw, 50 )
			
			draw.SimpleText( CH_CryptoCurrencies.LangString( "Sell" ) .." ".. crypto.Name, "CH_ATM_Font_ATMScreen_Size35", sw / 2, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			-- Exit button
			if CH_ATM.Config.ActivateWithCreditCard then
				local hovering = imgui.IsHovering( 1020, 10, 32, 32 )
				
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme( ply ) ].mat_exit_atm )
				surface.DrawTexturedRect( 1020, 10, 32, 32 )
				
				if hovering and pressing then
					-- Start net to pull out card and reset atm
					net.Start( "CH_ATM_Net_PullOutCreditCard" )
						net.WriteEntity( self )
					net.SendToServer()
				end
			end
			
			-- Coin Icon
			surface.SetDrawColor( color_white )
			surface.SetMaterial( crypto.Icon )
			surface.DrawTexturedRect( 100, 100, 200, 200 )
			
			--Coin Name & Price
			draw.SimpleText( crypto.Name, "CH_ATM_Font_ATMScreen_Size100", 315, 150, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			
			surface.SetFont( "CH_ATM_Font_ATMScreen_Size100" )
			local x, y = surface.GetTextSize( crypto.Price )
			
			draw.SimpleText( crypto.Price, "CH_ATM_Font_ATMScreen_Size100", 315, 250, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( CH_CryptoCurrencies.CurrencyAbbreviation(), "CH_ATM_Font_ATMScreen_Size60", 315 + ( x + 10 ), 260, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		
			
			-- LEFT ENTRY
			draw.RoundedBox( 8, 100, 400, 380, 80, color_white )
			
			-- Text above entry
			draw.SimpleText( string.format( "%f", player_owns ) .." ".. crypto.Currency, "CH_ATM_Font_ATMScreen_Size40", 100, 370, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

			-- Entry text from keypad
			draw.SimpleText( self.CurrentInput or 0, "CH_ATM_Font_ATMScreen_Size50", 105, 440, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			
			-- The currency to trade
			draw.SimpleText( crypto.Currency, "CH_ATM_Font_ATMScreen_Size50", 475, 440, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			
			-- RIGHT ENTRY
			draw.RoundedBox( 8, 580, 400, 380, 80, color_white )
			
			-- Text above entry
			draw.SimpleText( CH_CryptoCurrencies.FormatMoney( player_money ), "CH_ATM_Font_ATMScreen_Size40", 955, 370, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			
			-- Amount to earn from trade
			self.CRYPTO_AmountToSell = tonumber( self.CurrentInput ) or 0
			local earn_from_trade = math.Round( ( self.CRYPTO_AmountToSell ) * crypto.Price )
			
			draw.SimpleText( CH_ATM.FormatMoney( earn_from_trade ), "CH_ATM_Font_ATMScreen_Size50", 585, 440, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			
			-- CurrencyAbbreviation
			draw.SimpleText( CH_CryptoCurrencies.CurrencyAbbreviation(), "CH_ATM_Font_ATMScreen_Size50", 955, 440, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			
			
			
			
			-- Exchange Icon
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_CryptoCurrencies.Materials.ArrowExchangeIcon )
			surface.DrawTexturedRect( sw / 2 - 32, 410, 64, 64 )
			
			-- Back Button
			local hovering = imgui.IsHovering( 20, 605, 32, 32 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( mat_back )
			surface.DrawTexturedRect( 20, 605, 32, 32 )
			
			if hovering and pressing then
				-- Clear the keypad input
				self:KEYPAD_ResetInput()
				
				-- Show bank home screen
				self:CRYPTO_BrowseCurrencies()
				
				-- Remove keypad 3d2d
				self:KEYPAD_Clear3D2D()
			end
			
			-- Draw curser
			imgui.xCursor( 0, 0, sw, sh )
			
			imgui.End3D2D()
		end
	end
end

--[[
	Show crypto portfolio
--]]
function ENT:CRYPTO_Portfolio()
	local ply = LocalPlayer()
	local TotalBalance = 0

	surface.PlaySound( "buttons/button17.wav" )

	-- Setup the amount of pages
	local amount_of_cryptos = 0
	for k, crypto in pairs( CH_CryptoCurrencies.CryptosCL ) do
		local prefix = crypto.Currency
		local player_owns = math.Round( ply.CH_CryptoCurrencies_Wallet[ prefix ].Amount, 7 )
		
		if CH_CryptoCurrencies.CryptoIconsCL[ prefix ] and player_owns > 0 then
			amount_of_cryptos = amount_of_cryptos + 1
		end
	end

	self.PAGES_AmountOfPages = math.ceil( amount_of_cryptos / 8 )
	
	for i = 1, self.PAGES_AmountOfPages do
		-- Create the table for page
		self.PAGES_PageContent[ i ] = {}
	end
	
	-- Insert entries into their respective page
	local count = 0
	for k, crypto in ipairs( CH_CryptoCurrencies.CryptosCL ) do
		local prefix = crypto.Currency
		local player_owns = math.Round( ply.CH_CryptoCurrencies_Wallet[ prefix ].Amount, 7 )
		
		if CH_CryptoCurrencies.CryptoIconsCL[ prefix ] and player_owns > 0 then
			local crypto_worth = math.Round( player_owns * crypto.Price )
			-- Update total balance for the frame
			TotalBalance = TotalBalance + crypto_worth
		
			count = count + 1
			
			local page = math.ceil( count / 8 )
			
			table.insert( self.PAGES_PageContent[ page ], crypto )
		end
	end
	
	self.Draw3D2DPage = function()
		if imgui.Entity3D2D( self, pos, ang, scale ) then
			local pressing = imgui.IsPressing()
			
			-- Top
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
			surface.DrawRect( 0, 0, sw, 50 )
			
			draw.SimpleText( CH_ATM.LangString( "Crypto Worth" ) ..": ".. CH_CryptoCurrencies.FormatMoney( TotalBalance ), "CH_ATM_Font_ATMScreen_Size35", sw / 2, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			-- Exit button
			if CH_ATM.Config.ActivateWithCreditCard then
				local hovering = imgui.IsHovering( 1020, 10, 32, 32 )
				
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme( ply ) ].mat_exit_atm )
				surface.DrawTexturedRect( 1020, 10, 32, 32 )
				
				if hovering and pressing then
					-- Start net to pull out card and reset atm
					net.Start( "CH_ATM_Net_PullOutCreditCard" )
						net.WriteEntity( self )
					net.SendToServer()
				end
			end
			
			if self.PAGES_AmountOfPages > 0 then
				draw.SimpleText( CH_CryptoCurrencies.LangString( "Portfolio" ) .." (".. self.PAGES_CurrentPage .. "/".. self.PAGES_AmountOfPages ..")", "CH_ATM_Font_ATMScreen_Size45", sw / 2, 105, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

				-- Pages of crypto
				if self.PAGES_PageContent[ self.PAGES_CurrentPage ] then
					for k, crypto in pairs( self.PAGES_PageContent[ self.PAGES_CurrentPage ] ) do
						local x_pos = -450
						local y_pos = 160

						local x_offset = 0
						if k <= 2 then
							x_offset = k * 500
							x_pos = x_pos + x_offset
						elseif k <= 4 then
							x_offset = ( k - 2 ) * 500
							x_pos = x_pos + x_offset
							
							y_pos = 260
						elseif k <= 6 then
							x_offset = ( k - 4 ) * 500
							x_pos = x_pos + x_offset
							
							y_pos = 360
						elseif k <= 8 then
							x_offset = ( k - 6 ) * 500
							x_pos = x_pos + x_offset
							
							y_pos = 460
						end
						
						-- Crypto BG
						draw.RoundedBox( 8, x_pos, y_pos, 450, 90, CH_ATM.Colors.DarkGray )
						
						-- Crypto Icon
						surface.SetDrawColor( color_white )
						surface.SetMaterial( crypto.Icon )
						surface.DrawTexturedRect( x_pos + 5, y_pos + 5, 80, 80 )
						
						-- Vertical seperator line
						surface.SetDrawColor( CH_CryptoCurrencies.Colors.WhiteAlpha )
						surface.DrawRect( x_pos + 90, y_pos + 10, 2.5, 70 )
						
						-- Vertical seperator line END
						surface.SetDrawColor( CH_CryptoCurrencies.Colors.WhiteAlpha )
						surface.DrawRect( x_pos + 440, y_pos + 10, 2.5, 70 )
						
						-- Horizontal seperator line
						surface.SetDrawColor( CH_CryptoCurrencies.Colors.WhiteAlpha )
						surface.DrawRect( x_pos + 97.5, y_pos + 45, 337.5, 2.5 )
						
						-- Player Owns Amount
						local player_owns = math.Round( ply.CH_CryptoCurrencies_Wallet[ crypto.Currency ].Amount, 7 )
						
						-- Crypto Name and Owned Amount
						draw.SimpleText( crypto.Name, "CH_ATM_Font_ATMScreen_Size35", x_pos + 97.5, y_pos + 25, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
						
						surface.SetFont( "CH_ATM_Font_ATMScreen_Size35" )
						local x, y = surface.GetTextSize( string.format( "%f", player_owns ) )
						
						draw.SimpleText( string.format( "%f", player_owns ), "CH_ATM_Font_ATMScreen_Size35", x_pos + 97.5, y_pos + 65, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
						draw.SimpleText( crypto.Currency, "CH_CryptoCurrency_Font_Size6", x_pos + 97.5 + ( x + 5 ), y_pos + 70, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

						-- Crypto Worth
						draw.SimpleText( CH_CryptoCurrencies.LangString( "Worth" ), "CH_ATM_Font_ATMScreen_Size35", x_pos + 432.5, y_pos + 25, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
						
						local crypto_worth = math.Round( player_owns * crypto.Price )
						draw.SimpleText( string.Comma( crypto_worth ), "CH_ATM_Font_ATMScreen_Size35", x_pos + 405, y_pos + 65, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
						draw.SimpleText( CH_CryptoCurrencies.CurrencyAbbreviation(), "CH_CryptoCurrency_Font_Size6", x_pos + 432.5, y_pos + 70, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
					end
					
					-- Change pages
					-- Left Page Button
					if self.PAGES_CurrentPage > 1 then
						local hovering = imgui.IsHovering( 40, 550, 50, 50 )
						
						surface.SetDrawColor( color_white )
						surface.SetMaterial( mat_page_back )
						surface.DrawTexturedRect( 40, 550, 50, 50 )
						
						if hovering and pressing then
							self.PAGES_CurrentPage = self.PAGES_CurrentPage - 1
						end
					end
					
					-- Right Page Button
					if self.PAGES_AmountOfPages > self.PAGES_CurrentPage then
						local hovering = imgui.IsHovering( 970, 550, 50, 50 )
						
						surface.SetDrawColor( color_white )
						surface.SetMaterial( mat_page_next )
						surface.DrawTexturedRect( 970, 550, 50, 50 )
						
						if hovering and pressing then
							self.PAGES_CurrentPage = self.PAGES_CurrentPage + 1
						end
					end
				end
			else -- Empty portfolio
				-- Draw icon
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_no_cryptos )
				surface.DrawTexturedRect( sw / 2 - 128, 250 - 128, 256, 256 )

				-- Browse Cryptocurrencies Button
				local hovering = imgui.IsHovering( sw / 2 - 400, 440, 800, 100 )
				
				if hovering and pressing then
					draw.RoundedBox( 8, sw / 2 - 400, 440, 800, 100, CH_ATM.Colors.Green )
					
					-- Draw new 3D2D
					self:CRYPTO_BrowseCurrencies()
				elseif hovering then
					draw.RoundedBox( 8, sw / 2 - 400, 440, 800, 100, CH_ATM.Colors.GMSBlue )
				else
					draw.RoundedBox( 8, sw / 2 - 400, 440, 800, 100, CH_ATM.Colors.DarkGray )
				end
				
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_cryptos )
				surface.DrawTexturedRect( 150, 450, 80, 80 )
				
				draw.SimpleText( CH_ATM.LangString( "Browse Cryptocurrencies" ), "CH_ATM_Font_ATMScreen_Size55", sw / 2, 490, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			
			-- Back Button
			local hovering = imgui.IsHovering( 20, 605, 32, 32 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( mat_back )
			surface.DrawTexturedRect( 20, 605, 32, 32 )
			
			if hovering and pressing then
				-- Show bank home screen
				self:CRYPTO_HomeScreen()
				
				-- Reset page
				self.PAGES_CurrentPage = 1
			end
			
			-- Draw curser
			imgui.xCursor( 0, 0, sw, sh )
			
			imgui.End3D2D()
		end
	end
end

--[[
	Show select send crypto page
--]]
function ENT:CRYPTO_SelectSendCrypto()
	local ply = LocalPlayer()

	surface.PlaySound( "buttons/button17.wav" )

	-- Setup the amount of pages
	local amount_of_cryptos = 0
	for k, crypto in pairs( CH_CryptoCurrencies.CryptosCL ) do
		local prefix = crypto.Currency
		local player_owns = math.Round( ply.CH_CryptoCurrencies_Wallet[ prefix ].Amount, 7 )
		
		if CH_CryptoCurrencies.CryptoIconsCL[ prefix ] and player_owns > 0 then
			amount_of_cryptos = amount_of_cryptos + 1
		end
	end

	self.PAGES_AmountOfPages = math.ceil( amount_of_cryptos / 8 )
	
	for i = 1, self.PAGES_AmountOfPages do
		-- Create the table for page
		self.PAGES_PageContent[ i ] = {}
	end
	
	-- Insert entries into their respective page
	local count = 0
	for k, crypto in ipairs( CH_CryptoCurrencies.CryptosCL ) do
		local prefix = crypto.Currency
		local player_owns = math.Round( ply.CH_CryptoCurrencies_Wallet[ prefix ].Amount, 7 )
		
		if CH_CryptoCurrencies.CryptoIconsCL[ prefix ] and player_owns > 0 then
			count = count + 1
			
			local page = math.ceil( count / 8 )
			
			table.insert( self.PAGES_PageContent[ page ], crypto )
		end
	end
	
	self.Draw3D2DPage = function()
		if imgui.Entity3D2D( self, pos, ang, scale ) then
			local pressing = imgui.IsPressing()
			
			-- Top
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
			surface.DrawRect( 0, 0, sw, 50 )
			
			draw.SimpleText( CH_ATM.LangString( "Send Crypto" ), "CH_ATM_Font_ATMScreen_Size35", sw / 2, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			-- Exit button
			if CH_ATM.Config.ActivateWithCreditCard then
				local hovering = imgui.IsHovering( 1020, 10, 32, 32 )
				
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme( ply ) ].mat_exit_atm )
				surface.DrawTexturedRect( 1020, 10, 32, 32 )
				
				if hovering and pressing then
					-- Start net to pull out card and reset atm
					net.Start( "CH_ATM_Net_PullOutCreditCard" )
						net.WriteEntity( self )
					net.SendToServer()
				end
			end
			
			if self.PAGES_AmountOfPages > 0 then
				draw.SimpleText( CH_CryptoCurrencies.LangString( "Select Crypto" ) .." (".. self.PAGES_CurrentPage .. "/".. self.PAGES_AmountOfPages ..")", "CH_ATM_Font_ATMScreen_Size45", sw / 2, 105, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

				-- Pages of crypto
				if self.PAGES_PageContent[ self.PAGES_CurrentPage ] then
					for k, crypto in pairs( self.PAGES_PageContent[ self.PAGES_CurrentPage ] ) do
						local x_pos = -195
						local y_pos = 160

						local x_offset = 0
						if k <= 4 then
							x_offset = k * 245
							x_pos = x_pos + x_offset
						elseif k <= 8 then
							x_offset = ( k - 4 ) * 245
							x_pos = x_pos + x_offset
							
							y_pos = 330
						end
						
						local hovering = imgui.IsHovering( x_pos, y_pos, 220, 150 )
						
						-- Crypto BG
						if hovering and pressing then
							draw.RoundedBox( 8, x_pos, y_pos, 220, 150, CH_ATM.Colors.Green )
							
							self:CRYPTO_SendCrypto( table.KeyFromValue( CH_CryptoCurrencies.CryptosCL, crypto ) )
						elseif hovering then
							draw.RoundedBox( 8, x_pos, y_pos, 220, 150, CH_ATM.Colors.GMSBlue )
						else
							draw.RoundedBox( 8, x_pos, y_pos, 220, 150, CH_ATM.Colors.DarkGray )
						end
						
						-- Crypto Icon
						surface.SetDrawColor( color_white )
						surface.SetMaterial( crypto.Icon )
						surface.DrawTexturedRect( x_pos + 60, y_pos + 5, 110, 110 )
						
						-- Crypto Name and Owned Amount
						draw.SimpleText( crypto.Name, "CH_ATM_Font_ATMScreen_Size35", x_pos + 112.5, y_pos + 130, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end
					
					-- Change pages
					-- Left Page Button
					if self.PAGES_CurrentPage > 1 then
						local hovering = imgui.IsHovering( 40, 485, 50, 50 )
						
						surface.SetDrawColor( color_white )
						surface.SetMaterial( mat_page_back )
						surface.DrawTexturedRect( 40, 485, 50, 50 )
						
						if hovering and pressing then
							self.PAGES_CurrentPage = self.PAGES_CurrentPage - 1
						end
					end
					
					-- Right Page Button
					if self.PAGES_AmountOfPages > self.PAGES_CurrentPage then
						local hovering = imgui.IsHovering( 970, 485, 50, 50 )
						
						surface.SetDrawColor( color_white )
						surface.SetMaterial( mat_page_next )
						surface.DrawTexturedRect( 970, 485, 50, 50 )
						
						if hovering and pressing then
							self.PAGES_CurrentPage = self.PAGES_CurrentPage + 1
						end
					end
				end
			else -- Empty portfolio
				-- Draw icon
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_no_cryptos )
				surface.DrawTexturedRect( sw / 2 - 128, 250 - 128, 256, 256 )

				-- Browse Cryptocurrencies Button
				local hovering = imgui.IsHovering( sw / 2 - 400, 440, 800, 100 )
				
				if hovering and pressing then
					draw.RoundedBox( 8, sw / 2 - 400, 440, 800, 100, CH_ATM.Colors.Green )
					
					-- Draw new 3D2D
					self:CRYPTO_BrowseCurrencies()
				elseif hovering then
					draw.RoundedBox( 8, sw / 2 - 400, 440, 800, 100, CH_ATM.Colors.GMSBlue )
				else
					draw.RoundedBox( 8, sw / 2 - 400, 440, 800, 100, CH_ATM.Colors.DarkGray )
				end
				
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_cryptos )
				surface.DrawTexturedRect( 150, 450, 80, 80 )
				
				draw.SimpleText( CH_ATM.LangString( "Browse Cryptocurrencies" ), "CH_ATM_Font_ATMScreen_Size55", sw / 2, 490, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			
			-- Back Button
			local hovering = imgui.IsHovering( 20, 605, 32, 32 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( mat_back )
			surface.DrawTexturedRect( 20, 605, 32, 32 )
			
			if hovering and pressing then
				-- Show bank home screen
				self:CRYPTO_HomeScreen()
				
				-- Reset page
				self.PAGES_CurrentPage = 1
			end
			
			-- Draw curser
			imgui.xCursor( 0, 0, sw, sh )
			
			imgui.End3D2D()
		end
	end
end

--[[
	Show send crypto page
--]]
function ENT:CRYPTO_SendCrypto( crypto_to_send )
	local ply = LocalPlayer()

	surface.PlaySound( "buttons/button17.wav" )
	
	self:GENERAL_KeyPad( "send_crypto" )
	self.CRYPTO_Index = crypto_to_send
	
	local ply = LocalPlayer()
	
	-- Setup the amount of pages (exclude ourself from the calculation)
	local amount_of_players = #player.GetAll() - 1
	self.PAGES_AmountOfPages = math.ceil( amount_of_players / 15 )
	
	for i = 1, self.PAGES_AmountOfPages do
		-- Create the table for page
		self.PAGES_PageContent[ i ] = {}
	end
	
	-- Insert entries into their respective page (exclude ourself again)
	local count = 0
	for k, v in ipairs( player.GetAll() ) do
		if ply != v then
			count = count + 1
			
			local page = math.ceil( count / 15 )
			
			table.insert( self.PAGES_PageContent[ page ], v )
		end
	end
	
	self.Draw3D2DPage = function()
		if imgui.Entity3D2D( self, pos, ang, scale ) then
			local pressing = imgui.IsPressing()

			-- Top
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
			surface.DrawRect( 0, 0, sw, 50 )
			
			local crypto_prefix_to_send = CH_CryptoCurrencies.CryptosCL[ self.CRYPTO_Index ].Currency
			
			local selected_total_balance = string.format( "%f", ply.CH_CryptoCurrencies_Wallet[ crypto_prefix_to_send ].Amount )
			draw.SimpleText( CH_ATM.LangString( "Total Balance" ) ..": ".. selected_total_balance .." ".. crypto_prefix_to_send, "CH_ATM_Font_ATMScreen_Size35", sw / 2, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			if not self.PAGES_SelectedOption then
				draw.SimpleText( CH_ATM.LangString( "Select Player" ), "CH_ATM_Font_ATMScreen_Size55", sw / 2, 105, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( CH_ATM.LangString( "Sending" ) .." ".. self.CurrentInput .." ".. crypto_prefix_to_send .." ".. CH_ATM.LangString( "to" ) .." ".. self.PAGES_SelectedOption:Nick(), "CH_ATM_Font_ATMScreen_Size45", sw / 2, 105, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			
			-- Exit button
			if CH_ATM.Config.ActivateWithCreditCard then
				local hovering = imgui.IsHovering( 1020, 10, 32, 32 )
				
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme( ply ) ].mat_exit_atm )
				surface.DrawTexturedRect( 1020, 10, 32, 32 )
				
				if hovering and pressing then
					-- Start net to pull out card and reset atm
					net.Start( "CH_ATM_Net_PullOutCreditCard" )
						net.WriteEntity( self )
					net.SendToServer()
				end
			end
			
			-- Pages of players
			if self.PAGES_PageContent[ self.PAGES_CurrentPage ] then

				for k, button in pairs( self.PAGES_PageContent[ self.PAGES_CurrentPage ] ) do
					local x_pos = -295
					local y_pos = 160

					local y_offset = 0
					if k <= 3 then
						y_offset = k * 335
						x_pos = x_pos + y_offset
					elseif k <= 6 then
						y_offset = ( k - 3 ) * 335
						x_pos = x_pos + y_offset
						
						y_pos = 225
					elseif k <= 9 then
						y_offset = ( k - 6 ) * 335
						x_pos = x_pos + y_offset
						
						y_pos = 290
					elseif k <= 12 then
						y_offset = ( k - 9 ) * 335
						x_pos = x_pos + y_offset
						
						y_pos = 355
					elseif k <= 15 then
						y_offset = ( k - 12 ) * 335
						x_pos = x_pos + y_offset
						
						y_pos = 420
					end
					
					local hovering = imgui.IsHovering( x_pos, y_pos, 300, 50 )
					
					if hovering and pressing and IsValid( button ) then
						self.PAGES_SelectedOption = button
					elseif hovering then
						draw.RoundedBox( 8, x_pos, y_pos, 300, 50, CH_ATM.Colors.GMSBlue )
					else
						draw.RoundedBox( 8, x_pos, y_pos, 300, 50, CH_ATM.Colors.DarkGray )
					end
					
					local ply_name = ""
					if IsValid( button ) then
						ply_name = button:Nick()
					else
						ply_name = CH_ATM.LangString( "Disconnected Player" )
					end
					if string.len( ply_name ) > 18 then
						ply_name = string.Left( ply_name, 18 ) ..".."
					end
					draw.SimpleText( ply_name, "CH_ATM_Font_ATMScreen_Size35", x_pos + 20, y_pos + 25, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end
				
				-- Change pages
				-- Left Page Button
				if self.PAGES_CurrentPage > 1 then
					local hovering = imgui.IsHovering( 40, 475, 50, 50 )
					
					surface.SetDrawColor( color_white )
					surface.SetMaterial( mat_page_back )
					surface.DrawTexturedRect( 40, 475, 50, 50 )
					
					if hovering and pressing then
						self.PAGES_CurrentPage = self.PAGES_CurrentPage - 1
					end
				end
				
				-- Right Page Button
				if self.PAGES_AmountOfPages > self.PAGES_CurrentPage then
					local hovering = imgui.IsHovering( 970, 475, 50, 50 )
					
					surface.SetDrawColor( color_white )
					surface.SetMaterial( mat_page_next )
					surface.DrawTexturedRect( 970, 475, 50, 50 )
					
					if hovering and pressing then
						self.PAGES_CurrentPage = self.PAGES_CurrentPage + 1
					end
				end
			end

			-- Fake text entry field
			self.CRYPTO_AmountToSend = tonumber( self.CurrentInput ) or 0
			draw.RoundedBox( 8, sw / 2 - 320, 510, 640, 80, color_white )
			
			if #self.CurrentInput <= 0 then
				draw.SimpleText( CH_ATM.LangString( "Enter the amount using the keypad" ), "CH_ATM_Font_ATMScreen_Size40", 230, 550, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( self.CurrentInput, "CH_ATM_Font_ATMScreen_Size40", 230, 550, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end
			
			-- Back Button
			local hovering = imgui.IsHovering( 20, 605, 32, 32 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( mat_back )
			surface.DrawTexturedRect( 20, 605, 32, 32 )
			
			if hovering and pressing then
				-- Clear the keypad input
				self:KEYPAD_ResetInput()
				
				-- Show bank home screen
				self:CRYPTO_SelectSendCrypto()
				
				-- Remove keypad 3d2d
				self:KEYPAD_Clear3D2D()
				
				-- Reset page
				self.PAGES_CurrentPage = 1
			end
			
			-- Draw curser
			imgui.xCursor( 0, 0, sw, sh )
			
			imgui.End3D2D()
		end
	end
end

--[[
	Show crypto trading history
--]]
function ENT:CRYPTO_TransactionHistory()
	local ply = LocalPlayer()

	surface.PlaySound( "buttons/button17.wav" )
	
	-- Setup the amount of pages
	local amount_of_transactions = #ply.CH_CryptoCurrencies_Transactions
	self.PAGES_AmountOfPages = math.ceil( amount_of_transactions / 8 )
	
	for i = 1, self.PAGES_AmountOfPages do
		-- Create the table for page
		self.PAGES_PageContent[ i ] = {}
	end
	
	-- Insert entries into their respective page
	local count = 0
	for k, trans in ipairs( ply.CH_CryptoCurrencies_Transactions ) do
		count = count + 1
		
		local page = math.ceil( count / 8 )
		
		table.insert( self.PAGES_PageContent[ page ], trans )
	end
	
	self.Draw3D2DPage = function()
		if imgui.Entity3D2D( self, pos, ang, scale ) then
			local pressing = imgui.IsPressing()

			-- Top
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
			surface.DrawRect( 0, 0, sw, 50 )
			
			draw.SimpleText( CH_ATM.LangString( "Total Balance" ) ..": ".. CH_ATM.FormatMoney( CH_ATM.GetMoneyBankAccount( ply ) ), "CH_ATM_Font_ATMScreen_Size35", sw / 2, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			draw.SimpleText( CH_ATM.LangString( "Transaction History" ) .." (".. self.PAGES_CurrentPage .. "/".. self.PAGES_AmountOfPages ..")", "CH_ATM_Font_ATMScreen_Size45", sw / 2, 105, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			-- Exit button
			if CH_ATM.Config.ActivateWithCreditCard then
				local hovering = imgui.IsHovering( 1020, 10, 32, 32 )
				
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme( ply ) ].mat_exit_atm )
				surface.DrawTexturedRect( 1020, 10, 32, 32 )
				
				if hovering and pressing then
					-- Start net to pull out card and reset atm
					net.Start( "CH_ATM_Net_PullOutCreditCard" )
						net.WriteEntity( self )
					net.SendToServer()
				end
			end
			
			-- Pages of transactions
			if self.PAGES_PageContent[ self.PAGES_CurrentPage ] then
				for k, trans in pairs( self.PAGES_PageContent[ self.PAGES_CurrentPage ] ) do
					local x_pos = -450
						local y_pos = 160

						local x_offset = 0
						if k <= 2 then
							x_offset = k * 500
							x_pos = x_pos + x_offset
						elseif k <= 4 then
							x_offset = ( k - 2 ) * 500
							x_pos = x_pos + x_offset
							
							y_pos = 260
						elseif k <= 6 then
							x_offset = ( k - 4 ) * 500
							x_pos = x_pos + x_offset
							
							y_pos = 360
						elseif k <= 8 then
							x_offset = ( k - 6 ) * 500
							x_pos = x_pos + x_offset
							
							y_pos = 460
						end
					
					-- BG
					draw.RoundedBox( 8, x_pos, y_pos, 450, 90, CH_ATM.Colors.DarkGray )
					
					
					-- Icon
					surface.SetDrawColor( color_white )
					if trans.Action == "buy" then
						surface.SetMaterial( buy_icon )
					else
						surface.SetMaterial( sold_icon )
					end
					surface.DrawTexturedRect( x_pos + 100, y_pos + 11, 28, 28 )
					
					-- Buy/Sold Icon
					surface.SetDrawColor( color_white )
					surface.SetMaterial( CH_CryptoCurrencies.CryptoIconsCL[ trans.Crypto ].Icon )
					surface.DrawTexturedRect( x_pos + 5, y_pos + 5, 80, 80 )
					
					-- Vertical seperator line
					surface.SetDrawColor( CH_ATM.Colors.WhiteAlpha )
					surface.DrawRect( x_pos + 90, y_pos + 10, 2.5, 70 )
					
					-- Vertical seperator line END
					surface.SetDrawColor( CH_ATM.Colors.WhiteAlpha )
					surface.DrawRect( x_pos + 440, y_pos + 10, 2.5, 70 )
					
					-- Horizontal seperator line
					surface.SetDrawColor( CH_ATM.Colors.WhiteAlpha )
					surface.DrawRect( x_pos + 97.5, y_pos + 45, 337.5, 2.5 )
					
					-- Name of coin
					draw.SimpleText( trans.Name, "CH_ATM_Font_ATMScreen_Size35", x_pos + 135, y_pos + 25, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					
					-- Cost or Earned
					if trans.Action == "buy" then
						draw.SimpleText( "-".. CH_CryptoCurrencies.FormatMoney( trans.Price ), "CH_ATM_Font_ATMScreen_Size35", x_pos + 432, y_pos + 25, CH_CryptoCurrencies.Colors.Red, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( "+".. CH_CryptoCurrencies.FormatMoney( trans.Price ), "CH_ATM_Font_ATMScreen_Size35", x_pos + 432, y_pos + 25, CH_CryptoCurrencies.Colors.Green, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
					end
					
					surface.SetFont( "CH_ATM_Font_ATMScreen_Size35" )
					local x, y = surface.GetTextSize( string.format( "%f", trans.Amount ) )
					
					draw.SimpleText( string.format( "%f", trans.Amount ), "CH_ATM_Font_ATMScreen_Size35", x_pos + 97.5, y_pos + 65, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					draw.SimpleText( trans.Crypto, "CH_ATM_Font_ATMScreen_Size20", x_pos + 97.5 + ( x + 3 ), y_pos + 70, CH_ATM.Colors.WhiteAlpha2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					
					
					draw.SimpleText( trans.TimeStamp, "CH_ATM_Font_ATMScreen_Size20", x_pos + 432, y_pos + 70, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
					
				end
				
				-- Change pages
				-- Left Page Button
				if self.PAGES_CurrentPage > 1 then
					local hovering = imgui.IsHovering( 40, 550, 50, 50 )
					
					surface.SetDrawColor( color_white )
					surface.SetMaterial( mat_page_back )
					surface.DrawTexturedRect( 40, 550, 50, 50 )
					
					if hovering and pressing then
						self.PAGES_CurrentPage = self.PAGES_CurrentPage - 1
					end
				end
				
				-- Right Page Button
				if self.PAGES_AmountOfPages > self.PAGES_CurrentPage then
					local hovering = imgui.IsHovering( 970, 550, 50, 50 )
					
					surface.SetDrawColor( color_white )
					surface.SetMaterial( mat_page_next )
					surface.DrawTexturedRect( 970, 550, 50, 50 )
					
					if hovering and pressing then
						self.PAGES_CurrentPage = self.PAGES_CurrentPage + 1
					end
				end
			end
			
			-- Back Button
			local hovering = imgui.IsHovering( 20, 605, 32, 32 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( mat_back )
			surface.DrawTexturedRect( 20, 605, 32, 32 )
			
			if hovering and pressing then
				-- Show bank home screen
				self:CRYPTO_HomeScreen()
				
				-- Reset page
				self.PAGES_CurrentPage = 1
			end
			
			-- Draw curser
			imgui.xCursor( 0, 0, sw, sh )
			
			imgui.End3D2D()
		end
	end
end






--[[
	Home for regular bank account
--]]
function ENT:BANK_HomeScreen()
	local ply = LocalPlayer()

	surface.PlaySound( "buttons/button17.wav" )
	
	self.Draw3D2DPage = function()
		if imgui.Entity3D2D( self, pos, ang, scale ) then
			local pressing = imgui.IsPressing()

			-- Top
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
			surface.DrawRect( 0, 0, sw, 50 )
			
			draw.SimpleText( CH_ATM.LangString( "Total Balance" ) ..": ".. CH_ATM.FormatMoney( CH_ATM.GetMoneyBankAccount( ply ) ), "CH_ATM_Font_ATMScreen_Size35", sw / 2, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			-- Exit button
			if CH_ATM.Config.ActivateWithCreditCard then
				local hovering = imgui.IsHovering( 1020, 10, 32, 32 )
				
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme( ply ) ].mat_exit_atm )
				surface.DrawTexturedRect( 1020, 10, 32, 32 )
				
				if hovering and pressing then
					-- Start net to pull out card and reset atm
					net.Start( "CH_ATM_Net_PullOutCreditCard" )
						net.WriteEntity( self )
					net.SendToServer()
				end
			end
			
			
			-- Cache some button sizes
			local btn_x = sw / 2 - 400
			local btn_w = 800
			local btn_h = 100
			
			
			
			
			-- Deposit Button
			local hovering = imgui.IsHovering( btn_x, 100, btn_w, btn_h )
			
			if hovering and pressing then
				draw.RoundedBox( 8, btn_x, 100, btn_w, btn_h, CH_ATM.Colors.Green )
				
				-- Draw new 3D2D
				self:BANK_DepositBank()
			elseif hovering then
				draw.RoundedBox( 8, btn_x, 100, btn_w, btn_h, CH_ATM.Colors.GMSBlue )
			else
				draw.RoundedBox( 8, btn_x, 100, btn_w, btn_h, CH_ATM.Colors.DarkGray )
			end
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_deposit )
			surface.DrawTexturedRect( 150, 110, 80, 80 )
			
			draw.SimpleText( CH_ATM.LangString( "Deposit" ), "CH_ATM_Font_ATMScreen_Size55", sw / 2, 150, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			
			
			-- Portfolio Button
			local hovering = imgui.IsHovering( btn_x, 230, btn_w, btn_h )
			
			if hovering and pressing then
				draw.RoundedBox( 8, btn_x, 230, btn_w, btn_h, CH_ATM.Colors.Green )
				
				-- Draw new 3D2D
				self:BANK_WithdrawBank()
			elseif hovering then
				draw.RoundedBox( 8, btn_x, 230, btn_w, btn_h, CH_ATM.Colors.GMSBlue )
			else
				draw.RoundedBox( 8, btn_x, 230, btn_w, btn_h, CH_ATM.Colors.DarkGray )
			end
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_withdraw )
			surface.DrawTexturedRect( 150, 240, 80, 80 )
			
			draw.SimpleText( CH_ATM.LangString( "Withdraw" ), "CH_ATM_Font_ATMScreen_Size55", sw / 2, 280, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			
			
			-- Send Crypto Button
			local hovering = imgui.IsHovering( btn_x, 350, btn_w, btn_h )
			
			if hovering and pressing then
				draw.RoundedBox( 8, btn_x, 360, btn_w, btn_h, CH_ATM.Colors.Green )
				
				-- Draw new 3D2D
				self:BANK_TransferMoney()
			elseif hovering then
				draw.RoundedBox( 8, btn_x, 360, btn_w, btn_h, CH_ATM.Colors.GMSBlue )
			else
				draw.RoundedBox( 8, btn_x, 360, btn_w, btn_h, CH_ATM.Colors.DarkGray )
			end
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_send_money )
			surface.DrawTexturedRect( 150, 370, 80, 80 )
			
			draw.SimpleText( CH_ATM.LangString( "Transfer" ), "CH_ATM_Font_ATMScreen_Size55", sw / 2, 410, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			
			
			-- History Button (only if MySQL)
			if CH_ATM.Config.EnableSQL then
				local hovering = imgui.IsHovering( btn_x, 490, btn_w, btn_h )
				
				if hovering and pressing then
					draw.RoundedBox( 8, btn_x, 490, btn_w, btn_h, CH_ATM.Colors.Green )
					
					-- Draw new 3D2D
					self:BANK_TransactionHistory()
				elseif hovering then
					draw.RoundedBox( 8, btn_x, 490, btn_w, btn_h, CH_ATM.Colors.GMSBlue )
				else
					draw.RoundedBox( 8, btn_x, 490, btn_w, btn_h, CH_ATM.Colors.DarkGray )
				end
				
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_bank_history )
				surface.DrawTexturedRect( 150, 500, 80, 80 )
				
				draw.SimpleText( CH_ATM.LangString( "Transaction History" ), "CH_ATM_Font_ATMScreen_Size55", sw / 2, 540, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			
			
			-- Settings Button
			local hovering = imgui.IsHovering( 970, 570, 64, 64 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme( ply ) ].mat_settings )
			surface.DrawTexturedRect( 970, 570, 64, 64 )
			
			if hovering and pressing then
				self:GENERAL_UserSettings()
			end
			
			-- Back Button (if crypto is enabled ONLY)
			if CH_CryptoCurrencies then
				local hovering = imgui.IsHovering( 20, 605, 32, 32 )
				
				surface.SetDrawColor( color_white )
				surface.SetMaterial( mat_back )
				surface.DrawTexturedRect( 20, 605, 32, 32 )
				
				if hovering and pressing then
					self:GENERAL_HomePortal()
				end
			end
			
			-- Draw curser
			imgui.xCursor( 0, 0, sw, sh )
			
			imgui.End3D2D()
		end
	end
end

--[[
	Deposit cash in the bank
--]]
function ENT:BANK_DepositBank()
	self:GENERAL_KeyPad( "deposit" )
	
	local ply = LocalPlayer()

	surface.PlaySound( "buttons/button17.wav" )
	
	self.Draw3D2DPage = function()
		if imgui.Entity3D2D( self, pos, ang, scale ) then
			local pressing = imgui.IsPressing()

			-- Top
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
			surface.DrawRect( 0, 0, sw, 50 )
			
			draw.SimpleText( CH_ATM.LangString( "Total Balance" ) ..": ".. CH_ATM.FormatMoney( CH_ATM.GetMoneyBankAccount( ply ) ), "CH_ATM_Font_ATMScreen_Size35", sw / 2, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			draw.SimpleText( CH_ATM.LangString( "Deposit" ), "CH_ATM_Font_ATMScreen_Size55", sw / 2, 175, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			-- Exit button
			if CH_ATM.Config.ActivateWithCreditCard then
				local hovering = imgui.IsHovering( 1020, 10, 32, 32 )
				
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme( ply ) ].mat_exit_atm )
				surface.DrawTexturedRect( 1020, 10, 32, 32 )
				
				if hovering and pressing then
					-- Start net to pull out card and reset atm
					net.Start( "CH_ATM_Net_PullOutCreditCard" )
						net.WriteEntity( self )
					net.SendToServer()
				end
			end
			
			-- Fake text entry field
			draw.RoundedBox( 8, sw / 2 - 320, sh / 2 - 40, 640, 80, color_white )
			
			if #self.CurrentInput <= 0 then
				draw.SimpleText( CH_ATM.LangString( "Enter the amount using the keypad" ), "CH_ATM_Font_ATMScreen_Size40", 230, 330, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( CH_ATM.FormatMoney( tonumber( self.CurrentInput ) ), "CH_ATM_Font_ATMScreen_Size40", 230, 330, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end
			
			-- Back Button
			local hovering = imgui.IsHovering( 20, 605, 32, 32 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( mat_back )
			surface.DrawTexturedRect( 20, 605, 32, 32 )
			
			if hovering and pressing then
				-- Clear the keypad input
				self:KEYPAD_ResetInput()
				
				-- Show bank home screen
				self:BANK_HomeScreen()
				
				-- Remove keypad 3d2d
				self:KEYPAD_Clear3D2D()
			end
			
			-- Draw curser
			imgui.xCursor( 0, 0, sw, sh )
			
			imgui.End3D2D()
		end
	end
end

--[[
	Deposit cash in the bank
--]]
function ENT:BANK_WithdrawBank()
	self:GENERAL_KeyPad( "withdraw" )
	
	local ply = LocalPlayer()

	surface.PlaySound( "buttons/button17.wav" )
	
	self.Draw3D2DPage = function()
		if imgui.Entity3D2D( self, pos, ang, scale ) then
			local pressing = imgui.IsPressing()

			-- Top
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
			surface.DrawRect( 0, 0, sw, 50 )
			
			draw.SimpleText( CH_ATM.LangString( "Total Balance" ) ..": ".. CH_ATM.FormatMoney( CH_ATM.GetMoneyBankAccount( ply ) ), "CH_ATM_Font_ATMScreen_Size35", sw / 2, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			draw.SimpleText( CH_ATM.LangString( "Withdraw" ), "CH_ATM_Font_ATMScreen_Size55", sw / 2, 175, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			-- Exit button
			if CH_ATM.Config.ActivateWithCreditCard then
				local hovering = imgui.IsHovering( 1020, 10, 32, 32 )
				
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme( ply ) ].mat_exit_atm )
				surface.DrawTexturedRect( 1020, 10, 32, 32 )
				
				if hovering and pressing then
					-- Start net to pull out card and reset atm
					net.Start( "CH_ATM_Net_PullOutCreditCard" )
						net.WriteEntity( self )
					net.SendToServer()
				end
			end
			
			-- Fake text entry field
			draw.RoundedBox( 8, sw / 2 - 320, sh / 2 - 40, 640, 80, color_white )
			
			if #self.CurrentInput <= 0 then
				draw.SimpleText( CH_ATM.LangString( "Enter the amount using the keypad" ), "CH_ATM_Font_ATMScreen_Size40", 230, 330, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( CH_ATM.FormatMoney( tonumber( self.CurrentInput ) ), "CH_ATM_Font_ATMScreen_Size40", 230, 330, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end
			
			-- Back Button
			local hovering = imgui.IsHovering( 20, 605, 32, 32 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( mat_back )
			surface.DrawTexturedRect( 20, 605, 32, 32 )
			
			if hovering and pressing then
				-- Clear the keypad input
				self:KEYPAD_ResetInput()
				
				-- Show bank home screen
				self:BANK_HomeScreen()
				
				-- Remove keypad 3d2d
				self:KEYPAD_Clear3D2D()
			end
			
			-- Draw curser
			imgui.xCursor( 0, 0, sw, sh )
			
			imgui.End3D2D()
		end
	end
end

--[[
	Transfer money to a friend
--]]
function ENT:BANK_TransferMoney()
	self:GENERAL_KeyPad( "transfer" )
	
	local ply = LocalPlayer()

	surface.PlaySound( "buttons/button17.wav" )
	
	-- Setup the amount of pages (exclude ourself from the calculation)
	local amount_of_players = #player.GetAll() - 1
	self.PAGES_AmountOfPages = math.ceil( amount_of_players / 15 )
	
	for i = 1, self.PAGES_AmountOfPages do
		-- Create the table for page
		self.PAGES_PageContent[ i ] = {}
	end
	
	-- Insert entries into their respective page (exclude ourself again)
	local count = 0
	for k, v in ipairs( player.GetAll() ) do
		if ply != v then
			count = count + 1
			
			local page = math.ceil( count / 15 )
			
			table.insert( self.PAGES_PageContent[ page ], v )
		end
	end

	self.Draw3D2DPage = function()
		if imgui.Entity3D2D( self, pos, ang, scale ) then
			local pressing = imgui.IsPressing()

			-- Top
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
			surface.DrawRect( 0, 0, sw, 50 )
			
			draw.SimpleText( CH_ATM.LangString( "Total Balance" ) ..": ".. CH_ATM.FormatMoney( CH_ATM.GetMoneyBankAccount( ply ) ), "CH_ATM_Font_ATMScreen_Size35", sw / 2, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			-- Exit button
			if CH_ATM.Config.ActivateWithCreditCard then
				local hovering = imgui.IsHovering( 1020, 10, 32, 32 )
				
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme( ply ) ].mat_exit_atm )
				surface.DrawTexturedRect( 1020, 10, 32, 32 )
				
				if hovering and pressing then
					-- Start net to pull out card and reset atm
					net.Start( "CH_ATM_Net_PullOutCreditCard" )
						net.WriteEntity( self )
					net.SendToServer()
				end
			end
			
			if not self.PAGES_SelectedOption then
				draw.SimpleText( CH_ATM.LangString( "Select Player" ), "CH_ATM_Font_ATMScreen_Size55", sw / 2, 105, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( CH_ATM.LangString( "Sending" ) .." ".. CH_ATM.FormatMoney( tonumber( self.CurrentInput ) ) .." ".. CH_ATM.LangString( "to" ) .." ".. self.PAGES_SelectedOption:Nick(), "CH_ATM_Font_ATMScreen_Size45", sw / 2, 105, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			
			-- Pages of players
			if self.PAGES_PageContent[ self.PAGES_CurrentPage ] then

				for k, button in pairs( self.PAGES_PageContent[ self.PAGES_CurrentPage ] ) do
					local x_pos = -295
					local y_pos = 160

					local y_offset = 0
					if k <= 3 then
						y_offset = k * 335
						x_pos = x_pos + y_offset
					elseif k <= 6 then
						y_offset = ( k - 3 ) * 335
						x_pos = x_pos + y_offset
						
						y_pos = 225
					elseif k <= 9 then
						y_offset = ( k - 6 ) * 335
						x_pos = x_pos + y_offset
						
						y_pos = 290
					elseif k <= 12 then
						y_offset = ( k - 9 ) * 335
						x_pos = x_pos + y_offset
						
						y_pos = 355
					elseif k <= 15 then
						y_offset = ( k - 12 ) * 335
						x_pos = x_pos + y_offset
						
						y_pos = 420
					end
					
					local hovering = imgui.IsHovering( x_pos, y_pos, 300, 50 )
					
					if hovering and pressing and IsValid( button ) then
						self.PAGES_SelectedOption = button
					elseif hovering then
						draw.RoundedBox( 8, x_pos, y_pos, 300, 50, CH_ATM.Colors.GMSBlue )
					else
						draw.RoundedBox( 8, x_pos, y_pos, 300, 50, CH_ATM.Colors.DarkGray )
					end
					
					local ply_name = ""
					if IsValid( button ) then
						ply_name = button:Nick()
					else
						ply_name = CH_ATM.LangString( "Disconnected Player" )
					end
					if string.len( ply_name ) > 18 then
						ply_name = string.Left( ply_name, 18 ) ..".."
					end
					draw.SimpleText( ply_name, "CH_ATM_Font_ATMScreen_Size35", x_pos + 20, y_pos + 25, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				end
				
				-- Change pages
				-- Left Page Button
				if self.PAGES_CurrentPage > 1 then
					local hovering = imgui.IsHovering( 40, 475, 50, 50 )
					
					surface.SetDrawColor( color_white )
					surface.SetMaterial( mat_page_back )
					surface.DrawTexturedRect( 40, 475, 50, 50 )
					
					if hovering and pressing then
						self.PAGES_CurrentPage = self.PAGES_CurrentPage - 1
					end
				end
				
				-- Right Page Button
				if self.PAGES_AmountOfPages > self.PAGES_CurrentPage then
					local hovering = imgui.IsHovering( 970, 475, 50, 50 )
					
					surface.SetDrawColor( color_white )
					surface.SetMaterial( mat_page_next )
					surface.DrawTexturedRect( 970, 475, 50, 50 )
					
					if hovering and pressing then
						self.PAGES_CurrentPage = self.PAGES_CurrentPage + 1
					end
				end
			end
			
			-- Fake text entry field
			draw.RoundedBox( 8, sw / 2 - 320, 510, 640, 80, color_white )
			
			if #self.CurrentInput <= 0 then
				draw.SimpleText( CH_ATM.LangString( "Enter the amount using the keypad" ), "CH_ATM_Font_ATMScreen_Size40", 230, 550, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( CH_ATM.FormatMoney( tonumber( self.CurrentInput ) ), "CH_ATM_Font_ATMScreen_Size40", 230, 550, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end
			
			-- Back Button
			local hovering = imgui.IsHovering( 20, 605, 32, 32 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( mat_back )
			surface.DrawTexturedRect( 20, 605, 32, 32 )
			
			if hovering and pressing then
				-- Clear the keypad input
				self:KEYPAD_ResetInput()
				
				-- Show bank home screen
				self:BANK_HomeScreen()
				
				-- Remove keypad 3d2d
				self:KEYPAD_Clear3D2D()
				
				-- Reset page
				self.PAGES_CurrentPage = 1
			end
			
			-- Draw curser
			imgui.xCursor( 0, 0, sw, sh )
			
			imgui.End3D2D()
		end
	end
end

--[[
	Show bank transaction history
--]]
function ENT:BANK_TransactionHistory()
	local ply = LocalPlayer()

	surface.PlaySound( "buttons/button17.wav" )
	
	-- Setup the amount of pages
	local amount_of_transactions = #ply.CH_ATM_Transactions
	self.PAGES_AmountOfPages = math.ceil( amount_of_transactions / 8 )
	
	for i = 1, self.PAGES_AmountOfPages do
		-- Create the table for page
		self.PAGES_PageContent[ i ] = {}
	end
	
	-- Insert entries into their respective page
	local count = 0
	for k, trans in ipairs( ply.CH_ATM_Transactions ) do
		count = count + 1
		
		local page = math.ceil( count / 8 )
		
		table.insert( self.PAGES_PageContent[ page ], trans )
	end
	
	self.Draw3D2DPage = function()
		if imgui.Entity3D2D( self, pos, ang, scale ) then
			local pressing = imgui.IsPressing()

			-- Top
			surface.SetDrawColor( CH_ATM.Colors.DarkGray )
			surface.DrawRect( 0, 0, sw, 50 )
			
			draw.SimpleText( CH_ATM.LangString( "Total Balance" ) ..": ".. CH_ATM.FormatMoney( CH_ATM.GetMoneyBankAccount( ply ) ), "CH_ATM_Font_ATMScreen_Size35", sw / 2, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			draw.SimpleText( CH_ATM.LangString( "Transaction History" ) .." (".. self.PAGES_CurrentPage .. "/".. self.PAGES_AmountOfPages ..")", "CH_ATM_Font_ATMScreen_Size45", sw / 2, 105, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
			-- Exit button
			if CH_ATM.Config.ActivateWithCreditCard then
				local hovering = imgui.IsHovering( 1020, 10, 32, 32 )
				
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme( ply ) ].mat_exit_atm )
				surface.DrawTexturedRect( 1020, 10, 32, 32 )
				
				if hovering and pressing then
					-- Start net to pull out card and reset atm
					net.Start( "CH_ATM_Net_PullOutCreditCard" )
						net.WriteEntity( self )
					net.SendToServer()
				end
			end
			
			-- Pages of transactions
			if self.PAGES_PageContent[ self.PAGES_CurrentPage ] then
				for k, trans in pairs( self.PAGES_PageContent[ self.PAGES_CurrentPage ] ) do
					local x_pos = -450
						local y_pos = 160

						local x_offset = 0
						if k <= 2 then
							x_offset = k * 500
							x_pos = x_pos + x_offset
						elseif k <= 4 then
							x_offset = ( k - 2 ) * 500
							x_pos = x_pos + x_offset
							
							y_pos = 260
						elseif k <= 6 then
							x_offset = ( k - 4 ) * 500
							x_pos = x_pos + x_offset
							
							y_pos = 360
						elseif k <= 8 then
							x_offset = ( k - 6 ) * 500
							x_pos = x_pos + x_offset
							
							y_pos = 460
						end
					
					-- BG
					draw.RoundedBox( 8, x_pos, y_pos, 450, 90, CH_ATM.Colors.DarkGray )
					
					
					-- Icon
					surface.SetDrawColor( color_white )
					if trans.Action == "deposit" then
						surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_deposit )
					else
						surface.SetMaterial( CH_ATM.IconTheme.Icons[ CH_ATM.GetIconTheme() ].mat_withdraw )
					end
					surface.DrawTexturedRect( x_pos + 5, y_pos + 5, 80, 80 )
					
					-- Vertical seperator line
					surface.SetDrawColor( CH_ATM.Colors.WhiteAlpha )
					surface.DrawRect( x_pos + 90, y_pos + 10, 2.5, 70 )
					
					-- Vertical seperator line END
					surface.SetDrawColor( CH_ATM.Colors.WhiteAlpha )
					surface.DrawRect( x_pos + 440, y_pos + 10, 2.5, 70 )
					
					-- Horizontal seperator line
					surface.SetDrawColor( CH_ATM.Colors.WhiteAlpha )
					surface.DrawRect( x_pos + 97.5, y_pos + 45, 337.5, 2.5 )
					
					-- Type and amount
					if trans.Action == "deposit" then
						draw.SimpleText( CH_ATM.LangString( "Deposit" ), "CH_ATM_Font_ATMScreen_Size35", x_pos + 97.5, y_pos + 25, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					elseif trans.Action == "withdraw" then
						draw.SimpleText( CH_ATM.LangString( "Withdraw" ), "CH_ATM_Font_ATMScreen_Size35", x_pos + 97.5, y_pos + 25, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					elseif trans.Action == "card" then
						draw.SimpleText( CH_ATM.LangString( "Credit Card" ), "CH_ATM_Font_ATMScreen_Size35", x_pos + 97.5, y_pos + 25, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					elseif trans.Action == "transfer" then
						draw.SimpleText( CH_ATM.LangString( "Transfer" ), "CH_ATM_Font_ATMScreen_Size35", x_pos + 97.5, y_pos + 25, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					end
					
					surface.SetFont( "CH_ATM_Font_ATMScreen_Size35" )
					local x, y = surface.GetTextSize( CH_ATM.FormatMoney( trans.Amount ) )
					
					draw.SimpleText( CH_ATM.FormatMoney( trans.Amount ), "CH_ATM_Font_ATMScreen_Size35", x_pos + 97.5, y_pos + 65, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					draw.SimpleText( CH_ATM.CurrencyAbbreviation(), "CH_ATM_Font_ATMScreen_Size20", x_pos + 97.5 + ( x + 5 ), y_pos + 70, CH_ATM.Colors.WhiteAlpha2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					
					draw.SimpleText( trans.TimeStamp, "CH_ATM_Font_ATMScreen_Size20", x_pos + 432, y_pos + 70, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				end
				
				-- Change pages
				-- Left Page Button
				if self.PAGES_CurrentPage > 1 then
					local hovering = imgui.IsHovering( 40, 550, 50, 50 )
					
					surface.SetDrawColor( color_white )
					surface.SetMaterial( mat_page_back )
					surface.DrawTexturedRect( 40, 550, 50, 50 )
					
					if hovering and pressing then
						self.PAGES_CurrentPage = self.PAGES_CurrentPage - 1
					end
				end
				
				-- Right Page Button
				if self.PAGES_AmountOfPages > self.PAGES_CurrentPage then
					local hovering = imgui.IsHovering( 970, 550, 50, 50 )
					
					surface.SetDrawColor( color_white )
					surface.SetMaterial( mat_page_next )
					surface.DrawTexturedRect( 970, 550, 50, 50 )
					
					if hovering and pressing then
						self.PAGES_CurrentPage = self.PAGES_CurrentPage + 1
					end
				end
			end
			
			-- Back Button
			local hovering = imgui.IsHovering( 20, 605, 32, 32 )
			
			surface.SetDrawColor( color_white )
			surface.SetMaterial( mat_back )
			surface.DrawTexturedRect( 20, 605, 32, 32 )
			
			if hovering and pressing then
				-- Show bank home screen
				self:BANK_HomeScreen()
				
				-- Reset page
				self.PAGES_CurrentPage = 1
			end
			
			-- Draw curser
			imgui.xCursor( 0, 0, sw, sh )
			
			imgui.End3D2D()
		end
	end
end