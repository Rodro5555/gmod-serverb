/////////////////////////
//Zeros Yeastbeast
//https://www.gmodstore.com/market/view/zero-s-yeastbeast-alcohol-script

zvm.AllowedItems.Add("zyb_fuel")
zvm.AllowedItems.Add("zyb_jarpack")
zvm.AllowedItems.Add("zyb_paperbag")
zvm.AllowedItems.Add("zyb_sugar")
zvm.AllowedItems.Add("zyb_water")
zvm.AllowedItems.Add("zyb_yeast")
zvm.AllowedItems.Add("zyb_yeastgrinder")
zvm.AllowedItems.Add("zyb_motor")
zvm.AllowedItems.Add("zyb_fermbarrel")
zvm.AllowedItems.Add("zyb_distillery")
zvm.AllowedItems.Add("zyb_constructionkit_cooler")
zvm.AllowedItems.Add("zyb_constructionkit_condenser")
zvm.AllowedItems.Add("zyb_jarcrate") // Has CustomData
zvm.AllowedItems.Add("zyb_jar") // Has CustomData
zvm.AllowedItems.Add("zyb_palette") // Has CustomData

zclib.RenderData.Add("zyb_yeastgrinder", {ang = Angle(0, 180, 0)})

local zyb_entTable = {
    ["zyb_distillery"] = true,
    ["zyb_constructionkit_cooler"] = true,
    ["zyb_constructionkit_condenser"] = true,
    ["zyb_fermbarrel"] = true,
    ["zyb_fuel"] = true,
    ["zyb_jarpack"] = true,
    ["zyb_jarcrate"] = true,
    ["zyb_yeastgrinder"] = true,
    ["zyb_motor"] = true,
    ["zyb_paperbag"] = true,
    ["zyb_sugar"] = true,
    ["zyb_water"] = true,
    ["zyb_yeast"] = true,
    ["zyb_distillery_cooler"] = true,
    ["zyb_distillery_condenser"] = true,
    ["zyb_palette"] = true
}
hook.Add("zvm_OnPackageItemSpawned", "zvm_OnPackageItemSpawned_ZerosYeastbeast", function(ply, ent, extradata)
    if zyb and zyb_entTable[ent:GetClass()] then
        zyb.f.SetOwner(ent, ply)
    end
end)

hook.Add("zvm_OnItemDataCatch", "zvm_OnItemDataCatch_ZerosYeastbeast", function(data, ent, itemclass)
    if zyb then
        if itemclass == "zyb_jarcrate" then
            data.jar_count = ent:GetJarCount()
        elseif itemclass == "zyb_palette" then
            data.crate_count = ent:GetCrateCount()
        end
    end
end)

hook.Add("zvm_OnItemDataApply", "zvm_OnItemDataApply_ZerosYeastbeast", function(itemclass, ent, extraData)
    if zyb then
        if itemclass == "zyb_jar" then
            ent:SetMoonShine(zyb.config.Jar.MoonshineAmount)
            ent:UpdateVisuals()
        elseif itemclass == "zyb_jarcrate" then
            ent:SetJarCount(extraData.jar_count)
        elseif itemclass == "zyb_palette" then
            ent:SetCrateCount(extraData.crate_count)
        end
    end
end)

hook.Add("zvm_OnItemDataName", "zvm_OnItemDataName_ZerosYeastbeast", function(ent, extraData)
    if zyb then
        local itemclass = ent:GetClass()
        if itemclass == "zyb_jarcrate" then
            if extraData.jar_count > 0 then
                return ent.PrintName .. " x" .. extraData.jar_count
            else
                return ent.PrintName
            end
        elseif itemclass == "zyb_palette" then
            if extraData.crate_count > 0 then
                return ent.PrintName .. " x" .. extraData.crate_count
            else
                return ent.PrintName
            end
        elseif itemclass == "zyb_constructionkit_cooler" then
            return "Kit - Condenser"
        elseif itemclass == "zyb_constructionkit_condenser" then
            return "Kit - Cooler"
        end
    end
end)

hook.Add("zvm_BlockItemCheck", "zvm_BlockItemCheck_ZerosYeastbeast", function(ent)
    if zyb then
        local itemclass = ent:GetClass()
        if itemclass == "zyb_jarpack" and ent:GetJarCount() < 6 then
            return true
        elseif itemclass == "zyb_paperbag" and ent:GetYeastAmount() > 0 then
            return true
        elseif itemclass == "zyb_yeast" and ent:GetYeastAmount() < zyb.config.YeastBlock.Amount then
            return true
        elseif itemclass == "zyb_yeastgrinder" and ent:GetGrinding() then
            return true
        elseif itemclass == "zyb_fermbarrel" and ent:GetStage() ~= 0 then
            return true
        elseif itemclass == "zyb_jar" and ent:GetMoonShine() < zyb.config.Jar.MoonshineAmount then
            return true
        end
    end
end)

hook.Add("zvm_ItemExists", "zvm_ItemExists_ZerosYeastbeast", function(itemclass,compared_item,extraData)
    if zyb then
        if itemclass == "zyb_jarcrate" then
            return true , compared_item.extraData.jar_count == extraData.jar_count
        elseif itemclass == "zyb_palette" then
            return true , compared_item.extraData.crate_count == extraData.crate_count
        end
    end
end)

zclib.Snapshoter.SetPath("zyb_jarcrate", function(ItemData) return "zyb/crates/crate_" .. ItemData.extraData.jar_count end)
zclib.Snapshoter.SetPath("zyb_palette", function(ItemData) return "zyb/palette/palette_" .. ItemData.extraData.crate_count end)

hook.Add("zclib_RenderProductImage","zclib_RenderProductImage_ZerosYeastbeast",function(cEnt,ItemData)
    if zyb then
        // Lets add the food on the plates before rendering
        if ItemData.class == "zyb_palette" and ItemData.extraData and ItemData.extraData.crate_count and ItemData.extraData.crate_count > 0 then

            // Create all the crates on the palette
            local crates = {}
            local Count_X = 0
            local Count_Y = 0
            local Count_Z = 0
            for i = 1, ItemData.extraData.crate_count do
                local client_mdl = zclib.ClientModel.Add("models/zerochain/props_yeastbeast/yb_jarcrate_full.mdl", RENDERGROUP_BOTH)
                if IsValid(client_mdl) then
                    local pos = cEnt:GetPos() - cEnt:GetRight() * 25 - cEnt:GetForward() * 50 + cEnt:GetUp() * 3
                    local ang = cEnt:GetAngles()

                    if Count_X >= 2 then
                        Count_X = 1
                        Count_Y = Count_Y + 1
                    else
                        Count_X = Count_X + 1
                    end

                    if Count_Y >= 3 then
                        Count_Y = 0
                        Count_Z = Count_Z + 1
                    end

                    pos = pos + cEnt:GetForward() * 33 * Count_X
                    pos = pos + cEnt:GetRight() * 25 * Count_Y
                    pos = pos + cEnt:GetUp() * 13.5 * Count_Z

                    client_mdl:SetAngles(ang)
                    client_mdl:SetPos(pos)

                    render.Model({
                        model = "models/zerochain/props_yeastbeast/yb_jarcrate_full.mdl",
                        pos = pos,
                        angle = ang
                    }, client_mdl)

                    table.insert(crates,client_mdl)
                end
            end

            cEnt:CallOnRemove("zyb_remove_render_crates_" .. cEnt:EntIndex(),function(ent)
                for k,v in pairs(crates) do
                    zclib.ClientModel.Remove(v)
                end
            end)
        elseif ItemData.class == "zyb_jarpack" then

            // Create all the crates on the palette
            local jars = {}
            for i = 1, 6 do
                local client_mdl = zclib.ClientModel.Add("models/zerochain/props_yeastbeast/yb_jar.mdl", RENDERGROUP_BOTH)
                if IsValid(client_mdl) then
                    local pos = cEnt:GetAttachment(i).Pos - cEnt:GetUp() * 3
                    client_mdl:SetPos(pos)

                    render.Model({
                        model = "models/zerochain/props_yeastbeast/yb_jar.mdl",
                        pos = pos,
                        angle = Angle(0,0,0)
                    }, client_mdl)

                    table.insert(jars,client_mdl)
                end
            end

            cEnt:CallOnRemove("zyb_remove_render_jarpacks_" .. cEnt:EntIndex(),function(ent)
                for k,v in pairs(jars) do
                    zclib.ClientModel.Remove(v)
                end
            end)
        elseif ItemData.class == "zyb_jarcrate" and ItemData.extraData and ItemData.extraData.jar_count and ItemData.extraData.jar_count > 0 then

            // Create all the crates on the palette
            local jars = {}
            for i = 1, ItemData.extraData.jar_count do
                local client_mdl = zclib.ClientModel.Add("models/zerochain/props_yeastbeast/yb_jar.mdl", RENDERGROUP_BOTH)
                if IsValid(client_mdl) then
                    local pos = cEnt:GetAttachment(i).Pos + cEnt:GetUp() * 1
                    client_mdl:SetPos(pos)

                    client_mdl:SetBodygroup(2, 5)
                    client_mdl:SetBodygroup(1,1)

                    render.Model({
                        model = "models/zerochain/props_yeastbeast/yb_jar.mdl",
                        pos = pos,
                        angle = Angle(0,0,0)
                    }, client_mdl)

                    table.insert(jars,client_mdl)
                end
            end

            cEnt:CallOnRemove("zyb_remove_render_jarpacks_" .. cEnt:EntIndex(),function(ent)
                for k,v in pairs(jars) do
                    zclib.ClientModel.Remove(v)
                end
            end)
        end
    end
end)
