local DROP = CarePackage:CreateDrop()
DROP.InventoryEnabled = false
DROP.Skins = {}
DROP.EquipName = function()
	return CarePackage:GetPhrase("Drops.Money.Loot")
end

function DROP:GetSkinByName(name)
	if (!self.Skins[name]) then
		for i, v in pairs(SH_EASYSKINS.GetSkins()) do
			if (v.dispName == name) then
				self.Skins[name] = v

				break
			end
		end
	end

	return self.Skins[name] or {}
end

function DROP:CanLoot(ent, ply, type)
	if (!SH_EASYSKINS) then return false end
	if CarePackage.Config.OnetimeSkinLoot then return true end
	local skins = SH_EASYSKINS.GetPurchasedSkins(ply)
	for i, v in pairs(skins) do
		local skin = self:GetSkinByName(ent.skin)

		if (v.skinID == skin.id and v.weaponClass == ent.weapon) then
			return false, "You already own this skin"
		end
	end

	return true
end

function DROP:Loot(ent, ply, type)
	if (CLIENT) then return end

	local skin = self:GetSkinByName(ent.skin)
	SV_EASYSKINS.GiveSkinToPlayer(ply:SteamID64(), skin.id, { ent.weapon })
end

function DROP:GetName(ent)
	if (!SH_EASYSKINS) then return "Easy Skins not installed" end
	local skin = SH_EASYSKINS.GetSkin(self:GetSkinByName(ent.skin).id)
	if (!skin) then return "Invalid Skin ID" end

	local wep = weapons.Get(ent.weapon)
	local str = wep and wep.PrintName or ent.weapon

	return skin.dispName .. " " .. str .. " skin"
end

function DROP:GetModel(ent)
	local wep = weapons.Get(ent.weapon)
	if (!wep) then return ".mdl" end

	return wep.WorldModel or wep.WM or wep.ViewModel or wep.VM
end

function DROP:GetData(ent)
	return {}
end

function DROP:GetPostDisplay(panel, reward, amount)
	if (!IsValid(panel.Model)) then return end
	if (!SH_EASYSKINS) then return end
	local skin = SH_EASYSKINS.GetSkin(self:GetSkinByName(reward.skin).id)
	if (!skin) then return end

	SH_EASYSKINS.ApplySkinToModel(panel.Model.Entity, skin.material.path)
end

function DROP:GetColor(ent)
	if (self.Options.Color) then return self.Options.Color end

	return CarePackage.Config.DefaultItemColor
end

DROP:Register("EasySkins")
