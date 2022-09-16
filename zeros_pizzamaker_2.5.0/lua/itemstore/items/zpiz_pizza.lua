ITEM.Name = "Pizza"
ITEM.Description = "A tasty Pizza"
ITEM.Model = "models/zerochain/props_pizza/zpizmak_pizza.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false
ITEM.DropStack = false

function ITEM:GetName()
	return self:GetData("Name", zpiz.Pizza.GetName(self:GetData("PizzaID")))
end

function ITEM:GetDescription()
	local pizzaID = self:GetData("PizzaID")
	local desc = zpiz.Pizza.GetDesc(pizzaID) .. " | Health: " .. zpiz.Pizza.GetHealth(pizzaID) .. " | Price: " .. zclib.Money.Display(zpiz.Pizza.GetPrice(pizzaID))

	return self:GetData("Description", desc)
end

function ITEM:Use(ply, con, slot)
	zpiz.Pizza.Eat(nil,self:GetData("PizzaID"),ply)
	return true
end

function ITEM:CanPickup(pl, ent)
	if ent:GetPizzaState() == 3 then
		return true
	else
		return false
	end
end

function ITEM:SaveData(ent)
	self:SetData("PizzaID", ent:GetPizzaID())
end

function ITEM:LoadData(ent)
	ent:SetPizzaID(self:GetData("PizzaID"))

	//Call function to change entity state to fully baked pizza
	timer.Simple(0.1, function()
		if IsValid(ent) then
			zpiz.Pizza.ItemStoreDrop(ent)
		end
	end)
end

function ITEM:Drop(ply, con, slot, ent)
	zclib.Player.SetOwner(ent, ply)
end
