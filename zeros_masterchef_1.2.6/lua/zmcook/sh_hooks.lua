
/*

    Some custom hooks to run your code on certain events, if you need more open a ticket

*/


// Can be used to restrict which dish items the player can select in the dishtable
// Return false to block the player from cooking the specified DishID, return nothing otherwhise
hook.Add("zmc_CanCookDish","zmc_CanCookDish_test",function(ply,DishID)

    /*
    In this examble we restrict a dish depending by the players job
    local DishData = zmc.Dish.GetData(DishID)
    if ply:Team() == TEAM_FRENCHMAN and DishData and DishData.name and DishData.name == "Baguette" then
        return true
    else
        return false
    end
    */
end)

if SERVER then
    hook.Add("zmc_OnDishSold","zmc_OnDishSold_test",function(DishID,Ordertable,IsReadyToGoFood,Customertable)
        //local ply = zclib.Player.GetOwner(Ordertable)
    end)

    // Called once a player receives his food
    hook.Add("zmc_OnDishSoldToPlayer","zmc_OnDishSoldToPlayer_test",function(DishID,Ordertable,steamid64)

    end)

    hook.Add("zmc_OnDishMade","zmc_OnDishMade_test",function(Dishtable,DishID,DishEnt)
        //local ply = zclib.Player.GetOwner(Dishtable)
    end)

    // Can be used to modify the players item spawn limit
    hook.Add("zmc_GetItemLimit","zmc_GetItemLimit_test",function(ply)

    end)

    // Can be used to overwrite the item limit
    hook.Add("zmc_Buildkit_GetItemLimit","zmc_Buildkit_GetItemLimit_test",function(ply,ItemID)
        //if ply:IsSuperAdmin() then return 50 end
    end)
end
