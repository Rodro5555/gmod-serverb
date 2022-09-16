--[[
 _____           _ _     _   _       ______                          _   _           
| ___ \         | (_)   | | (_)      | ___ \                        | | (_)           // d4a00ae36fee340bad74e663d36354691df5ed4890bbce0316af7cd557812a60
| |_/ /___  __ _| |_ ___| |_ _  ___  | |_/ / __ ___  _ __   ___ _ __| |_ _  ___  ___ 
|    // _ \/ _` | | / __| __| |/ __| |  __/ '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
| |\ \  __/ (_| | | \__ \ |_| | (__  | |  | | | (_) | |_) |  __/ |  | |_| |  __/\__ \
\_| \_\___|\__,_|_|_|___/\__|_|\___| \_|  |_|  \___/| .__/ \___|_|   \__|_|\___||___/                          

]]

local function GetDoorPos( entDoor ) -- Get Door Pos
    local vecDimension = entDoor:OBBMaxs() -entDoor:OBBMins()
    local vecCenter = entDoor:OBBCenter()
    local intMinimum, intKey
    local vecNorm, angRotate, vecPos, intDot
    
    for i = 1, 3 do
        if !intMinimum or vecDimension[ i ] <= intMinimum then
            intKey = i
            intMinimum = vecDimension[ i ]
        end
    end
    vecNorm = Vector()
    vecNorm[ intKey ] = 1
    angRotate = Angle( 0, vecNorm:Angle().y +90, 90 )

    if entDoor:GetClass() == "prop_door_rotating" then
        vecPos = Vector( vecCenter.x, vecCenter.y, 15 ) +angRotate:Up() *( intMinimum /6 )
    else
        vecPos = vecCenter + Vector( 0, 0, 20 ) +angRotate:Up() *( ( intMinimum *.5 ) -0.1 )
    end

    local angRotateNew = entDoor:LocalToWorldAngles( angRotate )
    intDot = angRotateNew:Up():Dot( LocalPlayer():GetShootPos() -entDoor:WorldSpaceCenter() )
    if intDot < 0 then
        angRotate:RotateAroundAxis( angRotate:Right(), 180 )
        vecPos = vecPos -( 2 *vecPos *-angRotate:Up() )
        angRotateNew = entDoor:LocalToWorldAngles( angRotate )
    end
    vecPos = entDoor:LocalToWorld( vecPos )
    return vecPos, angRotateNew
end

hook.Add("Think", "Realistic_Properties:Think", function() -- Hook for the delivery system 
    if not IsValid(RWSEnt) then return end     
    RWSEnt:SetPos(LocalPlayer():GetEyeTrace().HitPos)
    if IsEntity(RWSEnt) then  
        if IsValid(RealisticPropertiesEntGhost) && IsEntity(RealisticPropertiesEntGhost) then
            if LocalPlayer():KeyDown(IN_RELOAD) then 
                net.Start("RealisticProperties:Halos")
                    net.WriteString("closebox")
                    net.WriteEntity(RealisticPropertiesEntGhost)
                net.SendToServer()
                if IsValid(RWSEnt) then RWSEnt:Remove() end 
            end  
            if LocalPlayer():GetPos():DistToSqr(RealisticPropertiesEntGhost:GetPos()) > (Realistic_Properties.DistanceEnt*Realistic_Properties.DistanceEnt) or LocalPlayer():GetEyeTrace().HitPos:DistToSqr(RealisticPropertiesEntGhost:GetPos()) > (Realistic_Properties.DistanceEnt*Realistic_Properties.DistanceEnt) then 
                if IsValid(RWSEnt) then RWSEnt:Remove() end 
                net.Start("RealisticProperties:Halos")
                    net.WriteString("closebox")
                    net.WriteEntity(RealisticPropertiesEntGhost)
                net.SendToServer()
            end
        else 
            if IsValid(RWSEnt) then RWSEnt:Remove() end 
        end 
    else 
        if IsValid(RWSEnt) then RWSEnt:Remove() end 
    end 
end ) 

hook.Add("KeyPress", "Realistic_Properties:KeyPress", function(ply, key) -- Press E to spawn the ent 
	if key == IN_USE then 
        if IsValid(RWSEnt) then 
            RWSEnt:Remove()
            net.Start("RealisticProperties:DeliveryEnt")
            net.SendToServer()
        end 
    end 
end ) 

hook.Add( "PreDrawHalos", "Realistic_Properties:AddPropHalos", function() -- Hook for the halos 
    if istable(RealisticPropertiesTableDoors) then 
        halo.Add( RealisticPropertiesTableDoors, Realistic_Properties.Colors["green150"], 5, 5, 2 )
    end 
    if istable(RealisticPropertiesTableDoorsData) then 
        halo.Add( RealisticPropertiesTableDoorsData, Realistic_Properties.Colors["red"], 5, 5, 2 )
    end 
    if istable( RPSBlackListDoor ) then 
        halo.Add( RPSBlackListDoor, Realistic_Properties.Colors["red"], 5, 5, 2 )
    end 
end )

hook.Add("PostDrawTranslucentRenderables", "Realistic_Properties:DoorHud", function() -- Draw DoorHud 
    if not Realistic_Properties.HudDoor then return end 
	for _, ent in pairs( ents.FindInSphere(LocalPlayer():GetPos(), 500) ) do
        if not IsValid(ent) or not isentity(ent) then return end 
        if ent:GetClass() == "func_door_rotating" or ent:GetClass() == "prop_door_rotating" or ent:GetClass() == "func_door" then 
            if not IsValid(ent) then continue end
            if ent == LocalPlayer() then continue end
            -- if its a realistic properties door
            if string.len(ent:GetNWString("PropertiesName")) > 0 then
                local pos, ang = GetDoorPos(ent)
                local RealisticPropertiesColorAlpha = ColorAlpha( color_white, 200 - LocalPlayer():GetPos():DistToSqr(pos)/200 )
                if LocalPlayer():GetPos():DistToSqr(pos) < 200*200 then 
                    cam.Start3D2D(pos + ang:Up(), ang, 0.03)
                        if isstring(ent:getKeysDoorGroup()) then 
                            draw.SimpleTextOutlined(Realistic_Properties.GetSentence("doorGroop"), "rps_font_10", 0, 140, RealisticPropertiesColorAlpha, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, RealisticPropertiesColorAlpha)
                            draw.SimpleTextOutlined("( "..ent:getKeysDoorGroup().." )", "rps_font_105", 0, 260, RealisticPropertiesColorAlpha, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, RealisticPropertiesColorAlpha)
                        end 
                        if isstring(ent:GetNWString("PropertiesName")) && ent:GetNWString("PropertiesName") != "disable" then 
                            if ent:GetNWString("PropertiesName") != "" then 
                                draw.SimpleTextOutlined(ent:GetNWString("PropertiesName"), "rps_font_9", 20, 140, RealisticPropertiesColorAlpha, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, RealisticPropertiesColorAlpha)
                                if ent:GetNWBool("PropertiesBuy") == true then 
                                    draw.SimpleTextOutlined(Realistic_Properties.GetSentence("purchased"), "rps_font_10", 0, 20, RealisticPropertiesColorAlpha, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, RealisticPropertiesColorAlpha)
                                else
                                    draw.SimpleTextOutlined(Realistic_Properties.GetSentence("forSale"), "rps_font_11", 20, 20, RealisticPropertiesColorAlpha, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, ColorAlpha( color_yellow, 200 - LocalPlayer():GetPos():DistToSqr(pos)/200 ))
                                end 
                            end 
                        end 
                        if not Realistic_Properties.PlayerSeeOwner then 
                            if isstring(ent:GetNWString("PropertiesOwner")) then 
                                if ent:GetNWString("PropertiesOwner") != "" then 
                                    if LocalPlayer():isCP() then 
                                        draw.SimpleTextOutlined("( "..Realistic_Properties.GetSentence("owner").." : "..ent:GetNWString("PropertiesOwner"), "rps_font_105", 0, 260, RealisticPropertiesColorAlpha, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, RealisticPropertiesColorAlpha)
                                    end 
                                end 
                            end 
                        else 
                            if isstring(ent:GetNWString("PropertiesOwner")) then 
                                if ent:GetNWString("PropertiesOwner") != "" then 
                                    draw.SimpleTextOutlined("( "..Realistic_Properties.GetSentence("owner").." : "..ent:GetNWString("PropertiesOwner").." )", "rps_font_105", 0, 260, RealisticPropertiesColorAlpha, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, RealisticPropertiesColorAlpha)
                                end 
                            end
                        end 
                    cam.End3D2D()
                end
            end
        end
    end
end )

local function CheckifdoorHasBool(ent)
    local HaveBool = false 
    if string.len(ent:GetNWString("PropertiesName")) == 0 then 
        HaveBool = false 
    else 
        HaveBool = true 
    end 
    return HaveBool 
end 

hook.Add("HUDDrawDoorData", "Realistic_Properties:HUDDrawDoorData", function(ent) -- Desactivate Base huddoor 
    if not ent:IsVehicle() && CheckifdoorHasBool(ent) then 
        return true
    end  -- 6bfb12fc9f3796b36c9920cb3f7b741b9e5e905d75a063f36ef3797110d91364
end)

hook.Add("ShowTeam", "Realistic_Properties:ShowTeam", function() -- Desactivate F2 menu 
    if Realistic_Properties.OverridingF2 then  
        if not Realistic_Properties.AdminRank[LocalPlayer():GetUserGroup()] then 
            if not Realistic_Properties.CanBuyPropertyWithF2 then 
                return true 
            end 
        end 
    end 
end)
