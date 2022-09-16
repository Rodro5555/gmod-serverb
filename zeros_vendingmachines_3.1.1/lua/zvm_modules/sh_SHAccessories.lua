/////////////////////////
//SHAccessories

hook.Add("zvm_AddItemBlock", "zvm_AddItemBlock_SHAccessories", function(ply, Machine, ItemData,ItemID)

    // Some items can only be bought one time
    local c_ProductAmount = (Machine.BuyList[ItemID] or 0)
    if ItemData.class == "sh_accessory" and c_ProductAmount == 1 then
        zvm.Warning(ply,zvm.language.General["BuyLimitReached"])
        return true
    end
end)

if CLIENT then return end
zvm = zvm or {}
zvm.SHAccessories = zvm.SHAccessories or {}

zclib.Hook.Add("PlayerSay", "zvm_PlayerSay_shaccessories", function(ply, text)

    // Adds SH Accessories Item to Vendingmachine
    if string.sub(string.lower(text), 1, 23) == "!zvm_shaccessories_add_" then
        local text_tbl = string.Split( text, "_" )
        local itemid = text_tbl[4]

        zvm.SHAccessories.AddItem(ply,itemid)
    end
end)

function zvm.SHAccessories.AddItem(ply, hatid)

    if zclib.Player.IsAdmin(ply) == false then
        zclib.Notify(ply, "You do not have permission to perform this action, please contact an admin.", 1)
        return
    end

    local tr = ply:GetEyeTrace()

    if tr.Hit and IsValid(tr.Entity) and tr.Entity:GetClass() == "zvm_machine" then

        local Machine = tr.Entity

        if Machine:GetPublicMachine() == false then return end
        if zvm.Machine.ReachedItemLimit(Machine) then return end
        if Machine:GetAllowCollisionInput() == false then return end

        local acc = SH_ACC:GetAccessory(hatid)
        table.insert(Machine.Products,{
            class = "sh_accessory",
            name = acc.name,
            price = 500,
            model = acc.mdl,
            extraData = {itemid = acc.id},
            entData = {},
            amount = 1,
        })

        // Updates the machine interface for the user which is editing it
        zvm.Machine.UpdateMachineData(Machine,ply)
    end
end

function zvm.SHAccessories.GiveItem(ply, hatid)

    if not IsValid(ply) then return end

    local acc = SH_ACC:GetAccessory(hatid)

    if not acc then
        return
    end

    if ply:SH_HasAccessory(hatid) then
        print("Zeros Vendingmachine Package: " .. ply:Nick() .. " <" .. ply:SteamID() .. "> already has '" .. hatid .. "' accessory!")
        return
    end

    if ply:SH_AddAccessory(hatid) then
        print("Zeros Vendingmachine Package: " .. "Successfully given " .. ply:Nick() .. " <" .. ply:SteamID() .. "> the '" .. hatid .. "' accessory!")
    else
        print("Zeros Vendingmachine Package: " .. "Failed to give " .. ply:Nick() .. " <" .. ply:SteamID() .. "> the '" .. hatid .. "' accessory!")
    end
end


hook.Add("zvm_Overwrite_ItemUnpack","zvm_Overwrite_ItemUnpack_SHAccessories",function(ply,crate,ItemData)
    if ItemData.class == "sh_accessory" then
        if IsValid(ply) then
            zvm.SHAccessories.GiveItem(ply, ItemData.extraData.itemid)
        end
        return true
    end
end)
