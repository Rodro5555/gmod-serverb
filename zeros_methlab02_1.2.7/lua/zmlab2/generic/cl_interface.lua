if SERVER then return end

zmlab2 = zmlab2 or {}
zmlab2.Interface = zmlab2.Interface or {}

function zmlab2.Interface.DrawIngredient(x, y, w, h, icon,amount,font)

    //draw.RoundedBox(0, -w/2, -h/2, w, h, zmlab2.colors["red02"])

    local rot = 15 * math.sin(CurTime() * 4)
    rot = zclib.util.SnapValue(15,rot)

    local icon_size =  math.Clamp(w * 0.7,0,h * 0.8)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(icon)
    surface.DrawTexturedRectRotated(x, y, icon_size, icon_size, rot)

    local tri_size = math.Clamp(w * 0.5,0,h * 0.75)
    local tri_x = x - w / 2
    surface.SetDrawColor(color_white)
    surface.SetMaterial(zclib.Materials.Get("icon_triangle"))
    surface.DrawTexturedRect(tri_x, y + ((h / 2) - tri_size), tri_size, tri_size)

    draw.SimpleText(amount .. "x", font, tri_x + 10,y + (h / 2) + 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
end

function zmlab2.Interface.DrawPipe(w, h, color)
    local rot = 10 * math.sin(CurTime() * 1)
    rot = zclib.util.SnapValue(15, rot)
    surface.SetDrawColor(color_white)
    if rot == 0 then
        surface.SetMaterial(zclib.Materials.Get("icon_pipe_on"))
    else
        surface.SetMaterial(zclib.Materials.Get("icon_pipe_off"))
    end
    surface.DrawTexturedRectRotated(0, h * 0.25, w, h, 0)

    surface.SetDrawColor(color)
    surface.SetMaterial(zclib.Materials.Get("icon_liquid"))
    surface.DrawTexturedRectRotated(0, -h * 0.25, w * 0.4, h * 0.4, 0)
end

function zmlab2.Interface.DrawButton(x, y, w, h, txt, hover)
    zclib.util.DrawOutlinedBox(x - (w / 2), y - (h / 2), w, h, 2, color_white)
    local font = zclib.GetFont("zmlab2_font02")
    local txtSize = zclib.util.GetTextSize(txt,font)
    if txtSize > w then
        // Does this slightly smaller font work?
        font = zclib.GetFont("zmlab2_font05")
        txtSize = zclib.util.GetTextSize(txt,font)
        if txtSize > w then
            // If not then use the really small one
            font = zclib.GetFont("zmlab2_font01")
        end
    end
    draw.SimpleText(txt, font, x, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    if hover then
        draw.RoundedBox(0, x - (w / 2), y - (h / 2), w, h, zmlab2.colors["white02"])
    end
end

function zmlab2.Interface.DrawProgress(Duration,TimePassed,YOffset)
    local time = (100 / Duration) * TimePassed
    draw.SimpleText(math.Clamp(math.Round(time), 0, 100) .. "%", zclib.GetFont("zmlab2_font03"), 0, 0 + (YOffset or 0), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local wave_res = 16
local cWhite = color_white
function zmlab2.Interface.DrawLiquid(Machine,ax,ay,w,h,size,color,turbulence)
    draw.RoundedBox(0, ax, ay, w, h, zmlab2.colors["black04"])

    // Change the wave according to turbulence
    local wave_height = 1 + 5 * turbulence
    local wave_length = 0.5 + 0.1 * turbulence
    local wave_speed = 2 + 8 * turbulence

    if Machine.Verts == nil then Machine.Verts = {} end

    local BarSize = h * size

    Machine.Verts[1] = { x = ax, y = math.Clamp(ay + BarSize - 50, ay, ay + h) } // Right Top
    Machine.Verts[2] = { x = ax, y = ay } // Right Bottom
    Machine.Verts[3] = { x = ax + w, y = ay } // Left Bottom
    Machine.Verts[4] = { x = ax + w, y = math.Clamp(ay + BarSize - 50, ay, ay + h) } // Left Top

    for i = 1, wave_res do

        local xIncrease = ((w + 5) / wave_res) * (i - 1)
        local nx = ax - xIncrease + w
        nx = math.Clamp(nx, ax, ax + w)

        local yIncrease = math.sin((i * wave_length) + CurTime() * wave_speed)
        yIncrease = yIncrease * wave_height

        local ny = ay + BarSize + yIncrease - wave_height - h * 0.06
        ny = math.Clamp(ny, ay, ay + h)

        // Make it wavey
        Machine.Verts[4 + i] = {
            x = nx,
            y = ny,
        }
    end

    if size > 0.01 then
        local GlowPos = math.sin(wave_length + CurTime() * wave_speed)
        GlowPos = GlowPos * wave_height
        GlowPos = ay + BarSize + GlowPos - wave_height - h * 0.05
        GlowPos = math.Clamp(GlowPos, ay + w * 0.5, ay + h)

        surface.SetDrawColor(color)
        surface.SetMaterial(zclib.Materials.Get("liquid_glow_top"))
        surface.DrawTexturedRectRotated(ax + w / 2, GlowPos, w * 0.9, w * 0.8,180)
    end

    surface.SetDrawColor( color )
    draw.NoTexture()
    surface.DrawPoly( Machine.Verts )

    // Colors the metal overlay depending on the baked / dynamic light
    local light = (render.ComputeDynamicLighting(Machine:GetPos(), Machine:GetUp()) + render.ComputeLighting(Machine:GetPos(), Machine:GetUp())) / 2 + Vector(0.25,0.25,0.25)
    surface.SetDrawColor(Color(cWhite.r * light.x, cWhite.g * light.y, cWhite.b * light.z))
    surface.SetMaterial(zclib.Materials.Get("tank_overlay"))
    surface.DrawTexturedRectRotated(ax + w / 2, ay + h / 2, w, h, 180)
end

function zmlab2.Interface.DrawScalar(Machine,Pos,Ang,Active)
    cam.Start3D2D(Machine:LocalToWorld(Pos), Machine:LocalToWorldAngles(Ang), 1)
        local target = 52
        if Active then target = 180 + 10 * math.sin(CurTime() * 15) end
        Machine.PointerSmooth = Lerp(5 * FrameTime(),Machine.PointerSmooth or 0,target)

        surface.SetDrawColor( color_white )
        surface.SetMaterial(zclib.Materials.Get("air_pressure_pointer"))
        surface.DrawTexturedRectRotated(0, 0, 4, 4,  -Machine.PointerSmooth )

        surface.SetDrawColor(zclib.colors["black_a200"])
        surface.SetMaterial(zclib.Materials.Get("radial_invert_glow"))
        surface.DrawTexturedRectRotated(0, 0, 5 , 5 , 0)
    cam.End3D2D()
end


local maxrange = 0
local s_ang = Angle(0, 0, 0)
function zmlab2.Interface.GetCursorPos(origin,angle)

    local normal = angle:Up()

    local p = util.IntersectRayWithPlane(LocalPlayer():EyePos(), LocalPlayer():GetAimVector(), origin, normal)

    // if there wasn't an intersection, don't calculate anything.
    if not p then return end

    // If we are too close then stop
    local hPos = WorldToLocal(LocalPlayer():GetShootPos(), s_ang, origin, angle)

    if hPos.z < 0 then
        return
    end

    if maxrange > 0 and p:Distance(LocalPlayer():EyePos()) > maxrange then return end

    local pos = WorldToLocal(p, s_ang, origin, angle)
    local _x = (pos.x or 0) / (0.05 or 1)
    local _y = (pos.y or 0) / (0.05 or 1)

    return _x, -_y
end

function zmlab2.Interface.Draw(Machine,data)
    local _state = Machine:GetProcessState()
    cam.Start3D2D(Machine:LocalToWorld(data.pos), Machine:LocalToWorldAngles(data.ang), 0.05)

        if Machine.GetErrorStart == nil or Machine:GetErrorStart() < 0 then
            surface.SetDrawColor( data.OverwriteColor or zmlab2.colors["blue02"] )
            surface.SetMaterial(zclib.Materials.Get("item_bg"))
            surface.DrawTexturedRectRotated(data.x, data.y, data.w, data.h, 0 )

            if data.pages[_state] then
                data.pages[_state](Machine)
            else

                local rot = CurTime() * -700
                rot = zclib.util.SnapValue(36, rot)

                // If no ui data is specified for the current state then just display the loading symbol
                surface.SetDrawColor( color_white )
                surface.SetMaterial(zclib.Materials.Get("icon_loading"))
                surface.DrawTexturedRectRotated(0,0, 160, 160, rot )
            end
        else
            surface.SetDrawColor( zmlab2.colors["red02"] )
            surface.SetMaterial(zclib.Materials.Get("item_bg"))
            surface.DrawTexturedRectRotated(data.x, data.y, data.w, data.h, 0 )

            local error_width = data.w * 0.5
            local error_height = math.Clamp(data.h * 0.3,80,150)
            //zmlab2.Interface.DrawButton(0, 0,error_width, error_height, zmlab2.language["ERROR"], Machine:OnErrorButton(LocalPlayer()))

            if Machine:OnErrorButton(LocalPlayer()) then
                surface.SetDrawColor(color_white)
                surface.SetMaterial(zclib.Materials.Get("icon_E"))
                surface.DrawTexturedRectRotated(0, 0, error_width, error_width, 0)

                local hover_size = error_width * 0.9
                draw.RoundedBox(10, -hover_size / 2, -hover_size / 2, hover_size, hover_size, zmlab2.colors["white02"])

                Machine.Pulse = (Machine.Pulse or 0) + (1 * FrameTime())
                if Machine.Pulse > 1 then Machine.Pulse = 0 end


                local mul = 1 + math.abs(0.7 * Machine.Pulse)
                surface.SetDrawColor(Color(255, 255, 255, 200 - 200 * Machine.Pulse))
                surface.SetMaterial(zclib.Materials.Get("icon_box01"))
                surface.DrawTexturedRectRotated(0, 0, error_width * mul, error_width * mul, 0)
            else
                surface.SetDrawColor(color_white)
                surface.SetMaterial(zclib.Materials.Get("icon_error"))
                surface.DrawTexturedRectRotated(0, 0, error_width, error_width, 0)
            end


            draw.SimpleText(zmlab2.language["ERROR"], zclib.GetFont("zmlab2_font02"), 0, -80, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            local barMax = data.w * 0.9
            local barSize = math.Clamp((barMax / zmlab2.config.MiniGame.RespondTime) * (CurTime() - Machine:GetErrorStart()),0,barMax)
            draw.RoundedBox(0, data.w * 0.05 - (data.w / 2), error_height * 0.8, barMax - barSize, 20, color_white)
        end

        // Draws the cursor if its inside the screen
        local cx,cy = zmlab2.Interface.GetCursorPos(Machine:LocalToWorld(data.pos), Machine:LocalToWorldAngles(data.ang))
        if cx and cy and math.abs(cx) < (data.w / 2) and math.abs(cy) < (data.h / 2)  then
            draw.RoundedBox(4, cx - 4, cy - 4, 8, 8, color_white)
        end

        surface.SetDrawColor(zclib.colors["black_a100"])
        surface.SetMaterial(zclib.Materials.Get("scanlines"))
        surface.DrawTexturedRectRotated(data.x, data.y, data.w, data.h, 0)

    cam.End3D2D()

    data.OverwriteColor = nil
end
