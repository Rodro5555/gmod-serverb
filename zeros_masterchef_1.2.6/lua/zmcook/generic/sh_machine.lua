zmc = zmc or {}
zmc.Machine = zmc.Machine or {}

function zmc.Machine.InProgress(Machine)
    if Machine.GetProgress and Machine:GetProgress() > -1 then return true end
    if Machine.GetCookStart and Machine:GetCookStart() > 0 then return true end
    return false
end

// Checks if the set temperatur is in the needed range of the item
function zmc.Machine.TemperaturCheck(itm_comp, temp)
    if itm_comp.temp and itm_comp.temp.start and itm_comp.temp.range and temp >= itm_comp.temp.start and temp <= (itm_comp.temp.start + itm_comp.temp.range) then
        return true
    else
        return false
    end
end
