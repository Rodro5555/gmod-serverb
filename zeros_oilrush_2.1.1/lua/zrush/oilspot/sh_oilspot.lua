zrush = zrush or {}
zrush.OilSpot = zrush.OilSpot or {}

function zrush.OilSpot.GetData(id)
    return zrush.Holes[id]
end

function zrush.OilSpot.GetRandom()
    // Get DrillHole Information
    local OilHolePool = {}
    for k, v in pairs(zrush.Holes) do
        for i = 1, v.chance do
            table.insert(OilHolePool, k)
        end
    end

    return table.Random(OilHolePool)
end
