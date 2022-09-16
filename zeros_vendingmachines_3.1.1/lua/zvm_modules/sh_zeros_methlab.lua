/////////////////////////
//Zeros Methlab
//https://www.gmodstore.com/market/view/zero-s-methlab-drug-script

zvm.AllowedItems.Add("zmlab_collectcrate") // Has CustomData
zvm.AllowedItems.Add("zmlab_filter")
zvm.AllowedItems.Add("zmlab_methylamin")
zvm.AllowedItems.Add("zmlab_palette")
zvm.AllowedItems.Add("zmlab_aluminium")
zvm.AllowedItems.Add("zmlab_combiner")
zvm.AllowedItems.Add("zmlab_frezzer")
zvm.AllowedItems.Add("zmlab_meth") // Has CustomData
zvm.AllowedItems.Add("zmlab_meth_baggy") // Has CustomData

zclib.RenderData.Add("zmlab_frezzer", {ang = Angle(0, 180, 0)})
zclib.RenderData.Add("zmlab_methylamin", {ang = Angle(0, 270, 0)})

local zmlab_entTable = {
    ["zmlab_collectcrate"] = true,
    ["zmlab_filter"] = true,
    ["zmlab_methylamin"] = true,
    ["zmlab_palette"] = true,
    ["zmlab_aluminium"] = true,
    ["zmlab_combiner"] = true,
    ["zmlab_frezzer"] = true,
}
hook.Add("zvm_OnPackageItemSpawned", "zvm_OnPackageItemSpawned_ZerosMethlab", function(ply, ent, extradata)
    if zmlab and zmlab_entTable[ent:GetClass()] then
        zmlab.f.SetOwner(ent, ply)
    end
end)

hook.Add("zvm_OnItemDataCatch", "zvm_OnItemDataCatch_ZerosMethlab", function(data, ent, itemclass)
    if zmlab then
        if itemclass == "zmlab_collectcrate" then
            data.meth_amount = ent:GetMethAmount()
        elseif itemclass == "zmlab_meth" then
            data.meth_amount = ent:GetMethAmount()
        end
    end
end)

hook.Add("zvm_OnItemDataApply", "zvm_OnItemDataApply_ZerosMethlab", function(itemclass, ent, extraData)
    if zmlab then
        if itemclass == "zmlab_collectcrate" then
            ent:SetMethAmount(extraData.meth_amount)
        elseif itemclass == "zmlab_meth" then
            ent:SetMethAmount(extraData.meth_amount)
        elseif itemclass == "zmlab_meth_baggy" then
            ent:SetMethAmount(zmlab.config.MethExtractorSWEP.Amount)
        end
    end
end)

hook.Add("zvm_OnItemDataName", "zvm_OnItemDataName_ZerosMethlab", function(ent, extraData)

    if zmlab then
        local itemclass = ent:GetClass()
        if itemclass == "zmlab_collectcrate" then
            if extraData.meth_amount > 0 then
                return ent.PrintName .. " " .. extraData.meth_amount .. zmlab.config.UoW
            else
                return ent.PrintName
            end
        elseif itemclass == "zmlab_meth" then
            return ent.PrintName .. " " .. extraData.meth_amount .. zmlab.config.UoW
        end
    end
end)

hook.Add("zvm_BlockItemCheck", "zvm_BlockItemCheck_ZerosMethlab", function(ent)
    if zmlab and ent:GetClass() == "zmlab_palette" and ent:GetCrateCount() > 0 then
        return true
    end
end)

hook.Add("zvm_ItemExists", "zvm_ItemExists_ZerosMethlab", function(itemclass,compared_item,extraData)
    if zmlab then
        if itemclass == "zmlab_collectcrate" then
            return true , compared_item.extraData.meth_amount == extraData.meth_amount
        elseif itemclass == "zmlab_meth" then
            return true , compared_item.extraData.meth_amount == extraData.meth_amount
        end
    end
end)

hook.Add("zclib_GetImagePath","zclib_GetImagePath_ZerosMethlab",function(ItemData)
    if zmlab and string.sub(ItemData.class,1,6) == "zmlab_" then
        return "zmlab/" .. ItemData.class
    end
end)
