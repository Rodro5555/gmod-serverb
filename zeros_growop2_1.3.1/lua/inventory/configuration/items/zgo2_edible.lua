local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/zerochain/props_growop2/zgo2_food_muffin.mdl")

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
	local data = tbl.data

	if zgo2.Plant.IsValid(data.WeedID) then
		ent:SetWeedID(zgo2.Plant.GetListID(data.WeedID))
		ent:SetWeedAmount(data.WeedAmount)
		ent:SetWeedTHC(data.WeedTHC or 50)

		ent:SetBodygroup(0,1)
	end


	local EdibleData = zgo2.Edible.GetData(data.EdibleID)
	if EdibleData then
		ent:SetModel(EdibleData.edible_model)
	end


	ent:SetEdibleID(data.EdibleID)

	zclib.Player.SetOwner(ent, ply)
end)

function ITEM:GetData(ent)
	return {
		WeedID = zgo2.Plant.GetID(ent:GetWeedID()),
		WeedAmount = math.Round(ent:GetWeedAmount()),
		WeedTHC = math.Round(ent:GetWeedTHC()),
		EdibleID = ent:GetEdibleID()
	}
end

function ITEM:GetVisualAmount(item)
	return 1
end

function ITEM:GetName(item)
	local ent = isentity(item)

	local EdibleID = ent and item:GetEdibleID() or item.data.EdibleID

	local WeedID = ent and item:GetWeedID() or item.data.WeedID
	local WeedTHC = ent and item:GetWeedTHC() or ( item.data.WeedTHC or 50 )

	local name = zgo2.Edible.GetName(EdibleID)

	local WeedData = zgo2.Plant.GetData(WeedID)
	if not WeedData then return name end



	return name .. " | " .. zgo2.Plant.GetName(WeedID) .. " THC: " .. WeedTHC .. "%"
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

	local EdibleData = zgo2.Edible.GetData(tbl.data.EdibleID)
	if EdibleData then
		mdlPanel.Entity:SetModel(EdibleData.edible_model)
	end

	local WeedData = zgo2.Plant.GetData(tbl.data.WeedID)
	if not WeedData then return end

	mdlPanel.Entity:SetBodygroup(0,1)

	zgo2.Plant.UpdateMaterial(mdlPanel.Entity, WeedData)
end

ITEM:Register("zgo2_edible")
