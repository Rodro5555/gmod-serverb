if not CLIENT then return end
zmlab2 = zmlab2 or {}
zmlab2.Frezzer = zmlab2.Frezzer or {}


function zmlab2.Frezzer.Initialize(Frezzer)
    Frezzer.Initialize = true
    timer.Simple(1,function()
        if IsValid(Frezzer) then Frezzer.Initialize = false end
    end)
    Frezzer.NextFrezzeSound = 0
    Frezzer.NextFrezzeEffect = 0
end

function zmlab2.Frezzer.Think(Frezzer)
    if Frezzer.Initialize == true then return end
    if zclib.util.InDistance(LocalPlayer():GetPos(),Frezzer:GetPos(), 1000) then
        local _state = Frezzer:GetProcessState()

        if _state == 2 and CurTime() >= Frezzer.NextFrezzeSound then
            zclib.Sound.EmitFromEntity("frezzing_crack", Frezzer)
            Frezzer.NextFrezzeSound = CurTime() + math.random(1,3)
        end

        /*
        if _state == 2 and CurTime() >= Frezzer.NextFrezzeEffect then
            Frezzer.NextFrezzeEffect = CurTime() + 1
            zclib.Effect.ParticleEffect("zmlab2_frozen_gas", Frezzer:LocalToWorld(Vector(17,0,41.5)), Frezzer:GetAngles(), Frezzer)
        end
        */

        if _state ~= Frezzer.LastState then

            if Frezzer.LastState ~= 0 then
                if _state >= 2 then
                    zclib.Animation.Play(Frezzer, "close", 1)
                else
                    zclib.Animation.Play(Frezzer, "open", 1)
                end
            end

            Frezzer.LastState = _state
        end
    else
        Frezzer.LastState = nil
    end
end

function zmlab2.Frezzer.OnRemove(Frezzer)
    Frezzer:StopSound("zmlab2_machine_compressing")
end

function zmlab2.Frezzer.DrawLight(Frezzer)
    if zclib.Convar.Get("zmlab2_cl_vfx_dynamiclight") == 0 then return end
    local dlight = DynamicLight(Frezzer:EntIndex())
    if (dlight) then
        dlight.pos = Frezzer:LocalToWorld(Vector(17,-5,35))
        dlight.r = 126
        dlight.g = 181
        dlight.b = 239
        dlight.brightness = 1
        dlight.style = 0
        dlight.Decay = 1000
        dlight.Size = 128
        dlight.DieTime = CurTime() + 1
    end
end

local ScreenData = {
    pos = Vector(12.3, 10.66, 52.5),
    ang = Angle(0, 180, 90),
    x = 0,
    y = 0,
    w = 160,
    h = 140,
    pages = {
        [0] = function(Frezzer)
            zmlab2.Interface.DrawIngredient(0, 0, 160, 140, zclib.Materials.Get("icon_lox"),1,zclib.GetFont("zmlab2_font02"))
        end,
        [1] = function(Frezzer)
            zmlab2.Interface.DrawButton(0, -35, 150, 60, zmlab2.language["Start"], Frezzer:OnStart(LocalPlayer()))
            zmlab2.Interface.DrawButton(0, 35, 150, 60, zmlab2.language["Drop"], Frezzer:OnDropTray(LocalPlayer()))
        end,
        [2] = function(Frezzer)
            zmlab2.Interface.DrawProgress(zmlab2.config.Frezzer.Time,CurTime() - Frezzer:GetFrezzeStart())
        end
    }
}

function zmlab2.Frezzer.Draw(Frezzer)
    if Frezzer.Initialize == true then return end
    zclib.util.LoopedSound(Frezzer, "zmlab2_machine_compressing", Frezzer:GetProcessState() == 2)

    if zclib.util.InDistance(LocalPlayer():GetPos(),Frezzer:GetPos(), 1000) and zclib.Convar.Get("zmlab2_cl_drawui") == 1 then

        zmlab2.Interface.Draw(Frezzer,ScreenData)

        if Frezzer:GetProcessState() == 2 then
            zmlab2.Frezzer.DrawLight(Frezzer)
        end
    end

    // Update the material once it gets drawn
    if Frezzer.LastDraw and CurTime() > (Frezzer.LastDraw + 0.1) then
        if Frezzer:GetProcessState() ~= 2 and Frezzer:GetSequence() ~= Frezzer:LookupSequence("open") then
            Frezzer.LastState = nil
        end
    end

    Frezzer.LastDraw = CurTime()
end
