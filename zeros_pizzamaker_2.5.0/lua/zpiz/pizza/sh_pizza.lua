zpiz = zpiz or {}
zpiz.Pizza = zpiz.Pizza or {}

function zpiz.Pizza.GetData(id)
	return zpiz.config.Pizza[id]
end

function zpiz.Pizza.GetName(id)
	local dat = zpiz.Pizza.GetData(id)
	if dat then
		return dat.name
	else
		return "Unkown"
	end
end

function zpiz.Pizza.GetDesc(id)
	local dat = zpiz.Pizza.GetData(id)
	if dat then
		return dat.desc
	else
		return "Unkown"
	end
end

function zpiz.Pizza.GetBakeTime(id)
	local dat = zpiz.Pizza.GetData(id)
	if dat then
		return dat.time
	else
		return 10
	end
end

function zpiz.Pizza.GetHealth(id)
	local dat = zpiz.Pizza.GetData(id)
	if dat then
		return dat.health
	else
		return 0
	end
end

function zpiz.Pizza.GetHealthCap(id)
	local dat = zpiz.Pizza.GetData(id)
	if dat then
		return dat.health_cap
	else
		return 0
	end
end

function zpiz.Pizza.GetRecipe(id)
	local dat = zpiz.Pizza.GetData(id)
	if dat then
		return dat.recipe
	else
		return {}
	end
end

// Returns a random pizza according to the provided chance var
function zpiz.Pizza.GetRandom()
	local PizzaPool = {}

	for k, v in pairs(zpiz.config.Pizza) do
		for i = 1, v.chance do
			table.insert(PizzaPool, k)
		end
	end

	local pizza = PizzaPool[math.random(#PizzaPool)]

	return pizza
end

// Returns the price of the pizza + ingredient cost
function zpiz.Pizza.GetPrice(pizzaID)
	local pizzaData = zpiz.config.Pizza[pizzaID]
	if pizzaData == nil then return 0 end

	local pizzaprice = zpiz.Ingredient.GetPrice(ZPIZ_ING_DOUGH) + pizzaData.price
	for ing_id, ing_amount in pairs(zpiz.Pizza.GetRecipe(pizzaID)) do
		if (ing_amount > 0) then
			pizzaprice = pizzaprice + (zpiz.Ingredient.GetPrice(ing_id) * ing_amount)
		end
	end

	return pizzaprice
end

function zpiz.Pizza.GetIcon(id)
	local dat = zpiz.Pizza.GetData(id)
	if dat then
		return dat.icon
	else
		return zpiz.materials["zpiz_circle"]
	end
end
