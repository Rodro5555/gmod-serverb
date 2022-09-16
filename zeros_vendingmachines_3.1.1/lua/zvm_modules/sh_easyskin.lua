/////////////////////////
//EasySkins

hook.Add("zvm_Overwrite_ProductImage","zvm_Overwrite_ProductImage_Easyskin",function(pnl,ItemData)
    if ItemData.class == "easyskin" and ItemData.skinpath and CL_EASYSKINS and IsValid(pnl) then
        local image = CL_EASYSKINS.VMTToUnlitGeneric(ItemData.skinpath)
        if image then pnl:SetMaterial(image) end
        return true
    end
end)

local vscale = 0.08
local sm = (1 / 0.1) * vscale

hook.Add("zvm_Overwrite_IdleImage","zvm_Overwrite_IdleImage_Easyskin",function(pnl,ItemData)
    if ItemData.class == "easyskin" and ItemData.skinpath and CL_EASYSKINS and IsValid(pnl) then

        local image = CL_EASYSKINS.VMTToUnlitGeneric(ItemData.skinpath)
        if image then pnl:SetMaterial(image) end

        local BGLabel = vgui.Create("DPanel", pnl)
        BGLabel:SetPos(0, 200 / sm)
        BGLabel:SetSize(250 / sm, 50 / sm)
        BGLabel:SetAutoDelete(true)
        BGLabel.Paint = function(s, w, h)
            draw.RoundedBox(0, 0, 0, w, h, zvm.colors["black03"])
            draw.DrawText(zvm.language.General["Weapon Skin"], zclib.GetFont("zvm_interface_title_small"), w / 2, 10 / sm, color_white, TEXT_ALIGN_CENTER)
        end
        return true
    end
end)

hook.Add("zvm_AddItemBlock", "zvm_AddItemBlock_Easyskin", function(ply, Machine, ItemData,ItemID)

    // Some items can only be bought one time
    if ItemData.class == "easyskin" and SH_EASYSKINS then

        local c_ProductAmount = (Machine.BuyList[ItemID] or 0)
        if c_ProductAmount == 1 then
            zvm.Warning(ply,zvm.language.General["BuyLimitReached"])
            return true
        end

        // Special check to make sure we cant add any other Item to the BuyList if a EasySkin item exist
        local BuyListHasEasySkin = false
        if table.Count(Machine.BuyList) > 0 then
            for k, v in pairs(Machine.BuyList) do
                if Machine.Products[k].class == "easyskin" then
                    BuyListHasEasySkin = true
                    break
                end
            end
        end
        if BuyListHasEasySkin == true then
            notification.AddLegacy("When buying a Weapon skin your Buylist cant contain any other Items!", NOTIFY_ERROR, 4)
            CL_EASYSKINS.PlaySound("deny")
            return true
        end

        // Some items like easyskin needs a special check which makes sure we can buy the item
        if ItemData.class == "easyskin" and table.Count(Machine.BuyList) > 0 then
            notification.AddLegacy( "You need to make sure your Buylist is empty before buying a skin!", NOTIFY_ERROR, 3 )
            CL_EASYSKINS.PlaySound("deny")
            return true
        end

        // Easy skin checks if the active weapon of the player supports the skin he wants to buy
        local skin = SH_EASYSKINS.GetSkin(ItemData.model)
        if not IsValid(ply:GetActiveWeapon()) or table.HasValue(skin.weaponTbl, ply:GetActiveWeapon():GetClass()) == false then
            notification.AddLegacy(table.concat(skin.weaponTbl, ",", 1, #skin.weaponTbl), NOTIFY_HINT, 3)
            notification.AddLegacy("Your active weapon cant be used for this skin!", NOTIFY_ERROR, 3)
            CL_EASYSKINS.PlaySound("deny")

            return true
        end

        // Can the player even buy this skin?
        local _weaponclass = ply:GetActiveWeapon():GetClass()
        local _canbuy,_reason = SH_EASYSKINS.CanBuySkin(ply,ItemData.model,_weaponclass)
        if _canbuy == false then
            notification.AddLegacy(_reason, NOTIFY_ERROR, 3)
            CL_EASYSKINS.PlaySound("deny")
            return true
        end
    end
end)

// Called when the player got data from a machine send
hook.Add("zvm_OnMachineDataUpdated","zvm_OnMachineDataUpdated_Easyskin",function(Machine)
    for k,v in pairs(Machine.Products) do
        if v.class == "easyskin" and SH_EASYSKINS then
            local skin = SH_EASYSKINS.GetSkin(v.model)
			if skin then
	            v.price = SH_EASYSKINS.GetRealPrice(LocalPlayer(),skin)
	            v.skinpath =  skin.material.path
			end
        end
    end
end)

hook.Add("zvm_ModifyProductDataOnPurchase","zvm_ModifyProductDataOnPurchase_Easyskin",function(ply,ProductData)
    // Lets add the active weapon which the player is holding
    if ProductData.class == "easyskin" then
        local swep = ply:GetActiveWeapon()
        if IsValid(swep) then
            ProductData.extraData.weaponclass = swep:GetClass()
            return ProductData
        end
    end
end)

local function HasEasySkinSelected(Machine)
    return Machine.Products and Machine.SelectedItem and Machine.SelectedItem > 0 and Machine.Products[Machine.SelectedItem] and Machine.Products[Machine.SelectedItem].class == "easyskin"
end

// Return true to prevent the player using the PriceEditor
hook.Add("zvm_BlockPriceEditor","zvm_BlockPriceEditor_Easyskin",function(Machine)
    local result = HasEasySkinSelected(Machine)
    if result then return result end
end)

// Return true to prevent the player using the AppearanceEditor
hook.Add("zvm_BlockAppearanceEditor","zvm_BlockAppearanceEditor_Easyskin",function(Machine)
    local result = HasEasySkinSelected(Machine)
    if result then return result end
end)

// Return true to prevent the player using the RestrictionsEditor
hook.Add("zvm_BlockRestrictionsEditor","zvm_BlockRestrictionsEditor_Easyskin",function(Machine)
    local result = HasEasySkinSelected(Machine)
    if result then return result end
end)


if CLIENT then return end
zvm = zvm or {}
zvm.EasySkins = zvm.EasySkins or {}

concommand.Add("zvm_easyskins_add", function(ply, cmd, args)
    if IsValid(ply) and zclib.Player.IsAdmin(ply) then

        local skindname = args[1]
        if skindname == nil then return end

        zvm.EasySkins.AddItem(ply, skindname)
    end
end)


//!zvm_easyskins_add_CrazyBurn
//!zvm_easyskins_add_Blue_wave
zclib.Hook.Add("PlayerSay", "zvm_PlayerSay_easyskins", function(ply, text)

    // Adds EasySkin Item to Vendingmachine
    if string.sub(string.lower(text), 1, 19) == "!zvm_easyskins_add_" then
        local text_tbl = string.Split( text, "_" )
        local itemid = text_tbl[4]

        zvm.EasySkins.AddItem(ply,itemid)
    end
end)

function zvm.EasySkins.AddItem(ply, skindname)
    zclib.Debug("zvm.EasySkins.AddItem")

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


        // Gets the model
        // Not used since its not a singel model really but multiple which can use the skin
        //SH_EASYSKINS.GetWeaponModels(class)

        // Gets the skin data from a name
        local skin_object,skin_id = SH_EASYSKINS.GetSkinByName(skindname)

        if skin_object == nil then
            zclib.Notify(ply, "Skin not found!", 1)
            return
        end

        local DoesExist = false
        for k,v in pairs(Machine.Products) do
            if v.class == "easyskin" and v.model == skin_id then
                DoesExist = true
                break
            end
        end

        if DoesExist then
            zclib.Notify(ply, "Skin is already in the Vendingmachine!", 1)
            return
        end

        table.insert(Machine.Products,{
            class = "easyskin",
            name = skin_object.dispName,
            price = 0,
            model = skin_id,
            extraData = {skinid = skin_id},
            amount = 1,
        })

        zclib.Notify(ply, "Successfully added " .. skin_object.dispName .. " WeaponSkin to Vendingmachine!", 0)

        // Updates the machine interface for the user which is editing it
        zvm.Machine.UpdateMachineData(Machine,ply)
    end
end

function zvm.EasySkins.GiveItem(ply, skinID,weaponClass)
    zclib.Debug("zvm.EasySkins.GiveItem")

    if not IsValid(ply) then return end

    //SV_EASYSKINS.BuySkin(ply, skinid, weaponclass)
    SV_EASYSKINS.GiveSkinToPlayer(ply:SteamID64(), skinID, {weaponClass})
end


hook.Add("zvm_Overwrite_ItemUnpack","zvm_Overwrite_ItemUnpack_Easyskin",function(ply,crate,ItemData)
    if ItemData.class == "easyskin" then
        if IsValid(ply) then
            local _canbuy,_reason = SH_EASYSKINS.CanBuySkin(ply,ItemData.extraData.skinid,ItemData.extraData.weaponclass)
            if not _canbuy then
                zclib.Notify(ply, _reason, 1)
            else
                zvm.EasySkins.GiveItem(ply, ItemData.extraData.skinid,ItemData.extraData.weaponclass)
            end
        end
        return true
    end
end)
