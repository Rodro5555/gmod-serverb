zvm = zvm or {}
zvm.Machine = zvm.Machine or {}

// Changeging this value wont do much good, since it wont resize the items currently, Its just here for refrence
function zvm.Machine.PageItemLimit()
    return 12
end

function zvm.Machine.ItemLimit()
    return zvm.config.Vendingmachine.ItemCapacity
end

function zvm.Machine.ProductCount(Machine)
    return table.Count(Machine.Products)
end

function zvm.Machine.ReachedItemLimit(Machine)
    return zvm.Machine.ProductCount(Machine) >= zvm.Machine.ItemLimit()
end


function zvm.Machine.HasRankRestriction(ItemData)
    if ItemData and ItemData.rankid and ItemData.rankid > 0 then
        return true
    else
        return false
    end
end

function zvm.Machine.HasJobRestriction(ItemData)
    if ItemData and ItemData.jobid and ItemData.jobid > 0 then
        return true
    else
        return false
    end
end

function zvm.Machine.RankCheck(ply, ItemData)
    local rankid = ItemData.rankid
    if rankid == nil then return true end
    local rankgp = zvm.config.Vendingmachine.RankGroups[rankid]
    if rankgp == nil then return true end
    if rankgp.ranks == nil then return true end

    local result = zclib.Player.RankCheck(ply, rankgp.ranks)
    if result == false then
        zvm.Warning(ply,zvm.language.General["InCorrectRank"])
        zvm.Warning(ply,zclib.table.ToString(rankgp.ranks))
    end
    return result
end

function zvm.Machine.JobCheck(ply, ItemData)
    local jobid = ItemData.jobid
    if jobid == nil then return true end
    local jobgp = zvm.config.Vendingmachine.JobGroups[team.GetName(jobid)]
    if jobgp == nil then return true end
    if jobgp.jobs == nil then return true end

    local result = jobgp.jobs[zclib.Player.GetJob(ply)] == true
    if result == false then
        zvm.Warning(ply,zvm.language.General["WrongJob"])
        local tbl = {}
        for k, v in pairs(jobgp.jobs) do table.insert(tbl,team.GetName(k)) end
        zvm.Warning(ply,table.concat(tbl, ", ", 1, #tbl))
    end
    return result
end

function zvm.Machine.SwitchProducts(Machine,ID01,ID02)
    // The data we wanna move
    local dat_a = table.Copy(Machine.Products[ID01])
    local dat_b = table.Copy(Machine.Products[ID02])

    // Do the switch
    Machine.Products[ID01] = dat_b
    Machine.Products[ID02] = dat_a
end
