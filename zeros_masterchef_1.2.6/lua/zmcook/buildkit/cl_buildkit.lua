if SERVER then return end
zmc = zmc or {}
zmc.Buildkit = zmc.Buildkit or {}

local function GetWidth(ent)
    local min,max = ent:GetModelBounds()
     debugoverlay.BoxAngles( ent:GetPos(), min,max, ent:GetAngles(),0.1,Color( 255, 255, 255 ,1) )
    return math.abs(min.y) + math.abs(max.y)
end

local function CanPlace()
    if zclib.PointerSystem.Data.Pos == nil or zclib.PointerSystem.Data.Ang == nil then
        return false
    end

    if zmc.Buildkit.AreaOccupied(zclib.PointerSystem.Data.Pos,zclib.PointerSystem.Data.Target) then
        return false
    end

    zclib.PointerSystem.Data.Ang = (LocalPlayer():GetPos() - zclib.PointerSystem.Data.Pos):Angle()
    zclib.PointerSystem.Data.Ang:RotateAroundAxis(zclib.PointerSystem.Data.Ang:Up(),180)

    //local aUp = zclib.PointerSystem.Data.Ang:Up()
    //if (math.abs(aUp.x) > 0.2 or math.abs(aUp.y) > 0.2 or aUp.z < 0.7) then return false end

    // Find Snap target
    local nearest
    local last_dist = 99999999999999999
    for k,v in pairs(ents.FindInSphere(zclib.PointerSystem.Data.Pos,50)) do
        if not IsValid(v) then continue end
        if zmc.Buildkit_Classes[v:GetClass()] == nil then continue end
        if IsValid(zclib.PointerSystem.Data.Target) and v == zclib.PointerSystem.Data.Target then continue end

        local dist = v:GetPos():Distance(zclib.PointerSystem.Data.Pos)
        if dist < last_dist then
            nearest = v
            last_dist = dist
        end
    end

    if IsValid(nearest) then

        zclib.PointerSystem.Data.Ang = nearest:GetAngles()

        local lspace = nearest:WorldToLocal(zclib.PointerSystem.Data.Pos)

        local min = nearest:GetModelBounds()

        local NewEnt_w = GetWidth(zclib.PointerSystem.Data.PreviewModel)
        local SnapEnt_w = GetWidth(nearest)

        local YPos
        if lspace.y > 0 then
            // LEFT
            YPos = math.Clamp(NewEnt_w - math.abs(min.y),SnapEnt_w,9999999)
        else
            // RIGHT
            YPos = -math.Clamp((NewEnt_w / 2) + math.abs(min.y),-SnapEnt_w,9999999)
        end

        zclib.PointerSystem.Data.Pos = nearest:LocalToWorld(Vector(0,YPos,0))
    end

    return true
end

function zmc.Buildkit.Place(Equipment,EquipmentID)
    zclib.Debug("zmc.Buildkit.Place")

    zclib.PointerSystem.Start(Equipment,function()

        // OnInit
        zclib.PointerSystem.Data.MainColor = zclib.colors["green01"]

        zclib.PointerSystem.Data.ActionName = zmc.language["Construct"]
        zclib.PointerSystem.Data.CancelName = zmc.language["Cancel"]

        zclib.PointerSystem.Data.EquipmentID = EquipmentID

        // Overwride model if we got a EquipmentID
        local EquipmentData = zmc.config.Buildkit.List[EquipmentID]
        zclib.PointerSystem.Data.ModelOverwrite = EquipmentData.mdl
    end,function()

        // Can we build here?
        if zclib.PointerSystem.Data.CanPlace ~= true then

            return
        end

        // Position detection done, send info to server and wait for further instructions
        net.Start("zmc_Buildkit_Place")
        net.WriteEntity(zclib.PointerSystem.Data.From)
        net.WriteVector(zclib.PointerSystem.Data.Pos)
        net.WriteAngle(zclib.PointerSystem.Data.Ang)
        net.WriteUInt(zclib.PointerSystem.Data.EquipmentID,16)
        net.SendToServer()

        zclib.PointerSystem.Stop()

        // Reopens the interface after we finished, if we wanna build something again
        zmc.Buildkit.OpenInterface()
    end,function()

        // MainLogic

        zclib.PointerSystem.Data.CanPlace = CanPlace()

        // Change the main color depening if we found a valid building pos
        if zclib.PointerSystem.Data.CanPlace then
            zclib.PointerSystem.Data.MainColor = zclib.colors["green01"]
        else
            zclib.PointerSystem.Data.MainColor = zclib.colors["red01"]
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

function zmc.Buildkit.Deconstruct(Equipment)
    zclib.PointerSystem.Start(Equipment,function()

        // OnInit
        zclib.PointerSystem.Data.MainColor = zclib.colors["red01"]

        zclib.PointerSystem.Data.ActionName = zmc.language["Deconstruct"]
        zclib.PointerSystem.Data.CancelName = zmc.language["Cancel"]

    end,function()

        // OnLeftClick

        if not zclib.PointerSystem.Data.Target then return end

        net.Start("zmc_Buildkit_Deconstruct")
        net.WriteEntity(zclib.PointerSystem.Data.Target)
        net.SendToServer()
    end,function()

        // MainLogic

        // Catch the Target Data
        if IsValid(zclib.PointerSystem.Data.HitEntity) and zmc.Buildkit_Classes[zclib.PointerSystem.Data.HitEntity:GetClass()] then
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

function zmc.Buildkit.Move(Equipment)
    zclib.PointerSystem.Start(Equipment,function()

        // OnInit
        zclib.PointerSystem.Data.MainColor = zclib.colors["blue01"]
        zclib.PointerSystem.Data.CancelName = zmc.language["Cancel"]

    end,function()

        // OnLeftClick

        if IsValid(zclib.PointerSystem.Data.Target) then

            // Can we build here?
            if zclib.PointerSystem.Data.CanPlace ~= true then return end

            net.Start("zmc_Buildkit_Move")
            net.WriteEntity(zclib.PointerSystem.Data.Target)
            net.WriteVector(zclib.PointerSystem.Data.Pos)
            net.WriteAngle(zclib.PointerSystem.Data.Ang)
            net.SendToServer()

            zclib.PointerSystem.Data.Target = nil
        else

            // Select the machine to move
            if not IsValid(zclib.PointerSystem.Data.HitEntity) then return end
            if zmc.Buildkit_Classes[zclib.PointerSystem.Data.HitEntity:GetClass()] == nil then return end

            zclib.PointerSystem.Data.Target = zclib.PointerSystem.Data.HitEntity

            zclib.PointerSystem.Data.EquipmentID = zmc.Buildkit_Classes[zclib.PointerSystem.Data.Target:GetClass()]

            zclib.Sound.EmitFromEntity("throw",zclib.PointerSystem.Data.HitEntity)
        end
    end,function()

        // MainLogic

        // Update PreviewModel
        if IsValid(zclib.PointerSystem.Data.PreviewModel) then

            zclib.PointerSystem.Data.Ignore = zclib.PointerSystem.Data.Target

            if IsValid(zclib.PointerSystem.Data.Target) then

                zclib.PointerSystem.Data.PreviewModel:SetModel(zclib.PointerSystem.Data.Target:GetModel())

                zclib.PointerSystem.Data.CanPlace = CanPlace()

                // Change the main color depening if we found a valid building pos
                if zclib.PointerSystem.Data.CanPlace then
                    zclib.PointerSystem.Data.MainColor = zclib.colors["blue01"]
                else
                    zclib.PointerSystem.Data.MainColor = zclib.colors["red01"]
                end

                zclib.PointerSystem.Data.ActionName = zmc.language["Choosepostion"]
            else
                zclib.PointerSystem.Data.MainColor = zclib.colors["blue01"]
                zclib.PointerSystem.Data.ActionName = zmc.language["ChooseEntity"]

                // If we found a entity that we can move then get its pos and ang
                if IsValid(zclib.PointerSystem.Data.HitEntity) and zmc.Buildkit_Classes[zclib.PointerSystem.Data.HitEntity:GetClass()] then
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

function zmc.Buildkit.Repair(Equipment)
    zclib.PointerSystem.Start(Equipment,function()

        // OnInit
        zclib.PointerSystem.Data.MainColor = zclib.colors["green01"]

        zclib.PointerSystem.Data.ActionName = zmc.language["Equipment_Repair"]
        zclib.PointerSystem.Data.CancelName = zmc.language["Cancel"]
    end,function()

        // OnLeftClick

        if not zclib.PointerSystem.Data.Target then return end

        net.Start("zmc_Buildkit_Repair")
        net.WriteEntity(zclib.PointerSystem.Data.Target)
        net.SendToServer()
    end,function()

        // MainLogic

        // Catch the Target Data
        if IsValid(zclib.PointerSystem.Data.HitEntity) and zmc.Buildkit_Classes[zclib.PointerSystem.Data.HitEntity:GetClass()] then
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
                local t = (1 / zmc.config.Damageable[zclib.PointerSystem.Data.Target:GetClass()]) * zclib.PointerSystem.Data.Target:Health()
                zclib.PointerSystem.Data.MainColor = zclib.util.LerpColor(t, zclib.colors["red01"], zclib.colors["green01"])
            else
                zclib.PointerSystem.Data.MainColor = zclib.colors["green01"]
            end
            zclib.PointerSystem.Data.PreviewModel:SetColor(zclib.PointerSystem.Data.MainColor)
        end
    end,function()

        if IsValid(zclib.PointerSystem.Data.Target) then
            local pos = zclib.PointerSystem.Data.Target:GetPos() + Vector(0,0,50)
            local data2D = pos:ToScreen()
            local val = zclib.PointerSystem.Data.Target:Health()
            local max = zmc.config.Damageable[zclib.PointerSystem.Data.Target:GetClass()]
            draw.RoundedBox(0, data2D.x - 100, data2D.y - 25, 200, 50, zclib.colors["black_a200"])
            draw.SimpleText("[" .. val .. "/" .. max .. "]", zclib.GetFont("zclib_font_big"), data2D.x, data2D.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            zclib.util.DrawOutlinedBox(data2D.x - 100, data2D.y - 25, 200, 50, 4, color_white)
        end
    end)
end
