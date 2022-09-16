local DROP = CarePackage:CreateDrop()
DROP.InventoryEnabled = false
DROP.EquipName = function()
	return CarePackage:GetPhrase("Drops.Money.Take")
end

function DROP:CanLoot(ent, ply, type)
	return true
end

function DROP:Loot(ent, ply, type)
	ply:addMoney(ent)
end

function DROP:GetName(ent)
	return DarkRP.formatMoney(ent)
end

function DROP:GetModel(ent)
	return GAMEMODE.Config.moneyModel
end

function DROP:GetData(ent)
	return {
		camera = {
			x = 40,
			y = -20
		}
	}
end

function DROP:GetColor(ent)
	if (self.Options.Color) then return self.Options.Color end

	if (XeninInventory) then
		local rarity = XeninInventory.Config.Rarities["spawned_money"] or 1
		
		return XeninInventory.Config.Categories[rarity].color
	end

	return CarePackage.Config.DefaultItemColor
end

DROP:Register("Money")