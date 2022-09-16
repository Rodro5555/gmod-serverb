zfs = zfs or {}
zfs.Shop = zfs.Shop or {}

// Performs a bunch of check to see if the player is even allowed to interact with the shop
function zfs.Shop.CanInteract(Shop, ply,notify)

	// Player valid check
	if ply:IsPlayer() == false then return false end
	if ply:Alive() == false then return false end

	if table.Count(zfs.config.Jobs) > 0 and zfs.config.Jobs[team.GetName(zclib.Player.GetJob(ply))] == nil then
		zclib.Notify(ply, zfs.language.Shop.WrongJob, 1)
		return false
	end

	// Shop entity check
	if not IsValid(Shop) then return false end
	if Shop:GetClass() ~= "zfs_shop" then return false end

	// Busy check
	if Shop:GetIsBusy() then return false end

	// Distance check
	if zclib.util.InDistance(ply:GetPos(), Shop:GetPos(), zfs.dist_interaction) == false then return false end

	// Owner check
	if Shop:GetPublicEntity() == false and not zclib.Player.IsOwner(ply, Shop) then
		zclib.Notify(ply, zfs.language.Shop.NotOwner, 1)
		return false
	end

	// Interaction check
	local occ_ply = Shop:GetOccupiedPlayer()
	if IsValid(occ_ply) and ply ~= occ_ply then return false end

	return true
end

// Returns all the fruits which are curretnly stored in the shop
function zfs.Shop.GetFruitStorage(Shop)
	return Shop.StoredFruits or {}
end

// Checks if the shop has enough fruits in storage
function zfs.Shop.MissingFruits(Shop, ply,id)
	local SmoothieData = zfs.Smoothie.GetData(id)
	if SmoothieData == nil then
		zclib.Debug("zfs.Shop.MissingFruits [Invalid Smoothie]")
		return true
	end

	local FruitStorage = zfs.Shop.GetFruitStorage(Shop)
	if table.Count(FruitStorage) <= 0 then
		zclib.Debug("zfs.Shop.MissingFruits [Storage Empty]")
		return true
	end

	local MissingFruits = false
	for k,v in pairs(SmoothieData.recipe) do
		if FruitStorage[k] == nil then
			MissingFruits = true
			break
		end

		if FruitStorage[k] < v then
			MissingFruits = true
			break
		end
	end

	return MissingFruits
end

function zfs.Shop.OnCup(Shop,ply)
	local tr = ply:GetEyeTrace()
	local lTrace = Shop:WorldToLocal(tr.HitPos)
	if lTrace.x < -26 and lTrace.x > -42 and lTrace.y < 25 and lTrace.y > 13 and lTrace.z < 51 and lTrace.z > 35 then
		return true
	else
		return false
	end
end

function zfs.Shop.OnPush(Shop,ply)
	local tr = ply:GetEyeTrace()
	local lTrace = Shop:WorldToLocal(tr.HitPos)
	if lTrace.x < -50 and lTrace.x > -60 and lTrace.y < 15 and lTrace.y > -15 and lTrace.z < 37 and lTrace.z > 31 then
		return true
	else
		return false
	end
end
