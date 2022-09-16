util.AddNetworkString("CarePackage.Menu.Loot")
util.AddNetworkString("CarePackage.Menu.Response")
util.AddNetworkString("CarePackage.Menu")
util.AddNetworkString("CarePackage.Plane")
util.AddNetworkString("CarePackage.Message")

util.AddNetworkString("CarePackage.Saving.Add")
util.AddNetworkString("CarePackage.Saving.Delete")
util.AddNetworkString("CarePackage.Saving.DeleteAll")
util.AddNetworkString("CarePackage.Saving.Get")

net.Receive("CarePackage.Menu.Loot", function(len, ply)
	local function networkResponse(success, id, str)
		net.Start("CarePackage.Menu.Response")
			net.WriteBool(success)
			net.WriteUInt(id, 8)
			net.WriteString(str)
		net.Send(ply)
	end
	
	local ent = net.ReadEntity()
	local id = net.ReadUInt(8)
	local type = net.ReadUInt(1)
	if (!ply:Alive()) then
		networkResponse(false, id, CarePackage:GetPhrase("Loot.Error.Dead"))

		return
	end
	if (type == CAREPACKAGE_INVENTORY and !XeninInventory) then
		networkResponse(false, id, CarePackage:GetPhrase("Loot.Error.InventoryNotThere"))

		return
	end
	if (!IsValid(ent)) then 
		networkResponse(false, id, CarePackage:GetPhrase("Loot.Error.Invalid"))
		
		return 
	end
	if (!ent.Opened) then
		networkResponse(false, id, CarePackage:GetPhrase("Loot.Error.NotReady"))

		return
	end
	if (ent:GetPos():DistToSqr(ply:GetPos()) > (125 * 125)) then 
		networkResponse(false, id, CarePackage:GetPhrase("Loot.Error.TooFarAway"))

		return
	end
	local tbl = ent.Contents[id]
	if (!tbl) then 
		networkResponse(false, id, CarePackage:GetPhrase("Loot.Error.DoesntContainAnything"))
		
		return
	end
	if (tbl.claimed) then 
		networkResponse(false, id, CarePackage:GetPhrase("Loot.Error.ItemLooted"))
		
		return 
	end
	local cfg = CarePackage.Config.Drops[tbl.id]
	if (!cfg) then 
		networkResponse(false, id, CarePackage:GetPhrase("Loot.Error.DoesntExistInConfig"))
		
		return
	end
	local canLoot, err = cfg.Drop:CanLoot(cfg.Ent, ply, type)
	if (!canLoot) then
		networkResponse(false, id, err)

		return
	end

	tbl.claimed = true

	cfg.Drop:Loot(cfg.Ent, ply, type)
	networkResponse(true, id, "")

	hook.Run("CarePackage.LootedItem", ply, cfg.Ent, type)
	
	ent.ClaimedItems = ent.ClaimedItems + 1

	if (ent.ClaimedItems == CarePackage.Config.ItemsPerDrop) then
		timer.Simple(1, function()
			if (IsValid(ent)) then
				ent:Remove()
			end
		end)
	end
end)

net.Receive("CarePackage.Saving.Add", function(len, ply)
	if (!CarePackage.Config.IsAdmin(ply)) then return end
	local tbl = net.ReadTable()

	CarePackage:AddSpawn(tbl.pos, tbl.ang)
end)

net.Receive("CarePackage.Saving.Delete", function(len, ply)
	if (!CarePackage.Config.IsAdmin(ply)) then return end
	local id = net.ReadUInt(32)

	CarePackage:DeleteSpawn(id)
end)

net.Receive("CarePackage.Saving.DeleteAll", function(len, ply)
	if (!CarePackage.Config.IsAdmin(ply)) then return end

	CarePackage:DeleteAllSpawns()
end)

net.Receive("CarePackage.Saving.Get", function(len, ply)
	if (!CarePackage.Config.IsAdmin(ply)) then return end

	net.Start("CarePackage.Saving.Get")
		net.WriteTable(CarePackage.Spawns)
	net.Send(ply)
end)

util.AddNetworkString("CarePackage.Saving.PlanePos")

net.Receive("CarePackage.Saving.PlanePos", function(len, ply)
	if (!CarePackage.Config.IsAdmin(ply)) then return end
	
	local vec1 = net.ReadVector()
	local vec2 = net.ReadVector()

	CarePackage.PlanePos = {
		vec1,
		vec2
	}
	CarePackage.PlanePosOrdered = nil
	CarePackage.Database:SavePlanePos(vec1, vec2)
end)