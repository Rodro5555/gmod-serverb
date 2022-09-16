local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/dom/magicmushroomfactory/potion.mdl")
ITEM:SetDescription("Una pocion magica.")

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
	local data = tbl.data
	ent:SetRecipe(data.Recipe or "poison")
    ent:SetColor(data.Color)
end)


function ITEM:GetData(ent)
	return {
		Recipe = ent:GetRecipe(),
		Color = ent:GetColor(),
	}
end

function ITEM:GetDisplayName(item)
	return self:GetName(item)
end

function ITEM:GetName(item)
	local ent = isentity(item)
	local Recipe = ent and item:GetRecipe() or item.data.Recipe
	local name = Recipe .. " Potion"

	return name
end

function ITEM:GetCameraModifiers(tbl)
	return {
		FOV = 40,
		X = 0,
		Y = -22,
		Z = 25,
		Angles = Angle(0, -190, 0),
		Pos = Vector(0, 0, -1)
	}
end

function ITEM:GetClientsideModel(tbl, mdlPanel)
	local Color = tbl.data.Color
	mdlPanel.Entity:SetColor(Color)
end

ITEM:Register("mmf_bottle")
