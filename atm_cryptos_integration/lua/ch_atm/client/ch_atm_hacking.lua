--[[
	Net message to update the clientside cooldown counter on an ATM
--]]
net.Receive( "CH_ATM_Net_RestartHackCooldownTimer", function( length, ply )
	local atm = net.ReadEntity()
	local cooldown_time = CH_ATM.Config.ATMHackCooldownTime
	
	atm.HackCooldownTimer = CurTime() + cooldown_time
end )

--[[
	Draw ATMs that are being hacked to cops
--]]
local function CH_ATM_UnitToMeter( unit )
	return math.Round( unit * 0.0195 ) .."m"
end

local CH_ATM_HackedATMCachedDist = CH_ATM_HackedATMCachedDist or {}
local atm_being_hacked = CH_ATM.LangString( "ATM Being Hacked" )

function CH_ATM.DisplayATMBeingHacked()
	local ply = LocalPlayer()
	
	if ply:CH_ATM_IsPoliceJob() then
		for k, atm in ipairs( ents.FindByClass( "ch_atm" ) ) do
			if IsValid( atm ) and atm:GetIsBeingHacked() then
				local pos = atm:GetPos():ToScreen()
				
				-- Cache distance every 0.5 second.
				-- We're using Distance here because I want to show in units.
				-- Unfortunately cannot use DistToSqr for this.

				local ct = CurTime()
				if ( not CH_ATM_HackedATMCachedDist[ atm ] or CH_ATM_HackedATMCachedDist[ atm ].ct + 0.5 < ct ) then
					CH_ATM_HackedATMCachedDist[ atm ] = {
						dist = atm:GetPos():Distance( ply:GetPos() ),
						ct = ct
					}
				end
				
				local dist_to_atm = CH_ATM.LangString( "Distance" ) ..": ".. CH_ATM_UnitToMeter( CH_ATM_HackedATMCachedDist[ atm ].dist )
			
				surface.SetFont( "CH_ATM_Font_ATMScreen_Size35" )
				local x, y = surface.GetTextSize( atm_being_hacked )
				local flash_col = Color( 255 * math.abs( math.sin( CurTime() * 1.2 ) ), 0, 0, 255 )
				
				draw.SimpleTextOutlined( atm_being_hacked, "CH_ATM_Font_ATMScreen_Size35", pos.x - x / 2, pos.y - 30, flash_col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, color_black )
				
				surface.SetFont( "CH_ATM_Font_ATMScreen_Size25" )
				local x, y = surface.GetTextSize( dist_to_atm )
				draw.SimpleTextOutlined( dist_to_atm, "CH_ATM_Font_ATMScreen_Size25", pos.x - x / 2, pos.y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, color_black )
			end
		end
	end
end
hook.Add( "HUDDrawTargetID", "CH_ATM.DisplayATMBeingHacked", CH_ATM.DisplayATMBeingHacked )