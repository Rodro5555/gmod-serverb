if not CLIENT then return end
zmlab2 = zmlab2 or {}
zmlab2.Ventilation = zmlab2.Ventilation or {}

function zmlab2.Ventilation.Initialize(Ventilation)

end

function zmlab2.Ventilation.OnThink(Ventilation)
    if zclib.util.InDistance(LocalPlayer():GetPos(),Ventilation:GetPos(), 1000) and IsValid(Ventilation:GetOutput()) then

        if Ventilation:GetIsVenting() == true and (Ventilation.NextEffect == nil or Ventilation.NextEffect < CurTime()) then
            local time = Ventilation:GetLastPollutionMove() + 3
            if CurTime() < time then
                zclib.Effect.ParticleEffectAttach("zmlab2_vent_poision", PATTACH_POINT_FOLLOW, Ventilation.Output, 2)
            else
                zclib.Effect.ParticleEffectAttach("zmlab2_vent_clean", PATTACH_POINT_FOLLOW, Ventilation.Output, 2)
            end

            Ventilation.NextEffect = CurTime() + 0.5
        end


        if zmlab2.Ventilation.List[Ventilation:EntIndex()] == nil then
            zmlab2.Ventilation.AddPipeRender(Ventilation)
        end
    else
        if zmlab2.Ventilation.List[Ventilation:EntIndex()] then
            zmlab2.Ventilation.RemovePipeRender(Ventilation:EntIndex())
        end
    end
end

function zmlab2.Ventilation.OnRemove(Ventilation)
    zmlab2.Ventilation.RemoveClientModel(Ventilation)
    Ventilation:StopSound("zmlab2_machine_ventilation")
end


local ScreenData = {
    pos = Vector(-4.9,11,30.8),
    ang = Angle(0, 180, 90),
    x = 0,
    y = 0,
    w = 155,
    h = 90,
    pages = {
        [0] = function(Ventilation)
            zmlab2.Interface.DrawButton(0, 0, 130, 60, zmlab2.language["Disabled"], Ventilation:OnStart(LocalPlayer()))

            draw.RoundedBox(15, 39, 63,30,30, zclib.colors["black_a200"])
            surface.SetDrawColor(zmlab2.colors["red02"])
            surface.SetMaterial(zclib.Materials.Get("radial_shadow"))
            surface.DrawTexturedRect(29, 55,50,50)
        end,
        [1] = function(Ventilation)
            zmlab2.Interface.DrawButton(0, 0, 130, 60, zmlab2.language["Enabled"], Ventilation:OnStart(LocalPlayer()))

            draw.RoundedBox(15, 39, 63,30,30, zclib.colors["black_a200"])
            surface.SetDrawColor(color_green)
            surface.SetMaterial(zclib.Materials.Get("radial_shadow"))
            surface.DrawTexturedRect(29, 55,50,50)
        end,
    }
}

function zmlab2.Ventilation.Draw(Ventilation)

    zclib.util.LoopedSound(Ventilation, "zmlab2_machine_ventilation", Ventilation:GetIsVenting())

    if zclib.util.InDistance(Ventilation:GetPos(), LocalPlayer():GetPos(), 2500) then

        zmlab2.Interface.Draw(Ventilation,ScreenData)

        // Vibrates certain bones of the machine
        zclib.VibrationSystem.Run(Ventilation,Ventilation:GetProcessState() == 1,0.7)
    end
end



zmlab2.Ventilation.List = zmlab2.Ventilation.List or {}

function zmlab2.Ventilation.AddPipeRender(Ventilation)

    zmlab2.Ventilation.List[Ventilation:EntIndex()] = Ventilation

    zclib.Hook.Add("Think", "zmlab2_Ventilation", function() zmlab2.Ventilation.PipeRender() end)
end

function zmlab2.Ventilation.RemovePipeRender(EntIndex)
    zmlab2.Ventilation.List[EntIndex] = nil
end

function zmlab2.Ventilation.PipeRender()

    if zmlab2.Ventilation.List == nil or table.Count(zmlab2.Ventilation.List) <= 0 then
        zclib.Hook.Remove("Think", "zmlab2_Ventilation")
        return
    end

    for k,v in pairs(zmlab2.Ventilation.List) do
        if not IsValid(v) then
            zmlab2.Ventilation.RemovePipeRender(k)
            continue
        end
        zmlab2.Ventilation.DrawPipe(v)
    end
end

local gravity = Vector(0, 0, -0.5)
local damping = 0.5
local Length = 14

local function Pipe_GetLinePoints(Ventilation,attach,r_start,r_end)
    // Create rope points
    if Ventilation.LinePoints == nil then
        Ventilation.LinePoints = zclib.Rope.Setup(Length, r_start)
    end

    // Updates the Rope points to move physicly
    if Ventilation.LinePoints and table.Count(Ventilation.LinePoints) > 0 then

        zclib.Rope.Update(Ventilation.LinePoints, r_start, r_end, Length, gravity, damping)

        // Clamp all point positions Z to mid pos
        if Ventilation.Pipe_MidPos then
            for k,v in pairs(Ventilation.LinePoints) do
                v.position = Vector(v.position.x, v.position.y, math.Clamp(v.position.z, Ventilation.Pipe_MidPos.z, 99999999))
            end
        end

        Ventilation.LinePoints[1].position = r_start - attach.Ang:Up() * 5
        Ventilation.LinePoints[2].position = r_start - attach.Ang:Up() * 3

        Ventilation.LinePoints[Length - 1].position = r_end + Ventilation.Output:GetForward() * 15
        Ventilation.LinePoints[Length].position = r_end
    end
end

local function Pipe_GetMidPoint(Ventilation)
    local speed = Ventilation.Output:GetVelocity():Length()
    if speed > 0 then
        Ventilation.Pipe_MidPos = nil
    else
        // Now that the thing is not moving anymore lets trace for the floor between the 2 points
        if Ventilation.Pipe_MidPos == nil then

            local vent_pos = Ventilation:GetPos()
            local output_pos = Ventilation.Output:GetPos()

            // If the position z diffrence is bigger then 10 units then lets not define it
            // BUG You returned here so tahts why none of the other code was working anymore
            if math.abs(output_pos.z - vent_pos.z) < 100 then
                local midPos = (Ventilation.Output:GetPos() + vent_pos) / 2
                midPos = Vector(midPos.x,midPos.y,math.Clamp(midPos.z,vent_pos.z,99999999999999))

                local c_trace = zclib.util.TraceLine({
                    start = midPos,
                    endpos = midPos - Vector(0,0,10000),
                    mask = MASK_SOLID_BRUSHONLY,
                }, "Pipe_MidPosTracer")

                if c_trace.Hit and c_trace.HitPos then
                    Ventilation.Pipe_MidPos = Vector(c_trace.HitPos.x,c_trace.HitPos.y,midPos.z)
                end
            end
        end
    end
end

local function Pipe_GetLineAngles(Ventilation)
    if Ventilation.LineAngles == nil then
        Ventilation.LineAngles = {}
    end

    for point = 0, Length do
        if Ventilation.LinePoints[point] then
            local pos = Ventilation.LinePoints[point].position
            local ang = (Ventilation:GetPos() - Ventilation.Output:GetPos()):Angle()

            if Ventilation.LinePoints[point - 1] then
                ang = (pos - Ventilation.LinePoints[point-1].position):Angle()
                ang:RotateAroundAxis(ang:Right(),-90)
            end

            Ventilation.LineAngles[point] = ang
        end
    end
end

function zmlab2.Ventilation.DrawPipe(Ventilation)

    // Here we create or remove the client models
    if zclib.util.InDistance(LocalPlayer():GetPos(), Ventilation:GetPos(), 2000) and Ventilation:GetAttachment(1) then

        if not IsValid(Ventilation.PipeModel) then
            zmlab2.Ventilation.CreateClientModel(Ventilation)
        else

            if not IsValid(Ventilation.Output) then
                Ventilation.Output = Ventilation:GetOutput()
            else

                // If the Ventilation Head is not moving then it will get a mid point between start and finish via trace
                Pipe_GetMidPoint(Ventilation)

                local attach = Ventilation:GetAttachment(1)
                local r_start = Ventilation:GetPos()
                if attach then r_start = attach.Pos end

                local output_attach = Ventilation.Output:GetAttachment(1)
                local r_end = Ventilation.Output:GetPos()
                if output_attach then r_end = output_attach.Pos end

                // Calculate the segments position
                Pipe_GetLinePoints(Ventilation,attach,r_start,r_end)

                // Calculate the segment angles
                Pipe_GetLineAngles(Ventilation)

                // Fixes the pipe rotation for the last 2 bones
                if output_attach then
                    local last_ang = output_attach.Ang
                    last_ang:RotateAroundAxis(last_ang:Right(),180)
                    last_ang:RotateAroundAxis(last_ang:Up(),-90)

                    Ventilation.LineAngles[Length - 1] = output_attach.Ang
                    Ventilation.LineAngles[Length] = output_attach.Ang
                end
            end

            // I know its stupid but we need to make sure the client prop stays in eye sight to keep rendering
            Ventilation.PipeModel:SetPos(LocalPlayer():EyePos())
        end
    else
        zmlab2.Ventilation.RemoveClientModel(Ventilation)
    end
end

function zmlab2.Ventilation.RemoveClientModel(Ventilation)
    if IsValid(Ventilation.PipeModel) then
        zclib.ClientModel.Remove(Ventilation.PipeModel)
        zclib.Debug("zmlab2.Ventilation.RemoveClientModel")
        Ventilation.PipeModel = nil
    end

    Ventilation.Output = nil
end

function zmlab2.Ventilation.CreateClientModel(Ventilation)

    local ent = zclib.ClientModel.AddProp()
    if not IsValid(ent) then return end
    ent:SetModel("models/zerochain/props_methlab/zmlab2_pipe_vent.mdl")
    ent:SetAngles(Ventilation:LocalToWorldAngles(angle_zero))
    ent:SetPos(Ventilation:LocalToWorld(vector_origin))
    ent:Spawn()
    ent:SetParent(Ventilation)
    ent:SetRenderMode(RENDERMODE_TRANSCOLOR)
    Ventilation.PipeModel = ent
    zclib.Debug("zmlab2.Ventilation.CreateClientModel")

    local CallBackID = ent:AddCallback("BuildBonePositions", function(pipe, numbones)
        for i = 0, numbones - 1 do
            local mat = pipe:GetBoneMatrix(i)
            if not mat then continue end

            if Ventilation.LineAngles and Ventilation.LineAngles[i + 1] then
                mat:SetAngles(Ventilation.LineAngles[i + 1])
            end

            if Ventilation.LinePoints and Ventilation.LinePoints[i + 1] then
                mat:SetTranslation(Ventilation.LinePoints[i + 1].position)
            end

            pipe:SetBoneMatrix(i, mat)
        end
    end)
    //print("Ventilation[" .. tostring(Ventilation:EntIndex()) .. "]" .. "Added Callback [BuildBonePositions]")

    ent:CallOnRemove("Remove_BuildBonePositions_Callback_" .. math.random(99999999), function(pipe)
        //print("Ventilation[" .. tostring(Ventilation:EntIndex()) .. "]" .. "Removed Callback [BuildBonePositions]")
        pipe:RemoveCallback("BuildBonePositions", CallBackID)
    end)
end
