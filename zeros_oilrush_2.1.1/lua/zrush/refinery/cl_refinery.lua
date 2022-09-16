if SERVER then return end
zrush = zrush or {}
zrush.Refinery = zrush.Refinery or {}

function zrush.Refinery.Initialize(Refinery)
    Refinery:UpdatePitch()
    Refinery.UpdateSound = false
    Refinery.LastState = "nil"
    zclib.EntityTracker.Add(Refinery)
end

function zrush.Refinery.Draw(Refinery)
    if zclib.Convar.Get("zclib_cl_drawui") == 1 and zclib.util.InDistance(LocalPlayer():GetPos(), Refinery:GetPos(), 500) then
        zrush.Refinery.DrawMainInfo(Refinery)
    end
end

local time = 0
local progress = 0
local l_pos = Vector(0, -24.3, 69.5)
local l_ang = Angle(0, 0, 90)
function zrush.Refinery.DrawMainInfo(Refinery)
    cam.Start3D2D(Refinery:LocalToWorld(l_pos), Refinery:LocalToWorldAngles(l_ang), 0.1)
    draw.RoundedBox(0, -53, -50, 108, 108, zrush.Fuel.GetTransColor(Refinery:GetFuelTypeID()))

    if Refinery.LastState == ZRUSH_STATE_REFINING then
        if (time > 100) then
            time = 0
        else
            local boostBoni = Refinery:GetBoostValue("speed")
            time = time + (70 * FrameTime() - (20 * FrameTime() * boostBoni))
            progress = (1 / 100) * time
        end

        surface.SetDrawColor(zrush.FuelTypes[Refinery:GetFuelTypeID()].color)
        surface.SetMaterial(zrush.default_materials["circle_refining"])
        surface.DrawTexturedRectRotated(0, 0, 100, 100, Lerp(progress, 360, 0))
    end

    cam.End3D2D()
end

function zrush.Refinery.Think(Refinery)
    if zclib.util.InDistance(LocalPlayer():GetPos(), Refinery:GetPos(), 1000) then

        // One time Effect Creation
        local cur_state = Refinery:GetState()
        if Refinery.LastState ~= cur_state then
            Refinery.LastState = cur_state
            Refinery:StopParticles()

            if (Refinery.LastState == ZRUSH_STATE_REFINING) then
                zclib.Effect.ParticleEffectAttach("zrush_burner", PATTACH_POINT_FOLLOW, Refinery, 7)
            elseif (Refinery.LastState == ZRUSH_STATE_OVERHEAT) then
                zclib.Effect.ParticleEffectAttach("zrush_refinery_overheat", PATTACH_POINT_FOLLOW, Refinery, 7)
            end
        end

        // Playing looped sound
        zrush.util.LoopedSound(Refinery, "zrush_sfx_overheat_loop", Refinery:IsOverHeating() == true and cur_state == ZRUSH_STATE_OVERHEAT, 70)
        zrush.util.LoopedSound(Refinery, "zrush_sfx_refine", Refinery:IsOverHeating() == false and cur_state == ZRUSH_STATE_REFINING, Refinery.SoundPitch)
    else
        if Refinery.LastState ~= nil then
            Refinery.LastState = nil
            Refinery:StopParticles()
        end
    end
end

function zrush.Refinery.OnRemove(Refinery)
    Refinery:StopSound("zrush_sfx_overheat_loop")
    Refinery:StopSound("zrush_sfx_refine")
    Refinery:StopParticles()
end
