function InvestigationMod:IsAllowedToInvestigate( pPlayer )
	return InvestigationMod.Configuration.JobsAllowed[ pPlayer:Team() ]
end 

function InvestigationMod:GetConfig( sName )
	return InvestigationMod.Configuration[ sName ]
end

function InvestigationMod:AddJob( iTeam )
	if not iTeam then return end

	InvestigationMod.Configuration.JobsAllowed[ iTeam ] = true 
end