/////////////////////////
//Zeros Methlab2
//https://www.gmodstore.com/market/view/zero-s-methlab2-drug-script

zvm.AllowedItems.Add("zmlab2_equipment")

zvm.AllowedItems.Add("zmlab2_item_acid")
zvm.AllowedItems.Add("zmlab2_item_aluminium")
zvm.AllowedItems.Add("zmlab2_item_lox")
zvm.AllowedItems.Add("zmlab2_item_methylamine")

zvm.AllowedItems.Add("zmlab2_item_meth") // Has CustomData
zvm.AllowedItems.Add("zmlab2_item_crate") // Has CustomData
zvm.AllowedItems.Add("zmlab2_item_palette")
zvm.AllowedItems.Add("zmlab2_item_autobreaker")

zvm.AllowedItems.Add("zmlab2_equipment")
zvm.AllowedItems.Add("zmlab2_tent")

zvm.AllowedItems.Add("zmlab2_machine_ventilation")
zvm.AllowedItems.Add("zmlab2_machine_furnace")
zvm.AllowedItems.Add("zmlab2_machine_mixer")
zvm.AllowedItems.Add("zmlab2_machine_filter")
zvm.AllowedItems.Add("zmlab2_machine_filler")
zvm.AllowedItems.Add("zmlab2_machine_frezzer")
zvm.AllowedItems.Add("zmlab2_table")
zvm.AllowedItems.Add("zmlab2_storage")

zclib.RenderData.Add("zmlab2_equipment", {ang = Angle(0, 180, 0)})

local zmlab2_entTable = {
    ["zmlab2_item_acid"] = true,
	["zmlab2_item_aluminium"] = true,
	["zmlab2_item_lox"] = true,
	["zmlab2_item_methylamine"] = true,

	["zmlab2_item_meth"] = true,
	["zmlab2_item_crate"] = true,
	["zmlab2_item_palette"] = true,
    ["zmlab2_item_autobreaker"] = true,

    ["zmlab2_equipment"] = true,
    ["zmlab2_tent"] = true,

    ["zmlab2_machine_ventilation"] = true,
    ["zmlab2_machine_furnace"] = true,
    ["zmlab2_machine_mixer"] = true,
    ["zmlab2_machine_filter"] = true,
    ["zmlab2_machine_filler"] = true,
    ["zmlab2_machine_frezzer"] = true,
    ["zmlab2_table"] = true,
    ["zmlab2_storage"] = true,
}
hook.Add("zvm_OnPackageItemSpawned", "zvm_OnPackageItemSpawned_ZerosMethlab2", function(ply, ent, extradata)
    if zmlab2 and zmlab2_entTable[ent:GetClass()] then
        zclib.Player.SetOwner(ent, ply)
    end
end)

hook.Add("zvm_OnItemDataCatch", "zvm_OnItemDataCatch_ZerosMethlab2", function(data, ent, itemclass)
    if zmlab2 then
        if itemclass == "zmlab2_item_crate" then
            data.meth_amount = ent:GetMethAmount()
            data.meth_type = ent:GetMethType()
            data.meth_qual = ent:GetMethQuality()
        elseif itemclass == "zmlab2_item_meth" then
            data.meth_amount = ent:GetMethAmount()
            data.meth_type = ent:GetMethType()
            data.meth_qual = ent:GetMethQuality()
        end
    end
end)

hook.Add("zvm_OnItemDataApply", "zvm_OnItemDataApply_ZerosMethlab2", function(itemclass, ent, extraData)
    if zmlab2 then
        if itemclass == "zmlab2_item_crate" then
            ent:SetMethAmount(extraData.meth_amount)
            ent:SetMethType(extraData.meth_type)
            ent:SetMethQuality(extraData.meth_qual)
        elseif itemclass == "zmlab2_item_meth" then
            ent:SetMethAmount(extraData.meth_amount)
            ent:SetMethType(extraData.meth_type)
            ent:SetMethQuality(extraData.meth_qual)
        end
    end
end)

local function GetName(extraData)
    local name = zmlab2.Meth.GetName(extraData.meth_type) or "Meth"
    return name .. " " .. extraData.meth_amount .. zmlab2.config.UoM .. " " .. extraData.meth_qual .. "%"
end
hook.Add("zvm_OnItemDataName", "zvm_OnItemDataName_ZerosMethlab2", function(ent, extraData)
    if zmlab2 then
        local itemclass = ent:GetClass()
        if itemclass == "zmlab2_item_crate" then
            if extraData.meth_amount > 0 then
                return GetName(extraData)
            else
                return ent.PrintName
            end
        elseif itemclass == "zmlab2_item_meth" then
            return GetName(extraData)
        end
    end
end)

hook.Add("zvm_BlockItemCheck", "zvm_BlockItemCheck_ZerosMethlab2", function(ent)
    if zmlab2 and ent:GetClass() == "zmlab2_item_palette" and table.Count(ent.MethList) > 0 then
        return true
    end
end)

hook.Add("zvm_ItemExists", "zvm_ItemExists_ZerosMethlab2", function(itemclass,compared_item,extraData)
    if zmlab2 then
        if itemclass == "zmlab2_item_crate" then
            return true , compared_item.extraData.meth_amount == extraData.meth_amount and compared_item.extraData.meth_type == extraData.meth_type and compared_item.extraData.meth_qual == extraData.meth_qual
        elseif itemclass == "zmlab2_item_meth" then
            return true , compared_item.extraData.meth_amount == extraData.meth_amount and compared_item.extraData.meth_type == extraData.meth_type and compared_item.extraData.meth_qual == extraData.meth_qual
        end
    end
end)

zclib.Snapshoter.SetPath("zmlab2_item_meth", function(ItemData) return "zmlab2/meth/meth_" .. math.Round(ItemData.extraData.meth_type) .. "_" .. math.Round((3 / 100) * ItemData.extraData.meth_qual) end)

zclib.Snapshoter.SetPath("zmlab2_item_crate", function(ItemData)
    if ItemData.extraData.meth_amount > 0 then return "zmlab2/crate/crate_" .. math.Round(ItemData.extraData.meth_type) .. "_" .. math.Clamp(5 - math.Round((5 / zmlab2.config.Crate.Capacity) * ItemData.extraData.meth_amount), 1, 5) .. "_" .. math.Round((3 / 100) * ItemData.extraData.meth_qual) end
end)


hook.Add("zclib_RenderProductImage", "zclib_RenderProductImage_ZerosMethlab2", function(cEnt, ItemData)
    if zmlab2 then
        if ItemData.class == "zmlab2_item_crate" and ItemData.extraData and ItemData.extraData.meth_amount > 0 then
            local MethMat = zmlab2.Meth.GetMaterial(ItemData.extraData.meth_type, ItemData.extraData.meth_qual)

            if MethMat then
                cEnt:SetSubMaterial(0, "!" .. MethMat)
            end

            local cur_amount = ItemData.extraData.meth_amount
            local bg = math.Clamp(5 - math.Round((5 / zmlab2.config.Crate.Capacity) * cur_amount), 1, 5)
            cEnt:SetBodygroup(0, bg)
        elseif ItemData.class == "zmlab2_item_meth" and ItemData.extraData and ItemData.extraData.meth_amount > 0 then
            local MethMat = zmlab2.Meth.GetMaterial(ItemData.extraData.meth_type, ItemData.extraData.meth_qual)

            if MethMat then
                cEnt:SetSubMaterial(0, "!" .. MethMat)
            end
        end
    end
end)
