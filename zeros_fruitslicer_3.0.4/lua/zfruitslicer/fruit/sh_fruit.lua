zfs = zfs or {}
zfs.Fruit = zfs.Fruit or {}

function zfs.Fruit.GetData(id)
    return zfs.config.Fruits[id]
end

function zfs.Fruit.GetIcon(id)
    local dat = zfs.Fruit.GetData(id)
    return dat.Icon
end

function zfs.Fruit.GetHealth(id)
    local dat = zfs.Fruit.GetData(id)
    return dat.Health or 0
end

function zfs.Fruit.GetSlicedBG(id)
    local dat = zfs.Fruit.GetData(id)
    return dat.SlicedBG or 0
end
