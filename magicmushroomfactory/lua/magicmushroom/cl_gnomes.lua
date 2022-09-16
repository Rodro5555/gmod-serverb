local function CreateGnome()
    local special = math.random() > .9
    local walking = math.random() > .5

    local plypos = LocalPlayer():GetPos()
    local pos = Vector(plypos.x + math.random(-600, 600), plypos.y + math.random(-600, 600), plypos.z)

    local tr = util.TraceLine({
        start = pos + Vector(0, 0, 1) * 1000,
        endpos = pos + Vector(0, 0, -1) * 1000
    })

    if tr and tr.Hit then
        pos.z = tr.HitPos.z
    end

    local gnome = ClientsideModel("models/dom/magicmushroomfactory/gnome.mdl")
    gnome:UseClientSideAnimation()
    gnome:SetPos(pos)
    gnome:SetRenderMode(RENDERMODE_TRANSALPHA)
    gnome.AutomaticFrameAdvance = true

    if walking then
        local angle = Angle(0, math.random(-180, 180), 0)
        gnome:SetAngles(angle)
        MMF.RunSequence(gnome, "Walk")
    end

    local start = CurTime()
    local duration = math.random(1, 5)

    SafeRemoveEntityDelayed(gnome, duration)

    hook.Add("Think", gnome, function()
        if walking then
            pos = pos - gnome:GetRight() * .5
            gnome:SetPos(pos)
        else
            local angle = (LocalPlayer():GetPos() - pos):Angle()
            angle = angle + Angle(0, 1, 0) * -100
            gnome:SetAngles(angle)
        end

        local color = special and HSVToColor(RealTime() % 6 * 60, 1, 1) or gnome:GetColor()

        local alphatime = start + duration - 1
        if alphatime < CurTime() then
            color.a = math.max((1 - (CurTime() - alphatime)) * 255, 0)
        end

        gnome:SetColor(color)
        gnome:FrameAdvance(1)
    end)
end

function MMF.StartGnomeEffect()
    timer.Create("MMF_SeeGnomes", 2, 10, function()
        if math.random() > 0.5 then
            CreateGnome()
        end
    end)
end