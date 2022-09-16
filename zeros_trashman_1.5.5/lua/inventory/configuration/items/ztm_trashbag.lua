local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/zerochain/props_trashman/ztm_trashbag.mdl")
ITEM:SetDescription("A bag of trash.")

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
	local data = tbl.data
	ent:SetTrash(data.Trash)
	zclib.Player.SetOwner(ent, ply)
end)

function ITEM:GetData(ent)
	return {
		Trash = ent:GetTrash()
	}
end

function ITEM:GetDisplayName(item)
	return self:GetName(item)
end

function ITEM:GetName(item)
	local ent = isentity(item)
	local trash = ent and item:GetTrash() or item.data.Trash
	local name = "Trashbag " .. "[ " .. trash .. ztm.config.UoW .. " ]"

	return name
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

ITEM:Register("ztm_trashbag")
