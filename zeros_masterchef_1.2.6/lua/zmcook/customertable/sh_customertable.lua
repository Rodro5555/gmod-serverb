zmc = zmc or {}
zmc.Customertable = zmc.Customertable or {}

if SERVER then
    util.AddNetworkString("zmc_Customertable_Sync")
    function zmc.Customertable.Synch(Customertable)
        zclib.Debug("zmc.Customertable.Synch")
        if not IsValid(Customertable) then return end
        local e_String = util.TableToJSON(Customertable.CustomerData)
        local e_Compressed = util.Compress(e_String)
        net.Start("zmc_Customertable_Sync")
        net.WriteUInt(#e_Compressed, 16)
        net.WriteData(e_Compressed, #e_Compressed)
        net.WriteEntity(Customertable)
        net.WriteUInt(Customertable:EntIndex(),16)
        net.Broadcast()
    end

    function zmc.Customertable.SynchForPlayer(Customertable,ply)
        zclib.Debug("zmc.Customertable.SynchForPlayer")
        if not IsValid(Customertable) then return end
        local e_String = util.TableToJSON(Customertable.CustomerData)
        local e_Compressed = util.Compress(e_String)
        net.Start("zmc_Customertable_Sync")
        net.WriteUInt(#e_Compressed, 16)
        net.WriteData(e_Compressed, #e_Compressed)
        net.WriteEntity(Customertable)
        net.WriteUInt(Customertable:EntIndex(),16)
        net.Send(ply)
    end
else

    zmc.CustomertableData = zmc.CustomertableData or {}

    net.Receive("zmc_Customertable_Sync", function(len)
        zclib.Debug_Net("zmc_Customertable_Sync", len)
        local dataLength = net.ReadUInt(16)
        local dataDecompressed = util.Decompress(net.ReadData(dataLength))
        local inv = util.JSONToTable(dataDecompressed)
        local Customertable = net.ReadEntity()
        local endIndex = net.ReadUInt(16)

        if inv then
            zmc.CustomertableData[endIndex] = table.Copy(inv)

            if IsValid(Customertable) then
                Customertable.CustomerData = table.Copy(inv)
            end
            Customertable.CustomerDataChanged = true
        end
    end)
end



/*

    The Table Config

*/
zmc.Table = zmc.Table or {}
zmc.config.Tables_ListID = zmc.config.Tables_ListID or {}
file.CreateDir( "zmc" )
timer.Simple(0,function()
    zclib.Data.Setup("zmc_table_config", "[Zero´s MasterCook]", "zmc/table_config.txt",function()
        return zmc.config.Tables
    end, function(data)
        -- OnLoaded
        zmc.config.Tables = table.Copy(data)
    end, function()
        -- OnSend
    end, function(data)
        -- OnReceived
        zmc.config.Tables = table.Copy(data)
    end, function(list)
        --OnIDListRebuild
        zmc.config.Tables_ListID = table.Copy(list)
    end)
end)

function zmc.Table.GetListID(UniqueID)
    return zmc.config.Tables_ListID[UniqueID]
end

function zmc.Table.GetData(UniqueID)
    if UniqueID == nil then return end

    // If its a list id then lets return its data
    if zmc.config.Tables[UniqueID] then return zmc.config.Tables[UniqueID] end

    // If its a uniqueid then lets get its list id and return the data
    local id = zmc.Table.GetListID(UniqueID)
    if UniqueID and id and zmc.config.Tables[id] then
        return zmc.config.Tables[id]
    end
end









/*

    The Seat Config

*/
zmc.Seat = zmc.Seat or {}
zmc.config.Seats_ListID = zmc.config.Seats_ListID or {}
file.CreateDir( "zmc" )
timer.Simple(0,function()
    zclib.Data.Setup("zmc_seat_config", "[Zero´s MasterCook]", "zmc/seat_config.txt",function()
        return zmc.config.Seats
    end, function(data)
        -- OnLoaded
        zmc.config.Seats = table.Copy(data)
    end, function()
        -- OnSend
    end, function(data)
        -- OnReceived
        zmc.config.Seats = table.Copy(data)
    end, function(list)
        --OnIDListRebuild
        zmc.config.Seats_ListID = table.Copy(list)
    end)
end)

function zmc.Seat.GetListID(UniqueID)
    return zmc.config.Seats_ListID[UniqueID]
end

function zmc.Seat.GetData(UniqueID)
    if UniqueID == nil then return end

    // If its a list id then lets return its data
    if zmc.config.Seats[UniqueID] then return zmc.config.Seats[UniqueID] end

    // If its a uniqueid then lets get its list id and return the data
    local id = zmc.Seat.GetListID(UniqueID)
    if UniqueID and id and zmc.config.Seats[id] then
        return zmc.config.Seats[id]
    end
end
