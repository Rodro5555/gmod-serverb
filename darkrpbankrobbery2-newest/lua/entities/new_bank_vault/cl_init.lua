include( "shared.lua" )

net.Receive( "BANK2_RestartCooldown", function( length, ply )
	local cooldowntime = net.ReadDouble()
	LocalPlayer().BankRobberyCooldown = CurTime() + cooldowntime
end )

net.Receive( "BANK2_KillCooldown", function( length, ply ) 
	LocalPlayer().BankRobberyCooldown = 0
end )

net.Receive( "BANK2_RestartCountdown", function( length, ply )
	local countdowntime = net.ReadDouble()
	
	LocalPlayer().BankRobberyCountdown = CurTime() + countdowntime
	table.Empty( CH_BankVault.CurrentRobbers)
end )

net.Receive( "BANK2_KillCooldown", function( length, ply ) 
	LocalPlayer().BankRobberyCountdown = 0
	
	table.Empty( CH_BankVault.CurrentRobbers )
	table.insert( CH_BankVault.CurrentRobbers, "NONE")
end )

net.Receive( "BANK2_UpdateCurrentRobbers", function( length, ply )
	local therobberupdate = net.ReadString()
	
	table.insert( CH_BankVault.CurrentRobbers, therobberupdate )
end )

net.Receive( "BANK2_RemoveCurrentRobbers", function( length, ply )
	local therobberremove = net.ReadString()
	
	table.RemoveByValue( CH_BankVault.CurrentRobbers, therobberremove )
end )

net.Receive( "BANK2_UpdateBankMoney", function( length, ply )
	local bankvault_ent = net.ReadEntity()
	local bank_money = net.ReadDouble()
	
	bankvault_ent.BankMoney = bank_money
end )

function ENT:Initialize()
end

local function BANK2_DrawCircle(x, y, ang, seg, p, rad, color)
	local cirle = {}

	table.insert( cirle, { x = x, y = y} )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -p + ang )
		table.insert( cirle, { x = x + math.sin( a ) * rad, y = y + math.cos( a ) * rad } )
	end
	surface.SetDrawColor( color )
	draw.NoTexture()
	surface.DrawPoly( cirle )
end

function ENT:Draw()
	self:DrawModel()

	if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) >= CH_BankVault.Design.DistanceTo3D2D then
		return
	end

	local BankAmount = self.BankMoney or CH_BankVault.Config.StartMoney
	local RequiredTeamsCount = 0
	local RequiredPlayersCounted = 0
	
	if not BankAmount then
		return
	end

	local ang = self:GetAngles()
	ang:RotateAroundAxis( ang:Up(), 90 )
	
	local pos = self:GetPos() + ang:Right() * 30 + ang:Up() * 52
	ang:RotateAroundAxis( ang:Forward(), 90 )
	
	cam.Start3D2D( pos, ang, 0.11 )
		draw.SimpleTextOutlined( CH_BankVault.Design.DesignText_VaultName, "CH_BankRobbery2_Header", 0, -65, CH_BankVault.Design.DesignColor_VaultName, 1, 1, 3, CH_BankVault.Design.DesignColor_VaultNameBoarder )
		draw.SimpleTextOutlined( CH_BankVault.Design.DesignText_BankVault, "CH_BankRobbery2_VaultName", 0, -10, CH_BankVault.Design.DesignColor_BankVault, 1, 1, 3, CH_BankVault.Design.DesignColor_BankVaultBoarder )
		
		BANK2_DrawCircle( 0, 110, 180, 80, 360, 100, CH_BankVault.Design.DesignColor_BackCircle ) -- Back circle
		BANK2_DrawCircle( 0, 110, 180, 80, 360 * BankAmount/CH_BankVault.Config.Max, 99, CH_BankVault.Design.DesignColor_MoneyCircle ) -- Money circle
		BANK2_DrawCircle( 0, 110, 180, 40, 360, 80, CH_BankVault.Design.DesignColor_FrontCircle ) -- Front circle
		
		draw.SimpleTextOutlined( CH_BankVault.Design.DesignText_Money, "CH_BankRobbery2_Money", 0, 90, CH_BankVault.Design.DesignColor_Money, 1, 1, 2, CH_BankVault.Design.DesignColor_MoneyBoarder )
		draw.SimpleTextOutlined( DarkRP.formatMoney( BankAmount ), "CH_BankRobbery2_Money", 0, 130, CH_BankVault.Design.DesignColor_VaultAmount, 1, 1, 2, CH_BankVault.Design.DesignColor_VaultAmountBoarder )
    
    	-- LEFT SIDE
		draw.RoundedBox( 8, -265, 215, 240, 190, CH_BankVault.Design.DesignColor_LeftBox )

		if LocalPlayer().BankRobberyCooldown and LocalPlayer().BankRobberyCooldown > CurTime() then
			draw.SimpleTextOutlined( CH_BankVault.Design.DesignText_Cooldown, "CH_BankRobbery2_SubHeader", -142.5, 240, CH_BankVault.Design.DesignColor_Cooldown, 1, 1, 2, CH_BankVault.Design.DesignColor_CooldownBoarder )
			draw.SimpleTextOutlined( string.ToMinutesSeconds( math.Round(LocalPlayer().BankRobberyCooldown - CurTime() ) ), "CH_BankRobbery2_Header", -142.5, 320, CH_BankVault.Design.DesignColor_CooldownValue, 1, 1, 2, CH_BankVault.Design.DesignColor_CooldownValueBoarder )
		elseif LocalPlayer().BankRobberyCountdown and LocalPlayer().BankRobberyCountdown > CurTime() then
			draw.SimpleTextOutlined( CH_BankVault.Design.DesignText_Countdown, "CH_BankRobbery2_SubHeader", -142.5, 240, CH_BankVault.Design.DesignColor_Countdown, 1, 1, 2, CH_BankVault.Design.DesignColor_CountdownBoarder )
			draw.SimpleTextOutlined( string.ToMinutesSeconds( math.Round(LocalPlayer().BankRobberyCountdown - CurTime() ) ), "CH_BankRobbery2_Header", -142.5, 320, CH_BankVault.Design.DesignColor_CountdownValue, 1, 1, 2, CH_BankVault.Design.DesignColor_CountdownValueBoarder )	
		else
			draw.SimpleTextOutlined( CH_BankVault.Design.DesignText_RobStatus, "CH_BankRobbery2_SubHeader", -142.5, 240, CH_BankVault.Design.DesignColor_RobStatus, 1, 1, 2, CH_BankVault.Design.DesignColor_RobStatusBoarder )
			for k, v in ipairs( player.GetAll() ) do
				RequiredPlayersCounted = RequiredPlayersCounted + 1
				
				if v:isCP() then
					RequiredTeamsCount = RequiredTeamsCount + 1
				end
				
				if RequiredPlayersCounted == #player.GetAll() then
					if RequiredTeamsCount >= CH_BankVault.Config.PoliceRequired then
						draw.SimpleTextOutlined( CH_BankVault.Design.DesignText_EnoughPoliceYes, "CH_BankRobbery2_NormalText", -142.5, 280, CH_BankVault.Design.DesignColor_TheYes, 1, 1, 2, CH_BankVault.Design.DesignColor_TheBoarder )
					else
						draw.SimpleTextOutlined( CH_BankVault.Design.DesignText_EnoughPoliceNo, "CH_BankRobbery2_NormalText", -142.5, 280, CH_BankVault.Design.DesignColor_TheNo, 1, 1, 2, CH_BankVault.Design.DesignColor_TheBoarder )
					end
				end
			end
			
			if CH_BankVault.Config.AllowedTeams[ team.GetName( LocalPlayer():Team() ) ] then
				draw.SimpleTextOutlined( CH_BankVault.Design.DesignText_AllowedTeamYes, "CH_BankRobbery2_NormalText", -142.5, 310, CH_BankVault.Design.DesignColor_TheYes, 1, 1, 2, CH_BankVault.Design.DesignColor_TheBoarder )
			else
				draw.SimpleTextOutlined( CH_BankVault.Design.DesignText_AllowedTeamNo, "CH_BankRobbery2_NormalText", -142.5, 310, CH_BankVault.Design.DesignColor_TheNo, 1, 1, 2, CH_BankVault.Design.DesignColor_TheBoarder )
			end
			
			if #player.GetAll() >= CH_BankVault.Config.PlayerLimit then
				draw.SimpleTextOutlined( CH_BankVault.Design.DesignText_EnoughPlayersYes, "CH_BankRobbery2_NormalText", -142.5, 340, CH_BankVault.Design.DesignColor_TheYes, 1, 1, 2, CH_BankVault.Design.DesignColor_TheBoarder )
			else
				draw.SimpleTextOutlined( CH_BankVault.Design.DesignText_EnoughPlayersNo, "CH_BankRobbery2_NormalText", -142.5, 340, CH_BankVault.Design.DesignColor_TheNo, 1, 1, 2, CH_BankVault.Design.DesignColor_TheBoarder )
			end
		end

		-- RIGHT SIDE
		draw.RoundedBox( 8, 10, 215, 240, 190, CH_BankVault.Design.DesignColor_RightBox )

		draw.SimpleTextOutlined( CH_BankVault.Design.DesignText_CurrentRobbers, "CH_BankRobbery2_SubHeader", 130, 240, CH_BankVault.Design.DesignColor_CurrentRobbers, 1, 1, 2, CH_BankVault.Design.DesignColor_CurrentRobbersBoarder )
    	draw.SimpleTextOutlined( table.concat( CH_BankVault.CurrentRobbers, "", 1, 1), "CH_BankRobbery2_NormalText", 130, 280, CH_BankVault.Design.DesignColor_Robber1, 1, 1, 2, CH_BankVault.Design.DesignColor_Robber1Boarder )
    	
		if table.Count( CH_BankVault.CurrentRobbers ) > 1 then
    		draw.SimpleTextOutlined( table.concat( CH_BankVault.CurrentRobbers, "", 2, 2), "CH_BankRobbery2_NormalText", 130, 310, CH_BankVault.Design.DesignColor_Robber2, 1, 1, 2, CH_BankVault.Design.DesignColor_Robber2Boarder )
    	end
		
    	if table.Count( CH_BankVault.CurrentRobbers ) > 2 then
    		draw.SimpleTextOutlined( table.concat( CH_BankVault.CurrentRobbers, "", 3, 3), "CH_BankRobbery2_NormalText", 130, 340, CH_BankVault.Design.DesignColor_Robber3, 1, 1, 2, CH_BankVault.Design.DesignColor_Robber3Boarder )
    	end
		
		if table.Count( CH_BankVault.CurrentRobbers ) > 3 then
    		draw.SimpleTextOutlined( table.concat( CH_BankVault.CurrentRobbers, "", 4, 4), "CH_BankRobbery2_NormalText", 130, 340, CH_BankVault.Design.DesignColor_Robber3, 1, 1, 2, CH_BankVault.Design.DesignColor_Robber3Boarder )
    	end
    cam.End3D2D()
end