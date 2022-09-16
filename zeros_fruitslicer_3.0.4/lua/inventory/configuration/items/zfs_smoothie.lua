local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/zerochain/fruitslicerjob/fs_fruitcup.mdl")
ITEM:SetDescription("A tasty smoothie.")

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
	local data = tbl.data
	ent:SetProductID(data.ProductID)
	ent:SetToppingID(data.ToppingID)

	zfs.Smoothie.Visuals(ent)
end)

function ITEM:GetData(ent)
	return {
		ProductID = ent:GetProductID(),
		ToppingID = ent:GetToppingID()
	}
end

function ITEM:GetName(item)
	local ent = isentity(item)

	local pID = ent and item:GetProductID() or item.data.ProductID
	local tID = ent and item:GetToppingID() or item.data.ToppingID

	local pname = zfs.config.Smoothies[pID].Name
	local tname = zfs.config.Toppings[tID].Name

	return pname .. " [" .. tname .. "]"
end

function ITEM:GetCameraModifiers(tbl)
	return {
		FOV = 40,
		X = 0,
		Y = -25,
		Z = 25,
		Angles = Angle(0, -180, 0),
		Pos = Vector(0, 0, -1)
	}
end

function ITEM:GetClientsideModel(tbl, mdlPanel)
	mdlPanel:SetColor(zfs.Smoothie.GetColor(tbl.data.ProductID))
	mdlPanel.Entity:SetBodygroup(0, 1)
end

ITEM:Register("zfs_smoothie")
