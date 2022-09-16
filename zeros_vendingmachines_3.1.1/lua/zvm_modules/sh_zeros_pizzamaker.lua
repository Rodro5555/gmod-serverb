/////////////////////////
//Zeros Pizzamaker
//https://www.gmodstore.com/market/view/zero-s-pizzamaker-food-script

zvm.AllowedItems.Add("zpiz_ingredient") // Has CustomData
zvm.AllowedItems.Add("zpiz_pizza") // Has CustomData

hook.Add("zvm_OnItemDataCatch", "zvm_OnItemDataCatch_ZerosPizzamaker", function(data, ent, itemclass)
    if zpiz then
        if itemclass == "zpiz_ingredient" then
            data.ing_id = ent:GetIngredientID()
        elseif itemclass == "zpiz_pizza" then
            data.pizza_id = ent:GetPizzaID()
        end
    end
end)

hook.Add("zvm_OnItemDataApply", "zvm_OnItemDataApply_ZerosPizzamaker", function(itemclass, ent, extraData)
    if zpiz then
        if itemclass == "zpiz_ingredient" then

            local ingredientData = zpiz.Ingredient.GetData(extraData.ing_id)
            if ingredientData == nil then return end

            ent:SetIngredientID(extraData.ing_id)

            ent:SetModel(ingredientData.model)
            ent:PhysicsInit(SOLID_VPHYSICS)
            ent:SetMoveType(MOVETYPE_VPHYSICS)
            ent:SetSolid(SOLID_VPHYSICS)
            local phys = ent:GetPhysicsObject()

            if IsValid(phys) then
                phys:Wake()
                phys:EnableMotion(true)
            end
        elseif itemclass == "zpiz_pizza" then
            if extraData.pizza_id ~= -1 then
                ent:SetModel("models/zerochain/props_pizza/zpizmak_pizza.mdl")
                ent:PhysicsInit(SOLID_VPHYSICS)
                ent:SetMoveType(MOVETYPE_VPHYSICS)
                ent:SetSolid(SOLID_VPHYSICS)
                local phys = ent:GetPhysicsObject()

                if IsValid(phys) then
                    phys:Wake()
                    phys:EnableMotion(true)
                end

                ent:SetColor(zpiz.colors["brown01"])
                ent:SetSkin(1)
                ent:SetBakeTime(-1)
                ent:SetPizzaState(3)
                ent:SetPizzaID(extraData.pizza_id)
            end
        end
    end
end)

hook.Add("zvm_OnItemDataName", "zvm_OnItemDataName_ZerosPizzamaker", function(ent, extraData)
    if zpiz then
        local itemclass = ent:GetClass()
        if itemclass == "zpiz_ingredient" then
            return zpiz.Ingredient.GetName(extraData.ing_id)
        elseif itemclass == "zpiz_pizza" then
            if extraData.pizza_id ~= -1 then
                return zpiz.Pizza.GetName(extraData.pizza_id)
            end
        end
    end
end)

hook.Add("zvm_BlockItemCheck", "zvm_BlockItemCheck_ZerosPizzamaker", function(ent)
    if zpiz and ent:GetClass() == "zpiz_pizza" and (ent:GetPizzaState() >= 4 or ent:GetPizzaState() == 1 or ent:GetPizzaState() == 2) then
        return true
    end
end)

hook.Add("zvm_ItemExists", "zvm_ItemExists_ZerosPizzamaker", function(itemclass,compared_item,extraData)
    if zpiz then
        if itemclass == "zpiz_pizza" then
            return true , compared_item.extraData.pizza_id == extraData.pizza_id
        elseif itemclass == "zpiz_ingredient" then
            return true , compared_item.extraData.ing_id == extraData.ing_id
        end
    end
end)

zclib.Snapshoter.SetPath("zpiz_pizza", function(ItemData)
    if ItemData.extraData.pizza_id and ItemData.extraData.pizza_id > 0 then return "zpiz/" .. ItemData.extraData.pizza_id end
end)

hook.Add("zclib_PostRenderProductImage","zclib_PostRenderProductImage_ZerosPizzamaker",function(cEnt,ItemData)
    if zpiz and ItemData.class == "zpiz_pizza" and ItemData.extraData and ItemData.extraData.pizza_id ~= -1 then
        local pizzaIcon = zpiz.Pizza.GetIcon(ItemData.extraData.pizza_id)
        if pizzaIcon then
            cam.Start3D2D(cEnt:LocalToWorld(Vector(0,0,2)), cEnt:GetAngles(), 1)
                surface.SetDrawColor(255, 255, 255, 255)
                surface.SetMaterial(pizzaIcon)
                surface.DrawTexturedRect(-11, -11, 22, 22)
            cam.End3D2D()
        end
    end
end)
