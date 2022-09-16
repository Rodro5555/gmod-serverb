local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(100)
ITEM:SetModel("models/zerochain/props_growop2/zgo2_weedblock.mdl")

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
	local data = tbl.data

	if not zgo2.Plant.IsValid(data.WeedID) then
		zclib.Notify(ply, zgo2.language["InvalidPlantData"], 1)
		SafeRemoveEntity(ent)
		return
	end

	if zgo2.Weedblock.ReachedSpawnLimit(ply) then
		zclib.Notify(ply, zgo2.language["Spawnlimit"], 1)
		SafeRemoveEntity(ent)
		return
	end

	ent:SetWeedID(zgo2.Plant.GetListID(data.WeedID))
	zclib.Player.SetOwner(ent, ply)
end)

function ITEM:GetData(ent)
	return {
		WeedID = zgo2.Plant.GetID(ent:GetWeedID()),
	}
end

function ITEM:CanStack(newItem, invItem)
	return newItem.data.WeedID == invItem.data.WeedID
end

function ITEM:GetName(item)
	local ent = isentity(item)
	local WeedID = ent and item:GetWeedID() or item.data.WeedID

	return zgo2.Plant.GetName(WeedID)
end

function ITEM:GetDisplayName(item)
	return self:GetName(item)
end

local ang = Angle(0, 45, 0)
function ITEM:GetCameraModifiers(tbl)
	return {
		FOV = 30,
		X = 0,
		Y = 0,
		Z = 50,
		Angles = ang,
		Pos = vector_origin
	}
end

function ITEM:GetClientsideModel(tbl, mdlPanel)
	local WeedData = zgo2.Plant.GetData(tbl.data.WeedID)
	zgo2.Plant.UpdateMaterial(mdlPanel.Entity, WeedData)
end

ITEM:Register("zgo2_weedblock")
