local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack(1)
ITEM:SetModel("models/props_junk/PopCan01a.mdl")

/*
function ITEM:OnPickup(ply, ent)
	if (not IsValid(ent)) then return end

	if ent:GetIsRotten() == true then return end

	local info = {
		ent = self:GetEntityClass(ent),
		dropEnt = self:GetDropEntityClass(ent),
		amount = self:GetEntityAmount(ent),
		data = self:GetData(ent)
	}

	self:Pickup(ply, ent, info)

	return true
end
*/

ITEM:AddAction("Use", 1, function(self, ply, ent, tbl)
    if CLIENT then return true end
    local data = tbl.data
    local IsRotten = data.IsRotten

    if IsRotten then
        zmc.Item.EatRotten(ply)
        zclib.NetEvent.Create("eat_effect", {ply, true})
    else
        if zmc.Item.Eat(data.ItemID, ply) then
            local dat = zmc.Item.GetData(data.ItemID)
            zclib.NetEvent.Create("eat_effect", {ply, dat.edible.health <= 0})
        end
    end
end, function() return true end)

ITEM:AddDrop(function(self, ply, ent, tbl, tr)
    local data = tbl.data
    local ItemID = data.ItemID
    local IsRotten = data.IsRotten

    if ItemID and zmc.Item.GetData(ItemID) then
        ent:SetItemID(ItemID)
        zclib.Player.SetOwner(ent, ply)
        zmc.Item.UpdateVisual(ent,zmc.Item.GetData(ItemID),true)

        if IsRotten then zmc.Item.Spoil(ent) end
    else
        SafeRemoveEntity(ent)
    end
end)

ITEM:SetDescription(function(self, tbl)

    if tbl.data.IsRotten then
        return {zmc.language["Spoiled_desc"]}
    end

    local desc = {}
    local data = zmc.Item.GetData(tbl.data.ItemID)
    if data then
        for k,v in pairs(data) do
            if zmc.Item.Components[k] == nil then continue end
            table.insert(desc,zmc.Item.Components[k].desc)
        end
    end
    return desc
end)

function ITEM:GetData(ent)
    return {
        ItemID = ent:GetItemID(),
        IsRotten = ent:GetIsRotten()
    }
end

function ITEM:GetDisplayName(item)
    return self:GetName(item)
end

function ITEM:GetName(item)
    local name = "Unkown"
    local ent = isentity(item)
    local ItemID
    local IsRotten

    if ent then
        ItemID = item:GetItemID()
        ItemID = item:GetIsRotten()
    else
        ItemID = item.data.ItemID
        IsRotten = item.data.IsRotten
    end

    local data = zmc.Item.GetData(ItemID)

    if data and data.name then
        name = data.name
    end

    if IsRotten then
        name = name .. " " .. zmc.language["Spoiled"]
    end

    return name
end

function ITEM:GetCameraModifiers(tbl)
    return {
        FOV = 30,
        X = 0,
        Y = 0,
        Z = 50,
        Angles = Angle(0, 45, 0),
        Pos = Vector(0, 0, 0)
    }
end

function ITEM:GetClientsideModel(tbl, mdlPanel)
    local data = zmc.Item.GetData(tbl.data.ItemID)

    if data then
        zmc.Item.UpdateVisual(mdlPanel.Entity, data, true)

        if data.color then
            mdlPanel:SetColor(data.color)
        end

        if tbl.data.IsRotten then
            mdlPanel.Entity:SetMaterial("zerochain/props_kitchen/zmc_rott_diff")
        end
    end
end

function ITEM:GetSkin(tbl)
    local ItemID = tbl.data.ItemID
    local data = zmc.Item.GetData(ItemID)
    local skin = 0

    if data and data.skin then
        skin = data.skin
    end

    return skin
end

ITEM:Register("zmc_item")
