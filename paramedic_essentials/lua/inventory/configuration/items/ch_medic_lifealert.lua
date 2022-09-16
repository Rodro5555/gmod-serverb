local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(5)
ITEM:SetModel("models/craphead_scripts/paramedic_essentials/props/alarm.mdl")
ITEM:SetDescription("If equipped it will notify paramedics of your location upon death.")

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
    local data = tbl.data
end)

function ITEM:GetData(ent)
end

function ITEM:GetName(item)
	return "Life Alert"
end

function ITEM:GetCameraModifiers(tbl)
	return {
		FOV = 40,
		X = 0,
		Y = -25,
		Z = 25,
		Angles = Angle(90, 70, 0),
		Pos = Vector(0, 0, 2)
	}
end

ITEM:Register("ch_medic_lifealert")
