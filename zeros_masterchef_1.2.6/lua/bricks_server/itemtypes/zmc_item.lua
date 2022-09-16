local ITEM = BRICKS_SERVER.Func.CreateItemType("zmc_item")

ITEM.GetItemData = function(ent)
    if (not IsValid(ent)) then return end
    local itemData = {"zmc_item", "models/props_junk/PopCan01a.mdl", ent:GetItemID(), ent:GetIsRotten()}

    return itemData, 1
end

ITEM.OnSpawn = function(ply, pos, itemData, itemAmount)
    local ItemID = itemData[3]
    local IsRotten = itemData[4]

    if ItemID and zmc.Item.GetData(ItemID) then
        local ent = ents.Create("zmc_item")
        if not IsValid(ent) then return end
        ent:SetPos(pos)
        ent:Spawn()
        ent:Activate()
        ent:SetItemID(ItemID)
        zclib.Player.SetOwner(ent, ply)
        zmc.Item.UpdateVisual(ent, zmc.Item.GetData(ItemID), true)

        if IsRotten then
            zmc.Item.Spoil(ent)
        end
    end
end

ITEM.CanUse = function(ply, itemData) return true end

ITEM.OnUse = function(ply, itemData)
    local ItemID = itemData[3]
    local IsRotten = itemData[4]

    if SERVER then
        if IsRotten then
            zmc.Item.EatRotten(ply)
            zclib.NetEvent.Create("eat_effect", {ply, true})
            return true
        else
            if zmc.Item.Eat(ItemID, ply) then
                local dat = zmc.Item.GetData(ItemID)
                zclib.NetEvent.Create("eat_effect", {ply, dat.edible.health <= 0})
                return true
            else
                return false
            end
        end
    else
        return false
    end
end

ITEM.GetInfo = function(itemData)
    local ItemID = itemData[3]
    local IsRotten = itemData[4]
    local ItemData = zmc.Item.GetData(ItemID)
    local itemDescription = ""
    local itemtitle = ""

    if ItemData then
        itemtitle = ItemData.name

        if IsRotten then
            itemtitle = itemtitle .. " " .. zmc.language["Spoiled"]
        end

        for k, v in pairs(ItemData) do
            if zmc.Item.Components[k] == nil then continue end
            itemDescription = itemDescription .. zmc.Item.Components[k].desc .. "\n"
        end

        if IsRotten then
            itemDescription = zmc.language["Spoiled_desc"]
        end

    end

    return {itemtitle, itemDescription, ""}
end

ITEM.ModelDisplay = function(Panel, itemtable)
    if (not Panel.Entity or not IsValid(Panel.Entity)) then return end
    local mn, mx = Panel.Entity:GetRenderBounds()
    local size = 0
    size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
    size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
    size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
    Panel:SetFOV(50)
    Panel:SetCamPos(Vector(size, size * 3, size * 2))
    Panel:SetLookAt((mn + mx) * 0.5)
    Panel.Entity:SetAngles(Angle(0, 45, 0))
    local data = zmc.Item.GetData(itemtable[3])

    if data then
        zmc.Item.UpdateVisual(Panel.Entity, data, true)

        if data.color then
            Panel:SetColor(data.color)
        end

        if itemtable[4] == true then
            Panel.Entity:SetMaterial("zerochain/props_kitchen/zmc_rott_diff")
        end
    end
end

ITEM.CanCombine = function(itemData1, itemData2) return false end
ITEM:Register()

if BRICKS_SERVER and BRICKS_SERVER.CONFIG and BRICKS_SERVER.CONFIG.INVENTORY and BRICKS_SERVER.CONFIG.INVENTORY.Whitelist then
    BRICKS_SERVER.CONFIG.INVENTORY.Whitelist["zmc_item"] = {false, true}
end
