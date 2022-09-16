if not CLIENT then return end
zmlab2 = zmlab2 or {}
zmlab2.TentDoor = zmlab2.TentDoor or {}

function zmlab2.TentDoor.Initialize(TentDoor)
    TentDoor.SmoothAnim = 0
end

function zmlab2.TentDoor.Draw(TentDoor)

    if TentDoor:GetIsPublic() == false and zclib.util.InDistance(TentDoor:GetPos(), LocalPlayer():GetPos(), 1000) and TentDoor.SmoothAnim < 1 then
        zmlab2.TentDoor.DrawIndicator(TentDoor, Vector(-2, 0, 30), Angle(0, -90, 90), TentDoor:GetIsLocked())
        zmlab2.TentDoor.DrawIndicator(TentDoor, Vector(2, 0, 30), Angle(0, 90, 90), TentDoor:GetIsLocked())
    end
end

function zmlab2.TentDoor.DrawIndicator(TentDoor, pos, ang, state)
    cam.Start3D2D(TentDoor:LocalToWorld(pos), TentDoor:LocalToWorldAngles(ang), 0.1)

        local NextInteraction = TentDoor:GetNextInteraction()

        if NextInteraction > CurTime() then

            local wipe = math.Clamp((1 / 10) * (NextInteraction - CurTime()), 0, 1)

            surface.SetDrawColor(zclib.colors["black_a100"])
            surface.SetMaterial(zclib.Materials.Get("icon_locked"))
            surface.DrawTexturedRectRotated(0, 0, 200, 200, 0)

            surface.SetDrawColor(color_white)
            surface.SetMaterial(zclib.Materials.Get("icon_locked"))
        	// Draws right half of the texture
        	// Note that we also change the width of the rectangle to avoid stetcing of the texture
        	// This is for demonstration purposes, you can do whatever it is you need
        	surface.DrawTexturedRectUV( -100, -100, 200, 200 * wipe, 0, 0, 1,wipe )
        else

            if TentDoor:OnLockButton(LocalPlayer()) then
                surface.SetDrawColor(zmlab2.colors["orange01"])
                surface.SetMaterial(zclib.Materials.Get("icon_locked_outline"))
                surface.DrawTexturedRectRotated(0, 0, 200, 200, 0)
            end

            if state then
                surface.SetDrawColor(color_white)
                surface.SetMaterial(zclib.Materials.Get("icon_locked"))
                surface.DrawTexturedRectRotated(0, 0, 200, 200, 0)
            else
                surface.SetDrawColor(zclib.colors["black_a100"])
                surface.SetMaterial(zclib.Materials.Get("icon_locked"))
                surface.DrawTexturedRectRotated(0, 0, 200, 200, 0)
            end
        end

    cam.End3D2D()
end

function zmlab2.TentDoor.Think(TentDoor)
    if TentDoor:GetIsLocked() then
        TentDoor.SmoothAnim = Lerp(15 * FrameTime(), TentDoor.SmoothAnim, 0)
    else
        if zclib.util.InDistance(TentDoor:GetPos(), LocalPlayer():GetPos(), 75) then
            TentDoor.SmoothAnim = Lerp(5 * FrameTime(), TentDoor.SmoothAnim, 1)
        else
            TentDoor.SmoothAnim = Lerp(5 * FrameTime(), TentDoor.SmoothAnim, 0)
        end
    end

    TentDoor:SetPoseParameter("zmlab2_doormover", TentDoor.SmoothAnim)
    TentDoor:InvalidateBoneCache()
end
