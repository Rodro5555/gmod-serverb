local ITEM = BRICKS_SERVER.Func.CreateItemType("zgo2_jar")

ITEM.GetItemData = function(ent)
    if (not IsValid(ent)) then return end
    local itemData = {"zgo2_jar", "models/zerochain/props_growop2/zgo2_jar.mdl",zgo2.Plant.GetID(ent:GetWeedID()),math.Round(ent:GetWeedAmount()),math.Round(ent:GetWeedTHC())}

    return itemData, 1
end

ITEM.OnSpawn = function(ply, pos, itemData, itemAmount)

	if not zgo2.Plant.IsValid(itemData[ 3 ]) then
		zclib.Notify(ply, zgo2.language[ "InvalidPlantData" ], 1)
		return false
	end

	if zgo2.Jar.ReachedSpawnLimit(ply) then
		zclib.Notify(ply, zgo2.language["Spawnlimit"], 1)
		return false
	end

    local ent = ents.Create("zgo2_jar")
    if not IsValid(ent) then return end
    ent:SetPos(pos)
    ent:Spawn()
    ent:Activate()
    zclib.Player.SetOwner(ent, ply)

	ent:SetWeedID(zgo2.Plant.GetListID(itemData[3]))
	ent:SetWeedAmount(itemData[4])
	ent:SetWeedTHC(itemData[5] or 50)

	zgo2.Jar.UpdateBodygroups(ent)
end

ITEM.GetInfo = function(itemData)
    return {zgo2.Plant.GetName(itemData[3]) .. " " .. tostring(itemData[4]) .. zgo2.config.UoM .. " THC: ".. (itemData[5] or 50) .. "%", "Holds weed.", ""}
end

local ang = Angle(0, -45, 0)
ITEM.ModelDisplay = function(Panel, itemtable)
    if (not Panel.Entity or not IsValid(Panel.Entity)) then return end
    local mn, mx = Panel.Entity:GetRenderBounds()
    local size = 0
    size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
    size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
    size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
    Panel:SetFOV(20)
    Panel:SetCamPos(Vector(size, size * 3, size * 2))
    Panel:SetLookAt((mn + mx) * 0.5)
    Panel.Entity:SetAngles(ang)

	local WeedData = zgo2.Plant.GetData(itemtable[3])
	if not WeedData then return end

	local weed_amount = itemtable[4]
	local Jar = Panel.Entity
	Jar:SetBodygroup(0, 0)
	Jar:SetBodygroup(1, 0)
	Jar:SetBodygroup(2, 0)
	Jar:SetBodygroup(3, 0)
	Jar:SetBodygroup(4, 0)

	if weed_amount > 0 then
		local bg = math.Clamp(math.Round((5 / zgo2.config.Jar.Capacity) * weed_amount), 1, 5)

		for i = 0, bg - 1 do
			Jar:SetBodygroup(i, 1)
		end
	end

	zgo2.Plant.UpdateMaterial(Jar, WeedData)
end


ITEM.CanCombine = function(itemData1, itemData2) return false end
ITEM:Register()

if BRICKS_SERVER and BRICKS_SERVER.CONFIG and BRICKS_SERVER.CONFIG.INVENTORY and BRICKS_SERVER.CONFIG.INVENTORY.Whitelist then
    BRICKS_SERVER.CONFIG.INVENTORY.Whitelist["zgo2_jar"] = {false, true}
end
