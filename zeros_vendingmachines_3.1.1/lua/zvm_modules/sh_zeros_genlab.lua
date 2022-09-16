/////////////////////////
//Zeros GenLab
//https://www.gmodstore.com/market/view/zero-s-genlab-disease-script

zvm.AllowedItems.Add("zbl_flask") // Has CustomData
zvm.AllowedItems.Add("zbl_gasmask")
zvm.AllowedItems.Add("zbl_spray")
zvm.AllowedItems.Add("zbl_gun")
zvm.AllowedItems.Add("zbl_lab")
zvm.AllowedItems.Add("zbl_dna")

local zbl_entTable = {
    ["zbl_flask"] = true,
    ["zbl_gasmask"] = true,
    ["zbl_lab"] = true,
}
hook.Add("zvm_OnPackageItemSpawned", "zvm_OnPackageItemSpawned_ZerosGenLab", function(ply, ent, extradata)
    if zbl then
        if zbl_entTable[ent:GetClass()] then
            zclib.Player.SetOwner(ent, ply)
        end

        if class == "zbl_flask" then
            ent.FlaskOwner = ply

            zbl.Flask.Add(ply,ent)
        end
    end
end)

hook.Add("zvm_OnItemDataCatch", "zvm_OnItemDataCatch_ZerosGenLab", function(data, ent, itemclass)
    if itemclass == "zbl_flask" then
        data.gentype = ent:GetGenType()
        data.genvalue = ent:GetGenValue()
        data.genname = ent:GetGenName()
        data.genpoints = ent:GetGenPoints()
        data.genclass = ent:GetGenClass()
    end
end)

hook.Add("zvm_OnItemDataApply", "zvm_OnItemDataApply_ZerosGenLab", function(itemclass, ent, extraData)
    if itemclass == "zbl_flask" then
        ent:SetGenType(extraData.gentype)
        ent:SetGenValue(extraData.genvalue)
        ent:SetGenName(extraData.genname)
        ent:SetGenPoints(extraData.genpoints)
        ent:SetGenClass(extraData.genclass)
    end
end)

hook.Add("zvm_OnItemDataName", "zvm_OnItemDataName_ZerosGenLab", function(ent, extraData)
    local itemclass = ent:GetClass()

    if itemclass == "zbl_flask" then
        return ent:GetGenName()
    end
end)

hook.Add("zvm_BlockItemCheck", "zvm_BlockItemCheck_ZerosGenLab", function(ent)
    local itemclass = ent:GetClass()
    if itemclass == "zbl_flask" and ent:GetGenType() <= 0 then
        return true
    end
end)

hook.Add("zvm_ItemExists", "zvm_ItemExists_ZerosGenLab", function(itemclass,compared_item,extraData)
    if itemclass == "zbl_flask" then
        return true , compared_item.extraData.gentype == extraData.gentype and compared_item.extraData.genvalue == extraData.genvalue
    end
end)

hook.Add("zvm_Overwrite_ProductImage","zvm_Overwrite_ProductImage_ZerosGenLab",function(pnl,ItemData)

    if ItemData.class == "zbl_flask" and zbl and zbl.materials and IsValid(pnl) then

        local gen_type = ItemData.extraData.gentype
        local gen_value = ItemData.extraData.genvalue
        local image
        local col

        // GenType 0 means the flask which got added is empty, which should never happen
        if gen_type == 0 then
            image = zbl.materials["zbl_icon_close"]
            col = zbl.colors["sample_blue"]
        elseif gen_type == 1 then
            image = zbl.materials["zbl_dna_icon"]
            col = zbl.colors["sample_blue"]
        elseif gen_type == 2 then
            if zbl.config.Vaccines[gen_value] and zbl.config.Vaccines[gen_value].isvirus then
                image = zbl.materials["zbl_virus_icon"]
                col = zbl.colors["virus_red"]
            else
                image = zbl.materials["zbl_abillity_icon"]
                col = zbl.colors["abillity_yellow"]
            end
        elseif gen_type == 3 then
            image = zbl.materials["zbl_cure_icon"]
            col = zbl.colors["cure_green"]
        end

        if image then pnl:SetMaterial(image) end
        if col then pnl:SetImageColor(col) end
        return true
    end
end)

hook.Add("zvm_Overwrite_IdleImage","zvm_Overwrite_IdleImage_ZerosGenLab",function(pnl,ItemData)

    if ItemData.class == "zbl_flask" and zbl and zbl.materials and IsValid(pnl) then

        local gen_type = ItemData.extraData.gentype
        local gen_value = ItemData.extraData.genvalue
        local image
        local col

        // GenType 0 means the flask which got added is empty, which should never happen
        if gen_type == 0 then
            image = zbl.materials["zbl_icon_close"]
            col = zbl.colors["sample_blue"]
        elseif gen_type == 1 then
            image = zbl.materials["zbl_dna_icon"]
            col = zbl.colors["sample_blue"]
        elseif gen_type == 2 then
            if zbl.config.Vaccines[gen_value] and zbl.config.Vaccines[gen_value].isvirus then
                image = zbl.materials["zbl_virus_icon"]
                col = zbl.colors["virus_red"]
            else
                image = zbl.materials["zbl_abillity_icon"]
                col = zbl.colors["abillity_yellow"]
            end
        elseif gen_type == 3 then
            image = zbl.materials["zbl_cure_icon"]
            col = zbl.colors["cure_green"]
        end

        if image then pnl:SetMaterial(image) end
        if col then pnl:SetImageColor(col) end
        return true
    end
end)
