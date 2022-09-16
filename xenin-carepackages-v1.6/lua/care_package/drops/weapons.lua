local DROP = CarePackage:CreateDrop()
DROP.Options = {}
DROP.InventoryEnabled = true

function DROP:CanLoot(ent, ply, type)
	if (type == CAREPACKAGE_STANDARD) then
		return !ply:HasWeapon(ent), CarePackage:GetPhrase("Drops.Weapons.Equipped")
	elseif (type == CAREPACKAGE_INVENTORY) then
		if (!XeninInventory) then return false, CarePackage:GetPhrase("Drops.Weapons.DontOwnXeninInventory") end

		local inv = ply:XeninInventory()
		local tbl = inv:GetInventory()
		local slots = inv:GetSlots()
		local amt = table.Count(tbl)

		return slots >= amt, CarePackage:GetPhrase("Drops.Weapons.InventoryFull")
	end
end

function DROP:Loot(ent, ply, type)
	if (type == CAREPACKAGE_STANDARD) then
		ply:Give(ent)
		ply:SelectWeapon(ent)
	elseif (type == CAREPACKAGE_INVENTORY) then
		local inv = ply:XeninInventory()
		local wep = weapons.Get(ent)
		local clipSize = (wep and wep.Primary and wep.Primary.ClipSize) or 0

		inv:AddV2(ent, DarkRP and "spawned_weapon" or ent, 1, {
			Clip1 = clipSize
		})
	end
end

function DROP:GetName(ent)
	return weapons.Get(ent).PrintName or ""
end

function DROP:GetModel(ent)
	return weapons.Get(ent).WorldModel or ".mdl"
end

DROP:Register("Weapon")