if SERVER then return end
ztm = ztm or {}
ztm.Trashburner = ztm.Trashburner or {}

function ztm.Trashburner.Initialize(TrashBurner)
    zclib.EntityTracker.Add(TrashBurner)
    TrashBurner.LastTrash = 0
    TrashBurner.IsBurning = false
    TrashBurner.IsClosed = false
    zclib.Animation.Play(TrashBurner, "open", 1)
end

function ztm.Trashburner.Draw(TrashBurner)
    ztm.util.UpdateEntityVisuals(TrashBurner)

    if zclib.util.InDistance(LocalPlayer():GetPos(), TrashBurner:GetPos(), 300) then
        ztm.Trashburner.DrawInfo(TrashBurner)
    end
end

local function DrawButton(texta, textb, x, y, w, h, hover, state, locked)
    if hover and locked == false then
        draw.RoundedBox(5, x, y, w, h, ztm.default_colors["blue02"])
    else
        draw.RoundedBox(5, x, y, w, h, ztm.default_colors["blue03"])
    end

    if state then
        draw.DrawText(texta, zclib.GetFont("ztm_trashburner_font02"), x + 50, y + 25, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)
    else
        draw.DrawText(textb, zclib.GetFont("ztm_trashburner_font02"), x + 50, y + 25, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)
    end

    if locked then
        draw.RoundedBox(5, x, y, w, h, ztm.default_colors["black01"])
    end
end

function ztm.Trashburner.DrawInfo(TrashBurner)
    cam.Start3D2D(TrashBurner:LocalToWorld(Vector(-40, 0, 78)), TrashBurner:LocalToWorldAngles(Angle(0, -90, 90)), 0.1)
        draw.RoundedBox(5, -120, 115, 240, 150, ztm.default_colors["blue01"])
        local _trash = TrashBurner:GetTrash()

        if TrashBurner.IsBurning then
            draw.RoundedBox(5, -105, 127, 210, 50, ztm.default_colors["black01"])
            -- The expected time
            local exp_time = math.Clamp(_trash * ztm.config.TrashBurner.burn_time, 1, ztm.config.TrashBurner.burn_load * ztm.config.TrashBurner.burn_time)
            local time = CurTime() - TrashBurner:GetStartTime()
            local size = (210 / exp_time) * time
            draw.RoundedBox(5, -105, 127, size, 50, ztm.default_colors["red01"])
        end

        draw.DrawText(_trash .. ztm.config.UoW, zclib.GetFont("ztm_trashburner_font01"), 0, 125, ztm.default_colors["white01"], TEXT_ALIGN_CENTER)
        DrawButton(ztm.language.General["Open"], ztm.language.General["Close"], -105, 182.5, 100, 75, TrashBurner:OnCloseButton(LocalPlayer()), TrashBurner.IsClosed, TrashBurner.IsBurning)
        DrawButton(ztm.language.General["Start"], ztm.language.General["Start"], 5, 182.5, 100, 75, TrashBurner:OnStartButton(LocalPlayer()), TrashBurner.IsBurning, TrashBurner.IsClosed == false or TrashBurner.LastTrash <= 0 or TrashBurner.IsBurning)
    cam.End3D2D()
end

function ztm.Trashburner.Think(TrashBurner)
    zclib.util.LoopedSound(TrashBurner, "ztm_trashburner_burning", TrashBurner:GetIsBurning())

    if zclib.util.InDistance(LocalPlayer():GetPos(), TrashBurner:GetPos(), 1000) then
        local _isclosed = TrashBurner:GetIsClosed()

        if TrashBurner.IsClosed ~= _isclosed then
            TrashBurner.IsClosed = _isclosed

            if TrashBurner.IsClosed then
                zclib.Animation.Play(TrashBurner, "close", 1)
                TrashBurner:EmitSound("ztm_trashburner_door")

                timer.Simple(1, function()
                    if IsValid(TrashBurner) then
                        TrashBurner:StopSound("ztm_trashburner_door")
                        TrashBurner:EmitSound("ztm_trashburner_close")
                    end
                end)
            else
                zclib.Animation.Play(TrashBurner, "open", 1)
                TrashBurner:EmitSound("ztm_trashburner_door")

                timer.Simple(1, function()
                    if IsValid(TrashBurner) then
                        TrashBurner:StopSound("ztm_trashburner_door")
                        TrashBurner:EmitSound("ztm_trashburner_open")
                    end
                end)
            end
        end

        local _isburning = TrashBurner:GetIsBurning()

        if TrashBurner.IsBurning ~= _isburning then
            TrashBurner.IsBurning = _isburning

            if TrashBurner.IsBurning then
                zclib.Effect.ParticleEffectAttach("ztm_burn", PATTACH_POINT_FOLLOW, TrashBurner, 1)
                zclib.Effect.ParticleEffectAttach("ztm_smoke", PATTACH_POINT_FOLLOW, TrashBurner, 2)
                zclib.Effect.ParticleEffectAttach("ztm_smoke", PATTACH_POINT_FOLLOW, TrashBurner, 3)
            else
                TrashBurner:StopParticles()
            end
        end

        local _trash = TrashBurner:GetTrash()

        if TrashBurner.LastTrash ~= _trash then
            if _trash > TrashBurner.LastTrash then
                TrashBurner:SetBodygroup(1, 1)
                zclib.Animation.Play(TrashBurner, "add_trash", 2)
                TrashBurner:EmitSound("ztm_trash_throw")

                timer.Simple(0.3, function()
                    if IsValid(TrashBurner) then
                        ztm.Effects.Trash(TrashBurner:GetPos() + TrashBurner:GetUp() * 15 + TrashBurner:GetForward() * -35, TrashBurner)
                        zclib.Animation.Play(TrashBurner, "trash_idle", 1)
                        TrashBurner:SetBodygroup(1, 0)
                    end
                end)
            end

            TrashBurner.LastTrash = _trash
            local max = ztm.config.TrashBurner.burn_load

            if TrashBurner.LastTrash <= 0 then
                TrashBurner:SetBodygroup(0, 0)
            elseif TrashBurner.LastTrash < max * 0.3 then
                TrashBurner:SetBodygroup(0, 1)
            elseif TrashBurner.LastTrash < max * 0.6 then
                TrashBurner:SetBodygroup(0, 2)
            elseif TrashBurner.LastTrash >= max * 0.9 then
                TrashBurner:SetBodygroup(0, 3)
            end
        end
    else
        TrashBurner.IsBurning = false
        TrashBurner.IsClosed = false
    end
end

function ztm.Trashburner.UpdateVisuals(TrashBurner)
    if TrashBurner.IsClosed then
        zclib.Animation.Play(TrashBurner, "close", 5)
    else
        zclib.Animation.Play(TrashBurner, "open", 5)
    end

    if TrashBurner.IsBurning then
        TrashBurner:StopParticles()
        zclib.Effect.ParticleEffectAttach("ztm_burn", PATTACH_POINT_FOLLOW, TrashBurner, 1)
        zclib.Effect.ParticleEffectAttach("ztm_smoke", PATTACH_POINT_FOLLOW, TrashBurner, 2)
        zclib.Effect.ParticleEffectAttach("ztm_smoke", PATTACH_POINT_FOLLOW, TrashBurner, 3)
    else
        TrashBurner:StopParticles()
    end

    local max = ztm.config.TrashBurner.burn_load

    if TrashBurner.LastTrash <= 0 then
        TrashBurner:SetBodygroup(0, 0)
    elseif TrashBurner.LastTrash < max * 0.3 then
        TrashBurner:SetBodygroup(0, 1)
    elseif TrashBurner.LastTrash < max * 0.6 then
        TrashBurner:SetBodygroup(0, 2)
    elseif TrashBurner.LastTrash >= max * 0.9 then
        TrashBurner:SetBodygroup(0, 3)
    end
end

function ztm.Trashburner.Remove(TrashBurner)
    TrashBurner:StopParticles()
    TrashBurner:StopSound("ztm_trashburner_door")
    TrashBurner:StopSound("ztm_trashburner_burning")
end
