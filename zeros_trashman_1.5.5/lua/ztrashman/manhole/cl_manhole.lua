if SERVER then return end
ztm = ztm or {}
ztm.Manhole = ztm.Manhole or {}
ztm.Manhole.Stencils = ztm.Manhole.Stencils or {}

function ztm.Manhole.Initialize(Manhole)
	zclib.EntityTracker.Add(Manhole)
	Manhole.Closed = true
	Manhole.LastTrash = -1
	Manhole.RenderStencil = false
	ztm.Manhole.Stencils[Manhole:EntIndex()] = Manhole
end

function ztm.Manhole.Draw(Manhole)
	if zclib.Convar.Get("zclib_cl_drawui") == 1 and zclib.util.InDistance(LocalPlayer():GetPos(), Manhole:GetPos(), 500) and Manhole.Closed == false and Manhole.LastTrash > 0 and ztm.Player.IsTrashman(LocalPlayer()) then
		ztm.HUD.DrawTrash(Manhole.LastTrash,Manhole:GetPos() + Vector(0, 0, 50))
	end
end

function ztm.Manhole.Think(Manhole)
	zclib.util.LoopedSound(Manhole, "ztm_manhole_water", Manhole.Closed == false and Manhole.LastTrash <= 0)

	if zclib.util.InDistance(LocalPlayer():GetPos(), Manhole:GetPos(), 300) then
		if IsValid(Manhole.csModel) then
			Manhole.csModel:SetPos(Manhole:GetPos())
			Manhole.csModel:SetAngles(Manhole:GetAngles())
			local _trash = Manhole:GetTrash()

			if _trash ~= Manhole.LastTrash then
				--Trash got removed so we create effect
				if Manhole.LastTrash > _trash then
					ztm.Effects.Trash(Manhole:GetPos() + Manhole:GetUp() * 5 + Manhole:GetRight() * math.Rand(-15, 15) + Manhole:GetForward() * math.Rand(-15, 15), Manhole)
				end

				Manhole.LastTrash = _trash

				if Manhole.LastTrash > 0 then
					Manhole.csModel:SetBodygroup(0, 1)
				else
					Manhole.csModel:SetBodygroup(0, 0)
				end
			end
		end
	else
		Manhole.LastTrash = -1
	end

	if zclib.util.InDistance(LocalPlayer():GetPos(), Manhole:GetPos(), 800) then
		local closed = Manhole:GetIsClosed()

		if Manhole.Closed ~= closed then
			Manhole.Closed = closed

			if Manhole.Closed then
				Manhole:EmitSound("ztm_manhole_close")
				zclib.Animation.Play(Manhole, "close", 1)

				timer.Simple(0.9, function()
					if IsValid(Manhole) then
						Manhole.RenderStencil = false
					end
				end)
			else
				Manhole:EmitSound("ztm_manhole_open")
				Manhole.RenderStencil = true
				zclib.Animation.Play(Manhole, "open", 1)
			end
		end
	end
end

function ztm.Manhole.OnRemove(Manhole)
	Manhole:StopSound("ztm_manhole_water")

	if IsValid(Manhole.csModel) then
		Manhole.csModel:Remove()
	end
end

zclib.Hook.Add("PostDrawTranslucentRenderables", "ztm_manhole", function(depth, skybox, isDraw3DSkybox)
	if isDraw3DSkybox == false then
		for k, s in pairs(ztm.Manhole.Stencils) do
			if not IsValid(s) then continue end
			if not zclib.util.InDistance(LocalPlayer():GetPos(), s:GetPos(), 400) then continue end
			if (s.RenderStencil == false) then continue end
			render.ClearStencil()
			render.SetStencilEnable(true)
			render.SetStencilWriteMask(255)
			render.SetStencilTestMask(255)
			render.SetStencilReferenceValue(57)
			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
			render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
			render.SetStencilFailOperation(STENCIL_ZERO)
			render.SetStencilZFailOperation(STENCIL_ZERO)


			cam.Start3D2D(s:GetPos(), s:GetAngles(), 0.5)
				surface.SetDrawColor(ztm.default_colors["black02"])
				draw.NoTexture()
				zclib.util.DrawCircle(0, 0, 41, 20)
			cam.End3D2D()

			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
			render.SuppressEngineLighting(false)
			render.DepthRange(0, 0.6)

			if IsValid(s.csModel) then
				s.csModel:DrawModel()
			else
				s.csModel = zclib.ClientModel.Add("models/zerochain/props_trashman/ztm_manhole_stencil.mdl")
				s.csModel:SetPos(s:GetPos())
				s.csModel:SetAngles(s:GetAngles())
				s.csModel:SetParent(s)
				s.csModel:SetNoDraw(true)
			end

			render.SuppressEngineLighting(false)
			render.SetStencilEnable(false)
			render.DepthRange(0, 1)
		end
	end
end)
