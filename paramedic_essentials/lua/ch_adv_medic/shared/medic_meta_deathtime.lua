local PMETA = FindMetaTable( "Player" )

function PMETA:GetUnconciousTime()
	local death_time = CH_AdvMedic.Config.UnconsciousTime

	for k, v in pairs( CH_AdvMedic.Config.RankDeathTime ) do
		if serverguard then
			if v.UserGroup == serverguard.player:GetRank( self ) then
				return v.Time
			end
		elseif sam then
			if v.UserGroup == sam.player.get_rank( self:SteamID() ) then
				return v.Time
			end
		else
			if v.UserGroup == self:GetUserGroup() then
				return v.Time
			end
		end
	end

	return death_time
end