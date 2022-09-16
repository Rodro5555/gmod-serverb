if SERVER then return end
zmlab2 = zmlab2 or {}
zmlab2.PumpSystem = zmlab2.PumpSystem or {}

net.Receive("zmlab2_PumpSystem_EnablePointer", function(len, ply)
    zclib.Debug_Net("zmlab2_PumpSystem_EnablePointer", len)
    local Machine = net.ReadEntity()
    if not IsValid(Machine) then return end

    zclib.PointerSystem.Start(Machine,function()

        // OnInit
        zclib.PointerSystem.Data.MainColor = zmlab2.colors["blue01"]

        zclib.PointerSystem.Data.ActionName = zmlab2.language["PumpTo"]

    end,function()

        // OnLeftClick

        if not IsValid(zclib.PointerSystem.Data.Target) then return end

        net.Start("zmlab2_PumpSystem_Start")
        net.WriteEntity(zclib.PointerSystem.Data.From)
        net.WriteEntity(zclib.PointerSystem.Data.Target)
        net.SendToServer()

        zclib.PointerSystem.Stop()
    end,function()

        // MainLogic

        // Catch the Target
        if IsValid(zclib.PointerSystem.Data.HitEntity) and zmlab2.PumpSystem.AllowConnection(zclib.PointerSystem.Data.From,zclib.PointerSystem.Data.HitEntity) then
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
    end)
end)

zmlab2.PumpSystem.Hoses = zmlab2.PumpSystem.Hoses or {}

// Creates a new entry for a hose
net.Receive("zmlab2_PumpSystem_AddHose", function(len, ply)
    zclib.Debug_Net("zmlab2_PumpSystem_AddHose", len)
    local Machine_From = net.ReadEntity()
    local Machine_To = net.ReadEntity()
    if not IsValid(Machine_From) then return end
    if not IsValid(Machine_To) then return end

    if zclib.util.InDistance(LocalPlayer():GetPos(),Machine_From:GetPos(), 1000) == false then return end
    if zclib.util.InDistance(LocalPlayer():GetPos(),Machine_To:GetPos(), 1000) == false then return end

    zmlab2.PumpSystem.AddHose(Machine_From,Machine_To)
end)
function zmlab2.PumpSystem.AddHose(Machine_From,Machine_To)

    if Machine_From.GetHose_Out == nil then return end
    if Machine_To.GetHose_In == nil then return end

    local pos_start,dir_start = Machine_From:GetHose_Out()
    local pos_end,dir_end = Machine_To:GetHose_In()
    local time = zmlab2.PumpSystem.GetTime(Machine_From:GetPos(),Machine_To:GetPos())

    zclib.Debug("zmlab2.PumpSystem.AddHose[" .. tostring(Machine_From) .. "][" .. tostring(Machine_To) .. "][" .. time .. "]")

    //debugoverlay.Sphere(pos_start,2,3,Color( 255, 255, 255 ),true)
    //debugoverlay.Sphere(pos_end,2,3,Color( 255, 255, 255 ),true)

    table.insert(zmlab2.PumpSystem.Hoses,{
        time = CurTime() + time,
        pos_start = pos_start,
        pos_end = pos_end,
        dir_start = dir_start,
        dir_end = dir_end,
    })

    zclib.Hook.Remove("Think", "zmlab2_PumpSystem_Render")
    zclib.Hook.Add("Think", "zmlab2_PumpSystem_Render", function() zmlab2.PumpSystem.RenderHose() end)
end

local hose_gravity = Vector(0, 0, -3)
local hose_damping = 0.5
local hose_Length = 14
function zmlab2.PumpSystem.RenderHose()
    // If we dont have any hoses to calc anymore then lets remove the hook
    if table.Count(zmlab2.PumpSystem.Hoses) <= 0 then
        zclib.Hook.Remove("Think", "zmlab2_PumpSystem_Render")
        return
    end

    for k,v in pairs(zmlab2.PumpSystem.Hoses) do
        if v == nil then
            zmlab2.PumpSystem.Hoses[k] = nil
            continue
        end

        if CurTime() > v.time then
            zclib.Debug("zmlab2.PumpSystem.Hose Removed!")

            zmlab2.PumpSystem.Hoses[k] = nil

            if v.pipe then

                // Remove BuildBonePositions callback if existed
                if v.CallBackID then v.pipe:RemoveCallback( "BuildBonePositions", v.CallBackID ) end

                zclib.ClientModel.Remove(v.pipe)
                v.pipe = nil
            end

            continue
        end

        if zclib.util.InDistance(LocalPlayer():GetPos(), v.pos_start, 1000) == false then
            if v.pipe then

                // Remove BuildBonePositions callback if existed
                if v.CallBackID then v.pipe:RemoveCallback( "BuildBonePositions", v.CallBackID ) end

                zclib.ClientModel.Remove(v.pipe)
                v.pipe = nil
            end
            continue
        end

        if v.pipe == nil then

            // Create the client model pipe
            v.pipe = zclib.ClientModel.Add("models/zerochain/props_methlab/zmlab2_pipe.mdl", RENDERGROUP_OPAQUE)

            if IsValid(v.pipe) then
                // Hose skin
                v.pipe:SetSkin(1)

                // Remove BuildBonePositions callback if existed
                if v.CallBackID then v.pipe:RemoveCallback( "BuildBonePositions", v.CallBackID ) end

                // Add callback to adjust bones
                local CallBackID = v.pipe:AddCallback( "BuildBonePositions", function( pipe, numbones )
                    for i = 0, numbones - 1 do
                        local mat = pipe:GetBoneMatrix( i )
                        if not mat then continue end

                        if v.LineAngles and v.LineAngles[i + 1] and v.LinePoints and v.LinePoints[i + 1] then
                            mat:SetAngles(v.LineAngles[i + 1])
                            mat:SetTranslation(v.LinePoints[i + 1].position)
                            mat:SetScale(Vector(0.3,0.3,0.3))

                            pipe:SetBoneMatrix( i, mat )
                            //debugoverlay.Sphere(mat:GetTranslation(),5,0.1,Color( 255, 255, 255 ),true)
                        end

                        debugoverlay.Text( mat:GetTranslation(), pipe:GetBoneName(i), 0.1, false )
                    end
                end )

                v.CallBackID = CallBackID

                zclib.Debug("zmlab2.PumpSystem.Hose Created!")
            end
        else

            // Create rope points
            if v.LinePoints == nil then
                v.LinePoints = zclib.Rope.Setup(hose_Length, v.pos_start,v.pos_end)
            end

            // Updates the Rope points to move physicly
            if v.LinePoints and table.Count(v.LinePoints) > 0 then

                zclib.Rope.Update(v.LinePoints, v.pos_start, v.pos_end, hose_Length, hose_gravity, hose_damping)

                v.LinePoints[1].position = v.pos_start
                v.LinePoints[2].position = v.pos_start + v.dir_start:Up() * 1

                v.LinePoints[hose_Length - 1].position = v.pos_end - v.dir_end:Up() * 5
                v.LinePoints[hose_Length].position = v.pos_end
            end

            // Generates the Angles for the Pipe Bones
            for point = 0, hose_Length do

                if v.LineAngles == nil then
                    v.LineAngles = {}
                end

                if v.LinePoints[point] then
                    local pos = v.LinePoints[point].position
                    local ang = (v.pos_start - v.pos_end):Angle()

                    debugoverlay.Sphere(pos,1,0.1,Color( 0, 255, 0 ),true)

                    if v.LinePoints[point - 1] then
                        ang = (pos - v.LinePoints[point-1].position):Angle()
                        ang:RotateAroundAxis(ang:Right(),-90)
                        debugoverlay.Line(v.LinePoints[point-1].position,pos,0.1,HSVToColor( (360 / hose_Length) * point, 1,1 ),true)
                    end

                    v.LineAngles[point] = ang
                end
            end

            // Fixes the pipe rotation for the last 2 bones
            v.LineAngles[hose_Length - 1] = v.dir_end
            v.LineAngles[hose_Length] = v.dir_end

            v.pipe:SetPos(LocalPlayer():EyePos())
        end
    end
end
