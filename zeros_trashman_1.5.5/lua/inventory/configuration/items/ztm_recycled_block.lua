local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(10)
ITEM:SetModel("models/zerochain/props_trashman/ztm_recycleblock.mdl")
ITEM:SetDescription("A block of recycled trash.")

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
	local data = tbl.data

	ent:SetRecycleType(data.RecycleType)

	zclib.Player.SetOwner(ent, ply)
end)

function ITEM:CanStack(newItem, invItem)
	local ent = isentity(newItem)
	local RecycleType = ent and newItem:GetRecycleType() or newItem.data.RecycleType
	return RecycleType == invItem.data.RecycleType
end

function ITEM:GetData(ent)
	return {
		RecycleType = ent:GetRecycleType(),
	}
end

function ITEM:GetDisplayName(item)
	return self:GetName(item)
end

function ITEM:GetName(item)
	local ent = isentity(item)
	local RecycleType = ent and item:GetRecycleType() or item.data.RecycleType
	local trash_name = ztm.config.Recycler.recycle_types[RecycleType].name
	return trash_name
end

function ITEM:GetCameraModifiers(tbl)
	return {
		FOV = 40,
		X = 0,
		Y = -22,
		Z = 25,
		Angles = Angle(0, -190, 0),
		Pos = Vector(0, 0, -1)
	}
end

function ITEM:GetClientsideModel(tbl, mdlPanel)

	local RecycleType = tbl.data.RecycleType
	local _recycle_type = ztm.config.Recycler.recycle_types[RecycleType]

	mdlPanel.Entity:SetMaterial( _recycle_type.mat, true )
end

ITEM:Register("ztm_recycled_block")
