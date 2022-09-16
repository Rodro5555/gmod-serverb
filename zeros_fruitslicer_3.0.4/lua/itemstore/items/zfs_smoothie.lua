ITEM.Name = "Smoothie"
ITEM.Description = "A tasty smoothie."
ITEM.Model = "models/zerochain/fruitslicerjob/fs_fruitcup.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false
ITEM.DropStack = false

function ITEM:GetName()
	local ProductID = self:GetData("ProductID")
	local ToppingID = self:GetData("ToppingID")
	local pname = zfs.config.Smoothies[ ProductID ].Name
	local tname = zfs.config.Toppings[ ToppingID ].Name

	return self:GetData("Name", pname .. " [" .. tname .. "]")
end

function ITEM:GetDescription()
	local dat = zfs.Smoothie.GetData(self:GetData("ProductID"))

	return self:GetData("Description", dat.info)
end

function ITEM:GetColor()
	return self:GetData("Color", zfs.Smoothie.GetColor(self:GetData("ProductID")))
end

function ITEM:SaveData(ent)
	self:SetData("ProductID", ent:GetProductID())
	self:SetData("ToppingID", ent:GetToppingID())
end

function ITEM:LoadData(ent)
	local ProductID = self:GetData("ProductID")
	local ToppingID = self:GetData("ToppingID")

	if ProductID and ToppingID then
		ent:SetProductID(ProductID)
		ent:SetToppingID(ToppingID)
	else
		SafeRemoveEntity(ent)
	end
end

function ITEM:Drop(ply, con, slot, ent)
	zclib.Player.SetOwner(ent, ply)
	zfs.Smoothie.Visuals(ent)
end
