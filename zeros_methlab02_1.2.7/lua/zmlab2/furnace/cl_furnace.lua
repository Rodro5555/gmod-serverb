if not CLIENT then return end
zmlab2 = zmlab2 or {}
zmlab2.Furnace = zmlab2.Furnace or {}


function zmlab2.Furnace.Initialize(Furnace)
    Furnace.SmoothBar = 0
    Furnace.SmoothDegree = 0
end

function zmlab2.Furnace.OnRemove(Furnace)
    Furnace:StopSound("zmlab2_boil01_loop")
    Furnace:StopSound("zmlab2_boil02_loop")
end

function zmlab2.Furnace.Draw(Furnace)
    if zclib.util.InDistance(LocalPlayer():GetPos(),Furnace:GetPos(), 1000) then

        // Draw ui
        if zclib.Convar.Get("zmlab2_cl_drawui") == 1 then zmlab2.Furnace.DrawUI(Furnace) end

        // Draw light
        if Furnace:GetProcessState() == 2 then zmlab2.Furnace.DrawLight(Furnace) end

        // Vibrates certain bones of the machine
        zclib.VibrationSystem.Run(Furnace,Furnace:GetProcessState() == 2,(1 / 100) * Furnace:GetTemperatur())
    end
    zclib.util.LoopedSound(Furnace, "zmlab2_boil01_loop", Furnace:GetProcessState() == 2)
    zclib.util.LoopedSound(Furnace, "zmlab2_boil02_loop", Furnace:GetProcessState() == 2 and Furnace:GetTemperatur() > 25)
end

function zmlab2.Furnace.DrawLight(Furnace)
    if zclib.Convar.Get("zmlab2_cl_vfx_dynamiclight") == 0 then return end
    local dlight = DynamicLight(Furnace:EntIndex())
    if (dlight) then
        dlight.pos = Furnace:LocalToWorld(Vector(-15,25,30))
        dlight.r = 150
        dlight.g = 190
        dlight.b = 71
        dlight.brightness = 1
        dlight.style = 0
        dlight.Decay = 1000
        dlight.Size = 128
        dlight.DieTime = CurTime() + 1
    end
end

local function SimpleButton(x,y,icon,hover)
    surface.SetDrawColor( color_white )
    surface.SetMaterial(zclib.Materials.Get(icon))
    surface.DrawTexturedRectRotated(x, y, 50, 50, 0 )

    surface.SetDrawColor( color_white )
    surface.SetMaterial(zclib.Materials.Get("icon_box01"))
    surface.DrawTexturedRectRotated(x, y, 50, 50, 0 )

    if hover then
        draw.RoundedBox(5, x - 25, y - 25, 50,50, zmlab2.colors["white02"])
    end
end

local ScreenData = {
    pos = Vector(-17.5, 12.9, 54.3),
    ang = Angle(0, 180, 90),
    x = 0,
    y = 0,
    w = 340,
    h = 162,
    pages = {
        [0] = function(Furnace)
            zmlab2.Interface.DrawIngredient(0, 0, 340, 165, zclib.Materials.Get("icon_acid"),zmlab2.config.Furnace.Capacity - Furnace:GetAcidAmount(),zclib.GetFont("zmlab2_font03"))
        end,
        [1] = function(Furnace)
            zmlab2.Interface.DrawButton(0, 0, 200, 80, zmlab2.language["Start"], Furnace:OnStart(LocalPlayer()))
        end,
        [2] = function(Furnace)
            draw.RoundedBox(0, -110, -32, 220, 5, color_white)
            SimpleButton(-120, 10, "icon_cold", Furnace:OnDecrease(LocalPlayer()))
            SimpleButton(120, 10, "icon_hot", Furnace:OnIncrease(LocalPlayer()))
            draw.RoundedBox(10, -210 + ((300 / 3) * (Furnace:GetHeater() + 1)), -40, 20, 20, color_white)

            local heatTime = math.Clamp(CurTime() - Furnace:GetHeatingStart(), 0, zmlab2.config.Furnace.HeatingCylce_Duration)
            draw.RoundedBox(0, -140, 40, 280, 20, zclib.colors["black_a100"])
            draw.RoundedBox(0, -140, 40, (280 / zmlab2.config.Furnace.HeatingCylce_Duration) * heatTime, 20, color_white)
            zclib.util.DrawOutlinedBox(-140, 40, 280, 20, 1, color_white)
        end,
        [4] = function(Furnace)
            zmlab2.Interface.DrawButton(0, 0, 240, 80, zmlab2.language["Move Liquid"], Furnace:OnStart(LocalPlayer()))
        end,
        [6] = function(Furnace)
            surface.SetDrawColor(color_white )
            surface.SetMaterial(zclib.Materials.Get("icon_sponge"))
            surface.DrawTexturedRectRotated(0, 0, 140, 140, 0 )
        end
    }
}
function zmlab2.Furnace.DrawUI(Furnace)

    // Draw screen
    zmlab2.Interface.Draw(Furnace,ScreenData)

    // Draws how much acid we have
    cam.Start3D2D(Furnace:LocalToWorld(Vector(-30.5,10.5,16)), Furnace:LocalToWorldAngles(Angle(0,0,-90)), 0.1)

        local turbulence = 0
        if Furnace:GetProcessState() == 2 then
            if Furnace:GetTemperatur() > 50 then
                turbulence = 1.25
            elseif Furnace:GetTemperatur() > 25 then
                turbulence = 0.5
            end
        end

        local bar_size = (1 / zmlab2.config.Furnace.Capacity) * Furnace:GetAcidAmount()
        Furnace.SmoothBar = Lerp(FrameTime() * 0.5,Furnace.SmoothBar,bar_size)
        zmlab2.Interface.DrawLiquid(Furnace,130,35,40,170,Furnace.SmoothBar,zmlab2.colors["acid"],turbulence)
    cam.End3D2D()

    cam.Start3D2D(Furnace:LocalToWorld(Vector(-7.55,10.1,65.1)), Furnace:LocalToWorldAngles(Angle(0,180,90)),0.1)

        surface.SetDrawColor(color_white)
        surface.SetMaterial(zclib.Materials.Get("temp_bg"))
        surface.DrawTexturedRectRotated(-19, 20, 49 , 49 , 0)

        surface.SetDrawColor(color_white)
        surface.SetMaterial(zclib.Materials.Get("air_pressure_pointer"))
        surface.DrawTexturedRectRotated(-20, 20,40,40,Furnace.SmoothDegree)

        surface.SetDrawColor(zclib.colors["black_a200"])
        surface.SetMaterial(zclib.Materials.Get("radial_invert_glow"))
        surface.DrawTexturedRectRotated(-19, 20, 49 , 49 , 0)

        if Furnace:GetProcessState() == 2 then
            local temp = Furnace:GetTemperatur()

            if temp > 70 then
                local time_mul = 0.25 + math.abs(math.sin(CurTime() * 5))
                local col = Color(255, 0, 0, 200 * time_mul)
                surface.SetDrawColor(col)
                surface.SetMaterial(zclib.Materials.Get("radial_invert_glow"))
                surface.DrawTexturedRectRotated(-19.5, 20, 48 , 48 , 0)
                draw.SimpleText("!", zclib.GetFont("zmlab2_font02"), -20, 20, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            temp = 100 - temp
            local deg = (270 / 100) * temp
            deg = deg - 135
            Furnace.SmoothDegree = Lerp(1.5 * FrameTime(),Furnace.SmoothDegree,deg)
        else
            Furnace.SmoothDegree = Lerp(1.5 * FrameTime(),Furnace.SmoothDegree,140)
        end
    cam.End3D2D()
end
