/////////////////////////
// Darkrp weapons
zvm.config.PredefinedNames["weapon_ak47custom"] = "AK47"
zvm.config.PredefinedNames["weapon_ak472"] = "AK47"
zvm.config.PredefinedNames["weapon_deagle2"] = "Deagle"
zvm.config.PredefinedNames["weapon_fiveseven2"] = "FiveSeven"
zvm.config.PredefinedNames["weapon_glock2"] = "Glock"
zvm.config.PredefinedNames["weapon_m42"] = "M4"
zvm.config.PredefinedNames["weapon_mac102"] = "Mac10"
zvm.config.PredefinedNames["weapon_mp52"] = "MP5"
zvm.config.PredefinedNames["weapon_p2282"] = "P228"
zvm.config.PredefinedNames["weapon_pumpshotgun2"] = "Pump Shotgun"
zvm.config.PredefinedNames["ls_sniper"] = "Silenced Sniper"

hook.Add("zvm_OnItemDataCatch", "zvm_OnItemDataCatch_darkrp", function(data, ent, itemclass)

	// Spawned Shipment
	if itemclass == "spawned_shipment" then
		local contents = ent:Getcontents()
		data.Ammount = ent:Getcount()
		data.contents = contents
	end

	// Ammo
	if itemclass == "spawned_ammo" then
		data.amountGiven = ent.amountGiven
		data.ammoType = ent.ammoType
	end

	// Food
	if itemclass == "spawned_food" then
		data.foodItem = ent.foodItem
	end

	// Spawned Weapon
	if itemclass == "spawned_weapon" then
		data.WeaponClass = ent:GetWeaponClass()
	end
end)

hook.Add("zvm_OnItemDataApplyPreSpawn", "zvm_OnItemDataApplyPreSpawn_darkrp", function(itemclass, ent, extraData)

	// Spawned Shipment
    if itemclass == "spawned_shipment" then
        ent:SetContents(extraData.contents,extraData.Ammount)
        //ent.dt.count = extraData.Ammount
	end

    // Ammo
    if itemclass == "spawned_ammo" then
        ent.amountGiven = extraData.amountGiven
        ent.ammoType = extraData.ammoType
	end

    // Food
    if itemclass == "spawned_food" then
        ent.foodItem = extraData.foodItem
        ent.FoodEnergy = extraData.foodItem.energy
	end

    // Spawned weapons
    if itemclass == "spawned_weapon" then
        ent:SetWeaponClass(extraData.WeaponClass)
    end
end)

hook.Add("zvm_ItemExists", "zvm_ItemExists_darkrp", function(itemclass,compared_item,extraData)

	// Spawned Shipment
	if itemclass == "spawned_shipment" then
		return true , compared_item.extraData.contents == extraData.contents and compared_item.extraData.Ammount == extraData.Ammount
	end

	// Spawned Weapon
	if itemclass == "spawned_weapon" then
		return true , compared_item.extraData.WeaponClass == extraData.WeaponClass
	end

	// Ammo
	if itemclass == "spawned_ammo" then
		return true , compared_item.extraData.ammoType == extraData.ammoType and compared_item.extraData.amountGiven == extraData.amountGiven
	end

	// Food
	if itemclass == "spawned_food" then
		return true , compared_item.extraData.foodItem.model == extraData.foodItem.model
	end
end)

hook.Add("zvm_OnItemDataName", "zvm_OnItemDataName_darkrp", function(ent, extraData)

	local itemclass = ent:GetClass()

	// Spawned Shipment
	if itemclass == "spawned_shipment" then
		local contents = CustomShipments[extraData.contents]
		if contents.name then
			return contents.name .. " [" .. extraData.Ammount .. "x]"
		end
	end

	// Spawned Weapon
	if itemclass == "spawned_weapon" then
		return ent:GetWeaponClass()
	end

	// Ammo
	if itemclass == "spawned_ammo" then
		return ent.ammoType .. " [" .. ent.amountGiven .. "x]"
	end

	// Food
	if itemclass == "spawned_food" and extraData.foodItem and extraData.foodItem.name then
		return extraData.foodItem.name
	end
end)
