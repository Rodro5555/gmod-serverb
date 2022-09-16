local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/Zerochain/props_mining/zrms_storagecrate_closed.mdl")
//ITEM:SetDescription("Used to store and sell metal bars.")

ITEM:SetDescription(function(self, tbl)
	local data = tbl.data

	local desc = ""

	if data.Iron and data.Iron > 0 then
		desc = desc .. "Iron: " .. tostring(data.Iron)
	end

	if data.Bronze and data.Bronze > 0 then
		desc = desc .. " | Bronze: " .. tostring(data.Bronze)
	end

	if data.Silver and data.Silver > 0 then
		desc = desc .. " | Silver: " .. tostring(data.Silver)
	end

	if data.Gold and data.Gold > 0 then
		desc = desc .. " | Gold: " .. tostring(data.Gold)
	end

	return desc
end)


ITEM:AddDrop(function(self, ply, ent, tbl, tr)
	local data = tbl.data

	ent:SetbIron(data.Iron)
	ent:SetbBronze(data.Bronze)
	ent:SetbSilver(data.Silver)
	ent:SetbGold(data.Gold)

	zrmine.f.SetOwner(ent, ply)

	ent:SpawnFromInventory()
end)

function ITEM:GetData(ent)
	return {
		Iron = ent:GetbIron(),
		Bronze = ent:GetbBronze(),
		Silver = ent:GetbSilver(),
		Gold = ent:GetbGold(),
	}
end

function ITEM:GetDisplayName(item)
	return self:GetName(item)
end

function ITEM:GetName(item)
	local name = "Storage Crate"

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

ITEM:Register("zrms_storagecrate")
