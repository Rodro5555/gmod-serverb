zmc = zmc or {}
zmc.Inventory = zmc.Inventory or {}

zmc.InventoryCache = zmc.InventoryCache or {}
/*

    This inventory system does not get saved and is only used to temporarly store items

*/

function zmc.Inventory.Get(ent)
    //zclib.Debug("zmc.Inventory.Get")
    if not IsValid(ent) then return {} end
    return ent.zmc_inv or zmc.InventoryCache[ent:EntIndex()] or {}
end

function zmc.Inventory.GetSlotData(ent,slot_id)
    //zclib.Debug("zmc.Inventory.GetSlotData")
    if slot_id == nil then return end
    if not IsValid(ent) then return end
    local inv = zmc.Inventory.Get(ent)
    return inv[slot_id]
end

function zmc.Inventory.SlotIsEmpty(ent,slot_id)
    local slot_data = zmc.Inventory.GetSlotData(ent,slot_id)
    return slot_data and table.IsEmpty(slot_data)
end

// Returns the slot key of the first slot which matches the itemid
function zmc.Inventory.FindItem(ent,ItemID)
    local slot = false
    for k,v in pairs(zmc.Inventory.Get(ent)) do
        if v and v.itm == ItemID then
            slot = k
            break
        end
    end
    zclib.Debug("zmc.Inventory.FindItem " .. tostring(slot))
    return slot
end

function zmc.Inventory.Has(ent,ItemID)
    zclib.Debug("zmc.Inventory.Has")
    local result = zmc.Inventory.FindItem(ent,ItemID)
    return result ~= false
end

// Returns the first valid item it can find
function zmc.Inventory.GetValidItem(ent)
    zclib.Debug("zmc.Inventory.GetValidItem")
    local item,slot
    for k,v in pairs(zmc.Inventory.Get(ent)) do
        if v and v.itm then
            slot = k
            item = v.itm
            break
        end
    end
    return item,slot
end

// Returns the first free slot it can find
function zmc.Inventory.FindFreeSlot(ent)
    local slot = false
    for k,v in pairs(zmc.Inventory.Get(ent)) do
        if v and zmc.Inventory.SlotIsEmpty(ent,k) then
            slot = k
            break
        end
    end
    zclib.Debug("zmc.Inventory.FindFreeSlot " .. tostring(slot))
    return slot
end

// Returns all the items which are currently missing from the Inventory
function zmc.Inventory.GetMissing(ent,NeededItems)
    if NeededItems == nil then return {} end
    local temp = {}
    for k,v in pairs(NeededItems) do
        table.insert(temp,v)
    end
    for k,v in pairs(zmc.Inventory.Get(ent)) do
        table.RemoveByValue(temp,v.itm)
    end
    local missing = {}
    for k,v in pairs(temp) do
        table.insert(missing,{itm = v})
    end
    return missing
end

function zmc.Inventory.GetThrowTravelTime(from,to)
    local traveltime = from:GetPos():Distance(to:GetPos())
    traveltime = traveltime / 500
    return traveltime
end

if SERVER then
    util.AddNetworkString("zmc_Inventory_Drop")
    util.AddNetworkString("zmc_Inventory_Sync")

    function zmc.Inventory.Synch(ent)
        zclib.Debug("zmc.Inventory.Synch")
        if not IsValid(ent) then return end
        local e_String = util.TableToJSON(zmc.Inventory.Get(ent))
        local e_Compressed = util.Compress(e_String)
        net.Start("zmc_Inventory_Sync")
        net.WriteUInt(#e_Compressed, 16)
        net.WriteData(e_Compressed, #e_Compressed)
        net.WriteEntity(ent)
        net.WriteUInt(ent:EntIndex(),16)
        net.Broadcast()
    end

    function zmc.Inventory.SynchForPlayer(ent,ply)
        zclib.Debug("zmc.Inventory.Synch")
        if not IsValid(ent) then return end

        local e_String = util.TableToJSON(zmc.Inventory.Get(ent))
        local e_Compressed = util.Compress(e_String)
        net.Start("zmc_Inventory_Sync")
        net.WriteUInt(#e_Compressed, 16)
        net.WriteData(e_Compressed, #e_Compressed)
        net.WriteEntity(ent)
        net.WriteUInt(ent:EntIndex(),16)
        net.Send(ply)
    end

    net.Receive("zmc_Inventory_Drop", function(len,ply)
        zclib.Debug_Net("zmc_Inventory_Drop", len)

        if zclib.Player.Timeout(nil,ply) == true then return end

        local ent = net.ReadEntity()
        local SlotID = net.ReadUInt(16)
        if not IsValid(ent) then return end
        if zclib.util.InDistance(ent:GetPos(), ply:GetPos(), zmc.netdist) == false then return end

        local SlotData = zmc.Inventory.GetSlotData(ent,SlotID)
        if SlotData.itm == nil then return end

        // Does the inventory has a item on this slot? If so then empty it
        if zmc.Inventory.EmptySlot(ent, SlotID) == false then return end

        if zmc.Item.LimitCheck(ply) == false then
            zclib.Notify(ply, zmc.language["item_limit_reached"], 1)

            return
        end


        local DropPosition = Vector(-50,0,50)

        if ent:GetClass() == "zmc_mixer" then
            DropPosition = Vector(-50,50,50)
        end

        // ReadyToGo means its a Dish instead of a Item
        local item_ent
        if SlotData.ReadyToGo then
            item_ent = zmc.Dish.Spawn(ent:LocalToWorld(DropPosition),SlotData.itm)
        else
            item_ent = zmc.Item.Spawn(ent:LocalToWorld(DropPosition),SlotData.itm)
        end

        if not IsValid(item_ent) then return end
        zclib.Player.SetOwner(item_ent, ply)

        hook.Run("zmc_Inventory_Drop",ent,SlotID,SlotData,item_ent)

        ent:EmitSound("zmc_item_remove")
    end)

    util.AddNetworkString("zmc_Inventory_Throw")
    net.Receive("zmc_Inventory_Throw", function(len,ply)
        zclib.Debug_Net("zmc_Inventory_Throw", len)

        if zclib.Player.Timeout(nil,ply) == true then return end

        local from = net.ReadEntity()
        local target = net.ReadEntity()
        local SlotID = net.ReadUInt(16)
        if not IsValid(from) then return end
        if not IsValid(target) then return end
        if zclib.util.InDistance(from:GetPos(), ply:GetPos(), zmc.throw_distance) == false then return end

        // Is there even is a item on the start entity
        local SlotData = zmc.Inventory.GetSlotData(from,SlotID)
        local ItemID
        if SlotData.itm == nil then return end

        // Remove it
        zmc.Inventory.EmptySlot(from, SlotID)

        // A small delay should prevent exploits which comes from code being run at the same time
        local traveltime = zmc.Inventory.GetThrowTravelTime(from,target)
        timer.Simple(traveltime,function()

            local slot = zmc.Inventory.FindFreeSlot(target)

            if slot then
                zmc.Inventory.SetSlotData(target, slot,SlotData)
                zmc.Inventory.Synch(target)
                hook.Run("zmc_Inventory_GotItemThrown",from,target,slot,SlotData)
            else

                local item_ent = zmc.Item.Spawn(target:LocalToWorld(Vector(25,0,50)),tostring(ItemID))
                if not IsValid(item_ent) then return end
                zclib.Player.SetOwner(item_ent, ply)

                hook.Run("zmc_Inventory_Drop",target,SlotID,SlotData,item_ent)
            end
        end)
    end)
else

    function zmc.Inventory.Drop(ent,SlotID)
        zclib.Debug("zmc.Inventory.Drop")
        net.Start("zmc_Inventory_Drop")
        net.WriteEntity(ent)
        net.WriteUInt(SlotID,16)
        net.SendToServer()

        zmc.Inventory.SelectedItem = nil
    end

    net.Receive("zmc_Inventory_Sync", function(len)
        zclib.Debug_Net("zmc_Inventory_Sync", len)
        local dataLength = net.ReadUInt(16)
        local dataDecompressed = util.Decompress(net.ReadData(dataLength))
        local inv = util.JSONToTable(dataDecompressed)
        local ent = net.ReadEntity()
        local ent_index = net.ReadUInt(16)

        if inv then

            // Just to be sure the loaded item ids are all strings
            //for k,v in pairs(inv) do if v and v.itm then v.itm = tostring(v.itm) end end

            zmc.InventoryCache[ent_index] = table.Copy(inv)

            if IsValid(ent) then
                ent.zmc_inv = table.Copy(inv)

                hook.Run("zmc_OnInventorySynch",ent)
            end
            ent.InventoryChanged = true
        end

        if inv and IsValid(zmc_main_panel) and ent == zmc.vgui.ActiveEntity and zmc_main_panel.OnInventoryChanged then
            zmc_main_panel:OnInventoryChanged()
        end
    end)


    local classes = {
        ["zmc_worktable"] = true,
        ["zmc_wok"] = true,
        ["zmc_souppot"] = true,
        ["zmc_oven"] = true,
        ["zmc_mixer"] = true,
        ["zmc_grill"] = true,
        ["zmc_garbagepin"] = true,
        ["zmc_dishtable"] = true,
        ["zmc_boilpot"] = true
    }
    local function IsThrowTarget(ent,ItemID)
        if classes[ent:GetClass()] == nil then return false end
        return ent:CanPickUp(ItemID)
    end

    function zmc.Inventory.ThrowItem(from, SlotID)

        local SlotData = zmc.Inventory.GetSlotData(from,SlotID)
        if SlotData == nil or SlotData.itm == nil then
            //zmc_main_panel:Show()
            return
        end

        local ItemID = SlotData.itm

        //zmc_main_panel:Hide()

        zmc_main_panel:Close()

        zclib.PointerSystem.Start(from, function()
            // OnInit
            zclib.PointerSystem.Data.MainColor = zclib.colors["green01"]
            zclib.PointerSystem.Data.ActionName = zmc.language["Throw"]
            zclib.PointerSystem.Data.CancelName = zmc.language["Cancel"]
        end, function()
            // OnLeftClick

            zmc.Inventory.SelectedItem = nil

            //zmc_main_panel:Show()

            // Send the target to the SERVER
            net.Start("zmc_Inventory_Throw")
            net.WriteEntity(from)
            net.WriteEntity(zclib.PointerSystem.Data.Target)
            net.WriteUInt(SlotID,16)
            net.SendToServer()

            SlotData = zmc.Inventory.GetSlotData(from,SlotID)
            if SlotData and SlotData.itm then

                local traveltime = zmc.Inventory.GetThrowTravelTime(from,zclib.PointerSystem.Data.Target)
                zclib.ItemShooter.Add(from:GetPos() + Vector(0,0,50),zclib.PointerSystem.Data.Target:GetPos() + Vector(0,0,50),traveltime,function(ent)

                    local ItemData = zmc.Item.GetData(SlotData.itm)

                    zmc.Item.UpdateVisual(ent,ItemData,false)

                    // If the Item which we are Build / Updated is baking then lets update its color depending on Baking progress
                    if SlotData.bake_prog and ItemData.bake then
                        local ResultItemData = zmc.Item.GetData(ItemData.bake.item)
                        if ResultItemData == nil then return end

                        local col = zclib.util.LerpColor((1 / ItemData.bake.time) * (SlotData.bake_prog or 0), ItemData.color or color_white, ResultItemData.color or color_white)
                        ent:SetColor(col)
                    end

                    // If the Item which we are Build / Updated is grilling then lets update its color depending on Baking progress
                    if SlotData.grill_prog and ItemData.grill then
                        local ResultItemData = zmc.Item.GetData(ItemData.grill.item)
                        if ResultItemData == nil then return end

                        local col = zclib.util.LerpColor((1 / ItemData.grill.time) * (SlotData.grill_prog or 0), ItemData.color or color_white, ResultItemData.color or color_white)
                        ent:SetColor(col)
                    end
                end)
            end
            zclib.PointerSystem.Stop()
        end, function()
            // MainLogic
            // Catch the Target
            if IsValid(zclib.PointerSystem.Data.HitEntity) and IsThrowTarget(zclib.PointerSystem.Data.HitEntity,ItemID) then
                zclib.PointerSystem.Data.Target = zclib.PointerSystem.Data.HitEntity
            else
                zclib.PointerSystem.Data.Target = nil
            end

            // Update PreviewModel
            if IsValid(zclib.PointerSystem.Data.PreviewModel) then
                if IsValid(zclib.PointerSystem.Data.Target) then
                    zclib.PointerSystem.Data.PreviewModel:SetColor(zclib.PointerSystem.Data.MainColor)
                    zclib.PointerSystem.Data.PreviewModel:SetPos(zclib.PointerSystem.Data.Target:GetPos())
                    zclib.PointerSystem.Data.PreviewModel:SetAngles(zclib.PointerSystem.Data.Target:GetAngles())
                    zclib.PointerSystem.Data.PreviewModel:SetModel(zclib.PointerSystem.Data.Target:GetModel())
                    zclib.PointerSystem.Data.PreviewModel:SetNoDraw(false)
                else
                    zclib.PointerSystem.Data.PreviewModel:SetNoDraw(true)
                end
            end
        end,nil,function()
            //zmc_main_panel:Show()
        end)
    end
end
