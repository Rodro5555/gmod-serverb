if SERVER then return end
zrush = zrush or {}
zrush.Burner = zrush.Burner or {}

function zrush.Burner.Initialize(Burner)
    Burner:UpdatePitch()
    Burner.UpdateSound = false
    Burner.LastState = "nil"
    zclib.EntityTracker.Add(Burner)
end

function zrush.Burner.Think(Burner)
    if zclib.util.InDistance(LocalPlayer():GetPos(), Burner:GetPos(), 1000) then
        // One time Effect Creation
        local cur_state = Burner:GetState()

        if Burner.LastState ~= cur_state then
            Burner.LastState = cur_state
            Burner:StopParticles()

            if (Burner.LastState == ZRUSH_STATE_BURNINGGAS) then
                zclib.Effect.ParticleEffectAttach("zrush_burner", PATTACH_POINT_FOLLOW, Burner, 4)
            elseif (Burner.LastState == ZRUSH_STATE_OVERHEAT) then
                zclib.Effect.ParticleEffectAttach("zrush_burner_overheat", PATTACH_POINT_FOLLOW, Burner, 4)
            end
        end

        // Playing looped sound
        zrush.util.LoopedSound(Burner, "zrush_sfx_overheat_loop", Burner:IsOverHeating() == true and cur_state == ZRUSH_STATE_OVERHEAT, 70)
        zrush.util.LoopedSound(Burner, "zrush_sfx_refine", Burner:IsOverHeating() == false and cur_state == ZRUSH_STATE_BURNINGGAS, Burner.SoundPitch)
    else
        if Burner.LastState ~= nil then
            Burner.LastState = nil
            Burner:StopParticles()
        end
    end
end

function zrush.Burner.OnRemove(Burner)
    Burner:StopSound("zrush_sfx_overheat_loop")
    Burner:StopSound("zrush_sfx_refine")
    Burner:StopParticles()
    zclib.EntityTracker.Remove(Burner)
end
