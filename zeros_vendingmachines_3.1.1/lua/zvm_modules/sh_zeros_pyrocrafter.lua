/////////////////////////
//Zeros Pyrocrafter
//https://www.gmodstore.com/market/view/zero-s-pyrocrafter-firework-script

zvm.AllowedItems.Add("zpc_battery") // Has CustomData
zvm.AllowedItems.Add("zpc_pyrostage")
zvm.AllowedItems.Add("zpc_pyroworkbench")

local function FireworkSetup(ent, ply)
    local filename = ent:GetPyroFileName()
    local _, directories = file.Find("zpc/*", "DATA", "datedesc")
    local pathToFile

    for _, dirs in pairs(directories) do
        local currentPath = "zpc/" .. dirs .. "/"
        local files, dirs01 = file.Find(currentPath .. "*", "DATA", "datedesc")
        local foundPath = false

        for s, w in pairs(files) do
            if w == filename then
                pathToFile = currentPath .. filename
                foundPath = true
                break
            end
        end

        if foundPath == false then
            for s, w in pairs(dirs01) do
                local currentPath01 = currentPath .. w .. "/"
                local files01, _ = file.Find(currentPath01 .. "*", "DATA", "datedesc")

                for _, afile in pairs(files01) do
                    if afile == filename then
                        pathToFile = currentPath01 .. filename
                        foundPath = true
                        break
                    end
                end
            end
        end

        if foundPath then break end
    end

    local pyrodata

    if pathToFile then
        if file.Exists(pathToFile, "DATA") then
            pyrodata = file.Read(pathToFile, "DATA")
            pyrodata = util.JSONToTable(pyrodata)
        else
            ent:FireWorkInvalid(ply)

            return
        end
    else
        ent:FireWorkInvalid(ply)

        return
    end

    if zpc.f.CanSpawnPyro(ply, -1) == false then
        ent:FireWorkLimit(ply)

        return
    end

    if (pyrodata) then
        ent:SetPyroName(pyrodata.name)
        ent:SetModelID(pyrodata.modelID)
        ent:SetPyroCreatedBy(pyrodata.CreatedBy)
        local spyroBoxData = zpc.PyroBox[pyrodata.modelID]
        ent:SetModel(spyroBoxData.model)
        ent:PhysicsInit(SOLID_VPHYSICS)
        ent:SetMoveType(MOVETYPE_VPHYSICS)
        ent:SetSolid(SOLID_VPHYSICS)
        ent:SetUseType(SIMPLE_USE)
        ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        local phys = ent:GetPhysicsObject()

        if IsValid(ent) then
            phys:Wake()
            phys:EnableMotion(true)
        end

        if spyroBoxData.isrocket then
            local strings = string.Split(pyrodata.filename, "_")
            strings = string.Split(strings[2], ".")
            local id = strings[1]
            math.randomseed(id)
            ent:SetSkin(math.random(1, 3))
        end

        local seq = pyrodata.EffectSequence
        ent.EffectSequence = {}

        for k, v in pairs(seq) do
            local effectData = zpc.f.CatchEffectByNumID(v[1])

            table.insert(ent.EffectSequence, {
                EffectID = v[1],
                EffectName = effectData.effect,
                TriggerTime = v[2],
                AttachID = v[3],
                duration = effectData.duration,
                EffectType = effectData.effecttype,
                SFX = effectData.sfx,
                GotFired = false,
                ZForce = effectData.zforce
            })
        end
    end
end

local zpc_entTable = {
    ["zpc_battery"] = true,
    ["zpc_pyroworkbench"] = true,
    ["zpc_pyrostage"] = true,
}
hook.Add("zvm_OnPackageItemSpawned", "zvm_OnPackageItemSpawned_ZerosPyrocrafter", function(ply, ent, extradata)

    if zpc then
        local class = ent:GetClass()
        if zpc_entTable[class] then
            zpc.f.SetOwner(ent, ply)

            if class == "zpc_pyrostage" then
                ent:SetAssignedPlayer(ply:SteamID())
                ent:SetMusicID(zpc.MusicList[1].id)
                ent:SetPyroShowDuration(zpc.MusicList[1].duration)

                if ply:HasWeapon("zpc_pyrolinker") then
                    ply:GetWeapon("zpc_pyrolinker"):SetShowTable(ent)
                end
            elseif class == "zpc_battery" then
                FireworkSetup(ent, ply)
            end
        end
    end
end)

hook.Add("zvm_OnItemDataCatch", "zvm_OnItemDataCatch_ZerosPyrocrafter", function(data, ent, itemclass)
    if zpc and itemclass == "zpc_battery" then
        data.pyro_file = ent:GetPyroFileName()
    end
end)

hook.Add("zvm_OnItemDataApply", "zvm_OnItemDataApply_ZerosPyrocrafter", function(itemclass, ent, extraData)
    if zpc and itemclass == "zpc_battery" then
        ent:SetPyroFileName(extraData.pyro_file)
    end
end)

hook.Add("zvm_OnItemDataName", "zvm_OnItemDataName_ZerosPyrocrafter", function(ent, extraData)
    if zpc then
        local itemclass = ent:GetClass()
        if itemclass == "zpc_battery" then
            return ent:GetPyroName() or ""
        end
    end
end)

hook.Add("zvm_BlockItemCheck", "zvm_BlockItemCheck_ZerosPyrocrafter", function(ent)
    if zpc then
        local itemclass = ent:GetClass()
        if itemclass == "zpc_battery" and (ent:GetPyroIgnited() or ent:GetPyroDone()) then
            return true
        elseif itemclass == "zpc_pyroworkbench" and ent:GetInUse() then
            return true
        elseif itemclass == "zpc_pyrostage" and ent:GetIsPlaying() then
            return true
        end
    end
end)

hook.Add("zvm_ItemExists", "zvm_ItemExists_ZerosPyrocrafter", function(itemclass,compared_item,extraData)
    if zpc and itemclass == "zpc_battery" then
        return true , compared_item.extraData.pyro_file == extraData.pyro_file
    end
end)
