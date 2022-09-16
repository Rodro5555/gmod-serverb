zrush = zrush or {}
zrush.Barrel = zrush.Barrel or {}

function zrush.Barrel.PickUpCheck(ply, AllowedRanks)
	if zrush.config.Barrel.Rank_PickUpCheck then

		if zclib.Player.RankCheck(ply, AllowedRanks) then
			return true
		else
			return false
		end
	else
		return true
	end
end
