SP = SP or {}
SPZones = SPZones or {}
SPZone = SPZone or {}

surface.CreateFont("SPZonesFont", {
    font = "Trebuchet24",
    size = 200,
    weight = 500,
    antialias = true,
})

net.Receive("SPZones.SendSettings", function()
    local SettingVals = net.ReadTable()

    for k, v in pairs(SettingVals) do
        SP["SPZones"]["settings"][k].Value = v.Value

        if k == "Punishment" then
            SP["SPZones"]["settings"][k].Options = v.Options
        end
    end

    SPZones.Restricted = net.ReadTable()
end)

net.Receive("SPZones.SendRestricted", function()
    SPZones.Restricted = net.ReadTable()
end)

net.Receive("SPZones.SPZone", function(len, ply)
    local pos = net.ReadVector()
    local time = CurTime() + SP["SPZones"]["settings"]["ZoneTime"].Value

    table.insert(SPZone, {
        pos = pos,
        time = time,
    })
end)

net.Receive("SPZones.ZonesUpdate", function(len, ply)
    local pos = net.ReadVector()

    for k, v in pairs(SPZone) do
        if pos == v.pos then
            table.remove(SPZone, k)
        end
    end
end)

net.Receive("SPZones.ZonesRemove", function(len, ply)
    SPZone = {}
end)

net.Receive("SPZones.AdminMessages", function(len, ply)
    local PlyInfo = net.ReadString()

    if SP["SPZones"]["settings"]["MsgAdmins"].Value == 2 then
        chat.AddText(Color(255, 0, 0), "[SPZones] ", Color(255, 255, 255), PlyInfo .. " Just broke NLR!")
    elseif SP["SPZones"]["settings"]["MsgAdmins"].Value == 3 then
        MsgC(Color(255, 0, 0), "[SPZones] ", Color(255, 255, 255), PlyInfo .. " Just broke NLR!\n")
    end
end)

net.Receive("SPZones.PunishmentDelay", function(len, ply)
    SPZones.PunishmentTime = CurTime()
end)

net.Receive("SPZones.NlrCheckData", function(len, ply)
    SPZones.CheckNLR = net.ReadTable()
    chat.AddText(Color(255, 0, 0), "[SPZones] ", Color(255, 255, 255), " Write !clearcheck to remove the point(s)!")
end)

net.Receive("SPZones.NlrCheckClear", function(len, ply)
    SPZones.CheckNLR = {}
    chat.AddText(Color(255, 0, 0), "[SPZones] ", Color(255, 255, 255), " Removed all the point(s)!")
end)

local ThinkWait = 0

function SPZones.Think()
    if ThinkWait > CurTime() then return end
    ThinkWait = SP["SPZones"]["settings"]["ClientDelay"].Value + CurTime()

    if #SPZone == 0 then
        LocalPlayer().InsideNLR = false
        LocalPlayer().InsideNLRWarn = false
    end

    local ClosestDist = math.huge
    local ClosestZone = nil

    for k, v in pairs(SPZone) do
        local Dist = LocalPlayer():GetPos():DistToSqr(v.pos)

        if Dist < ClosestDist ^ 2 then
            ClosestDist = Dist
            ClosestZone = v
            ClosestZone.n = k
        end
    end

    for k, v in pairs(SPZone) do
        if v.time - CurTime() <= 0 then
            if k == ClosestZone.n then
                -- Remove notifications when zone is removed
                notification.Kill("InsideWarn")
                notification.Kill("InsideNLR")
            end

            table.remove(SPZone, k)
        end
    end

    if ClosestZone == nil then return end
    local Dist = LocalPlayer():GetPos():DistToSqr(ClosestZone.pos)

    if Dist < SP["SPZones"]["settings"]["ZoneRadius"].Value ^ 2 then
        if LocalPlayer().InsideNLR then return end -- Makes everything after this only be run once everytime a zone is entered

        if SP["SPZones"]["settings"]["Punishment"].Value == 1 and SP["SPZones"]["settings"]["PunishmentDelay"].Value == 0 and SP["SPZones"]["settings"]["WarnDisplay"].Value == 3 then
            notification.AddProgress("InsideNLR", SPZones.GhostText)
        end

        -- Remove notifcation if inside zone
        notification.Kill("InsideWarn")
        LocalPlayer().InsideNLR = true
    else
        if SP["SPZones"]["settings"]["EnterWarn"].Value == 2 and Dist < (SP["SPZones"]["settings"]["ZoneRadius"].Value + SP["SPZones"]["settings"]["EnterWarnDist"].Value) ^ 2 then
            LocalPlayer().WarnTime = ClosestZone.time

            if SP["SPZones"]["settings"]["WarnDisplay"].Value == 3 then
                notification.AddProgress("InsideWarn", SPZones.WarnText .. " " .. string.ToMinutesSeconds(math.ceil(LocalPlayer().WarnTime - CurTime())) .. SPZones.WarnTimeText)
            end

            if not LocalPlayer().InsideNLRWarn then
                LocalPlayer().InsideNLRWarn = true
            end
        else
            if LocalPlayer().InsideNLRWarn then
                -- Remove notifcation if outside distance of zone
                notification.Kill("InsideWarn")
                LocalPlayer().InsideNLRWarn = false
            end
        end

        if not LocalPlayer().InsideNLR then return end
        notification.Kill("InsideNLR")
        LocalPlayer().InsideNLR = false
    end
end

hook.Add("PlayerPostThink", "SPZones.Think", SPZones.Think)
local uiForeground, uiBackground = Color(240, 240, 255, 255), Color(20, 20, 20, 120)

function DrawZoneWarn()
    if not LocalPlayer():IsValid() or not LocalPlayer():Alive() then return end

    if SPZones.CheckNLR and #SPZones.CheckNLR > 0 then
        for k, v in pairs(SPZones.CheckNLR) do
            pos = v.pos:ToScreen()
            local sptext1 = "" .. v.victim:Nick() .. " got killed by a non player"

            if IsValid(v.killer) and v.killer:IsPlayer() then
                sptext1 = "" .. v.victim:Nick() .. " got killed by " .. v.killer:Nick()
            end

            local sptext2 = "Died here: " .. string.ToMinutesSeconds(math.Round(CurTime() - v.time)) .. " minutes ago"
            local sptext3 = v.job
            surface.SetFont("DermaLarge")
            local TextWidth1 = surface.GetTextSize(tostring(sptext1))
            local TextWidth2 = surface.GetTextSize(sptext2)
            local TextWidth3 = surface.GetTextSize(sptext3)
            draw.RoundedBox(2, pos.x - 6, pos.y - 6, 12, 12, v.color)
            draw.WordBox(2, pos.x - TextWidth1 / 4, pos.y - 66, sptext1, "UiBold", uiBackground, uiForeground)
            draw.WordBox(2, pos.x - TextWidth2 / 4, pos.y - 46, sptext2, "UiBold", uiBackground, uiForeground)
            draw.WordBox(2, pos.x - TextWidth3 / 4, pos.y - 26, sptext3, "UiBold", uiBackground, uiForeground)
        end
    end

    if SP["SPZones"]["settings"]["WarnDisplay"].Value == 2 then
        surface.SetFont("DermaLarge")
        local GhostWidth = select(1, surface.GetTextSize(SPZones.GhostText)) + 50
        local GhostHeight = select(2, surface.GetTextSize(SPZones.GhostText)) + 25
        local WarnWidth = select(1, surface.GetTextSize(SPZones.WarnText)) + 50
        local WarnHeight = select(2, surface.GetTextSize(SPZones.WarnText)) * 2 + 50

        if LocalPlayer().InsideNLR then
            if SP["SPZones"]["settings"]["PunishmentDelay"].Value ~= 0 and SPZones.PunishmentTime ~= nil and (SPZones.PunishmentTime + SP["SPZones"]["settings"]["PunishmentDelay"].Value) - CurTime() > -1 then
                local WarnDelay = SPZones.PunishmentTime + SP["SPZones"]["settings"]["PunishmentDelay"].Value

                if math.ceil(WarnDelay - CurTime()) > 0 then
                    draw.RoundedBox(5, ScrW() / 2 - WarnWidth / 2, ScrH() / 4 + 25 - WarnHeight / 2, WarnWidth, WarnHeight, Color(52, 73, 94, 200))
                    draw.RoundedBox(10, ScrW() / 2 - WarnWidth / 2 - 5 / 2, ScrH() / 4 + 25 - WarnHeight / 2 - 5 / 2, WarnWidth + 5, WarnHeight + 5, Color(44, 62, 80, 100))
                    draw.SimpleText(SPZones.WarnTextDelay, "DermaLarge", ScrW() / 2, ScrH() / 4, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    draw.SimpleText(math.ceil(WarnDelay - CurTime()) .. SPZones.WarnTimeTextDelay, "DermaLarge", ScrW() / 2, ScrH() / 4 + 50, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            end

            if string.lower(string.lower(SP["SPZones"]["settings"]["Punishment"].Options[SP["SPZones"]["settings"]["Punishment"].Value])) == "ghost" and SP["SPZones"]["settings"]["PunishmentDelay"].Value == 0 then
                draw.RoundedBox(5, ScrW() / 2 - GhostWidth / 2, ScrH() / 4 - GhostHeight / 2 + 25, GhostWidth, GhostHeight, Color(52, 73, 94, 200))
                draw.RoundedBox(10, ScrW() / 2 - GhostWidth / 2 - 5 / 2, ScrH() / 4 - GhostHeight / 2 - 5 / 2 + 25, GhostWidth + 5, GhostHeight + 5, Color(44, 62, 80, 100))
                draw.SimpleText(SPZones.GhostText, "DermaLarge", ScrW() / 2, ScrH() / 4 + 25, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        elseif LocalPlayer().InsideNLRWarn and SP["SPZones"]["settings"]["PunishmentDelay"].Value == 0 then
            draw.RoundedBox(5, ScrW() / 2 - WarnWidth / 2, ScrH() / 4 + 25 - WarnHeight / 2, WarnWidth, WarnHeight, Color(52, 73, 94, 200))
            draw.RoundedBox(10, ScrW() / 2 - WarnWidth / 2 - 5 / 2, ScrH() / 4 + 25 - WarnHeight / 2 - 5 / 2, WarnWidth + 5, WarnHeight + 5, Color(44, 62, 80, 100))
            draw.SimpleText(SPZones.WarnText, "DermaLarge", ScrW() / 2, ScrH() / 4, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(string.ToMinutesSeconds(math.ceil(LocalPlayer().WarnTime - CurTime())) .. SPZones.WarnTimeText, "DermaLarge", ScrW() / 2, ScrH() / 4 + 50, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        --96ca69bf88bf650d9d2191c7c4165b44d3ea4629292fbfa534b7b552eda1879a
    end
end

hook.Add("HUDPaint", "DrawZoneWarn", DrawZoneWarn)

function drawCircle(x, y, radius, seg)
    local cir = {}

    table.insert(cir, {
        x = x,
        y = y,
        u = 0.5,
        v = 0.5
    })

    for i = 0, seg do
        local a = math.rad((i / seg) * -360)

        table.insert(cir, {
            x = x + math.sin(a) * radius,
            y = y + math.cos(a) * radius,
            u = math.sin(a) / 2 + 0.5,
            v = math.cos(a) / 2 + 0.5
        })
    end

    local a = math.rad(0)

    --[[96ca69bf88bf650d9d2191c7c4165b44d3ea4629292fbfa534b7b552eda1879a]]
    table.insert(cir, {
        x = x + math.sin(a) * radius,
        y = y + math.cos(a) * radius,
        u = math.sin(a) / 2 + 0.5,
        v = math.cos(a) / 2 + 0.5
    })

    surface.DrawPoly(cir)
end

local function SPRenderZone()
    for k, v in pairs(SPZone) do
        if LocalPlayer():GetPos():DistToSqr(v.pos) < ((SP["SPZones"]["settings"]["FadeBeing"].Value + SP["SPZones"]["settings"]["ZoneRadius"].Value) + SP["SPZones"]["settings"]["FadeOut"].Value) ^ 2 then
            SPZones.FadeColor = Color(SP["SPZones"]["settings"]["ZoneColor"].Value.r, SP["SPZones"]["settings"]["ZoneColor"].Value.g, SP["SPZones"]["settings"]["ZoneColor"].Value.b, SP["SPZones"]["settings"]["ZoneColor"].Value.a)

            if LocalPlayer():GetPos():DistToSqr(v.pos) > (SP["SPZones"]["settings"]["FadeBeing"].Value + SP["SPZones"]["settings"]["ZoneRadius"].Value) ^ 2 then
                SPZones.FadeColor.a = (SP["SPZones"]["settings"]["ZoneColor"].Value.a - (LocalPlayer():GetPos():Distance(v.pos) - (SP["SPZones"]["settings"]["FadeBeing"].Value + SP["SPZones"]["settings"]["ZoneRadius"].Value)) / (SP["SPZones"]["settings"]["FadeOut"].Value / SP["SPZones"]["settings"]["ZoneColor"].Value.a))
            end

            if SP["SPZones"]["settings"]["WarnDisplay"].Value == 1 then
                local AngleY = math.rad((Vector(v.pos) - LocalPlayer():GetPos()):Angle().y + 90)
                local TextX = v.pos.x + (SP["SPZones"]["settings"]["ZoneRadius"].Value * math.sin(-AngleY))
                local TextY = v.pos.y + (SP["SPZones"]["settings"]["ZoneRadius"].Value * math.cos(-AngleY))
                local TextAngle = (Vector(v.pos) - LocalPlayer():GetPos()):Angle().y
                cam.Start3D2D(Vector(TextX, TextY, v.pos.z), Angle(0, TextAngle - 90, 90), 0.1)
                surface.SetFont("SPZonesFont")
                local Width, Height = surface.GetTextSize(SPZones.WarnText)
                surface.SetTextColor(255, 255, 255)
                surface.SetTextPos(0 - Width / 2, -Height - 620)
                surface.DrawText(SPZones.WarnText)
                local Text = string.ToMinutesSeconds(math.ceil(v.time - CurTime())) .. SPZones.WarnTimeText
                local _, HeightT = surface.GetTextSize(Text)
                surface.SetTextPos(0 - Width / 2, -HeightT - 480)
                surface.DrawText(Text)
                cam.End3D2D()
            end

            if SP["SPZones"]["settings"]["ZoneStyle"].Value == 1 then
                if SP["SPZones"]["settings"]["ZoneMaterial"].Value ~= 1 then
                    SPMaterial = Material(SP["SPZones"]["settings"]["ZoneMaterial"].Options[SP["SPZones"]["settings"]["ZoneMaterial"].Value])
                    render.SetMaterial(SPMaterial)
                else
                    render.SetColorMaterial()
                end

                render.UpdateScreenEffectTexture()
                render.CullMode(MATERIAL_CULLMODE_CW)

                if LocalPlayer().InsideNLR then
                    render.DrawSphere(v.pos, SP["SPZones"]["settings"]["ZoneRadius"].Value, 100, 100, SPZones.FadeColor)
                end

                render.CullMode(MATERIAL_CULLMODE_CCW)
                render.DrawSphere(v.pos, SP["SPZones"]["settings"]["ZoneRadius"].Value, 100, 100, SPZones.FadeColor)
            elseif SP["SPZones"]["settings"]["ZoneStyle"].Value == 2 then
                cam.Start3D2D(v.pos + Vector(0, 0, SP["SPZones"]["settings"]["FlatSphereHeight"].Value), Angle(0, 0, 0), 6)

                if SP["SPZones"]["settings"]["ZoneMaterial"].Value ~= 1 then
                    SPMaterial = Material(SP["SPZones"]["settings"]["ZoneMaterial"].Options[SP["SPZones"]["settings"]["ZoneMaterial"].Value])
                    render.SetMaterial(SPMaterial)
                else
                    draw.NoTexture()
                end

                surface.SetDrawColor(SPZones.FadeColor)
                drawCircle(0, 0, SP["SPZones"]["settings"]["ZoneRadius"].Value / 6, 80)
                cam.End3D2D()
            elseif SP["SPZones"]["settings"]["ZoneStyle"].Value == 3 then
                cam.Start3D2D(v.pos + Vector(0, 0, SP["SPZones"]["settings"]["DottedHeight"].Value), Angle(0, 0, 0), SP["SPZones"]["settings"]["DottedSquareSize"].Value)
                surface.SetDrawColor(SPZones.FadeColor)
                draw.NoTexture()
                surface.DrawCircle(0, 0, SP["SPZones"]["settings"]["ZoneRadius"].Value / SP["SPZones"]["settings"]["DottedSquareSize"].Value, SPZones.FadeColor)
                cam.End3D2D()
            end
        end
    end
end

hook.Add("PostDrawTranslucentRenderables", "SPRenderZone", SPRenderZone)