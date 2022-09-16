if SERVER then

    concommand.Add("zrms_debug_basket", function(ply, cmd, args)
        if zrmine.f.IsAdmin(ply) then
            local tr = ply:GetEyeTrace()
            local trEntity = tr.Entity

            if IsValid(trEntity) and string.sub(trEntity:GetClass(), 1, 11) == "zrms_basket" then
                print("-----------------------------------------")
                print("Entity: " .. trEntity.PrintName .. " [" .. trEntity:EntIndex() .. "]")
                print("Type: " .. trEntity:GetResourceType())
                print("Amount: " .. trEntity:GetResourceAmount())
                print("-----------------------------------------")
            end
        end
    end)

    concommand.Add("zrms_debug_GraveAnim_Info", function(ply, cmd, args)
        if zrmine.f.IsAdmin(ply) then
            local tr = ply:GetEyeTrace()
            local ent = tr.Entity

            if IsValid(ent) then
                print(ent.PrintName .. "[" .. ent:EntIndex() .. "]")
                print("GravelAnim_Type: " .. ent:GetGravelAnim_Type())
            end
        end
    end)

    concommand.Add("zrms_debug_gravel", function(ply, cmd, args)
        if zrmine.f.IsAdmin(ply) then
            local tr = ply:GetEyeTrace()

            if tr.HitPos then
                local ent = ents.Create("zrms_resource")
                ent:SetAngles(Angle(math.random(0, 360), math.random(0, 360), math.random(0, 360)))
                ent:SetPos(tr.HitPos)
                ent:Spawn()
                ent:Activate()
                ent:SetBodygroup(0, 1)

                ent:SetSkin(0)



                ent:SetResourceType(tostring("Iron"))
                ent:SetResourceAmount(25)
            end
        end
    end)

    concommand.Add("zrms_debug_GravelAnim_Test", function(ply, cmd, args)
        if zrmine.f.IsAdmin(ply) then
            local tr = ply:GetEyeTrace()
            local ent = tr.Entity

            if IsValid(ent) and ent:GetClass() == "zrms_crusher" then
                zrmine.f.Crusher_PlayGravelAnim(ent, "Gold")
            end
        end
    end)

    concommand.Add("zrms_debug_EntList", function(ply, cmd, args)
        if zrmine.f.IsAdmin(ply) then
            PrintTable(zrmine.EntList)
        end
    end)

    local function PrintConnectionData(Parent, Child01, Child02, ConnectionPos)
        if IsValid(Parent) then
            print("Parent: " .. Parent.PrintName .. Parent:EntIndex())
        else
            print("Parent: NONE")
        end

        if ConnectionPos == -1 then
            print("ParentPort: NOT CONNECTED")
        else
            print("ParentPort: " .. ConnectionPos)
        end

        if IsValid(Child01) then
            print("Child01: " .. Child01.PrintName .. Child01:EntIndex())
        else
            print("Child01: NONE")
        end

        if IsValid(Child02) then
            print("Child02: " .. Child02.PrintName .. Child02:EntIndex())
        else
            print("Child02: NONE")
        end
    end

    concommand.Add("zrms_debug_Entity", function(ply, cmd, args)
        if zrmine.f.IsAdmin(ply) then
            local tr = ply:GetEyeTrace()
            local ent = tr.Entity

            if IsValid(ent) then
                if ent:GetClass() == "zrms_splitter" then
                    PrintConnectionData(ent:GetModuleParent(), ent:GetModuleChild01(), ent:GetModuleChild02(), ent:GetConnectionPos())
                else
                    PrintConnectionData(ent:GetModuleParent(), ent:GetModuleChild(), nil, ent:GetConnectionPos())
                end
            end
        end
    end)




    concommand.Add("zrms_levelsystem_migrate_data_to_file", function(ply, cmd, args)
    	if zrmine.f.IsAdmin(ply) then
    		for k, v in pairs(zrmine.players) do
    			if IsValid(v) then

    				local plyData = v:GetPData("zrmine/XP/database", nil)

    				if plyData then

    					plyData = util.JSONToTable(plyData)

    					if not file.Exists("zrms", "DATA") then
    						file.CreateDir("zrms")
    					end

    					if not file.Exists("zrms/playerdata", "DATA") then
    						file.CreateDir("zrms/playerdata")
    					end

    					// This makes sure the data only gets replaced if it doesent exist allready as file
    					if file.Exists("zrms/playerdata/" ..  tostring(v:SteamID64()) .. ".txt", "DATA") == false then

    						file.Write("zrms/playerdata/" .. tostring(v:SteamID64()) .. ".txt", util.TableToJSON(plyData,true))
    						zrmine.f.Debug("Pickaxe Data migrated from sv.db to file for player: " .. v:Nick())

    					end
    				else
    					zrmine.f.Debug("No sv.db data found for : " .. v:Nick())
    				end
    			end
    		end
    	end
    end)


    // Open PlayerData Config
    concommand.Add("zrms_levelsystem_open", function(ply, cmd, args)
    	if zrmine.f.IsAdmin(ply) then
    		net.Start("zrmine_LvlSysData_open_net")
    		net.Send(ply)
    	end
    end)


    concommand.Add("zrms_ore_save", function(ply, cmd, args)
    	if zrmine.f.IsAdmin(ply) then
    		zrmine.f.OreSpawn_Save(ply)
    	else
    		zrmine.f.Notify(ply, zrmine.language.Cmd_NoPermission, 1)
    	end
    end)
    concommand.Add("zrms_ore_remove", function(ply, cmd, args)
    	if zrmine.f.IsAdmin(ply) then
    		zrmine.f.OreSpawn_Remove(ply)
    	else
    		zrmine.f.Notify(ply, zrmine.language.Cmd_NoPermission, 1)
    	end
    end)



    concommand.Add("zrms_lvlsys_reset", function(ply, cmd, args)
        zrmine.lvlsys.AdminReset(ply,args[1])
    end)

    concommand.Add("zrms_lvlsys_xp", function(ply, cmd, args)
        zrmine.lvlsys.AdminGiveXP(ply, args[1], tonumber(args[2]))
    end)

    concommand.Add("zrms_lvlsys_lvl", function(ply, cmd, args)
        zrmine.lvlsys.AdminGiveLvl(ply, args[1], tonumber(args[2],10))
    end)








    concommand.Add("zrmine_pipeline_save", function(ply, cmd, args)
        if zrmine.f.IsAdmin(ply) then
            zrmine.f.PipeLine_Save(ply)
        else
            zrmine.f.Notify(ply, zrmine.language.Cmd_NoPermission, 1)
        end
    end)

    concommand.Add("zrmine_pipeline_load", function(ply, cmd, args)
        if zrmine.f.IsAdmin(ply) then
            zrmine.f.PipeLine_Remove()
            zrmine.f.PipeLine_Load()
        else
            zrmine.f.Notify(ply, zrmine.language.Cmd_NoPermission, 1)
        end
    end)

    concommand.Add("zrmine_pipeline_delete", function(ply, cmd, args)
        if zrmine.f.IsAdmin(ply) then
            zrmine.f.PipeLine_Delete(ply)
        else
            zrmine.f.Notify(ply, zrmine.language.Cmd_NoPermission, 1)
        end
    end)


    concommand.Add("zrms_publicents_save", function(ply, cmd, args)
        if zrmine.f.IsAdmin(ply) then
            zrmine.f.PublicEnts_Save(ply)
        else
            zrmine.f.Notify(ply, zrmine.language.Cmd_NoPermission, 1)
        end
    end)
    concommand.Add("zrms_publicents_remove", function(ply, cmd, args)
        if zrmine.f.IsAdmin(ply) then
            zrmine.f.PublicEnts_Remove(ply)
        else
            zrmine.f.Notify(ply, zrmine.language.Cmd_NoPermission, 1)
        end
    end)



    concommand.Add("zrms_npc_save", function(ply, cmd, args)
        if zrmine.f.IsAdmin(ply) then

            zrmine.f.BuyerNPC_Save(ply)
        else
            zrmine.f.Notify(ply, zrmine.language.Cmd_NoPermission, 1)
        end
    end)
    concommand.Add("zrms_npc_remove", function(ply, cmd, args)
        if zrmine.f.IsAdmin(ply) then
            zrmine.f.BuyerNPC_Remove(ply)
        else
            zrmine.f.Notify(ply, zrmine.language.Cmd_NoPermission, 1)
        end
    end)



    concommand.Add("zrms_debug_GetBars", function(ply, cmd, args)
        if zrmine.f.IsAdmin(ply) then
            PrintTable(ply:zrms_GetMetalBars())
        end
    end)

    concommand.Add("zrms_debug_GetSoldBars", function(ply, cmd, args)
        if zrmine.f.IsAdmin(ply) then
            PrintTable(ply:zrms_GetMetalBarsSold())
        end
    end)

    concommand.Add("zrms_debug_AddMetalBar", function(ply, cmd, args)
        if zrmine.f.IsAdmin(ply) then
            ply:zrms_AddMetalBar("Iron", 3)
            ply:zrms_AddMetalBar("Bronze", 3)
            ply:zrms_AddMetalBar("Silver", 3)
            ply:zrms_AddMetalBar("Gold", 3)

            PrintTable(ply:zrms_GetMetalBars())
        end
    end)






    concommand.Add("zrms_debug_SpawnMetalBar", function(ply, cmd, args)
        if zrmine.f.IsAdmin(ply) then
            local tr = ply:GetEyeTrace()
            local m_type = tostring(args[1])
            if tr.Hit and tr.HitPos then
                local ent = ents.Create("zrms_bar")
                ent:SetPos(tr.HitPos)
                ent:SetMetalType(m_type)
                ent:Spawn()
                ent:Activate()
                zrmine.f.SetOwner(ent, ply)
            end
        end
    end)

    concommand.Add("zrms_debug_SpawnResource", function(ply, cmd, args)
        if zrmine.f.IsAdmin(ply) then
            local tr = ply:GetEyeTrace()
            local m_type = tostring(args[1])
            if tr.Hit and tr.HitPos then
                local ent = ents.Create("zrms_resource")
                ent:SetPos(tr.HitPos)
                ent:SetResourceType(m_type)
                ent:SetResourceAmount(25)
                ent:Spawn()
                ent:Activate()
                zrmine.f.SetOwner(ent, ply)
            end
        end
    end)
end
