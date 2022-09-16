ITEM.Name = "Dish"
ITEM.Description = "A Dish"
ITEM.Model = "models/props_junk/PopCan01a.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false
ITEM.DropStack = false

-- We save the uniqueid to be save should the ingredients config order or item count change
function ITEM:SaveData(ent)
	self:SetData("DishID", ent:GetDishID())
	self:SetData("EatProgress", ent:GetEatProgress())
end

-- Get the list id using the uniqueid and set it in the entity
function ITEM:LoadData(ent)
	local DishID = self:GetData("DishID")
	local EatProgress = self:GetData("EatProgress")

	if DishID and zmc.Dish.GetData(DishID) and EatProgress then
		ent:SetDishID(DishID)
		ent:SetEatProgress(EatProgress)

		local DishData = zmc.Dish.GetData(DishID)
		if DishData.mdl then ent:SetModel(DishData.mdl) end

	else
		SafeRemoveEntity(ent)
	end
end

function ITEM:GetDescription()
	local desc = zmc.language["price_title"] .. ": " .. zclib.Money.Display(zmc.Dish.GetPrice(self:GetData("DishID")))

	return self:GetData("Description", desc)
end

function ITEM:GetName()
	local name = "Unkown"
	local data = zmc.Dish.GetData(self:GetData("DishID"))

	if data and data.name then
		name = data.name
	end

	return self:GetData("Name", name)
end

function ITEM:CanMerge(item)
	return false
end

function ITEM:Drop(ply, con, slot, ent)
	zclib.Player.SetOwner(ent, ply)
end

function ITEM:Use(pl)
	if SERVER then
		local DishData = zmc.Dish.GetData(self:GetData("DishID"))
		if DishData == nil then return end
		if DishData.items == nil then return end
		local foodCount = table.Count(DishData.items)
		if foodCount == 0 then return end

		if self:GetData("EatProgress") == -1 then
			self:SetData("EatProgress", foodCount)
		end

		for k, v in pairs(DishData.items) do
			if v and v.uniqueid and self:GetData("EatProgress") > 0 then
				zmc.Item.Eat(v.uniqueid, pl)
				self:SetData("EatProgress", self:GetData("EatProgress") - 1)
			end
		end

		zclib.NetEvent.Create("eat_effect", {pl,false})
		return self:TakeOne()
	end
end

function ITEM:GetModel()
	local data = zmc.Dish.GetData(self:GetData("DishID"))
	local mdl = "models/props_junk/PopCan01a.mdl"

	if data and data.mdl then
		mdl = data.mdl
	end

	return self:GetData("Model", mdl)
end
