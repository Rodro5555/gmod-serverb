zrush = zrush or {}
zrush.Fuel = zrush.Fuel or {}

function zrush.Fuel.GetData(id)
    return zrush.FuelTypes[id]
end

function zrush.Fuel.GetName(id)
    local dat = zrush.Fuel.GetData(id)
    return dat.name
end

function zrush.Fuel.GetColor(id)
    local dat = zrush.Fuel.GetData(id)
    return dat.color
end

function zrush.Fuel.GetVCFuel(id)
    local dat = zrush.Fuel.GetData(id)
    return dat.vcmodfuel
end


function zrush.Fuel.GetDarkenColor(id)
    return zrush.darken_fuelcolors[id]
end

function zrush.Fuel.GetTransColor(id)
    return zrush.trans_fuelcolors[id]
end
