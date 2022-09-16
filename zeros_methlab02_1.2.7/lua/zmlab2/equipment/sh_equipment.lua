zmlab2 = zmlab2 or {}
zmlab2.Equipment = zmlab2.Equipment or {}

zmlab2.Equipment_Classes = {}
timer.Simple(2,function()
    for k,v in pairs(zmlab2.config.Equipment.List) do
        zmlab2.Equipment_Classes[v.class] = k
    end
end)


// Check if some player is in the way
function zmlab2.Equipment.AreaOccupied(pos,ignore)
    local IsOccupied = false
    for k,v in pairs(ents.FindInSphere(pos,15)) do
        if not IsValid(v) then continue end

        if ignore and v == ignore then continue end

        // We dont place a machine on top of another one
        if zmlab2.Equipment_Classes[v:GetClass()] then
            IsOccupied = true
            break
        end

        // Dont place a machine on a player
        if v:IsPlayer() then
            IsOccupied = true
            break
        end
    end
    return IsOccupied
end
