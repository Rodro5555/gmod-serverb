/////////////////////////
//Zeros Pyrocrafter 2

zvm.AllowedItems.Add("zpc2_firework") // Has CustomData

hook.Add("zvm_OnPackageItemSpawned", "zvm_OnPackageItemSpawned_ZerosPyrocrafter2", function(ply, ent, extradata)
    if ent:GetClass() == "zpc2_firework" then
        zclib.Player.SetOwner(ent, ply)
    end
end)

hook.Add("zvm_OnItemDataCatch", "zvm_OnItemDataCatch_ZerosPyrocrafter2", function(data, ent, itemclass)
    if zpc2 and itemclass == "zpc2_firework" then
        // Lets save the fireworkdata too
        local FireworkData = zpc2.Firework.GetCachedData(ent:GetSavefileID())
        if FireworkData then
            data.FireworkData = FireworkData
        end

        // Cache firework data
        zpc2.Firework.Cache(ent:GetSavefileID(),FireworkData)
    end
end)

hook.Add("zvm_OnItemDataApply", "zvm_OnItemDataApply_ZerosPyrocrafter2", function(itemclass, ent, extraData)
    if zpc2 and itemclass == "zpc2_firework" then

        local SavefileID = extraData.FireworkData.UniqueID
        local FireworkData = zpc2.Firework.GetCachedData(SavefileID) or extraData.FireworkData

        zpc2.Firework.Cache(SavefileID,FireworkData)

        local BoxData = zpc2.config.Pyrobox[FireworkData.PyroBoxID]
        if BoxData == nil then return end

        ent:SetSavefileID(SavefileID)

        // Cache firework data
        zpc2.Firework.Cache(SavefileID,FireworkData)


        ent:SetModel(BoxData.model)
        ent:PhysicsInit(SOLID_VPHYSICS)
        ent:SetSolid(SOLID_VPHYSICS)
        ent:SetMoveType(MOVETYPE_VPHYSICS)
        ent:SetUseType(SIMPLE_USE)

        if zpc2.config.Firework.PlayerCollide == false then
            ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        end

        local phys = ent:GetPhysicsObject()
        if IsValid(phys) then
            phys:Wake()
            phys:EnableMotion(true)
            phys:SetAngleDragCoefficient(1000)
        end
    end
end)

hook.Add("zvm_OnItemDataName", "zvm_OnItemDataName_ZerosPyrocrafter2", function(ent, extraData)
    if zpc2 and ent:GetClass() == "zpc2_firework" then
        local savefile = ent:GetSavefileID()
        local FireworkData = zpc2.Firework.GetCachedData(savefile)
        if FireworkData == nil then return end
        local PyroBoxData = zpc2.config.Pyrobox[FireworkData.PyroBoxID]
        if PyroBoxData == nil then return end
        local name = FireworkData.Name

        if FireworkData.Version then
            name = name .. " v." .. FireworkData.Version
        end

        return name
    end
end)

hook.Add("zvm_BlockItemCheck", "zvm_BlockItemCheck_ZerosPyrocrafter2", function(ent)
    if zpc2 and ent:GetClass() == "zpc2_firework" and ent:GetIgnitionTime() > 0 then
        return true
    end
end)

hook.Add("zvm_ItemExists", "zvm_ItemExists_ZerosPyrocrafter2", function(itemclass,compared_item,extraData)
    if zpc2 and itemclass == "zpc2_firework" then
        return true , compared_item.extraData.UniqueID == extraData.UniqueID
    end
end)
