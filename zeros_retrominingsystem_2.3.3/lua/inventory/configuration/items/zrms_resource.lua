local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/Zerochain/props_mining/zrms_resource.mdl")
ITEM:SetDescription("A metal ore.")

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
	local data = tbl.data
	ent:SetResourceType(data.ResourceType)
	ent:SetResourceAmount(data.ResourceAmount)
	zrmine.f.SetOwner(ent, ply)
end)


function ITEM:GetData(ent)
	return {
		ResourceType = ent:GetResourceType(),
		ResourceAmount = ent:GetResourceAmount(),
	}
end

function ITEM:GetDisplayName(item)
	return self:GetName(item)
end

function ITEM:GetName(item)
	local ent = isentity(item)
	local r_type = ent and item:GetResourceType() or item.data.ResourceType
	local r_amount = ent and item:GetResourceAmount() or item.data.ResourceAmount
	local name = r_amount .. zrmine.config.BuyerNPC_Mass .. " " .. r_type .. " Ore"

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
	local ResourceType = tbl.data.ResourceType

	if (ResourceType == "Iron") then
		mdlPanel.Entity:SetSkin(0)
	elseif (ResourceType == "Bronze") then
		mdlPanel.Entity:SetSkin(1)
	elseif (ResourceType == "Silver") then
		mdlPanel.Entity:SetSkin(2)
	elseif (ResourceType == "Gold") then
		mdlPanel.Entity:SetSkin(3)
	elseif (ResourceType == "Coal") then
		mdlPanel.Entity:SetSkin(4)
	end
end

ITEM:Register("zrms_resource")
