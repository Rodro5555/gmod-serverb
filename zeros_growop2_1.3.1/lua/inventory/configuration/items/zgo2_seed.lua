local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/zerochain/props_growop2/zgo2_weedseeds.mdl")

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
	local data = tbl.data

	if not zgo2.Plant.IsValid(data.WeedID) then
		zclib.Notify(ply, zgo2.language[ "InvalidPlantData" ], 1)
		SafeRemoveEntity(ent)

		return
	end

	ent:SetPlantID(zgo2.Plant.GetListID(data.WeedID))
	ent:SetCount(data.Count)
	zclib.Player.SetOwner(ent, ply)
end)

function ITEM:GetData(ent)
	return {
		WeedID = zgo2.Plant.GetID(ent:GetPlantID()),
		Count = math.Round(ent:GetCount()),
	}
end

function ITEM:GetVisualAmount(item)
	return item.data.Count
end

function ITEM:GetName(item)
	local ent = isentity(item)
	local WeedID = ent and item:GetPlantID() or item.data.WeedID
	local Count = ent and item:GetCount() or (item.data.Count or 50)
	local WeedData = zgo2.Plant.GetData(WeedID)
	if not WeedData then return "Seeds" end

	return zgo2.Plant.GetName(WeedID) .. " " .. Count .. "x"
end

function ITEM:GetDisplayName(item)
	return self:GetName(item)
end

local ang = Angle(0, 45, 0)

function ITEM:GetCameraModifiers(tbl)
	return {
		FOV = 30,
		X = 0,
		Y = 0,
		Z = 50,
		Angles = ang,
		Pos = vector_origin
	}
end

function ITEM:GetClientsideModel(tbl, mdlPanel)
	local WeedData = zgo2.Plant.GetData(tbl.data.WeedID)
	if not WeedData then return end
	zgo2.Seed.UpdateMaterial(mdlPanel.Entity, WeedData, false)
end

ITEM:Register("zgo2_seed")
