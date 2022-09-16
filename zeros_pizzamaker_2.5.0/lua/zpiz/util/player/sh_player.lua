zpiz = zpiz or {}
zpiz.Player = zpiz.Player or {}

// Does the player have the correctjob
function zpiz.Player.IsPizzaChef(ply)
	if zpiz.config.Jobs and table.Count(zpiz.config.Jobs) > 0 then
		if zpiz.config.Jobs[zclib.Player.GetJob(ply)] then
			return true
		else
			return false
		end
	else
		return true
	end
end

function zpiz.Player.CanInteract(ply,ent)
	if zpiz.Player.IsPizzaChef(ply) == false then return false end
	if zpiz.config.EquipmentSharing then return true end
	if ent.IsPublicEntity then return true end

	if zclib.Player.IsOwner(ply, ent) then
		return true
	else
		return false
	end
end

function zpiz.Player.GetNearPizzaChef(ent)
	local cook = false
	// 229407176
	for k, v in pairs(zclib.Player.List) do
		if not IsValid(v) then continue end
		if not v:IsPlayer() then continue end
		if not v:Alive() then continue end
		if zclib.util.InDistance(v:GetPos(), ent:GetPos(), 300) == false then continue end
		if zpiz.Player.CanInteract(v,ent) then
			cook = v
			break
		end
	end
	return cook
end

// Returns how many valid ingredients the player has currently spawned
function zpiz.Player.ReachedIngredientLimit(ply)
	if ply.zpiz_SpawnedIngredients == nil then ply.zpiz_SpawnedIngredients = {} end
	local count = 0
	for k,v in pairs(ply.zpiz_SpawnedIngredients) do
		if IsValid(v) then
			count = count + 1
		end
	end
	return count >= zpiz.config.Ingredient.Limit
end
