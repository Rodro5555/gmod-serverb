local PMETA = FindMetaTable( "Player" )

--[[
	Simple meta function to check if players team is in the PoliceTeams table.
--]]
function PMETA:CH_ATM_IsPoliceJob()
	return CH_ATM.Config.PoliceTeams[ team.GetName( self:Team() ) ] or self:isCP()
end

--[[
	Check if players team is allowed to rob an ATM
--]]
function PMETA:CH_ATM_CanRobATM()
	return CH_ATM.Config.CriminalTeams[ team.GetName( self:Team() ) ]
end

--[[
	Check if player is an admin
--]]
function PMETA:CH_ATM_IsAdmin()
	if CH_ATM.Config.EnableCustomAdminGroups then
		if serverguard then 
			return CH_ATM.Config.CustomAdminGroups[ serverguard.player:GetRank( self ) ] or false
		else
			return CH_ATM.Config.CustomAdminGroups[ self:GetUserGroup() ] or false
		end
	else
		return self:IsAdmin()
	end
end