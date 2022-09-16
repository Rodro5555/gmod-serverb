if not CLIENT then return end
zmlab2 = zmlab2 or {}
zmlab2.Tent = zmlab2.Tent or {}


zmlab2.Tent.Materials = zmlab2.Tent.Materials or {}

// Creates / returns a tent material which matches the specified parameters
function zmlab2.Tent.GetMaterial(TentID,ColorID)

    local mat_name = "zmlab2_material_tent_" .. TentID .. "_" .. ColorID

    if zmlab2.Tent.Materials[mat_name] then
        return mat_name
    end

    local TentData = zmlab2.config.Tent[TentID]
    local col_vec = zclib.util.ColorToVector(zmlab2.Tent_LightColors[ColorID])

    local params = {

        ["$blendtintbybasealpha"] = 1,

        ["$basetexture"] = TentData.tex_diff,
        ["$bumpMap"] = TentData.tex_nrm,
        ["$normalmapalphaenvmapmask"] = 1,

        ["$surfaceprop"] = "metal",
        ["$halflambert"] = 1,
        ["$model"] = 1,

        ["$envmap"] = "env_cubemap",
        ["$envmaptint"] = col_vec,
        ["$envmapfresnel"] = 1,

        ["$phong"] = 1,
        ["$phongexponent"] = 5,
        ["$phongfresnelranges"] = Vector(1, 1, 1),
        ["$phongtint"] = col_vec,
        ["$phongboost"] = 1,

        ["$rimlight"] = 1,
        ["$rimlightexponent"] = 25,
        ["$rimlightboost"] = 0.1,

        ["$emissiveBlendEnabled"] = 1,
        ["$emissiveBlendTexture"] = "zerochain/props_methlab/tent/null",
        ["$emissiveBlendBaseTexture"] = TentData.tex_em,
        ["$emissiveBlendFlowTexture"] = "zerochain/props_methlab/tent/null",
        ["$emissiveBlendTint"] = col_vec,
        ["$emissiveBlendStrength"] = 2,
        ["$emissiveBlendScrollVector"] = Vector(0,0),
    }

    local mat = CreateMaterial(mat_name, "VertexLitGeneric", params)

    mat:SetVector("$emissiveBlendTint",col_vec)
    mat:SetFloat("$emissiveBlendStrength",2)

    zmlab2.Tent.Materials[mat_name] = mat

    return mat_name
end


// Informs all near clients that the tent type changed so rebuild the client model
net.Receive("zmlab2_Tent_ChangeType", function(len,ply)
    zclib.Debug_Net("zmlab2_Tent_ChangeType",len)

    local Tent = net.ReadEntity()
    if not IsValid(Tent) then return end

    if IsValid(Tent.PreviewModel) then
        zmlab2.Tent.RemoveClientModel(Tent)
    end
end)

function zmlab2.Tent.Initialize(Tent) end

function zmlab2.Tent.OnThink(Tent)

    local i_state = Tent:GetBuildState()

    zclib.util.LoopedSound(Tent, "zmlab2_tent_construction_loop", i_state == 1)

    // Here we create the build preview model
    if zclib.util.InDistance(LocalPlayer():GetPos(), Tent:GetPos(), 1500) and i_state > -1 and i_state < 2 then
        if not IsValid(Tent.PreviewModel) then
            zmlab2.Tent.CreateClientModel(Tent)
        end
    else
        zmlab2.Tent.RemoveClientModel(Tent)
    end
end

function zmlab2.Tent.UpdateLightMaterial(Tent)
    zclib.Debug("zmlab2.Tent.UpdateLightMaterial")

    local TentMat = zmlab2.Tent.GetMaterial(Tent:GetTentID(),Tent:GetColorID())
    local TentData = zmlab2.config.Tent[Tent:GetTentID()]

    Tent:SetSubMaterial(TentData.mat_id, "!" .. TentMat)

    //zmlab2.Tent.Materials["!" .. TentMat]:SetFloat("$emissiveBlendStrength",1)
end

function zmlab2.Tent.OnRemove(Tent)
    zmlab2.Tent.RemoveClientModel(Tent)
    Tent:StopSound("zmlab2_tent_construction_loop")
end

function zmlab2.Tent.RemoveClientModel(Tent)
    if IsValid(Tent.PreviewModel) then
        zclib.ClientModel.Remove(Tent.PreviewModel)
        zclib.Debug("zmlab2.Tent.RemoveClientModel")
        Tent.PreviewModel = nil
    end
end

function zmlab2.Tent.CreateClientModel(Tent)

    local TentData = zmlab2.config.Tent[Tent:GetTentID()]
    if TentData == nil then return end

    local ent = zclib.ClientModel.AddProp()
    if not IsValid(ent) then return end
    ent:SetModel(TentData.model)
    ent:SetAngles(Tent:LocalToWorldAngles(angle_zero))
    ent:SetPos(Tent:LocalToWorld(vector_origin))
    ent:Spawn()

    ent:SetParent(Tent)
    ent:SetRenderMode(RENDERMODE_TRANSCOLOR)
    ent:SetMaterial("zerochain/zmlab2/shader/zmlab2_highlight")

    Tent.PreviewModel = ent
    zclib.Debug("zmlab2.Tent.CreateClientModel")
end

function zmlab2.Tent.DrawButton(icon,x,hovered,wipe)
    if wipe >= 1 then
        zclib.util.DrawOutlinedBox(x-45, -45, 90, 90, 2, color_white)

        surface.SetDrawColor(color_white)
        surface.SetMaterial(zclib.Materials.Get(icon))
        surface.DrawTexturedRectRotated(x,0, 80, 80, 0)

        if hovered then
            draw.RoundedBox(0, x-45, -45, 90, 90, zmlab2.colors["white02"])
        end
    else

        zclib.util.DrawOutlinedBox(x-45, -45, 90, 90, 2, zclib.colors["black_a100"])

        surface.SetDrawColor(zclib.colors["black_a100"])
        surface.SetMaterial(zclib.Materials.Get(icon))
        surface.DrawTexturedRectRotated(x,0, 80, 80, 0)

        surface.SetDrawColor(color_white)
        surface.SetMaterial(zclib.Materials.Get(icon))
    	// Draws right half of the texture
    	// Note that we also change the width of the rectangle to avoid stetcing of the texture
    	// This is for demonstration purposes, you can do whatever it is you need
    	surface.DrawTexturedRectUV( x-40, -40, 80, 80 * wipe, 0, 0, 1, wipe )
    end
end

function zmlab2.Tent.DrawControllPanel(Tent)
    local attach = Tent:GetAttachment(1)
    if attach == nil then return end

    cam.Start3D2D(attach.Pos, attach.Ang, 0.05)
        //draw.RoundedBox(0, -77.5, -60, 155, 120, color_black)

        surface.SetDrawColor(zmlab2.colors["blue02"] )
        surface.SetMaterial(zclib.Materials.Get("item_bg"))
        surface.DrawTexturedRectRotated(0, 0, 320, 250, 0)

        zmlab2.Tent.DrawButton("icon_light",-100,Tent:OnLightButton(LocalPlayer()),1)
        zmlab2.Tent.DrawButton("icon_fire_extinguisher",0,Tent:OnExtinquisher(LocalPlayer()),zmlab2.Tent.GetNextExtinguish(Tent))

        if Tent:GetIsPublic() == false then
            zmlab2.Tent.DrawButton("icon_fold",100,Tent:OnFoldButton(LocalPlayer()),1)
        end

        // Draws the cursor if its inside the screen
        local cx,cy = zmlab2.Interface.GetCursorPos(attach.Pos, attach.Ang)
        if cx and cy and math.abs(cx) < 300 and math.abs(cy) < 300  then
            draw.RoundedBox(4, cx - 4, cy - 4, 8, 8, color_white)
        end

        surface.SetDrawColor(zclib.colors["black_a100"])
        surface.SetMaterial(zclib.Materials.Get("scanlines"))
        surface.DrawTexturedRectRotated(0, 0, 320, 250, 0)
    cam.End3D2D()
end

function zmlab2.Tent.DrawDynamicLight(Tent)
    if zclib.Convar.Get("zmlab2_cl_vfx_dynamiclight") == 0 then return end
    local col = zmlab2.Tent_LightColors[Tent.CurColID]

    // Dont even create a DynamicLight if we have black as a color
    if (col.r + col.g + col.b) <= 0 then return end
    local TentData = zmlab2.config.Tent[Tent:GetTentID()]

    local dlight = DynamicLight(Tent:EntIndex())
    if (dlight) then
        dlight.pos = Tent:LocalToWorld( TentData.light.pos)
        dlight.r = col.r
        dlight.g = col.g
        dlight.b = col.b
        dlight.brightness = TentData.light.brightness
        dlight.style = 0
        dlight.Decay = 1000
        dlight.Size = TentData.light.size
        dlight.DieTime = CurTime() + 1
    end
end

function zmlab2.Tent.Draw(Tent)
    if zclib.util.InDistance(Tent:GetPos(), LocalPlayer():GetPos(), 1500) and IsValid(Tent.PreviewModel) then

        Tent.PreviewModel:SetPos(Tent:GetPos())
        Tent.PreviewModel:SetAngles(Tent:GetAngles())

        if Tent:GetBuildState() == 0 then
            Tent.PreviewModel:SetNoDraw(false)
            Tent.PreviewModel:SetMaterial("zerochain/zmlab2/shader/zmlab2_highlight")

            if zmlab2.Tent.Builder_HasSpace(Tent) then
                Tent.PreviewModel:SetColor(zmlab2.colors["green01"])
            else
                Tent.PreviewModel:SetColor(zmlab2.colors["red01"])
            end
        else
            zmlab2.Tent.DrawConstruction(Tent)
        end
    end

    if Tent:GetBuildState() ~= Tent.CurBuildState then
        Tent.CurBuildState = Tent:GetBuildState()
        // Clear the color id so it rebuilds the material once the tent got build again
        if Tent.CurBuildState ~= 2 and Tent.CurColID then

            // Reset all materials
            Tent:SetSubMaterial()
            Tent.CurColID = nil
        end
    end

    if zclib.util.InDistance(Tent:GetPos(), LocalPlayer():GetPos(), 300) and Tent:GetBuildState() >= 2 then

        if zclib.Convar.Get("zmlab2_cl_drawui") == 1 then zmlab2.Tent.DrawControllPanel(Tent) end

        if Tent:GetColorID() ~= Tent.CurColID then
            Tent.CurColID = Tent:GetColorID()
            zmlab2.Tent.UpdateLightMaterial(Tent)
        end

        // Update the material once it gets drawn
        if Tent.LastDraw and CurTime() > (Tent.LastDraw + 0.1) then
            zmlab2.Tent.UpdateLightMaterial(Tent)
        end

        Tent.LastDraw = CurTime()

        zmlab2.Tent.DrawDynamicLight(Tent)
    end
end

function zmlab2.Tent.DrawConstruction(Tent)
    local FinishTime = Tent:GetBuildCompletion()

    if Tent.BuildTime == nil then
        Tent.BuildTime = FinishTime - CurTime()
    end

    Tent.PreviewModel:SetNoDraw(true)
    Tent.PreviewModel:SetMaterial(nil)
    Tent.PreviewModel:SetColor(color_white)

    local fract = math.Clamp(FinishTime - CurTime(),0,Tent.BuildTime)
    fract = Tent.BuildTime - fract

    // Draw the spawning effect
    local delta = (1 / Tent.BuildTime) * fract
    math.Clamp(delta, 0, 1)

    render.EnableClipping(true)

        local min, max = Tent.PreviewModel:OBBMins(), Tent.PreviewModel:OBBMaxs()
        min, max = Tent.PreviewModel:LocalToWorld(min), Tent.PreviewModel:LocalToWorld(max)

        // The clipping plane only draws objects that face the plane
        local normal = -Tent.PreviewModel:GetUp()
        local cutPosition = LerpVector(delta, min, max) // Where it cuts
        local cutDistance = normal:Dot(cutPosition) // Project the vector onto the normal to get the shortest distance between the plane and origin

        // Activate the plane
        render.PushCustomClipPlane(normal, cutDistance)

        // Draw the partial model
        Tent.PreviewModel:DrawModel()

        // Remove the plane
        render.PopCustomClipPlane()
    render.EnableClipping(false)

    render.MaterialOverride(zclib.Materials.Get("highlight"))
    if zmlab2.Tent.Builder_IsAreaFree(Tent) then
        render.SetColorModulation(0.278, 0.819, 0.207)
    else
        render.SetColorModulation(0.819, 0.207, 0.207)
    end
    Tent.PreviewModel:DrawModel()
    render.MaterialOverride()
    render.SetColorModulation(1, 1, 1)
end
