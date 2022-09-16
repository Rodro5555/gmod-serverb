local PMETA = FindMetaTable( "Player" )

function PMETA:GetMaxMiners()
	local max_miners = 16

	for k, v in pairs( CH_Bitminers.Config.MaxBitminersInstalled ) do
		if serverguard then
			if v.UserGroup == serverguard.player:GetRank( self ) then
				return v.MaxBitminers
			end
		else
			if v.UserGroup == self:GetUserGroup() then
				return v.MaxBitminers
			end
		end
	end

	return max_miners
end