zpiz = zpiz or {}
zpiz.Ingredient = zpiz.Ingredient or {}

function zpiz.Ingredient.GetData(id)
	return zpiz.config.Ingredients[id]
end

function zpiz.Ingredient.GetName(id)
	local dat = zpiz.Ingredient.GetData(id)
	if dat then
		return dat.name
	else
		return "Unkown"
	end
end

function zpiz.Ingredient.GetModel(id)
	local dat = zpiz.Ingredient.GetData(id)
	if dat then
		return dat.model
	else
		return "Unkown"
	end
end

function zpiz.Ingredient.GetIcon(id)
	local dat = zpiz.Ingredient.GetData(id)
	if dat then
		return dat.icon
	else
		return zpiz.materials["zpiz_circle"]
	end
end

function zpiz.Ingredient.GetColor(id)
	local dat = zpiz.Ingredient.GetData(id)
	if dat then
		return dat.color
	else
		return color_white
	end
end

function zpiz.Ingredient.GetPrice(id)
	local dat = zpiz.Ingredient.GetData(id)
	if dat then
		return dat.price
	else
		return 0
	end
end
