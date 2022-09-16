if SERVER then return end
zrush = zrush or {}
zrush.Pump = zrush.Pump or {}

function zrush.Pump.Initialize(Pump)
    Pump:UpdatePitch()
    Pump.UpdateSound = false
end

function zrush.Pump.Think(Pump)
    if zclib.util.InDistance(LocalPlayer():GetPos(), Pump:GetPos(), 1000) then
        -- One time Effect Creation
        local cur_state = Pump:GetState()
        -- Playing looped sound
        zrush.util.LoopedSound(Pump, "zrush_sfx_jammed", Pump:IsJammed() == true and cur_state == ZRUSH_STATE_JAMMED, 70)
        zrush.util.LoopedSound(Pump, "zrush_sfx_pump", Pump:IsJammed() == false and cur_state == ZRUSH_STATE_PUMPING, Pump.SoundPitch)
    end
end

function zrush.Pump.OnRemove(Pump)
    Pump:StopSound("zrush_sfx_pump")
    Pump:StopSound("zrush_sfx_jammed")
    Pump:StopParticles()
end
