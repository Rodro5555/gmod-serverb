if SERVER then return end
ztm = ztm or {}
ztm.Recycler = ztm.Recycler or {}

function ztm.Recycler.Initialize(Recycler)
    zclib.EntityTracker.Add(Recycler)
    Recycler.LastTrash = 0
    Recycler.RecycleStage = 0
    Recycler.LastBlockUpdate = 0
    zclib.Animation.Play(Recycler, "open", 1)
end

function ztm.Recycler.Draw(Recycler)
    ztm.util.UpdateEntityVisuals(Recycler)

    if zclib.util.InDistance(LocalPlayer():GetPos(), Recycler:GetPos(), 300) then
        ztm.Recycler.DrawInfo(Recycler)
    end
end

function ztm.Recycler.DrawInfo(Recycler)
    cam.Start3D2D(Recycler:LocalToWorld(Vector(35.5, 5.6, 78.5)), Recycler:LocalToWorldAngles(Angle(0, 90, 90)), 0.1)
        draw.RoundedBox(5, -180, 85, 360, 215, ztm.default_colors["blue01"])
        local _stype = Recycler:GetSelectedType()
        local _rtypeData = ztm.config.Recycler.recycle_types[_stype]
        local _trash = Recycler:GetTrash()

        if Recycler.RecycleStage ~= 0 then
            draw.RoundedBox(5, -150, 165, 300, 50, ztm.default_colors["black01"])
            local time = CurTime() - Recycler:GetStartTime()
            local size = (300 / _rtypeData.recycle_time) * time
            draw.RoundedBox(5, -150, 165, size, 50, ztm.default_colors["red01"])
            draw.DrawText(ztm.language.General["Recycling"] .. "...", zclib.util.FontSwitch(ztm.language.General["Recycling"], 15, zclib.GetFont("ztm_recycler_font01"), zclib.GetFont("ztm_recycler_font01_small")), 0, 175, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)
            draw.DrawText(_trash .. ztm.config.UoW, zclib.GetFont("ztm_recycler_font01"), 0, 100, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)
        else
            // SWITCH Left
            if Recycler:OnSwitchButton_Left(LocalPlayer()) then
                draw.RoundedBox(5, -150, 165, 50, 50, ztm.default_colors["blue02"])
            else
                draw.RoundedBox(5, -150, 165, 50, 50, ztm.default_colors["blue03"])
            end

            draw.DrawText("<", zclib.GetFont("ztm_recycler_font01"), -125, 166, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)

            // SWITCH Right
            if Recycler:OnSwitchButton_Right(LocalPlayer()) then
                draw.RoundedBox(5, 100, 165, 50, 50, ztm.default_colors["blue02"])
            else
                draw.RoundedBox(5, 100, 165, 50, 50, ztm.default_colors["blue03"])
            end

            draw.DrawText(">", zclib.GetFont("ztm_recycler_font01"), 125, 166, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)
            draw.DrawText(_rtypeData.name, zclib.GetFont("ztm_recycler_font02"), 0, 167, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)
            draw.DrawText(" [ " .. _rtypeData.trash_per_block .. ztm.config.UoW .. " | " .. _rtypeData.recycle_time .. " s ]", zclib.GetFont("ztm_recycler_font03"), 0, 190, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)

            // Recycle Button
            if _trash >= _rtypeData.trash_per_block then
                if Recycler:OnStartButton(LocalPlayer()) then
                    draw.RoundedBox(5, -150, 230, 300, 50, ztm.default_colors["blue02"])
                else
                    draw.RoundedBox(5, -150, 230, 300, 50, ztm.default_colors["blue03"])
                end

                draw.DrawText(ztm.language.General["Recycle"], zclib.util.FontSwitch(ztm.language.General["Recycle"], 15, zclib.GetFont("ztm_recycler_font01"), zclib.GetFont("ztm_recycler_font01_small")), 0, 238, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)
            else
                draw.RoundedBox(5, -150, 230, 300, 50, ztm.default_colors["blue03"])
                draw.DrawText(ztm.language.General["Recycle"], zclib.util.FontSwitch(ztm.language.General["Recycle"], 15, zclib.GetFont("ztm_recycler_font01"), zclib.GetFont("ztm_recycler_font01_small")), 0, 238, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)
                draw.RoundedBox(5, -150, 230, 300, 50, ztm.default_colors["black01"])
            end

            draw.DrawText(_trash .. ztm.config.UoW, zclib.GetFont("ztm_recycler_font01"), 0, 100, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)
        end

    cam.End3D2D()
end

function ztm.Recycler.Think(Recycler)
    zclib.util.LoopedSound(Recycler, "ztm_recycler_grind", Recycler.RecycleStage == 2)
    zclib.util.LoopedSound(Recycler, "ztm_recycler_trashfall", Recycler.RecycleStage == 2)
    zclib.util.LoopedSound(Recycler, "ztm_conveyorbelt_loop", true)

    if zclib.util.InDistance(LocalPlayer():GetPos(), Recycler:GetPos(), 1000) then
        if IsValid(Recycler.csBlockModel) then
            if Recycler.csBlockModel:GetNoDraw() == false then
                local attach = Recycler:GetAttachment(1)

                if attach then
                    local ang = attach.Ang
                    ang:RotateAroundAxis(attach.Ang:Forward(), -90)
                    ang:RotateAroundAxis(attach.Ang:Up(), 90)
                    Recycler.csBlockModel:SetPos(attach.Pos)
                    Recycler.csBlockModel:SetAngles(ang)
                end

                local time = CurTime() - Recycler:GetStartTime()

                if time > Recycler.LastBlockUpdate then
                    Recycler.LastBlockUpdate = time + 0.1
                    local _recycle_data = ztm.config.Recycler.recycle_types[Recycler:GetSelectedType()]
                    local bHeight = (1 / _recycle_data.recycle_time) * time
                    local mat = Matrix()
                    mat:Scale(Vector(1, 1, math.Clamp(bHeight, 0, 1)))
                    Recycler.csBlockModel:EnableMatrix("RenderMultiply", mat)
                    Recycler.csBlockModel:SetMaterial(_recycle_data.mat, true)
                end
            end
        else
            Recycler.csBlockModel = zclib.ClientModel.Add("models/zerochain/props_trashman/ztm_recycleblock.mdl")

            if IsValid(Recycler.csBlockModel) then
                Recycler.csBlockModel:SetNoDraw(true)
            end
        end

        local _recyclestage = Recycler:GetRecycleStage()
        if Recycler.RecycleStage ~= _recyclestage then
            Recycler.RecycleStage = _recyclestage

            if Recycler.RecycleStage == 0 then
                Recycler:EmitSound("ztm_trashburner_door")

                timer.Simple(1, function()
                    if IsValid(Recycler) then
                        Recycler:EmitSound("ztm_trashburner_open")
                    end
                end)

                zclib.Animation.Play(Recycler, "open", 1)
                Recycler.csBlockModel:SetNoDraw(true)
            elseif Recycler.RecycleStage == 1 then
                zclib.Animation.Play(Recycler, "close", 1)
                Recycler:EmitSound("ztm_trashburner_door")

                timer.Simple(1, function()
                    if IsValid(Recycler) then
                        Recycler:EmitSound("ztm_trashburner_close")
                    end
                end)

                Recycler.csBlockModel:SetNoDraw(true)
            elseif Recycler.RecycleStage == 2 then
                zclib.Animation.Play(Recycler, "recycle", 1)
                Recycler.LastBlockUpdate = 0
                Recycler.csBlockModel:SetNoDraw(false)
                zclib.Effect.ParticleEffectAttach("ztm_trashfall", PATTACH_POINT_FOLLOW, Recycler, 2)
            elseif Recycler.RecycleStage == 3 then
                Recycler:StopParticlesNamed("ztm_trashfall")
                zclib.Animation.Play(Recycler, "output", 1)
                Recycler:EmitSound("ztm_trashburner_door")

                timer.Simple(1, function()
                    if IsValid(Recycler) then
                        Recycler:EmitSound("ztm_trashburner_open")
                    end
                end)

                Recycler.csBlockModel:SetNoDraw(false)
                local _recycle_type = ztm.config.Recycler.recycle_types[Recycler:GetSelectedType()]
                Recycler.csBlockModel:SetMaterial(_recycle_type.mat, true)
            end
        end

        local _trash = Recycler:GetTrash()
        if Recycler.LastTrash ~= _trash then
            if _trash > Recycler.LastTrash then
                Recycler:SetBodygroup(1, 1)
                zclib.Animation.Play(Recycler, "add_trash", 1.5)
                Recycler:EmitSound("ztm_trash_throw")

                timer.Simple(0.6, function()
                    if IsValid(Recycler) then
                        ztm.Effects.Trash(Recycler:GetPos() + Recycler:GetUp() * 15 + Recycler:GetRight() * -35, Recycler)
                        zclib.Animation.Play(Recycler, "trash_idle", 1)
                        Recycler:SetBodygroup(1, 0)
                    end
                end)
            end

            Recycler.LastTrash = _trash
            local max = ztm.config.TrashBurner.burn_load

            if Recycler.LastTrash <= 0 then
                Recycler:SetBodygroup(0, 0)
            elseif Recycler.LastTrash < max * 0.3 then
                Recycler:SetBodygroup(0, 1)
            elseif Recycler.LastTrash < max * 0.6 then
                Recycler:SetBodygroup(0, 2)
            elseif Recycler.LastTrash >= max * 0.9 then
                Recycler:SetBodygroup(0, 3)
            end
        end
    else
        Recycler.RecycleStage = -1
        Recycler.LastBlockUpdate = 0
        Recycler:StopParticlesNamed("ztm_trashfall")

        if IsValid(Recycler.csBlockModel) then
            Recycler.csBlockModel:Remove()
        end
    end
end

function ztm.Recycler.UpdateVisuals(Recycler)
    Recycler:StopParticlesNamed("ztm_trashfall")

    if Recycler.RecycleStage == 0 then
        zclib.Animation.Play(Recycler, "open", 5)
    elseif Recycler.RecycleStage == 1 then
        zclib.Animation.Play(Recycler, "close", 5)
    elseif Recycler.RecycleStage == 2 then
        zclib.Animation.Play(Recycler, "recycle", 1)
        zclib.Effect.ParticleEffectAttach("ztm_trashfall", PATTACH_POINT_FOLLOW, Recycler, 2)
    elseif Recycler.RecycleStage == 3 then
        zclib.Animation.Play(Recycler, "output", 1)
    end

    local max = ztm.config.TrashBurner.burn_load

    if Recycler.LastTrash <= 0 then
        Recycler:SetBodygroup(0, 0)
    elseif Recycler.LastTrash < max * 0.3 then
        Recycler:SetBodygroup(0, 1)
    elseif Recycler.LastTrash < max * 0.6 then
        Recycler:SetBodygroup(0, 2)
    elseif Recycler.LastTrash >= max * 0.9 then
        Recycler:SetBodygroup(0, 3)
    end
end

function ztm.Recycler.OnRemove(Recycler)
    Recycler:StopSound("ztm_recycler_grind")
    Recycler:StopSound("ztm_recycler_trashfall")
    Recycler:StopSound("ztm_conveyorbelt_loop")

    if IsValid(Recycler.csBlockModel) then
        Recycler.csBlockModel:Remove()
    end
end
