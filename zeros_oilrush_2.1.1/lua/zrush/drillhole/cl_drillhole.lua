if SERVER then return end
zrush = zrush or {}
zrush.DrillHole = zrush.DrillHole or {}

function zrush.DrillHole.Initialize(DrillHole)
    DrillHole.HasEffect = false
    DrillHole.LastState = "nil"
end

function zrush.DrillHole.Think(DrillHole)
    if zclib.util.InDistance(LocalPlayer():GetPos(), DrillHole:GetPos(), 1000) then

        local cur_state = DrillHole:GetState()
        if (cur_state == ZRUSH_STATE_NEEDBURNER) and (DrillHole.LastSplash == nil or CurTime() > DrillHole.LastSplash) then
            zclib.Effect.ParticleEffectAttach("zrush_butangas", PATTACH_POINT_FOLLOW, DrillHole, 0)
            DrillHole.LastSplash = CurTime() + 0.25
        end

        local ReachedOil = DrillHole:GetPipes() >= DrillHole:GetNeededPipes() and not IsValid(DrillHole:GetParent()) and DrillHole:GetOilAmount() > 0 and cur_state ~= ZRUSH_STATE_NEEDBURNER
        if ReachedOil and (DrillHole.LastSplash == nil or CurTime() > DrillHole.LastSplash) then
            zclib.Effect.ParticleEffectAttach("zrush_drillhole_splash", PATTACH_POINT_FOLLOW, DrillHole, 1)
            DrillHole.LastSplash = CurTime() + 0.25
        end


        -- The Sound of the gas
        zrush.util.LoopedSound(DrillHole, "zrush_sfx_butangas", cur_state == ZRUSH_STATE_NEEDBURNER, 100)
        zrush.util.LoopedSound(DrillHole, "zrush_sfx_oil", ReachedOil, 100)
    end
end

function zrush.DrillHole.OnRemove(DrillHole)
    DrillHole:StopSound("zrush_sfx_butangas")
    DrillHole:StopSound("zrush_sfx_oil")
    DrillHole:StopParticles()
end
