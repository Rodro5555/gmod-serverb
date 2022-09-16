zfs = zfs or {}
zfs.Topping = zfs.Topping or {}

function zfs.Topping.GetData(id)
    return zfs.config.Toppings[id]
end

function zfs.Topping.IsValid(id)
    return zfs.Topping.GetData(id) ~= nil
end

function zfs.Topping.CanAdd(id, ply)
    local dat = zfs.Topping.GetData(id)
    local ranks = dat.Ranks_create

    if ranks and table.Count(ranks) > 0 and zclib.Player.RankCheck(ply, ranks) == false then
        zclib.Notify(ply, zclib.table.ToString(ranks), 3)
        zclib.Notify(ply, zfs.language.Shop.SelectTopping_WrongUlx02, 1)

        return false
    else
        return true
    end
end

function zfs.Topping.CanConsum(id, ply)
    local dat = zfs.Topping.GetData(id)

    // Does the player have the right Ulx Group to Consume the topping of this Item?
    local Ranks_consume = dat.Ranks_consume
    if table.Count(Ranks_consume) > 0 then
        local permission = zclib.Player.RankCheck(ply,Ranks_consume)
        if permission == false then
            zclib.Notify(ply, zfs.language.Shop.Item_WrongUlx01 .. zclib.table.ToString(Ranks_consume), 3)
            zclib.Notify(ply, zfs.language.Shop.Item_WrongUlx02, 1)
            return false
        end
    end

    // Does the player have the right Job to Consume the topping of this Item?
    local Job_consume = dat.Job_consume
    if table.Count(Job_consume) > 0 then
        local JobPermission = Job_consume[zclib.Player.GetJobName(ply)]
        if (JobPermission == false or JobPermission == nil) then
            zclib.Notify(ply, zfs.language.Shop.Item_WrongJob01 .. zclib.table.ToString(Job_consume), 3)
            zclib.Notify(ply, zfs.language.Shop.Item_WrongJob02, 1)
            return false
        end
    end
    return true
end
