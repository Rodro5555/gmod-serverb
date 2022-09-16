if not CLIENT then return end
zmlab2 = zmlab2 or {}
zmlab2.Equipment = zmlab2.Equipment or {}

function zmlab2.Equipment.Initialize(Equipment) end
function zmlab2.Equipment.OnRemove(Equipment) end

function zmlab2.Equipment.DrawButton(Equipment,txt,y,IsHovered)

    local font = zclib.GetFont("zmlab2_font02")
    local txtSize = zclib.util.GetTextSize(txt,font)
    if txtSize > 220 then font = zclib.GetFont("zmlab2_font04") end


    draw.RoundedBox(0, -110, y-30, 220, 60, zclib.colors["black_a100"])

    if IsHovered then
        zclib.util.DrawOutlinedBox(-110, y-30, 220, 60, 4, zmlab2.colors["blue02"])
    else
        zclib.util.DrawOutlinedBox( -110, y-30, 220, 60, 4, color_white)
    end

    draw.SimpleText(txt,font,0,y,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end

function zmlab2.Equipment.DrawUI(Equipment)

    if zclib.util.InDistance(Equipment:GetPos(), LocalPlayer():GetPos(), 500) and zclib.Convar.Get("zmlab2_cl_drawui") == 1 then
        cam.Start3D2D(Equipment:LocalToWorld(Vector(0,13.5,40)), Equipment:LocalToWorldAngles(Angle(0,180,90)), 0.1)
            if zmlab2.config.Equipment.RepairOnly == false then
                zmlab2.Equipment.DrawButton(Equipment,zmlab2.language["Equipment_Build"],-70,Equipment:OnBuild(LocalPlayer()))
                zmlab2.Equipment.DrawButton(Equipment,zmlab2.language["Equipment_Move"],0,Equipment:OnMove(LocalPlayer()))
                zmlab2.Equipment.DrawButton(Equipment,zmlab2.language["Equipment_Remove"],140,Equipment:OnRemoveButton(LocalPlayer()))
            end
            zmlab2.Equipment.DrawButton(Equipment,zmlab2.language["Equipment_Repair"],70,Equipment:OnRepair(LocalPlayer()))
        cam.End3D2D()
    end
end

// Takes in the HitEntity of the trace and returns the Tent entity and a valid and free build attachment point
local function GetPlacementPos(HitEntity)
    local Tent,AttachID
    if IsValid(HitEntity) and HitEntity:GetClass() == "zmlab2_tent" then

        Tent = HitEntity

        local EquipmentData = zmlab2.config.Equipment.List[zclib.PointerSystem.Data.EquipmentID]

        for k,v in pairs(Tent:GetAttachments()) do

            //debugoverlay.Sphere(Tent:GetAttachment(v.id).Pos,5, 0.1, Color( 255, 255, 255 ), false )

            // If the attachment point not for building, not a nowall build attach and not set to some class then stop
            local attach_name = v.name
            if (string.sub(attach_name,1,6) ~= "build_" and string.sub(attach_name,1,6) ~= "nowall") and string.sub(attach_name,1,#EquipmentData.class) ~= EquipmentData.class then continue end

            if EquipmentData.class == "zmlab2_machine_ventilation" and string.sub(attach_name,1,6) == "nowall" then continue end

            local attach = Tent:GetAttachment(v.id)
            if attach == nil then continue end

            local pos = attach.Pos

            local InDistance = pos:DistToSqr(zclib.PointerSystem.Data.Pos) < (25 * 25)

            if InDistance == false then
                continue
            end

            if zmlab2.Equipment.AreaOccupied(pos) == false then
                AttachID = v.id
                zclib.PointerSystem.Data.Pos = pos
                zclib.PointerSystem.Data.Ang = attach.Ang
                break
            end
        end
    end
    return Tent,AttachID
end

local function CanPlace(Tent,AttachID)
    if zmlab2.config.Equipment.RestrictToTent == true then
        if not IsValid(Tent) or AttachID == nil then
            return false
        end
    else
        if zclib.PointerSystem.Data.Pos == nil or zclib.PointerSystem.Data.Ang == nil then
            return false
        end
    end

    if zmlab2.Equipment.AreaOccupied(zclib.PointerSystem.Data.Pos,zclib.PointerSystem.Data.Target) then
        return false
    end

    if not IsValid(Tent) and zclib.PointerSystem.Data.Pos and zmlab2.config.Equipment.RestrictToTent == false then
        zclib.PointerSystem.Data.Ang = (LocalPlayer():GetPos() - zclib.PointerSystem.Data.Pos):Angle()
        zclib.PointerSystem.Data.Ang:RotateAroundAxis(zclib.PointerSystem.Data.Ang:Up(),-90)
    end

    local aUp = zclib.PointerSystem.Data.Ang:Up()
    if not IsValid(zclib.PointerSystem.Data.HitEntity) then
        if (math.abs(aUp.x) > 0.2 or math.abs(aUp.y) > 0.2 or aUp.z < 0.7) then return false end
    else
        if zclib.PointerSystem.Data.HitEntity:GetClass() ~= "zmlab2_tent" then
            if (math.abs(aUp.x) > 0.2 or math.abs(aUp.y) > 0.2 or aUp.z < 0.7) then return false end
        end
    end


    return true
end

function zmlab2.Equipment.Place(Equipment,EquipmentID)
    zclib.Debug("zmlab2.Equipment.Place")

    zclib.PointerSystem.Start(Equipment,function()

        // OnInit
        zclib.PointerSystem.Data.MainColor = zmlab2.colors["green01"]

        zclib.PointerSystem.Data.ActionName = zmlab2.language["Construct"]

        zclib.PointerSystem.Data.EquipmentID = EquipmentID

        // Overwride model if we got a EquipmentID
        local EquipmentData = zmlab2.config.Equipment.List[EquipmentID]
        zclib.PointerSystem.Data.ModelOverwrite = EquipmentData.model
    end,function()

        // OnLeftClick
        if not zclib.PointerSystem.Data.Target then return end

        // Can we build here?
        if CanPlace(zclib.PointerSystem.Data.Target.Tent,zclib.PointerSystem.Data.Target.AttachID) == false then return end

        //if not IsValid(zclib.PointerSystem.Data.Target.Tent) then return end
        //if zclib.PointerSystem.Data.Target.AttachID == nil then return end

        // Position detection done, send info to server and wait for further instructions
        net.Start("zmlab2_Equipment_Place")
        net.WriteEntity(zclib.PointerSystem.Data.From)
        net.WriteEntity(zclib.PointerSystem.Data.Target.Tent)
        net.WriteInt(zclib.PointerSystem.Data.Target.AttachID or -1,16)
        net.WriteVector(zclib.PointerSystem.Data.Pos)
        net.WriteAngle(zclib.PointerSystem.Data.Ang)
        net.WriteUInt(zclib.PointerSystem.Data.EquipmentID,16)
        net.SendToServer()

        zclib.PointerSystem.Stop()

        // Reopens the interface after we finished, if we wanna build something again
        zmlab2.Equipment.OpenInterface()
    end,function()

        // MainLogic

        // Catch the Target Data
        // Lets search for the closest tent and AttachID
        local Tent , AttachID = GetPlacementPos(zclib.PointerSystem.Data.HitEntity)
        zclib.PointerSystem.Data.Target = {
            Tent = Tent,
            AttachID = AttachID,
        }

        // Change the main color depening if we found a valid building pos
        if CanPlace(Tent,AttachID) then
            zclib.PointerSystem.Data.MainColor = zmlab2.colors["green01"]
        else
            zclib.PointerSystem.Data.MainColor = zmlab2.colors["red01"]
        end

        // Update PreviewModel
        if IsValid(zclib.PointerSystem.Data.PreviewModel) then
            zclib.PointerSystem.Data.PreviewModel:SetModel(zclib.PointerSystem.Data.ModelOverwrite)
            zclib.PointerSystem.Data.PreviewModel:SetPos(zclib.PointerSystem.Data.Pos)
            zclib.PointerSystem.Data.PreviewModel:SetAngles(zclib.PointerSystem.Data.Ang)
            zclib.PointerSystem.Data.PreviewModel:SetColor(zclib.PointerSystem.Data.MainColor)
        end
    end)
end

net.Receive("zmlab2_Equipment_Deconstruct", function(len,ply)
    zclib.Debug_Net("zmlab2_Equipment_Deconstruct",len)
    local Equipment = net.ReadEntity()
    if not IsValid(Equipment) then return end
    zmlab2.Equipment.Deconstruct(Equipment)
end)
function zmlab2.Equipment.Deconstruct(Equipment)
    zclib.PointerSystem.Start(Equipment,function()

        // OnInit
        zclib.PointerSystem.Data.MainColor = zmlab2.colors["red01"]

        zclib.PointerSystem.Data.ActionName = zmlab2.language["Deconstruct"]

    end,function()

        // OnLeftClick

        if not zclib.PointerSystem.Data.Target then return end

        net.Start("zmlab2_Equipment_Deconstruct")
        net.WriteEntity(zclib.PointerSystem.Data.Target)
        net.SendToServer()
    end,function()

        // MainLogic

        // Catch the Target Data
        if IsValid(zclib.PointerSystem.Data.HitEntity) and zmlab2.Equipment_Classes[zclib.PointerSystem.Data.HitEntity:GetClass()] then
            zclib.PointerSystem.Data.Target = zclib.PointerSystem.Data.HitEntity
        else
            zclib.PointerSystem.Data.Target = nil
        end

        // Update PreviewModel
        if IsValid(zclib.PointerSystem.Data.PreviewModel) then
            if IsValid(zclib.PointerSystem.Data.Target) then
                zclib.PointerSystem.Data.PreviewModel:SetModel(zclib.PointerSystem.Data.Target:GetModel())
                zclib.PointerSystem.Data.PreviewModel:SetPos(zclib.PointerSystem.Data.Target:GetPos())
                zclib.PointerSystem.Data.PreviewModel:SetAngles(zclib.PointerSystem.Data.Target:GetAngles())
            else
                zclib.PointerSystem.Data.PreviewModel:SetModel("models/hunter/misc/sphere025x025.mdl")
                zclib.PointerSystem.Data.PreviewModel:SetPos(zclib.PointerSystem.Data.Pos)
                zclib.PointerSystem.Data.PreviewModel:SetAngles(zclib.PointerSystem.Data.Ang)
            end
            zclib.PointerSystem.Data.PreviewModel:SetColor(zclib.PointerSystem.Data.MainColor)
        end
    end)
end

net.Receive("zmlab2_Equipment_Move", function(len,ply)
    zclib.Debug_Net("zmlab2_Equipment_Move", len)
    local Equipment = net.ReadEntity()
    if not IsValid(Equipment) then return end
    zmlab2.Equipment.Move(Equipment)
end)
function zmlab2.Equipment.Move(Equipment)
    zclib.PointerSystem.Start(Equipment,function()

        // OnInit
        zclib.PointerSystem.Data.MainColor = zmlab2.colors["blue01"]
    end,function()

        // OnLeftClick

        if IsValid(zclib.PointerSystem.Data.Target) then

            // Lets search for the closest tent and AttachID
            local Tent , AttachID = GetPlacementPos(zclib.PointerSystem.Data.HitEntity)

            // Can we build here?
            if CanPlace(Tent,AttachID) == false then return end

            net.Start("zmlab2_Equipment_Move")
            net.WriteEntity(zclib.PointerSystem.Data.Target)
            net.WriteEntity(Tent)
            net.WriteInt(AttachID or -1,16)
            net.WriteVector(zclib.PointerSystem.Data.Pos)
            net.WriteAngle(zclib.PointerSystem.Data.Ang)
            net.SendToServer()

            zclib.PointerSystem.Data.Target = nil
        else

            // Select the machine to move
            if not IsValid(zclib.PointerSystem.Data.HitEntity) then return end
            if zmlab2.Equipment_Classes[zclib.PointerSystem.Data.HitEntity:GetClass()] == nil then return end

            zclib.PointerSystem.Data.Target = zclib.PointerSystem.Data.HitEntity

            zclib.PointerSystem.Data.EquipmentID = zmlab2.Equipment_Classes[zclib.PointerSystem.Data.Target:GetClass()]

            zclib.Sound.EmitFromEntity("tray_drop", zclib.PointerSystem.Data.HitEntity)
        end
    end,function()

        // MainLogic

        // Update PreviewModel
        if IsValid(zclib.PointerSystem.Data.PreviewModel) then

            zclib.PointerSystem.Data.Ignore = zclib.PointerSystem.Data.Target

            if IsValid(zclib.PointerSystem.Data.Target) then
                zclib.PointerSystem.Data.PreviewModel:SetModel(zclib.PointerSystem.Data.Target:GetModel())

                // We just call this function so it sets the Pos/Ang of the preview model
                local Tent,AttachID = GetPlacementPos(zclib.PointerSystem.Data.HitEntity)

                // Change the main color depening if we found a valid building pos
                if CanPlace(Tent,AttachID) then
                    zclib.PointerSystem.Data.MainColor = zmlab2.colors["blue01"]
                else
                    zclib.PointerSystem.Data.MainColor = zmlab2.colors["red01"]
                end

                zclib.PointerSystem.Data.ActionName = zmlab2.language["Choosepostion"]
            else
                zclib.PointerSystem.Data.MainColor = zmlab2.colors["blue01"]
                zclib.PointerSystem.Data.ActionName = zmlab2.language["ChooseMachine"]

                // If we found a entity that we can move then get its pos and ang
                if IsValid(zclib.PointerSystem.Data.HitEntity) and zmlab2.Equipment_Classes[zclib.PointerSystem.Data.HitEntity:GetClass()] then
                    zclib.PointerSystem.Data.Pos = zclib.PointerSystem.Data.HitEntity:GetPos()
                    zclib.PointerSystem.Data.Ang = zclib.PointerSystem.Data.HitEntity:GetAngles()
                    zclib.PointerSystem.Data.PreviewModel:SetModel(zclib.PointerSystem.Data.HitEntity:GetModel())
                else
                    zclib.PointerSystem.Data.PreviewModel:SetModel("models/hunter/misc/sphere025x025.mdl")
                end
            end

            zclib.PointerSystem.Data.PreviewModel:SetPos(zclib.PointerSystem.Data.Pos)
            zclib.PointerSystem.Data.PreviewModel:SetAngles(zclib.PointerSystem.Data.Ang)
            zclib.PointerSystem.Data.PreviewModel:SetColor(zclib.PointerSystem.Data.MainColor)
        end
    end)
end

net.Receive("zmlab2_Equipment_Repair", function(len,ply)
    zclib.Debug_Net("zmlab2_Equipment_Repair", len)
    local Equipment = net.ReadEntity()
    if not IsValid(Equipment) then return end
    zmlab2.Equipment.Repair(Equipment)
end)
function zmlab2.Equipment.Repair(Equipment)
    zclib.PointerSystem.Start(Equipment,function()

        // OnInit
        zclib.PointerSystem.Data.MainColor = zmlab2.colors["green01"]

        zclib.PointerSystem.Data.ActionName = zmlab2.language["Equipment_Repair"]
    end,function()

        // OnLeftClick

        if not zclib.PointerSystem.Data.Target then return end

        net.Start("zmlab2_Equipment_Repair")
        net.WriteEntity(zclib.PointerSystem.Data.Target)
        net.SendToServer()
    end,function()

        // MainLogic

        // Catch the Target Data
        if IsValid(zclib.PointerSystem.Data.HitEntity) and zmlab2.Equipment_Classes[zclib.PointerSystem.Data.HitEntity:GetClass()] then
            zclib.PointerSystem.Data.Target = zclib.PointerSystem.Data.HitEntity
        else
            zclib.PointerSystem.Data.Target = nil
        end

        // Update PreviewModel
        if IsValid(zclib.PointerSystem.Data.PreviewModel) then
            if IsValid(zclib.PointerSystem.Data.Target) then
                zclib.PointerSystem.Data.PreviewModel:SetModel(zclib.PointerSystem.Data.Target:GetModel())
                zclib.PointerSystem.Data.PreviewModel:SetPos(zclib.PointerSystem.Data.Target:GetPos())
                zclib.PointerSystem.Data.PreviewModel:SetAngles(zclib.PointerSystem.Data.Target:GetAngles())
            else
                zclib.PointerSystem.Data.PreviewModel:SetModel("models/hunter/misc/sphere025x025.mdl")
                zclib.PointerSystem.Data.PreviewModel:SetPos(zclib.PointerSystem.Data.Pos)
                zclib.PointerSystem.Data.PreviewModel:SetAngles(zclib.PointerSystem.Data.Ang)
            end

            if IsValid(zclib.PointerSystem.Data.Target) then
                local t = (1 / zmlab2.config.Damageable[zclib.PointerSystem.Data.Target:GetClass()]) * zclib.PointerSystem.Data.Target:Health()
                zclib.PointerSystem.Data.MainColor = zclib.util.LerpColor(t, zmlab2.colors["red02"], zmlab2.colors["green03"])
            else
                zclib.PointerSystem.Data.MainColor = zmlab2.colors["green01"]
            end
            zclib.PointerSystem.Data.PreviewModel:SetColor(zclib.PointerSystem.Data.MainColor)
        end
    end,function()

        if IsValid(zclib.PointerSystem.Data.Target) then
            local pos = zclib.PointerSystem.Data.Target:GetPos() + Vector(0,0,50)
            local data2D = pos:ToScreen()
            local val = zclib.PointerSystem.Data.Target:Health()
            local max = zmlab2.config.Damageable[zclib.PointerSystem.Data.Target:GetClass()]
            draw.RoundedBox(0, data2D.x - 100, data2D.y - 25, 200, 50, zclib.colors["black_a200"])
            draw.SimpleText("[" .. val .. "/" .. max .. "]", zclib.GetFont("zclib_font_big"), data2D.x, data2D.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            zclib.util.DrawOutlinedBox(data2D.x - 100, data2D.y - 25, 200, 50, 4, color_white)
        end
    end)
end
