local ITEM = BRICKS_SERVER.Func.CreateItemType("zgo2_joint_ent")

ITEM.GetItemData = function(ent)
    if (not IsValid(ent)) then return end
    local itemData = {"zgo2_joint_ent", "models/zerochain/props_growop2/zgo2_joint.mdl",zgo2.Plant.GetID(ent:GetWeedID()),math.Round(ent:GetWeedAmount()),math.Round(ent:GetWeedTHC())}

    return itemData, 1
end

ITEM.OnSpawn = function(ply, pos, itemData, itemAmount)

	if not zgo2.Plant.IsValid(itemData[ 3 ]) then
		zclib.Notify(ply, zgo2.language[ "InvalidPlantData" ], 1)
		return false
	end

    local ent = ents.Create("zgo2_joint_ent")
    if not IsValid(ent) then return end
    ent:SetPos(pos)
    ent:Spawn()
    ent:Activate()
    zclib.Player.SetOwner(ent, ply)

	ent:SetWeedID(zgo2.Plant.GetListID(itemData[3]))
	ent:SetWeedAmount(itemData[4])
	ent:SetWeedTHC(itemData[5] or 50)
end

ITEM.GetInfo = function(itemData)
    return {zgo2.Plant.GetName(itemData[3]) .. " " .. tostring(itemData[4]) .. zgo2.config.UoM .. " THC: ".. (itemData[5] or 50) .. "%", "A Joint.", ""}
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
end


ITEM.CanCombine = function(itemData1, itemData2) return false end
ITEM:Register()

if BRICKS_SERVER and BRICKS_SERVER.CONFIG and BRICKS_SERVER.CONFIG.INVENTORY and BRICKS_SERVER.CONFIG.INVENTORY.Whitelist then
    BRICKS_SERVER.CONFIG.INVENTORY.Whitelist["zgo2_joint_ent"] = {false, true}
end
