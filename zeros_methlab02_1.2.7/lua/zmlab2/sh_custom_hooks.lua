// Called when the player creates the Final Meth by Pressing E on the frezzing Tray
hook.Add("zmlab2_OnMethMade", "zmlab2_OnMethMade_test", function(ply, frezzingTray, methEnt,mType,mAmount,mQuality)
    if not IsValid(ply) then return end

    /*
        methEnt can either be a meth bag or a meth crate, depending if the frezzer tray is put on a packing table or not
    */
end)

// Called before the player receives his earning
// Can be used to modify the money earned from selling meth
hook.Add("zmlab2_PreMethSell","zmlab2_PreSell_test",function(ply,earning)

    /*
        if ply:IsSuperAdmin() then
            earning = earning * 2
        end
    */

    return earning
end)

// Gets called after meth got sold
hook.Add("zmlab2_PostMethSell","zmlab2_PostMethSell_test",function(ply,earning,methlist)


end)

// Gets called when a Player destorys Methbag, Methcrate or Palette with Meth
hook.Add("zmlab2_OnMethObjectDestroyed", "zmlab2_OnMethObjectDestroyed_test", function(methObject,damageinfo)

    if IsValid(methObject) then
        local ply = damageinfo:GetAttacker()

        local Earning = 0
        if methObject:GetClass() == "zmlab2_item_palette" then
            for k,v in pairs(methObject.MethList) do
                Earning = Earning + zmlab2.Meth.GetValue(v.t,v.a,v.q)
            end
        else
            Earning = zmlab2.Meth.GetValue(methObject:GetMethType(),methObject:GetMethAmount(),methObject:GetMethQuality())
        end
        if Earning <= 0 then return end

        if methObject.GetMethType then
            zclib.NetEvent.Create("meth_explo", { [1] = methObject:GetPos(), [2] = methObject:GetMethType()})
        else
            zclib.NetEvent.Create("meth_explo", { [1] = methObject:GetPos(), [2] = 1})
        end

        // If the attacker is a player with a police job then we reward that player
        if IsValid(ply) and ply:IsPlayer() and ply:Alive() and zmlab2.config.Police.Jobs[zclib.Player.GetJob(ply)] then

            // Add Rank multiplicator
            Earning = Earning * ( zmlab2.config.NPC.SellRanks[zclib.Player.GetRank(ply)] or zmlab2.config.NPC.SellRanks["default"])

            // Multiply by police cut
            Earning = Earning * zmlab2.config.Police.PoliceCut

            zclib.Money.Give(ply, Earning)
            zclib.Notify(ply, "+" .. zclib.Money.Display(math.Round(Earning)), 0)
        end
    end
end)

// Called when a player gets wanted for either selling meth or lockpicking a tentdoor
// Return true to prevent the player getting wanted
hook.Add("zmlab2_OnWanted", "zmlab2_OnWanted_test", function(ply,reason)

	// Police players will never get wanted
    if IsValid(ply) and zmlab2.config.Police.Jobs[ply:Team()] then
        return true
    end
end)

// Here you can return which sellmode this player should have for selling meth
// Return 1,2, 3, 4 or return nothing if you want to use the default sellmode defind in the config
hook.Add("zmlab2_GetSellMode", "zmlab2_GetSellMode_test", function(ply)

    // 1 = Methcrates can be absorbed by Players and sold by the MethBuyer on use
    // 2 = Methcrates cant be absorbed and the MethBuyer tells you a dropoff point instead (Palette Entity gets used here for easier transport)
    // 3 = Methcrates can be absorbed and the MethBuyer tells you a dropoff point
    // 4 = Methcrates need to be moved to the MethBuyer and sold directly by him

    if IsValid(ply) and ply:IsSuperAdmin() then
        //return 3
    end
end)

// Gets called when a dropoff point gets assinged to a player
hook.Add("zmlab2_OnDropOffPoint_Assigned", "zmlab2_OnDropOffPoint_Assigned_test", function(dropoffpoint,ply)
    /*
    if IsValid(dropoffpoint) and IsValid(ply) then
        print("Player: " .. ply:Nick() .. " just got assigned DropOffPoint: " .. tostring(dropoffpoint) .. ".")
    end
    */
end)

// Called when a player consums meth
hook.Add("zmlab2_OnMethConsum", "zmlab2_OnMethConsum_test", function(ply, MethType,MethQuality)
    if not IsValid(ply) then return end
end)

// Can be used to overwrite the limit for a specific item which the player trys to buy from the storage entity
hook.Add("zmlab2_Storage_GetItemLimit", "zmlab2_Storage_GetItemLimit_test", function(ply,ItemID)

    /*
    // Superadmins can buy double as much
    if IsValid(ply) and ply:IsSuperAdmin() then
        return zmlab2.config.Storage.Shop[ItemID].limit * 2
    end
    */
end)

// Can be used to overwrite the limit for a specific item which the player trys to buy / build from the Equipmentbox entity
hook.Add("zmlab2_Equipment_GetItemLimit", "zmlab2_Equipment_GetItemLimit_test", function(ply,ItemID)

    /*
    // Superadmins can buy double as much
    if IsValid(ply) and ply:IsSuperAdmin() then
        return zmlab2.config.Equipment.List[ItemID].limit * 2
    end
    */

    if IsValid(ply) and ply:IsSuperAdmin() then
        return zmlab2.config.Equipment.List[ItemID].limit * 5
    end
end)
