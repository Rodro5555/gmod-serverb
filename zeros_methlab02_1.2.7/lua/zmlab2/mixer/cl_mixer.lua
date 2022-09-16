if not CLIENT then return end
zmlab2 = zmlab2 or {}
zmlab2.Mixer = zmlab2.Mixer or {}


function zmlab2.Mixer.Initialize(Mixer)
    Mixer.SmoothAnim = 0
end

function zmlab2.Mixer.OnRemove(Mixer)
    Mixer:StopSound("zmlab2_machine_pumping")
    Mixer:StopSound("zmlab2_machine_venting")
end

function zmlab2.Mixer.Think(Mixer)

    if zclib.util.InDistance(LocalPlayer():GetPos(),Mixer:GetPos(), 1000) then
        Mixer:OnCenterButton(LocalPlayer())
        local _state = Mixer:GetProcessState()

        zclib.util.LoopedSound(Mixer, "zmlab2_machine_pumping", _state == 3 or _state == 6)
        zclib.util.LoopedSound(Mixer, "zmlab2_machine_venting", _state == 7 or _state == 8 or _state == 4 )

        // Smoke effect when tank is open
        if _state == 4 and (Mixer.NextEffect == nil or (Mixer.NextEffect and CurTime() > Mixer.NextEffect)) then

            local m_data = zmlab2.config.MethTypes[Mixer:GetMethType()]
            if m_data and m_data.visuals and m_data.visuals.effect_mixer_liquid then
                zclib.Effect.ParticleEffect(m_data.visuals.effect_mixer_liquid, Mixer:LocalToWorld(Vector(15,0,45)), Mixer:GetAngles(), Mixer)
            end
            Mixer.NextEffect = CurTime() + 1
        end

        // Smoke effect when Exhaust connection is open
        if _state == 7 and (Mixer.NextEffect == nil or (Mixer.NextEffect and CurTime() > Mixer.NextEffect)) then

            local m_data = zmlab2.config.MethTypes[Mixer:GetMethType()]
            if m_data and m_data.visuals and m_data.visuals.effect_mixer_exhaust then
                zclib.Effect.ParticleEffect(m_data.visuals.effect_mixer_exhaust, Mixer:LocalToWorld(Vector(23.1,0,55)), Mixer:GetAngles(), Mixer)
            end
            Mixer.NextEffect = CurTime() + 1
        end

        if _state == 0 or _state == 4 or _state == 11 then
            Mixer.SmoothAnim = Lerp(2 * FrameTime(),Mixer.SmoothAnim,0.6)
        else
            Mixer.SmoothAnim = Lerp(2 * FrameTime(),Mixer.SmoothAnim,0)
        end
        Mixer:SetPoseParameter("zmlab2_deckel_move",Mixer.SmoothAnim)
        Mixer:InvalidateBoneCache()
    end
end

function zmlab2.Mixer.Draw(Mixer)
    if zclib.util.InDistance(LocalPlayer():GetPos(),Mixer:GetPos(), 1000) then
        if zclib.Convar.Get("zmlab2_cl_drawui") == 1 then zmlab2.Mixer.DrawUI(Mixer) end

        // Vibrates certain bones of the machine
        local _state = Mixer:GetProcessState()
        zclib.VibrationSystem.Run(Mixer,_state == 3 or _state == 6,0.5)
    end
end

local ScreenData = {
    pos = Vector(-5,13.69,31.7),
    ang = Angle(0, 180, 90),
    x = 0,
    y = 0,
    w = 220,
    h = 280,
    pages = {
        [-1] = function(Mixer)
            local MethData = zmlab2.config.MethTypes[Mixer:GetMethType()]
            zmlab2.Interface.DrawButton(0, -50, 180, 80, MethData.name, Mixer:OnMethType(LocalPlayer()))
            zmlab2.Interface.DrawButton(0, 50, 180, 80, zmlab2.language["Start"], Mixer:OnStart(LocalPlayer()))
        end,
        [0] = function(Mixer)
            zmlab2.Interface.DrawIngredient(0, 0, 220, 280, zclib.Materials.Get("icon_bee"),Mixer:GetNeedAmount(),zclib.GetFont("zmlab2_font03"))
        end,
        [1] = function(Mixer)
            zmlab2.Interface.DrawPipe(220,220,zmlab2.colors["acid"])
        end,
        [2] = function(Mixer)
            zmlab2.Interface.DrawButton(0, 0, 200, 80, zmlab2.language["Start"], Mixer:OnCenterButton(LocalPlayer()))
        end,
        [3] = function(Mixer)
            zmlab2.Interface.DrawProgress(zmlab2.Meth.GetMixTime(Mixer:GetMethType()),CurTime() - Mixer:GetProcessStart())
        end,
        [4] = function(Mixer)
            zmlab2.Interface.DrawIngredient(0, 0, 220, 280, zclib.Materials.Get("icon_alu"),Mixer:GetNeedAmount(),zclib.GetFont("zmlab2_font03"))
        end,
        [5] = function(Mixer)
            zmlab2.Interface.DrawButton(0, 0, 200, 80, zmlab2.language["Start"], Mixer:OnCenterButton(LocalPlayer()))
        end,
        [6] = function(Mixer)
            zmlab2.Interface.DrawProgress(zmlab2.Meth.GetMixTime(Mixer:GetMethType()),CurTime() - Mixer:GetProcessStart())
        end,
        [7] = function(Mixer)
            local rot = 10 * math.sin(CurTime() * 1)
            rot = zclib.util.SnapValue(15,rot)

            surface.SetDrawColor(color_white )
            if rot == 0 then
                surface.SetMaterial(zclib.Materials.Get("icon_pipe"))
            else
                surface.SetMaterial(zclib.Materials.Get("icon_pipe_smoke"))
            end
            surface.DrawTexturedRectRotated(0, 10, 260, 260, 0 )


            local e_width,e_y = 100,-45
            surface.SetDrawColor(color_white)
            surface.SetMaterial(zclib.Materials.Get("icon_E"))
            surface.DrawTexturedRectRotated(0, e_y, e_width, e_width, 0)

            if Mixer:OnCenterButton(LocalPlayer()) then
                draw.RoundedBox(10, -45, -90, 90, 90, zmlab2.colors["white02"])
            end

            Mixer.Pulse = (Mixer.Pulse or 0) + (1 * FrameTime())
            if Mixer.Pulse > 1 then Mixer.Pulse = 0 end


            local mul = 1 + math.abs(0.7 * Mixer.Pulse)
            surface.SetDrawColor(Color(255, 255, 255, 200 - 200 * Mixer.Pulse))
            surface.SetMaterial(zclib.Materials.Get("icon_box01"))
            surface.DrawTexturedRectRotated(0, e_y, e_width * mul, e_width * mul, 0)
        end,
        [8] = function(Mixer)
            zmlab2.Interface.DrawProgress(zmlab2.Meth.GetVentTime(Mixer:GetMethType()),CurTime() - Mixer:GetProcessStart())
        end,
        [9] = function(Mixer)
            zmlab2.Interface.DrawButton(0, 0, 200, 80, zmlab2.language["Move Liquid"], Mixer:OnCenterButton(LocalPlayer()))
        end,
        [11] = function(Mixer)
            surface.SetDrawColor(color_white )
            surface.SetMaterial(zclib.Materials.Get("icon_sponge"))
            surface.DrawTexturedRectRotated(0, 0, 200, 200, 0 )
        end
    }
}

function zmlab2.Mixer.DrawUI_Liquid(Mixer)
    local _state = Mixer:GetProcessState()

    local col = zmlab2.Mixer.GetLiquidColor(Mixer)

    local amount = 0
    if (_state >= 1 and _state <= 9) or Mixer:GetBodygroup(4) == 1 then amount = 0.95 end

    if Mixer.SmoothBar == nil then Mixer.SmoothBar = 0 end
    Mixer.SmoothBar = Lerp(0.5 * FrameTime(),Mixer.SmoothBar,amount)

    if Mixer:GetBodygroup(4) == 0 and _state <= 0 or _state >= 11 then Mixer.SmoothBar = 0 end

    local turbulence = 0
    if _state == 3 or _state == 6 or _state == 8 then turbulence = 0.5 end

    cam.Start3D2D(Mixer:LocalToWorld(Vector(17.8,13.7,25)), Mixer:LocalToWorldAngles(Angle(0,0,-90)), 0.1)
        zmlab2.Interface.DrawLiquid(Mixer,-50, -20, 40, 275,Mixer.SmoothBar,col,turbulence)
    cam.End3D2D()
end

function zmlab2.Mixer.DrawUI(Mixer)

    local _state = Mixer:GetProcessState()

    // Draws the liquid indicator
    zmlab2.Mixer.DrawUI_Liquid(Mixer)

    local MethData = zmlab2.config.MethTypes[Mixer:GetMethType()]
    if _state == -1 then
        ScreenData.OverwriteColor = MethData.color
    end

    // Draws the current status
    zmlab2.Interface.Draw(Mixer,ScreenData)
end
