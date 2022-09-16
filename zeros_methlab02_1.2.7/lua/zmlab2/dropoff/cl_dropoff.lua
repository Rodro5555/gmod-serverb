if not CLIENT then return end
zmlab2 = zmlab2 or {}
zmlab2.Dropoff = zmlab2.Dropoff or {}
zmlab2.Dropoff.Stencils = zmlab2.Dropoff.Stencils or {}

function zmlab2.Dropoff.Initialize(Dropoff)
    Dropoff.IsClosed = true
    Dropoff.RenderStencil = false
    Dropoff.SmoothAnim = 0
    zmlab2.Dropoff.Stencils[Dropoff:EntIndex()] = Dropoff
end

function zmlab2.Dropoff.Draw(Dropoff)
    Dropoff:DrawModel()
end

function zmlab2.Dropoff.OnRemove(Dropoff)
    if IsValid(Dropoff.csModel) then Dropoff.csModel:Remove() end
end

function zmlab2.Dropoff.Think(Dropoff)

    if Dropoff.IsClosed ~= Dropoff:GetIsClosed() then
        Dropoff.IsClosed = Dropoff:GetIsClosed()

        if Dropoff.IsClosed == true then
            zclib.Animation.Play(Dropoff, "close", 1)
            Dropoff:EmitSound("zmlab2_dropoff_door")
            timer.Simple(1, function()
                if not IsValid(Dropoff) then return end
                Dropoff.RenderStencil = false
            end)
        else
            Dropoff.RenderStencil = true
            zclib.Animation.Play(Dropoff, "open", 1)
            Dropoff:EmitSound("zmlab2_dropoff_door")
        end
    end

    if IsValid(Dropoff.csModel) then
        Dropoff.csModel:SetPos(Dropoff:GetPos())
        Dropoff.csModel:SetAngles(Dropoff:GetAngles())
    else
        Dropoff.csModel = zclib.ClientModel.Add("models/zerochain/props_methlab/zmlab2_dropoff_shaft.mdl",RENDERGROUP_OTHER)
        if IsValid(Dropoff.csModel) then
            Dropoff.csModel:SetPos(Dropoff:GetPos())
            Dropoff.csModel:SetAngles(Dropoff:GetAngles())
            Dropoff.csModel:SetParent(Dropoff)
            Dropoff.csModel:SetNoDraw(true)
        end
    end
end

zclib.Hook.Add("PreDrawTranslucentRenderables", "zmlab2_DropOff", function(depth, skybox)
    if zmlab2 and zmlab2.Dropoff and zmlab2.Dropoff.Stencils then
    	for k, s in pairs(zmlab2.Dropoff.Stencils) do
    		if not IsValid(s) then continue end
    		if (s.RenderStencil == false) then continue end

            -- Reset everything to known good
        	render.SetStencilWriteMask( 0xFF )
        	render.SetStencilTestMask( 0xFF )
        	render.SetStencilReferenceValue( 0 )
        	render.SetStencilCompareFunction( STENCIL_ALWAYS )
        	render.SetStencilPassOperation( STENCIL_KEEP )
        	render.SetStencilFailOperation( STENCIL_KEEP )
        	render.SetStencilZFailOperation( STENCIL_KEEP )
        	render.ClearStencil()

    		render.SetStencilEnable(true)
    		render.SetStencilWriteMask(255)
    		render.SetStencilTestMask(255)
    		render.SetStencilReferenceValue(57)
    		render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
    		render.SetStencilPassOperation(STENCIL_REPLACE)
    		render.SetStencilFailOperation(STENCIL_ZERO)
    		render.SetStencilZFailOperation(STENCIL_KEEP)


            cam.Start3D2D(s:GetPos() + s:GetUp() * 1, s:GetAngles(), 0.5)
    			draw.RoundedBox(0, -75, -100, 150, 200, color_black)
    		cam.End3D2D()

    		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)

    		//render.SuppressEngineLighting(true)
    		render.DepthRange(0, 0.7)

    		if IsValid(s.csModel) then
    			s.csModel:DrawModel()
                if s.IsClosed then
                    s.SmoothAnim = Lerp(1 * FrameTime(),s.SmoothAnim,0)
                    s.csModel:SetPoseParameter("zmlab2_mover",s.SmoothAnim)
                else
                    s.SmoothAnim = Lerp(1 * FrameTime(),s.SmoothAnim,1)
                    s.csModel:SetPoseParameter("zmlab2_mover",s.SmoothAnim)
                end
    		end

    		//render.SuppressEngineLighting(false)
    		render.SetStencilEnable(false)
    		render.DepthRange(0, 1)
    	end
    end
end)


//zmlab2.Dropoff.Indicator = nil
local function AddHint(pos)
    zmlab2.Dropoff.Indicator = {
        pos = pos,
        created = CurTime()
    }

    zclib.Hook.Remove("HUDPaint", "zmlab2_Indicator")
    zclib.Hook.Add("HUDPaint", "zmlab2_Indicator", zmlab2.Dropoff.DrawIndicator)
end
net.Receive("zmlab2_DropOff_AddHint", function()
    local pos = net.ReadVector()
    if pos == nil then return end
    AddHint(pos)
end)

net.Receive("zmlab2_DropOff_RemoveHint", function()
    zclib.Hook.Remove("HUDPaint", "zmlab2_Indicator")
    zmlab2.Dropoff.Indicator = nil
end)

local function DrawBox(x,y,w,h,txt)
    draw.RoundedBox(0, x - (w / 2), y - (h / 2), w, h, zclib.colors["black_a100"])
    draw.SimpleText(txt, zclib.GetFont("zmlab2_font00"), x, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    zclib.util.DrawOutlinedBox(x - (w / 2), y - (h / 2), w, h, 2, color_white)
end

function zmlab2.Dropoff.DrawIndicator()
    local ply = LocalPlayer()

    if IsValid(ply) and ply:Alive() and zmlab2.Dropoff and zmlab2.Dropoff.Indicator and zmlab2.Dropoff.Indicator.pos and zmlab2.Dropoff.Indicator.created then

        if CurTime() >= (zmlab2.Dropoff.Indicator.created + zmlab2.config.DropOffPoint.DeliverTime) then
            zmlab2.Dropoff.Indicator = nil
            zclib.Hook.Remove("HUDPaint", "zmlab2_Indicator")
            return
        end

        if zclib.util.InDistance(ply:GetPos(), zmlab2.Dropoff.Indicator.pos, 100) then return end

        local pos = zmlab2.Dropoff.Indicator.pos:ToScreen()

        if zmlab2.config.DropOffPoint.Draw_Time then
            local time = math.Round((zmlab2.Dropoff.Indicator.created + zmlab2.config.DropOffPoint.DeliverTime) - CurTime())
            DrawBox(pos.x, pos.y + 60,140,30,string.FormattedTime(time, "%02i:%02i"))
        end

        if zmlab2.config.DropOffPoint.Draw_Icon then
            surface.SetDrawColor(color_white )
            surface.SetMaterial(zclib.Materials.Get("icon_meth"))
            surface.DrawTexturedRectRotated(pos.x, pos.y, 100, 100, 0 )
        end
    end
end
