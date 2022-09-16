local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/zerochain/props_oilrush/zor_barrel.mdl")
ITEM:SetDescription("Used to store Oil and Fuel.")

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
	local data = tbl.data
	ent:SetOil(data.Oil)
	ent:SetFuel(data.Fuel)
	ent:SetFuelTypeID(data.FuelTypeID)
	zclib.Player.SetOwner(ent, ply)
	zrush.Barrel.UpdateVisual(ent)
end)

function ITEM:GetData(ent)
	return {
		Oil = ent:GetOil(),
		Fuel = ent:GetFuel(),
		FuelTypeID = ent:GetFuelTypeID()
	}
end

function ITEM:GetDisplayName(item)
	return self:GetName(item)
end

function ITEM:GetName(item)
	local name = "Undefind"
	local ent = isentity(item)
	local Oil = ent and item:GetOil() or item.data.Oil
	local Fuel = ent and item:GetFuel() or item.data.Fuel
	local FuelTypeID = ent and item:GetFuelTypeID() or item.data.FuelTypeID

	if Oil > 0 then
		name = "Oil"
	elseif Fuel > 0 then
		local fuelData = zrush.FuelTypes[FuelTypeID]
		name = fuelData.name
	else
		name = "Empty Barrel"
	end

	return name
end

function ITEM:GetVisualAmount(tbl)
	if (not tbl) then return end

	if tbl.data.Oil > 0 then
		return tbl.data.Oil
	elseif tbl.data.Fuel > 0 then
		return tbl.data.Fuel
	end
end

function ITEM:GetCameraModifiers(tbl)
	return {
		FOV = 40,
		X = 0,
		Y = 0,
		Z = 50,
		Angles = Angle(0, -90, 0),
		Pos = Vector(0, 0, 0)
	}
end

function ITEM:GetClientsideModel(tbl, mdlPanel)
	local Oil = tbl.data.Oil
	local Fuel = tbl.data.Fuel
	local FuelTypeID = tbl.data.FuelTypeID

	if Oil > 0 then
		mdlPanel:SetColor(zrush.default_colors["grey02"])
	elseif Fuel > 0 then
		local fuelData = zrush.FuelTypes[FuelTypeID]
		mdlPanel:SetColor(fuelData.color)
	else
		mdlPanel:SetColor(color_white)
	end
end

ITEM:Register("zrush_barrel")
