local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/zerochain/props_pizza/zpizmak_pizza.mdl")

ITEM:SetDescription(function(self, tbl)
	return zpiz.Pizza.GetDesc(tbl.data.PizzaID)
end)

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
	ent:SetPizzaID(tbl.data.PizzaID)

	timer.Simple(0.1, function()
		if IsValid(ent) then
			zpiz.Pizza.ItemStoreDrop(ent)
		end
	end)

	zclib.Player.SetOwner(ent, ply)
end)

function ITEM:GetData(ent)
	return {
		PizzaID = ent:GetPizzaID(),
	}
end

function ITEM:GetDisplayName(item)
	return self:GetName(item)
end

function ITEM:GetName(item)
	local ent = isentity(item)
	local PizzaID = ent and item:GetPizzaID() or item.data.PizzaID
	return zpiz.Pizza.GetName(PizzaID)
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
	mdlPanel.Entity:SetSkin(1)
end

ITEM:Register("zpiz_pizza")
