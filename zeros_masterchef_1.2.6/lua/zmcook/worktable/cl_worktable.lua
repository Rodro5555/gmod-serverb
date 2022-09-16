if SERVER then return end
zmc = zmc or {}
zmc.Worktable = zmc.Worktable or {}

local tPos = 39.5
function zmc.Worktable.Initialize(Worktable)
    Worktable.Dummy_pos = Vector(0,0,45)
    Worktable.Dummy_pos_target = Vector(0,0,45)

    Worktable.Dummy_rot = angle_zero
    Worktable.Dummy_rot_target = angle_zero


    Worktable.Tool_pos = Vector(0,0,tPos)
    Worktable.Tool_pos_target = Vector(-15,0,50)

    Worktable.Tool_rot = angle_zero
    Worktable.Tool_rot_target = Angle(45,180,0)
end

function zmc.Worktable.Draw(Worktable)

end

// Here we setup some custom item positions on the table because it looks nicer if they are custom set instead of some boring grid
local TablePositions = {}
for i = 1, 12 do
    table.insert(TablePositions, Vector(15, -40 + (6 * i), tPos))
end
for i = 1, 12 do
    table.insert(TablePositions, Vector(10, -40 + (6 * i), tPos))
end
table.insert(TablePositions,Vector(0,-30,tPos))
table.insert(TablePositions,Vector(0,-20,tPos))

table.insert(TablePositions,Vector(0,30,tPos))
table.insert(TablePositions,Vector(0,20,tPos))


local change = 1
for k, v in pairs(TablePositions) do
    TablePositions[k] = Vector(v.x + math.Rand(-change, change), v.y + math.Rand(-change, change), v.z)
end


local RndRot = {}
for i = 1, 28 do
    RndRot[i] = Angle(0, math.random(0, 360), 0)
end

function zmc.Worktable.CraftItems_Create(Worktable)
    local ItemData = zmc.Item.GetData(Worktable:GetItemID())

    Worktable.CraftingItems = {}
    for k,v in pairs(ItemData.craft.items) do

        local itmDat = zmc.Item.GetData(v)
        if itmDat == nil then
            if IsValid(Worktable.CraftingItems[k]) then zclib.ClientModel.Remove(Worktable.OnTableDummys[k]) end
            continue
        end

        local ent = zclib.ClientModel.AddProp()
        if not IsValid(ent) then continue end

        zmc.Item.UpdateVisual(ent,itmDat,true)
        ent:SetModelScale(ent:GetModelScale() * 0.5)

        if (k-1) < Worktable:GetProgress() then
            ent:SetMaterial("zerochain/zmc/shader/ghost_mat")
            ent:SetColor(color_white)
        end

        Worktable.CraftingItems[k] = {
            ent = ent,
            itmDat = itmDat,
        }
    end
end

function zmc.Worktable.CraftItems_Remove(Worktable)
    if Worktable.CraftingItems then
        for k, v in pairs(Worktable.CraftingItems) do
            if not IsValid(v.ent) then continue end
            zclib.ClientModel.Remove(v.ent)
        end
        Worktable.CraftingItems = nil
    end
    Worktable.LastProgress = nil
end

local CraftPositions = {
    [1] = Vector(0,4,41),
    [2] = Vector(-7,4,41),
    [3] = Vector(0,-4,41),
    [4] = Vector(-7,-4,41),
}
function zmc.Worktable.CraftItems_Draw(Worktable)
    for k,v in pairs(Worktable.CraftingItems) do
        if not IsValid(v.ent) then continue end
        v.ent:SetPos(Worktable:LocalToWorld(CraftPositions[k]))
        v.ent:SetAngles(Worktable:LocalToWorldAngles(angle_zero))
    end

    local curProgress = Worktable:GetProgress()
    if Worktable.LastProgress ~= curProgress then
        for k,v in pairs(Worktable.CraftingItems) do
            if not IsValid(v.ent) then continue end
            if (k-1) < Worktable:GetProgress() then
                v.ent:SetMaterial("zerochain/zmc/shader/ghost_mat")
                v.ent:SetColor(color_white)
            else
                v.ent:SetMaterial(nil)
                zmc.Item.UpdateVisual(v.ent,v.itmDat,true)
                v.ent:SetModelScale(v.ent:GetModelScale() * 0.5)
            end
        end
        Worktable.LastProgress = curProgress
    end
end


function zmc.Worktable.Think(Worktable)
    if zclib.util.InDistance(Worktable:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_clientmodels) then
        local ItemID = Worktable:GetItemID()
        if ItemID ~= -1 then
            local ItemData = zmc.Item.GetData(ItemID)
            if ItemData then

                if Worktable:GetTaskType() == 3 then

                    if Worktable.CraftingItems == nil then
                        zmc.Worktable.CraftItems_Create(Worktable)
                    else
                        zmc.Worktable.CraftItems_Draw(Worktable)
                    end
                else
                    // Position Food
                    if IsValid(Worktable.Dummy) then

                        Worktable.Dummy_pos = LerpVector(5 * FrameTime(),Worktable.Dummy_pos,Worktable.Dummy_pos_target)
                        Worktable.Dummy_rot = LerpAngle(5 * FrameTime(),Worktable.Dummy_rot,Worktable.Dummy_rot_target)

                        Worktable.Dummy:SetPos(Worktable:LocalToWorld(Worktable.Dummy_pos))
                        Worktable.Dummy:SetAngles(Worktable:LocalToWorldAngles(Worktable.Dummy_rot))
                    else
                        Worktable.Dummy = zclib.ClientModel.AddProp()
                        if not IsValid(Worktable.Dummy) then return end
                        Worktable.Dummy:SetModel(ItemData.mdl)
                        zmc.Item.UpdateVisual(Worktable.Dummy,ItemData,true)
                    end

                    // Position Tool
                    if Worktable:GetTaskType() == 1 and ItemData.cut and not IsValid(Worktable.ToolModel) then
                        Worktable.ToolModel = zclib.ClientModel.AddProp()
                        if not IsValid(Worktable.ToolModel) then return end
                        Worktable.ToolModel:SetModel("models/props_lab/Cleaver.mdl")
                    else
                        if IsValid(Worktable.ToolModel) then
                            Worktable.Tool_pos = LerpVector(5 * FrameTime(),Worktable.Tool_pos,Worktable.Tool_pos_target)
                            Worktable.Tool_rot = LerpAngle(5 * FrameTime(),Worktable.Tool_rot,Worktable.Tool_rot_target)

                            Worktable.ToolModel:SetPos(Worktable:LocalToWorld(Worktable.Tool_pos))
                            Worktable.ToolModel:SetAngles(Worktable:LocalToWorldAngles(Worktable.Tool_rot))
                        end
                    end
                end
            else
                if IsValid(Worktable.Dummy) then
                    zclib.ClientModel.Remove(Worktable.Dummy)
                    Worktable.Dummy = nil
                end

                if IsValid(Worktable.ToolModel) then
                    zclib.ClientModel.Remove(Worktable.ToolModel)
                    Worktable.ToolModel = nil
                end

                zmc.Worktable.CraftItems_Remove(Worktable)
            end
        else
            if IsValid(Worktable.Dummy) then
                zclib.ClientModel.Remove(Worktable.Dummy)
                Worktable.Dummy = nil
            end

            if IsValid(Worktable.ToolModel) then
                zclib.ClientModel.Remove(Worktable.ToolModel)
                Worktable.ToolModel = nil
            end

            zmc.Worktable.CraftItems_Remove(Worktable)
        end

        if Worktable.OnTableDummys == nil or Worktable.InventoryChanged == true then

            if Worktable.OnTableDummys == nil then Worktable.OnTableDummys = {} end

            for slot_id,slot_data in pairs(zmc.Inventory.Get(Worktable)) do
                if slot_data == nil then continue end

                local itmDat = zmc.Item.GetData(slot_data.itm)
                if itmDat == nil then
                    if IsValid(Worktable.OnTableDummys[slot_id]) then zclib.ClientModel.Remove(Worktable.OnTableDummys[slot_id]) end
                    continue
                end

                local ent
                if IsValid(Worktable.OnTableDummys[slot_id]) then
                    ent = Worktable.OnTableDummys[slot_id]
                else
                    ent = zclib.ClientModel.AddProp()
                end
                if not IsValid(ent) then continue end

                zmc.Item.UpdateVisual(ent,itmDat,true)
                ent:SetModelScale(ent:GetModelScale() * 0.5)

                Worktable.OnTableDummys[slot_id] = ent
            end

            Worktable.InventoryChanged = nil
        end

        if Worktable.OnTableDummys then
            for k,v in pairs(Worktable.OnTableDummys) do
                if not IsValid(v) then continue end
                if TablePositions[k] == nil then continue end

                local bound_min = v:GetModelBounds()
                local height = math.abs(bound_min.z) * v:GetModelScale()
                local pos = TablePositions[k]
                v:SetPos(Worktable:LocalToWorld(Vector(pos.x,pos.y,pos.z + height)))
                v:SetAngles(Worktable:LocalToWorldAngles(RndRot[k]))
            end
        end
    else
        zmc.Worktable.RemoveClientModels(Worktable)

        Worktable.InventoryChanged = true
    end
end

function zmc.Worktable.Interaction(Worktable)
    if not IsValid(Worktable) then return end

    local task = Worktable:GetTaskType()

    if task == 3 then
        Worktable:EmitSound("zmc_craft")
    elseif task == 1 then
        Worktable.Tool_pos = Vector(-10, 0, 45)
        Worktable.Tool_rot = Angle(0, 180, 0)
        Worktable:EmitSound("zmc_cut")
    elseif task == 2 then
        Worktable:EmitSound("zmc_knead")
    end

    if IsValid(Worktable.Dummy) then
        Worktable.Dummy_pos = Vector(math.Rand(-5, 5), math.Rand(-5, 5), 45)
        Worktable.Dummy_rot = Angle(math.Rand(-180, 180), math.Rand(-180, 180), math.Rand(-180, 180))
    end
end

function zmc.Worktable.RemoveClientModels(Worktable)
    if Worktable.OnTableDummys then
        for k, v in pairs(Worktable.OnTableDummys) do
            if not IsValid(v) then continue end
            zclib.ClientModel.Remove(v)
        end
        Worktable.OnTableDummys = nil
    end

    zmc.Worktable.CraftItems_Remove(Worktable)

    if IsValid(Worktable.Dummy) then
        zclib.ClientModel.Remove(Worktable.Dummy)
        Worktable.Dummy = nil
    end

    if IsValid(Worktable.ToolModel) then
        zclib.ClientModel.Remove(Worktable.ToolModel)
        Worktable.ToolModel = nil
    end
end

function zmc.Worktable.OnRemove(Worktable)
    zmc.Worktable.RemoveClientModels(Worktable)
end
