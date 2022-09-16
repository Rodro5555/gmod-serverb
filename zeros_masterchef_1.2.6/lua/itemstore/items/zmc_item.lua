ITEM.Name = "Item"
ITEM.Description = "A Item"
ITEM.Model = "models/props_junk/PopCan01a.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false
ITEM.DropStack = false

/*
function ITEM:CanPickup(ply,ent)
	if ent:GetIsRotten() then
		return false
	else
		return true
	end
end
*/

-- We save the uniqueid to be save should the ingredients config order or item count change
function ITEM:SaveData(ent)
	self:SetData("ItemID", ent:GetItemID())
	self:SetData("IsRotten", ent:GetIsRotten())
end

-- Get the list id using the uniqueid and set it in the entity
function ITEM:LoadData(ent)
	local ItemID = self:GetData("ItemID")
	local IsRotten = self:GetData("IsRotten")

	if ItemID and zmc.Item.GetData(ItemID) then
		ent:SetItemID(ItemID)
		zmc.Item.UpdateVisual(ent, zmc.Item.GetData(ItemID), true)

		if IsRotten then zmc.Item.Spoil(ent) end
	else
		SafeRemoveEntity(ent)
	end
end

function ITEM:GetDescription()

	if self:GetData("IsRotten") == true then
		return self:GetData("Description", zmc.language["Spoiled_desc"])
	end

	local data = zmc.Item.GetData(self:GetData("ItemID"))
	local desc = ""

	if data then
		for k, v in pairs(data) do
			if zmc.Item.Components[k] == nil then continue end
			desc = desc .. zmc.Item.Components[k].desc .. "\n"
		end
	end

	return self:GetData("Description", desc)
end

function ITEM:GetName()
	local name = "Unkown"
	local data = zmc.Item.GetData(self:GetData("ItemID"))
	local IsRotten = self:GetData("IsRotten")

	if data and data.name then
		name = data.name
	end

	if IsRotten then
		name = name .. " " .. zmc.language["Spoiled"]
	end

	return self:GetData("Name", name)
end

function ITEM:CanMerge(item)
	return false
end

function ITEM:Drop(ply, con, slot, ent)
	zclib.Player.SetOwner(ent, ply)
	zmc.Item.UpdateVisual(ent, zmc.Item.GetData(self:GetData("ItemID")), true)
end

function ITEM:Use(pl)
	if SERVER then
		local IsRotten = self:GetData("IsRotten")
		local data = zmc.Item.GetData(self:GetData("ItemID"))
		if IsRotten then
			zmc.Item.EatRotten(pl)
			zclib.NetEvent.Create("eat_effect", {pl, true})
			return self:TakeOne()
		else
			if zmc.Item.Eat(self:GetData("ItemID"), pl) then
				zclib.NetEvent.Create("eat_effect", {pl, data.edible.health <= 0})

				return self:TakeOne()
			end
		end
	end
end

function ITEM:GetModel()
	local data = zmc.Item.GetData(self:GetData("ItemID"))
	local mdl = "models/props_junk/PopCan01a.mdl"

	if data and data.mdl then
		mdl = data.mdl
	end

	return self:GetData("Model", mdl)
end

function ITEM:GetColor()
	local data = zmc.Item.GetData(self:GetData("ItemID"))
	local col = color_white

	if data and data.color then
		col = data.color
	end

	return self:GetData("Color", col)
end

function ITEM:GetSkin()
	local data = zmc.Item.GetData(self:GetData("ItemID"))
	local skin = 0

	if data and data.skin then
		skin = data.skin
	end

	return self:GetData("Skin", skin)
end

function ITEM:GetMaterial()

	if self:GetData("IsRotten") == true then
		return self:GetData("Material", "zerochain/props_kitchen/zmc_rott_diff")
	end

	local data = zmc.Item.GetData(self:GetData("ItemID"))
	local mat

	if data and data.material then
		mat = data.material
	end

	return self:GetData("Material", mat)
end
