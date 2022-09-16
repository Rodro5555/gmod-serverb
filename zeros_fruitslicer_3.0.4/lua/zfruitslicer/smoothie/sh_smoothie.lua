zfs = zfs or {}
zfs.Smoothie = zfs.FruitCup or {}

function zfs.Smoothie.GetData(id)
	return zfs.config.Smoothies[id]
end

function zfs.Smoothie.IsValid(id)
	return zfs.Smoothie.GetData(id) ~= nil
end

function zfs.Smoothie.GetColor(id)
	local dat = zfs.Smoothie.GetData(id)
	return dat.fruitColor or color_white
end

// Returns how much health the player would get from this smoothie
function zfs.Smoothie.GetHealth(id)
	local dat = zfs.Smoothie.GetData(id)
	local _health = 0
	for k, v in pairs(dat.recipe) do
		if (v > 0) then
			_health = _health + zfs.Fruit.GetHealth(k)
		end
	end
	return _health
end

// This Calculates our Fruit varation Boni
function zfs.Smoothie.GetFruitVarationBoni(id)
	local SmoothieData = zfs.Smoothie.GetData(id)
	local FruitVariationCount = 0
	for k, v in pairs(SmoothieData.recipe) do
		if (v > 0) then
			FruitVariationCount = FruitVariationCount + 1
		end
	end
	return FruitVariationCount / table.Count(zfs.config.Fruits)
end
