ztm = ztm or {}
ztm.Player = ztm.Player or {}

function ztm.Player.IsTrashman(ply)
	if ztm.config.Jobs == nil then return true end
	if table.Count(ztm.config.Jobs) <= 0 then return true end

	if ztm.config.Jobs[zclib.Player.GetJob(ply)] then
		return true
	else
		return false
	end
end
