zvm = zvm or {}
zvm.util = zvm.util or {}

function zvm.Print(msg)
	print("[Zeros Vendingmachine] " .. msg)
end

function zvm.Warning(ply,msg)
	if CLIENT then
		notification.AddLegacy(msg, NOTIFY_ERROR, 2)
		surface.PlaySound("buttons/combine_button_locked.wav")
	else
		zclib.Notify(ply,msg, 1)
	end
end

// Returns the value of the first valid key which is found in the table, returns default otherwhise
function zvm.util.GetFirstValidRank(ply,_table,default)
	local val
	if xAdmin then
		for k, v in pairs(_table) do
			if ply:IsUserGroup(k) then
				val = v
				break
			end
		end
	else
		val = _table[zclib.Player.GetRank(ply)]
	end

	if val == nil then val = default end
	return val
end

/*
	Precaches any of the model replacements
*/
if SERVER then
	timer.Simple(2, function()
		for k, v in pairs(zvm.config.PredefinedModels) do
			if v then
				util.PrecacheModel(v)
			end
		end
	end)
end
