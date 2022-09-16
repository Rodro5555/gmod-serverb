local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(10)
ITEM:SetModel("models/Zerochain/props_mining/zrms_bar.mdl")
ITEM:SetDescription("A Bar of Metal")

function ITEM:CanStack(newItem, invItem)
	local ent = isentity(newItem)
	local metaltype = ent and newItem:GetMetalType() or newItem.data.MetalType
	return metaltype == invItem.data.MetalType
end

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
	local data = tbl.data
	ent:SetMetalType(data.MetalType)
	zrmine.f.SetOwner(ent, ply)
	ent:UpdateVisuals()
end)

function ITEM:GetData(ent)
	return {
		MetalType = ent:GetMetalType()
	}
end

function ITEM:GetDisplayName(item)
	return self:GetName(item)
end

function ITEM:GetName(item)
	local ent = isentity(item)
	local metaltype = ent and item:GetMetalType() or item.data.MetalType
	local name = metaltype .. " Bar"

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
	local MetalType = tbl.data.MetalType

	if (MetalType == "Iron") then
		mdlPanel.Entity:SetSkin(0)
	elseif (MetalType == "Bronze") then
		mdlPanel.Entity:SetSkin(1)
	elseif (MetalType == "Silver") then
		mdlPanel.Entity:SetSkin(2)
	elseif (MetalType == "Gold") then
		mdlPanel.Entity:SetSkin(3)
	end
end

ITEM:Register("zrms_bar")
