local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/dom/magicmushroomfactory/book.mdl")
ITEM:SetDescription("Guia de Pociones.")

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
end)


function ITEM:GetData(ent)
	return {
	}
end

function ITEM:GetDisplayName(item)
	return self:GetName(item)
end

function ITEM:GetName(item)
	return "Guia de Pociones"
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

ITEM:Register("mmf_guide")
