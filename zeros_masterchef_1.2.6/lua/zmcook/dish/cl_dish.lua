if SERVER then return end
zmc = zmc or {}
zmc.Dish = zmc.Dish or {}

function zmc.Dish.Initialize(Dish) end

function zmc.Dish.Draw(Dish)
    zmc.Dish.DrawFood(Dish)
    if zclib.Convar.Get("zmc_vfx_dishhud") == 1 then
        zmc.Item.DrawName(Dish, zmc.Dish.GetName(Dish:GetDishID()))
    end
end

function zmc.Dish.Think(Dish) end

function zmc.Dish.DrawFood(Dish)
    if zclib.util.InDistance(Dish:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_dish_clientmodels) then

        // The eating progress
        local prog = Dish:GetEatProgress()

        zmc.Dish.DrawFoodItems(Dish,zmc.Dish.GetData(Dish:GetDishID()),nil,function(food_id)
            return prog ~= -1 and food_id > prog
        end)
    else
        zmc.Dish.RemoveClientModels(Dish)
    end
end

function zmc.Dish.RemoveClientModels(Dish)
    if Dish.ClientModelCache then
        for k, v in pairs(Dish.ClientModelCache) do
            if not IsValid(v.ent) then continue end
            zclib.ClientModel.Remove(v.ent)
        end
        Dish.ClientModelCache = nil
    end
end

function zmc.Dish.OnRemove(Dish)
    zmc.Dish.RemoveClientModels(Dish)
end

// If enabled cuts all the bottom of the food items so it doesent glitch through the plate
function zmc.Dish.Clipping(enabled,Dish,plate_scale,DrawFood)
    if enabled and zclib.Convar.Get("zmc_vfx_dishclipping") == 1 and Dish.NoFoodClipping == nil then
        local oldEC = render.EnableClipping(true)
            local normal = Dish:GetUp()
            local cutPosition = Dish:LocalToWorld(Vector(0,0,1 * plate_scale))
            local cutDistance = normal:Dot(cutPosition) // Project the vector onto the normal to get the shortest distance between the plane and origin

            // Activate the plane
            render.PushCustomClipPlane(normal, cutDistance)
                pcall(DrawFood)
            render.PopCustomClipPlane()
        render.EnableClipping(oldEC)
    else
        pcall(DrawFood)
    end
end

function zmc.Dish.DrawFoodItems(Dish,DishData,HighlightID,SkipCheck,IsGhost,ForceClipping)
    if not IsValid(Dish) then return end
    if DishData == nil then
        zmc.Dish.RemoveClientModels(Dish)
        return
    end

    local plate_scale = Dish:GetModelScale()
    if plate_scale == nil then
        zmc.Dish.RemoveClientModels(Dish)
        return
    end

    if Dish.ClientModelCache == nil then
        Dish.ClientModelCache = {}
        for k,v in pairs(DishData.items) do
            if v == nil then continue end
            if v.uniqueid == nil then continue end

            local itemdata = zmc.Item.GetData(v.uniqueid)
            if itemdata == nil then continue end
            if itemdata.mdl == nil then continue end

            if SkipCheck then
                local _,check = xpcall(SkipCheck,function() end,k,v.uniqueid)
                if check then continue end
            end

            local client_mdl = zclib.ClientModel.Add(itemdata.mdl, RENDERGROUP_BOTH)
            if not IsValid(client_mdl) then

                continue
            end

            Dish.ClientModelCache[k] = {ent = client_mdl,color = zclib.util.ColorToVector(itemdata.color or color_white),mdlpath = itemdata.mdl,item_scale = itemdata.scale or 1}

            zmc.Item.UpdateVisual(client_mdl,itemdata,true)
            client_mdl:SetModelScale((itemdata.scale or 1) * plate_scale * (v.scale or 1))

            if IsGhost then
                local _,check = xpcall(IsGhost,function() end,k,v.uniqueid)
                if check then
                    client_mdl:SetMaterial(nil)
                    client_mdl:SetColor(color_white)
                    client_mdl:SetMaterial("zerochain/zmc/shader/ghost_mat")
                end
            end
        end

        Dish:CallOnRemove("zmc_remove_food_items_" .. Dish:EntIndex(),function(ent)
            zmc.Dish.RemoveClientModels(ent)
        end)
    end

    if Dish.ClientModelCache == nil then return end
    if table.Count(Dish.ClientModelCache) <= 0 then return end

    zmc.Dish.Clipping(ForceClipping or zclib.util.InDistance(Dish:GetPos(), LocalPlayer():GetPos(), zmc.renderdist_dish_clipping),Dish,plate_scale,function()
        for k, v in pairs(Dish.ClientModelCache) do
            if v and IsValid(v.ent) and v.ent.DrawModel then
                local itmDat = DishData.items[k]
                if itmDat == nil then continue end
                if itmDat.lpos == nil then continue end
                if itmDat.lang == nil then continue end

                if SkipCheck then
                    local _,check = xpcall(SkipCheck,function() end,k,itmDat.uniqueid)
                    if check then continue end
                end

                local pos = itmDat.lpos

                // If its not a ghost then draw the food items color
                if IsGhost then
                    local _,check = xpcall(IsGhost,function() end,k,itmDat.uniqueid)
                    if check ~= true then
                        render.SetColorModulation(v.color.x,v.color.y,v.color.z,1)
                    end
                else
                    render.SetColorModulation(v.color.x,v.color.y,v.color.z,1)
                end

                v.ent:SetModelScale((v.item_scale or 1) * plate_scale * (itmDat.scale or 1))

                local apos = Dish:LocalToWorld(Vector(20 * (-pos.x) + 10, 20 * pos.y - 10, 15 * pos.z) * plate_scale)
                debugoverlay.Sphere( pos, 1, 0.1, Color( 255, 255, 255 ), true )

                render.Model({
                    model = v.mdlpath,
                    pos = apos,
                    angle = Dish:LocalToWorldAngles(itmDat.lang)
                }, v.ent)
                render.SetColorModulation(1, 1, 1, 1)

                // Draw the highlight indicator
                if HighlightID and k == HighlightID then
                    render.MaterialOverride(zclib.Materials.Get("highlight"))
                    render.SetColorModulation(0.6,0.6,0.6)
                    v.ent:DrawModel()
                    render.MaterialOverride()
                    render.SetColorModulation(1, 1, 1)
                end
            end
        end
    end)
end
