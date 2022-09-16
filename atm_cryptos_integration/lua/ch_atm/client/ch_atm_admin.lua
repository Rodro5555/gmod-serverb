--[[
	Simple CL var if an admin has triggered the emergency lockdown on ATMs
--]]
CH_ATM.HasAdminEmergencyLockdownATM = false

--[[
	Function to draw halo on ATM for the admin if enabled through admin menu
--]]
function CH_ATM.DrawEntitiesHalo()
	local ply = LocalPlayer()
	
	if not ply:CH_ATM_IsAdmin() then
		return
	end
	
	if not ply:Alive() then
		return
	end
	
	if not ply.CH_ATM_ShowATMEntitiesOnMap then
		return
	end
	
	halo.Add( ents.FindByClass( "ch_atm" ), CH_ATM.Colors.Red, 2, 2, 5, true, true )
end
hook.Add( "PreDrawHalos", "CH_ATM.DrawEntitiesHalo", CH_ATM.DrawEntitiesHalo )