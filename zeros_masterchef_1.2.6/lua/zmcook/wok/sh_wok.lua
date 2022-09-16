zmc = zmc or {}
zmc.Wok = zmc.Wok or {}

function zmc.Wok.GetTime()
    return CurTime()
end

function zmc.Wok.GetCycleTime()
    return 4
end

function zmc.Wok.GetRange(Wok)
    local ItemData = zmc.Item.GetData(Wok:GetItemID())
    if ItemData and ItemData.wok and ItemData.wok.range then
        return ItemData.wok.range
    else
        return 0.25
    end
end

function zmc.Wok.GetCooldown()
    return 0.25
end

function zmc.Wok.GetPointerPos(Wok)
    local time = zmc.Wok.GetTime() * zmc.Wok.GetCycleTime()
    local pos = math.sin(time)
    return pos
end

function zmc.Wok.PointerHit(Wok)
    local pos = zmc.Wok.GetPointerPos(Wok)
    if pos >= -zmc.Wok.GetRange(Wok) and pos <= zmc.Wok.GetRange(Wok) then
        return true
    else
        return false
    end
end
