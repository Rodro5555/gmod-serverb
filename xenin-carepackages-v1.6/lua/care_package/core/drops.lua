CarePackage.Drops = CarePackage.Drops or {}

local DROP = {}
DROP.Options = {}
DROP.ClientsideLoot = false

function DROP:CanLoot(ply, type)
	return false
end

function DROP:Loot(ply, type)
	print("Tried to do nothing " .. self.Name)
end

function DROP:GetName(ent)
	return ent
end

function DROP:GetData(ent)
	return {}
end

function DROP:GetModel(ent)
	return self.Options.Model or ".mdl"
end

function DROP:GetColor(ent)
	if (self.Options.Color) then return self.Options.Color end

	if (XeninInventory) then
		local rarity = XeninInventory.Config.Rarities[ent] or 1
		
		return XeninInventory.Config.Categories[rarity].color
	end

	return CarePackage.Config.DefaultItemColor
end

function DROP:GetPostDisplay(ent)
	return nil
end

function DROP:Register(name)
	self.Name = name

	CarePackage.Drops[name] = self
end

function CarePackage:CreateDrop()
	return table.Copy(DROP)
end

function CarePackage:GetRandomDrop()
	local tbl = self.Config.Drops
	local sum = 0

  for i, v in pairs(tbl) do
    sum = sum + (v.Drop.Options.Chance or 100)
  end

  local random = math.Rand(0, sum)
  local winningIndex
	local winningValue

  for index, v in pairs(tbl) do
    winningIndex = index
		winningValue = v
    random = random - (v.Drop.Options.Chance or 100)

    if (random <= 0) then break end
  end

  return winningIndex, winningValue
end